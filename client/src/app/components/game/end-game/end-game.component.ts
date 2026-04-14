import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { GlobalStats } from '@app/classes/stats/global-stats';
import { PlayerStats } from '@app/classes/stats/player-stats';
import { AVATAR_TYPES } from '@app/constants/player.constants';
import { SocketService } from '@app/services/communication/socket-handlers/socket.service';
import { GameManagerService } from '@app/services/state/game-manager.service';
import { TranslateModule, TranslateService } from '@ngx-translate/core';

const ONE_HUNDRED = 100;

export interface PlayerReward {
    playerName: string;
    coinsEarned: number;
    avatarImage: string | null;
}

@Component({
    imports: [CommonModule, TranslateModule],
    selector: 'app-end-game',
    templateUrl: './end-game.component.html',
    styleUrl: './end-game.component.scss',
})
export class EndGameComponent {
    isAscending: boolean = false;
    sortedProperty: keyof PlayerStats;
    playersStats: PlayerStats[] = [];
    globalStats: GlobalStats = new GlobalStats();
    walkableTiles: number = 0;
    toggableDoors: number = 0;
    hasWon: boolean = false;

    constructor(
        private router: Router,
        private socketService: SocketService,
        private gameManagerService: GameManagerService,
        private translate: TranslateService,
    ) {
        this.hasWon = this.gameManagerService.hasWon();
        this.socketService.on(
            'getStatisticsResponse',
            (data: { playerStats: PlayerStats[]; globalStats: GlobalStats; walkableTiles: number; toggableDoors: number }) => {
                this.playersStats = data.playerStats;
                this.globalStats = data.globalStats;
                this.walkableTiles = data.walkableTiles;
                this.toggableDoors = data.toggableDoors;
            },
        );
        this.socketService.send('getStatistics', this.socketService.getRoomId());
        this.sortBy('name');
    }

    get playerRewards(): PlayerReward[] {
        const data = this.gameManagerService.gameRewards;
        if (!data) return [];
        return data.rewards.map((r) => ({
            playerName: r.name,
            coinsEarned: r.gain,
            avatarImage: r.avatarName ? AVATAR_TYPES[r.avatarName.toLowerCase()]?.avatar ?? null : null,
        }));
    }

    get playersHadFlag(): number {
        return this.playersStats.filter((player) => player.itemsCollected.find((item) => item === 'flag')).length;
    }

    get tileExploredPercentage(): number {
        const seen = new Set<string>();

        for (const player of this.playersStats) {
            for (const tile of player.tilesVisited) {
                seen.add(`${tile.x},${tile.y}`);
            }
        }
        return Math.floor(this.walkableTiles > 0 ? (seen.size / this.walkableTiles) * ONE_HUNDRED : 0);
    }

    get doorsToggledPercentage(): number {
        return Math.floor(this.toggableDoors > 0 ? (this.globalStats.doorsToggled.length / this.toggableDoors) * ONE_HUNDRED : 0);
    }

    getPlayersTilePercentage(playerName: string): number {
        const player = this.playersStats.find((playerStat) => playerStat.name === playerName);
        if (!player) {
            return 0;
        }
        return Math.floor(this.walkableTiles > 0 ? (player.tilesVisited.length / this.walkableTiles) * ONE_HUNDRED : 0);
    }

    sortBy(property: keyof PlayerStats): void {
        this.playersStats.sort((a, b) => {
            let aValue: string | number;
            let bValue: string | number;

            if (property === 'itemsCollected') {
                aValue = a.itemsCollected.length;
                bValue = b.itemsCollected.length;
            } else if (property === 'tilesVisited') {
                aValue = a.tilesVisited.length;
                bValue = b.tilesVisited.length;
            } else {
                aValue = a[property] as string | number;
                bValue = b[property] as string | number;
            }

            if (aValue < bValue) {
                return this.isAscending ? -1 : 1;
            } else if (aValue > bValue) {
                return this.isAscending ? 1 : -1;
            } else {
                return 0;
            }
        });
        this.sortedProperty = property;
        this.isAscending = !this.isAscending;
    }

    quitGame(): void {
        this.socketService.quitEndGame();
        this.router.navigate(['/home']);
    }

    get currentPlayerStats(): PlayerStats | undefined {
        const name = this.gameManagerService.mainPlayer?.name;
        if (!name) return undefined;
        return this.playersStats.find((p) => p.name === name);
    }

    get currentPlayerCombatWinPercentage(): number {
        const stats = this.currentPlayerStats;
        if (!stats || stats.combats === 0) return 0;
        return Math.floor((stats.victories / stats.combats) * ONE_HUNDRED);
    }

    get currentPlayerDefeats(): number {
        return this.currentPlayerStats?.defeats ?? 0;
    }

    get currentPlayerTilePercentage(): number {
        const name = this.gameManagerService.mainPlayer?.name;
        if (!name) return 0;
        return this.getPlayersTilePercentage(name);
    }

    shareOnX(): void {
        const text = this.buildShareText();
        const url = `https://x.com/intent/tweet?text=${encodeURIComponent(text)}`;
        window.open(url, '_blank', 'noopener,noreferrer');
    }

    shareOnWhatsApp(): void {
        const url = `https://wa.me/?text=${encodeURIComponent(this.buildShareText())}`;
        window.open(url, '_blank', 'noopener,noreferrer');
    }

    private buildShareText(): string {
        const resultKey = this.hasWon ? 'end_game.share.victory' : 'end_game.share.defeat';
        const result = this.translate.instant(resultKey);
        const deaths = this.currentPlayerDefeats;
        const combatPct = this.currentPlayerCombatWinPercentage;
        const tilePct = this.currentPlayerTilePercentage;

        return this.translate.instant('end_game.share.text', {
            result,
            deaths,
            combatPct,
            tilePct,
        });
    }
}

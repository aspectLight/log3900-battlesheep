import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { GlobalStats } from '@app/classes/stats/global-stats';
import { PlayerStats } from '@app/classes/stats/player-stats';
import { SocketService } from '@app/services/communication/socket-handlers/socket.service';

const ONE_HUNDRED = 100;

@Component({
    imports: [CommonModule],
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

    constructor(
        private router: Router,
        private socketService: SocketService,
    ) {
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
}

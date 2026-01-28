import { NgStyle } from '@angular/common';
import { Component } from '@angular/core';
import { PlayerCard } from '@app/interfaces/character.interface';
import { GameManagerService } from '@app/services/state/game-manager.service';

@Component({
    selector: 'app-actions-hud',
    imports: [NgStyle],
    templateUrl: './actions-hud.component.html',
    styleUrl: './actions-hud.component.scss',
})
export class ActionsHudComponent {
    constructor(private gameManager: GameManagerService) {}

    get playerCardList(): PlayerCard[] {
        const activePlayers = this.gameManager.getPlayers();
        const disconnectedPlayers = this.gameManager.disconnectedPlayer;
        const allPlayers = [
            ...activePlayers.map((player) => ({
                player,
                isActive: this.gameManager.currentPlayerId === player.id,
                isHost: this.gameManager.room.hostId === player.id,
                playerColor: player.color,
                isDisconnected: false,
                playerTeam: player.team ? player.team : null,
                hasFlag: this.gameManager.playerWithFlag === player.id,
            })),
            ...disconnectedPlayers.map((player) => ({
                player,
                isActive: false,
                isHost: false,
                playerColor: player.color,
                isDisconnected: true,
                playerTeam: player.team ? player.team : null,
            })),
        ];

        return allPlayers;
    }

    toggleCard(index: number) {
        this.playerCardList.forEach((card) => {
            card.isActive = false;
        });

        this.playerCardList[index].isActive = true;
    }
}

import { NgStyle } from '@angular/common';
import { Component } from '@angular/core';
import { GameManagerService } from '@app/services/game-manager.service';
import { PlayerCard } from '@app/interfaces/character';
import { Player } from '@app/classes/player';

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
                isHost: this.gameManager.room.organisatorId === player.id,
                playerColor: player.color,
                isDisconnected: false,
            })),
            ...disconnectedPlayers.map((player) => ({
                player,
                isActive: false,
                isHost: false,
                playerColor: player.color,
                isDisconnected: true,
            })),
        ];

        return allPlayers;
    }

    get players() {
        return this.gameManager.getPlayers();
    }

    toggleCard(index: number) {
        this.playerCardList.forEach((card) => {
            card.isActive = false;
        });

        this.playerCardList[index].isActive = true;
    }

    hoverCard(index: number) {
        if (!this.playerCardList[index].isActive) {
            this.playerCardList[index].isActive = true;
        }
    }

    unhoverCard(index: number) {
        if (this.playerCardList[index].isActive) {
            this.playerCardList[index].isActive = false;
        }
    }

    findPlayerIndex(player: Player): number {
        return this.playerCardList.findIndex((card) => card.player.id === player.id);
    }
}

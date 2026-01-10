import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ItemCardComponent } from '@app/components/item-card/item-card.component';
import { Item } from '@app/classes/item';
import { Player } from '@app/classes/player';
import { GameManagerService } from '@app/services/game-manager.service';

@Component({
    selector: 'app-player-hud',
    imports: [CommonModule, ItemCardComponent],
    templateUrl: './player-hud.component.html',
    styleUrl: './player-hud.component.scss',
})
export class PlayerHudComponent {
    private expandedCards: { [key: number]: boolean } = {};

    constructor(private gameManager: GameManagerService) {}

    get player(): Player | null {
        return this.gameManager.getMainPlayer();
    }

    get cards() {
        return (
            this.player?.inventory
                .filter((item) => item !== null)
                .map((item, index) => ({
                    item: item as Item,
                    isExpanded: this.expandedCards[index] || false,
                })) || []
        );
    }

    get defensePoints() {
        if (!this.player) return [];
        return Array.from({ length: this.player.stats['defense'].value }, (_, i) => i);
    }

    get attackPoints() {
        if (!this.player) return [];
        return Array.from({ length: this.player.stats['attack'].value }, (_, i) => i);
    }

    get speedPoints() {
        if (!this.player) return [];
        return Array.from({ length: this.player.stats['speed'].value }, (_, i) => i);
    }

    get healthPoints() {
        if (!this.player) return [];
        return Array.from({ length: this.player.stats['health'].value }, (_, i) => i);
    }

    get movementPoints() {
        return this.player?.movementPoints;
    }

    get actionPoints() {
        return this.player?.actionPoints;
    }

    getDice(stat: string) {
        return this.player?.d6Choice === stat ? './assets/items/D6.png' : './assets/items/D4.png';
    }

    toggleCard(index: number) {
        this.expandedCards[index] = !this.expandedCards[index];
    }

    hoverCard(index: number) {
        if (!this.expandedCards[index]) {
            this.expandedCards[index] = true;
        }
    }

    unhoverCard(index: number) {
        if (this.expandedCards[index]) {
            this.expandedCards[index] = false;
        }
    }
}

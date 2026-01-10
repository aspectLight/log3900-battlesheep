import { Component } from '@angular/core';
import { Item } from '@app/classes/item';
import { Player } from '@app/classes/player';
import { ItemCard } from '@app/interfaces/character';
import { GameManagerService } from '@app/services/game-manager.service';

@Component({
    selector: 'app-player-hud',
    imports: [],
    templateUrl: './player-hud.component.html',
    styleUrl: './player-hud.component.scss',
})
export class PlayerHudComponent {
    cards: ItemCard[] = [
        { item: new Item('barbedWire'), isExpanded: false },
        { item: new Item('propaganda'), isExpanded: false },
    ];

    healthCount: number;
    defCount: number;
    speedCount: number;

    constructor(private gameManager: GameManagerService) {}

    get player(): Player | undefined {
        return this.gameManager.getMainPlayer();
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
        this.cards[index].isExpanded = !this.cards[index].isExpanded;
    }

    hoverCard(index: number) {
        if (!this.cards[index].isExpanded) {
            this.cards[index].isExpanded = true;
        }
    }

    unhoverCard(index: number) {
        if (this.cards[index].isExpanded) {
            this.cards[index].isExpanded = false;
        }
    }
}

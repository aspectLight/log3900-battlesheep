import { Component, Input } from '@angular/core';
import { Player } from '@app/classes/player';

@Component({
    selector: 'app-player',
    imports: [],
    templateUrl: './player.component.html',
    styleUrl: './player.component.scss',
})
export class PlayerComponent {
    @Input() player!: Player;

    getSpritePath(): string {
        const base = 'assets/characters';
        const color = this.player.color;
        const state = this.player.animationState;
        const orientation = this.player.orientation;
        return `${base}/${color}/${state}_${orientation}.gif`;
    }
}

import { Component } from '@angular/core';
import { EndGameComponent } from '@app/components/end-game/end-game.component';

@Component({
    imports: [EndGameComponent],
    selector: 'app-end-game-page',
    templateUrl: './end-game-page.component.html',
    styleUrl: './end-game-page.component.scss',
})
export class EndGamePageComponent {}

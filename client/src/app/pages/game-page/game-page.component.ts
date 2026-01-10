import { Component } from '@angular/core';
import { GamePlayComponent } from '@app/components/game-play/game-play.component';

@Component({
    selector: 'app-game-page',
    templateUrl: './game-page.component.html',
    styleUrls: ['./game-page.component.scss'],
    imports: [GamePlayComponent],
})
export class GamePageComponent {}

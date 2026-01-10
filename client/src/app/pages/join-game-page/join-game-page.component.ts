import { Component } from '@angular/core';
import { GameJoinerComponent } from '@app/components/game-joiner/game-joiner.component';

@Component({
    selector: 'app-join-game-page',
    imports: [GameJoinerComponent],
    templateUrl: './join-game-page.component.html',
    styleUrls: ['./join-game-page.component.scss'],
})
export class JoinGamePageComponent {}

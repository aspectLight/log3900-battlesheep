import { Component } from '@angular/core';
import { GameCreatorComponent } from '@app/components/editor/game-creator/game-creator.component';

@Component({
    imports: [GameCreatorComponent],
    selector: 'app-create-game-page',
    templateUrl: './create-game-page.component.html',
    styleUrls: ['./create-game-page.component.scss'],
})
export class CreateGamePageComponent {}

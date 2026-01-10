import { Component } from '@angular/core';
import { GameEditorComponent } from '@app/components/game-editor/game-editor.component';
import { RouterLink } from '@angular/router';

@Component({
    selector: 'app-edit-game-page',
    imports: [GameEditorComponent, RouterLink],
    templateUrl: './edit-game-page.component.html',
    styleUrl: './edit-game-page.component.scss',
})
export class EditGamePageComponent {}

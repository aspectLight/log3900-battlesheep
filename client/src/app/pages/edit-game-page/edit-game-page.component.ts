import { Component } from '@angular/core';
import { GameEditorComponent } from '@app/components/game-editor/game-editor.component';
import { Router } from '@angular/router';
import { PopUpComponent } from '@app/components/pop-up/pop-up.component';
import { WARNING_MESSAGES } from '@common/error-messages.constants';

@Component({
    selector: 'app-edit-game-page',
    imports: [GameEditorComponent, PopUpComponent],
    templateUrl: './edit-game-page.component.html',
    styleUrl: './edit-game-page.component.scss',
})
export class EditGamePageComponent {
    showConfirmation: boolean = false;
    quitMessage = WARNING_MESSAGES.QuitEdit;

    constructor(private router: Router) {}

    onReturnClick(): void {
        this.showConfirmation = true;
    }

    onConfirmQuit(): void {
        this.showConfirmation = false;
        this.router.navigate(['/admin-game']);
    }

    onCancelQuit(): void {
        this.showConfirmation = false;
    }
}

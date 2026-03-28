import { Component } from '@angular/core';
import { GameEditorComponent } from '@app/components/editor/game-editor/game-editor.component';
import { Router } from '@angular/router';
import { PopUpComponent } from '@app/components/shared/pop-up/pop-up.component';
import { TranslateModule } from '@ngx-translate/core';

@Component({
    selector: 'app-edit-game-page',
    imports: [GameEditorComponent, PopUpComponent, TranslateModule],
    templateUrl: './edit-game-page.component.html',
    styleUrl: './edit-game-page.component.scss',
})
export class EditGamePageComponent {
    showConfirmation: boolean = false;
    quitMessage = 'edit_game.quit_confirm';

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

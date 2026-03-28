import { HttpErrorResponse } from '@angular/common/http';
import { Component, Input } from '@angular/core';
import { Router } from '@angular/router';
import { Board } from '@app/classes/board/board';
import { PopUpComponent } from '@app/components/shared/pop-up/pop-up.component';
import { HTTP_STATUS_CODES } from '@app/constants/http-status-code.constants';
import { ROUTES } from '@app/constants/routes.constants';
import { SaveValidationResult } from '@app/interfaces/save-validation-result.interface';
import { GameValidationService } from '@app/services/editor/game-validation.service';
import { GameService } from '@app/services/editor/game.service';
import { TranslateModule, TranslateService } from '@ngx-translate/core';

@Component({
    selector: 'app-save-game',
    imports: [PopUpComponent, TranslateModule],
    templateUrl: './save-game.component.html',
    styleUrl: './save-game.component.scss',
})
export class SaveGameComponent {
    @Input() board!: Board;
    errors: SaveValidationResult[] = [];
    showError: boolean;
    errorMessage: string;
    showSecondButton: boolean = false;
    onConfirm: () => void = this.closeDialogue;

    constructor(
        private router: Router,
        private gameValidationService: GameValidationService,
        private gameService: GameService,
        private translate: TranslateService,
    ) {}

    onSaveGame(): void {
        if (!this.validateBoard()) return;
        this.errorMessage = this.translate.instant('save.confirm');
        this.showError = true;
        this.showSecondButton = true;
        this.onConfirm = this.onConfirmSave;
    }

    onConfirmSave(): void {
        this.closeDialogue();
        this.gameService.setBoard(this.board);
        if (this.gameService.isGameBeingModified) {
            this.gameService.fetchGames().subscribe({
                next: (games) => {
                    const gameExists = games.find((game) => game._id === this.gameService.getId());
                    if (gameExists) this.saveModifications();
                    else this.saveNewGame();
                },
            });
        } else this.saveNewGame();
    }

    getErrorParams(error: SaveValidationResult): Record<string, unknown> | undefined {
        return error.messageParams;
    }

    closeDialogue(): void {
        this.errors = [];
        this.showError = false;
        this.errorMessage = '';
        this.showSecondButton = false;
        this.onConfirm = this.closeDialogue;
    }

    private validateBoard(): boolean {
        const name = this.gameService.getName();
        const description = this.gameService.getDescription();
        const isCTF = this.gameService.getMode() === 'ctf';
        this.errors = this.gameValidationService.validateGame(name, description, this.board, isCTF);
        return this.errors.length === 0;
    }

    private saveModifications() {
        this.gameService.saveModifications().subscribe({
            next: () => {
                this.router.navigate([ROUTES.admin]);
            },
            error: (err) => this.handleSaveError(err),
        });
    }

    private saveNewGame() {
        this.gameService.saveNewGame().subscribe({
            next: () => {
                this.router.navigate([ROUTES.admin]);
            },
            error: (err) => this.handleSaveError(err),
        });
    }

    private handleSaveError(err: HttpErrorResponse): void {
        this.showError = true;
        if (err.status === HTTP_STATUS_CODES.conflict) {
            this.errorMessage = this.translate.instant('save.conflict_error');
        } else {
            this.errorMessage = this.translate.instant('save.generic_error');
        }
    }
}

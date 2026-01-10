import { HttpErrorResponse } from '@angular/common/http';
import { Component, Input } from '@angular/core';
import { Router } from '@angular/router';
import { Board } from '@app/classes/board';
import { GameValidationService } from '@app/services/game-validation.service';
import { GameService } from '@app/services/game.service';
import { HTTP_STATUS_CODES } from '@app/constants/http-status-code.constants';
import { PopUpComponent } from '@app/components/pop-up/pop-up.component';
import { ROUTES } from '@app/constants/routes.constants';
import { ErrorMessages } from '@app/constants/error-messages.constants';

@Component({
    selector: 'app-save-game',
    imports: [PopUpComponent],
    templateUrl: './save-game.component.html',
    styleUrl: './save-game.component.scss',
})
export class SaveGameComponent {
    @Input() board!: Board;
    errors: { message?: string }[] = [];
    showError: boolean;
    errorMessage: string;

    constructor(
        private router: Router,
        private gameValidationService: GameValidationService,
        private gameService: GameService,
    ) {}

    onSaveGame(): void {
        const isBoardValid = this.validateBoard();
        if (isBoardValid) {
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
    }

    closeDialogue(): void {
        this.errors = [];
        this.showError = false;
    }

    private validateBoard(): boolean {
        const name = this.gameService.getName();
        const description = this.gameService.getDescription();
        this.errors = this.gameValidationService.validateGame(name, description, this.board);
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
            this.errorMessage = ErrorMessages.NameAlreadyUsed;
        } else {
            this.errorMessage = ErrorMessages.GenericError;
        }
    }
}

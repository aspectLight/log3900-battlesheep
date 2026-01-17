import { CommonModule } from '@angular/common';
import { HttpErrorResponse } from '@angular/common/http';
import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { RouterLink } from '@angular/router';
import { Game } from '@app/classes/game';
import { BoardComponent } from '@app/components/board/board.component';
import { HTTP_STATUS_CODES } from '@app/constants/http-status-code.constants';
import { GameListService } from '@app/services/game-list.service';
import { GameService } from '@app/services/game.service';
import { PopUpComponent } from '@app/components/pop-up/pop-up.component';
import { ErrorMessages, WARNING_MESSAGES } from '@common/error-messages.constants';
import { LoadingScreenComponent } from '@app/components/loading-screen/loading-screen.component';
@Component({
    selector: 'app-game-list',
    templateUrl: './game-list.component.html',
    styleUrls: ['./game-list.component.scss'],
    imports: [CommonModule, RouterLink, BoardComponent, PopUpComponent, LoadingScreenComponent],
})
export class GameListComponent implements OnInit {
    @Input() isAddBoardVisible = false;
    @Input() isModifierVisible = false;
    @Output() selectedGame = new EventEmitter<Game>();
    @Output() gamesLength = new EventEmitter<number>();

    selectedGameId: string | null = null;
    games: Game[] = [];
    showError: boolean = false;
    errorMessage: string = '';
    onConfirm: () => void;

    private pendingGame: Game | null = null;

    constructor(
        private gameListService: GameListService,
        private gameService: GameService,
    ) {}

    ngOnInit(): void {
        this.getAllGames();
    }

    onCheckboxClick(game: Game, event: MouseEvent): void {
        event.preventDefault();
        event.stopPropagation();

        this.pendingGame = game;
        this.errorMessage = WARNING_MESSAGES.VisibilityWarning;
        this.showError = true;
        this.onConfirm = this.onConfirmVisibility;
    }

    onConfirmVisibility(): void {
        if (!this.pendingGame) return;
        this.gameListService.onCheckboxClick(this.pendingGame).subscribe({
            next: () => {
                this.getAllGames();
            },
        });
        this.clearPending();
    }

    onModifyClick(game: Game): void {
        this.gameListService.onModifyClick(game);
    }

    onDeleteClick(game: Game): void {
        this.pendingGame = game;
        this.errorMessage = WARNING_MESSAGES.DeleteWarning;
        this.showError = true;
        this.onConfirm = this.onConfirmDelete;
    }

    onConfirmDelete(): void {
        if (!this.pendingGame) return;
        this.gameListService.onDeleteClick(this.pendingGame).subscribe({
            next: () => {
                this.getAllGames();
                this.clearPending();
            },
            error: (err: HttpErrorResponse) => {
                this.handleDeleteError(err);
                this.clearPending();
            },
        });
    }

    onCancel(): void {
        this.clearPending();
    }

    onSelectGame(game: Game): void {
        this.selectedGameId = game._id;
        this.selectedGame.emit(game);
    }

    private getAllGames(): void {
        this.gameService.fetchGames().subscribe({
            next: (gamesData) => {
                this.games = gamesData.map((gameData) => new Game(gameData));
                this.gamesLength.emit(this.games.length);
            },
            error: () => {
                this.games = [];
                this.gamesLength.emit(0);
            },
        });
    }

    private handleDeleteError(err: HttpErrorResponse): void {
        this.showError = true;
        if (err.status === HTTP_STATUS_CODES.notFound) {
            this.errorMessage = ErrorMessages.GameDeleted;
        } else {
            this.errorMessage = ErrorMessages.GenericError;
        }
    }

    private clearPending(): void {
        this.pendingGame = null;
        this.showError = false;
        this.errorMessage = '';
    }
}

import { CommonModule } from '@angular/common';
import { HttpErrorResponse } from '@angular/common/http';
import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { RouterLink } from '@angular/router';
import { Game } from '@app/classes/game/game';
import { BoardComponent } from '@app/components/shared/board/board.component';
import { LoadingScreenComponent } from '@app/components/shared/loading-screen/loading-screen.component';
import { PopUpComponent } from '@app/components/shared/pop-up/pop-up.component';
import { HTTP_STATUS_CODES } from '@app/constants/http-status-code.constants';
import { ProfileService } from '@app/services/communication/profile.service';
import { GameService } from '@app/services/editor/game.service';
import { GameListService } from '@app/services/lobby/game-list.service';
import { ErrorMessages, WARNING_MESSAGES } from '@common/error-messages.constants';
@Component({
    selector: 'app-game-list',
    templateUrl: './game-list.component.html',
    styleUrls: ['./game-list.component.scss'],
    imports: [CommonModule, RouterLink, BoardComponent, PopUpComponent, LoadingScreenComponent],
})
export class GameListComponent implements OnInit {
    @Input() isAddBoardVisible = false;
    @Input() isModifierVisible = false;
    @Input() includeProtected = false;
    @Output() selectedGame = new EventEmitter<Game>();
    @Output() gamesLength = new EventEmitter<number>();

    currentUsername: string = '';
    selectedGameId: string | null = null;
    games: Game[] = [];
    isLoading: boolean = true;
    showError: boolean = false;
    errorMessage: string = '';
    onConfirm: () => void;

    private pendingGame: Game | null = null;

    constructor(
        private gameListService: GameListService,
        private gameService: GameService,
        private profileService: ProfileService,
    ) {}

    ngOnInit(): void {
        this.profileService.getProfile().then((profile) => {
            this.currentUsername = profile.username;
        });
        this.getAllGames();
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

    onPrivacyChange(game: Game, privacy: string): void {
        this.gameListService.updatePrivacy(game._id, privacy).subscribe({
            next: (updatedGame) => {
                game.privacy = updatedGame.privacy;
            },
        });
    }

    onDuplicateClick(game: Game): void {
        this.gameListService.duplicateGame(game._id).subscribe({
            next: () => {
                this.getAllGames();
            },
            error: (err: HttpErrorResponse) => {
                this.showError = true;
                this.errorMessage = err.error?.message || ErrorMessages.GenericError;
                this.onConfirm = () => {
                    this.showError = false;
                };
            },
        });
    }

    private getAllGames(): void {
        this.isLoading = true;
        this.gameService.fetchGames(this.includeProtected ? 'play' : undefined).subscribe({
            next: (gamesData) => {
                this.games = gamesData.map((gameData) => new Game(gameData));
                this.gamesLength.emit(this.games.length);
                this.isLoading = false;
            },
            error: () => {
                this.games = [];
                this.gamesLength.emit(0);
                this.isLoading = false;
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

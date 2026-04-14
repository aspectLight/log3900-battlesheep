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
import { TranslateModule, TranslateService } from '@ngx-translate/core';
@Component({
    selector: 'app-game-list',
    templateUrl: './game-list.component.html',
    styleUrls: ['./game-list.component.scss'],
    imports: [CommonModule, RouterLink, BoardComponent, PopUpComponent, LoadingScreenComponent, TranslateModule],
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

    filterSize: string = '';
    filterMode: string = '';
    sortByDate: string = '';
    searchQuery: string = '';

    private pendingGame: Game | null = null;

    constructor(
        private gameListService: GameListService,
        private gameService: GameService,
        private profileService: ProfileService,
        private translate: TranslateService,
    ) {}

    get filteredGames(): Game[] {
        let result = this.games;

        if (this.searchQuery.trim()) {
            const query = this.searchQuery.trim().toLowerCase();
            result = result.filter((g) => g.name.toLowerCase().includes(query));
        }

        if (this.filterSize) {
            result = result.filter((g) => String(g.board.size) === this.filterSize);
        }

        if (this.filterMode) {
            result = result.filter((g) => g.mode === this.filterMode);
        }

        if (this.sortByDate === 'newest') {
            result = [...result].sort((a, b) => new Date(b.modificationDate).getTime() - new Date(a.modificationDate).getTime());
        } else if (this.sortByDate === 'oldest') {
            result = [...result].sort((a, b) => new Date(a.modificationDate).getTime() - new Date(b.modificationDate).getTime());
        }

        return result;
    }

    resetFilters(): void {
        this.filterSize = '';
        this.filterMode = '';
        this.sortByDate = '';
        this.searchQuery = '';
    }

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
        this.errorMessage = this.translate.instant('game_list.delete_warning');
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
                this.errorMessage = err.error?.message || this.translate.instant('errors.generic');
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
            this.errorMessage = this.translate.instant('errors.game_deleted');
        } else {
            this.errorMessage = this.translate.instant('errors.generic');
        }
    }

    private clearPending(): void {
        this.pendingGame = null;
        this.showError = false;
        this.errorMessage = '';
    }
}

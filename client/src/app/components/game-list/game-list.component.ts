import { CommonModule } from '@angular/common';
import { HttpErrorResponse } from '@angular/common/http';
import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { Router, RouterLink } from '@angular/router';
import { Game } from '@app/classes/game';
import { BoardComponent } from '@app/components/board/board.component';
import { HTTP_STATUS_CODES } from '@app/constants/http-status-code.constants';
import { GameListService } from '@app/services/game-list.service';
import { GameService } from '@app/services/game.service';
import { PopUpComponent } from '@app/components/pop-up/pop-up.component';
import { ErrorMessages } from '@app/constants/error-messages.constants';

@Component({
    selector: 'app-game-list',
    templateUrl: './game-list.component.html',
    styleUrls: ['./game-list.component.scss'],
    imports: [CommonModule, RouterLink, BoardComponent, PopUpComponent],
})
export class GameListComponent implements OnInit {
    @Input() isAddBoardVisible = false;
    @Input() isModifierVisible = false;
    @Output() selectedGame = new EventEmitter<Game>();
    selectedGameId: string | null = null;
    games: Game[] = [];
    message: string = '';
    showError: boolean;
    errorMessage: string;
    router: Router;

    constructor(
        private gameListService: GameListService,
        private gameService: GameService,
    ) {
        this.showError = false;
    }

    ngOnInit(): void {
        this.getAllGames();
    }

    trackById(game: Game): string {
        return game._id;
    }

    getDate(game: Game): string {
        return this.gameListService.getDate(game);
    }

    onCheckboxClick(game: Game) {
        this.gameListService.onCheckboxClick(game).subscribe({
            next: () => {
                this.getAllGames();
            },
        });
    }

    onModifyClick(game: Game) {
        this.gameListService.onModifyClick(game);
    }

    onDeleteClick(game: Game) {
        this.gameListService.onDeleteClick(game).subscribe({
            next: () => {
                this.getAllGames();
            },
            error: (err) => this.handleDeleteError(err),
        });
    }

    onSelectGame(game: Game) {
        this.selectedGameId = game._id;
        this.selectedGame.emit(game);
    }

    private getAllGames(): void {
        this.gameService.fetchGames().subscribe({
            next: (gamesData) => {
                this.games = gamesData.map((gameData) => new Game(gameData));
            },
            error: () => {
                this.games = [];
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
}

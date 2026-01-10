import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { GameService } from '@app/services/game.service';
import { BOARD_SIZES } from '@app/constants/board.constants';
import { MODES } from '@app/constants/game.constants';
import { ROUTES } from '@app/constants/routes.constants';

@Component({
    selector: 'app-game-configurator',
    templateUrl: './game-configurator.component.html',
    styleUrl: './game-configurator.component.scss',
})
export class GameConfiguratorComponent {
    mode: string = 'classique';
    modeDescription: string = MODES[this.mode];
    boardSize: string = 'moyenne';
    board: number = BOARD_SIZES[this.boardSize].board;
    players: string = BOARD_SIZES[this.boardSize].players;
    items: number = BOARD_SIZES[this.boardSize].items;

    constructor(
        private router: Router,
        private gameService: GameService,
    ) {}

    onModeChange(mode: string): void {
        this.mode = mode;
        this.modeDescription = MODES[this.mode];
    }

    onSizeChange(boardSize: string): void {
        this.boardSize = boardSize;
        this.board = BOARD_SIZES[this.boardSize].board;
        this.players = BOARD_SIZES[this.boardSize].players;
        this.items = BOARD_SIZES[this.boardSize].items;
    }

    createGame(): void {
        this.router.navigate(['/edit-game']);
        this.gameService.setNewGame();
        this.gameService.setGameSettings(this.mode, this.board);
    }

    cancel(): void {
        this.router.navigate([ROUTES.admin]);
    }
}

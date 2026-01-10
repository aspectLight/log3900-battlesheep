import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { GameService } from '@app/services/game.service';
import { BOARD_CONFIGS, BoardSizes } from '@app/constants/board.constants';
import { MODES, MODE_DESCRIPTIONS } from '@app/constants/game.constants';
import { ROUTES } from '@app/constants/routes.constants';

@Component({
    selector: 'app-game-configurator',
    templateUrl: './game-configurator.component.html',
    styleUrl: './game-configurator.component.scss',
})
export class GameConfiguratorComponent {
    mode: string = 'classique';
    modeDescription: string = MODE_DESCRIPTIONS[this.mode as MODES];
    boardSize: BoardSizes = BoardSizes.Moyenne;
    board: number = BOARD_CONFIGS[this.boardSize].board;
    players: string = BOARD_CONFIGS[this.boardSize].players;
    items: number = BOARD_CONFIGS[this.boardSize].items;

    readonly boardSizes = BoardSizes;

    constructor(
        private router: Router,
        private gameService: GameService,
    ) {}

    onModeChange(mode: string): void {
        this.mode = mode;
        this.modeDescription = MODE_DESCRIPTIONS[this.mode as MODES];
    }

    onSizeChange(boardSize: BoardSizes): void {
        this.boardSize = boardSize;
        this.board = BOARD_CONFIGS[this.boardSize].board;
        this.players = BOARD_CONFIGS[this.boardSize].players;
        this.items = BOARD_CONFIGS[this.boardSize].items;
    }

    createGame(): void {
        this.router.navigate([ROUTES.edit]);
        this.gameService.setNewGame();
        this.gameService.setGameSettings(this.mode, this.board);
    }

    cancel(): void {
        this.router.navigate([ROUTES.admin]);
    }
}

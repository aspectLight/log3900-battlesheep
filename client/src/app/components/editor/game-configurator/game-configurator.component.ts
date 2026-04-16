import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { BOARD_CONFIGS, BoardSizes } from '@app/constants/board.constants';
import { MODES, MODE_DESCRIPTIONS } from '@app/constants/game.constants';
import { ROUTES } from '@app/constants/routes.constants';
import { GameService } from '@app/services/editor/game.service';
import { TranslateModule } from '@ngx-translate/core';

@Component({
    selector: 'app-game-configurator',
    templateUrl: './game-configurator.component.html',
    styleUrl: './game-configurator.component.scss',
    imports: [TranslateModule],
})
export class GameConfiguratorComponent {
    mode: string = 'classique';
    privacy: 'public' | 'private' | 'protected' = 'public';
    modeDescriptionKey: string = MODE_DESCRIPTIONS[this.mode as MODES];
    privacyDescriptionKey: string = 'game_configurator.privacy_desc_public';
    boardSize: BoardSizes = BoardSizes.Moyenne;
    board: number = BOARD_CONFIGS[this.boardSize].board;
    players: string = BOARD_CONFIGS[this.boardSize].players;
    items: number = BOARD_CONFIGS[this.boardSize].items;
    actionsPoints: number = 1;

    readonly boardSizes = BoardSizes;

    constructor(
        private router: Router,
        private gameService: GameService,
    ) {}

    onModeChange(mode: string): void {
        this.mode = mode;
        this.modeDescriptionKey = MODE_DESCRIPTIONS[this.mode as MODES];
    }

    onSizeChange(boardSize: BoardSizes): void {
        this.boardSize = boardSize;
        this.board = BOARD_CONFIGS[this.boardSize].board;
        this.players = BOARD_CONFIGS[this.boardSize].players;
        this.items = BOARD_CONFIGS[this.boardSize].items;
    }

    onPrivacyChange(privacy: string): void {
        this.privacy = privacy as 'public' | 'private' | 'protected';
        this.privacyDescriptionKey = `game_configurator.privacy_desc_${privacy}`;
    }

    onActionsChange(actions: number): void {
        this.actionsPoints = actions;
    }

    createGame(): void {
        this.router.navigate([ROUTES.edit]);
        this.gameService.setNewGame();
        this.gameService.setGameSettings(this.mode, this.board, this.privacy, this.actionsPoints);
    }

    cancel(): void {
        this.router.navigate([ROUTES.admin]);
    }
}

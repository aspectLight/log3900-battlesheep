import { Component, OnInit } from '@angular/core';
import { Board } from '@app/classes/board/board';
import { BoardComponent } from '@app/components/shared/board/board.component';
import { ToolboxComponent } from '@app/components/editor/toolbox/toolbox.component';
import { GameService } from '@app/services/editor/game.service';
import { TeleportService } from '@app/services/editor/teleport.service';
import { LoadingScreenComponent } from '@app/components/shared/loading-screen/loading-screen.component';
@Component({
    selector: 'app-game-editor',
    imports: [ToolboxComponent, BoardComponent, LoadingScreenComponent],
    templateUrl: './game-editor.component.html',
    styleUrls: ['./game-editor.component.scss'],
})
export class GameEditorComponent implements OnInit {
    board: Board;
    resetToolboxFlag: boolean = false;

    constructor(
        private gameService: GameService,
        private teleportService: TeleportService,
    ) {}

    ngOnInit(): void {
        if (this.gameService.isGameBeingModified) {
            this.board = this.gameService.getBoard();
            this.teleportService.initializePairsFromBoard(this.board);
        } else {
            const gameSettings = this.gameService.getGameSettings();
            this.board = new Board(gameSettings.boardSize);
        }
    }

    onRestartConfirmed() {
        this.gameService.undoModifications();
        this.board = this.gameService.getBoard();
        this.teleportService.initializePairsFromBoard(this.board);
        this.resetToolboxFlag = !this.resetToolboxFlag;
    }

    getGameName() {
        return this.gameService.getName();
    }
}

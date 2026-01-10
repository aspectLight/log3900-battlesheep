import { Component, OnInit } from '@angular/core';
import { Board } from '@app/classes/board';
import { BoardComponent } from '@app/components/board/board.component';
import { RestartGameComponent } from '@app/components/restart-game/restart-game.component';
import { SaveGameComponent } from '@app/components/save-game/save-game.component';
import { ToolboxComponent } from '@app/components/toolbox/toolbox.component';
import { GameService } from '@app/services/game.service';

@Component({
    selector: 'app-game-editor',
    imports: [ToolboxComponent, SaveGameComponent, RestartGameComponent, BoardComponent],
    templateUrl: './game-editor.component.html',
    styleUrls: ['./game-editor.component.scss'],
})
export class GameEditorComponent implements OnInit {
    board: Board;
    resetToolboxFlag: boolean = false;

    constructor(private gameService: GameService) {}

    ngOnInit(): void {
        if (this.gameService.isGameBeingModified) {
            this.board = this.gameService.getBoard();
        } else {
            const gameSettings = this.gameService.getGameSettings();
            this.board = new Board(gameSettings.boardSize);
        }
    }

    onRestartConfirmed() {
        this.gameService.undoModifications();
        this.board = this.gameService.getBoard();
        this.resetToolboxFlag = !this.resetToolboxFlag;
    }

    getGameName() {
        return this.gameService.getName();
    }
}

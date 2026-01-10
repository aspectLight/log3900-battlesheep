import { Component, OnInit } from '@angular/core';
import { Board } from '@app/classes/board';
import { BoardComponent } from '@app/components/board/board.component';
import { ToolboxComponent } from '@app/components/toolbox/toolbox.component';
import { GameService } from '@app/services/game.service';
import { LoadingScreenComponent } from '@app/components/loading-screen/loading-screen.component';
@Component({
    selector: 'app-game-editor',
    imports: [ToolboxComponent, BoardComponent, LoadingScreenComponent],
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

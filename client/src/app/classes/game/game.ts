import { Board } from '@app/classes/board/board';
import { BOARD_CONFIGS, BoardSizes } from '@app/constants/board.constants';

export class Game {
    _id: string;
    name: string;
    description: string;
    mode: string;
    board: Board;
    isVisible: boolean;
    modificationDate: string;
    actionPoints: number;
    constructor(data?: Game) {
        if (data) {
            this.setData(data);
        } else {
            const boardSize = BoardSizes.Moyenne;
            this.name = '';
            this.description = '';
            this.mode = '';
            this.board = new Board(BOARD_CONFIGS[boardSize].board);
            this.isVisible = false;
            this.modificationDate = Date.now().toString();
            this.actionPoints = 1;
        }
    }

    get isCTF(): boolean {
        return this.mode === 'ctf';
    }

    getBoard(): Board {
        return this.board;
    }

    private setData(data: Game) {
        this._id = data._id;
        this.name = data.name;
        this.description = data.description;
        this.mode = data.mode;
        this.board = new Board(data.board);
        this.isVisible = data.isVisible;
        this.modificationDate = data.modificationDate;
        this.actionPoints = data.actionPoints ?? 1;
    }
}

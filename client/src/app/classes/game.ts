import { Board } from './board';
import { BOARD_SIZES } from '@app/constants/board.constants';

export class Game {
    _id: string;
    name: string;
    description: string;
    mode: string;
    board: Board;
    isVisible: boolean;
    modificationDate: string;

    constructor(data?: Game) {
        if (data) {
            this.setData(data);
        } else {
            this._id = '';
            this.name = '';
            this.description = '';
            this.mode = '';
            this.board = new Board(BOARD_SIZES['moyenne'].board);
            this.isVisible = false;
            this.modificationDate = Date.now().toString();
        }
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
    }
}

import { Board } from '@app/classes/board/board';
import { BOARD_CONFIGS, BoardSizes } from '@app/constants/board.constants';

export class Game {
    _id: string;
    name: string;
    description: string;
    mode: string;
    board: Board;
    modificationDate: string;
    privacy: string;
    owner: string;

    constructor(data?: Game) {
        if (data) {
            this.setData(data);
        } else {
            const boardSize = BoardSizes.Moyenne;
            this.name = '';
            this.description = '';
            this.mode = '';
            this.board = new Board(BOARD_CONFIGS[boardSize].board);
            this.modificationDate = Date.now().toString();
            this.privacy = 'public';
            this.owner = '';
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
        this.modificationDate = data.modificationDate;
        this.privacy = data.privacy;
        this.owner = data.owner;
    }
}

import { Board } from './board';
import { Cell } from './cell';
import { Item } from './item';
import { Player } from './player';
import { Tile } from './tile';

describe('Board', () => {
    let board: Board;
    const expectedSize = 5;

    beforeEach(() => {
        board = new Board(expectedSize);
    });

    it('should create a board with the correct size', () => {
        expect(board.size).toBe(expectedSize);
        expect(board.matrix.length).toBe(expectedSize);
        expect(board.matrix[0].length).toBe(expectedSize);
    });

    it('should initialize all cells with a default tile', () => {
        for (let i = 0; i < board.size; i++) {
            for (let j = 0; j < board.size; j++) {
                expect(board.getCell(i, j)?.tile.type).toBe('snow');
            }
        }
    });

    it('should get a cell at valid coordinates', () => {
        // eslint-disable-next-line @typescript-eslint/no-magic-numbers
        const cell = board.getCell(2, 3);
        expect(cell).toBeInstanceOf(Cell);
        expect(cell?.tile.type).toBe('snow');
    });

    it('should return null for invalid coordinates', () => {
        expect(board.getCell(-1, 0)).toBeNull();
        expect(board.getCell(0, -1)).toBeNull();
        expect(board.getCell(expectedSize, 0)).toBeNull();
        expect(board.getCell(0, expectedSize)).toBeNull();
    });

    it('should set a tile at a valid position', () => {
        const newTile = new Tile('water');
        board.setTile(1, 1, newTile);
        expect(board.getCell(1, 1)?.tile.type).toBe('water');
    });

    it('should throw an error when setting a tile at an invalid position', () => {
        const newTile = new Tile('water');
        expect(() => board.setTile(-1, 0, newTile)).toThrowError('Invalid position (-1, 0)');
        expect(() => board.setTile(0, expectedSize, newTile)).toThrowError('Invalid position (0, 5)');
    });

    it('should reset a tile to default at a valid position', () => {
        const newTile = new Tile('water');
        board.setTile(2, 2, newTile);
        expect(board.getCell(2, 2)?.tile.type).toBe('water');

        board.setTileDefault(2, 2);
        expect(board.getCell(2, 2)?.tile.type).toBe('snow');
    });

    it('should throw an error when resetting a tile at an invalid position', () => {
        expect(() => board.setTileDefault(-1, 0)).toThrowError('Invalid position (-1, 0)');
        expect(() => board.setTileDefault(0, expectedSize)).toThrowError('Invalid position (0, 5)');
    });

    it('clearBoard() should reset all tiles to default', () => {
        board.setTile(0, 0, new Tile('water'));
        // eslint-disable-next-line @typescript-eslint/no-magic-numbers
        board.setTile(2, 3, new Tile('stone'));

        expect(board.getCell(0, 0)?.tile.type).toBe('water');
        // eslint-disable-next-line @typescript-eslint/no-magic-numbers
        expect(board.getCell(2, 3)?.tile.type).toBe('stone');

        board.clearBoard();

        for (let i = 0; i < board.size; i++) {
            for (let j = 0; j < board.size; j++) {
                expect(board.getCell(i, j)?.tile.type).toBe('snow');
            }
        }
    });

    it('should create a board from data with item', () => {
        board.matrix[0][0].addItem(new Item('propaganda'));

        const newBoard = new Board(board);

        expect(board.size).toBe(expectedSize);
        expect(board.matrix.length).toBe(expectedSize);
        expect(board.matrix[0].length).toBe(expectedSize);
        expect(newBoard.getCell(0, 0)?.getItem()?.type).toBe('propaganda');
    });

    it('should return the player by id', () => {
        const player = new Player('player1', 'Player 1');

        const cell = board.getCell(2, 2);
        if (cell) {
            cell.player = player;
        }
        const foundPlayer = board.getPlayerById(player.id);

        expect(foundPlayer).toBe(player);
    });

    it('should return null when player is not found', () => {
        const playerId = '123';
        board.matrix[0][0].addEntity(new Player(playerId));

        const player = board.getPlayerById('456');

        expect(player).toBeNull();
    });
});

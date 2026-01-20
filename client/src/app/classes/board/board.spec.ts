import { Item } from '@app/classes/entity/item';
import { Player } from '@app/classes/entity/player';
import { Board } from '@app/classes/board/board';
import { Cell } from '@app/classes/board/cell';
import { Tile } from '@app/classes/board/tile';

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

    describe('getPlayerCoordsById', () => {
        it('should return correct coordinates when player is found', () => {
            const player = new Player('player1', 'Player 1');
            const x = 2;
            const y = 3;
            const cell = board.getCell(x, y);
            if (cell) {
                cell.player = player;
            }

            const coords = board.getPlayerCoordsById(player.id);
            expect(coords).toEqual({ x, y });
        });

        it('should return null when player is not found', () => {
            const coords = board.getPlayerCoordsById('nonexistent');
            expect(coords).toBeNull();
        });
    });

    describe('getTwoNearestEmptyCells', () => {
        it('should return two nearest empty cells', () => {
            // Create a scenario with some obstacles
            board.setTile(1, 1, new Tile('wall'));
            board.setTile(1, 2, new Tile('tree'));
            board.setTile(2, 1, new Tile('stone'));

            const startCoords = { x: 0, y: 0 };
            const emptyCells = board.getTwoNearestEmptyCells(startCoords);

            expect(emptyCells.length).toBe(2);
            // The two nearest empty cells should be (0,1) and (1,0)
            expect(emptyCells.some((cell) => cell.x === 0 && cell.y === 1)).toBeTrue();
            expect(emptyCells.some((cell) => cell.x === 1 && cell.y === 0)).toBeTrue();
        });

        it('should return empty array when no empty cells are available', () => {
            // Fill the board with obstacles
            for (let i = 0; i < board.size; i++) {
                for (let j = 0; j < board.size; j++) {
                    if (i !== 0 || j !== 0) {
                        // Leave the start position empty
                        board.setTile(i, j, new Tile('wall'));
                    }
                }
            }

            const startCoords = { x: 0, y: 0 };
            const emptyCells = board.getTwoNearestEmptyCells(startCoords);

            expect(emptyCells.length).toBe(0);
        });

        it('should not return cells with players or items', () => {
            // Add a player and an item to nearby cells
            const player = new Player('player1', 'Player 1');
            const cellWithPlayer = board.getCell(0, 1);
            if (cellWithPlayer) {
                cellWithPlayer.player = player;
            }

            const cellWithItem = board.getCell(1, 0);
            if (cellWithItem) {
                cellWithItem.addItem(new Item('propaganda'));
            }

            const startCoords = { x: 0, y: 0 };
            const emptyCells = board.getTwoNearestEmptyCells(startCoords);

            expect(emptyCells.length).toBe(2);
            // Should not include cells with players or items
            expect(emptyCells.some((cell) => cell.x === 0 && cell.y === 1)).toBeFalse();
            expect(emptyCells.some((cell) => cell.x === 1 && cell.y === 0)).toBeFalse();
        });

        it('should handle edge case when queue.shift() returns undefined', () => {
            // Create a spy on Array.prototype.shift to force it to return undefined
            const originalShift = Array.prototype.shift;
            let shiftCallCount = 0;

            // Mock implementation that returns undefined on first call
            Array.prototype.shift = function () {
                shiftCallCount++;
                if (shiftCallCount === 1) {
                    return undefined;
                }
                return originalShift.apply(this);
            };

            const startCoords = { x: 0, y: 0 };
            const emptyCells = board.getTwoNearestEmptyCells(startCoords);

            // Restore original shift implementation
            Array.prototype.shift = originalShift;

            // Since we forced shift to return undefined on the first call,
            // the algorithm should have exited the while loop early
            expect(emptyCells.length).toBe(0);
        });
    });
});

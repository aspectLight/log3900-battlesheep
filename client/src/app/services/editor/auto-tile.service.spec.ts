import { TestBed } from '@angular/core/testing';
import { Board } from '@app/classes/board/board';
import { Cell } from '@app/classes/board/cell';
import { Item } from '@app/classes/entity/item';
import { Tile } from '@app/classes/board/tile';
import { AutoTileService } from '@app/services/editor/auto-tile.service';

describe('AutoTileService', () => {
    let service: AutoTileService;
    let board: Board;
    let wall: Tile;

    beforeEach(() => {
        TestBed.configureTestingModule({});
        service = TestBed.inject(AutoTileService);

        board = new Board(3);
        wall = new Tile('wall');
    });

    it('should be created', () => {
        expect(service).toBeTruthy();
    });

    it('should not apply if out of bound', () => {
        spyOn(board, 'setTile');
        service.updateSurroundingTiles(10, 10, board);
        expect(board.setTile).not.toHaveBeenCalled();
    });

    it('should not apply if no neighbors', () => {
        board.setTile(1, 1, wall);

        spyOn(board, 'setTile');
        service.updateSurroundingTiles(1, 1, board);

        expect(board.setTile).toHaveBeenCalledWith(1, 1, new Tile('wall', 'Horizontal'));
    });

    it('should not apply if no wallLike neighbors', () => {
        const tree = new Tile('tree');
        board.setTile(0, 1, tree);
        board.setTile(1, 1, wall);
        board.setTile(0, 2, tree);

        spyOn(board, 'setTile');
        service.updateSurroundingTiles(1, 1, board);

        expect(board.setTile).toHaveBeenCalledWith(1, 1, new Tile('wall', 'Horizontal'));
    });

    it('should apply auto-tile for a corner', () => {
        board.setTile(0, 0, wall);
        board.setTile(1, 0, wall);
        board.setTile(0, 1, wall);

        spyOn(board, 'setTile');
        service.updateSurroundingTiles(0, 0, board);

        expect(board.setTile).toHaveBeenCalledWith(0, 0, new Tile('corner', 'UpLeft'));
        expect(board.setTile).toHaveBeenCalledWith(1, 0, new Tile('wall', 'Vertical'));
        expect(board.setTile).toHaveBeenCalledWith(0, 1, new Tile('wall', 'Horizontal'));
    });

    it('should apply auto-tile for an intersection', () => {
        board.setTile(0, 0, wall);
        board.setTile(0, 1, wall);
        board.setTile(0, 2, wall);
        board.setTile(1, 1, wall);

        spyOn(board, 'setTile');
        service.updateSurroundingTiles(0, 1, board);

        expect(board.setTile).toHaveBeenCalledWith(0, 0, new Tile('wall', 'Horizontal'));
        expect(board.setTile).toHaveBeenCalledWith(0, 1, new Tile('intersection', 'TDown'));
        expect(board.setTile).toHaveBeenCalledWith(0, 2, new Tile('wall', 'Horizontal'));
        expect(board.setTile).toHaveBeenCalledWith(1, 1, new Tile('wall', 'Vertical'));
    });

    it('should apply auto-tile for a door (vertically)', () => {
        const door = new Tile('door');

        board.setTile(0, 0, wall);
        board.setTile(1, 0, door);
        board.setTile(2, 0, wall);

        spyOn(board, 'setTile');
        service.updateSurroundingTiles(1, 0, board);

        expect(board.setTile).toHaveBeenCalledWith(0, 0, new Tile('wall', 'Vertical'));
        expect(board.setTile).toHaveBeenCalledWith(1, 0, new Tile('door', 'Vertical'));
        expect(board.setTile).toHaveBeenCalledWith(2, 0, new Tile('wall', 'Vertical'));
    });

    it('should apply auto-tile for a door (horizontally)', () => {
        const door = new Tile('door', 'Vertical');

        board.setTile(0, 0, wall);
        board.setTile(0, 1, door);
        board.setTile(0, 2, wall);

        spyOn(board, 'setTile');
        service.updateSurroundingTiles(0, 1, board);

        expect(board.setTile).toHaveBeenCalledWith(0, 0, new Tile('wall', 'Horizontal'));
        expect(board.setTile).toHaveBeenCalledWith(0, 1, new Tile('door', 'Horizontal'));
        expect(board.setTile).toHaveBeenCalledWith(0, 2, new Tile('wall', 'Horizontal'));
    });

    it('should apply auto-tile for a door (horizontally)', () => {
        board.setTile(0, 0, wall);
        board.setTile(0, 1, wall);
        board.setTile(0, 2, wall);

        spyOn(board, 'setTile');
        service.updateSurroundingTiles(0, 1, board);

        expect(board.setTile).toHaveBeenCalledWith(0, 0, new Tile('wall', 'Horizontal'));
        expect(board.setTile).toHaveBeenCalledWith(0, 1, new Tile('wall', 'Horizontal'));
        expect(board.setTile).toHaveBeenCalledWith(0, 2, new Tile('wall', 'Horizontal'));
    });

    it('should append all diagonal suffixes when all diagonal neighbors (and their adjacent cardinals) are in the same category', () => {
        board = new Board(3);
        board.matrix = [
            [new Cell(new Tile('wall'), 0, 0), new Cell(new Tile('wall'), 0, 1), new Cell(new Tile('wall'), 0, 2)],
            [new Cell(new Tile('wall'), 1, 0), new Cell(new Tile('wall'), 1, 1), new Cell(new Tile('wall'), 1, 2)],
            [new Cell(new Tile('wall'), 2, 0), new Cell(new Tile('wall'), 2, 1), new Cell(new Tile('wall'), 2, 2)],
        ];
        const suffix = service['getDiagonalSuffix'](1, 1, board, 'wall');

        // '_TL' + '_TR' + '_BR' + '_BL'
        expect(suffix).toBe('_TL_TR_BR_BL');
    });

    it('should not replace if no cell is selected ', () => {
        const setTileSpy = spyOn(board, 'setTile');

        service['replaceTileAndRestoreItem'](-1, 0, new Board(2), 'water', 'newOrientation');

        expect(setTileSpy).not.toHaveBeenCalled();
    });

    it('should put back the item and replace the tile when a cell has an item', () => {
        const oldTile = new Tile('ice', 'oldOrientation', 'defaultState');
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const testItem = { type: 'testItem' } as any; // assume Item shape
        const testCell = new Cell(oldTile, 1, 1);
        testCell.item = testItem as Item;

        const testBoard = new Board(3);
        testBoard.matrix[1] = [];
        testBoard.matrix[1][1] = testCell;
        spyOn(testBoard, 'getCell').and.callFake((x: number, y: number) => {
            return x === 1 && y === 1 ? testCell : null;
        });

        const setTileSpy = spyOn(testBoard, 'setTile');

        service['replaceTileAndRestoreItem'](1, 1, testBoard, 'water', 'newOrientation');

        expect(setTileSpy).toHaveBeenCalledWith(
            1,
            1,
            jasmine.objectContaining({
                type: 'water',
                orientation: 'newOrientation',
                state: 'defaultState',
            }),
        );
    });

    it('should return the correct tile category for each tile type', () => {
        const testCases = [
            { tileType: 'wall', expected: 'wall' },
            { tileType: 'corner', expected: 'wall' },
            { tileType: 'intersection', expected: 'wall' },
            { tileType: 'door', expected: 'wall' },
            { tileType: 'water', expected: 'water' },
            { tileType: 'ice', expected: 'ice' },
            { tileType: 'grass', expected: 'none' },
        ];
        let tile: Tile;

        testCases.forEach(({ tileType, expected }) => {
            if (tileType === 'grass') {
                tile = new Tile('ice');
                tile.type = tileType;
            } else {
                tile = new Tile(tileType);
            }
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            const result = (service as any).getTileCategory(tile);
            expect(result).toEqual(expected, `Expected tile type "${tileType}" to be categorized as "${expected}"`);
        });
    });

    it('should not replace if mapping is undefined ', () => {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const replaceSpy = spyOn<any>(service, 'replaceTileAndRestoreItem');
        board.matrix[1][1].tile.type = 'wall';
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        spyOn<any>(service, 'getTileMapping').and.returnValue(undefined);
        service['applyAutoTile'](1, 1, board);
        expect(replaceSpy).not.toHaveBeenCalled();
    });

    it('should not finish getTileMapping if category is undefined ', () => {
        const res = service['getTileMapping']('none', 1, 1, board);
        expect(res).toBe(undefined);
    });

    it('should not finish basemapping if category is undefined ', () => {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        spyOn<any>(service, 'getCardinalMask').and.returnValue(undefined);
        const res = service['getTileMapping']('wall', 1, 1, board);
        expect(res).toBe(undefined);
    });
});

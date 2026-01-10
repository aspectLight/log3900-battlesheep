/* eslint-disable @typescript-eslint/no-magic-numbers */
import { TestBed } from '@angular/core/testing';
import { PathService } from './path.service';
import { Cell } from '@app/classes/cell';
import { Board } from '@app/classes/board';
import { Tile } from '@app/classes/tile';
import { Coords } from '@app/interfaces/coords';
import { Item } from '@app/classes/item';

describe('PathService', () => {
    let service: PathService;
    let boardStub: Board;
    let cellA: Cell;
    let cellB: Cell;
    let cellC: Cell;
    let cellD: Cell;

    beforeEach(() => {
        TestBed.configureTestingModule({});
        service = TestBed.inject(PathService);

        cellA = new Cell(new Tile('snow'), 0, 0);
        cellB = new Cell(new Tile('ice'), 0, 1);
        cellC = new Cell(new Tile('snow'), 1, 0);
        cellD = new Cell(new Tile('ice'), 1, 1);

        boardStub = {
            getCell: (x: number, y: number): Cell | null => {
                if (x === cellA.x && y === cellA.y) return cellA;
                if (x === cellB.x && y === cellB.y) return cellB;
                if (x === cellC.x && y === cellC.y) return cellC;
                if (x === cellD.x && y === cellD.y) return cellD;
                return null;
            },
        } as Board;
    });

    it('should be created', () => {
        expect(service).toBeTruthy();
    });

    describe('setPaths', () => {
        it('should set paths if map size > 1', () => {
            const map = new Map<Coords, Coords[]>();
            map.set({ x: 0, y: 0 }, [{ x: 0, y: 1 }]);
            map.set({ x: 1, y: 0 }, [{ x: 1, y: 1 }]);
            service.setPaths(map);
            expect(service.paths).toEqual(map);
        });

        it('should clear service if map size <= 1', () => {
            const map = new Map<Coords, Coords[]>();
            map.set({ x: 0, y: 0 }, [{ x: 0, y: 1 }]);
            service.selectedPath.push(cellA);
            service.setPaths(map);
            expect(service.paths.size).toBe(0);
            expect(service.selectedPath).toEqual([]);
        });
    });

    describe('setPathFromCoord', () => {
        it('should add cells to selectedPath when board returns valid cells', () => {
            const key: Coords = { x: 0, y: 0 };
            const value: Coords[] = [
                { x: 0, y: 1 },
                { x: 1, y: 0 },
            ];
            const map = new Map<Coords, Coords[]>();
            map.set(key, value);
            service.paths = map;

            service.setPathFromCoord({ x: 0, y: 0 }, boardStub);
            expect(service.selectedPath).toEqual([cellB]);
        });

        it('should return early if board.getCell returns null', () => {
            const key: Coords = { x: 10, y: 10 };
            const value: Coords[] = [{ x: 10, y: 11 }];
            const map = new Map<Coords, Coords[]>();
            map.set(key, value);
            service.paths = map;
            service.selectedPath = [];

            service.setPathFromCoord({ x: 10, y: 10 }, boardStub);
            expect(service.selectedPath).toEqual([]);
        });
    });

    describe('addToPath', () => {
        beforeEach(() => {
            service.selectedPath = [];
        });

        it('should add a cell if selectedPath is empty', () => {
            service.addToPath(cellA);
            expect(service.selectedPath).toContain(cellA);
        });

        it('should not add a cell if it already exists in selectedPath', () => {
            service.selectedPath = [cellA];
            service.addToPath(cellA);
            expect(service.selectedPath.length).toBe(1);
        });

        it('should add a cell if it is adjacent to the last cell', () => {
            service.addToPath(cellA);
            service.addToPath(cellB);
            expect(service.selectedPath).toEqual([cellA, cellB]);
        });

        it('should add a cell if it is adjacent to the last cell', () => {
            service.addToPath(cellA);
            service.addToPath(cellC);
            expect(service.selectedPath).toEqual([cellA, cellC]);
        });

        it('should add a cell if it is adjacent to the last cell', () => {
            service.addToPath(cellD);
            service.addToPath(cellB);
            expect(service.selectedPath).toEqual([cellD, cellB]);
        });

        it('should not add a cell if it is not adjacent to the last cell', () => {
            service.addToPath(cellA);
            service.addToPath(cellD);
            expect(service.selectedPath).toEqual([cellA]);
        });

        it('should update path connections when adding adjacent cells', () => {
            service.addToPath(cellA);
            service.addToPath(cellB);
            expect(cellA.hasPathRight).toBeTrue();
            expect(cellB.hasPathLeft).toBeTrue();
        });
    });

    describe('clearPath', () => {
        it('should clear selectedPath and reset connection flags on each cell', () => {
            cellA.hasPathUp = true;
            cellB.hasPathDown = true;
            service.selectedPath = [cellA, cellB];
            service.clearPath();
            expect(service.selectedPath).toEqual([]);
            expect(cellA.hasPathUp).toBeFalse();
            expect(cellB.hasPathDown).toBeFalse();
        });
    });

    describe('getSelectedPathAsCoords', () => {
        it('should return coordinates corresponding to each cell in selectedPath', () => {
            service.selectedPath = [cellA, cellB];
            const coords = service.getSelectedPathAsCoords();
            expect(coords).toEqual([
                { x: cellA.x, y: cellA.y },
                { x: cellB.x, y: cellB.y },
            ]);
        });

        it('should truncate path at first non-spawnPoint item', () => {
            // Create cells with different item types
            const spawnCell1 = new Cell(new Tile('snow'), 0, 0);
            const spawnCell2 = new Cell(new Tile('snow'), 1, 0);
            const nonSpawnCell = new Cell(new Tile('snow'), 2, 0);
            const spawnCell3 = new Cell(new Tile('snow'), 3, 0);

            // Add items to cells
            spawnCell1.addItem(new Item('spawnPoint'));
            spawnCell2.addItem(new Item('spawnPoint'));
            nonSpawnCell.addItem(new Item('adrenaline'));
            spawnCell3.addItem(new Item('spawnPoint'));

            // Set up the path
            service.selectedPath = [spawnCell1, spawnCell2, nonSpawnCell, spawnCell3];

            // Get coordinates
            const coords = service.getSelectedPathAsCoords();

            // Should only include up to the non-spawnPoint cell
            expect(coords).toEqual([
                { x: spawnCell1.x, y: spawnCell1.y },
                { x: spawnCell2.x, y: spawnCell2.y },
                { x: nonSpawnCell.x, y: nonSpawnCell.y },
            ]);
        });
    });

    describe('getAllCellsFromPaths', () => {
        it('should return all unique cells from the paths based on board.getCell', () => {
            const coord1: Coords = { x: cellA.x, y: cellA.y };
            const coord2: Coords = { x: cellB.x, y: cellB.y };
            const coord3: Coords = { x: cellC.x, y: cellC.y };
            const map = new Map<Coords, Coords[]>();
            map.set(coord1, [coord1, coord2]);
            map.set(coord2, [coord2, coord3]);
            service.paths = map;
            const allCells = service.getAllCellsFromPaths(boardStub);
            expect(allCells).toContain(cellA);
            expect(allCells).toContain(cellB);
            expect(allCells).toContain(cellC);
            /* eslint-disable @typescript-eslint/no-magic-numbers */
            expect(allCells.length).toBe(3);
            /* eslint-enable @typescript-eslint/no-magic-numbers */
        });

        it('should not include duplicates in the returned array', () => {
            const coord1: Coords = { x: cellA.x, y: cellA.y };
            const map = new Map<Coords, Coords[]>();
            map.set(coord1, [coord1, coord1]);
            service.paths = map;
            const allCells = service.getAllCellsFromPaths(boardStub);
            expect(allCells).toEqual([cellA]);
        });
    });

    describe('setSelectedPathFromCoords', () => {
        it('should clear current path and set selectedPath based on board.getCell for each coordinate', () => {
            service.selectedPath = [cellA, cellB];
            const coordsList: Coords[] = [
                { x: cellD.x, y: cellD.y },
                { x: cellC.x, y: cellC.y },
            ];
            service.setSelectedPathFromCoords(coordsList, boardStub);
            expect(service.selectedPath).toEqual([cellD, cellC]);
            expect(cellC.hasPathRight).toBeTrue();
            expect(cellD.hasPathLeft).toBeTrue();
        });

        it('should not add a cell if board.getCell returns null', () => {
            const coordsList: Coords[] = [{ x: 10, y: 10 }];
            service.selectedPath = [];
            service.setSelectedPathFromCoords(coordsList, boardStub);
            expect(service.selectedPath).toEqual([]);
        });
    });

    describe('clearService', () => {
        it('should clear selectedPath and reset paths to an empty map', () => {
            service.selectedPath = [cellA];
            service.paths.set({ x: 0, y: 0 }, [{ x: 0, y: 1 }]);
            service.clearService();
            expect(service.selectedPath).toEqual([]);
            expect(service.paths.size).toBe(0);
        });
    });
});

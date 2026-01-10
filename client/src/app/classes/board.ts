import { ErrorMessages } from '@common/error-messages.constants';
import { Coords } from '@app/interfaces/coords';
import { Cell } from './cell';
import { Tile } from './tile';

export class Board {
    matrix: Cell[][];
    size: number;

    constructor(sizeOrData: number | Board) {
        if (typeof sizeOrData === 'number') {
            this.size = sizeOrData;
            this.matrix = this.createMatrix(sizeOrData);
        } else {
            const parsedData = sizeOrData;
            this.size = parsedData.size;
            this.matrix = this.createMatrixFromData(parsedData.matrix);
        }
    }

    getCell(x: number, y: number): Cell | null {
        if (x < 0 || x >= this.size || y < 0 || y >= this.size) {
            return null;
        }
        return this.matrix[x][y];
    }

    setTile(x: number, y: number, tile: Tile): void {
        const cell = this.getCell(x, y);
        if (cell) {
            cell.tile = tile;
        } else {
            throw new Error(`${ErrorMessages.InvalidPosition} (${x}, ${y})`);
        }
    }

    setTileDefault(x: number, y: number): void {
        const cell = this.getCell(x, y);
        if (cell) {
            cell.tile = new Tile('snow');
            cell.removeItem();
        } else {
            throw new Error(`${ErrorMessages.InvalidPosition} (${x}, ${y})`);
        }
    }

    copyBoard(): Board {
        return new Board(this);
    }

    getPlayerById(id: string) {
        for (let i = 0; i < this.size; i++) {
            for (let j = 0; j < this.size; j++) {
                const cell = this.matrix[i][j];
                if (cell.player && cell.player.id === id) {
                    return cell.player;
                }
            }
        }
        return null;
    }

    getPlayerCoordsById(id: string): Coords | null {
        for (let i = 0; i < this.size; i++) {
            for (let j = 0; j < this.size; j++) {
                const cell = this.matrix[i][j];
                if (cell.player && cell.player.id === id) {
                    return { x: i, y: j };
                }
            }
        }
        return null;
    }

    getTwoNearestEmptyCells(coords: Coords): Coords[] {
        const emptyCells: Coords[] = [];
        const visited = new Set<string>();
        const queue: { coords: Coords; distance: number }[] = [];

        queue.push({ coords, distance: 0 });
        visited.add(`${coords.x}-${coords.y}`);

        const directions = [
            { dx: 0, dy: -1 },
            { dx: 0, dy: 1 },
            { dx: -1, dy: 0 },
            { dx: 1, dy: 0 },
            { dx: -1, dy: -1 },
            { dx: 1, dy: -1 },
            { dx: -1, dy: 1 },
            { dx: 1, dy: 1 },
        ];

        while (queue.length > 0 && emptyCells.length < 2) {
            const current = queue.shift();
            if (!current) break;
            const { coords: currentCoords, distance } = current;

            if (distance > 0) {
                const cell = this.getCell(currentCoords.x, currentCoords.y);
                if (cell && this.cellIsEmpty(cell)) {
                    emptyCells.push(currentCoords);
                }
            }

            for (const { dx, dy } of directions) {
                const newX = currentCoords.x + dx;
                const newY = currentCoords.y + dy;
                const key = `${newX}-${newY}`;
                if (newX >= 0 && newX < this.size && newY >= 0 && newY < this.size && !visited.has(key)) {
                    visited.add(key);
                    queue.push({ coords: { x: newX, y: newY }, distance: distance + 1 });
                }
            }
        }
        return emptyCells;
    }

    private cellIsEmpty(cell: Cell): boolean {
        const forbiddenTypes = ['tree', 'wall', 'intersection', 'stone', 'corner', 'door'];
        return !forbiddenTypes.includes(cell.tile.type) && cell.item === null && cell.player === null;
    }

    private createMatrix(size: number): Cell[][] {
        const matrix: Cell[][] = [];

        for (let i = 0; i < size; i++) {
            const row: Cell[] = [];
            for (let j = 0; j < size; j++) {
                const defaultTile = new Tile('snow');
                const newCell = new Cell(defaultTile, i, j);
                row.push(newCell);
            }
            matrix.push(row);
        }

        return matrix;
    }

    private createMatrixFromData(data: Cell[][]): Cell[][] {
        const matrix: Cell[][] = [];

        for (let i = 0; i < data.length; i++) {
            const row: Cell[] = [];
            for (let j = 0; j < data.length; j++) {
                const cellData = data[i][j];
                const newCell = new Cell(new Tile(cellData.tile.type, cellData.tile.orientation, cellData.tile.state), i, j);
                if (cellData.item) {
                    newCell.addItem(cellData.item);
                }
                row.push(newCell);
            }
            matrix.push(row);
        }

        return matrix;
    }
}

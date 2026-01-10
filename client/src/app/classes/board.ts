import { ErrorMessages } from '@app/constants/error-messages.constants';
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

    createMatrix(size: number): Cell[][] {
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

    createMatrixFromData(data: Cell[][]): Cell[][] {
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
            cell.removeItem();
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

    clearBoard() {
        for (let i = 0; i < this.size; i++) {
            for (let j = 0; j < this.size; j++) {
                this.setTileDefault(i, j);
            }
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
}

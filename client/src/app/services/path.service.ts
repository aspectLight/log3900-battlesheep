import { Injectable } from '@angular/core';
import { Cell } from '@app/classes/cell';
import { Coords } from '@app/interfaces/coords';
import { Board } from '@app/classes/board';

@Injectable({
    providedIn: 'root',
})
export class PathService {
    selectedPath: Cell[] = [];
    paths: Map<Coords, Coords[]> = new Map<Coords, Coords[]>();

    setPaths(paths: Map<Coords, Coords[]>): void {
        if (paths.size > 1) this.paths = paths;
        else this.clearService();
    }

    setPathFromCoord(coords: Coords, board: Board): void {
        this.selectedPath = [];
        for (const [coord, cellCoordsArray] of this.paths) {
            if (coord.x === coords.x && coord.y === coords.y) {
                for (const cellCoords of cellCoordsArray) {
                    const cell = board.getCell(cellCoords.x, cellCoords.y);
                    if (!cell) return;

                    this.addToPath(cell);
                }
            }
        }
    }

    addToPath(cell: Cell): void {
        if (this.selectedPath.includes(cell)) return;

        if (this.selectedPath.length === 0 || this.isAdjacent(this.selectedPath[this.selectedPath.length - 1], cell)) {
            this.selectedPath.push(cell);
            this.updatePathConnections();
        }
    }

    clearPath(): void {
        this.selectedPath.forEach((cell) => {
            cell.hasPathUp = false;
            cell.hasPathDown = false;
            cell.hasPathLeft = false;
            cell.hasPathRight = false;
        });
        this.selectedPath = [];
    }

    getSelectedPathAsCoords(): Coords[] {
        return this.selectedPath.map((cell) => ({
            x: cell.x,
            y: cell.y,
        }));
    }

    getAllCellsFromPaths(board: Board): Cell[] {
        const allCells: Cell[] = [];
        for (const cellCoordsArray of this.paths.values()) {
            for (const coords of cellCoordsArray) {
                const cell = board.getCell(coords.x, coords.y);
                if (cell && !allCells.includes(cell)) {
                    allCells.push(cell);
                }
            }
        }
        return allCells;
    }

    setSelectedPathFromCoords(coordsList: Coords[], board: Board): void {
        this.clearPath();

        for (const coords of coordsList) {
            const cell = board.getCell(coords.x, coords.y);
            if (cell) {
                this.selectedPath.push(cell);
            }
        }

        this.updatePathConnections();
    }

    clearService(): void {
        this.clearPath();
        this.paths = new Map<Coords, Coords[]>();
    }

    private isAdjacent(cell1: Cell, cell2: Cell): boolean {
        const dx = Math.abs(cell1.x - cell2.x);
        const dy = Math.abs(cell1.y - cell2.y);
        return (dx === 1 && dy === 0) || (dx === 0 && dy === 1);
    }

    private updatePathConnections(): void {
        for (const cell of this.selectedPath) {
            cell.hasPathUp = false;
            cell.hasPathDown = false;
            cell.hasPathLeft = false;
            cell.hasPathRight = false;
        }

        for (let i = 0; i < this.selectedPath.length - 1; i++) {
            const current = this.selectedPath[i];
            const next = this.selectedPath[i + 1];

            if (next.x === current.x - 1 && next.y === current.y) {
                current.hasPathUp = true;
                next.hasPathDown = true;
            }

            if (next.x === current.x + 1 && next.y === current.y) {
                current.hasPathDown = true;
                next.hasPathUp = true;
            }

            if (next.y === current.y - 1 && next.x === current.x) {
                current.hasPathLeft = true;
                next.hasPathRight = true;
            }

            if (next.y === current.y + 1 && next.x === current.x) {
                current.hasPathRight = true;
                next.hasPathLeft = true;
            }
        }
    }
}

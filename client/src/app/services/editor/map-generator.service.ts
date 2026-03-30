import { Injectable } from '@angular/core';
import { Board } from '@app/classes/board/board';
import { Cell } from '@app/classes/board/cell';
import { Item } from '@app/classes/entity/item';
import { Tile } from '@app/classes/board/tile';
import { AutoTileService } from '@app/services/editor/auto-tile.service';
import { ACCESSIBLE_TILES, TERRAIN_TILES, REQUIRED_OBJECTS } from '@app/constants/game-validation.constants';
import {
    MIN_SPAWN_DISTANCE,
    MIN_BODY_SIZE,
    STRUCTURE_COUNTS,
    SPAWN_COUNTS,
    STRUCTURE_MIN_INTERIOR,
    STRUCTURE_MAX_INTERIOR,
} from '@app/constants/map-generator.constants';

interface StructureRect {
    x: number;
    y: number;
    width: number;
    height: number;
}

/* eslint-disable @typescript-eslint/no-magic-numbers */

@Injectable({
    providedIn: 'root',
})
export class MapGeneratorService {
    private lastBoardHash = '';
    private structureInteriors = new Set<string>();
    private structureWalls = new Set<string>();

    constructor(private autoTileService: AutoTileService) {}

    generate(board: Board, mode: string, waterPercent: number, icePercent: number): void {
        let hash = this.lastBoardHash;
        do {
            this.structureInteriors.clear();
            this.structureWalls.clear();
            this.resetBoard(board);

            const structures = this.placeStructures(board, mode);
            const expectedStructures = STRUCTURE_COUNTS[board.size] || 1;
            if (structures.length < expectedStructures) {
                continue;
            }

            this.placeWaterBodies(board, waterPercent);
            this.placeIceBodies(board, icePercent);

            if (!this.validateCoverage(board) || !this.validateConnectivity(board)) {
                continue;
            }

            if (!this.placeSpawnPoints(board)) {
                continue;
            }

            this.placeItems(board, mode, structures);

            hash = this.computeBoardHash(board);
        } while (hash === this.lastBoardHash);

        this.lastBoardHash = hash;
    }

    private resetBoard(board: Board): void {
        for (let i = 0; i < board.size; i++) {
            for (let j = 0; j < board.size; j++) {
                board.setTile(i, j, new Tile('snow'));
                board.matrix[i][j].removeItem();
            }
        }
    }

    // --- Structures ---

    private placeStructures(board: Board, mode: string): StructureRect[] {
        const count = STRUCTURE_COUNTS[board.size] || 1;
        const structures: StructureRect[] = [];
        const itemPool = this.buildItemPool(board, mode);

        for (let s = 0; s < count; s++) {
            const rect = this.findStructurePosition(board, structures);
            if (!rect) continue;

            structures.push(rect);
            this.buildStructure(board, rect, itemPool);
        }

        return structures;
    }

    private findStructurePosition(board: Board, existing: StructureRect[]): StructureRect | null {
        const maxAttempts = 500;
        for (let attempt = 0; attempt < maxAttempts; attempt++) {
            // After many failed attempts with random sizes, try smaller structures
            let width: number;
            let height: number;
            if (attempt < 300) {
                width = this.randInt(STRUCTURE_MIN_INTERIOR, STRUCTURE_MAX_INTERIOR);
                height = this.randInt(STRUCTURE_MIN_INTERIOR, STRUCTURE_MAX_INTERIOR);
            } else {
                width = STRUCTURE_MIN_INTERIOR;
                height = STRUCTURE_MIN_INTERIOR;
            }

            const maxX = board.size - width - 3;
            const maxY = board.size - height - 3;
            if (maxX < 2 || maxY < 2) continue;

            const x = this.randInt(2, maxX);
            const y = this.randInt(2, maxY);

            const rect: StructureRect = { x, y, width, height };
            if (this.structureOverlaps(rect, existing)) continue;

            return rect;
        }
        return null;
    }

    private structureOverlaps(rect: StructureRect, existing: StructureRect[]): boolean {
        // Wall bounding box for rect: rows [rect.x-1 .. rect.x+rect.height], cols [rect.y-1 .. rect.y+rect.width]
        const rTop = rect.x - 1;
        const rBottom = rect.x + rect.height;
        const rLeft = rect.y - 1;
        const rRight = rect.y + rect.width;

        for (const other of existing) {
            const oTop = other.x - 1;
            const oBottom = other.x + other.height;
            const oLeft = other.y - 1;
            const oRight = other.y + other.width;

            // Require at least 1 empty tile between wall edges (spacing = 2 means no adjacency)
            const spacing = 2;
            if (
                rTop < oBottom + spacing &&
                rBottom + spacing > oTop &&
                rLeft < oRight + spacing &&
                rRight + spacing > oLeft
            ) {
                return true;
            }
        }
        return false;
    }

    private buildStructure(board: Board, rect: StructureRect, itemPool: string[]): void {
        const wallCells: { x: number; y: number }[] = [];

        for (let i = rect.x - 1; i <= rect.x + rect.height; i++) {
            for (let j = rect.y - 1; j <= rect.y + rect.width; j++) {
                const isInterior = i >= rect.x && i < rect.x + rect.height && j >= rect.y && j < rect.y + rect.width;

                if (isInterior) {
                    this.structureInteriors.add(`${i},${j}`);
                } else {
                    board.setTile(i, j, new Tile('wall'));
                    wallCells.push({ x: i, y: j });
                    this.structureWalls.add(`${i},${j}`);
                }
            }
        }

        this.placeDoor(board, rect, wallCells);

        for (const wc of wallCells) {
            this.autoTileService.updateSurroundingTiles(wc.x, wc.y, board);
        }

        if (itemPool.length > 0) {
            const interiorCells = this.getInteriorCells(board, rect);
            if (interiorCells.length > 0) {
                const cell = interiorCells[this.randInt(0, interiorCells.length - 1)];
                const itemType = itemPool.shift()!;
                cell.addItem(new Item(itemType));
            }
        }
    }

    private placeDoor(board: Board, rect: StructureRect, wallCells: { x: number; y: number }[]): void {
        const candidates = wallCells.filter(({ x, y }) => {
            const isCorner =
                (x === rect.x - 1 || x === rect.x + rect.height) && (y === rect.y - 1 || y === rect.y + rect.width);
            if (isCorner) return false;

            const isOnEdge = x === 0 || x === board.size - 1 || y === 0 || y === board.size - 1;
            return !isOnEdge;
        });

        if (candidates.length === 0) return;

        const door = candidates[this.randInt(0, candidates.length - 1)];
        board.setTile(door.x, door.y, new Tile('door'));
        this.structureWalls.delete(`${door.x},${door.y}`);
    }

    private getInteriorCells(board: Board, rect: StructureRect): Cell[] {
        const cells: Cell[] = [];
        for (let i = rect.x; i < rect.x + rect.height; i++) {
            for (let j = rect.y; j < rect.y + rect.width; j++) {
                const cell = board.getCell(i, j);
                if (cell && cell.tile.type === 'snow' && !cell.item) {
                    cells.push(cell);
                }
            }
        }
        return cells;
    }

    // --- Water & Ice Bodies ---

    private placeWaterBodies(board: Board, waterPercent: number): void {
        this.placeBodyTiles(board, waterPercent, 'water');
    }

    private placeIceBodies(board: Board, icePercent: number): void {
        this.placeBodyTiles(board, icePercent, 'ice');
    }

    private placeBodyTiles(board: Board, percent: number, tileType: string): void {
        if (percent <= 0) return;

        const totalTiles = board.size * board.size;
        const targetCount = Math.floor((totalTiles * percent) / 100);
        if (targetCount === 0) return;

        let placed = 0;
        let consecutiveFailures = 0;
        const maxConsecutiveFailures = 20;
        const allPlacedTiles: { x: number; y: number }[] = [];

        while (placed < targetCount && consecutiveFailures < maxConsecutiveFailures) {
            const remaining = targetCount - placed;
            const blobTarget = Math.min(remaining, Math.max(MIN_BODY_SIZE, Math.floor(remaining / 2)));
            const blobTiles = this.growBlob(board, blobTarget, tileType);

            if (blobTiles.length === 0) {
                consecutiveFailures++;
                continue;
            }

            consecutiveFailures = 0;
            placed += blobTiles.length;
            allPlacedTiles.push(...blobTiles);
        }

        for (const tile of allPlacedTiles) {
            this.autoTileService.updateSurroundingTiles(tile.x, tile.y, board);
        }
    }

    private growBlob(board: Board, targetSize: number, tileType: string): { x: number; y: number }[] {
        const placed: { x: number; y: number }[] = [];
        const maxAttempts = 500;

        let startCell: { x: number; y: number } | null = null;
        for (let attempt = 0; attempt < maxAttempts; attempt++) {
            const x = this.randInt(0, board.size - 1);
            const y = this.randInt(0, board.size - 1);
            if (this.isSnowAndFree(board, x, y)) {
                startCell = { x, y };
                break;
            }
        }

        if (!startCell) return placed;

        board.setTile(startCell.x, startCell.y, new Tile(tileType));
        placed.push(startCell);

        const frontier: { x: number; y: number }[] = this.getAdjacentSnowCells(board, startCell.x, startCell.y);

        while (placed.length < targetSize && frontier.length > 0) {
            const idx = this.randInt(0, frontier.length - 1);
            const candidate = frontier[idx];
            frontier.splice(idx, 1);

            if (!this.isSnowAndFree(board, candidate.x, candidate.y)) continue;

            board.setTile(candidate.x, candidate.y, new Tile(tileType));
            placed.push(candidate);

            for (const neighbor of this.getAdjacentSnowCells(board, candidate.x, candidate.y)) {
                if (!frontier.some((f) => f.x === neighbor.x && f.y === neighbor.y)) {
                    frontier.push(neighbor);
                }
            }
        }

        return placed;
    }

    private isSnowAndFree(board: Board, x: number, y: number): boolean {
        const cell = board.getCell(x, y);
        if (!cell) return false;
        return cell.tile.type === 'snow' && !cell.item && !this.structureInteriors.has(`${x},${y}`) && !this.structureWalls.has(`${x},${y}`);
    }

    private getAdjacentSnowCells(board: Board, x: number, y: number): { x: number; y: number }[] {
        const directions = [
            { dx: -1, dy: 0 },
            { dx: 1, dy: 0 },
            { dx: 0, dy: -1 },
            { dx: 0, dy: 1 },
        ];
        const result: { x: number; y: number }[] = [];
        for (const { dx, dy } of directions) {
            const nx = x + dx;
            const ny = y + dy;
            if (nx >= 0 && nx < board.size && ny >= 0 && ny < board.size) {
                if (this.isSnowAndFree(board, nx, ny)) {
                    result.push({ x: nx, y: ny });
                }
            }
        }
        return result;
    }

    // --- Validation helpers ---

    private validateCoverage(board: Board): boolean {
        const totalTiles = board.size * board.size;
        let terrainCount = 0;
        for (let i = 0; i < board.size; i++) {
            for (let j = 0; j < board.size; j++) {
                if (TERRAIN_TILES.includes(board.matrix[i][j].tile.type)) {
                    terrainCount++;
                }
            }
        }
        return terrainCount / totalTiles > 0.5;
    }

    private validateConnectivity(board: Board): boolean {
        const visited = board.matrix.map((row) => row.map(() => false));
        let start: [number, number] | null = null;

        for (let i = 0; i < board.size && !start; i++) {
            for (let j = 0; j < board.size && !start; j++) {
                if (TERRAIN_TILES.includes(board.matrix[i][j].tile.type)) {
                    start = [i, j];
                }
            }
        }

        if (!start) return false;

        const queue: [number, number][] = [start];
        visited[start[0]][start[1]] = true;
        const directions = [
            [-1, 0],
            [1, 0],
            [0, -1],
            [0, 1],
        ];

        while (queue.length > 0) {
            const [x, y] = queue.shift()!;
            for (const [dx, dy] of directions) {
                const nx = x + dx;
                const ny = y + dy;
                if (nx >= 0 && nx < board.size && ny >= 0 && ny < board.size && !visited[nx][ny]) {
                    if (ACCESSIBLE_TILES.includes(board.matrix[nx][ny].tile.type)) {
                        visited[nx][ny] = true;
                        queue.push([nx, ny]);
                    }
                }
            }
        }

        for (let i = 0; i < board.size; i++) {
            for (let j = 0; j < board.size; j++) {
                if (TERRAIN_TILES.includes(board.matrix[i][j].tile.type) && !visited[i][j]) {
                    return false;
                }
            }
        }
        return true;
    }

    // --- Spawn Points ---

    private placeSpawnPoints(board: Board): boolean {
        const count = SPAWN_COUNTS[board.size] || 2;
        const spawnPositions: { x: number; y: number }[] = [];
        const candidates = this.getEligibleSpawnCells(board);

        this.shuffle(candidates);

        for (const candidate of candidates) {
            if (spawnPositions.length >= count) break;

            const farEnough = spawnPositions.every(
                (sp) => Math.abs(sp.x - candidate.x) + Math.abs(sp.y - candidate.y) >= MIN_SPAWN_DISTANCE,
            );

            if (farEnough) {
                spawnPositions.push(candidate);
                const cell = board.getCell(candidate.x, candidate.y)!;
                cell.addItem(new Item('spawnPoint'));
            }
        }

        return spawnPositions.length >= count;
    }

    private getEligibleSpawnCells(board: Board): { x: number; y: number }[] {
        const eligible: { x: number; y: number }[] = [];
        for (let i = 0; i < board.size; i++) {
            for (let j = 0; j < board.size; j++) {
                const cell = board.matrix[i][j];
                if (cell.tile.type === 'snow' && !cell.item && !this.structureInteriors.has(`${i},${j}`)) {
                    eligible.push({ x: i, y: j });
                }
            }
        }
        return eligible;
    }

    // --- Items ---

    private placeItems(board: Board, mode: string, structures: StructureRect[]): void {
        const requiredCount = REQUIRED_OBJECTS.items[board.size] || 2;

        let itemsOnBoard = 0;
        for (let i = 0; i < board.size; i++) {
            for (let j = 0; j < board.size; j++) {
                const cell = board.matrix[i][j];
                if (cell.item && cell.item.type !== 'spawnPoint' && cell.item.type !== 'flag') {
                    itemsOnBoard++;
                }
            }
        }

        const eligible = this.getEligibleItemCells(board);
        this.shuffle(eligible);
        let idx = 0;

        if (mode === 'ctf') {
            const hasFlag = board.matrix.some((row) => row.some((cell) => cell.item?.type === 'flag'));
            if (!hasFlag && idx < eligible.length) {
                const cell = board.getCell(eligible[idx].x, eligible[idx].y)!;
                cell.addItem(new Item('flag'));
                idx++;
            }
        }

        while (itemsOnBoard < requiredCount && idx < eligible.length) {
            const cell = board.getCell(eligible[idx].x, eligible[idx].y)!;
            if (!cell.item) {
                cell.addItem(new Item('random'));
                itemsOnBoard++;
            }
            idx++;
        }
    }

    private getEligibleItemCells(board: Board): { x: number; y: number }[] {
        const eligible: { x: number; y: number }[] = [];
        for (let i = 0; i < board.size; i++) {
            for (let j = 0; j < board.size; j++) {
                const cell = board.matrix[i][j];
                if (
                    TERRAIN_TILES.includes(cell.tile.type) &&
                    !cell.item &&
                    !this.structureInteriors.has(`${i},${j}`)
                ) {
                    eligible.push({ x: i, y: j });
                }
            }
        }
        return eligible;
    }

    private buildItemPool(board: Board, mode: string): string[] {
        const structureCount = STRUCTURE_COUNTS[board.size] || 1;
        const pool: string[] = [];
        for (let i = 0; i < structureCount; i++) {
            pool.push('random');
        }
        return pool;
    }

    // --- Hash ---

    private computeBoardHash(board: Board): string {
        let hash = '';
        for (let i = 0; i < board.size; i++) {
            for (let j = 0; j < board.size; j++) {
                const cell = board.matrix[i][j];
                hash += cell.tile.type[0] + (cell.item?.type[0] || '_');
            }
        }
        return hash;
    }

    // --- Utilities ---

    private randInt(min: number, max: number): number {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    private shuffle<T>(array: T[]): void {
        for (let i = array.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [array[i], array[j]] = [array[j], array[i]];
        }
    }
}

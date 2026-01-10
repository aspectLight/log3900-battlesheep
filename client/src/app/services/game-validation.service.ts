import { Injectable } from '@angular/core';
import { Board } from '@app/classes/board';
import { Cell } from '@app/classes/cell';
import { ErrorMessages, SPECIFIC_ERROR } from '@app/constants/error-messages.constants';
import { ITEM_TYPES } from '@app/constants/item.constants';
import { TILE_TYPES } from '@app/constants/tile.constants';
import { Coords } from '@app/interfaces/coords';
import { SaveValidationResult } from '@app/interfaces/save-validation-result';

const TILES_COVERAGE_PERCENTAGE = 0.5;
const TERRAIN_TILES = Object.keys(TILE_TYPES).filter((key) => ['water', 'ice', 'snow'].includes(key));
const ACCESIBLE_TILES = Object.keys(TILE_TYPES).filter((key) => ['water', 'ice', 'snow', 'door'].includes(key));
const WALL_TYPE_TILES = Object.keys(TILE_TYPES).filter((key) => ['wall', 'corner', 'intersection', 'stone', 'tree'].includes(key));
export const ITEMS = Object.keys(ITEM_TYPES).filter((key) => key !== 'spawnPoint');

const BOARD_SIZES = {
    small: 10,
    medium: 15,
    large: 20,
};

const REQUIRED_OBJECTS = {
    [BOARD_SIZES.small]: 2,
    [BOARD_SIZES.medium]: 4,
    [BOARD_SIZES.large]: 6,
};

@Injectable({
    providedIn: 'root',
})
export class GameValidationService {
    validateGame(name: string, description: string, board: Board): SaveValidationResult[] {
        const nameValidation = this.validateName(name);
        const descriptionValidation = this.validateDescription(description);
        const coverageValidation = this.validateTerrainTilesCoverage(board);
        const spawnPointsValidation = this.validateSpawnPoints(board);
        const itemsValidation = this.validateItems(board);
        const accessibilityValidation = this.validateTerrainTilesAccessibility(board);
        const doorsValidation = this.validateDoors(board);

        return [
            nameValidation,
            descriptionValidation,
            coverageValidation,
            accessibilityValidation,
            spawnPointsValidation,
            itemsValidation,
            ...doorsValidation,
        ].filter((validation) => !validation.isValid);
    }

    validateName(name: string): SaveValidationResult {
        const isValidName = name.trim().length > 0;
        return isValidName ? { isValid: true } : { isValid: false, message: ErrorMessages.GameShouldHaveName };
    }

    validateDescription(description: string): SaveValidationResult {
        const isValidDescription = description.trim().length > 0;
        return isValidDescription ? { isValid: true } : { isValid: false, message: ErrorMessages.GameSoudlHaveDescription };
    }

    validateTerrainTilesCoverage(board: Board): SaveValidationResult {
        const totalTiles = board.size * board.size;
        const basicTiles = board.matrix.reduce((total, row) => {
            return total + row.filter((cell) => TERRAIN_TILES.includes(cell.tile.type)).length;
        }, 0);

        const isValidCoverage = basicTiles / totalTiles > TILES_COVERAGE_PERCENTAGE;

        return isValidCoverage ? { isValid: true } : { isValid: false, message: ErrorMessages.HalfTilesCoverage };
    }

    validateSpawnPoints(board: Board): SaveValidationResult {
        const spawnPoints = board.matrix.reduce((total, row) => {
            return total + row.filter((cell) => cell.item?.type === 'spawnPoint').length;
        }, 0);

        const requiredPoints = REQUIRED_OBJECTS[board.size];

        if (spawnPoints === requiredPoints) {
            return { isValid: true };
        }
        return { isValid: false, message: SPECIFIC_ERROR.minSpawnPoints(requiredPoints) };
    }

    validateItems(board: Board): SaveValidationResult {
        const items = board.matrix.reduce((total, row) => {
            return total + row.filter((cell) => cell.item?.type && ITEMS.includes(cell.item.type)).length;
        }, 0);

        const requiredItems = REQUIRED_OBJECTS[board.size];

        if (items === requiredItems) {
            return { isValid: true };
        }
        return { isValid: false, message: SPECIFIC_ERROR.minItems(requiredItems) };
    }

    validateTerrainTilesAccessibility(board: Board): SaveValidationResult {
        const visited = board.matrix.map((row) => row.map(() => false));
        const startingTile = this.findStartingTile(board);

        if (!startingTile) {
            return { isValid: false, message: ErrorMessages.NoTerrainTiles };
        }

        this.performBFS(board, startingTile, visited);

        const areAllTerrainTilesAccessible = this.areTerrainTilesAccessible(board, visited);
        return areAllTerrainTilesAccessible ? { isValid: true } : { isValid: false, message: ErrorMessages.AllTerrainTilesAccessible };
    }

    validateDoors(board: Board): SaveValidationResult[] {
        const errors: SaveValidationResult[] = [];
        const matrix = board.matrix;
        const rows = matrix.length;
        const cols = matrix[0].length;
        const boardSize = board.size;

        for (let i = 0; i < rows; i++) {
            for (let j = 0; j < cols; j++) {
                if (matrix[i][j].tile.type === 'door') {
                    const isOnEdgeResult = this.isNotOnEdge(i, j, boardSize);
                    if (!isOnEdgeResult.isValid) {
                        errors.push(isOnEdgeResult);
                        continue;
                    }

                    const wallsResult = this.isSurroundedByWalls(matrix, i, j);
                    if (!wallsResult.isValid) {
                        errors.push(wallsResult);
                    }

                    const terrainResult = this.isSurroundedByTerrain(matrix, i, j);
                    if (!terrainResult.isValid) {
                        errors.push(terrainResult);
                    }
                    continue;
                }
            }
        }
        return errors;
    }

    private findStartingTile(board: Board): [number, number] | null {
        const matrix = board.matrix;
        const rows = matrix.length;
        const cols = matrix[0].length;

        for (let i = 0; i < rows; i++) {
            for (let j = 0; j < cols; j++) {
                if (TERRAIN_TILES.includes(matrix[i][j].tile.type)) {
                    return [i, j];
                }
            }
        }
        return null;
    }

    private performBFS(board: Board, startingTile: [number, number], visited: boolean[][]): void {
        const matrix = board.matrix;
        const directions = [
            [-1, 0],
            [1, 0],
            [0, -1],
            [0, 1],
        ];

        const queue: [number, number][] = [startingTile];
        visited[startingTile[0]][startingTile[1]] = true;

        while (queue.length > 0) {
            const current = queue.shift();
            if (current) {
                const x = current[0];
                const y = current[1];

                for (const [offsetX, offsetY] of directions) {
                    const newPos = { x: x + offsetX, y: y + offsetY };
                    if (this.isValidTile(matrix, visited, newPos)) {
                        visited[newPos.x][newPos.y] = true;
                        queue.push([newPos.x, newPos.y]);
                    }
                }
            }
        }
    }

    private isValidTile(matrix: Cell[][], visited: boolean[][], pos: Coords): boolean {
        const { x, y } = pos;
        if (x < 0 || y < 0 || x >= matrix.length || y >= matrix[0].length) {
            return false;
        }
        return ACCESIBLE_TILES.includes(matrix[x][y].tile.type) && !visited[x][y];
    }

    private areTerrainTilesAccessible(board: Board, visited: boolean[][]): boolean {
        const matrix = board.matrix;
        const rows = matrix.length;
        const cols = matrix[0].length;

        for (let i = 0; i < rows; i++) {
            for (let j = 0; j < cols; j++) {
                if (TERRAIN_TILES.includes(matrix[i][j].tile.type) && !visited[i][j]) {
                    return false;
                }
            }
        }
        return true;
    }

    private isNotOnEdge(x: number, y: number, boardSize: number): SaveValidationResult {
        const isOnEdge = x === 0 || x === boardSize - 1 || y === 0 || y === boardSize - 1;
        return isOnEdge ? { isValid: false, message: SPECIFIC_ERROR.notOnEdge(x, y) } : { isValid: true };
    }

    private isSurroundedByWalls(matrix: Cell[][], x: number, y: number): SaveValidationResult {
        const areWallsOnXAxis = WALL_TYPE_TILES.includes(matrix[x][y + 1].tile.type) && WALL_TYPE_TILES.includes(matrix[x][y - 1].tile.type);

        const areWallsOnYAxis = WALL_TYPE_TILES.includes(matrix[x + 1][y].tile.type) && WALL_TYPE_TILES.includes(matrix[x - 1][y].tile.type);

        const isSurroundedByWalls = areWallsOnXAxis || areWallsOnYAxis;

        return isSurroundedByWalls ? { isValid: true } : { isValid: false, message: SPECIFIC_ERROR.surroundedByWalls(x, y) };
    }

    private isSurroundedByTerrain(matrix: Cell[][], x: number, y: number): SaveValidationResult {
        const isTerrainOnXAxis = TERRAIN_TILES.includes(matrix[x][y + 1].tile.type) && TERRAIN_TILES.includes(matrix[x][y - 1].tile.type);

        const isTerrainOnYAxis = TERRAIN_TILES.includes(matrix[x + 1][y].tile.type) && TERRAIN_TILES.includes(matrix[x - 1][y].tile.type);

        const isSurroundedByTerrain = isTerrainOnXAxis || isTerrainOnYAxis;

        return isSurroundedByTerrain ? { isValid: true } : { isValid: false, message: SPECIFIC_ERROR.surroundedByTerrain(x, y) };
    }
}

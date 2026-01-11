import {
    ACCESSIBLE_TILES,
    REQUIRED_OBJECTS,
    TERRAIN_TILES,
    TILES_COVERAGE_PERCENTAGE,
    WALL_TYPE_TILES,
} from '@app/constants/game-validation.constants';
import { ITEM_TYPES } from '@app/constants/item.constants';
import { Board } from '@app/interfaces/board';
import { Cell } from '@app/interfaces/cell';
import { Coords } from '@app/interfaces/coords';
import { GameValidationResult } from '@app/interfaces/game-validation-result';
import { ErrorMessages, SPECIFIC_ERROR } from '@common/error-messages.constants';
import { Injectable } from '@nestjs/common';

export const ITEMS = Object.keys(ITEM_TYPES).filter((key) => key !== 'spawnPoint');

@Injectable()
export class GameValidationService {
    validateGame(name: string, description: string, board: Board, isCTF: boolean): GameValidationResult[] {
        const nameValidation = this.validateName(name);
        const descriptionValidation = this.validateDescription(description);
        const coverageValidation = this.validateTerrainTilesCoverage(board);
        const spawnPointsValidation = this.validateSpawnPoints(board);
        const itemsValidation = this.validateItems(board, isCTF);
        const accessibilityValidation = this.validateTerrainTilesAccessibility(board);
        const doorsValidation = this.validateDoors(board);

        const errors = [
            nameValidation,
            descriptionValidation,
            coverageValidation,
            accessibilityValidation,
            spawnPointsValidation,
            itemsValidation,
            ...doorsValidation,
        ].filter((validation) => !validation.isValid);

        return errors;
    }

    /**
     * Validates the name of the game by checking if it is not empty.
     * @param name The name of the game.
     * @returns A GameValidationResult object.
     */
    validateName(name: string): GameValidationResult {
        const isValidName = name.trim().length > 0;
        return isValidName ? { isValid: true } : { isValid: false, message: ErrorMessages.GameShouldHaveName };
    }

    /**
     * Validates the description of the game by checking if it is not empty.
     * @param description The description of the game.
     * @returns A GameValidationResult object.
     */
    validateDescription(description: string): GameValidationResult {
        const isValidDescription = description.trim().length > 0;
        return isValidDescription ? { isValid: true } : { isValid: false, message: ErrorMessages.GameShouldHaveDescription };
    }

    /**
     * Validates the terrain tiles coverage of the board by checking if it is greater than the required percentage.
     * @param board The board to validate.
     * @returns A GameValidationResult object.
     */
    validateTerrainTilesCoverage(board: Board): GameValidationResult {
        const totalTilesCount = board.size * board.size;
        const basicTilesCount = board.matrix.reduce((total, row) => {
            return total + row.filter((cell) => TERRAIN_TILES.includes(cell.tile.type)).length;
        }, 0);

        const isValidCoverage = basicTilesCount / totalTilesCount > TILES_COVERAGE_PERCENTAGE;

        return isValidCoverage ? { isValid: true } : { isValid: false, message: ErrorMessages.HalfTilesCoverage };
    }

    /**
     * Validates the spawn points of the board by checking if they are equal to the required number.
     * @param board The board to validate.
     * @returns A GameValidationResult object.
     */
    validateSpawnPoints(board: Board): GameValidationResult {
        const spawnPointsCount = board.matrix.reduce((total, row) => {
            return total + row.filter((cell) => cell.item?.type === 'spawnPoint').length;
        }, 0);

        const requiredPointsCount = REQUIRED_OBJECTS.spawnPoints[board.size];

        if (spawnPointsCount < requiredPointsCount.min || spawnPointsCount > requiredPointsCount.max) {
            return { isValid: false, message: SPECIFIC_ERROR.spawnPoints(requiredPointsCount) };
        }

        return { isValid: true };
    }

    /**
     * Validates the items of the board by checking if they are equal to the required number.
     * @param board The board to validate.
     * @param isCTF Whether the game is in CTF mode or not.
     * @returns A GameValidationResult object.
     */
    validateItems(board: Board, isCTF: boolean): GameValidationResult {
        const itemsCount = board.matrix.reduce((total, row) => {
            return total + row.filter((cell) => cell.item?.type && ITEMS.includes(cell.item.type)).length;
        }, 0);

        const hasFlag = board.matrix.some((row) => row.some((cell) => cell.item?.type === 'flag'));

        const requiredItemsCount = REQUIRED_OBJECTS.items[board.size];

        if (isCTF) {
            if (itemsCount === requiredItemsCount && hasFlag) {
                return { isValid: true };
            }
            if (!hasFlag) {
                return { isValid: false, message: ErrorMessages.GameShouldHaveFlag };
            }
            return { isValid: false, message: SPECIFIC_ERROR.items(requiredItemsCount) };
        }

        if (itemsCount === requiredItemsCount) {
            return { isValid: true };
        }
        return { isValid: false, message: SPECIFIC_ERROR.items(requiredItemsCount) };
    }

    /**
     * Validates the accessibility of the terrain tiles by checking if they are all accessible.
     * @param board The board to validate.
     * @returns A GameValidationResult object.
     */
    validateTerrainTilesAccessibility(board: Board): GameValidationResult {
        const visited = board.matrix.map((row) => row.map(() => false));
        const startingTile = this.findStartingTile(board);

        if (!startingTile) {
            return { isValid: false, message: ErrorMessages.NoTerrainTiles };
        }

        this.performBFS(board, startingTile, visited);

        const areAllTerrainTilesAccessible = this.areTerrainTilesAccessible(board, visited);
        return areAllTerrainTilesAccessible ? { isValid: true } : { isValid: false, message: ErrorMessages.AllTerrainTilesAccessible };
    }

    /**
     * Validates the doors on the board by checking if they are on the edge, surrounded by walls and surrounded by terrain.
     * @param board The board to validate.
     * @returns An array of GameValidationResult objects.
     */
    validateDoors(board: Board): GameValidationResult[] {
        const errors: GameValidationResult[] = [];
        const matrix = board.matrix;
        const rows = matrix.length;
        const cols = matrix[0].length;
        const boardSize = board.size;

        for (let i = 0; i < rows; i++) {
            for (let j = 0; j < cols; j++) {
                if (matrix[i][j].tile.type === 'door') {
                    const isOnEdgeResult = this.isOnEdge(i, j, boardSize);
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

    /**
     * Finds the starting tile on the board.
     * @param board The board to search.
     * @returns The starting tile as a [number, number] array, or null if not found.
     */
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

    /**
     * Performs a Breadth-First Search (BFS) to check if all terrain tiles are accessible.
     * Marks the visited tiles as true if they are accessible.
     * @param board The board to validate.
     * @param startingTile The starting tile for the BFS.
     * @param visited A matrix of boolean values indicating whether a tile has been visited.
     */
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

    /**
     * Checks if a tile is valid for the BFS.
     * @param matrix The matrix of cells to validate.
     * @param visited A matrix of boolean values indicating whether a tile has been visited.
     * @param pos The position of the tile to validate.
     * @returns A boolean value indicating whether the tile is valid.
     */
    private isValidTile(matrix: Cell[][], visited: boolean[][], pos: Coords): boolean {
        const { x, y } = pos;
        if (x < 0 || y < 0 || x >= matrix.length || y >= matrix[0].length) {
            return false;
        }
        return ACCESSIBLE_TILES.includes(matrix[x][y].tile.type) && !visited[x][y];
    }

    /**
     * Checks if all terrain tiles are accessible.
     * @param board The board to validate.
     * @param visited A matrix of boolean values indicating whether a tile has been visited.
     * @returns A boolean value indicating whether all terrain tiles are accessible.
     */
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

    /**
     * Checks if a door is on the edge of the board.
     * @param x The x position of the door.
     * @param y The y position of the door.
     * @param boardSize The size of the board.
     * @returns A GameValidationResult object indicating if the door is on the edge (invalid) or not (valid).
     */
    private isOnEdge(x: number, y: number, boardSize: number): GameValidationResult {
        const isOnEdge = x === 0 || x === boardSize - 1 || y === 0 || y === boardSize - 1;
        return isOnEdge ? { isValid: false, message: SPECIFIC_ERROR.notOnEdge(x, y) } : { isValid: true };
    }

    /**
     * Checks if a door is surrounded by walls on the same axis.
     * @param matrix The matrix of cells to validate.
     * @param x The x position of the door.
     * @param y The y position of the door.
     * @returns A GameValidationResult object indicating if the door is surrounded by walls (valid) or not (invalid).
     */
    private isSurroundedByWalls(matrix: Cell[][], x: number, y: number): GameValidationResult {
        const areWallsOnXAxis = WALL_TYPE_TILES.includes(matrix[x][y + 1].tile.type) && WALL_TYPE_TILES.includes(matrix[x][y - 1].tile.type);
        const areWallsOnYAxis = WALL_TYPE_TILES.includes(matrix[x + 1][y].tile.type) && WALL_TYPE_TILES.includes(matrix[x - 1][y].tile.type);
        const isSurroundedByWalls = areWallsOnXAxis || areWallsOnYAxis;

        return isSurroundedByWalls ? { isValid: true } : { isValid: false, message: SPECIFIC_ERROR.surroundedByWalls(x, y) };
    }

    /**
     * Checks if a door is surrounded by terrain on the same axis.
     * @param matrix The matrix of cells to validate.
     * @param x The x position of the door.
     * @param y The y position of the door.
     * @returns A GameValidationResult object indicating if the door is surrounded by terrain (valid) or not (invalid).
     */
    private isSurroundedByTerrain(matrix: Cell[][], x: number, y: number): GameValidationResult {
        const isTerrainOnXAxis = TERRAIN_TILES.includes(matrix[x][y + 1].tile.type) && TERRAIN_TILES.includes(matrix[x][y - 1].tile.type);
        const isTerrainOnYAxis = TERRAIN_TILES.includes(matrix[x + 1][y].tile.type) && TERRAIN_TILES.includes(matrix[x - 1][y].tile.type);
        const isSurroundedByTerrain = isTerrainOnXAxis || isTerrainOnYAxis;

        return isSurroundedByTerrain ? { isValid: true } : { isValid: false, message: SPECIFIC_ERROR.surroundedByTerrain(x, y) };
    }
}

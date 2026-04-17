import { Board } from '@app/modules/game/interfaces/board';
import { Cell } from '@app/modules/game/interfaces/cell';
import { MoveCosts, TileType } from '@app/modules/game/interfaces/tile';
import { GameService } from '@app/modules/game/services/game.service';
import { Coords } from '@app/modules/movement/interfaces/coords';
import { GameRoom } from '@app/modules/shared-room/interfaces/game-room';
import { Item, ItemType } from '@app/shared/interfaces/item';
import { Player } from '@app/shared/interfaces/player';
import { ErrorMessages, SPECIFIC_ERROR } from '@common/error-messages.constants';
import { Injectable } from '@nestjs/common';
@Injectable()
export class GameMovementService {
    private boards: Map<string, Board> = new Map();

    constructor(private readonly gameService: GameService) {}

    private getBoard(roomId: string): Board {
        const board = this.boards.get(roomId);
        if (!board) throw new Error(ErrorMessages.GameDoesNotExist);
        return board;
    }

    toggleDoor(roomId: string, x: number, y: number, room: GameRoom) {
        const board = this.getBoard(roomId);
        const door = board.matrix[x][y];
        if (door.tile.type === TileType.Door) {
            if (!room.globalStats.doorsToggled.find((coord) => coord.x === x && coord.y === y)) {
                room.globalStats.doorsToggled.push({ x, y });
            }
            if (door.tile.state === 'closed') door.tile.state = 'opened';
            else if (door.tile.state === 'opened') door.tile.state = 'closed';
        }
    }

    async addPlayersToBoard(roomId: string, gameId: string, players: Player[]) {
        await this.loadBoard(roomId, gameId);
        const board = this.boards.get(roomId);
        if (!board) throw new Error(ErrorMessages.GameDoesNotExist);
        return this.spawnPlayer(roomId, players);
    }

    removePlayerFromBoard(roomId: string, playerId: string) {
        const board = this.getBoard(roomId);
        const player = board.matrix.flat().find((cell) => cell.player?.id === playerId);
        if (player) player.player = null;
    }

    removeBoard(roomId: string) {
        this.boards.delete(roomId);
    }

    getAllPaths(roomId: string, playerId: string, players: Player[]): Map<Coords, Coords[]> {
        const player = players.find((p) => p.id === playerId);
        if (!player) throw new Error(ErrorMessages.PlayerNotFound);

        const paths: Map<Coords, Coords[]> = new Map<Coords, Coords[]>();
        const { reachableTiles, pathsMap } = this.getReachableTilesAndPaths(roomId, playerId, players);

        for (const coord of reachableTiles) {
            const path = this.getShortestPath(player.position, coord.coord, pathsMap);
            if (!path) throw new Error(`Chemin introuvable pour la cellule (${coord.coord.x},${coord.coord.y})`);
            paths.set(coord.coord, path);
        }

        return paths;
    }

    /**
     * Validates if a path is legal for a player
     * @param roomId - Room identifier
     * @param playerId - Player attempting to move
     * @param path - Full path from start to destination
     * @param players - All players in the game
     * @returns Validation result with cost or error
     */
    validatePath(
        roomId: string,
        playerId: string,
        path: Coords[],
        players: Player[],
    ): { isValid: true; cost: number } | { isValid: false; error: string } {
        const player = players.find((p) => p.id === playerId);
        if (!player) {
            return { isValid: false, error: ErrorMessages.PlayerNotFound };
        }

        if (path.length === 0) {
            return { isValid: true, cost: 0 };
        }

        if (path[0].x !== player.position.x || path[0].y !== player.position.y) {
            return { isValid: false, error: ErrorMessages.PathStartInvalid };
        }

        if (path.length === 1) {
            return { isValid: true, cost: 0 };
        }

        for (let i = 0; i < path.length - 1; i++) {
            const distance = this.getDistance(path[i], path[i + 1]);
            if (distance !== 1) {
                return { isValid: false, error: ErrorMessages.PathNotAdjacent };
            }
        }

        let totalCost = 0;
        for (let i = 1; i < path.length; i++) {
            const cell = this.getCell(roomId, path[i].x, path[i].y);
            if (!cell) {
                return { isValid: false, error: ErrorMessages.CellNotFound };
            }
            if (!this.isCellReachable(cell)) {
                return { isValid: false, error: SPECIFIC_ERROR.cellNotReachable(path[i].x, path[i].y) };
            }
            if (!this.isCellFree(cell, playerId)) {
                return { isValid: false, error: ErrorMessages.CellOccupied };
            }
            totalCost += this.determineCellCost(cell, player);
        }

        if (totalCost > player.movementPoints) {
            return { isValid: false, error: ErrorMessages.InsufficientMovementPoints };
        }

        return { isValid: true, cost: totalCost };
    }

    movePlayer(roomId: string, playerId: string, players: Player[], destination: Coords, isTeleport?: boolean) {
        const targetCell = this.getCell(roomId, destination.x, destination.y);
        if (!targetCell) throw new Error(ErrorMessages.CellNotFound);
        if (!this.isCellFree(targetCell, playerId) || !this.isCellReachable(targetCell)) throw new Error(ErrorMessages.CellOccupied);

        const player = players.find((p) => p.id === playerId);
        if (!player) throw new Error(ErrorMessages.PlayerNotFound);

        const startCell = this.getCell(roomId, player.position.x, player.position.y);

        if (isTeleport) {
            if (startCell) startCell.player = null;
            player.position = { x: targetCell.x, y: targetCell.y };
            targetCell.player = player;
            return;
        }
        const reachableTilesAndPaths = this.getReachableTilesAndPaths(roomId, playerId, players);
        if (!reachableTilesAndPaths) throw new Error(ErrorMessages.PathCalculationError);
        const { costMap } = reachableTilesAndPaths;

        const destinationKey = `${destination.x},${destination.y}`;
        if (!costMap.has(destinationKey)) throw new Error(ErrorMessages.UnreachableDestination);

        const cost = costMap.get(destinationKey);
        if (cost > player.movementPoints) {
            throw new Error(ErrorMessages.InsufficientMovementPoints);
        }

        if (startCell) startCell.player = null;
        player.position = { x: targetCell.x, y: targetCell.y };
        player.movementPoints = player.movementPoints - cost;
        targetCell.player = player;
        return player.movementPoints;
    }

    getReachableTilesAndPaths(
        roomId: string,
        playerId: string,
        players: Player[],
        checkForPlayer?: boolean,
    ): {
        reachableTiles: { coord: Coords; cost: number }[];
        pathsMap: Map<string, Coords>;
        costMap: Map<string, number>;
    } | null {
        const player = players.find((p) => p.id === playerId);
        if (!player) throw new Error(ErrorMessages.PlayerNotFound);

        const costMap = new Map<string, number>();
        const pathsMap = new Map<string, Coords>();
        const queue: { coord: Coords; cost: number }[] = [{ coord: { x: player.position.x, y: player.position.y }, cost: 0 }];
        const reachableTiles: { coord: Coords; cost: number }[] = [];

        costMap.set(`${player.position.x},${player.position.y}`, 0);
        reachableTiles.push({ coord: { x: player.position.x, y: player.position.y }, cost: 0 });

        while (queue.length > 0) {
            queue.sort((a, b) => a.cost - b.cost);
            const {
                coord: { x, y },
                cost,
            } = queue.shift();
            const key = `${x},${y}`;
            if (costMap.get(key) < cost || cost > player.movementPoints) continue;
            const neighbors = [
                { x, y: y - 1 },
                { x, y: y + 1 },
                { x: x - 1, y },
                { x: x + 1, y },
            ];

            for (const { x: nx, y: ny } of neighbors) {
                const neighborCell = this.getCell(roomId, nx, ny);
                const neighborKey = `${nx},${ny}`;

                if (!neighborCell) continue;
                if (checkForPlayer) {
                    if (!this.isCellReachable(neighborCell)) continue;
                } else {
                    if (!this.isCellFree(neighborCell, playerId) || !this.isCellReachable(neighborCell)) continue;
                }
                const newCost = cost + this.determineCellCost(neighborCell, player);

                if (!costMap.has(neighborKey) || newCost < costMap.get(neighborKey)) {
                    costMap.set(neighborKey, newCost);
                    pathsMap.set(neighborKey, { x, y });

                    if (newCost <= player.movementPoints) {
                        queue.push({ coord: { x: nx, y: ny }, cost: newCost });
                        reachableTiles.push({ coord: { x: nx, y: ny }, cost: newCost });
                    }
                }
            }
        }
        return { reachableTiles, pathsMap, costMap };
    }

    determineCellCost(cell: Cell, player: Player) {
        const type = cell.tile.type;
        if (player.hasBoots && type === 'water') return MoveCosts['WaterWithBoots'];
        return MoveCosts[type.replace(/^\w/, (c) => c.toUpperCase())];
    }

    getShortestPath(playerPosition: Coords, destination: Coords, pathsMap: Map<string, Coords>): Coords[] | null {
        const destinationKey = `${destination.x},${destination.y}`;
        if (!pathsMap.has(destinationKey) && !(destination.x === playerPosition.x && destination.y === playerPosition.y))
            throw new Error(ErrorMessages.PathNotFound);

        const path: Coords[] = [];
        let current = { x: destination.x, y: destination.y };

        while (!(current.x === playerPosition.x && current.y === playerPosition.y)) {
            path.unshift(current);
            const key = `${current.x},${current.y}`;
            current = pathsMap.get(key);
        }

        path.unshift({ x: playerPosition.x, y: playerPosition.y });
        return path;
    }

    getBoardForGame(roomId: string): Board | null {
        return this.boards.get(roomId) || null;
    }

    getCell(roomId: string, x: number, y: number): Cell | null {
        const board = this.getBoard(roomId);
        if (x < 0 || y < 0 || x >= board.size || y >= board.size) return null;
        return board.matrix[x][y];
    }

    isCellReachable(cell: Cell): boolean {
        if (!cell) return false;
        if (['wall', 'tree', 'stone', 'corner', 'intersection'].includes(cell.tile.type)) return false;
        if (cell.tile.type === TileType.Door && cell.tile.state !== 'opened') return false;
        return true;
    }

    isCellFree(cell: Cell, playerId?: string): boolean {
        if (!cell || cell.player) {
            if (playerId) {
                if (cell.player.id === playerId) return true;
            }
            return false;
        }
        return true;
    }

    getDistance(firstCoord: Coords, secondCoord: Coords) {
        return Math.abs(secondCoord.x - firstCoord.x) + Math.abs(secondCoord.y - firstCoord.y);
    }

    addItemToBoard(roomId: string, item: Item, position: Coords) {
        const cell = this.getCell(roomId, position.x, position.y);
        if (cell) cell.item = item;
    }

    removeItemFromBoard(roomId: string, position: Coords) {
        const cell = this.getCell(roomId, position.x, position.y);
        if (cell) cell.item = null;
    }

    getAllDoors(roomId: string): number {
        const board = this.getBoard(roomId);
        let doors = 0;
        for (let i = 0; i < board.size; i++) {
            for (let j = 0; j < board.size; j++) {
                if (board.matrix[i][j].tile.type === TileType.Door) {
                    doors++;
                }
            }
        }
        return doors;
    }

    getWalkableTiles(roomId: string): number {
        const board = this.getBoard(roomId);
        const nonWalkableTypes = new Set([TileType.Wall, TileType.Tree, TileType.Stone]);
        let walkableTiles = 0;
        for (let i = 0; i < board.size; i++) {
            for (let j = 0; j < board.size; j++) {
                const tile = this.getCell(roomId, i, j).tile;
                if (!nonWalkableTypes.has(tile.type)) {
                    walkableTiles++;
                }
            }
        }
        return walkableTiles;
    }

    private async loadBoard(roomId: string, gameId: string): Promise<Board | null> {
        const game = await this.gameService.getGameBlueprintById(gameId);
        if (game && game.board) {
            // Deep copy so each game gets its own independent board
            const boardCopy: Board = JSON.parse(JSON.stringify(game.board));
            this.boards.set(roomId, boardCopy);
            return boardCopy;
        }
        return null;
    }

    private spawnPlayer(roomId: string, players: Player[]): Player[] {
        const board = this.getBoard(roomId);
        const spawnPoints: Cell[] = board.matrix.flat().filter((cell: Cell) => cell.item && cell.item.type === ItemType.SpawnPoint && !cell.player);
        if (spawnPoints.length < players.length) throw new Error(ErrorMessages.NotEnoughSpawnPoints);

        for (let i = spawnPoints.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [spawnPoints[i], spawnPoints[j]] = [spawnPoints[j], spawnPoints[i]];
        }

        for (let i = 0; i < players.length; i++) {
            const spawnCell = spawnPoints[i];
            players[i].spawnPoint = { x: spawnCell.x, y: spawnCell.y };
            players[i].position = { x: spawnCell.x, y: spawnCell.y };
            board.matrix[spawnCell.x][spawnCell.y].player = players[i];
        }
        return players;
    }

    spawnSinglePlayer(roomId: string, player: Player, activePlayers: Player[]): Player {
        const board = this.getBoard(roomId);

        // Find spawn points not already assigned to an active player's spawnPoint
        const occupiedSpawnPoints = new Set(activePlayers.filter((p) => p.spawnPoint).map((p) => `${p.spawnPoint.x},${p.spawnPoint.y}`));

        const unassignedSpawnPoints: Cell[] = board.matrix
            .flat()
            .filter((cell: Cell) => cell.item && cell.item.type === ItemType.SpawnPoint && !occupiedSpawnPoints.has(`${cell.x},${cell.y}`));

        // Among unassigned spawn points, prefer ones that are physically free
        const freeSpawnPoints = unassignedSpawnPoints.filter((cell) => !cell.player);

        if (freeSpawnPoints.length > 0) {
            const randomIndex = Math.floor(Math.random() * freeSpawnPoints.length);
            const spawnCell = freeSpawnPoints[randomIndex];
            player.spawnPoint = { x: spawnCell.x, y: spawnCell.y };
            player.position = { x: spawnCell.x, y: spawnCell.y };
            spawnCell.player = player;
            return player;
        }

        // All unassigned spawn points are physically occupied: fall back to the nearest free walkable tile
        const candidateSpawnPoints =
            unassignedSpawnPoints.length > 0
                ? unassignedSpawnPoints
                : board.matrix.flat().filter((cell: Cell) => cell.item && cell.item.type === ItemType.SpawnPoint);

        if (candidateSpawnPoints.length === 0) throw new Error(ErrorMessages.NotEnoughSpawnPoints);

        const origin = candidateSpawnPoints[Math.floor(Math.random() * candidateSpawnPoints.length)];
        const nearestFreeCell = this.findNearestFreeWalkableCell(roomId, origin.x, origin.y);

        if (!nearestFreeCell) throw new Error(ErrorMessages.NotEnoughSpawnPoints);

        player.spawnPoint = { x: origin.x, y: origin.y };
        player.position = { x: nearestFreeCell.x, y: nearestFreeCell.y };
        nearestFreeCell.player = player;
        return player;
    }

    extractCoord(element: Coords | { coord: Coords; cost: number }): Coords {
        return 'coord' in element ? element.coord : element;
    }

    private findNearestFreeWalkableCell(roomId: string, startX: number, startY: number): Cell | null {
        const visited = new Set<string>();
        const queue: { x: number; y: number }[] = [{ x: startX, y: startY }];
        visited.add(`${startX},${startY}`);

        while (queue.length > 0) {
            const { x, y } = queue.shift();
            const cell = this.getCell(roomId, x, y);
            if (cell && this.isCellReachable(cell) && !cell.player) {
                return cell;
            }
            for (const [dx, dy] of [
                [-1, 0],
                [1, 0],
                [0, -1],
                [0, 1],
            ]) {
                const nx = x + dx;
                const ny = y + dy;
                const key = `${nx},${ny}`;
                if (!visited.has(key)) {
                    visited.add(key);
                    queue.push({ x: nx, y: ny });
                }
            }
        }
        return null;
    }
}

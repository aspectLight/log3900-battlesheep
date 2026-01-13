import { Board } from '@app/interfaces/board';
import { Cell } from '@app/interfaces/cell';
import { Coords } from '@app/interfaces/coords';
import { GameRoom } from '@app/interfaces/game-room';
import { Item, ItemType } from '@app/interfaces/item';
import { Player } from '@app/interfaces/player';
import { MoveCosts, TileType } from '@app/interfaces/tile';
import { GameService } from '@app/services/game/game.service';
import { ErrorMessages, SPECIFIC_ERROR } from '@common/error-messages.constants';
import { Injectable } from '@nestjs/common';
@Injectable()
export class GameMovementService {
    private board: Board | null = null;

    constructor(private readonly gameService: GameService) {}

    toggleDoor(x: number, y: number, room: GameRoom) {
        const door = this.board.matrix[x][y];
        if (door.tile.type === TileType.Door) {
            if (!room.globalStats.doorsToggled.find((coord) => coord.x === x && coord.y === y)) {
                room.globalStats.doorsToggled.push({ x, y });
            }
            if (door.tile.state === 'closed') door.tile.state = 'opened';
            else if (door.tile.state === 'opened') door.tile.state = 'closed';
        }
    }

    async addPlayersToBoard(gameId: string, players: Player[]) {
        await this.loadBoard(gameId);
        if (!this.board) throw new Error(ErrorMessages.GameDoesNotExist);
        return this.spawnPlayer(players);
    }

    removePlayerFromBoard(playerId: string) {
        const player = this.board.matrix.flat().find((cell) => cell.player?.id === playerId);
        if (player) player.player = null;
    }

    getAllPaths(playerId: string, players: Player[]): Map<Coords, Coords[]> {
        const player = players.find((p) => p.id === playerId);
        if (!player) throw new Error(ErrorMessages.PlayerNotFound);

        const paths: Map<Coords, Coords[]> = new Map<Coords, Coords[]>();
        const { reachableTiles, pathsMap } = this.getReachableTilesAndPaths(playerId, players);

        for (const coord of reachableTiles) {
            const path = this.getShortestPath(player.position, coord.coord, pathsMap);
            if (!path) throw new Error(`Chemin introuvable pour la cellule (${coord.coord.x},${coord.coord.y})`);
            paths.set(coord.coord, path);
        }

        return paths;
    }

    /**
     * Validates if a path is legal for a player
     * @param playerId - Player attempting to move
     * @param path - Full path from start to destination
     * @param players - All players in the game
     * @returns Validation result with cost or error
     */
    validatePath(playerId: string, path: Coords[], players: Player[]): { isValid: true; cost: number } | { isValid: false; error: string } {
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
            const cell = this.getCell(path[i].x, path[i].y);
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

    movePlayer(playerId: string, players: Player[], destination: Coords, isTeleport?: boolean) {
        const targetCell = this.getCell(destination.x, destination.y);
        if (!targetCell) throw new Error(ErrorMessages.CellNotFound);
        if (!this.isCellFree(targetCell, playerId) || !this.isCellReachable(targetCell)) throw new Error(ErrorMessages.CellOccupied);

        const player = players.find((p) => p.id === playerId);
        if (!player) throw new Error(ErrorMessages.PlayerNotFound);

        const startCell = this.getCell(player.position.x, player.position.y);

        if (isTeleport) {
            if (startCell) startCell.player = null;
            player.position = targetCell;
            targetCell.player = player;
            return;
        }
        const reachableTilesAndPaths = this.getReachableTilesAndPaths(playerId, players);
        if (!reachableTilesAndPaths) throw new Error(ErrorMessages.PathCalculationError);
        const reachableTiles = reachableTilesAndPaths.reachableTiles;

        const targetTile = reachableTiles.find((tile) => tile.coord.x === destination.x && tile.coord.y === destination.y);
        if (!targetTile) throw new Error(ErrorMessages.UnreachableDestination);

        if (targetTile.cost > player.movementPoints) {
            throw new Error(ErrorMessages.InsufficientMovementPoints);
        }

        if (startCell) startCell.player = null;
        player.position = targetCell;
        player.movementPoints = player.movementPoints - targetTile.cost;
        targetCell.player = player;
        return player.movementPoints;
    }

    getReachableTilesAndPaths(
        playerId: string,
        players: Player[],
        checkForPlayer?: boolean,
    ): {
        reachableTiles: { coord: Coords; cost: number }[];
        pathsMap: Map<string, Coords>;
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
                const neighborCell = this.getCell(nx, ny);
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
        return { reachableTiles, pathsMap };
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

    getCell(x: number, y: number): Cell | null {
        if (x < 0 || y < 0 || x >= this.board.size || y >= this.board.size) return null;
        return this.board.matrix[x][y];
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

    addItemToBoard(item: Item, position: Coords) {
        const cell = this.getCell(position.x, position.y);
        if (cell) cell.item = item;
    }

    removeItemFromBoard(position: Coords) {
        const cell = this.getCell(position.x, position.y);
        if (cell) cell.item = null;
    }

    getAllDoors(): number {
        let doors = 0;
        for (let i = 0; i < this.board.size; i++) {
            for (let j = 0; j < this.board.size; j++) {
                if (this.board.matrix[i][j].tile.type === TileType.Door) {
                    doors++;
                }
            }
        }
        return doors;
    }

    getWalkableTiles(): number {
        const nonWalkableTypes = new Set([TileType.Wall, TileType.Tree, TileType.Stone]);
        let walkableTiles = 0;
        for (let i = 0; i < this.board.size; i++) {
            for (let j = 0; j < this.board.size; j++) {
                const tile = this.getCell(i, j).tile;
                if (!nonWalkableTypes.has(tile.type)) {
                    walkableTiles++;
                }
            }
        }
        return walkableTiles;
    }

    private async loadBoard(gameId: string): Promise<Board | null> {
        const game = await this.gameService.getGameById(gameId);
        this.board = game ? game.board : null;
        return this.board;
    }

    private spawnPlayer(players: Player[]): Player[] {
        const spawnPoints: Cell[] = this.board.matrix.flat().filter((cell) => cell.item && cell.item.type === ItemType.SpawnPoint && !cell.player);
        if (spawnPoints.length < players.length) throw new Error(ErrorMessages.NotEnoughSpawnPoints);

        for (let i = spawnPoints.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [spawnPoints[i], spawnPoints[j]] = [spawnPoints[j], spawnPoints[i]];
        }

        for (let i = 0; i < players.length; i++) {
            const spawnCell = spawnPoints[i];
            players[i].spawnPoint = { x: spawnCell.x, y: spawnCell.y };
            players[i].position = { x: spawnCell.x, y: spawnCell.y };
            this.board.matrix[spawnCell.x][spawnCell.y].player = players[i];
        }
        return players;
    }
}

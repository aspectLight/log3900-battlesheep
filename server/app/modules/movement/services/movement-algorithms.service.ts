import { Cell } from '@app/modules/game/interfaces/cell';
import { Coords } from '@app/modules/movement/interfaces/coords';
import { ItemType } from '@app/shared/interfaces/item';
import { Player } from '@app/shared/interfaces/player';
import { MoveCosts } from '@app/modules/game/interfaces/tile';
import { GameMovementService } from '@app/modules/movement/services/game-movement.service';
import { GameRoomService } from '@app/modules/shared-room/services/game-room.service';
import { Injectable } from '@nestjs/common';

@Injectable()
export class MovementAlgorithmsService {
    constructor(
        private readonly gameMovementService: GameMovementService,
        private readonly gameRoomService: GameRoomService,
    ) {}

    findNeighborPlayer(player: Player, isCTF?: boolean) {
        const playerPosition = player.position;
        const neighbors: Coords[] = [
            { x: playerPosition.x, y: playerPosition.y - 1 },
            { x: playerPosition.x, y: playerPosition.y + 1 },
            { x: playerPosition.x - 1, y: playerPosition.y },
            { x: playerPosition.x + 1, y: playerPosition.y },
        ];
        for (const neighbor of neighbors) {
            const cell = this.gameMovementService.getCell(neighbor.x, neighbor.y);
            if (cell && cell.player) {
                if (isCTF && this.gameRoomService.isOpponent(player, cell.player, isCTF)) return cell.player;
                else if (!isCTF) return cell.player;
            }
        }
    }

    findSpawnPoint(player: Player, opponent?: Player) {
        const queue: { coord: Coords; cost: number }[] = [{ coord: player.position, cost: 0 }];
        const costMap = new Map<string, number>();
        const pathMap = new Map<string, Coords>();

        costMap.set(`${player.position.x},${player.position.y}`, 0);

        while (queue.length > 0) {
            queue.sort((a, b) => a.cost - b.cost);
            const current = queue.shift();
            const key = `${current.coord.x},${current.coord.y}`;

            if (costMap.get(key) < current.cost) continue;

            const cell = this.gameMovementService.getCell(current.coord.x, current.coord.y);
            const spawnPoint = opponent ? opponent.spawnPoint : player.spawnPoint;
            if (cell && cell.x === spawnPoint.x && cell.y === spawnPoint.y) {
                const path = this.gameMovementService.getShortestPath(player.position, current.coord, pathMap);
                return { path, cost: current.cost };
            }

            const neighbors: Coords[] = [
                { x: current.coord.x, y: current.coord.y - 1 },
                { x: current.coord.x, y: current.coord.y + 1 },
                { x: current.coord.x - 1, y: current.coord.y },
                { x: current.coord.x + 1, y: current.coord.y },
            ];

            for (const neighbor of neighbors) {
                const neighborKey = `${neighbor.x},${neighbor.y}`;

                const neighborCell = this.gameMovementService.getCell(neighbor.x, neighbor.y);
                if (!neighborCell || !this.gameMovementService.isCellReachable(neighborCell)) continue;

                const tileType = neighborCell.tile.type.replace(/^\w/, (c) => c.toUpperCase());
                const newCost = neighborKey === `${player.position.x},${player.position.y}` ? 0 : current.cost + MoveCosts[tileType];

                if (!costMap.has(neighborKey) || newCost < costMap.get(neighborKey)) {
                    costMap.set(neighborKey, newCost);
                    pathMap.set(neighborKey, current.coord);
                    queue.push({ coord: neighbor, cost: newCost });
                }
            }
        }
        return null;
    }

    findClosestItem(start: Coords, predicate: (cell: Cell) => boolean, playerId?: string) {
        const queue: { coord: Coords; cost: number }[] = [{ coord: start, cost: 0 }];
        const costMap = new Map<string, number>();
        const pathMap = new Map<string, Coords>();

        costMap.set(`${start.x},${start.y}`, 0);

        while (queue.length > 0) {
            queue.sort((a, b) => a.cost - b.cost);
            const current = queue.shift();
            const key = `${current.coord.x},${current.coord.y}`;

            if (costMap.get(key) < current.cost) continue;

            const cell = this.gameMovementService.getCell(current.coord.x, current.coord.y);
            if (cell && predicate(cell)) {
                const path = this.gameMovementService.getShortestPath(start, current.coord, pathMap);
                return { path, cost: current.cost };
            }

            const neighbors: Coords[] = [
                { x: current.coord.x, y: current.coord.y - 1 },
                { x: current.coord.x, y: current.coord.y + 1 },
                { x: current.coord.x - 1, y: current.coord.y },
                { x: current.coord.x + 1, y: current.coord.y },
            ];

            for (const neighbor of neighbors) {
                const neighborKey = `${neighbor.x},${neighbor.y}`;

                const neighborCell = this.gameMovementService.getCell(neighbor.x, neighbor.y);
                if (
                    !neighborCell ||
                    !this.gameMovementService.isCellFree(neighborCell, playerId) ||
                    !this.gameMovementService.isCellReachable(neighborCell)
                )
                    continue;

                const tileType = neighborCell.tile.type.replace(/^\w/, (c) => c.toUpperCase());
                const newCost = neighborKey === `${start.x},${start.y}` ? 0 : current.cost + MoveCosts[tileType];

                if (!costMap.has(neighborKey) || newCost < costMap.get(neighborKey)) {
                    costMap.set(neighborKey, newCost);
                    pathMap.set(neighborKey, current.coord);
                    queue.push({ coord: neighbor, cost: newCost });
                }
            }
        }
        return null;
    }

    findClosestPlayer(player: Player, isCTF?: boolean) {
        const queue: { coord: Coords; cost: number }[] = [{ coord: player.position, cost: 0 }];
        const pathMap = new Map<string, Coords>();
        const costMap = new Map<string, number>();

        costMap.set(`${player.position.x},${player.position.y}`, 0);

        while (queue.length > 0) {
            queue.sort((a, b) => a.cost - b.cost);
            const current = queue.shift();
            const key = `${current.coord.x},${current.coord.y}`;

            if (costMap.get(key) < current.cost) continue;

            const cell = this.gameMovementService.getCell(current.coord.x, current.coord.y);
            if (cell && cell.player && this.gameRoomService.isOpponent(player, cell.player, isCTF)) {
                if (isCTF && this.gameRoomService.isOpponentCarryingFlag(player, cell.player)) {
                    const path = this.gameMovementService.getShortestPath(player.position, current.coord, pathMap);
                    return { path, cost: current.cost };
                }
                if (!isCTF) {
                    const path = this.gameMovementService.getShortestPath(player.position, current.coord, pathMap);
                    return { path, cost: current.cost };
                }
            }

            const neighbors: Coords[] = [
                { x: current.coord.x, y: current.coord.y - 1 },
                { x: current.coord.x, y: current.coord.y + 1 },
                { x: current.coord.x - 1, y: current.coord.y },
                { x: current.coord.x + 1, y: current.coord.y },
            ];

            for (const neighbor of neighbors) {
                const neighborKey = `${neighbor.x},${neighbor.y}`;

                const neighborCell = this.gameMovementService.getCell(neighbor.x, neighbor.y);
                if (!neighborCell || !this.gameMovementService.isCellReachable(neighborCell)) continue;

                const tileType = neighborCell.tile.type.replace(/^\w/, (c) => c.toUpperCase());
                const newCost = neighborKey === `${player.position}` ? 0 : current.cost + MoveCosts[tileType];

                if (!costMap.has(neighborKey) || newCost < costMap.get(neighborKey)) {
                    costMap.set(neighborKey, newCost);
                    pathMap.set(neighborKey, current.coord);
                    queue.push({ coord: neighbor, cost: newCost });
                }
            }
        }
        return null;
    }

    findWayToTarget(player: Player, target: Coords, reachableTiles: { coord: Coords; cost: number }[], pathsMap: Map<string, Coords>) {
        const isTargetReachable = reachableTiles.some((tile) => tile.coord.x === target.x && tile.coord.y === target.y);
        if (!isTargetReachable) return null;

        const targetCell = this.gameMovementService.getCell(target.x, target.y);
        if (!targetCell) return null;

        const neighbors: Coords[] = [
            { x: target.x, y: target.y - 1 },
            { x: target.x, y: target.y + 1 },
            { x: target.x - 1, y: target.y },
            { x: target.x + 1, y: target.y },
        ];

        const reachableNeighbors = neighbors.filter((neighbor) => {
            const isReachable = reachableTiles.some((tile) => tile.coord.x === neighbor.x && tile.coord.y === neighbor.y);
            return isReachable;
        });

        const freeReachableNeighbors = reachableNeighbors.filter((neighbor) => {
            const cell = this.gameMovementService.getCell(neighbor.x, neighbor.y);
            const isFree = cell && this.gameMovementService.isCellFree(cell, player.id) && this.gameMovementService.isCellReachable(cell);
            return isFree;
        });

        if (freeReachableNeighbors.length > 0) {
            const closestTiles = freeReachableNeighbors
                .map((neighbor) => {
                    const distance = this.gameMovementService.getDistance(player.position, neighbor);
                    const neighborPath = this.gameMovementService.getShortestPath(player.position, neighbor, pathsMap);
                    if (!neighborPath || neighborPath.length === 0) return null;

                    let isPathFree = true;
                    for (const coord of neighborPath) {
                        const pathCell = this.gameMovementService.getCell(coord.x, coord.y);
                        if (!pathCell || !this.gameMovementService.isCellFree(pathCell, player.id)) {
                            isPathFree = false;
                            break;
                        }
                    }
                    return isPathFree ? { distance, neighborPath } : null;
                })
                .filter((tile) => tile !== null);
            if (closestTiles.length === 0) return null;
            const closestTile = closestTiles.reduce((closest, current) => {
                return closest.distance < current.distance ? closest : current;
            });
            const closestNeighbor = closestTile.neighborPath[closestTile.neighborPath.length - 1];
            const destination = reachableTiles.find((tile) => tile.coord.x === closestNeighbor.x && tile.coord.y === closestNeighbor.y);
            if (!destination) return null;

            return { path: closestTile.neighborPath, destination };
        }
        return null;
    }

    truncatePath(path: Coords[], movementPoints: number, startPoint: Coords) {
        let accumulatedCost = 0;
        const truncatedPath: { coord: Coords; cost: number }[] = [];

        for (const coord of path) {
            const cell = this.gameMovementService.getCell(coord.x, coord.y);
            const tileType = cell.tile.type.replace(/^\w/, (c) => c.toUpperCase());
            const moveCost = coord.x === startPoint.x && coord.y === startPoint.y ? 0 : MoveCosts[tileType];
            if (accumulatedCost + moveCost > movementPoints) break;
            accumulatedCost += moveCost;
            truncatedPath.push({ coord, cost: accumulatedCost });
        }
        return truncatedPath;
    }

    lookForItemInPath(path: Coords[]) {
        const truncatedPath: Coords[] = [];
        let totalCost = 0;
        for (const coord of path) {
            const cell = this.gameMovementService.getCell(coord.x, coord.y);
            truncatedPath.push(coord);
            const tileType = cell.tile.type.replace(/^\w/, (c) => c.toUpperCase());
            totalCost += MoveCosts[tileType];
            if (cell && cell.item && cell.item.type !== ItemType.SpawnPoint) {
                return { path: truncatedPath, cost: totalCost };
            }
        }
        return { path, cost: totalCost };
    }
}

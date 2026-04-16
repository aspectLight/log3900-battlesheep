import { Cell } from '@app/modules/game/interfaces/cell';
import { Coords } from '@app/modules/movement/interfaces/coords';
import { AggressiveItemType, DefensiveItemType, ItemType } from '@app/shared/interfaces/item';
import { Player, VirtualPlayerType } from '@app/shared/interfaces/player';
import { GameMovementService } from '@app/modules/movement/services/game-movement.service';
import { Injectable } from '@nestjs/common';
import { MovementAlgorithmsService } from '@app/modules/movement/services/movement-algorithms.service';
import { GameRoomService } from '@app/modules/shared-room/services/game-room.service';

@Injectable()
export class GameMovementVPService {
    constructor(
        private readonly gameMovementService: GameMovementService,
        private readonly movementAlgorithms: MovementAlgorithmsService,
        private readonly gameRoomService: GameRoomService,
    ) {}

    determineVPMovement(roomId: string, player: Player, players: Player[], isCTF?: boolean) {
        if (isCTF) return this.determineCTFAction(roomId, player, players);
        return player.profile === VirtualPlayerType.Aggressive
            ? this.determineAggressiveAction(roomId, player, players)
            : this.determineDefensiveAction(roomId, player, players);
    }

    determineCTFAction(roomId: string, player: Player, players: Player[]) {
        const reachableData = this.gameMovementService.getReachableTilesAndPaths(roomId, player.id, players, true);
        if (!reachableData) return null;
        const { reachableTiles, pathsMap, costMap } = reachableData;

        if (this.gameRoomService.isCarryingFlag(player)) {
            return this.goToSpawnPoint(roomId, player, reachableTiles, pathsMap, undefined, costMap);
        }

        const flagItem = this.movementAlgorithms.findClosestItem(roomId, player.position, this.hasFlagItem);
        if (flagItem) return this.goCloserToTarget(roomId, player, flagItem.path);

        const allyWithFlag = this.gameRoomService.isFlagWithOurTeam(player);
        if (allyWithFlag) {
            const movement = this.chaseOpponent(roomId, player, reachableTiles, pathsMap, undefined, costMap);
            if (movement) return movement;
        } else if (!allyWithFlag) {
            if (player.profile === VirtualPlayerType.Aggressive) {
                const movement = this.chaseOpponent(roomId, player, reachableTiles, pathsMap, true, costMap);
                if (movement) return movement;
            } else if (player.profile === 'defensive') {
                const opponentWithFlag = this.findOpponentWithFlag(player, players);
                if (opponentWithFlag) return this.goToSpawnPoint(roomId, player, reachableTiles, pathsMap, opponentWithFlag, costMap);
            }
        }
        return this.goToSpawnPoint(roomId, player, reachableTiles, pathsMap, undefined, costMap);
    }

    determineAggressiveAction(roomId: string, player: Player, players: Player[]) {
        const emptyPath: Coords[] = [];
        const reachableData = this.gameMovementService.getReachableTilesAndPaths(roomId, player.id, players, true);
        if (!reachableData) return null;
        const { reachableTiles, pathsMap, costMap } = reachableData;

        const neighborOpponentTarget = this.movementAlgorithms.findNeighborPlayer(roomId, player);
        if (neighborOpponentTarget) return { path: emptyPath, remainingMovementPoints: player.movementPoints };
        const opponentTarget = this.findReachablePlayer(roomId, player, reachableTiles);
        if (opponentTarget) {
            const { path, destination } = this.movementAlgorithms.findWayToTarget(roomId, player, opponentTarget.coord, reachableTiles, pathsMap);
            if (!path || !destination) return null;
            const itemPathData = this.movementAlgorithms.lookForItemInPath(roomId, path);
            if (itemPathData) {
                const remainingMovementPointsItem = this.moveVirtualPlayer(roomId, player, {
                    coord: itemPathData.path[itemPathData.path.length - 1],
                    cost: itemPathData.cost,
                }, costMap);
                return {
                    path: itemPathData.path,
                    remainingMovementPoints: remainingMovementPointsItem,
                };
            }
            const remainingMovementPoints = this.moveVirtualPlayer(roomId, player, destination, costMap);
            return { path, remainingMovementPoints };
        }

        const itemTarget = this.findReachableItem(roomId, player, reachableTiles);
        if (itemTarget) return this.goForReachableTarget(roomId, player, itemTarget, pathsMap, costMap);

        let movement = this.goForDistantTarget(roomId, player, 'player');
        if (movement) return movement;

        movement = this.goForDistantTarget(roomId, player, 'item');
        if (movement) return movement;

        if (player.inventory.length < 2) {
            const randomItemTarget = this.findReachableRandomItem(roomId, player, reachableTiles);
            if (randomItemTarget) return this.goForReachableTarget(roomId, player, randomItemTarget, pathsMap, costMap);
            movement = this.goForDistantTarget(roomId, player, 'random');
            if (movement) return movement;
        }

        return this.goToSpawnPoint(roomId, player, reachableTiles, pathsMap, undefined, costMap);
    }

    determineDefensiveAction(roomId: string, player: Player, players: Player[]) {
        const emptyPath: Coords[] = [];
        const reachableData = this.gameMovementService.getReachableTilesAndPaths(roomId, player.id, players, true);
        if (!reachableData) return null;
        const { reachableTiles, pathsMap, costMap } = reachableData;

        const itemTarget = this.findReachableItem(roomId, player, reachableTiles);
        if (itemTarget) return this.goForReachableTarget(roomId, player, itemTarget, pathsMap, costMap);

        const neighborOpponentTarget = this.movementAlgorithms.findNeighborPlayer(roomId, player);
        if (neighborOpponentTarget) return { path: emptyPath, remainingMovementPoints: player.movementPoints };

        const opponentTarget = this.findReachablePlayer(roomId, player, reachableTiles);
        if (opponentTarget) {
            const { path, destination } = this.movementAlgorithms.findWayToTarget(roomId, player, opponentTarget.coord, reachableTiles, pathsMap);
            if (!path || !destination) return null;
            const itemPathData = this.movementAlgorithms.lookForItemInPath(roomId, path);
            if (itemPathData) {
                const remainingMovementPointsItem = this.moveVirtualPlayer(roomId, player, {
                    coord: itemPathData.path[itemPathData.path.length - 1],
                    cost: itemPathData.cost,
                }, costMap);
                return {
                    path: itemPathData.path,
                    remainingMovementPoints: remainingMovementPointsItem,
                };
            }
            const remainingMovementPoints = this.moveVirtualPlayer(roomId, player, destination, costMap);
            return { path, remainingMovementPoints };
        }

        const itemMovement = this.goForDistantTarget(roomId, player, 'item');
        if (itemMovement) return itemMovement;

        const playerMovement = this.goForDistantTarget(roomId, player, 'player');
        if (playerMovement) return playerMovement;

        if (player.inventory.length < 2) {
            const randomItemTarget = this.findReachableRandomItem(roomId, player, reachableTiles);
            if (randomItemTarget) return this.goForReachableTarget(roomId, player, randomItemTarget, pathsMap, costMap);
            const movement = this.goForDistantTarget(roomId, player, 'random');
            if (movement) return movement;
        }
        return this.goToSpawnPoint(roomId, player, reachableTiles, pathsMap, undefined, costMap);
    }

    goForReachableTarget(roomId: string, player: Player, target: { coord: Coords; cost: number }, pathsMap: Map<string, Coords>, costMap?: Map<string, number>) {
        const path = this.gameMovementService.getShortestPath(player.position, target.coord, pathsMap);
        const remainingMovementPoints = this.moveVirtualPlayer(roomId, player, target, costMap);
        return { path, remainingMovementPoints };
    }

    goForDistantTarget(roomId: string, player: Player, targetType: 'item' | 'player' | 'random') {
        if (targetType === 'player') {
            const closestOpponent = this.movementAlgorithms.findClosestPlayer(roomId, player);
            if (closestOpponent) return this.goCloserToTarget(roomId, player, closestOpponent.path);
        } else if (targetType === 'item') {
            const closestItem =
                player.profile === VirtualPlayerType.Aggressive
                    ? this.movementAlgorithms.findClosestItem(roomId, player.position, this.hasAggressiveItem)
                    : this.movementAlgorithms.findClosestItem(roomId, player.position, this.hasDefensiveItem);
            if (closestItem) return this.goCloserToTarget(roomId, player, closestItem.path);
        } else if (targetType === 'random') {
            const closestItem = this.movementAlgorithms.findClosestItem(roomId, player.position, this.hasItem);
            if (closestItem) return this.goCloserToTarget(roomId, player, closestItem.path);
        }
    }

    goCloserToTarget(roomId: string, player: Player, wayToTarget: Coords[]) {
        const truncatedPath = this.movementAlgorithms.truncatePath(roomId, wayToTarget, player.movementPoints, player.position);
        if (truncatedPath.length === 0) return { path: [], remainingMovementPoints: player.movementPoints };
        const destination = truncatedPath[truncatedPath.length - 1];
        const remainingMovementPoints = this.moveVirtualPlayer(roomId, player, destination);
        return { path: truncatedPath, remainingMovementPoints };
    }

    goToSpawnPoint(roomId: string, player: Player, reachableTiles: { coord: Coords; cost: number }[], pathsMap: Map<string, Coords>, otherPlayer?: Player, costMap?: Map<string, number>) {
        const emptyPath: Coords[] = [];
        const isAtSpawnPoint = (movingPlayer: Player, targetSpawnPoint: Coords) =>
            movingPlayer.position.x === targetSpawnPoint.x && movingPlayer.position.y === targetSpawnPoint.y;

        if (otherPlayer && isAtSpawnPoint(player, otherPlayer.spawnPoint)) {
            return { path: emptyPath, remainingMovementPoints: player.movementPoints };
        } else if (!otherPlayer && isAtSpawnPoint(player, player.spawnPoint)) {
            return { path: emptyPath, remainingMovementPoints: player.movementPoints };
        }

        const spawnPoint = otherPlayer
            ? this.gameMovementService.getCell(roomId, otherPlayer.spawnPoint.x, otherPlayer.spawnPoint.y)
            : this.gameMovementService.getCell(roomId, player.spawnPoint.x, player.spawnPoint.y);

        const reachableSpawnPoint = otherPlayer
            ? this.findReachableSpawnPoint(roomId, player, reachableTiles, otherPlayer)
            : this.findReachableSpawnPoint(roomId, player, reachableTiles);

        if (reachableSpawnPoint) {
            if (this.gameMovementService.isCellFree(spawnPoint, player.id)) return this.goForReachableTarget(roomId, player, reachableSpawnPoint, pathsMap, costMap);
            else {
                const neighborOpponentTarget = this.movementAlgorithms.findNeighborPlayer(roomId, player, true);
                if (neighborOpponentTarget) {
                    return { path: emptyPath, remainingMovementPoints: player.movementPoints };
                } else {
                    const spawnPointCoords = { x: spawnPoint.x, y: spawnPoint.y };
                    const { path, destination } = this.movementAlgorithms.findWayToTarget(roomId, player, spawnPointCoords, reachableTiles, pathsMap);
                    if (!path || !destination) return { path: emptyPath, remainingMovementPoints: player.movementPoints };
                    const remainingMovementPoints = this.moveVirtualPlayer(roomId, player, destination, costMap);
                    return { path, remainingMovementPoints };
                }
            }
        }

        const distantSpawnPoint = otherPlayer
            ? this.movementAlgorithms.findSpawnPoint(roomId, player, otherPlayer)
            : this.movementAlgorithms.findSpawnPoint(roomId, player);

        if (!distantSpawnPoint || !distantSpawnPoint.path) return { path: emptyPath, remainingMovementPoints: player.movementPoints };
        return this.goCloserToTarget(roomId, player, distantSpawnPoint.path);
    }

    chaseOpponent(roomId: string, player: Player, reachableTiles: { coord: Coords; cost: number }[], pathsMap: Map<string, Coords>, withFlag?: boolean, costMap?: Map<string, number>) {
        const reachableOpponent = withFlag
            ? this.findReachableOpponentWithFlag(roomId, player, reachableTiles)
            : this.findReachableOpponent(roomId, player, reachableTiles);
        if (reachableOpponent) {
            const { path, destination } = this.movementAlgorithms.findWayToTarget(roomId, player, reachableOpponent.coord, reachableTiles, pathsMap);
            if (!path || !destination) return null;
            const itemPathData = this.movementAlgorithms.lookForItemInPath(roomId, path);
            if (itemPathData) {
                const remainingMovementPointsItem = this.moveVirtualPlayer(roomId, player, {
                    coord: itemPathData.path[itemPathData.path.length - 1],
                    cost: itemPathData.cost,
                }, costMap);
                return {
                    path: itemPathData.path,
                    remainingMovementPoints: remainingMovementPointsItem,
                };
            }
            const remainingMovementPoints = this.moveVirtualPlayer(roomId, player, destination, costMap);
            return { path, remainingMovementPoints };
        }

        const distantOpponent = withFlag
            ? this.movementAlgorithms.findClosestPlayer(roomId, player, true)
            : this.movementAlgorithms.findClosestPlayer(roomId, player);
        if (distantOpponent) return this.goCloserToTarget(roomId, player, distantOpponent.path);
        return null;
    }

    moveVirtualPlayer(roomId: string, player: Player, destination: { coord: Coords; cost: number }, costMap?: Map<string, number>) {
        const destinationCell = this.gameMovementService.getCell(roomId, destination.coord.x, destination.coord.y);
        if (!destinationCell) throw new Error('Case introuvable');
        if (!this.gameMovementService.isCellFree(destinationCell, player.id) || !this.gameMovementService.isCellReachable(destinationCell))
            return null;

        const cost = costMap ? (costMap.get(`${destination.coord.x},${destination.coord.y}`) ?? destination.cost) : destination.cost;
        const startCell = this.gameMovementService.getCell(roomId, player.position.x, player.position.y);
        startCell.player = null;
        player.position = { x: destinationCell.x, y: destinationCell.y };
        player.movementPoints = player.movementPoints - cost;
        destinationCell.player = player;
        return player.movementPoints;
    }

    findReachablePlayer(roomId: string, player: Player, reachableTiles: { coord: Coords; cost: number }[], isCTF?: boolean) {
        return reachableTiles.find((tile) => {
            const cell = this.gameMovementService.getCell(roomId, tile.coord.x, tile.coord.y);
            if (isCTF) return cell && cell.player && this.gameRoomService.isOpponent(player, cell.player, isCTF);
            return cell && cell.player && cell.player.id !== player.id;
        });
    }

    findReachableRandomItem(roomId: string, player: Player, reachableTiles: { coord: Coords; cost: number }[]) {
        return reachableTiles.find((tile) => {
            const cell = this.gameMovementService.getCell(roomId, tile.coord.x, tile.coord.y);
            return cell && this.hasItem(cell) && !cell.player;
        });
    }

    findReachableItem(roomId: string, player: Player, reachableTiles: { coord: Coords; cost: number }[]) {
        return reachableTiles.find((tile) => {
            const cell = this.gameMovementService.getCell(roomId, tile.coord.x, tile.coord.y);
            return (
                cell && (player.profile === VirtualPlayerType.Aggressive ? this.hasAggressiveItem(cell) : this.hasDefensiveItem(cell)) && !cell.player
            );
        });
    }

    findReachableSpawnPoint(roomId: string, player: Player, reachableTiles: { coord: Coords; cost: number }[], opponent?: Player) {
        return reachableTiles.find((tile) => {
            const cell = this.gameMovementService.getCell(roomId, tile.coord.x, tile.coord.y);
            if (opponent) return cell && cell.x === opponent.spawnPoint.x && cell.y === opponent.spawnPoint.y;
            return cell && cell.x === player.spawnPoint.x && cell.y === player.spawnPoint.y;
        });
    }

    findReachableOpponentWithFlag(roomId: string, player: Player, reachableTiles: { coord: Coords; cost: number }[]) {
        return reachableTiles.find((tile) => {
            const cell = this.gameMovementService.getCell(roomId, tile.coord.x, tile.coord.y);
            return cell && cell.player && cell.player.id !== player.id && this.gameRoomService.isOpponentCarryingFlag(player, cell.player);
        });
    }

    findReachableOpponent(roomId: string, player: Player, reachableTiles: { coord: Coords; cost: number }[]) {
        return reachableTiles.find((tile) => {
            const cell = this.gameMovementService.getCell(roomId, tile.coord.x, tile.coord.y);
            return cell && cell.player && this.gameRoomService.isOpponent(player, cell.player, true);
        });
    }

    findOpponentWithFlag(player: Player, players: Player[]) {
        return players.find((opponent) => {
            if (this.gameRoomService.isOpponentCarryingFlag(player, opponent)) return opponent;
        });
    }

    hasItem(cell: Cell): boolean {
        return !!cell.item && cell.item.type !== ItemType.SpawnPoint && Object.values(ItemType).includes(cell.item.type as ItemType);
    }

    hasDefensiveItem(cell: Cell): boolean {
        return !!cell.item && Object.values(DefensiveItemType).includes(cell.item.type as DefensiveItemType);
    }

    hasAggressiveItem(cell: Cell): boolean {
        return !!cell.item && Object.values(AggressiveItemType).includes(cell.item.type as AggressiveItemType);
    }

    hasFlagItem(cell: Cell): boolean {
        return !!cell.item && cell.item.type === ItemType.Flag;
    }
}

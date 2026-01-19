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

    determineVPMovement(player: Player, players: Player[], isCTF?: boolean) {
        if (isCTF) return this.determineCTFAction(player, players);
        return player.profile === VirtualPlayerType.Aggressive
            ? this.determineAggressiveAction(player, players)
            : this.determineDefensiveAction(player, players);
    }

    determineCTFAction(player: Player, players: Player[]) {
        const reachableData = this.gameMovementService.getReachableTilesAndPaths(player.id, players, true);
        if (!reachableData) return null;
        const { reachableTiles, pathsMap } = reachableData;

        if (this.gameRoomService.isCarryingFlag(player)) {
            return this.goToSpawnPoint(player, reachableTiles, pathsMap);
        }

        const flagItem = this.movementAlgorithms.findClosestItem(player.position, this.hasFlagItem);
        if (flagItem) return this.goCloserToTarget(player, flagItem.path);

        const allyWithFlag = this.gameRoomService.isFlagWithOurTeam(player);
        if (allyWithFlag) {
            const movement = this.chaseOpponent(player, reachableTiles, pathsMap);
            if (movement) return movement;
        } else if (!allyWithFlag) {
            if (player.profile === VirtualPlayerType.Aggressive) {
                const movement = this.chaseOpponent(player, reachableTiles, pathsMap, true);
                if (movement) return movement;
            } else if (player.profile === 'defensive') {
                const opponentWithFlag = this.findOpponentWithFlag(player, players);
                if (opponentWithFlag) return this.goToSpawnPoint(player, reachableTiles, pathsMap, opponentWithFlag);
            }
        }
        return this.goToSpawnPoint(player, reachableTiles, pathsMap);
    }

    determineAggressiveAction(player: Player, players: Player[]) {
        const emptyPath: Coords[] = [];
        const reachableData = this.gameMovementService.getReachableTilesAndPaths(player.id, players, true);
        if (!reachableData) return null;
        const { reachableTiles, pathsMap } = reachableData;

        const neighborOpponentTarget = this.movementAlgorithms.findNeighborPlayer(player);
        if (neighborOpponentTarget) return { path: emptyPath, remainingMovementPoints: player.movementPoints };
        const opponentTarget = this.findReachablePlayer(player, reachableTiles);
        if (opponentTarget) {
            const { path, destination } = this.movementAlgorithms.findWayToTarget(player, opponentTarget.coord, reachableTiles, pathsMap);
            if (!path || !destination) return null;
            const itemPathData = this.movementAlgorithms.lookForItemInPath(path);
            if (itemPathData) {
                const remainingMovementPointsItem = this.moveVirtualPlayer(player, {
                    coord: itemPathData.path[itemPathData.path.length - 1],
                    cost: itemPathData.cost,
                });
                return {
                    path: itemPathData.path,
                    remainingMovementPoints: remainingMovementPointsItem,
                };
            }
            const remainingMovementPoints = this.moveVirtualPlayer(player, destination);
            return { path, remainingMovementPoints };
        }

        const itemTarget = this.findReachableItem(player, reachableTiles);
        if (itemTarget) return this.goForReachableTarget(player, itemTarget, pathsMap);

        let movement = this.goForDistantTarget(player, 'player');
        if (movement) return movement;

        movement = this.goForDistantTarget(player, 'item');
        if (movement) return movement;

        if (player.inventory.length < 2) {
            const randomItemTarget = this.findReachableRandomItem(player, reachableTiles);
            if (randomItemTarget) return this.goForReachableTarget(player, randomItemTarget, pathsMap);
            movement = this.goForDistantTarget(player, 'random');
            if (movement) return movement;
        }

        return this.goToSpawnPoint(player, reachableTiles, pathsMap);
    }

    determineDefensiveAction(player: Player, players: Player[]) {
        const emptyPath: Coords[] = [];
        const reachableData = this.gameMovementService.getReachableTilesAndPaths(player.id, players, true);
        if (!reachableData) return null;
        const { reachableTiles, pathsMap } = reachableData;

        const itemTarget = this.findReachableItem(player, reachableTiles);
        if (itemTarget) return this.goForReachableTarget(player, itemTarget, pathsMap);

        const neighborOpponentTarget = this.movementAlgorithms.findNeighborPlayer(player);
        if (neighborOpponentTarget) return { path: emptyPath, remainingMovementPoints: player.movementPoints };

        const opponentTarget = this.findReachablePlayer(player, reachableTiles);
        if (opponentTarget) {
            const { path, destination } = this.movementAlgorithms.findWayToTarget(player, opponentTarget.coord, reachableTiles, pathsMap);
            if (!path || !destination) return null;
            const itemPathData = this.movementAlgorithms.lookForItemInPath(path);
            if (itemPathData) {
                const remainingMovementPointsItem = this.moveVirtualPlayer(player, {
                    coord: itemPathData.path[itemPathData.path.length - 1],
                    cost: itemPathData.cost,
                });
                return {
                    path: itemPathData.path,
                    remainingMovementPoints: remainingMovementPointsItem,
                };
            }
            const remainingMovementPoints = this.moveVirtualPlayer(player, destination);
            return { path, remainingMovementPoints };
        }

        const itemMovement = this.goForDistantTarget(player, 'item');
        if (itemMovement) return itemMovement;

        const playerMovement = this.goForDistantTarget(player, 'player');
        if (playerMovement) return playerMovement;

        if (player.inventory.length < 2) {
            const randomItemTarget = this.findReachableRandomItem(player, reachableTiles);
            if (randomItemTarget) return this.goForReachableTarget(player, randomItemTarget, pathsMap);
            const movement = this.goForDistantTarget(player, 'random');
            if (movement) return movement;
        }
        return this.goToSpawnPoint(player, reachableTiles, pathsMap);
    }

    goForReachableTarget(player: Player, target: { coord: Coords; cost: number }, pathsMap: Map<string, Coords>) {
        const path = this.gameMovementService.getShortestPath(player.position, target.coord, pathsMap);
        const remainingMovementPoints = this.moveVirtualPlayer(player, target);
        return { path, remainingMovementPoints };
    }

    goForDistantTarget(player: Player, targetType: 'item' | 'player' | 'random') {
        if (targetType === 'player') {
            const closestOpponent = this.movementAlgorithms.findClosestPlayer(player);
            if (closestOpponent) return this.goCloserToTarget(player, closestOpponent.path);
        } else if (targetType === 'item') {
            const closestItem =
                player.profile === VirtualPlayerType.Aggressive
                    ? this.movementAlgorithms.findClosestItem(player.position, this.hasAggressiveItem)
                    : this.movementAlgorithms.findClosestItem(player.position, this.hasDefensiveItem);
            if (closestItem) return this.goCloserToTarget(player, closestItem.path);
        } else if (targetType === 'random') {
            const closestItem = this.movementAlgorithms.findClosestItem(player.position, this.hasItem);
            if (closestItem) return this.goCloserToTarget(player, closestItem.path);
        }
    }

    goCloserToTarget(player: Player, wayToTarget: Coords[]) {
        const truncatedPath = this.movementAlgorithms.truncatePath(wayToTarget, player.movementPoints, player.position);
        const destination = truncatedPath[truncatedPath.length - 1];
        const remainingMovementPoints = this.moveVirtualPlayer(player, destination);
        return { path: truncatedPath, remainingMovementPoints };
    }

    goToSpawnPoint(player: Player, reachableTiles: { coord: Coords; cost: number }[], pathsMap: Map<string, Coords>, otherPlayer?: Player) {
        const emptyPath: Coords[] = [];
        const isAtSpawnPoint = (movingPlayer: Player, targetSpawnPoint: Coords) =>
            movingPlayer.position.x === targetSpawnPoint.x && movingPlayer.position.y === targetSpawnPoint.y;

        if (otherPlayer && isAtSpawnPoint(player, otherPlayer.spawnPoint)) {
            return { path: emptyPath, remainingMovementPoints: player.movementPoints };
        } else if (!otherPlayer && isAtSpawnPoint(player, player.spawnPoint)) {
            return { path: emptyPath, remainingMovementPoints: player.movementPoints };
        }

        const spawnPoint = otherPlayer
            ? this.gameMovementService.getCell(otherPlayer.spawnPoint.x, otherPlayer.spawnPoint.y)
            : this.gameMovementService.getCell(player.spawnPoint.x, player.spawnPoint.y);

        const reachableSpawnPoint = otherPlayer
            ? this.findReachableSpawnPoint(player, reachableTiles, otherPlayer)
            : this.findReachableSpawnPoint(player, reachableTiles);

        if (reachableSpawnPoint) {
            if (this.gameMovementService.isCellFree(spawnPoint, player.id)) return this.goForReachableTarget(player, reachableSpawnPoint, pathsMap);
            else {
                const neighborOpponentTarget = this.movementAlgorithms.findNeighborPlayer(player, true);
                if (!neighborOpponentTarget) {
                    return { path: emptyPath, remainingMovementPoints: player.movementPoints };
                } else {
                    const spawnPointCoords = { x: spawnPoint.x, y: spawnPoint.y };
                    const { path, destination } = this.movementAlgorithms.findWayToTarget(player, spawnPointCoords, reachableTiles, pathsMap);
                    if (!path || !destination) return null;
                    const remainingMovementPoints = this.moveVirtualPlayer(player, destination);
                    return { path, remainingMovementPoints };
                }
            }
        }

        const distantSpawnPoint = otherPlayer
            ? this.movementAlgorithms.findSpawnPoint(player, otherPlayer)
            : this.movementAlgorithms.findSpawnPoint(player);

        if (!distantSpawnPoint || !distantSpawnPoint.path) return null;
        return this.goCloserToTarget(player, distantSpawnPoint.path);
    }

    chaseOpponent(player: Player, reachableTiles: { coord: Coords; cost: number }[], pathsMap: Map<string, Coords>, withFlag?: boolean) {
        const reachableOpponent = withFlag
            ? this.findReachableOpponentWithFlag(player, reachableTiles)
            : this.findReachableOpponent(player, reachableTiles);
        if (reachableOpponent) {
            const { path, destination } = this.movementAlgorithms.findWayToTarget(player, reachableOpponent.coord, reachableTiles, pathsMap);
            if (!path || !destination) return null;
            const itemPathData = this.movementAlgorithms.lookForItemInPath(path);
            if (itemPathData) {
                const remainingMovementPointsItem = this.moveVirtualPlayer(player, {
                    coord: itemPathData.path[itemPathData.path.length - 1],
                    cost: itemPathData.cost,
                });
                return {
                    path: itemPathData.path,
                    remainingMovementPoints: remainingMovementPointsItem,
                };
            }
            const remainingMovementPoints = this.moveVirtualPlayer(player, destination);
            return { path, remainingMovementPoints };
        }

        const distantOpponent = withFlag
            ? this.movementAlgorithms.findClosestPlayer(player, true)
            : this.movementAlgorithms.findClosestPlayer(player);
        if (distantOpponent) return this.goCloserToTarget(player, distantOpponent.path);
    }

    moveVirtualPlayer(player: Player, destination: { coord: Coords; cost: number }) {
        const destinationCell = this.gameMovementService.getCell(destination.coord.x, destination.coord.y);
        if (!destinationCell) throw new Error('Case introuvable');
        if (!this.gameMovementService.isCellFree(destinationCell, player.id) || !this.gameMovementService.isCellReachable(destinationCell))
            return null;

        const startCell = this.gameMovementService.getCell(player.position.x, player.position.y);
        startCell.player = null;
        player.position = destinationCell;
        player.movementPoints = player.movementPoints - destination.cost;
        destinationCell.player = player;
        return player.movementPoints;
    }

    findReachablePlayer(player: Player, reachableTiles: { coord: Coords; cost: number }[], isCTF?: boolean) {
        return reachableTiles.find((tile) => {
            const cell = this.gameMovementService.getCell(tile.coord.x, tile.coord.y);
            if (isCTF) return cell && cell.player && this.gameRoomService.isOpponent(player, cell.player, isCTF);
            return cell && cell.player && cell.player.id !== player.id;
        });
    }

    findReachableRandomItem(player: Player, reachableTiles: { coord: Coords; cost: number }[]) {
        return reachableTiles.find((tile) => {
            const cell = this.gameMovementService.getCell(tile.coord.x, tile.coord.y);
            return cell && this.hasItem(cell) && !cell.player;
        });
    }

    findReachableItem(player: Player, reachableTiles: { coord: Coords; cost: number }[]) {
        return reachableTiles.find((tile) => {
            const cell = this.gameMovementService.getCell(tile.coord.x, tile.coord.y);
            return (
                cell && (player.profile === VirtualPlayerType.Aggressive ? this.hasAggressiveItem(cell) : this.hasDefensiveItem(cell)) && !cell.player
            );
        });
    }

    findReachableSpawnPoint(player: Player, reachableTiles: { coord: Coords; cost: number }[], opponent?: Player) {
        return reachableTiles.find((tile) => {
            const cell = this.gameMovementService.getCell(tile.coord.x, tile.coord.y);
            if (opponent) return cell && cell.x === opponent.spawnPoint.x && cell.y === opponent.spawnPoint.y;
            return cell && cell.x === player.spawnPoint.x && cell.y === player.spawnPoint.y;
        });
    }

    findReachableOpponentWithFlag(player: Player, reachableTiles: { coord: Coords; cost: number }[]) {
        return reachableTiles.find((tile) => {
            const cell = this.gameMovementService.getCell(tile.coord.x, tile.coord.y);
            return cell && cell.player && cell.player.id !== player.id && this.gameRoomService.isOpponentCarryingFlag(player, cell.player);
        });
    }

    findReachableOpponent(player: Player, reachableTiles: { coord: Coords; cost: number }[]) {
        return reachableTiles.find((tile) => {
            const cell = this.gameMovementService.getCell(tile.coord.x, tile.coord.y);
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

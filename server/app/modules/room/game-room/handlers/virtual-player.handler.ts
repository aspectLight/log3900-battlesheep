import { GameCombatService } from '@app/modules/combat/services/game-combat.service';
import { TileType } from '@app/modules/game/interfaces/tile';
import { GameMovementService } from '@app/modules/movement/services/game-movement.service';
import { MovementAlgorithmsService } from '@app/modules/movement/services/movement-algorithms.service';
import { MIN_TURN_DELAY, MAX_TURN_DELAY } from '@app/modules/shared-room/constants/game-room.constants';
import { Coords } from '@app/modules/movement/interfaces/coords';
import { GameRoom } from '@app/modules/shared-room/interfaces/game-room';
import { GameRoomService } from '@app/modules/shared-room/services/game-room.service';
import { Player } from '@app/shared/interfaces/player';
import { GameMovementVPService } from '@app/modules/virtual-players/services/game-movement-vp.service';
import { GameRoomEvents } from '@common/socket.constants';
import { Injectable } from '@nestjs/common';
import { Server, Socket } from 'socket.io';
import { TrapHandler } from './trap.handler';

/**
 * Handler for virtual player-related events in the game room
 */
@Injectable()
export class VirtualPlayerHandler {
    constructor(
        private readonly gameRoomService: GameRoomService,
        private readonly gameCombatService: GameCombatService,
        private readonly gameMovementVPService: GameMovementVPService,
        private readonly movementAlgorithms: MovementAlgorithmsService,
        private readonly trapHandler: TrapHandler,
        private readonly gameMovementService: GameMovementService,
    ) {}

    /**
     * Handles virtual player turn logic
     */
    handleVirtualPlayerTurn(data: { roomId: string; playerId: string; isCTF: boolean; skipTimeout: boolean }, socket: Socket, server: Server): void {
        try {
            const room = this.gameRoomService.findRoomById(data.roomId);
            const player = room.players.find((p) => p.id === data.playerId);
            if (!player) return;

            setTimeout(
                () => {
                    try {
                        // Guard: if the board was removed (e.g. game ended / user left), bail out silently
                        if (!this.gameMovementService.getBoardForGame(data.roomId)) return;

                        // Guard: if it's no longer this player's turn, bail out
                        if (!this.gameRoomService.isPlayerTurn(data.roomId, data.playerId)) return;

                        const originalMovementPoints = player.movementPoints;
                        const originalPosition = { ...player.position };

                        const movement = this.gameMovementVPService.determineVPMovement(data.roomId, player, room.players, data.isCTF);
                        if (!movement) {
                            this.gameRoomService.endTurn(data.roomId);
                            return;
                        }
                        const neighborPlayer = this.movementAlgorithms.findNeighborPlayer(data.roomId, player);

                        if (movement.path.length <= 1) {
                            if (neighborPlayer && this.gameRoomService.isOpponent(player, neighborPlayer, data.isCTF)) {
                                this.gameCombatService.setServer(server);
                                return this.gameCombatService.startVirtualCombat(data.roomId, data.playerId, neighborPlayer.id, true);
                            } else {
                                return this.gameRoomService.endTurn(data.roomId);
                            }
                        }

                        // Scan the VP path for trap tiles (skip index 0 = starting position)
                        let trapIndex = -1;
                        for (let i = 1; i < movement.path.length; i++) {
                            const c = this.gameMovementService.extractCoord(movement.path[i]);
                            if (this.trapHandler.isTrapTile(data.roomId, c.x, c.y)) {
                                trapIndex = i;
                                break;
                            }
                        }

                        // If a trap is found mid-path, correct the VP position to the trap tile
                        if (trapIndex !== -1 && trapIndex < movement.path.length - 1) {
                            const trapCoord = this.gameMovementService.extractCoord(movement.path[trapIndex]);
                            const truncatedPath = movement.path.slice(0, trapIndex + 1);

                            // Restore original state: determineVPMovement already moved VP to final
                            // destination and deducted full cost. We need to undo that.
                            player.movementPoints = originalMovementPoints;
                            this.gameMovementService.movePlayer(data.roomId, data.playerId, room.players, originalPosition, true);

                            // Now move properly to the trap tile — this deducts only the cost up to the trap
                            const correctedMP = this.gameMovementService.movePlayer(data.roomId, data.playerId, room.players, trapCoord);

                            this.updateVisitedTiles(room, player, truncatedPath);

                            server.to(data.roomId).emit(GameRoomEvents.VirtualPlayerMoved, {
                                path: truncatedPath,
                                remainingMovementPoints: correctedMP,
                                playerId: data.playerId,
                            });

                            this.trapHandler.resolveForVirtualPlayer(data.roomId, data.playerId, server, player.profile);

                            return;
                        }

                        // No mid-path trap — check destination for trap
                        if (neighborPlayer && this.gameRoomService.isOpponent(player, neighborPlayer, data.isCTF)) {
                            this.updateVisitedTiles(room, player, movement.path);
                            return server.to(data.roomId).emit(GameRoomEvents.VirtualPlayerMoved, {
                                ...movement,
                                playerId: data.playerId,
                                opponentPlayerId: neighborPlayer.id,
                            });
                        } else {
                            // Check if destination itself is a trap
                            const destination = this.gameMovementService.extractCoord(movement.path[movement.path.length - 1]);
                            if (this.trapHandler.isTrapTile(data.roomId, destination.x, destination.y)) {
                                this.updateVisitedTiles(room, player, movement.path);
                                server.to(data.roomId).emit(GameRoomEvents.VirtualPlayerMoved, { ...movement, playerId: data.playerId });
                                this.trapHandler.resolveForVirtualPlayer(data.roomId, data.playerId, server, player.profile);
                            } else {
                                // Include teleport destination in the event so the client can
                                // teleport AFTER the movement animation completes (avoids desync).
                                const teleportDestination = this.getTeleportDestinationForVP(data.roomId, data.playerId, room.players);
                                this.updateVisitedTiles(room, player, movement.path);
                                server.to(data.roomId).emit(GameRoomEvents.VirtualPlayerMoved, {
                                    ...movement,
                                    playerId: data.playerId,
                                    teleportDestination,
                                });
                                if (teleportDestination) {
                                    this.gameMovementService.movePlayer(data.roomId, data.playerId, room.players, teleportDestination, true);
                                }
                            }
                        }
                    } catch (error) {
                        // Game was cleaned up before the VP timer fired — safe to ignore
                        return;
                    }
                },
                data.skipTimeout ? 0 : this.gameRoomService.getRandomDelay(MIN_TURN_DELAY, MAX_TURN_DELAY),
            );
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    private getTeleportDestinationForVP(roomId: string, playerId: string, players: Player[]): { x: number; y: number } | null {
        const player = players.find((p) => p.id === playerId);
        if (!player) return null;

        const currentCell = this.gameMovementService.getCell(roomId, player.position.x, player.position.y);
        if (!currentCell || currentCell.tile.type !== TileType.TeleportPad) return null;

        const board = this.gameMovementService.getBoardForGame(roomId);
        if (!board) return null;

        const partnerPad = board.matrix.flat().find(
            (cell) =>
                cell.tile.type === TileType.TeleportPad &&
                cell.tile.state === currentCell.tile.state &&
                (cell.x !== currentCell.x || cell.y !== currentCell.y) &&
                !cell.player,
        );

        if (!partnerPad) return null;

        return { x: partnerPad.x, y: partnerPad.y };
    }

    private updateVisitedTiles(room: GameRoom, player: Player, path: (Coords | { coord: Coords; cost: number })[]): void {
        const playerStats = room.playersStats?.find((s) => s.name === player.name);
        if (!playerStats) return;
        for (const element of path) {
            const coord = this.gameMovementService.extractCoord(element);
            const alreadyVisited = playerStats.tilesVisited.some((tile) => tile.x === coord.x && tile.y === coord.y);
            if (!alreadyVisited) playerStats.tilesVisited.push(coord);
        }
    }
}

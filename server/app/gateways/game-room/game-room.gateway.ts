/* eslint-disable max-lines */
import { MAX_TURN_DELAY, MIN_TURN_DELAY, MS_IN_SECOND, SECONDS_IN_MINUTE } from '@app/constants/game-room.constants';
import { Coords } from '@app/interfaces/coords';
import { Item } from '@app/interfaces/item';
import { GameCombatService } from '@app/services/game-combat/game-combat.service';
import { GameMovementService } from '@app/services/game-movement/game-movement.service';
import { GameRoomService } from '@app/services/game-room/game-room.service';
import { MovementAlgorithmsService } from '@app/services/movement-algorithms/movement-algorithms.service';
import { GameMovementVPService } from '@app/services/virtual-players/game-movement-vp.service';
import { ErrorMessages } from '@common/error-messages.constants';
import { GameRoomEvents } from '@common/socket.constants';
import { Injectable, Logger } from '@nestjs/common';
import {
    ConnectedSocket,
    MessageBody,
    OnGatewayConnection,
    OnGatewayDisconnect,
    SubscribeMessage,
    WebSocketGateway,
    WebSocketServer,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
@WebSocketGateway({ cors: { origin: '*' } })
@Injectable()
export class GameRoomGateway implements OnGatewayConnection, OnGatewayDisconnect {
    @WebSocketServer() private server: Server;
    private readonly logger = new Logger(GameRoomGateway.name);

    constructor(
        private readonly gameRoomService: GameRoomService,
        private readonly gameMovementService: GameMovementService,
        private readonly gameCombatService: GameCombatService,
        private readonly gameMovementVPService: GameMovementVPService,
        private readonly movementAlgorithms: MovementAlgorithmsService,
    ) {}

    @SubscribeMessage(GameRoomEvents.AbandonGame)
    handleLeaveRoom(@MessageBody() roomId: string, @ConnectedSocket() socket: Socket) {
        this.logger.log(`${GameRoomEvents.AbandonGame} called by ${socket.id}`);
        try {
            this.handlePlayerAbandonment(roomId, socket.id);
            socket.emit(GameRoomEvents.GameAbandoned);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    @SubscribeMessage(GameRoomEvents.FinishGame)
    handleFinishGame(@MessageBody() data: { roomId: string; winnerId: string }, @ConnectedSocket() socket: Socket) {
        try {
            const room = this.gameRoomService.findRoomById(data.roomId);
            const diffSeconds = Math.floor((Date.now() - room.startTime.getTime()) / MS_IN_SECOND);
            room.globalStats.gameDuration = `${String(Math.floor(diffSeconds / SECONDS_IN_MINUTE)).padStart(2, '0')}:${String(
                diffSeconds % SECONDS_IN_MINUTE,
            ).padStart(2, '0')}`;
            this.gameRoomService.pauseTimer(data.roomId);
            this.server.to(data.roomId).emit(GameRoomEvents.FinishGame, data.winnerId);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    @SubscribeMessage(GameRoomEvents.QuitEndGame)
    async handleLeaveEndGame(@MessageBody() roomId: string, @ConnectedSocket() socket: Socket) {
        try {
            socket.leave(roomId);
            if ((await this.server.in(roomId).fetchSockets()).length === 0) this.gameRoomService.deleteRoomById(roomId);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    @SubscribeMessage(GameRoomEvents.PlayGame)
    async handlePlayGame(@MessageBody() roomId: string, @ConnectedSocket() socket: Socket) {
        try {
            const room = this.gameRoomService.findRoomById(roomId);
            room.players = await this.gameMovementService.addPlayersToBoard(room.gameId, room.players);
            this.server.to(roomId).emit(GameRoomEvents.PlayerSpawned, room.players);
            this.gameRoomService.setServer(this.server);
            this.gameRoomService.prepareNextTurn(roomId);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    @SubscribeMessage(GameRoomEvents.SendMessageToGameRoom)
    async handleSendMessage(@MessageBody() data: { message: string; playerName: string | null; roomId: string }, @ConnectedSocket() socket: Socket) {
        try {
            const message = {
                type: 'received',
                name: data.playerName,
                content: data.message,
                time: new Date().toLocaleTimeString('en-GB', {
                    hour: '2-digit',
                    minute: '2-digit',
                    second: '2-digit',
                    hour12: false,
                }),
            };
            this.gameRoomService.addMessage(data.roomId, message);
            this.server.except(socket.id).to(data.roomId).emit(GameRoomEvents.MassMessage, message);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    @SubscribeMessage(GameRoomEvents.GetStatistics)
    async handleGetStatistics(@MessageBody() roomId: string, @ConnectedSocket() socket: Socket) {
        try {
            const room = this.gameRoomService.findRoomById(roomId);
            const statistics = {
                playerStats: room.playersStats,
                globalStats: room.globalStats,
                walkableTiles: this.gameMovementService.getWalkableTiles(),
                toggableDoors: this.gameMovementService.getAllDoors(),
            };
            socket.emit(GameRoomEvents.GetStatisticsResponse, statistics);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    /**
     * Handles the player request for possible movements
     * @param data The body of the request containing the room id and if the player has boots
     * @param socket The socket of the player
     * @returns A promise containing the possible movements
     */
    @SubscribeMessage(GameRoomEvents.PlayerGetMovements)
    async handlePlayerGetMovements(
        @MessageBody() data: { roomId: string; hasBoots: boolean },
        @ConnectedSocket() socket: Socket,
    ): Promise<{ success: boolean; paths?: [Coords, Coords[]][]; error?: string }> {
        try {
            const { roomId, hasBoots } = data;
            const room = this.gameRoomService.findRoomById(roomId);
            const player = room.players.find((p) => p.id === socket.id);

            if (!player) {
                return { success: false, error: ErrorMessages.PlayerNotFound };
            }

            player.hasBoots = hasBoots;
            const paths = this.gameMovementService.getAllPaths(socket.id, room.players);

            return {
                success: true,
                paths: Array.from(paths.entries()),
            };
        } catch (error) {
            return { success: false, error: error.message };
        }
    }

    /**
     * Handles the player request for moving
     * @param data The body of the request containing the room id, the player id and the selected path
     * @returns A promise containing the success status and the movement points
     */
    @SubscribeMessage(GameRoomEvents.PlayerMoved)
    async handlePlayerMoved(
        @MessageBody() data: { roomId: string; playerId: string; selectedPath: Coords[] },
    ): Promise<{ success: boolean; error?: string; movementPoints?: number }> {
        try {
            const { roomId, playerId, selectedPath } = data;
            const room = this.gameRoomService.findRoomById(roomId);
            const player = room.players.find((p) => p.id === playerId);

            if (!player) {
                return { success: false, error: ErrorMessages.PlayerNotFound };
            }

            const validation = this.gameMovementService.validatePath(playerId, selectedPath, room.players);

            if (!validation.isValid) {
                return { success: false, error: validation.isValid === false ? validation.error : '' };
            }

            const playerStats = room.playersStats.find((p) => p.name === player.name);
            for (const path of selectedPath) {
                const alreadyVisited = playerStats.tilesVisited.some((tile) => tile.x === path.x && tile.y === path.y);
                if (!alreadyVisited) playerStats.tilesVisited.push(path);
            }

            const destination = selectedPath[selectedPath.length - 1];
            const movementPoints = this.gameMovementService.movePlayer(playerId, room.players, destination);

            this.server.to(roomId).emit(GameRoomEvents.PlayerMoved, { ...data, movementPoints });

            return { success: true, movementPoints };
        } catch (error) {
            return { success: false, error: error.message };
        }
    }

    @SubscribeMessage(GameRoomEvents.PlayerTeleported)
    async handlePlayerTeleported(
        @MessageBody() data: { roomId: string; playerId: string; destination: Coords; hasCamouflage?: boolean },
    ): Promise<{ success: boolean; error?: string }> {
        try {
            const room = this.gameRoomService.findRoomById(data.roomId);
            if (!room) {
                throw new Error(ErrorMessages.RoomDoesNotExist);
            }

            const player = room.players.find((p) => p.id === data.playerId);
            if (!player) {
                throw new Error(ErrorMessages.PlayerNotFound);
            }

            if (data.destination.x < 0 || data.destination.y < 0) {
                throw new Error('Invalid destination coordinates');
            }

            const destinationCell = this.gameMovementService.getCell(data.destination.x, data.destination.y);
            const item = destinationCell?.item;
            const hasCollectableItem = item && item.type !== 'spawnPoint';

            this.gameMovementService.movePlayer(data.playerId, room.players, data.destination, true);

            if (hasCollectableItem) {
                this.gameRoomService.addItemToInventory(data.roomId, data.playerId, item, data.destination);
                this.server.to(data.roomId).emit(GameRoomEvents.ItemCollected, {
                    roomId: data.roomId,
                    playerId: data.playerId,
                    item,
                    position: data.destination,
                });

                if (item.type === 'flag') {
                    this.server.to(data.roomId).emit(GameRoomEvents.FlagCollected, data.playerId);
                }
            }

            this.server.to(data.roomId).emit(GameRoomEvents.PlayerTeleported, data);

            return { success: true };
        } catch (error) {
            this.logger.error(`Erreur téléportation: ${error.message}`);
            return { success: false, error: error.message };
        }
    }

    @SubscribeMessage(GameRoomEvents.StartCombat)
    handleStartFight(@MessageBody() data: { roomId: string; opponentId: string }, @ConnectedSocket() socket: Socket) {
        try {
            this.gameCombatService.setServer(this.server);
            const generalRoom = this.gameRoomService.findRoomById(data.roomId);
            if (!generalRoom) throw new Error(ErrorMessages.RoomDoesNotExist);
            const combatStarter = generalRoom.players.find((player) => player.id === socket.id);
            const combatRoom = `combat_${data.roomId}`;
            const opponentSocket = this.server.sockets.sockets.get(data.opponentId);
            const opponent = generalRoom.players.find((player) => player.id === data.opponentId);
            const playersFighting = [combatStarter, opponent];
            if (opponent.isVirtual) {
                this.gameCombatService.startVirtualCombat(data.roomId, data.opponentId, socket.id, false);
                return { success: true };
            }
            const starterStats = generalRoom.playersStats.find((p) => p.name === combatStarter.name);
            const opponentStats = generalRoom.playersStats.find((p) => p.name === opponent.name);
            if (starterStats) starterStats.combats++;
            if (opponentStats) opponentStats.combats++;
            this.gameRoomService.pauseTimer(data.roomId);
            socket.join(combatRoom);
            opponentSocket.join(combatRoom);
            this.gameCombatService.startCombat(data.roomId, combatRoom, playersFighting, socket.id, data.opponentId);
            return { success: true };
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
            return { success: false, error: error.message };
        }
    }

    @SubscribeMessage(GameRoomEvents.Attack)
    async handleAttack(@MessageBody() data: { roomId: string }, @ConnectedSocket() socket: Socket) {
        try {
            this.logger.log(`[${data.roomId}] Attack attempt`);
            await this.gameCombatService.attack(data.roomId);
            return { success: true };
        } catch (error) {
            this.logger.error(`[${data.roomId}] Attack error: ${error.message}`);
            socket.emit(GameRoomEvents.GameRoomError, error.message);
            return { success: false, error: error.message };
        }
    }

    @SubscribeMessage(GameRoomEvents.FlightAttempt)
    async handleFlightAttempt(@MessageBody() roomId: string, @ConnectedSocket() socket: Socket) {
        try {
            await this.gameCombatService.attemptFlight(roomId);
            return { success: true };
        } catch (error) {
            this.logger.error(`[${roomId}] Flight error: ${error.message}`);
            socket.emit(GameRoomEvents.GameRoomError, error.message);
            return { success: false, error: error.message };
        }
    }

    @SubscribeMessage(GameRoomEvents.ToggleDebugMode)
    handleToggleDebugMode(@MessageBody() roomId: string, @ConnectedSocket() socket: Socket) {
        try {
            const isDebugging = this.gameRoomService.toggleDebugMode(roomId);
            if (isDebugging) this.server.to(roomId).emit(GameRoomEvents.DebugModeEnabled);
            else this.server.to(roomId).emit(GameRoomEvents.DebugModeDisabled);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    @SubscribeMessage(GameRoomEvents.EndTurn)
    handleEndTurn(@MessageBody() roomId: string, @ConnectedSocket() socket: Socket) {
        try {
            this.gameRoomService.endTurn(roomId);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    @SubscribeMessage(GameRoomEvents.DoorToggled)
    handleDoorToggled(@MessageBody() data: { roomId: string; x: number; y: number }, @ConnectedSocket() socket: Socket) {
        try {
            const room = this.gameRoomService.findRoomById(data.roomId);
            this.gameMovementService.toggleDoor(data.x, data.y, room);
            this.server.to(data.roomId).emit(GameRoomEvents.DoorToggled, data);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    @SubscribeMessage(GameRoomEvents.ItemCollected)
    handleItemCollected(@MessageBody() data: { roomId: string; playerId: string; item: Item; position: Coords }, @ConnectedSocket() socket: Socket) {
        try {
            const room = this.gameRoomService.findRoomById(data.roomId);
            const playerInRoom = room.players.find((p) => p.id === data.playerId);
            const player = room.playersStats.find((playerReceived) => playerReceived.name === playerInRoom.name);
            if (!player.itemsCollected.includes(data.item.type)) player.itemsCollected.push(data.item.type);
            this.gameRoomService.addItemToInventory(data.roomId, data.playerId, data.item, data.position);
            if (data.item.type === 'flag') this.server.to(data.roomId).emit(GameRoomEvents.FlagCollected, data.playerId);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    @SubscribeMessage(GameRoomEvents.ItemDropped)
    handleItemDropped(@MessageBody() data: { roomId: string; playerId: string; item: Item; coords: Coords }, @ConnectedSocket() socket: Socket) {
        try {
            this.server.to(data.roomId).emit(GameRoomEvents.ItemDropped, data);
            this.gameRoomService.removeItemFromInventory(data.roomId, data.playerId, data.item, data.coords);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    @SubscribeMessage(GameRoomEvents.VirtualPlayerTurn)
    handleVirtualPlayerTurn(
        @MessageBody() data: { roomId: string; playerId: string; isCTF: boolean; skipTimeout: boolean },
        @ConnectedSocket() socket: Socket,
    ) {
        try {
            const room = this.gameRoomService.findRoomById(data.roomId);
            const player = room.players.find((p) => p.id === data.playerId);
            if (!player) return;
            setTimeout(
                () => {
                    const movement = this.gameMovementVPService.determineVPMovement(player, room.players, data.isCTF);
                    const neighborPlayer = this.movementAlgorithms.findNeighborPlayer(player);
                    if (movement.path.length <= 1) {
                        if (neighborPlayer && this.gameRoomService.isOpponent(player, neighborPlayer, data.isCTF)) {
                            this.gameCombatService.setServer(this.server);
                            return this.gameCombatService.startVirtualCombat(data.roomId, data.playerId, neighborPlayer.id, true);
                        } else return this.gameRoomService.endTurn(data.roomId);
                    } else {
                        if (neighborPlayer && this.gameRoomService.isOpponent(player, neighborPlayer, data.isCTF)) {
                            return this.server.to(data.roomId).emit(GameRoomEvents.VirtualPlayerMoved, {
                                ...movement,
                                playerId: data.playerId,
                                opponentPlayerId: neighborPlayer.id,
                            });
                        } else return this.server.to(data.roomId).emit(GameRoomEvents.VirtualPlayerMoved, { ...movement, playerId: data.playerId });
                    }
                },
                data.skipTimeout ? 0 : this.gameRoomService.getRandomDelay(MIN_TURN_DELAY, MAX_TURN_DELAY),
            );
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    @SubscribeMessage(GameRoomEvents.StartVirtualCombat)
    handleStartVirtualCombat(@MessageBody() data: { roomId: string; playerId: string; opponentId: string }, @ConnectedSocket() socket: Socket) {
        try {
            this.gameCombatService.setServer(this.server);
            this.gameCombatService.startVirtualCombat(data.roomId, data.playerId, data.opponentId, true);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    @SubscribeMessage(GameRoomEvents.SynchronizeMovement)
    handleSynchronizeMovement(@MessageBody() data: { roomId: string; playerId: string; destination: Coords }, @ConnectedSocket() socket: Socket) {
        try {
            this.server.to(data.roomId).emit(GameRoomEvents.SynchronizeMovement, data);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    handleConnection(@ConnectedSocket() socket: Socket) {
        this.logger.log(`socket connecté: ${socket.id}`);
    }

    handleDisconnect(@ConnectedSocket() socket: Socket) {
        this.logger.log(`socket déconnecté: ${socket.id}`);
        try {
            const rooms = this.gameRoomService.findRoomsByPlayerId(socket.id);
            const combatRooms = this.gameCombatService.findCombatsByPlayerId(socket.id);
            if (combatRooms && combatRooms.length > 0) {
                combatRooms.forEach((combat) => {
                    this.gameCombatService.abandonCombat(combat.combatRoomId, true);
                });
            }
            rooms.forEach((room) => {
                if (room && room.roomId) {
                    this.handlePlayerAbandonment(room.roomId, socket.id);
                }
            });
        } catch (error) {
            this.logger.log(`Error handling disconnect for ${socket.id}: ${error.message}`);
        }
    }

    private handlePlayerAbandonment(roomId: string, playerId: string): boolean {
        const combatRooms = this.gameCombatService.findCombatsByPlayerId(playerId);
        if (combatRooms && combatRooms.length > 0) combatRooms.forEach((combat) => this.gameCombatService.endCombat(combat.combatRoomId, false));
        this.gameRoomService.dropItemsWhenDisconnected(roomId, playerId);
        this.gameMovementService.removePlayerFromBoard(playerId);
        if (this.gameRoomService.isHost(roomId, playerId)) {
            this.server.to(roomId).emit(GameRoomEvents.DebugModeDisabled);
            this.gameRoomService.changeOrganisator(roomId);
        }

        if (this.gameRoomService.isPlayerTurn(roomId, playerId)) this.gameRoomService.endTurn(roomId);

        const isRoomDeleted = this.gameRoomService.abandonGame(roomId, playerId);
        if (isRoomDeleted) this.server.to(roomId).emit(GameRoomEvents.GameCanceled);
        else this.server.to(roomId).emit(GameRoomEvents.PlayerAbandoned, playerId);
        return isRoomDeleted;
    }
}

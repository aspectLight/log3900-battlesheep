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

    @SubscribeMessage(GameRoomEvents.PlayerGetMovements)
    async handlePlayerGetMovements(@MessageBody() data: { roomId: string; hasBoots: boolean }, @ConnectedSocket() socket: Socket) {
        try {
            const { roomId, hasBoots } = data;
            const room = this.gameRoomService.findRoomById(roomId);
            const player = room.players.find((p) => p.id === socket.id);
            if (player) player.hasBoots = hasBoots;
            const paths = this.gameMovementService.getAllPaths(socket.id, room.players);
            this.server.to(socket.id).emit(GameRoomEvents.PlayerMovements, Array.from(paths.entries()));
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    @SubscribeMessage(GameRoomEvents.PlayerMoved)
    async handlePlayerMoved(
        @MessageBody() data: { roomId: string; playerId: string; serializedMap: Map<Coords, Coords[]>; selectedPath: Coords[] },
        @ConnectedSocket() socket: Socket,
    ) {
        try {
            const room = this.gameRoomService.findRoomById(data.roomId);
            room.playersStats.forEach((player) => {
                if (player.name === room.players.find((p) => p.id === data.playerId).name) {
                    for (const path of data.selectedPath) {
                        const alreadyVisited = player.tilesVisited.some((tile) => tile.x === path.x && tile.y === path.y);
                        if (!alreadyVisited) player.tilesVisited.push(path);
                    }
                }
            });
            const destination = data.selectedPath[data.selectedPath.length - 1];
            const movementPoints = this.gameMovementService.movePlayer(socket.id, room.players, destination);
            this.server.to(data.roomId).emit(GameRoomEvents.PlayerMoved, { ...data, movementPoints });
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    @SubscribeMessage(GameRoomEvents.PlayerTeleported)
    async handlePlayerTeleported(
        @MessageBody() data: { roomId: string; playerId: string; destination: Coords; hasCamo?: boolean },
        @ConnectedSocket() socket: Socket,
    ) {
        try {
            const room = this.gameRoomService.findRoomById(data.roomId);
            this.gameMovementService.movePlayer(data.playerId, room.players, data.destination, true);
            this.server.to(data.roomId).emit(GameRoomEvents.PlayerTeleported, data);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
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
            generalRoom.playersStats.forEach((player) => {
                if (player.name === combatStarter.name) player.combats++;
                if (player.name === opponent.name) player.combats++;
            });
            if (opponent.isVirtual) return this.gameCombatService.startVirtualCombat(data.roomId, data.opponentId, socket.id, false);
            this.gameRoomService.pauseTimer(data.roomId);
            socket.join(combatRoom);
            opponentSocket.join(combatRoom);
            this.gameCombatService.startCombat(data.roomId, combatRoom, playersFighting, socket.id, data.opponentId);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    @SubscribeMessage(GameRoomEvents.Attack)
    handleAttack(@MessageBody() data: { roomId: string; attackValue: number; defenseValue: number }, @ConnectedSocket() socket: Socket) {
        try {
            this.logger.log(`[${data.roomId}] Attack attempt with attack value:  ${data.attackValue} and defense value: ${data.defenseValue}`);
            this.gameCombatService.attack(data.roomId, data.attackValue, data.defenseValue);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    @SubscribeMessage(GameRoomEvents.FlightAttempt)
    handleFlightAttempt(@MessageBody() roomId: string, @ConnectedSocket() socket: Socket) {
        try {
            this.gameCombatService.attemptFlight(roomId);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    @SubscribeMessage(GameRoomEvents.ResumeTurn)
    handleResumeTurn(@MessageBody() roomId: string, @ConnectedSocket() socket: Socket) {
        try {
            this.gameRoomService.resumeTurn(roomId);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
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

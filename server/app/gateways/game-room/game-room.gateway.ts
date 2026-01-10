import { Coords } from '@app/interfaces/coords';
import { GameCombatService } from '@app/services/game-combat/game-combat.service';
import { GameMovementService } from '@app/services/game-movement/game-movement.service';
import { GameRoomService } from '@app/services/game-room/game-room.service';
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
import { GameRoomEvents } from './game-room.gateway.events';

@WebSocketGateway({ cors: { origin: '*' } })
@Injectable()
export class GameRoomGateway implements OnGatewayConnection, OnGatewayDisconnect {
    @WebSocketServer() private server: Server;
    private readonly logger = new Logger(GameRoomGateway.name);

    constructor(
        private readonly gameRoomService: GameRoomService,
        private readonly gameMovementService: GameMovementService,
        private readonly gameCombatService: GameCombatService,
    ) {}

    @SubscribeMessage(GameRoomEvents.AbandonGame)
    handleLeaveRoom(@MessageBody() roomId: string, @ConnectedSocket() socket: Socket) {
        this.logger.log(`${GameRoomEvents.AbandonGame} called by ${socket.id}`);
        try {
            const combatRooms = this.gameCombatService.findCombatsByPlayerId(socket.id);
            if (combatRooms && combatRooms.length > 0) {
                combatRooms.forEach((combat) => {
                    this.gameCombatService.endCombat(combat.combatRoomId, false);
                    this.logger.log(`Combat ${combat.combatRoomId} terminé suite à l'abandon du joueur ${socket.id}`);
                });
            }

            const isRoomDeleted = this.gameRoomService.abandonGame(roomId, socket.id);
            socket.emit(GameRoomEvents.GameAbandoned);
            if (isRoomDeleted) {
                this.server.to(roomId).emit(GameRoomEvents.GameCanceled);
                this.logger.log(`Partie ${roomId} supprimée, car il y avait moins de 2 joueurs restant`);
            } else {
                this.server.to(roomId).emit(GameRoomEvents.PlayerAbandoned, socket.id);
                this.logger.log(`Joueur ${socket.id} a quitté la partie ${roomId}`);
            }
        } catch (error) {
            this.logger.log(`Error ${error.message} has been thrown`);
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    @SubscribeMessage(GameRoomEvents.FinishGame)
    async handleFinishGame(@MessageBody() data: { roomId: string; winnerId: string }, @ConnectedSocket() socket: Socket) {
        this.logger.log(`${GameRoomEvents.FinishGame} called by ${socket.id}`);
        try {
            this.server.to(data.roomId).emit(GameRoomEvents.FinishGame, data.winnerId);
            const sockets = await this.server.in(data.roomId).fetchSockets();
            for (const playerSocket of sockets) {
                playerSocket.leave(data.roomId);
            }
            this.gameRoomService.deleteRoomById(data.roomId);
            this.logger.log(`Joueur ${socket.id} a gagné la partie ${data.roomId}`);
        } catch (error) {
            this.logger.log(`Error ${error.message} has been thrown`);
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    @SubscribeMessage(GameRoomEvents.PlayGame)
    async handlePlayGame(@MessageBody() roomId: string, @ConnectedSocket() socket: Socket) {
        try {
            const room = this.gameRoomService.findRoomById(roomId);
            const players = await this.gameMovementService.addPlayersToBoard(room.gameId, room.players);
            room.players = players;
            this.server.to(roomId).emit(GameRoomEvents.PlayerSpawned, room.players);
            this.gameRoomService.setServer(this.server);
            this.gameRoomService.prepareNextTurn(roomId);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    @SubscribeMessage(GameRoomEvents.PlayerGetMovements)
    async handlePlayerGetMovements(@MessageBody() roomId: string, @ConnectedSocket() socket: Socket) {
        try {
            const room = this.gameRoomService.findRoomById(roomId);
            const paths = await this.gameMovementService.getAllPaths(socket.id, room.players);
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
            const destination = data.selectedPath[data.selectedPath.length - 1];
            const movementPoints = await this.gameMovementService.movePlayer(socket.id, room.players, destination);
            this.server.to(data.roomId).emit(GameRoomEvents.PlayerMoved, { ...data, movementPoints });
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    @SubscribeMessage(GameRoomEvents.PlayerTeleported)
    async handlePlayerTeleported(@MessageBody() data: { roomId: string; playerId: string; destination: Coords }, @ConnectedSocket() socket: Socket) {
        try {
            const room = this.gameRoomService.findRoomById(data.roomId);
            await this.gameMovementService.movePlayer(data.playerId, room.players, data.destination, room.isDebugging);
            this.server.to(data.roomId).emit(GameRoomEvents.PlayerTeleported, data);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    @SubscribeMessage(GameRoomEvents.StartCombat)
    handleStartFight(@MessageBody() data: { roomId: string; opponentId: string }, @ConnectedSocket() socket: Socket) {
        try {
            this.gameCombatService.setServer(this.server);
            this.gameRoomService.pauseTimer(data.roomId);
            const generalRoom = this.gameRoomService.findRoomById(data.roomId);
            if (!generalRoom) {
                throw new Error('Room not found');
            }
            const combatStarter = generalRoom.players.find((player) => player.id === socket.id);
            const opponent = generalRoom.players.find((player) => player.id === data.opponentId);
            const playersFighting = [combatStarter, opponent];
            const combatRoom = `combat_${data.roomId}`;
            const opponentSocket = this.server.sockets.sockets.get(data.opponentId);

            socket.join(combatRoom);
            opponentSocket.join(combatRoom);

            this.gameCombatService.startCombat(combatRoom, playersFighting, socket.id, data.opponentId);
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
            if (isDebugging) {
                this.server.to(roomId).emit(GameRoomEvents.DebugModeEnabled);
                this.logger.log(`Partie ${roomId}: mode débogage activé`);
            } else {
                this.server.to(roomId).emit(GameRoomEvents.DebugModeDisabled);
                this.logger.log(`Partie ${roomId}: mode débogage désactivé`);
            }
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
            this.logger.log('toggled door', data, data.roomId, data.x, data.y);
            this.gameMovementService.toggleDoor(data.x, data.y);
            this.server.to(data.roomId).emit(GameRoomEvents.DoorToggled, data);
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
                    this.logger.log(`Combat ${combat.combatRoomId} terminé suite à la déconnexion du joueur ${socket.id}`);
                });
            }

            rooms.forEach((room) => {
                if (room && room.roomId) {
                    const roomId = room.roomId;
                    const isRoomDeleted = this.gameRoomService.abandonGame(roomId, socket.id);

                    if (isRoomDeleted) {
                        this.server.to(roomId).emit(GameRoomEvents.GameCanceled);
                        this.logger.log(`Partie ${roomId} supprimée, car il y avait moins de 2 joueurs restant`);
                    } else {
                        this.server.to(roomId).emit(GameRoomEvents.PlayerAbandoned, socket.id);
                        this.logger.log(`Joueur ${socket.id} a quitté la partie ${roomId} (déconnexion)`);
                    }
                }
            });
        } catch (error) {
            this.logger.log(`Error handling disconnect for ${socket.id}: ${error.message}`);
        }
    }
}

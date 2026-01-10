import { GameRoomEvents } from '@app/gateways/game-room/game-room.gateway.events';
import { Player } from '@app/interfaces/player';
import { GameRoomService } from '@app/services/game-room/game-room.service';
import { WaitingRoomService } from '@app/services/waiting-room/waiting-room.service';
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
import { WaitingRoomEvents } from './waiting-room.gateway.events';

@WebSocketGateway({ cors: { origin: '*' } })
@Injectable()
export class WaitingRoomGateway implements OnGatewayConnection, OnGatewayDisconnect {
    @WebSocketServer() private server: Server;
    private readonly logger = new Logger(WaitingRoomGateway.name);

    constructor(
        private readonly waitingRoomService: WaitingRoomService,
        private readonly gameRoomService: GameRoomService,
    ) {}

    @SubscribeMessage(WaitingRoomEvents.CreateWaitingRoom)
    handleCreateRoom(@MessageBody() data: { roomId: string; gameId: string; organisator: Player }, @ConnectedSocket() socket: Socket) {
        try {
            const room = this.waitingRoomService.createRoom(data.roomId, data.gameId, data.organisator, socket.id);
            socket.join(data.roomId);
            this.server.to(socket.id).emit(WaitingRoomEvents.WaitingRoomCreated, room);
            this.logger.log(`Salle ${data.roomId} créée par ${data.organisator.id}`);
        } catch (error) {
            socket.emit(WaitingRoomEvents.WaitingRoomError, error.message);
        }
    }

    @SubscribeMessage(WaitingRoomEvents.JoinWaitingRoom)
    handleJoinRoom(@MessageBody() roomId: string, @ConnectedSocket() socket: Socket) {
        try {
            const room = this.waitingRoomService.findRoomById(roomId);
            if (!room) throw new Error("La salle n'existe pas");
            if (room.isLocked) throw new Error('La salle est verrouillée');
            socket.emit(WaitingRoomEvents.JoinRoomResponse, { success: true, room });

            this.waitingRoomService.joinRoom(roomId, socket.id);
            socket.join(roomId);
            this.server.to(roomId).emit(WaitingRoomEvents.PlayerJoined, { playerId: socket.id });
            this.logger.log(`Joueur ${socket.id} a rejoint la salle ${roomId}`);
        } catch (error) {
            socket.emit(WaitingRoomEvents.JoinRoomResponse, { success: false, error: error.message });
        }
    }

    @SubscribeMessage(WaitingRoomEvents.CreatePlayer)
    handleCreatePlayer(@MessageBody() data: { roomId: string; player: Player }, @ConnectedSocket() socket: Socket) {
        try {
            const room = this.waitingRoomService.findRoomById(data.roomId);
            if (room) {
                const originalName = data.player.name;
                let newName = originalName;
                let counter = 1;
                const existingNames = new Set(room.players.map((p) => p.name));
                while (existingNames.has(newName)) {
                    counter++;
                    newName = `${originalName} -${counter}`;
                }
                data.player.name = newName;
                this.waitingRoomService.addCharacter(data.roomId, data.player, socket.id);
                this.server.to(data.roomId).emit(WaitingRoomEvents.PlayerCreated, room.players);
                this.logger.log(`Joueur ${data.player.name} ajouté à la salle : ${data.roomId}`);
            }
        } catch (error) {
            socket.emit(WaitingRoomEvents.WaitingRoomError, error.message);
        }
    }

    @SubscribeMessage(WaitingRoomEvents.ReserveAvatar)
    handleReserveAvatar(@MessageBody() data: { roomId: string; chosenAvatar: string }, @ConnectedSocket() socket: Socket) {
        try {
            this.waitingRoomService.reserveCharacter(data.roomId, socket.id, data.chosenAvatar);
            const room = this.waitingRoomService.findRoomById(data.roomId);
            if (room) {
                this.server.to(data.roomId).emit(WaitingRoomEvents.UpdateAvatarReserved, { reservedAvatars: room.reservedAvatars });
                this.logger.log(`Joueur ${socket.id} a réservé l'avatar ${data.chosenAvatar}`);
            }
        } catch (error) {
            socket.emit(WaitingRoomEvents.WaitingRoomError, error.message);
        }
    }

    @SubscribeMessage(WaitingRoomEvents.GetReservedAvatars)
    handleGetReservedAvatars(@MessageBody() data: { roomId: string }, @ConnectedSocket() socket: Socket) {
        try {
            const room = this.waitingRoomService.findRoomById(data.roomId);
            if (!room) socket.emit(WaitingRoomEvents.UpdateAvatarReserved, { reservedAvatars: [] });
            if (room) {
                socket.emit(WaitingRoomEvents.UpdateAvatarReserved, { reservedAvatars: room.reservedAvatars });
            }
            this.logger.log(`Joueur ${socket.id} a demandé la liste des avatars réservés de la room ${data.roomId}`);
        } catch (error) {
            socket.emit(WaitingRoomEvents.WaitingRoomError, error.message);
        }
    }

    @SubscribeMessage(WaitingRoomEvents.LeaveRoom)
    handleLeaveRoom(@MessageBody() roomId: string, @ConnectedSocket() socket: Socket) {
        try {
            const isRoomDeleted = this.waitingRoomService.leaveRoom(roomId, socket.id);
            if (isRoomDeleted) {
                socket.emit(WaitingRoomEvents.LeaveRoomResponse, { success: true });
                this.server.except(socket.id).to(roomId).emit(WaitingRoomEvents.RoomCanceled);
                this.logger.log(`Salle ${roomId} supprimée, car l'organisateur a quitté.`);
            } else {
                this.server.to(roomId).emit(WaitingRoomEvents.PlayerLeft, { playerId: socket.id });
                const room = this.waitingRoomService.findRoomById(roomId);
                this.server.to(roomId).emit(WaitingRoomEvents.UpdateAvatarReserved, { reservedAvatars: room.reservedAvatars });
                socket.emit(WaitingRoomEvents.LeaveRoomResponse, { success: true });
                this.logger.log(`Joueur ${socket.id} a quitté la salle ${roomId}`);
            }
        } catch (error) {
            socket.emit(WaitingRoomEvents.LeaveRoomResponse, { success: false, error: error.message });
        }
    }

    @SubscribeMessage(WaitingRoomEvents.ToggleLockWaitingRoom)
    handleLockRoom(@MessageBody() roomId: string, @ConnectedSocket() socket: Socket) {
        try {
            const isLocked = this.waitingRoomService.toggleLockRoom(roomId, socket.id);
            if (isLocked) {
                this.server.to(roomId).emit(WaitingRoomEvents.WaitingRoomLocked);
                this.logger.log(`Salle ${roomId} verrouillée par ${socket.id}`);
            } else {
                this.server.to(roomId).emit(WaitingRoomEvents.WaitingRoomUnlocked);
                this.logger.log(`Salle ${roomId} déverrouillée par ${socket.id}`);
            }
        } catch (error) {
            socket.emit(WaitingRoomEvents.WaitingRoomError, error.message);
        }
    }

    @SubscribeMessage(WaitingRoomEvents.KickPlayer)
    handleKickPlayer(@MessageBody() data: { roomId: string; player: Player }, @ConnectedSocket() socket: Socket) {
        try {
            const isKicked = this.waitingRoomService.kickPlayer(data.roomId, socket.id, data.player);
            if (isKicked) {
                this.server.to(data.roomId).emit(WaitingRoomEvents.PlayerLeft, { playerId: data.player.id });
                const room = this.waitingRoomService.findRoomById(data.roomId);
                this.server.to(data.roomId).emit(WaitingRoomEvents.UpdateAvatarReserved, { reservedAvatars: room.reservedAvatars });
                this.server.to(data.player.id).emit(WaitingRoomEvents.PlayerKicked);
                this.logger.log(`Joueur ${data.player.name} expulsé de la salle ${data.roomId}`);
            }
        } catch (error) {
            socket.emit(WaitingRoomEvents.WaitingRoomError, error.message);
        }
    }

    @SubscribeMessage(WaitingRoomEvents.StartGame)
    async handleStartGame(@MessageBody() roomId: string, @ConnectedSocket() socket: Socket) {
        try {
            const waitingRoom = this.waitingRoomService.findRoomById(roomId);
            if (!waitingRoom.isLocked) {
                throw new Error("La salle n'est pas verrouillée");
            }
            const gameRoom = this.gameRoomService.createRoom(waitingRoom);

            const sockets = await this.server.in(roomId).fetchSockets();

            for (const playerSocket of sockets) {
                playerSocket.leave(roomId);
                playerSocket.join(gameRoom.roomId);
            }

            this.waitingRoomService.deleteRoom(roomId);
            this.server.to(gameRoom.roomId).emit(GameRoomEvents.GameRoomCreated, gameRoom);
            this.logger.log(`Lancement de la partie liée à la salle ${roomId}`);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    @SubscribeMessage(WaitingRoomEvents.GenerateCode)
    async handleGenerateCode(@ConnectedSocket() socket: Socket) {
        const code = this.waitingRoomService.generateCode();
        socket.emit(WaitingRoomEvents.GenerateCodeResponse, { code });
    }

    handleConnection(@ConnectedSocket() socket: Socket) {
        this.logger.log(`socket connecté: ${socket.id}`);
    }

    handleDisconnect(@ConnectedSocket() socket: Socket) {
        try {
            this.logger.log(`socket déconnecté: ${socket.id}`);
            const rooms = this.waitingRoomService.findRoomsByPlayerId(socket.id);
            if (rooms && rooms.length > 0) {
                rooms.forEach((room) => {
                    const isRoomDeleted = this.waitingRoomService.leaveRoom(room.roomId, socket.id);
                    if (isRoomDeleted) {
                        this.server.to(room.roomId).emit(WaitingRoomEvents.RoomCanceled);
                        this.logger.log(`Salle ${room.roomId} supprimée, car l'organisateur s'est déconnecté.`);
                    } else {
                        this.server.to(room.roomId).emit(WaitingRoomEvents.PlayerLeft, { playerId: socket.id });
                        const updatedRoom = this.waitingRoomService.findRoomById(room.roomId);
                        if (updatedRoom) {
                            this.server
                                .to(room.roomId)
                                .emit(WaitingRoomEvents.UpdateAvatarReserved, { reservedAvatars: updatedRoom.reservedAvatars });
                        }
                        this.logger.log(`Joueur ${socket.id} a quitté la salle ${room.roomId} suite à déconnexion`);
                    }
                });
            }
        } catch (error) {
            this.logger.error(`Erreur lors du traitement de la déconnexion du joueur ${socket.id}: ${error.message}`);
        }
    }
}

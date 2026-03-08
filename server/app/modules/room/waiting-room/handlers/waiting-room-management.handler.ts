import { GameService } from '@app/modules/game/services/game.service';
import { SIZE_LIMITS } from '@app/modules/shared-room/constants/waiting-room.constants';
import { GameRoomService } from '@app/modules/shared-room/services/game-room.service';
import { CustomChannelService } from '@app/modules/general-chat/services/custom-channel.service';
import { WaitingRoomService } from '@app/modules/shared-room/services/waiting-room.service';
import { Player } from '@app/shared/interfaces/player';
import { RoomInfo } from '@app/shared/interfaces/room-info';
import { CustomChannelEvents, WaitingRoomEvents } from '@common/socket.constants';
import { Injectable, Logger } from '@nestjs/common';
import { Server, Socket } from 'socket.io';

/**
 * Handler for waiting room management events (create, join, leave, lock)
 */
@Injectable()
export class WaitingRoomManagementHandler {
    private readonly logger = new Logger(WaitingRoomManagementHandler.name);

    constructor(
        
        private readonly waitingRoomService: WaitingRoomService,
        private readonly gameRoomService: GameRoomService,
        private readonly gameService: GameService,
        private readonly customChannelService: CustomChannelService,
    ) {}

    /**
     * Handles room creation
     */
    async handleCreateRoom(
        data: { roomId: string; gameId: string; host: Player },
        socket: Socket,
        server: Server,
    ): Promise<{ success: boolean; error?: string }> {
        try {
            data.host.inventory = [];
            const room = this.waitingRoomService.createRoom(data.roomId, data.gameId, data.host, socket.id);
            this.logger.log(`Salle ${data.roomId} créée par ${data.host.id}`);
            socket.join(data.roomId);
            server.to(socket.id).emit(WaitingRoomEvents.WaitingRoomCreated, room);
            server.to(data.roomId).emit(WaitingRoomEvents.UpdateAvatarReserved, { reservedAvatars: room.reservedAvatars });

            // Créer le canal de partie et y ajouter le créateur
            try {
                const channelName = `Partie ${data.roomId}`;
                await this.customChannelService.createGameChannel(data.roomId, channelName);
                socket.join(`custom-channel-${data.roomId}`);
                socket.emit(CustomChannelEvents.CustomChannelJoined, {
                    channelId: data.roomId,
                    channelName,
                    isGameChannel: true,
                });
                socket.emit(CustomChannelEvents.CustomChannelMessagesResponse, { channelId: data.roomId, messages: [] });
            } catch (channelError) {
                this.logger.error(`Erreur création canal de partie ${data.roomId}: ${channelError.message}`);
            }

            return { success: true };
        } catch (error) {
            this.logger.error(`Erreur création room: ${error.message}`);
            return { success: false, error: error.message };
        }
    }

    /**
     * Handles player joining a room
     */
    async handleJoinRoom(roomId: string, socket: Socket): Promise<void> {
        try {
            const room = this.waitingRoomService.findRoomById(roomId);
            if (!room) throw new Error("La salle n'existe pas");
            if (room.isLocked) throw new Error('La salle est verrouillée');

            socket.emit(WaitingRoomEvents.JoinRoomResponse, { success: true, room });
            this.waitingRoomService.joinRoom(roomId, socket.id);
            socket.join(roomId);
            this.logger.log(`Joueur ${socket.id} a rejoint la salle ${roomId}`);

            // Rejoindre le canal de partie
            try {
                const messages = await this.customChannelService.getMessages(roomId);
                socket.join(`custom-channel-${roomId}`);
                socket.emit(CustomChannelEvents.CustomChannelJoined, {
                    channelId: roomId,
                    channelName: `Partie ${roomId}`,
                    isGameChannel: true,
                });
                socket.emit(CustomChannelEvents.CustomChannelMessagesResponse, { channelId: roomId, messages });
            } catch (channelError) {
                this.logger.error(`Erreur rejoindre canal de partie ${roomId}: ${channelError.message}`);
            }
        } catch (error) {
            socket.emit(WaitingRoomEvents.JoinRoomResponse, { success: false, error: error.message });
        }
    }

    /**
     * Handles player leaving a room
     */
    async handleLeaveRoom(roomId: string, socket: Socket, server: Server): Promise<void> {
        try {
            this.logger.log(`Salle ${roomId} : joueur ${socket.id} essaye de quitter la salle`);
            const isRoomDeleted = this.waitingRoomService.leaveRoom(roomId, socket.id);

            if (isRoomDeleted) {
                socket.emit(WaitingRoomEvents.LeaveRoomResponse, { success: true });
                server.except(socket.id).to(roomId).emit(WaitingRoomEvents.RoomCanceled);
                this.logger.log(`Salle ${roomId} supprimée, car l'organisateur a quitté.`);

                // Faire quitter le canal de partie à l'organisateur
                socket.leave(`custom-channel-${roomId}`);
                socket.emit(CustomChannelEvents.CustomChannelDeleted, { channelId: roomId });

                // Supprimer le canal de partie et notifier les autres joueurs
                try {
                    server.to(`custom-channel-${roomId}`).emit(CustomChannelEvents.CustomChannelDeleted, { channelId: roomId });
                    await this.customChannelService.deleteGameChannel(roomId);
                } catch (channelError) {
                    this.logger.error(`Erreur suppression canal de partie ${roomId}: ${channelError.message}`);
                }
            } else {
                server.to(roomId).emit(WaitingRoomEvents.PlayerLeft, { playerId: socket.id });
                const room = this.waitingRoomService.findRoomById(roomId);
                server.to(roomId).emit(WaitingRoomEvents.UpdateAvatarReserved, { reservedAvatars: room.reservedAvatars });
                socket.emit(WaitingRoomEvents.LeaveRoomResponse, { success: true });
                this.logger.log(`Joueur ${socket.id} a quitté la salle ${roomId}`);

                // Faire quitter le canal de partie au joueur qui part
                socket.leave(`custom-channel-${roomId}`);
                socket.emit(CustomChannelEvents.CustomChannelLeft, { channelId: roomId });
            }
        } catch (error) {
            socket.emit(WaitingRoomEvents.LeaveRoomResponse, { success: false, error: error.message });
        }
    }

    /**
     * Handles room lock toggle
     */
    handleLockRoom(roomId: string, socket: Socket, server: Server): void {
        try {
            this.logger.log('toggle lock from gateway', roomId, socket.id);
            const isLocked = this.waitingRoomService.toggleLockRoom(roomId, socket.id);

            if (isLocked) {
                server.to(roomId).emit(WaitingRoomEvents.WaitingRoomLocked);
                this.logger.log(`Salle ${roomId} verrouillée par ${socket.id}`);
            } else {
                server.to(roomId).emit(WaitingRoomEvents.WaitingRoomUnlocked);
                this.logger.log(`Salle ${roomId} déverrouillée par ${socket.id}`);
            }
        } catch (error) {
            socket.emit(WaitingRoomEvents.WaitingRoomError, error.message);
        }
    }

    /**
     * Handles drop-in/drop-out toggle
     */
    handleToggleDropInDropOut(roomId: string, socket: Socket, server: Server): void {
        try {
            const isEnabled = this.waitingRoomService.toggleDropInDropOut(roomId, socket.id);
            server.to(roomId).emit(WaitingRoomEvents.DropInDropOutToggled, { dropInDropOut: isEnabled });
            this.logger.log(`Salle ${roomId} drop-in/drop-out ${isEnabled ? 'activé' : 'désactivé'} par ${socket.id}`);
        } catch (error) {
            socket.emit(WaitingRoomEvents.WaitingRoomError, error.message);
        }
    }

    /**
     * Handles player disconnection
     */
    async handleDisconnect(socket: Socket, server: Server): Promise<void> {
        try {
            this.logger.log(`socket déconnecté: ${socket.id}`);
            const rooms = this.waitingRoomService.findRoomsByPlayerId(socket.id);

            if (rooms && rooms.length > 0) {
                for (const room of rooms) {
                    const isRoomDeleted = this.waitingRoomService.leaveRoom(room.roomId, socket.id);

                    if (isRoomDeleted) {
                        server.to(room.roomId).emit(WaitingRoomEvents.RoomCanceled);
                        this.logger.log(`Salle ${room.roomId} supprimée, car l'organisateur s'est déconnecté.`);

                        // Faire quitter le canal de partie (le socket peut encore être actif à ce stade)
                        socket.leave(`custom-channel-${room.roomId}`);
                        try {
                            socket.emit(CustomChannelEvents.CustomChannelDeleted, { channelId: room.roomId });
                        } catch {
                            // Le socket peut être déjà déconnecté, ce n'est pas grave
                        }

                        // Supprimer le canal de partie et notifier les autres joueurs
                        try {
                            server.to(`custom-channel-${room.roomId}`).emit(CustomChannelEvents.CustomChannelDeleted, {
                                channelId: room.roomId,
                            });
                            await this.customChannelService.deleteGameChannel(room.roomId);
                        } catch (channelError) {
                            this.logger.error(`Erreur suppression canal de partie ${room.roomId}: ${channelError.message}`);
                        }
                    } else {
                        server.to(room.roomId).emit(WaitingRoomEvents.PlayerLeft, { playerId: socket.id });
                        const updatedRoom = this.waitingRoomService.findRoomById(room.roomId);
                        if (updatedRoom) {
                            server.to(room.roomId).emit(WaitingRoomEvents.UpdateAvatarReserved, {
                                reservedAvatars: updatedRoom.reservedAvatars,
                            });
                        }
                        this.logger.log(`Joueur ${socket.id} a quitté la salle ${room.roomId} suite à une déconnexion`);
                    }
                }
            }
        } catch (error) {
            this.logger.error(`Erreur lors du traitement de la déconnexion du joueur ${socket.id}: ${error.message}`);
        }
    }

    async handleGetAvailableRooms(socket: Socket): Promise<void> {
        try {
            const waitingRooms = this.waitingRoomService.getAvailableRooms();
            const gameRooms = this.gameRoomService.getAvailableRooms();

            const roomInfos: RoomInfo[] = [];

            for (const room of waitingRooms) {
                try {
                    const game = await this.gameService.getGameById(room.gameId);
                    const maxPlayers = SIZE_LIMITS[game.board.size] || 2;
                    roomInfos.push({
                        roomId: room.roomId,
                        gameName: game.name,
                        boardSize: game.board.size,
                        board: game.board,
                        mode: game.mode,
                        playerCount: room.players.length,
                        maxPlayers,
                        status: 'waiting',
                        isLocked: room.isLocked,
                        dropInDropOut: room.dropInDropOut || false,
                    });
                } catch {
                    this.logger.warn(`Jeu introuvable pour la salle ${room.roomId}`);
                }
            }

            for (const room of gameRooms) {
                try {
                    const game = await this.gameService.getGameById(room.gameId);
                    const maxPlayers = SIZE_LIMITS[game.board.size] || 2;
                    roomInfos.push({
                        roomId: room.roomId,
                        gameName: game.name,
                        boardSize: game.board.size,
                        board: game.board,
                        mode: game.mode,
                        playerCount: room.players.length,
                        maxPlayers,
                        status: 'playing',
                        isLocked: room.isLocked,
                        dropInDropOut: room.dropInDropOut || false,
                        abandonedPlayerFirebaseIds: room.abandonedPlayers
                            .map((ap) => ap.firebaseUid)
                            .filter((uid): uid is string => !!uid),
                    });
                } catch {
                    this.logger.warn(`Jeu introuvable pour la game room ${room.roomId}`);
                }
            }

            socket.emit(WaitingRoomEvents.AvailableRoomsResponse, roomInfos);
        } catch (error) {
            this.logger.error(`Erreur lors de la récupération des salles disponibles: ${error.message}`);
            socket.emit(WaitingRoomEvents.AvailableRoomsResponse, []);
        }
    }
}

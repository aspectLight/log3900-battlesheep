import { WaitingRoomService } from '@app/modules/shared-room/services/waiting-room.service';
import { Player } from '@app/shared/interfaces/player';
import { WaitingRoomEvents } from '@common/socket.constants';
import { Injectable, Logger } from '@nestjs/common';
import { Server, Socket } from 'socket.io';

/**
 * Handler for waiting room management events (create, join, leave, lock)
 */
@Injectable()
export class WaitingRoomManagementHandler {
    private readonly logger = new Logger(WaitingRoomManagementHandler.name);

    constructor(private readonly waitingRoomService: WaitingRoomService) {}

    /**
     * Handles room creation
     */
    handleCreateRoom(data: { roomId: string; gameId: string; host: Player }, socket: Socket, server: Server): { success: boolean; error?: string } {
        try {
            data.host.inventory = [];
            const room = this.waitingRoomService.createRoom(data.roomId, data.gameId, data.host, socket.id);
            this.logger.log(`Salle ${data.roomId} créée par ${data.host.id}`);
            socket.join(data.roomId);
            server.to(socket.id).emit(WaitingRoomEvents.WaitingRoomCreated, room);
            server.to(data.roomId).emit(WaitingRoomEvents.UpdateAvatarReserved, { reservedAvatars: room.reservedAvatars });
            return { success: true };
        } catch (error) {
            this.logger.error(`Erreur création room: ${error.message}`);
            return { success: false, error: error.message };
        }
    }

    /**
     * Handles player joining a room
     */
    handleJoinRoom(roomId: string, socket: Socket): void {
        try {
            const room = this.waitingRoomService.findRoomById(roomId);
            if (!room) throw new Error('Room does not exist');
            if (room.isLocked) throw new Error('Room is locked');

            socket.emit(WaitingRoomEvents.JoinRoomResponse, { success: true, room });
            this.waitingRoomService.joinRoom(roomId, socket.id);
            socket.join(roomId);
            this.logger.log(`Joueur ${socket.id} a rejoint la salle ${roomId}`);
        } catch (error) {
            socket.emit(WaitingRoomEvents.JoinRoomResponse, { success: false, error: error.message });
        }
    }

    /**
     * Handles player leaving a room
     */
    handleLeaveRoom(roomId: string, socket: Socket, server: Server): void {
        try {
            this.logger.log(`Salle ${roomId} : joueur ${socket.id} essaye de quitter la salle`);
            const isRoomDeleted = this.waitingRoomService.leaveRoom(roomId, socket.id);

            if (isRoomDeleted) {
                socket.emit(WaitingRoomEvents.LeaveRoomResponse, { success: true });
                server.except(socket.id).to(roomId).emit(WaitingRoomEvents.RoomCanceled);
                this.logger.log(`Salle ${roomId} supprimée, car l'organisateur a quitté.`);
            } else {
                server.to(roomId).emit(WaitingRoomEvents.PlayerLeft, { playerId: socket.id });
                const room = this.waitingRoomService.findRoomById(roomId);
                server.to(roomId).emit(WaitingRoomEvents.UpdateAvatarReserved, { reservedAvatars: room.reservedAvatars });
                socket.emit(WaitingRoomEvents.LeaveRoomResponse, { success: true });
                this.logger.log(`Joueur ${socket.id} a quitté la salle ${roomId}`);
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
     * Handles player disconnection
     */
    handleDisconnect(socket: Socket, server: Server): void {
        try {
            this.logger.log(`socket déconnecté: ${socket.id}`);
            const rooms = this.waitingRoomService.findRoomsByPlayerId(socket.id);

            if (rooms && rooms.length > 0) {
                rooms.forEach((room) => {
                    const isRoomDeleted = this.waitingRoomService.leaveRoom(room.roomId, socket.id);

                    if (isRoomDeleted) {
                        server.to(room.roomId).emit(WaitingRoomEvents.RoomCanceled);
                        this.logger.log(`Salle ${room.roomId} supprimée, car l'organisateur s'est déconnecté.`);
                    } else {
                        server.to(room.roomId).emit(WaitingRoomEvents.PlayerLeft, { playerId: socket.id });
                        const updatedRoom = this.waitingRoomService.findRoomById(room.roomId);
                        if (updatedRoom) {
                            server.to(room.roomId).emit(WaitingRoomEvents.UpdateAvatarReserved, { reservedAvatars: updatedRoom.reservedAvatars });
                        }
                        this.logger.log(`Joueur ${socket.id} a quitté la salle ${room.roomId} suite à une déconnexion`);
                    }
                });
            }
        } catch (error) {
            this.logger.error(`Erreur lors du traitement de la déconnexion du joueur ${socket.id}: ${error.message}`);
        }
    }
}

import { GameRoomService } from '@app/modules/shared-room/services/game-room.service';
import { WaitingRoomService } from '@app/modules/shared-room/services/waiting-room.service';
import { Player } from '@app/shared/interfaces/player';
import { WaitingRoomEvents } from '@common/socket.constants';
import { Injectable, Logger } from '@nestjs/common';
import { Server, Socket } from 'socket.io';

/**
 * Handler for player management in waiting room (create, kick, avatar reservation)
 */
@Injectable()
export class WaitingRoomPlayerHandler {
    private readonly logger = new Logger(WaitingRoomPlayerHandler.name);

    constructor(
        private readonly waitingRoomService: WaitingRoomService,
        private readonly gameRoomService: GameRoomService,
    ) {}

    /**
     * Handles player creation in waiting room
     */
    handleCreatePlayer(data: { roomId: string; player: Player }, socket: Socket, server: Server): void {
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
                data.player.inventory = [];

                if (data.player.isVirtual === true) {
                    this.waitingRoomService.addCharacter(data.roomId, data.player, data.player.name);
                } else {
                    this.waitingRoomService.addCharacter(data.roomId, data.player, socket.id);
                }

                server.to(data.roomId).emit(WaitingRoomEvents.PlayerCreated, room.players);
                this.logger.log(`Joueur ${data.player.name} ajouté à la salle : ${data.roomId}`);
            }
        } catch (error) {
            socket.emit(WaitingRoomEvents.WaitingRoomError, error.message);
        }
    }

    /**
     * Handles avatar reservation
     */
    handleReserveAvatar(
        data: { roomId: string; chosenAvatar: string; playerId: string },
        socket: Socket,
        server: Server,
    ): { success: boolean; error?: string } {
        try {
            this.waitingRoomService.reserveCharacter(data.roomId, data.playerId, data.chosenAvatar);
            const room = this.waitingRoomService.findRoomById(data.roomId);

            if (room) {
                server.to(data.roomId).emit(WaitingRoomEvents.UpdateAvatarReserved, { reservedAvatars: room.reservedAvatars });
                this.logger.log(`Joueur ${socket.id} a réservé l'avatar ${data.chosenAvatar}`);
            }

            return { success: true };
        } catch (error) {
            this.logger.error(`Erreur réservation avatar: ${error.message}`);
            return { success: false, error: error.message };
        }
    }

    /**
     * Handles getting reserved avatars
     */
    handleGetReservedAvatars(data: { roomId: string }, socket: Socket): void {
        try {
            const waitingRoom = this.waitingRoomService.findRoomById(data.roomId);

            if (waitingRoom) {
                socket.emit(WaitingRoomEvents.UpdateAvatarReserved, { reservedAvatars: waitingRoom.reservedAvatars });
            } else {
                // For drop-in: look in game rooms and build reserved list from active players
                const gameRoom = this.gameRoomService.findRoomById(data.roomId);
                if (gameRoom) {
                    const reservedAvatars = gameRoom.players
                        .filter((p) => p.avatar)
                        .map((p) => ({ reservorId: p.id, chosenAvatar: p.avatar?.name as string }));
                    socket.emit(WaitingRoomEvents.UpdateAvatarReserved, { reservedAvatars });
                } else {
                    socket.emit(WaitingRoomEvents.UpdateAvatarReserved, { reservedAvatars: [] });
                }
            }

            this.logger.log(`Joueur ${socket.id} a demandé la liste des avatars réservés de la room ${data.roomId}`);
        } catch (error) {
            socket.emit(WaitingRoomEvents.WaitingRoomError, error.message);
        }
    }

    /**
     * Handles player kick
     */
    handleKickPlayer(data: { roomId: string; player: Player }, socket: Socket, server: Server): void {
        try {
            const isKicked = this.waitingRoomService.kickPlayer(data.roomId, socket.id, data.player);

            if (isKicked) {
                server.to(data.roomId).emit(WaitingRoomEvents.PlayerLeft, { playerId: data.player.id });
                const room = this.waitingRoomService.findRoomById(data.roomId);
                server.to(data.roomId).emit(WaitingRoomEvents.UpdateAvatarReserved, { reservedAvatars: room.reservedAvatars });
                server.to(data.player.id).emit(WaitingRoomEvents.PlayerKicked);
                this.logger.log(`Joueur ${data.player.name} expulsé de la salle ${data.roomId}`);
            }
        } catch (error) {
            socket.emit(WaitingRoomEvents.WaitingRoomError, error.message);
        }
    }
}

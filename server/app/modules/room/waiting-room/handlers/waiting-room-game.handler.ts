import { GameRoomService } from '@app/modules/shared-room/services/game-room.service';
import { WaitingRoomService } from '@app/modules/shared-room/services/waiting-room.service';
import { GameRoomEvents, WaitingRoomEvents } from '@common/socket.constants';
import { ErrorMessages } from '@common/error-messages.constants';
import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { Server, Socket } from 'socket.io';

/**
 * Handler for game start and transition from waiting room to game room
 */
@Injectable()
export class WaitingRoomGameHandler {
    private readonly logger = new Logger(WaitingRoomGameHandler.name);
    /** Serializes start-game per waiting room so concurrent hosts cannot race across `await`s. */
    private readonly startGameTailByRoom = new Map<string, Promise<{ success: boolean; error?: string }>>();

    constructor(
        private readonly waitingRoomService: WaitingRoomService,
        private readonly gameRoomService: GameRoomService,
    ) {}

    /**
     * Handles game start - transitions from waiting room to game room
     */
    async handleStartGame(roomId: string, server: Server): Promise<{ success: boolean; error?: string }> {
        const previous = this.startGameTailByRoom.get(roomId) ?? Promise.resolve({ success: true });
        const current = previous.then(() => this.executeStartGame(roomId, server));
        this.startGameTailByRoom.set(roomId, current);
        try {
            return await current;
        } finally {
            if (this.startGameTailByRoom.get(roomId) === current) {
                this.startGameTailByRoom.delete(roomId);
            }
        }
    }

    private async executeStartGame(roomId: string, server: Server): Promise<{ success: boolean; error?: string }> {
        try {
            const waitingRoom = this.waitingRoomService.findRoomById(roomId);
            if (!waitingRoom) {
                throw new Error(ErrorMessages.RoomDoesNotExist);
            }

            const gameRoom = await this.gameRoomService.createRoom(waitingRoom as any);
            const sockets = await server.in(roomId).fetchSockets();

            for (const playerSocket of sockets) {
                playerSocket.leave(roomId);
                playerSocket.join(gameRoom.roomId);
            }

            this.waitingRoomService.deleteRoom(roomId);
            server.to(gameRoom.roomId).emit(GameRoomEvents.GameRoomCreated, gameRoom);
            server.emit(WaitingRoomEvents.AvailableRoomsChanged);
            this.logger.log(`Lancement de la partie liée à la salle ${roomId}`);

            return { success: true };
        } catch (error) {
            this.logger.error(`Erreur démarrage partie: ${error.message}`);

            if (error instanceof NotFoundException) {
                this.waitingRoomService.deleteRoom(roomId);
                server.to(roomId).emit(WaitingRoomEvents.RoomCanceled);
                server.emit(WaitingRoomEvents.AvailableRoomsChanged);
                this.logger.log(`Salle ${roomId} dissoute car le jeu a été supprimé`);
            }

            return { success: false, error: error.message };
        }
    }

    /**
     * Handles code generation for room
     */
    handleGenerateCode(socket: Socket): void {
        const code = this.waitingRoomService.generateCode();
        socket.emit(WaitingRoomEvents.GenerateCodeResponse, { code });
    }
}

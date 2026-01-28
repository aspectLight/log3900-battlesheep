import { GameMovementService } from '@app/modules/movement/services/game-movement.service';
import { MS_IN_SECOND, SECONDS_IN_MINUTE } from '@app/modules/shared-room/constants/game-room.constants';
import { GameRoomService } from '@app/modules/shared-room/services/game-room.service';
import { GameRoomEvents } from '@common/socket.constants';
import { Injectable, Logger } from '@nestjs/common';
import { Server, Socket } from 'socket.io';

/**
 * Handler for game lifecycle events (start, finish, debug mode)
 */
@Injectable()
export class GameLifecycleHandler {
    private readonly logger = new Logger(GameLifecycleHandler.name);

    constructor(
        private readonly gameRoomService: GameRoomService,
        private readonly gameMovementService: GameMovementService,
    ) {}

    /**
     * Handles game start - spawns players and prepares first turn
     */
    async handlePlayGame(roomId: string, socket: Socket, server: Server): Promise<void> {
        try {
            const room = this.gameRoomService.findRoomById(roomId);
            room.players = await this.gameMovementService.addPlayersToBoard(room.gameId, room.players);
            server.to(roomId).emit(GameRoomEvents.PlayerSpawned, room.players);
            this.gameRoomService.setServer(server);
            this.gameRoomService.prepareNextTurn(roomId);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    /**
     * Handles game completion - calculates duration and notifies players
     */
    handleFinishGame(data: { roomId: string; winnerId: string }, socket: Socket, server: Server): void {
        try {
            const room = this.gameRoomService.findRoomById(data.roomId);
            const diffSeconds = Math.floor((Date.now() - room.startTime.getTime()) / MS_IN_SECOND);
            room.globalStats.gameDuration = `${String(Math.floor(diffSeconds / SECONDS_IN_MINUTE)).padStart(2, '0')}:${String(
                diffSeconds % SECONDS_IN_MINUTE,
            ).padStart(2, '0')}`;
            this.gameRoomService.pauseTimer(data.roomId);
            server.to(data.roomId).emit(GameRoomEvents.FinishGame, data.winnerId);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    /**
     * Handles players leaving the end game screen
     */
    async handleLeaveEndGame(roomId: string, socket: Socket, server: Server): Promise<void> {
        try {
            socket.leave(roomId);
            if ((await server.in(roomId).fetchSockets()).length === 0) {
                this.gameRoomService.deleteRoomById(roomId);
            }
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    /**
     * Handles debug mode toggle
     */
    handleToggleDebugMode(roomId: string, socket: Socket, server: Server): void {
        try {
            const isDebugging = this.gameRoomService.toggleDebugMode(roomId);
            if (isDebugging) {
                server.to(roomId).emit(GameRoomEvents.DebugModeEnabled);
            } else {
                server.to(roomId).emit(GameRoomEvents.DebugModeDisabled);
            }
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }
}

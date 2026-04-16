import { GameMovementService } from '@app/modules/movement/services/game-movement.service';
import { GameRoomService } from '@app/modules/shared-room/services/game-room.service';
import { GameRoomEvents } from '@common/socket.constants';
import { Injectable } from '@nestjs/common';
import { Socket } from 'socket.io';

/**
 * Handler for statistics retrieval events
 */
@Injectable()
export class StatisticsHandler {
    constructor(
        private readonly gameRoomService: GameRoomService,
        private readonly gameMovementService: GameMovementService,
    ) {}

    /**
     * Handles statistics request
     */
    async handleGetStatistics(roomId: string, socket: Socket): Promise<void> {
        try {
            const room = this.gameRoomService.findRoomById(roomId);
            if (!room.globalStats) {
                room.globalStats = { gameDuration: '', doorsToggled: [], turns: 0 };
            }
            const statistics = {
                playerStats: room.playersStats,
                globalStats: room.globalStats,
                walkableTiles: this.gameMovementService.getWalkableTiles(roomId),
                toggableDoors: this.gameMovementService.getAllDoors(roomId),
            };
            socket.emit(GameRoomEvents.GetStatisticsResponse, statistics);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }
}

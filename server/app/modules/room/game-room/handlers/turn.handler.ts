import { GameRoomService } from '@app/modules/shared-room/services/game-room.service';
import { GameRoomEvents } from '@common/socket.constants';
import { Injectable } from '@nestjs/common';
import { Socket } from 'socket.io';

/**
 * Handler for turn management events
 */
@Injectable()
export class TurnHandler {
    constructor(private readonly gameRoomService: GameRoomService) {}

    /**
     * Handles turn end request
     */
    handleEndTurn(roomId: string, socket: Socket): void {
        try {
            const room = this.gameRoomService.findRoomById(roomId);
            if (!room || room.players.length === 0) return;

            const currentPlayer = room.players[0];
            const isCurrentPlayer = currentPlayer.id === socket.id;
            const isHostEndingForVirtual = room.hostId === socket.id && currentPlayer.isVirtual;

            if (!isCurrentPlayer && !isHostEndingForVirtual) return;

            this.gameRoomService.endTurn(roomId);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }
}

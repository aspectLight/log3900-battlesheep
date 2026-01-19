import { GameRoomService } from '@app/modules/shared-room/services/game-room.service';
import { GameRoomEvents } from '@common/socket.constants';
import { Injectable } from '@nestjs/common';
import { Server, Socket } from 'socket.io';

/**
 * Handler for chat and messaging events
 */
@Injectable()
export class ChatHandler {
    constructor(private readonly gameRoomService: GameRoomService) {}

    /**
     * Handles sending messages to the game room
     */
    async handleSendMessage(data: { message: string; playerName: string | null; roomId: string }, socket: Socket, server: Server): Promise<void> {
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
            server.except(socket.id).to(data.roomId).emit(GameRoomEvents.MassMessage, message);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }
}

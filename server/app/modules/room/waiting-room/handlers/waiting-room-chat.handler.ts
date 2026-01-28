import { GameRoomService } from '@app/modules/shared-room/services/game-room.service';
import { WaitingRoomService } from '@app/modules/shared-room/services/waiting-room.service';
import { GameRoomEvents, WaitingRoomEvents } from '@common/socket.constants';
import { Injectable, Logger } from '@nestjs/common';
import { Server, Socket } from 'socket.io';

/**
 * Handler for chat and journal events in waiting room
 */
@Injectable()
export class WaitingRoomChatHandler {
    private readonly logger = new Logger(WaitingRoomChatHandler.name);

    constructor(
        private readonly waitingRoomService: WaitingRoomService,
        private readonly gameRoomService: GameRoomService,
    ) {}

    /**
     * Handles sending messages in waiting room
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

            this.waitingRoomService.addMessage(data.roomId, message);
            server.except(socket.id).to(data.roomId).emit(WaitingRoomEvents.MassMessage, message);
            this.logger.log(`Joueur ${socket.id} a envoyé le message ${data.message} (salle ${data.roomId})`);
        } catch (error) {
            socket.emit(WaitingRoomEvents.WaitingRoomError, error.message);
        }
    }

    /**
     * Handles getting messages from waiting room
     */
    async handleGetMessagesFromWaitingRoom(roomId: string, socket: Socket): Promise<void> {
        try {
            const room = this.waitingRoomService.findRoomById(roomId);
            socket.emit(WaitingRoomEvents.GetMessagesResponse, room.messages);
            this.logger.log(`Joueur ${socket.id} a demandé tous les messages de la room ${roomId})`);
        } catch (error) {
            socket.emit(WaitingRoomEvents.WaitingRoomError, error.message);
        }
    }

    /**
     * Handles adding journal entry (for game room)
     */
    async handleAddJournalEntry(data: { roomId: string; entry: { type: string; content: string } }, socket: Socket, server: Server): Promise<void> {
        try {
            const entry = {
                type: data.entry.type,
                content: data.entry.content,
                time: new Date().toLocaleTimeString('en-GB', {
                    hour: '2-digit',
                    minute: '2-digit',
                    second: '2-digit',
                    hour12: false,
                }),
            };

            this.gameRoomService.addJournalEntry(data.roomId, entry);
            server.to(data.roomId).emit(GameRoomEvents.AddJournalEntry, entry);
            this.logger.log(`Joueur ${socket.id} a ajouté une entrée de journal dans la room ${data.roomId}`);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }
}

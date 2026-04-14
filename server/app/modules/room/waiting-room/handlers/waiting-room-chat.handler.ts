import { ChatModerationService } from '@app/modules/general-chat/services/chat-moderation.service';
import { WaitingRoomService } from '@app/modules/shared-room/services/waiting-room.service';
import { BlockService } from '@app/modules/social/services/block.service';
import { WaitingRoomEvents } from '@common/socket.constants';
import { Injectable, Logger } from '@nestjs/common';
import { Server, Socket } from 'socket.io';

/**
 * Handler for chat events in waiting room
 */
@Injectable()
export class WaitingRoomChatHandler {
    private readonly logger = new Logger(WaitingRoomChatHandler.name);

    constructor(
        private readonly waitingRoomService: WaitingRoomService,
        private readonly chatModerationService: ChatModerationService,
        private readonly blockService: BlockService,
    ) {}

    /**
     * Handles sending messages in waiting room
     */
    async handleSendMessage(data: { message: string; playerName: string | null; roomId: string }, socket: Socket, server: Server): Promise<void> {
        try {
            const room = this.waitingRoomService.findRoomById(data.roomId);
            const player = room?.players.find((p) => p.name === data.playerName);
            const avatarId = player?.avatar?.name ? player.avatar.name.toLowerCase() : undefined;

            // Censurer le message avant de le diffuser
            const censoredMessage = this.chatModerationService.censor(data.message);

            const message = {
                type: 'received',
                name: data.playerName,
                content: censoredMessage,
                time: new Date().toLocaleTimeString('en-GB', {
                    hour: '2-digit',
                    minute: '2-digit',
                    second: '2-digit',
                    hour12: false,
                }),
                avatarId,
            };

            this.waitingRoomService.addMessage(data.roomId, message);

            // Find socket IDs of players in a block relationship with the sender
            const blockedSocketIds = data.playerName ? await this.getBlockedPlayerSocketIds(data.playerName, data.roomId) : [];
            server.except([socket.id, ...blockedSocketIds]).to(data.roomId).emit(WaitingRoomEvents.MassMessage, message);
            socket.emit(WaitingRoomEvents.MassMessage, message);
            this.logger.log(`Joueur ${socket.id} a envoyé le message ${censoredMessage} (salle ${data.roomId})`);
        } catch (error) {
            socket.emit(WaitingRoomEvents.WaitingRoomError, error.message);
        }
    }

    /**
     * Returns socket IDs of room players in a block relationship with senderName.
     * In waiting rooms player.id is the socket ID and player.name is the username.
     */
    private async getBlockedPlayerSocketIds(senderName: string, roomId: string): Promise<string[]> {
        const room = this.waitingRoomService.findRoomById(roomId);
        if (!room) return [];

        const [blockedByMe, whoBlockedMe] = await Promise.all([
            this.blockService.getBlockedUsers(senderName),
            this.blockService.getUsersWhoBlocked(senderName),
        ]);
        const blocked = new Set([...blockedByMe, ...whoBlockedMe]);

        return room.players
            .filter((p) => p.name && blocked.has(p.name))
            .map((p) => p.id);
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
}

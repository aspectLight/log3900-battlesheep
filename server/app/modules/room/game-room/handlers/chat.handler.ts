import { ChatModerationService } from '@app/modules/general-chat/services/chat-moderation.service';
import { GameRoomService } from '@app/modules/shared-room/services/game-room.service';
import { BlockService } from '@app/modules/social/services/block.service';
import { GameRoomEvents } from '@common/socket.constants';
import { Injectable } from '@nestjs/common';
import { Server, Socket } from 'socket.io';

/**
 * Handler for chat and messaging events
 */
@Injectable()
export class ChatHandler {
    constructor(
        private readonly gameRoomService: GameRoomService,
        private readonly chatModerationService: ChatModerationService,
        private readonly blockService: BlockService,
    ) {}

    /**
     * Handles sending messages to the game room
     */
    async handleSendMessage(data: { message: string; playerName: string | null; roomId: string }, socket: Socket, server: Server): Promise<void> {
        try {
            const room = this.gameRoomService.findRoomById(data.roomId);
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
            this.gameRoomService.addMessage(data.roomId, message);

            // Find socket IDs of players in a block relationship with the sender
            const blockedSocketIds = data.playerName ? await this.getBlockedPlayerSocketIds(data.playerName, data.roomId) : [];
            server.except([socket.id, ...blockedSocketIds]).to(data.roomId).emit(GameRoomEvents.MassMessage, message);
            socket.emit(GameRoomEvents.MassMessage, message);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    /**
     * Returns socket IDs of room players in a block relationship with senderName.
     * In game rooms player.id is the socket ID and player.name is the username.
     */
    private async getBlockedPlayerSocketIds(senderName: string, roomId: string): Promise<string[]> {
        const room = this.gameRoomService.findRoomById(roomId);
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
}

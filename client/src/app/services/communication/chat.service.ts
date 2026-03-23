import { Injectable } from '@angular/core';
import { RoomSocketService } from '@app/services/communication/socket-handlers/room-socket.service';
import { SocketService } from '@app/services/communication/socket-handlers/socket.service';
import { SocialService } from '@app/services/communication/social.service';
import { WaitingRoomService } from '@app/services/lobby/waiting-room.service';
import { GameRoomService } from '@app/services/state/game-room.service';
import { GeneralChatEvents } from '@common/socket.constants';

@Injectable({
    providedIn: 'root',
})
export class ChatService {
    messages: { type: string; name?: string | null; content: string; time: string; avatarId?: string | null; avatarUrl?: string | null }[] = [];
    playerName: string | null = null;
    username: string | null = null;
    avatarId: string | null = null;
    avatarUrl: string | null = null;
    private scrollCallback: (() => void) | null = null;

    constructor(
        private socketService: SocketService,
        private roomSocketService: RoomSocketService,
        private waitingRoomService: WaitingRoomService,
        private gameRoomService: GameRoomService,
        private socialService: SocialService,
    ) {
        this.setupListeners();
    }

    setupListeners(): void {
        this.socketService.on(
            'massMessage',
            (message: { type: string; name?: string | null; content: string; time: string; avatarId?: string | null; avatarUrl?: string | null }) => {
                if (message.name && this.socialService.isInBlockRelationship(message.name)) return;
                this.messages.push(message);
                this.triggerScroll();
            },
        );

        this.socketService.on(
            'getMessagesResponse',
            (messages: {
                type: string;
                name?: string | null;
                content: string;
                time: string;
                avatarId?: string | null;
                avatarUrl?: string | null;
            }[]) => {
                this.messages = messages.filter((m) => !m.name || !this.socialService.isInBlockRelationship(m.name));
                this.triggerScroll();
            },
        );

        this.socketService.on(
            GeneralChatEvents.GeneralChatMessage,
            (message: { type: string; name: string; content: string; time: string; avatarId?: string | null; avatarUrl?: string | null }) => {
                if (this.socialService.isInBlockRelationship(message.name)) return;
                this.messages.push(message);
                this.triggerScroll();
            },
        );

        this.socketService.on(
            GeneralChatEvents.GeneralChatEmoji,
            (emoji: { type: string; name: string; content: string; time: string; avatarId?: string | null; avatarUrl?: string | null }) => {
                if (this.socialService.isInBlockRelationship(emoji.name)) return;
                this.messages.push(emoji);
                this.triggerScroll();
            },
        );

        this.socketService.on(
            GeneralChatEvents.GetGeneralChatMessagesResponse,
            (messages: { type: string; name: string; content: string; time: string; avatarId?: string | null; avatarUrl?: string | null }[]) => {
                this.messages = messages.filter((m) => !this.socialService.isInBlockRelationship(m.name));
                this.triggerScroll();
            },
        );
        this.socketService.on('connect', () => {
            if (this.username) {
                this.socketService.send(GeneralChatEvents.JoinGeneralChat, this.username);
            }
        });
    }

    getMessagesFromWaitingRoom() {
        this.roomSocketService.getMessagesFromWaitingRoom();
        this.playerName = this.waitingRoomService.getPlayerFromId(this.roomSocketService.getId() || '')?.name || '';
    }

    clearMessages() {
        this.messages = [];
    }

    sendMessageToWaitingRoom(newMessage: string) {
        const room = this.waitingRoomService.currentRoom.getValue();
        const player = room.players.find((p) => p.id === this.roomSocketService.getId());
        const avatarId = player?.avatar?.name ? player.avatar.name.toLowerCase() : null;

        this.messages.push({
            type: 'sent',
            name: this.playerName,
            content: newMessage,
            time: new Date().toLocaleTimeString('en-GB', {
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit',
                hour12: false,
            }),
            avatarId,
        });
        this.roomSocketService.sendMessageToWaitingRoom(newMessage, this.playerName);
    }

    sendMessageToGameRoom(newMessage: string) {
        const room = this.gameRoomService.room;
        const player = room.players.find((p) => p.id === this.socketService.getId());
        const avatarId = player?.avatar?.name ? player.avatar.name.toLowerCase() : null;

        this.messages.push({
            type: 'sent',
            name: this.playerName,
            content: newMessage,
            time: new Date().toLocaleTimeString('en-GB', {
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit',
                hour12: false,
            }),
            avatarId,
        });
        this.socketService.sendMessageToGameRoom(newMessage, this.playerName);
    }

    joinGeneralChat(username: string, avatarId?: string | null, avatarUrl?: string | null): void {
        this.username = username;
        this.avatarId = avatarId ?? null;
        this.avatarUrl = avatarUrl ?? null;
        this.socketService.send(GeneralChatEvents.JoinGeneralChat, username);
    }

    getGeneralChatMessages(): void {
        this.socketService.send(GeneralChatEvents.GetGeneralChatMessages);
        this.playerName = this.username;
    }

    sendMessageToGeneralChat(newMessage: string): void {
        this.socketService.send(GeneralChatEvents.SendMessageToGeneralChat, {
            username: this.username,
            message: newMessage,
            avatarId: this.avatarId,
            avatarUrl: this.avatarUrl,
        });
    }

    setScrollHandler(callback: () => void) {
        this.scrollCallback = callback;
    }

    triggerScroll() {
        this.scrollCallback?.();
    }
}

import { Injectable } from '@angular/core';
import { SocketService } from '@app/services/socket.service';
import { RoomSocketService } from './socket/room-socket.service';
import { WaitingRoomService } from './waiting-room.service';

@Injectable({
    providedIn: 'root',
})
export class ChatService {
    messages: { type: string; name?: string | null; content: string; time: string }[] = [];
    playerName: string | null = null;
    private scrollCallback: (() => void) | null = null;

    constructor(
        private socketService: SocketService,
        private roomSocketService: RoomSocketService,
        private waitingRoomService: WaitingRoomService,
    ) {
        this.socketService.on('massMessage', (message: { type: string; content: string; time: string }) => {
            this.messages.push(message);
            this.triggerScroll();
        });
        this.socketService.on('getMessagesResponse', (messages: { type: string; content: string; time: string }[]) => {
            this.messages = messages;
            this.triggerScroll();
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
        });
        this.roomSocketService.sendMessageToWaitingRoom(newMessage, this.playerName);
    }

    sendMessageToGameRoom(newMessage: string) {
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
        });
        this.socketService.sendMessageToGameRoom(newMessage, this.playerName);
    }

    setScrollHandler(callback: () => void) {
        this.scrollCallback = callback;
    }

    triggerScroll() {
        this.scrollCallback?.();
    }
}

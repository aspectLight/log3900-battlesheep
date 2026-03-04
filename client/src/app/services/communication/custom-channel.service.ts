import { Injectable } from '@angular/core';
import { AuthService } from '@app/services/communication/auth.service';
import { SocketService } from '@app/services/communication/socket-handlers/socket.service';
import { CustomChannelEvents } from '@common/socket.constants';
import { Subject } from 'rxjs';

export interface ChannelInfo {
    id: string;
    name: string;
    creator: string;
    memberCount: number;
}

export interface ChannelMessage {
    type: string;
    name?: string;
    content: string;
    time: string;
}

@Injectable({
    providedIn: 'root',
})
export class CustomChannelService {
    channels: ChannelInfo[] = [];
    channelError: string | null = null;

    channelsUpdated$ = new Subject<ChannelInfo[]>();
    channelCreated$ = new Subject<{ channelId: string; channelName: string }>();
    channelDeleted$ = new Subject<{ channelId: string }>();
    channelError$ = new Subject<string>();
    joinedChannels$ = new Subject<string[]>();
    messagesUpdated$ = new Subject<{ channelId: string; messages: ChannelMessage[] }>();

    private joinedChannelIds = new Set<string>();
    private joinedChannelNames = new Map<string, string>(); // channelId → display name
    private messagesByChannel: Record<string, ChannelMessage[]> = {};

    constructor(
        private socketService: SocketService,
        private authService: AuthService,
    ) {}

    get username(): string {
        return this.authService.currentUser?.displayName as string;
    }

    setupListeners(): void {
        const socket = this.socketService.socket;
        if (!socket) return;

        socket.on(CustomChannelEvents.CustomChannelsListResponse, (channels: ChannelInfo[]) => {
            const incomingIds = new Set(channels.map((c) => c.id));

            // Détecter les canaux qu'on croyait avoir rejoint mais qui n'existent plus sur le serveur
            const removedIds = [...this.joinedChannelIds].filter((id) => !incomingIds.has(id));
            for (const id of removedIds) {
                this.joinedChannelIds.delete(id);
                this.joinedChannelNames.delete(id);
                delete this.messagesByChannel[id];
                this.channelDeleted$.next({ channelId: id });
                this.messagesUpdated$.next({ channelId: id, messages: [] });
            }
            if (removedIds.length > 0) {
                this.joinedChannels$.next([...this.joinedChannelIds]);
            }

            this.channels = channels;
            this.channelsUpdated$.next(channels);
        });

        socket.on(CustomChannelEvents.CustomChannelCreated, (data: { channelId: string; channelName: string }) => {
            // Store the name so the chatbox dropdown can display it even before listChannels() is called
            this.joinedChannelNames.set(data.channelId, data.channelName);
            this.channelCreated$.next(data);
        });

        socket.on(CustomChannelEvents.CustomChannelDeleted, (data: { channelId: string }) => {
            this.channels = this.channels.filter((c) => c.id !== data.channelId);
            this.joinedChannelIds.delete(data.channelId);
            this.joinedChannelNames.delete(data.channelId);
            delete this.messagesByChannel[data.channelId];

            this.channelDeleted$.next(data);
            this.channelsUpdated$.next(this.channels);
            this.joinedChannels$.next([...this.joinedChannelIds]);
            this.messagesUpdated$.next({ channelId: data.channelId, messages: this.getMessages(data.channelId) });
        });

        socket.on(CustomChannelEvents.CustomChannelError, (data: { message: string }) => {
            this.channelError = data.message;
            this.channelError$.next(data.message);
        });

        socket.on(CustomChannelEvents.CustomChannelJoined, (data: { channelId: string; channelName: string }) => {
            this.joinedChannelIds.add(data.channelId);
            // Use the name sent by the server; fall back to channels list if available
            const name = data.channelName ?? this.channels.find((c) => c.id === data.channelId)?.name ?? data.channelId;
            this.joinedChannelNames.set(data.channelId, name);
            this.joinedChannels$.next([...this.joinedChannelIds]);
        });

        socket.on(CustomChannelEvents.CustomChannelLeft, (data: { channelId: string }) => {
            this.joinedChannelIds.delete(data.channelId);
            this.joinedChannelNames.delete(data.channelId);
            this.joinedChannels$.next([...this.joinedChannelIds]);
        });

        socket.on(CustomChannelEvents.CustomChannelMessagesResponse, (payload: { channelId: string; messages: ChannelMessage[] }) => {
            this.messagesByChannel[payload.channelId] = payload.messages;
            this.messagesUpdated$.next({ channelId: payload.channelId, messages: payload.messages });
        });

        socket.on(CustomChannelEvents.CustomChannelMessage, (payload: { channelId: string; message: ChannelMessage }) => {
            const current = this.messagesByChannel[payload.channelId] ?? [];
            this.messagesByChannel[payload.channelId] = [...current, payload.message];
            this.messagesUpdated$.next({
                channelId: payload.channelId,
                messages: this.messagesByChannel[payload.channelId],
            });
        });

        // Restauration des canaux à la (re)connexion : le serveur envoie automatiquement
        // la liste des canaux dont l'utilisateur est membre dans la BD.
        socket.on(CustomChannelEvents.UserChannelsRestored, (restoredChannels: { channelId: string; name: string }[]) => {
            for (const ch of restoredChannels) {
                this.joinedChannelIds.add(ch.channelId);
                this.joinedChannelNames.set(ch.channelId, ch.name);
                // Demander l'historique de messages pour chaque canal restauré
                this.socketService.send(CustomChannelEvents.GetCustomChannelMessages, { channelId: ch.channelId });
            }
            this.joinedChannels$.next([...this.joinedChannelIds]);
        });
    }

    listChannels(): void {
        this.socketService.send(CustomChannelEvents.ListCustomChannels);
    }

    createChannel(channelName: string): void {
        this.socketService.send(CustomChannelEvents.CreateCustomChannel, {
            channelName,
            username: this.username,
        });
    }

    deleteChannel(channelId: string): void {
        this.socketService.send(CustomChannelEvents.DeleteCustomChannel, {
            channelId,
            username: this.username,
        });
    }

    joinChannel(channelId: string): void {
        this.socketService.send(CustomChannelEvents.JoinCustomChannel, {
            channelId,
            username: this.username,
        });
    }

    leaveChannel(channelId: string): void {
        this.socketService.send(CustomChannelEvents.LeaveCustomChannel, {
            channelId,
            username: this.username,
        });
    }

    sendMessage(channelId: string, message: string): void {
        this.socketService.send(CustomChannelEvents.SendMessageToCustomChannel, {
            channelId,
            username: this.username,
            message,
        });
    }

    getMessages(channelId: string): ChannelMessage[] {
        return this.messagesByChannel[channelId] ?? [];
    }

    /** Retourne la liste des canaux rejoints avec leur nom d'affichage (pour le dropdown du chatbox). */
    getJoinedChannelInfos(): { id: string; name: string }[] {
        return [...this.joinedChannelIds].map((id) => ({
            id,
            name: this.joinedChannelNames.get(id) ?? id,
        }));
    }

    /** Demande au serveur l'historique de messages d'un canal. */
    fetchMessages(channelId: string): void {
        this.socketService.send(CustomChannelEvents.GetCustomChannelMessages, { channelId });
    }

    isJoined(channelId: string): boolean {
        return this.joinedChannelIds.has(channelId);
    }

    /** Retourne les IDs des canaux rejoints (snapshot synchrone). */
    getJoinedChannelIds(): string[] {
        return [...this.joinedChannelIds];
    }
}

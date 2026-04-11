import { Injectable } from '@angular/core';
import { AuthService } from '@app/services/communication/auth.service';
import { SocketService } from '@app/services/communication/socket-handlers/socket.service';
import { SocialService } from '@app/services/communication/social.service';
import { CustomChannelEvents } from '@common/socket.constants';
import { TranslateService } from '@ngx-translate/core';
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
    avatarId?: string | null;
    avatarUrl?: string | null;
}

@Injectable({
    providedIn: 'root',
})
export class CustomChannelService {
    channels: ChannelInfo[] = [];
    channelError: string | null = null;
    avatarId: string | null = null;
    avatarUrl: string | null = null;

    channelsUpdated$ = new Subject<ChannelInfo[]>();
    channelCreated$ = new Subject<{ channelId: string; channelName: string }>();
    channelDeleted$ = new Subject<{ channelId: string }>();
    channelError$ = new Subject<string>();
    joinedChannels$ = new Subject<string[]>();
    messagesUpdated$ = new Subject<{ channelId: string; messages: ChannelMessage[] }>();

    private joinedChannelIds = new Set<string>();
    private joinedChannelNames = new Map<string, string>(); // channelId → display name
    private gameChannelIds = new Set<string>(); // canaux éphémères de partie (exclus du dropdown)
    private messagesByChannel: Record<string, ChannelMessage[]> = {};

    constructor(
        private socketService: SocketService,
        private authService: AuthService,
        private socialService: SocialService,
        private translate: TranslateService,
    ) {}

    get username(): string {
        return this.authService.currentUser?.displayName as string;
    }

    setupListeners(): void {
        const socket = this.socketService.socket;
        if (!socket) return;

        // Vider les canaux de partie éphémères à chaque reconnexion (ils ne sont pas restaurés)
        for (const id of this.gameChannelIds) {
            this.joinedChannelIds.delete(id);
            this.joinedChannelNames.delete(id);
            delete this.messagesByChannel[id];
        }
        this.gameChannelIds.clear();
        this.joinedChannels$.next([...this.joinedChannelIds]);

        socket.on(CustomChannelEvents.CustomChannelsListResponse, (channels: ChannelInfo[]) => {
            const incomingIds = new Set(channels.map((c) => c.id));

            // Détecter les canaux custom (non-partie) qui n'existent plus sur le serveur
            // Les canaux de partie sont exclus de getAllChannels() — ne pas les supprimer ici
            const removedIds = [...this.joinedChannelIds].filter((id) => !incomingIds.has(id) && !this.gameChannelIds.has(id));
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
            this.gameChannelIds.delete(data.channelId);
            delete this.messagesByChannel[data.channelId];

            this.channelDeleted$.next(data);
            this.channelsUpdated$.next(this.channels);
            this.joinedChannels$.next([...this.joinedChannelIds]);
            this.messagesUpdated$.next({ channelId: data.channelId, messages: this.getMessages(data.channelId) });
        });

        socket.on(CustomChannelEvents.CustomChannelError, (data: { message: string }) => {
            const translatedMessage = this.translateChannelError(data.message);
            this.channelError = translatedMessage;
            this.channelError$.next(translatedMessage);
        });

        socket.on(CustomChannelEvents.CustomChannelJoined, (data: { channelId: string; channelName: string; isGameChannel?: boolean }) => {
            this.joinedChannelIds.add(data.channelId);
            const name = data.channelName ?? this.channels.find((c) => c.id === data.channelId)?.name ?? data.channelId;
            this.joinedChannelNames.set(data.channelId, name);
            if (data.isGameChannel) {
                this.gameChannelIds.add(data.channelId);
            }
            this.joinedChannels$.next([...this.joinedChannelIds]);
        });

        socket.on(CustomChannelEvents.CustomChannelLeft, (data: { channelId: string }) => {
            this.joinedChannelIds.delete(data.channelId);
            this.joinedChannelNames.delete(data.channelId);
            this.gameChannelIds.delete(data.channelId);
            this.joinedChannels$.next([...this.joinedChannelIds]);
        });

        socket.on(CustomChannelEvents.CustomChannelMessagesResponse, (payload: { channelId: string; messages: ChannelMessage[] }) => {
            const filtered = payload.messages.filter((m) => !m.name || !this.socialService.isInBlockRelationship(m.name));
            this.messagesByChannel[payload.channelId] = filtered;
            this.messagesUpdated$.next({ channelId: payload.channelId, messages: filtered });
        });

        socket.on(CustomChannelEvents.CustomChannelMessage, (payload: { channelId: string; message: ChannelMessage }) => {
            if (payload.message.name && this.socialService.isInBlockRelationship(payload.message.name)) return;
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
            avatarId: this.avatarId,
            avatarUrl: this.avatarUrl,
        });
    }

    getMessages(channelId: string): ChannelMessage[] {
        return this.messagesByChannel[channelId] ?? [];
    }

    /** Retourne tous les canaux rejoints (custom + partie) pour le dropdown du chatbox. */
    getJoinedChannelInfos(): { id: string; name: string; isGameChannel: boolean }[] {
        return [...this.joinedChannelIds].map((id) => ({
            id,
            name: this.joinedChannelNames.get(id) ?? id,
            isGameChannel: this.gameChannelIds.has(id),
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

    private translateChannelError(serverMessage: string): string {
        const key = this.mapChannelErrorKey(serverMessage);
        return this.translate.instant(key ?? 'channels.errors.generic');
    }

    private mapChannelErrorKey(serverMessage: string): string | null {
        const normalized = serverMessage
            .toLowerCase()
            .normalize('NFD')
            .replace(/[\u0300-\u036f]/g, '')
            .replace(/['\u2019]/g, ' ')
            .replace(/[^a-z0-9\s]/g, ' ')
            .replace(/\s+/g, ' ')
            .trim();

        if (normalized.includes('ne peut pas etre vide')) return 'channels.errors.empty_name';
        if (normalized.includes('depasser 50 caracteres')) return 'channels.errors.name_too_long';
        if (normalized.includes('reserve pour le chat general')) return 'channels.errors.reserved_general';
        if (normalized.includes('reserve pour les canaux de partie')) return 'channels.errors.reserved_game';
        if (normalized.includes('deja pris') || normalized.includes('existe deja')) return 'channels.errors.name_taken';
        if (normalized.includes('n existe plus') || normalized.includes('introuvable') || normalized.includes('a ete supprime'))
            return 'channels.errors.not_found';
        if (normalized.includes('seul le createur')) return 'channels.errors.only_creator_delete';
        if (normalized.includes('etre membre')) return 'channels.errors.must_be_member_to_send';
        if (normalized.includes('une erreur est survenue')) return 'channels.errors.generic';

        return null;
    }
}

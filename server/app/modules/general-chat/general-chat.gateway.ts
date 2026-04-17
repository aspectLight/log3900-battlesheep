import { AuthService } from '@app/modules/auth/services/auth.service';
import { GENERAL_CHAT_ROOM } from '@app/modules/general-chat/constants/general-chat.constants';
import { ChatMessage } from '@app/modules/general-chat/interfaces/chat';
import { ChatModerationService } from '@app/modules/general-chat/services/chat-moderation.service';
import { CustomChannelService } from '@app/modules/general-chat/services/custom-channel.service';
import { GeneralChatService } from '@app/modules/general-chat/services/general-chat.service';
import { BlockService } from '@app/modules/social/services/block.service';
import { CustomChannelEvents, GeneralChatEvents } from '@common/socket.constants';
import { ConflictException, Injectable, Logger, NotFoundException } from '@nestjs/common';
import {
    ConnectedSocket,
    MessageBody,
    OnGatewayConnection,
    OnGatewayDisconnect,
    SubscribeMessage,
    WebSocketGateway,
    WebSocketServer,
} from '@nestjs/websockets';
import { MongoServerError } from 'mongodb';
import { Server, Socket } from 'socket.io';

@WebSocketGateway({ cors: { origin: '*' } })
@Injectable()
export class GeneralChatGateway implements OnGatewayConnection, OnGatewayDisconnect {
    @WebSocketServer() private server: Server;
    private readonly logger = new Logger(GeneralChatGateway.name);
    private socketIdToUsername = new Map<string, string>();
    private disconnectionTimeouts = new Map<string, NodeJS.Timeout>();

    constructor(
        private readonly generalChatService: GeneralChatService,
        private readonly customChannelService: CustomChannelService,
        private readonly authService: AuthService,
        private readonly chatModerationService: ChatModerationService,
        private readonly blockService: BlockService,
    ) {}

    // ===== General Chat Events =====

    @SubscribeMessage(GeneralChatEvents.JoinGeneralChat)
    async handleJoinGeneralChat(socket: Socket): Promise<void> {
        socket.join(GENERAL_CHAT_ROOM);
        const username = this.socketIdToUsername.get(socket.id);
        const messages = await this.generalChatService.getMessages();
        const filtered = username ? await this.filterBlockedMessages(messages, username) : messages;
        socket.emit(GeneralChatEvents.GetGeneralChatMessagesResponse, filtered);
    }

    @SubscribeMessage(GeneralChatEvents.SendMessageToGeneralChat)
    async handleSendMessage(
        @ConnectedSocket() socket: Socket,
        @MessageBody() data: { username: string; message: string; avatarId?: string; avatarUrl?: string },
    ): Promise<void> {
        // Censurer le message avant de le diffuser
        const censoredMessage = this.chatModerationService.censor(data.message);

        const chatMessage: ChatMessage = {
            type: 'received',
            name: data.username,
            content: censoredMessage,
            time: new Date().toLocaleTimeString('en-GB', {
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit',
                hour12: false,
            }),
            avatarId: data.avatarId,
            avatarUrl: data.avatarUrl,
        };
        await this.generalChatService.addMessage(chatMessage);

        const blockedSocketIds = await this.getBlockedSocketIds(data.username);
        this.server
            .except([socket.id, ...blockedSocketIds])
            .to(GENERAL_CHAT_ROOM)
            .emit(GeneralChatEvents.GeneralChatMessage, chatMessage);
        socket.emit(GeneralChatEvents.GeneralChatMessage, chatMessage);
        this.logger.log(`Message de ${data.username}: ${censoredMessage}`);
    }

    @SubscribeMessage(GeneralChatEvents.SendEmojiToGeneralChat)
    async handleSendEmoji(@ConnectedSocket() socket: Socket, @MessageBody() data: { username: string; emoji: string }): Promise<void> {
        const chatEmoji: ChatMessage = {
            type: 'emoji-received',
            name: data.username,
            content: data.emoji,
            time: new Date().toLocaleTimeString('en-GB', {
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit',
                hour12: false,
            }),
        };
        await this.generalChatService.addMessage(chatEmoji);

        const blockedSocketIds = await this.getBlockedSocketIds(data.username);
        this.server
            .except([socket.id, ...blockedSocketIds])
            .to(GENERAL_CHAT_ROOM)
            .emit(GeneralChatEvents.GeneralChatEmoji, chatEmoji);
        socket.emit(GeneralChatEvents.GeneralChatEmoji, chatEmoji);
    }

    @SubscribeMessage(GeneralChatEvents.GetGeneralChatMessages)
    async handleGetMessages(socket: Socket): Promise<void> {
        const username = this.socketIdToUsername.get(socket.id);
        const messages = await this.generalChatService.getMessages();
        const filtered = username ? await this.filterBlockedMessages(messages, username) : messages;
        socket.emit(GeneralChatEvents.GetGeneralChatMessagesResponse, filtered);
    }

    // ===== Custom Channel Events =====

    @SubscribeMessage(CustomChannelEvents.CreateCustomChannel)
    async handleCreateCustomChannel(
        @ConnectedSocket() socket: Socket,
        @MessageBody() data: { channelName: string; username: string },
    ): Promise<void> {
        try {
            const username = this.socketIdToUsername.get(socket.id) ?? data.username;
            const channel = await this.customChannelService.createChannel(data.channelName, username);

            // Le créateur rejoint automatiquement la room socket de son canal
            socket.join(`custom-channel-${channel.channelId}`);

            socket.emit(CustomChannelEvents.CustomChannelCreated, {
                channelId: channel.channelId,
                channelName: channel.name,
            });

            // Notifier le créateur qu'il est membre (même comportement qu'un join normal)
            socket.emit(CustomChannelEvents.CustomChannelJoined, {
                channelId: channel.channelId,
                channelName: channel.name,
            });

            // Envoyer l'historique vide au créateur
            socket.emit(CustomChannelEvents.CustomChannelMessagesResponse, {
                channelId: channel.channelId,
                messages: [],
            });

            const channels = await this.customChannelService.getAllChannels();
            this.server.emit(
                CustomChannelEvents.CustomChannelsListResponse,
                channels.map((c) => ({ id: c.channelId, name: c.name, creator: c.creator, memberCount: c.members.length })),
            );
        } catch (error) {
            socket.emit(CustomChannelEvents.CustomChannelError, { message: this.getFriendlyError(error) });
        }
    }

    @SubscribeMessage(CustomChannelEvents.JoinCustomChannel)
    async handleJoinCustomChannel(@ConnectedSocket() socket: Socket, @MessageBody() data: { channelId: string; username: string }): Promise<void> {
        try {
            const username = this.socketIdToUsername.get(socket.id) ?? data.username;
            await this.customChannelService.joinChannel(data.channelId, username);
            socket.join(`custom-channel-${data.channelId}`);

            const channel = await this.customChannelService.getChannel(data.channelId);
            const messages = await this.customChannelService.getMessages(data.channelId);
            const filtered = await this.filterBlockedMessages(messages, username);
            socket.emit(CustomChannelEvents.CustomChannelJoined, { channelId: data.channelId, channelName: channel?.name ?? data.channelId });
            socket.emit(CustomChannelEvents.CustomChannelMessagesResponse, { channelId: data.channelId, messages: filtered });

            // Notifier tous les clients du nouveau memberCount
            const channels = await this.customChannelService.getAllChannels();
            this.server.emit(
                CustomChannelEvents.CustomChannelsListResponse,
                channels.map((c) => ({ id: c.channelId, name: c.name, creator: c.creator, memberCount: c.members.length })),
            );
        } catch (error) {
            socket.emit(CustomChannelEvents.CustomChannelError, { message: this.getFriendlyError(error) });
        }
    }

    @SubscribeMessage(CustomChannelEvents.LeaveCustomChannel)
    async handleLeaveCustomChannel(@ConnectedSocket() socket: Socket, @MessageBody() data: { channelId: string; username: string }): Promise<void> {
        try {
            const username = this.socketIdToUsername.get(socket.id) ?? data.username;
            await this.customChannelService.leaveChannel(data.channelId, username);
            socket.leave(`custom-channel-${data.channelId}`);
            socket.emit(CustomChannelEvents.CustomChannelLeft, { channelId: data.channelId });

            // Notifier tous les clients du nouveau memberCount (le canal peut aussi avoir été supprimé si 0 membres)
            const channels = await this.customChannelService.getAllChannels();
            this.server.emit(
                CustomChannelEvents.CustomChannelsListResponse,
                channels.map((c) => ({ id: c.channelId, name: c.name, creator: c.creator, memberCount: c.members.length })),
            );
        } catch (error) {
            socket.emit(CustomChannelEvents.CustomChannelError, { message: this.getFriendlyError(error) });
        }
    }

    @SubscribeMessage(CustomChannelEvents.DeleteCustomChannel)
    async handleDeleteCustomChannel(@ConnectedSocket() socket: Socket, @MessageBody() data: { channelId: string; username: string }): Promise<void> {
        try {
            const username = this.socketIdToUsername.get(socket.id) ?? data.username;
            await this.customChannelService.deleteChannel(data.channelId, username);

            socket.emit(CustomChannelEvents.CustomChannelDeleted, {
                channelId: data.channelId,
            });

            const channels = await this.customChannelService.getAllChannels();
            this.server.emit(
                CustomChannelEvents.CustomChannelsListResponse,
                channels.map((c) => ({ id: c.channelId, name: c.name, creator: c.creator, memberCount: c.members.length })),
            );
        } catch (error) {
            socket.emit(CustomChannelEvents.CustomChannelError, { message: this.getFriendlyError(error) });
        }
    }

    @SubscribeMessage(CustomChannelEvents.SendMessageToCustomChannel)
    async handleSendMessageToCustomChannel(
        @ConnectedSocket() socket: Socket,
        @MessageBody() data: { channelId: string; username: string; message: string; avatarId?: string; avatarUrl?: string },
    ): Promise<void> {
        try {
            // Les canaux de partie n'ont pas de membres en BD — on skippe la vérification
            const isGame = await this.customChannelService.checkIsGameChannel(data.channelId);
            if (!isGame) {
                const isMember = await this.customChannelService.isMember(data.channelId, data.username);
                if (!isMember) {
                    socket.emit(CustomChannelEvents.CustomChannelError, {
                        message: 'Vous devez être membre du canal pour envoyer des messages',
                    });
                    return;
                }
            }

            // Censurer le message avant de le diffuser
            const censoredMessage = this.chatModerationService.censor(data.message);

            const chatMessage: ChatMessage = {
                type: 'received',
                name: data.username,
                content: censoredMessage,
                time: new Date().toLocaleTimeString('en-GB', {
                    hour: '2-digit',
                    minute: '2-digit',
                    second: '2-digit',
                    hour12: false,
                }),
                avatarId: data.avatarId,
                avatarUrl: data.avatarUrl,
            };

            await this.customChannelService.addMessage(data.channelId, chatMessage);

            const blockedSocketIds = await this.getBlockedSocketIds(data.username);
            this.server.except(blockedSocketIds).to(`custom-channel-${data.channelId}`).emit(CustomChannelEvents.CustomChannelMessage, {
                channelId: data.channelId,
                message: chatMessage,
            });
        } catch (error) {
            socket.emit(CustomChannelEvents.CustomChannelError, { message: this.getFriendlyError(error) });
        }
    }

    @SubscribeMessage(CustomChannelEvents.SendEmojiToCustomChannel)
    async handleSendEmojiToCustomChannel(
        @ConnectedSocket() socket: Socket,
        @MessageBody() data: { channelId: string; username: string; emoji: string },
    ): Promise<void> {
        try {
            // Les canaux de partie n'ont pas de membres en BD — on skippe la vérification
            const isGame = await this.customChannelService.checkIsGameChannel(data.channelId);
            if (!isGame) {
                const isMember = await this.customChannelService.isMember(data.channelId, data.username);
                if (!isMember) {
                    socket.emit(CustomChannelEvents.CustomChannelError, {
                        message: 'Vous devez être membre du canal pour envoyer des messages',
                    });
                    return;
                }
            }

            const chatEmoji: ChatMessage = {
                type: 'emoji-received',
                name: data.username,
                content: data.emoji,
                time: new Date().toLocaleTimeString('en-GB', {
                    hour: '2-digit',
                    minute: '2-digit',
                    second: '2-digit',
                    hour12: false,
                }),
            };

            await this.customChannelService.addMessage(data.channelId, chatEmoji);

            const blockedSocketIds = await this.getBlockedSocketIds(data.username);
            this.server.except(blockedSocketIds).to(`custom-channel-${data.channelId}`).emit(CustomChannelEvents.CustomChannelEmoji, {
                channelId: data.channelId,
                emoji: chatEmoji,
            });
        } catch (error) {
            socket.emit(CustomChannelEvents.CustomChannelError, { message: this.getFriendlyError(error) });
        }
    }

    @SubscribeMessage(CustomChannelEvents.GetCustomChannelMessages)
    async handleGetCustomChannelMessages(@ConnectedSocket() socket: Socket, @MessageBody() data: { channelId: string }): Promise<void> {
        try {
            const username = this.socketIdToUsername.get(socket.id);
            const messages = await this.customChannelService.getMessages(data.channelId);
            const filtered = username ? await this.filterBlockedMessages(messages, username) : messages;
            socket.emit(CustomChannelEvents.CustomChannelMessagesResponse, { channelId: data.channelId, messages: filtered });
        } catch (error) {
            socket.emit(CustomChannelEvents.CustomChannelError, { message: this.getFriendlyError(error) });
        }
    }

    @SubscribeMessage(CustomChannelEvents.ListCustomChannels)
    async handleListCustomChannels(socket: Socket): Promise<void> {
        const channels = await this.customChannelService.getAllChannels();
        socket.emit(
            CustomChannelEvents.CustomChannelsListResponse,
            channels.map((c) => ({ id: c.channelId, name: c.name, creator: c.creator, memberCount: c.members.length })),
        );
    }

    // ===== WebSocket Lifecycle Events =====

    async handleConnection(socket: Socket): Promise<void> {
        const { token } = socket.handshake.auth as { token?: string };
        if (token) {
            try {
                const decodedToken = await this.authService.verifyToken(token);
                const user = await this.authService.getUserByUid(decodedToken.uid);
                if (user?.username) {
                    this.socketIdToUsername.set(socket.id, user.username);
                    this.logger.log(`Utilisateur ${user.username} authentifié sur socket ${socket.id}`);

                    const existingTimeout = this.disconnectionTimeouts.get(user.username);
                    if (existingTimeout) {
                        clearTimeout(existingTimeout);
                        this.disconnectionTimeouts.delete(user.username);
                        this.logger.log(`Déconnexion annulée pour ${user.username} (reconnexion rapide)`);
                    }

                    // Restaurer les canaux custom dont l'utilisateur est membre
                    const userChannels = await this.customChannelService.getChannelsForUser(user.username);
                    if (userChannels.length > 0) {
                        for (const ch of userChannels) {
                            socket.join(`custom-channel-${ch.channelId}`);
                        }
                        socket.emit(CustomChannelEvents.UserChannelsRestored, userChannels);
                        this.logger.log(`Canaux restaurés pour ${user.username}: ${userChannels.map((c) => c.name).join(', ')}`);
                    }
                }
            } catch (error) {
                this.logger.warn(`Échec de l'authentification pour socket ${socket.id}: ${error.message}`);
            }
        }
    }

    broadcastAvatarUpdate(payload: { username: string; avatarId: string | null; avatarUrl: string | null }): void {
        this.server.emit(GeneralChatEvents.AvatarUpdated, payload);
    }

    async handleUsernameUpdate(oldUsername: string, newUsername: string): Promise<void> {
        await this.generalChatService.replaceUsername(oldUsername, newUsername);
        await this.customChannelService.renameUser(oldUsername, newUsername);

        for (const [socketId, username] of this.socketIdToUsername.entries()) {
            if (username === oldUsername) {
                this.socketIdToUsername.set(socketId, newUsername);
            }
        }

        const pendingTimeout = this.disconnectionTimeouts.get(oldUsername);
        if (pendingTimeout) {
            this.disconnectionTimeouts.delete(oldUsername);
            this.disconnectionTimeouts.set(newUsername, pendingTimeout);
        }

        this.server.emit(GeneralChatEvents.UsernameUpdated, { oldUsername, newUsername });
        this.logger.log(`Utilisateur renommé: ${oldUsername} → ${newUsername}`);
    }

    async forceDisconnectUser(username: string): Promise<void> {
        // Cancel any pending disconnection timeout
        const existingTimeout = this.disconnectionTimeouts.get(username);
        if (existingTimeout) {
            clearTimeout(existingTimeout);
            this.disconnectionTimeouts.delete(username);
        }

        // Find all sockets for this user and remove them from the map before disconnecting,
        // so that handleDisconnect won't create new timeouts for the deleted user
        const socketsToDisconnect: Socket[] = [];
        for (const [socketId, socketUsername] of this.socketIdToUsername.entries()) {
            if (socketUsername === username) {
                const socket = this.server.sockets.sockets.get(socketId);
                if (socket) {
                    socketsToDisconnect.push(socket);
                }
                this.socketIdToUsername.delete(socketId);
            }
        }

        for (const socket of socketsToDisconnect) {
            socket.disconnect(true);
        }

        this.logger.log(`Déconnexion forcée effectuée pour ${username}`);
    }

    async handleDisconnect(socket: Socket): Promise<void> {
        const username = this.socketIdToUsername.get(socket.id);

        if (username) {
            const timeout = setTimeout(async () => {
                // Skip if the timeout was cancelled
                if (!this.disconnectionTimeouts.has(username)) {
                    return;
                }

                try {
                    const user = await this.authService.getUserByUsername(username);
                    if (!user.isOnline) {
                        // The user already went through the explicit HTTP logout (isOnline=false),
                        // so a logout history entry was already recorded. Skip to avoid a duplicate.
                        this.disconnectionTimeouts.delete(username);
                        this.logger.log(`Déconnexion automatique annulée pour ${username} (déjà déconnecté explicitement).`);
                        return;
                    }
                    await this.authService.logout(user.firebaseUid);
                    this.socketIdToUsername.delete(socket.id);
                    this.disconnectionTimeouts.delete(username);
                    this.logger.log(`Déconnexion automatique effectuée pour ${username} suite à la fermeture du client.`);
                } catch (error) {
                    this.logger.error(`Erreur lors de la déconnexion automatique de ${username}: ${error.message}`);
                }
            }, 10000);

            this.disconnectionTimeouts.set(username, timeout);
        }
    }

    // ===== Helpers =====

    /**
     * Returns all socket IDs connected to this gateway that belong to users
     * in a bidirectional block relationship with senderUsername.
     */
    private async getBlockedSocketIds(senderUsername: string): Promise<string[]> {
        const [blockedByMe, whoBlockedMe] = await Promise.all([
            this.blockService.getBlockedUsers(senderUsername),
            this.blockService.getUsersWhoBlocked(senderUsername),
        ]);
        const blocked = new Set([...blockedByMe, ...whoBlockedMe]);
        const socketIds: string[] = [];
        for (const [socketId, username] of this.socketIdToUsername.entries()) {
            if (blocked.has(username)) {
                socketIds.push(socketId);
            }
        }
        return socketIds;
    }

    /**
     * Filters out messages authored by users who are in a block relationship
     * with the requesting user.
     */
    private async filterBlockedMessages(messages: ChatMessage[], username: string): Promise<ChatMessage[]> {
        const [blockedByMe, whoBlockedMe] = await Promise.all([
            this.blockService.getBlockedUsers(username),
            this.blockService.getUsersWhoBlocked(username),
        ]);
        const blocked = new Set([...blockedByMe, ...whoBlockedMe]);
        return messages.filter((m) => !m.name || !blocked.has(m.name));
    }

    /**
     * Convertit n'importe quelle erreur en message lisible en français.
     * Empêche d'exposer des erreurs brutes MongoDB ou NestJS au client.
     */
    private getFriendlyError(error: unknown): string {
        // Erreur d'index unique MongoDB (E11000) — nom de canal déjà pris
        if (error instanceof MongoServerError && error.code === 11000) {
            return 'Le nom du canal est déjà pris, veuillez en choisir un autre';
        }

        if (error instanceof ConflictException) {
            return 'Le nom du canal est déjà pris, veuillez en choisir un autre';
        }

        if (error instanceof NotFoundException) {
            return "Ce canal n'existe plus ou a été supprimé";
        }

        if (error instanceof Error) {
            if (error.message.includes('ne peut pas être vide')) {
                return 'Le nom du canal ne peut pas être vide';
            }
            if (error.message.includes('dépasser 50 caractères') || error.message.includes('depasser 50 caracteres')) {
                return 'Le nom du canal ne peut pas dépasser 50 caractères';
            }
            if (error.message.includes('réservé pour le chat général') || error.message.includes('reserve pour le chat general')) {
                return 'Le nom du canal est réservé pour le chat général';
            }
            if (error.message.includes('réservé pour les canaux de partie') || error.message.includes('reserve pour les canaux de partie')) {
                return 'Le nom du canal est réservé pour les canaux de partie';
            }
            if (error.message.includes('mots interdits')) {
                return 'Le nom du canal contient des mots interdits';
            }
            if (error.message.includes('Seul le créateur')) {
                return 'Seul le créateur du canal peut le supprimer';
            }
            if (error.message.includes('être membre')) {
                return 'Vous devez être membre du canal pour envoyer des messages';
            }
            // Message déjà en français provenant du service
            return error.message;
        }

        return 'Une erreur est survenue. Veuillez réessayer.';
    }
}

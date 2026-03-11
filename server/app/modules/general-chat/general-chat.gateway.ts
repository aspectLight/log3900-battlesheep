import { AuthService } from '@app/modules/auth/services/auth.service';
import { GENERAL_CHAT_ROOM } from '@app/modules/general-chat/constants/general-chat.constants';
import { ChatMessage } from '@app/modules/general-chat/interfaces/chat';
import { ChatModerationService } from '@app/modules/general-chat/services/chat-moderation.service';
import { CustomChannelService } from '@app/modules/general-chat/services/custom-channel.service';
import { GeneralChatService } from '@app/modules/general-chat/services/general-chat.service';
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
    ) {}

    // ===== General Chat Events =====

    @SubscribeMessage(GeneralChatEvents.JoinGeneralChat)
    async handleJoinGeneralChat(socket: Socket): Promise<void> {
        socket.join(GENERAL_CHAT_ROOM);
        const messages = await this.generalChatService.getMessages();
        socket.emit(GeneralChatEvents.GetGeneralChatMessagesResponse, messages);
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

        socket.to(GENERAL_CHAT_ROOM).emit(GeneralChatEvents.GeneralChatMessage, chatMessage);
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

        socket.to(GENERAL_CHAT_ROOM).emit(GeneralChatEvents.GeneralChatEmoji, chatEmoji);
    }

    @SubscribeMessage(GeneralChatEvents.GetGeneralChatMessages)
    async handleGetMessages(socket: Socket): Promise<void> {
        const messages = await this.generalChatService.getMessages();
        socket.emit(GeneralChatEvents.GetGeneralChatMessagesResponse, messages);
    }

    // ===== Custom Channel Events =====

    @SubscribeMessage(CustomChannelEvents.CreateCustomChannel)
    async handleCreateCustomChannel(
        @ConnectedSocket() socket: Socket,
        @MessageBody() data: { channelName: string; username: string },
    ): Promise<void> {
        try {
            const channel = await this.customChannelService.createChannel(data.channelName, data.username);

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
            await this.customChannelService.joinChannel(data.channelId, data.username);
            socket.join(`custom-channel-${data.channelId}`);

            const channel = await this.customChannelService.getChannel(data.channelId);
            const messages = await this.customChannelService.getMessages(data.channelId);
            socket.emit(CustomChannelEvents.CustomChannelJoined, { channelId: data.channelId, channelName: channel?.name ?? data.channelId });
            socket.emit(CustomChannelEvents.CustomChannelMessagesResponse, { channelId: data.channelId, messages });

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
            await this.customChannelService.leaveChannel(data.channelId, data.username);
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
            await this.customChannelService.deleteChannel(data.channelId, data.username);

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

            this.server.to(`custom-channel-${data.channelId}`).emit(CustomChannelEvents.CustomChannelMessage, {
                channelId: data.channelId,
                message: chatMessage,
            });
        } catch (error) {
            socket.emit(CustomChannelEvents.CustomChannelError, { message: this.getFriendlyError(error) });
        }
    }

    @SubscribeMessage(CustomChannelEvents.GetCustomChannelMessages)
    async handleGetCustomChannelMessages(@ConnectedSocket() socket: Socket, @MessageBody() data: { channelId: string }): Promise<void> {
        try {
            const messages = await this.customChannelService.getMessages(data.channelId);
            socket.emit(CustomChannelEvents.CustomChannelMessagesResponse, { channelId: data.channelId, messages });
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
            if (error.message.includes('dépasser 50 caractères')) {
                return 'Le nom du canal ne peut pas dépasser 50 caractères';
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

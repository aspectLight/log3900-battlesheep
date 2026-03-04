import { AuthService } from '@app/modules/auth/services/auth.service';
import { GENERAL_CHAT_ROOM } from '@app/modules/general-chat/constants/general-chat.constants';
import { ChatMessage } from '@app/modules/general-chat/interfaces/chat';
import { GeneralChatService } from '@app/modules/general-chat/services/general-chat.service';
import { GeneralChatEvents } from '@common/socket.constants';
import { Injectable, Logger } from '@nestjs/common';
import { OnGatewayConnection, OnGatewayDisconnect, SubscribeMessage, WebSocketGateway } from '@nestjs/websockets';
import { Socket } from 'socket.io';

@WebSocketGateway({ cors: { origin: '*' } })
@Injectable()
export class GeneralChatGateway implements OnGatewayConnection, OnGatewayDisconnect {
    private readonly logger = new Logger(GeneralChatGateway.name);
    private socketIdToUser = new Map<string, { username: string; avatarId: string }>();
    private disconnectionTimeouts = new Map<string, NodeJS.Timeout>();

    constructor(
        private readonly generalChatService: GeneralChatService,
        private readonly authService: AuthService,
    ) {}

    @SubscribeMessage(GeneralChatEvents.JoinGeneralChat)
    handleJoinGeneralChat(socket: Socket): void {
        socket.join(GENERAL_CHAT_ROOM);
        const messages = this.generalChatService.getMessages();
        socket.emit(GeneralChatEvents.GetGeneralChatMessagesResponse, messages);
    }

    @SubscribeMessage(GeneralChatEvents.SendMessageToGeneralChat)
    handleSendMessage(socket: Socket, data: { username: string; message: string }): void {
        const chatMessage: ChatMessage = {
            type: 'received',
            name: data.username,
            content: data.message,
            time: new Date().toLocaleTimeString('en-GB', {
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit',
                hour12: false,
            }),
        };
        this.generalChatService.addMessage(chatMessage);

        socket.to(GENERAL_CHAT_ROOM).emit(GeneralChatEvents.GeneralChatMessage, chatMessage);
        socket.emit(GeneralChatEvents.GeneralChatMessage, chatMessage);
        this.logger.log(`Message de ${data.username}: ${data.message}`);
    }

    @SubscribeMessage(GeneralChatEvents.SendEmojiToGeneralChat)
    handleSendEmoji(socket: Socket, data: { username: string; emoji: string }): void {
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
        this.generalChatService.addMessage(chatEmoji);

        socket.to(GENERAL_CHAT_ROOM).emit(GeneralChatEvents.GeneralChatEmoji, chatEmoji);
    }

    @SubscribeMessage(GeneralChatEvents.GetGeneralChatMessages)
    handleGetMessages(socket: Socket): void {
        const messages = this.generalChatService.getMessages();
        socket.emit(GeneralChatEvents.GetGeneralChatMessagesResponse, messages);
    }

    async handleConnection(socket: Socket): Promise<void> {
        // Identify user with token
        const { token } = socket.handshake.auth as { token?: string };
        if (token) {
            try {
                const decodedToken = await this.authService.verifyToken(token);
                const user = await this.authService.getUserByUid(decodedToken.uid);
                if (user?.username) {
                    this.socketIdToUsername.set(socket.id, user.username);
                    this.logger.log(`Utilisateur ${user.username} authentifié sur socket ${socket.id}`);

                    // Cancel disconnection timeout if user reconnects (moving through pages)
                    const existingTimeout = this.disconnectionTimeouts.get(user.username);
                    if (existingTimeout) {
                        clearTimeout(existingTimeout);
                        this.disconnectionTimeouts.delete(user.username);
                        this.logger.log(`Déconnexion annulée pour ${user.username} (reconnexion rapide)`);
                    }
                }
            } catch (error) {
                this.logger.warn(`Échec de l'authentification pour socket ${socket.id}: ${error.message}`);
            }
        }
    }

    async handleDisconnect(socket: Socket): Promise<void> {
        const username = this.socketIdToUsername.get(socket.id);

        if (username) {
            // 15 seconds delay before logging out
            const timeout = setTimeout(async () => {
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
}

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
    private socketIdToUsername = new Map<string, string>();

    private disconnectionTimeouts = new Map<string, NodeJS.Timeout>();

    constructor(
        private readonly generalChatService: GeneralChatService,
        private readonly authService: AuthService,
    ) {}

    @SubscribeMessage(GeneralChatEvents.JoinGeneralChat)
    handleJoinGeneralChat(socket: Socket, username: string): void {
        const existingTimeout = this.disconnectionTimeouts.get(username);
        if (existingTimeout) {
            clearTimeout(existingTimeout);
            this.disconnectionTimeouts.delete(username);
            this.logger.log(`Déconnexion annulée pour ${username} (reconnexion rapide)`);
        }

        socket.join(GENERAL_CHAT_ROOM);
        this.socketIdToUsername.set(socket.id, username);
        this.logger.log(`${username} (${socket.id}) a rejoint le chat général`);

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

        // Send message to all except sender
        socket.to(GENERAL_CHAT_ROOM).emit(GeneralChatEvents.GeneralChatMessage, chatMessage);
        this.logger.log(`Message de ${data.username}: ${data.message}`);
    }

    @SubscribeMessage(GeneralChatEvents.GetGeneralChatMessages)
    handleGetMessages(socket: Socket): void {
        const messages = this.generalChatService.getMessages();
        socket.emit(GeneralChatEvents.GetGeneralChatMessagesResponse, messages);
    }

    handleConnection(socket: Socket) {
        this.logger.log(`Client connecté: ${socket.id}`);
    }

    async handleDisconnect(socket: Socket): Promise<void> {
        this.logger.log(`Client déconnecté: ${socket.id}`);
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
            }, 15000);

            this.disconnectionTimeouts.set(username, timeout);
        }
    }
}

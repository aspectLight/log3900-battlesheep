import { GENERAL_CHAT_ROOM } from '@app/modules/general-chat/constants/general-chat.constants';
import { ChatMessage } from '@app/modules/general-chat/interfaces/chat';
import { GeneralChatService } from '@app/modules/general-chat/services/general-chat.service';
import { GeneralChatEvents } from '@common/socket.constants';
import { Injectable, Logger } from '@nestjs/common';
import { OnGatewayConnection, OnGatewayDisconnect, SubscribeMessage, WebSocketGateway, WebSocketServer } from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';

@WebSocketGateway({ cors: { origin: '*' } })
@Injectable()
export class GeneralChatGateway implements OnGatewayConnection, OnGatewayDisconnect {
    @WebSocketServer()
    private server: Server;
    private readonly logger = new Logger(GeneralChatGateway.name);

    constructor(private readonly generalChatService: GeneralChatService) {}

    @SubscribeMessage(GeneralChatEvents.JoinGeneralChat)
    handleJoinGeneralChat(socket: Socket, username: string): void {
        socket.join(GENERAL_CHAT_ROOM);
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

    handleDisconnect(socket: Socket): void {
        this.logger.log(`Client déconnecté: ${socket.id}`);
    }
}

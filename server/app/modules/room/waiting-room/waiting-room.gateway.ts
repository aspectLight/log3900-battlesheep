import { Player } from '@app/shared/interfaces/player';
import { WaitingRoomEvents } from '@common/socket.constants';
import { Injectable, Logger } from '@nestjs/common';
import {
    ConnectedSocket,
    MessageBody,
    OnGatewayConnection,
    OnGatewayDisconnect,
    SubscribeMessage,
    WebSocketGateway,
    WebSocketServer,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { WaitingRoomChatHandler } from './handlers/waiting-room-chat.handler';
import { WaitingRoomGameHandler } from './handlers/waiting-room-game.handler';
import { WaitingRoomManagementHandler } from './handlers/waiting-room-management.handler';
import { WaitingRoomPlayerHandler } from './handlers/waiting-room-player.handler';

/**
 * Gateway for waiting room WebSocket events
 * Acts as a pure event router - all business logic delegated to handlers
 */
@WebSocketGateway({ cors: { origin: '*' } })
@Injectable()
export class WaitingRoomGateway implements OnGatewayConnection, OnGatewayDisconnect {
    @WebSocketServer() private server: Server;
    private readonly logger = new Logger(WaitingRoomGateway.name);

    constructor(
        private readonly managementHandler: WaitingRoomManagementHandler,
        private readonly playerHandler: WaitingRoomPlayerHandler,
        private readonly gameHandler: WaitingRoomGameHandler,
        private readonly chatHandler: WaitingRoomChatHandler,
    ) {}

    // ===== Room Management Events =====

    @SubscribeMessage(WaitingRoomEvents.CreateWaitingRoom)
    handleCreateRoom(
        @MessageBody() data: { roomId: string; gameId: string; host: Player },
        @ConnectedSocket() socket: Socket,
    ): { success: boolean; error?: string } {
        return this.managementHandler.handleCreateRoom(data, socket, this.server);
    }

    @SubscribeMessage(WaitingRoomEvents.JoinWaitingRoom)
    handleJoinRoom(@MessageBody() roomId: string, @ConnectedSocket() socket: Socket) {
        return this.managementHandler.handleJoinRoom(roomId, socket);
    }

    @SubscribeMessage(WaitingRoomEvents.LeaveWaitingRoom)
    handleLeaveRoom(@MessageBody() roomId: string, @ConnectedSocket() socket: Socket) {
        return this.managementHandler.handleLeaveRoom(roomId, socket, this.server);
    }

    @SubscribeMessage(WaitingRoomEvents.ToggleLockWaitingRoom)
    handleLockRoom(@MessageBody() roomId: string, @ConnectedSocket() socket: Socket) {
        return this.managementHandler.handleLockRoom(roomId, socket, this.server);
    }

    // ===== Player Management Events =====

    @SubscribeMessage(WaitingRoomEvents.CreatePlayer)
    handleCreatePlayer(@MessageBody() data: { roomId: string; player: Player }, @ConnectedSocket() socket: Socket) {
        return this.playerHandler.handleCreatePlayer(data, socket, this.server);
    }

    @SubscribeMessage(WaitingRoomEvents.ReserveAvatar)
    handleReserveAvatar(
        @MessageBody() data: { roomId: string; chosenAvatar: string; playerId: string },
        @ConnectedSocket() socket: Socket,
    ): { success: boolean; error?: string } {
        return this.playerHandler.handleReserveAvatar(data, socket, this.server);
    }

    @SubscribeMessage(WaitingRoomEvents.GetReservedAvatars)
    handleGetReservedAvatars(@MessageBody() data: { roomId: string }, @ConnectedSocket() socket: Socket) {
        return this.playerHandler.handleGetReservedAvatars(data, socket);
    }

    @SubscribeMessage(WaitingRoomEvents.KickPlayer)
    handleKickPlayer(@MessageBody() data: { roomId: string; player: Player }, @ConnectedSocket() socket: Socket) {
        return this.playerHandler.handleKickPlayer(data, socket, this.server);
    }

    // ===== Game Start Events =====

    @SubscribeMessage(WaitingRoomEvents.StartGame)
    async handleStartGame(@MessageBody() roomId: string): Promise<{ success: boolean; error?: string }> {
        return this.gameHandler.handleStartGame(roomId, this.server);
    }

    @SubscribeMessage(WaitingRoomEvents.GenerateCode)
    handleGenerateCode(@ConnectedSocket() socket: Socket) {
        return this.gameHandler.handleGenerateCode(socket);
    }

    // ===== Chat Events =====

    @SubscribeMessage(WaitingRoomEvents.SendMessageToWaitingRoom)
    async handleSendMessage(@MessageBody() data: { message: string; playerName: string | null; roomId: string }, @ConnectedSocket() socket: Socket) {
        return this.chatHandler.handleSendMessage(data, socket, this.server);
    }

    @SubscribeMessage(WaitingRoomEvents.GetMessagesFromWaitingRoom)
    async handleGetMessagesFromWaitingRoom(@MessageBody() roomId: string, @ConnectedSocket() socket: Socket) {
        return this.chatHandler.handleGetMessagesFromWaitingRoom(roomId, socket);
    }

    // ===== WebSocket Lifecycle Events =====

    handleConnection(@ConnectedSocket() socket: Socket) {
        this.logger.log(`socket connecté: ${socket.id}`);
    }

    handleDisconnect(@ConnectedSocket() socket: Socket) {
        this.managementHandler.handleDisconnect(socket, this.server);
    }
}

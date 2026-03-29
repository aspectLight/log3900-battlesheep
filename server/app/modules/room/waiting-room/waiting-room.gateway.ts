import { Player } from '@app/shared/interfaces/player';
import { SocialEvents, WaitingRoomEvents } from '@common/socket.constants';
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
    async handleCreateRoom(
        @MessageBody() data: { roomId: string; gameId: string; host: Player },
        @ConnectedSocket() socket: Socket,
    ): Promise<{ success: boolean; error?: string }> {
        return this.managementHandler.handleCreateRoom(data, socket, this.server);
    }

    @SubscribeMessage(WaitingRoomEvents.JoinWaitingRoom)
    async handleJoinRoom(@MessageBody() roomId: string, @ConnectedSocket() socket: Socket) {
        return this.managementHandler.handleJoinRoom(roomId, socket);
    }

    @SubscribeMessage(WaitingRoomEvents.LeaveWaitingRoom)
    async handleLeaveRoom(@MessageBody() roomId: string, @ConnectedSocket() socket: Socket) {
        return this.managementHandler.handleLeaveRoom(roomId, socket, this.server);
    }

    @SubscribeMessage(WaitingRoomEvents.ToggleLockWaitingRoom)
    handleLockRoom(@MessageBody() roomId: string, @ConnectedSocket() socket: Socket) {
        return this.managementHandler.handleLockRoom(roomId, socket, this.server);
    }

    @SubscribeMessage(WaitingRoomEvents.ToggleDropInDropOut)
    handleToggleDropInDropOut(@MessageBody() roomId: string, @ConnectedSocket() socket: Socket) {
        return this.managementHandler.handleToggleDropInDropOut(roomId, socket, this.server);
    }

    // ===== Player Management Events =====

    @SubscribeMessage(WaitingRoomEvents.CreatePlayer)
    handleCreatePlayer(@MessageBody() data: { roomId: string; player: Player }, @ConnectedSocket() socket: Socket) {
        return this.playerHandler.handleCreatePlayer(data, socket, this.server);
    }

    @SubscribeMessage(WaitingRoomEvents.ReserveAvatar)
    async handleReserveAvatar(
        @MessageBody() data: { roomId: string; chosenAvatar: string; playerId: string; isVirtual?: boolean },
        @ConnectedSocket() socket: Socket,
    ): Promise<{ success: boolean; error?: string }> {
        return await this.playerHandler.handleReserveAvatar(data, socket, this.server);
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

    // ===== Block Choice Events =====

    @SubscribeMessage(SocialEvents.BlockedUserRoomChoice)
    async handleBlockedUserRoomChoice(
        @MessageBody() data: { choice: 'enter' | 'cancel' },
        @ConnectedSocket() socket: Socket,
    ) {
        return this.managementHandler.handleBlockedUserRoomChoice(socket, data);
    }

    // ===== Room Listing Events =====

    @SubscribeMessage(WaitingRoomEvents.GetAvailableRooms)
    async handleGetAvailableRooms(@ConnectedSocket() socket: Socket) {
        return this.managementHandler.handleGetAvailableRooms(socket);
    }

    // ===== WebSocket Lifecycle Events =====

    handleConnection(@ConnectedSocket() socket: Socket) {
        this.logger.log(`socket connecté: ${socket.id}`);
    }

    async handleDisconnect(@ConnectedSocket() socket: Socket) {
        return this.managementHandler.handleDisconnect(socket, this.server);
    }
}

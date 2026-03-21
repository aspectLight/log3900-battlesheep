import { AuthService } from '@app/modules/auth/services/auth.service';
import { FriendshipService } from '@app/modules/social/services/friendship.service';
import { BlockService } from '@app/modules/social/services/block.service';
import { SocialEvents } from '@common/socket.constants';
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

@WebSocketGateway({ cors: { origin: '*' } })
@Injectable()
export class SocialGateway implements OnGatewayConnection, OnGatewayDisconnect {
    @WebSocketServer() private server: Server;
    private readonly logger = new Logger(SocialGateway.name);

    // Maps for tracking connected users
    private socketIdToUsername = new Map<string, string>();
    private usernameToSocketIds = new Map<string, Set<string>>();

    constructor(
        private readonly authService: AuthService,
        private readonly friendshipService: FriendshipService,
        private readonly blockService: BlockService,
    ) {}

    // ===== Connection Lifecycle =====

    async handleConnection(socket: Socket): Promise<void> {
        const { token } = socket.handshake.auth as { token?: string };
        if (!token) return;

        try {
            const decodedToken = await this.authService.verifyToken(token);
            const user = await this.authService.getUserByUid(decodedToken.uid);
            if (!user?.username) return;

            this.socketIdToUsername.set(socket.id, user.username);

            if (!this.usernameToSocketIds.has(user.username)) {
                this.usernameToSocketIds.set(user.username, new Set());
            }
            this.usernameToSocketIds.get(user.username).add(socket.id);

            // Notify friends that user is online
            await this.notifyFriendsPresence(user.username, true);
            this.logger.log(`Social: ${user.username} connecté (socket ${socket.id})`);
        } catch {
            // Auth failed silently — socket just won't get social features
        }
    }

    async handleDisconnect(socket: Socket): Promise<void> {
        const username = this.socketIdToUsername.get(socket.id);
        if (!username) return;

        this.socketIdToUsername.delete(socket.id);
        const sockets = this.usernameToSocketIds.get(username);
        if (sockets) {
            sockets.delete(socket.id);
            if (sockets.size === 0) {
                this.usernameToSocketIds.delete(username);
                // User has no more active sockets — notify friends offline
                await this.notifyFriendsPresence(username, false);
            }
        }
    }

    // ===== Friend Requests =====

    @SubscribeMessage(SocialEvents.SendFriendRequest)
    async handleSendFriendRequest(
        @ConnectedSocket() socket: Socket,
        @MessageBody() data: { targetUsername: string },
    ): Promise<void> {
        const senderUsername = this.socketIdToUsername.get(socket.id);
        if (!senderUsername) return;

        try {
            const request = await this.friendshipService.sendFriendRequest(senderUsername, data.targetUsername);
            // Notify the receiver if online
            this.emitToUser(data.targetUsername, SocialEvents.FriendRequestReceived, {
                requestId: request._id,
                senderId: senderUsername,
            });
        } catch (error) {
            socket.emit(SocialEvents.SocialError, { message: error.message });
        }
    }

    @SubscribeMessage(SocialEvents.AcceptFriendRequest)
    async handleAcceptFriendRequest(
        @ConnectedSocket() socket: Socket,
        @MessageBody() data: { requestId: string },
    ): Promise<void> {
        const currentUsername = this.socketIdToUsername.get(socket.id);
        if (!currentUsername) return;

        try {
            const { request } = await this.friendshipService.acceptFriendRequest(data.requestId, currentUsername);

            // Notify the sender that their request was accepted
            this.emitToUser(request.senderId, SocialEvents.FriendRequestAccepted, {
                friendUsername: currentUsername,
            });

            // Send updated friends list to both users
            await this.sendFriendsListToUser(currentUsername);
            await this.sendFriendsListToUser(request.senderId);
        } catch (error) {
            socket.emit(SocialEvents.SocialError, { message: error.message });
        }
    }

    @SubscribeMessage(SocialEvents.RefuseFriendRequest)
    async handleRefuseFriendRequest(
        @ConnectedSocket() socket: Socket,
        @MessageBody() data: { requestId: string },
    ): Promise<void> {
        const currentUsername = this.socketIdToUsername.get(socket.id);
        if (!currentUsername) return;

        try {
            const request = await this.friendshipService.refuseFriendRequest(data.requestId, currentUsername);
            this.emitToUser(request.senderId, SocialEvents.FriendRequestRefused, {
                receiverUsername: currentUsername,
            });
        } catch (error) {
            socket.emit(SocialEvents.SocialError, { message: error.message });
        }
    }

    @SubscribeMessage(SocialEvents.CancelFriendRequest)
    async handleCancelFriendRequest(
        @ConnectedSocket() socket: Socket,
        @MessageBody() data: { requestId: string },
    ): Promise<void> {
        const senderUsername = this.socketIdToUsername.get(socket.id);
        if (!senderUsername) return;

        try {
            const request = await this.friendshipService.cancelFriendRequest(data.requestId, senderUsername);
            // Notify the receiver that the request was canceled
            this.emitToUser(request.receiverId, SocialEvents.FriendRequestCanceled, {
                senderUsername,
            });
        } catch (error) {
            socket.emit(SocialEvents.SocialError, { message: error.message });
        }
    }

    @SubscribeMessage(SocialEvents.RemoveFriend)
    async handleRemoveFriend(
        @ConnectedSocket() socket: Socket,
        @MessageBody() data: { friendUsername: string },
    ): Promise<void> {
        const currentUsername = this.socketIdToUsername.get(socket.id);
        if (!currentUsername) return;

        try {
            await this.friendshipService.removeFriend(currentUsername, data.friendUsername);

            // Notify the removed friend
            this.emitToUser(data.friendUsername, SocialEvents.FriendRemoved, {
                friendUsername: currentUsername,
            });

            // Send updated lists to both
            await this.sendFriendsListToUser(currentUsername);
            await this.sendFriendsListToUser(data.friendUsername);
        } catch (error) {
            socket.emit(SocialEvents.SocialError, { message: error.message });
        }
    }

    // ===== Blocking =====

    @SubscribeMessage(SocialEvents.BlockUser)
    async handleBlockUser(
        @ConnectedSocket() socket: Socket,
        @MessageBody() data: { targetUsername: string },
    ): Promise<void> {
        const currentUsername = this.socketIdToUsername.get(socket.id);
        if (!currentUsername) return;

        try {
            await this.blockService.blockUser(currentUsername, data.targetUsername);

            socket.emit(SocialEvents.UserBlocked, { blockedUsername: data.targetUsername });

            // Notify the blocked user so they can update their usersWhoBlockedMe list
            this.emitToUser(data.targetUsername, SocialEvents.UserBlocked, {
                blockerUsername: currentUsername,
            });

            // If they were friends, notify the blocked user that friendship was removed
            this.emitToUser(data.targetUsername, SocialEvents.FriendRemoved, {
                friendUsername: currentUsername,
            });

            // Update friends list for both
            await this.sendFriendsListToUser(currentUsername);
            await this.sendFriendsListToUser(data.targetUsername);
        } catch (error) {
            socket.emit(SocialEvents.SocialError, { message: error.message });
        }
    }

    @SubscribeMessage(SocialEvents.UnblockUser)
    async handleUnblockUser(
        @ConnectedSocket() socket: Socket,
        @MessageBody() data: { targetUsername: string },
    ): Promise<void> {
        const currentUsername = this.socketIdToUsername.get(socket.id);
        if (!currentUsername) return;

        try {
            await this.blockService.unblockUser(currentUsername, data.targetUsername);
            socket.emit(SocialEvents.UserUnblocked, { unblockedUsername: data.targetUsername });

            // Notify the unblocked user so they can update their usersWhoBlockedMe list
            this.emitToUser(data.targetUsername, SocialEvents.UserUnblocked, {
                unblockerUsername: currentUsername,
            });
        } catch (error) {
            socket.emit(SocialEvents.SocialError, { message: error.message });
        }
    }

    // ===== State Sync =====

    @SubscribeMessage(SocialEvents.GetFriendsList)
    async handleGetFriendsList(@ConnectedSocket() socket: Socket): Promise<void> {
        const username = this.socketIdToUsername.get(socket.id);
        if (!username) return;

        const friends = await this.friendshipService.getFriendsList(username);
        socket.emit(SocialEvents.FriendsListResponse, friends);
    }

    @SubscribeMessage(SocialEvents.GetPendingRequests)
    async handleGetPendingRequests(@ConnectedSocket() socket: Socket): Promise<void> {
        const username = this.socketIdToUsername.get(socket.id);
        if (!username) return;

        const requests = await this.friendshipService.getPendingRequestsReceived(username);
        socket.emit(SocialEvents.PendingRequestsResponse, requests);
    }

    @SubscribeMessage(SocialEvents.GetBlockedUsers)
    async handleGetBlockedUsers(@ConnectedSocket() socket: Socket): Promise<void> {
        const username = this.socketIdToUsername.get(socket.id);
        if (!username) return;

        const blockedUsers = await this.blockService.getBlockedUsers(username);
        socket.emit(SocialEvents.BlockedUsersResponse, blockedUsers);
    }

    @SubscribeMessage(SocialEvents.GetUsersWhoBlockedMe)
    async handleGetUsersWhoBlockedMe(@ConnectedSocket() socket: Socket): Promise<void> {
        const username = this.socketIdToUsername.get(socket.id);
        if (!username) return;

        const usersWhoBlockedMe = await this.blockService.getUsersWhoBlocked(username);
        socket.emit(SocialEvents.UsersWhoBlockedMeResponse, usersWhoBlockedMe);
    }

    // ===== Helpers =====

    emitToUser(username: string, event: string, data: unknown): void {
        const socketIds = this.usernameToSocketIds.get(username);
        if (!socketIds) return;
        for (const socketId of socketIds) {
            this.server.to(socketId).emit(event, data);
        }
    }

    private async notifyFriendsPresence(username: string, isOnline: boolean): Promise<void> {
        const friendUsernames = await this.friendshipService.getFriendUsernames(username);
        const event = isOnline ? SocialEvents.FriendOnline : SocialEvents.FriendOffline;

        for (const friendUsername of friendUsernames) {
            this.emitToUser(friendUsername, event, { username });
        }
    }

    private async sendFriendsListToUser(username: string): Promise<void> {
        const friends = await this.friendshipService.getFriendsList(username);
        this.emitToUser(username, SocialEvents.FriendsListResponse, friends);
    }
}

import { AuthGuard } from '@app/modules/auth/guards/auth.guard';
import { CurrentUser } from '@app/modules/auth/decorators/current-user.decorator';
import { UserDocument } from '@app/modules/auth/schemas/user.schema';
import { FriendshipService } from '@app/modules/social/services/friendship.service';
import { BlockService } from '@app/modules/social/services/block.service';
import { SocialGateway } from '@app/modules/social/gateways/social.gateway';
import { SocialEvents } from '@common/socket.constants';
import { Controller, Get, Post, Patch, Delete, Param, Query, Body, UseGuards } from '@nestjs/common';

@Controller('social')
@UseGuards(AuthGuard)
export class SocialController {
    constructor(
        private readonly friendshipService: FriendshipService,
        private readonly blockService: BlockService,
        private readonly socialGateway: SocialGateway,
    ) {}

    // ===== Friends =====

    @Get('friends')
    async getFriends(@CurrentUser() user: UserDocument) {
        return this.friendshipService.getFriendsList(user.username);
    }

    @Delete('friends/:username')
    async removeFriend(@CurrentUser() user: UserDocument, @Param('username') friendUsername: string) {
        await this.friendshipService.removeFriend(user.username, friendUsername);
        this.socialGateway.emitToUser(friendUsername, SocialEvents.FriendRemoved, { friendUsername: user.username });
        return { message: 'Ami retiré' };
    }

    // ===== Friend Requests =====

    @Get('requests/pending')
    async getPendingRequests(@CurrentUser() user: UserDocument) {
        return this.friendshipService.getPendingRequestsReceived(user.username);
    }

    @Get('requests/sent')
    async getSentRequests(@CurrentUser() user: UserDocument) {
        return this.friendshipService.getPendingRequestsSent(user.username);
    }

    @Post('requests')
    async sendFriendRequest(@CurrentUser() user: UserDocument, @Body('targetUsername') targetUsername: string) {
        const request = await this.friendshipService.sendFriendRequest(user.username, targetUsername);
        this.socialGateway.emitToUser(targetUsername, SocialEvents.FriendRequestReceived, {
            requestId: request._id,
            senderId: user.username,
        });
        return request;
    }

    @Delete('requests/:id')
    async cancelRequest(@CurrentUser() user: UserDocument, @Param('id') requestId: string) {
        const request = await this.friendshipService.cancelFriendRequest(requestId, user.username);
        this.socialGateway.emitToUser(request.receiverId, SocialEvents.FriendRequestCanceled, { senderUsername: user.username });
        return { message: 'Demande annulée' };
    }

    @Patch('requests/:id/accept')
    async acceptRequest(@CurrentUser() user: UserDocument, @Param('id') requestId: string) {
        const { request, friendship } = await this.friendshipService.acceptFriendRequest(requestId, user.username);
        this.socialGateway.emitToUser(request.senderId, SocialEvents.FriendRequestAccepted, { friendUsername: user.username });
        return { request, friendship };
    }

    @Patch('requests/:id/refuse')
    async refuseRequest(@CurrentUser() user: UserDocument, @Param('id') requestId: string) {
        const request = await this.friendshipService.refuseFriendRequest(requestId, user.username);
        this.socialGateway.emitToUser(request.senderId, SocialEvents.FriendRequestRefused, { receiverUsername: user.username });
        return request;
    }

    // ===== Block =====

    @Get('blocked')
    async getBlockedUsers(@CurrentUser() user: UserDocument) {
        return this.blockService.getBlockedUsers(user.username);
    }

    @Get('blocked-by')
    async getUsersWhoBlockedMe(@CurrentUser() user: UserDocument) {
        return this.blockService.getUsersWhoBlocked(user.username);
    }

    @Post('block')
    async blockUser(@CurrentUser() user: UserDocument, @Body('targetUsername') targetUsername: string) {
        const result = await this.blockService.blockUser(user.username, targetUsername);
        this.socialGateway.emitToUser(targetUsername, SocialEvents.UserBlocked, { blockerUsername: user.username });
        this.socialGateway.emitToUser(targetUsername, SocialEvents.FriendRemoved, { friendUsername: user.username });
        return result;
    }

    @Delete('block/:username')
    async unblockUser(@CurrentUser() user: UserDocument, @Param('username') blockedUsername: string) {
        await this.blockService.unblockUser(user.username, blockedUsername);
        this.socialGateway.emitToUser(blockedUsername, SocialEvents.UserUnblocked, { unblockerUsername: user.username });
        return { message: 'Utilisateur débloqué' };
    }

    // ===== Search =====

    @Get('search')
    async searchUsers(@CurrentUser() user: UserDocument, @Query('q') query: string) {
        return this.friendshipService.searchUsers(user.username, query);
    }
}

import { AuthGuard } from '@app/modules/auth/guards/auth.guard';
import { CurrentUser } from '@app/modules/auth/decorators/current-user.decorator';
import { UserDocument } from '@app/modules/auth/schemas/user.schema';
import { FriendshipService } from '@app/modules/social/services/friendship.service';
import { BlockService } from '@app/modules/social/services/block.service';
import { Controller, Get, Post, Patch, Delete, Param, Query, Body, UseGuards } from '@nestjs/common';

@Controller('social')
@UseGuards(AuthGuard)
export class SocialController {
    constructor(
        private readonly friendshipService: FriendshipService,
        private readonly blockService: BlockService,
    ) {}

    // ===== Friends =====

    @Get('friends')
    async getFriends(@CurrentUser() user: UserDocument) {
        return this.friendshipService.getFriendsList(user.username);
    }

    @Delete('friends/:username')
    async removeFriend(@CurrentUser() user: UserDocument, @Param('username') friendUsername: string) {
        await this.friendshipService.removeFriend(user.username, friendUsername);
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
        return this.friendshipService.sendFriendRequest(user.username, targetUsername);
    }

    @Delete('requests/:id')
    async cancelRequest(@CurrentUser() user: UserDocument, @Param('id') requestId: string) {
        await this.friendshipService.cancelFriendRequest(requestId, user.username);
        return { message: 'Demande annulée' };
    }

    @Patch('requests/:id/accept')
    async acceptRequest(@CurrentUser() user: UserDocument, @Param('id') requestId: string) {
        const { request, friendship } = await this.friendshipService.acceptFriendRequest(requestId, user.username);
        return { request, friendship };
    }

    @Patch('requests/:id/refuse')
    async refuseRequest(@CurrentUser() user: UserDocument, @Param('id') requestId: string) {
        return this.friendshipService.refuseFriendRequest(requestId, user.username);
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
        return this.blockService.blockUser(user.username, targetUsername);
    }

    @Delete('block/:username')
    async unblockUser(@CurrentUser() user: UserDocument, @Param('username') blockedUsername: string) {
        await this.blockService.unblockUser(user.username, blockedUsername);
        return { message: 'Utilisateur débloqué' };
    }

    // ===== Search =====

    @Get('search')
    async searchUsers(@CurrentUser() user: UserDocument, @Query('q') query: string) {
        return this.friendshipService.searchUsers(user.username, query);
    }
}

import { Injectable, Logger, BadRequestException, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Block, BlockDocument } from '@app/modules/social/schemas/block.schema';
import { Friendship, FriendshipDocument } from '@app/modules/social/schemas/friendship.schema';
import { FriendRequest, FriendRequestDocument } from '@app/modules/social/schemas/friend-request.schema';

@Injectable()
export class BlockService {
    private readonly logger = new Logger(BlockService.name);

    constructor(
        @InjectModel(Block.name) private readonly blockModel: Model<BlockDocument>,
        @InjectModel(Friendship.name) private readonly friendshipModel: Model<FriendshipDocument>,
        @InjectModel(FriendRequest.name) private readonly friendRequestModel: Model<FriendRequestDocument>,
    ) {}

    async blockUser(blockerUsername: string, blockedUsername: string): Promise<BlockDocument> {
        if (blockerUsername === blockedUsername) {
            throw new BadRequestException('Vous ne pouvez pas vous bloquer vous-même');
        }

        const existing = await this.blockModel.findOne({ blockerId: blockerUsername, blockedId: blockedUsername });
        if (existing) {
            throw new BadRequestException('Cet utilisateur est déjà bloqué');
        }

        const block = new this.blockModel({ blockerId: blockerUsername, blockedId: blockedUsername });
        await block.save();

        // Remove friendship if it exists
        const [sortedUser1, sortedUser2] = [blockerUsername, blockedUsername].sort();
        await this.friendshipModel.deleteOne({ user1: sortedUser1, user2: sortedUser2 });

        // Remove any pending friend requests between them
        await this.friendRequestModel.deleteMany({
            $or: [
                { senderId: blockerUsername, receiverId: blockedUsername },
                { senderId: blockedUsername, receiverId: blockerUsername },
            ],
        });

        this.logger.log(`Utilisateur bloqué: ${blockerUsername} → ${blockedUsername}`);
        return block;
    }

    async unblockUser(blockerUsername: string, blockedUsername: string): Promise<void> {
        const result = await this.blockModel.deleteOne({ blockerId: blockerUsername, blockedId: blockedUsername });
        if (result.deletedCount === 0) {
            throw new NotFoundException('Cet utilisateur n\'est pas bloqué');
        }
        this.logger.log(`Utilisateur débloqué: ${blockerUsername} → ${blockedUsername}`);
    }

    async isBlocked(blockerUsername: string, blockedUsername: string): Promise<boolean> {
        const block = await this.blockModel.findOne({ blockerId: blockerUsername, blockedId: blockedUsername });
        return !!block;
    }

    async isBlockedBidirectional(user1: string, user2: string): Promise<boolean> {
        const block = await this.blockModel.findOne({
            $or: [
                { blockerId: user1, blockedId: user2 },
                { blockerId: user2, blockedId: user1 },
            ],
        });
        return !!block;
    }

    async getBlockedUsers(blockerUsername: string): Promise<string[]> {
        const blocks = await this.blockModel.find({ blockerId: blockerUsername }).select('blockedId').exec();
        return blocks.map((b) => b.blockedId);
    }

    async getUsersWhoBlocked(username: string): Promise<string[]> {
        const blocks = await this.blockModel.find({ blockedId: username }).select('blockerId').exec();
        return blocks.map((b) => b.blockerId);
    }

    async cleanupForUser(username: string): Promise<void> {
        await this.blockModel.deleteMany({
            $or: [{ blockerId: username }, { blockedId: username }],
        });
        this.logger.log(`Données de blocage nettoyées pour ${username}`);
    }
}

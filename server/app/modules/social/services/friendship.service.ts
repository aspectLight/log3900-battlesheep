import { Injectable, Logger, ConflictException, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { FriendRequest, FriendRequestDocument } from '@app/modules/social/schemas/friend-request.schema';
import { Friendship, FriendshipDocument } from '@app/modules/social/schemas/friendship.schema';
import { Block, BlockDocument } from '@app/modules/social/schemas/block.schema';
import { User, UserDocument } from '@app/modules/auth/schemas/user.schema';

@Injectable()
export class FriendshipService {
    private readonly logger = new Logger(FriendshipService.name);

    constructor(
        @InjectModel(FriendRequest.name) private readonly friendRequestModel: Model<FriendRequestDocument>,
        @InjectModel(Friendship.name) private readonly friendshipModel: Model<FriendshipDocument>,
        @InjectModel(Block.name) private readonly blockModel: Model<BlockDocument>,
        @InjectModel(User.name) private readonly userModel: Model<UserDocument>,
    ) {}

    async sendFriendRequest(senderUsername: string, receiverUsername: string): Promise<FriendRequestDocument> {
        if (senderUsername === receiverUsername) {
            throw new BadRequestException('Vous ne pouvez pas vous envoyer une demande à vous-même');
        }

        const receiver = await this.userModel.findOne({ username: receiverUsername });
        if (!receiver) {
            throw new NotFoundException('Utilisateur non trouvé');
        }

        // Check if already friends
        const existingFriendship = await this.findFriendship(senderUsername, receiverUsername);
        if (existingFriendship) {
            throw new ConflictException('Vous êtes déjà amis avec cet utilisateur');
        }

        // Check if blocked
        const isBlocked = await this.blockModel.findOne({
            $or: [
                { blockerId: senderUsername, blockedId: receiverUsername },
                { blockerId: receiverUsername, blockedId: senderUsername },
            ],
        });
        if (isBlocked) {
            throw new BadRequestException('Impossible d\'envoyer une demande à cet utilisateur');
        }

        // Check if there's already a pending request in either direction
        const existingRequest = await this.friendRequestModel.findOne({
            $or: [
                { senderId: senderUsername, receiverId: receiverUsername, status: 'pending' },
                { senderId: receiverUsername, receiverId: senderUsername, status: 'pending' },
            ],
        });
        if (existingRequest) {
            throw new ConflictException('Une demande d\'ami est déjà en attente');
        }

        // Delete any old refused request so the unique index doesn't block
        await this.friendRequestModel.deleteMany({
            senderId: senderUsername,
            receiverId: receiverUsername,
            status: { $in: ['refused', 'accepted'] },
        });

        const request = new this.friendRequestModel({
            senderId: senderUsername,
            receiverId: receiverUsername,
            status: 'pending',
        });

        await request.save();
        this.logger.log(`Demande d'ami envoyée: ${senderUsername} → ${receiverUsername}`);
        return request;
    }

    async acceptFriendRequest(requestId: string, currentUsername: string): Promise<{ request: FriendRequestDocument; friendship: FriendshipDocument }> {
        const request = await this.friendRequestModel.findById(requestId);
        if (!request) {
            throw new NotFoundException('Demande non trouvée');
        }
        if (request.receiverId !== currentUsername) {
            throw new BadRequestException('Vous ne pouvez accepter que les demandes qui vous sont adressées');
        }
        if (request.status !== 'pending') {
            throw new BadRequestException('Cette demande a déjà été traitée');
        }

        request.status = 'accepted';
        await request.save();

        const friendship = await this.createFriendship(request.senderId, request.receiverId);
        this.logger.log(`Demande acceptée: ${request.senderId} ↔ ${request.receiverId}`);
        return { request, friendship };
    }

    async refuseFriendRequest(requestId: string, currentUsername: string): Promise<FriendRequestDocument> {
        const request = await this.friendRequestModel.findById(requestId);
        if (!request) {
            throw new NotFoundException('Demande non trouvée');
        }
        if (request.receiverId !== currentUsername) {
            throw new BadRequestException('Vous ne pouvez refuser que les demandes qui vous sont adressées');
        }
        if (request.status !== 'pending') {
            throw new BadRequestException('Cette demande a déjà été traitée');
        }

        request.status = 'refused';
        await request.save();
        this.logger.log(`Demande refusée: ${request.senderId} → ${request.receiverId}`);
        return request;
    }

    async cancelFriendRequest(requestId: string, senderUsername: string): Promise<FriendRequestDocument> {
        const request = await this.friendRequestModel.findById(requestId);
        if (!request) {
            throw new NotFoundException('Demande non trouvée');
        }
        if (request.senderId !== senderUsername) {
            throw new BadRequestException('Vous ne pouvez annuler que vos propres demandes');
        }
        if (request.status !== 'pending') {
            throw new BadRequestException('Cette demande a déjà été traitée');
        }

        await this.friendRequestModel.deleteOne({ _id: requestId });
        this.logger.log(`Demande annulée: ${senderUsername} → ${request.receiverId}`);
        return request;
    }

    async removeFriend(currentUsername: string, friendUsername: string): Promise<void> {
        const deleted = await this.deleteFriendship(currentUsername, friendUsername);
        if (!deleted) {
            throw new NotFoundException('Cet utilisateur n\'est pas dans votre liste d\'amis');
        }
        // Clean up any pending requests between them
        await this.friendRequestModel.deleteMany({
            $or: [
                { senderId: currentUsername, receiverId: friendUsername },
                { senderId: friendUsername, receiverId: currentUsername },
            ],
        });
        this.logger.log(`Ami retiré: ${currentUsername} ↔ ${friendUsername}`);
    }

    async getFriendsList(username: string): Promise<UserDocument[]> {
        const friendships = await this.friendshipModel.find({
            $or: [{ user1: username }, { user2: username }],
        });

        const friendUsernames = friendships.map((f) => (f.user1 === username ? f.user2 : f.user1));

        if (friendUsernames.length === 0) return [];

        return this.userModel
            .find({ username: { $in: friendUsernames } })
            .select('username avatarId avatarUrl isOnline')
            .exec();
    }

    async getFriendUsernames(username: string): Promise<string[]> {
        const friendships = await this.friendshipModel.find({
            $or: [{ user1: username }, { user2: username }],
        });
        return friendships.map((f) => (f.user1 === username ? f.user2 : f.user1));
    }

    async getPendingRequestsReceived(username: string): Promise<FriendRequestDocument[]> {
        return this.friendRequestModel.find({ receiverId: username, status: 'pending' }).exec();
    }

    async getPendingRequestsSent(username: string): Promise<FriendRequestDocument[]> {
        return this.friendRequestModel.find({ senderId: username, status: 'pending' }).exec();
    }

    async areFriends(user1: string, user2: string): Promise<boolean> {
        const friendship = await this.findFriendship(user1, user2);
        return !!friendship;
    }

    async searchUsers(currentUsername: string, query: string): Promise<UserDocument[]> {
        if (!query || query.trim().length === 0) return [];

        // Get friends to exclude
        const friendUsernames = await this.getFriendUsernames(currentUsername);

        // Get users who blocked the current user (they should not appear)
        const blockedByOthers = await this.blockModel.find({ blockedId: currentUsername }).select('blockerId').exec();
        const blockerUsernames = blockedByOthers.map((b) => b.blockerId);

        // Get users the current user has blocked
        const blockedByMe = await this.blockModel.find({ blockerId: currentUsername }).select('blockedId').exec();
        const blockedUsernames = blockedByMe.map((b) => b.blockedId);

        const excludedUsernames = [currentUsername, ...friendUsernames, ...blockerUsernames, ...blockedUsernames];

        return this.userModel
            .find({
                username: { $regex: query, $options: 'i', $nin: excludedUsernames },
            })
            .select('username avatarId avatarUrl isOnline')
            .limit(20)
            .exec();
    }

    async cleanupForUser(username: string): Promise<void> {
        await this.friendRequestModel.deleteMany({
            $or: [{ senderId: username }, { receiverId: username }],
        });
        await this.friendshipModel.deleteMany({
            $or: [{ user1: username }, { user2: username }],
        });
        this.logger.log(`Données d'amitié nettoyées pour ${username}`);
    }

    private async createFriendship(user1: string, user2: string): Promise<FriendshipDocument> {
        const [sortedUser1, sortedUser2] = [user1, user2].sort();
        const friendship = new this.friendshipModel({ user1: sortedUser1, user2: sortedUser2 });
        return friendship.save();
    }

    private async findFriendship(user1: string, user2: string): Promise<FriendshipDocument | null> {
        const [sortedUser1, sortedUser2] = [user1, user2].sort();
        return this.friendshipModel.findOne({ user1: sortedUser1, user2: sortedUser2 });
    }

    private async deleteFriendship(user1: string, user2: string): Promise<boolean> {
        const [sortedUser1, sortedUser2] = [user1, user2].sort();
        const result = await this.friendshipModel.deleteOne({ user1: sortedUser1, user2: sortedUser2 });
        return result.deletedCount > 0;
    }
}

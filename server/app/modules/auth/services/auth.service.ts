/* eslint-disable @typescript-eslint/no-explicit-any */
import { RegisterUserDto, UpdateUserDto } from '@app/modules/auth/dto/auth.dto';
import { EXCLUSIVE_AVATAR_IDS, SHOP_CATALOGUE, ShopItem } from '@common/shop.constants';
import { User, UserDocument } from '@app/modules/auth/schemas/user.schema';
import { FirebaseAdminService } from '@app/modules/auth/services/firebase-admin.service';
import { CustomChannelService } from '@app/modules/general-chat/services/custom-channel.service';
import { GeneralChatService } from '@app/modules/general-chat/services/general-chat.service';
import { GameService } from '@app/modules/game/services/game.service';
import { FriendshipService } from '@app/modules/social/services/friendship.service';
import { BlockService } from '@app/modules/social/services/block.service';
import { ConflictException, BadRequestException, ForbiddenException, Inject, Injectable, Logger, NotFoundException, UnauthorizedException, forwardRef } from '@nestjs/common';
import { ChatModerationService } from '@app/modules/general-chat/services/chat-moderation.service';
import { InjectModel } from '@nestjs/mongoose';
import { DecodedIdToken } from 'firebase-admin/auth';
import { Model } from 'mongoose';
import { v4 as uuidv4 } from 'uuid';
// eslint-disable-next-line @typescript-eslint/no-unused-vars
import type {} from 'multer';

const DELETED_USER_PLACEHOLDER = '[supprimé]';

@Injectable()
export class AuthService {
    private readonly logger = new Logger(AuthService.name);

    constructor(
        private readonly firebaseAdminService: FirebaseAdminService,
        @InjectModel(User.name) private readonly userModel: Model<UserDocument>,
        @Inject(forwardRef(() => GeneralChatService)) private readonly generalChatService: GeneralChatService,
        @Inject(forwardRef(() => CustomChannelService)) private readonly customChannelService: CustomChannelService,
        @Inject(forwardRef(() => GameService)) private readonly gameService: GameService,
        @Inject(forwardRef(() => FriendshipService)) private readonly friendshipService: FriendshipService,
        @Inject(forwardRef(() => BlockService)) private readonly blockService: BlockService,
        @Inject(forwardRef(() => ChatModerationService)) private readonly chatModerationService: ChatModerationService,
    ) {}

    async verifyToken(idToken: string): Promise<DecodedIdToken> {
        try {
            const decodedToken = await this.firebaseAdminService.getAuth().verifyIdToken(idToken);
            return decodedToken;
        } catch (error) {
            this.logger.warn(`Token verification failed: ${error.message}`);
            throw new UnauthorizedException('Token invalide ou expiré');
        }
    }

    async registerUser(registerDto: RegisterUserDto): Promise<UserDocument> {
        const { email, password, username, avatarId } = registerDto;

        await this.checkUsername(username);

        if (avatarId && EXCLUSIVE_AVATAR_IDS.includes(avatarId)) {
            throw new ForbiddenException('Cet avatar est exclusif et doit être acheté en boutique.');
        }

        try {
            // 1. Create a new user in Firebase Auth
            const firebaseUser = await this.firebaseAdminService.getAuth().createUser({
                email,
                password,
                displayName: username,
            });

            this.logger.log(`Firebase user created: ${firebaseUser.uid}`);

            // 2. Create a new user in MongoDB
            const user = new this.userModel({
                firebaseUid: firebaseUser.uid,
                email: firebaseUser.email,
                username,
                avatarId,
                statistics: {
                    classicGamesPlayed: 0,
                    ctfGamesPlayed: 0,
                    totalGamesWon: 0,
                    totalPlaytime: 0,
                },
            });

            await user.save();
            this.logger.log(`MongoDB user created for uid: ${firebaseUser.uid}`);
            return user;
        } catch (error) {
            if (error.code === 'auth/email-already-exists') {
                throw new ConflictException('Cet email est déjà utilisé');
            }
            this.logger.error(`Registration failed: ${error.message}`);
            throw error;
        }
    }

    async login(decodedToken: DecodedIdToken): Promise<{ user: UserDocument; sessionId: string }> {
        const { uid } = decodedToken;

        const user = await this.userModel.findOne({ firebaseUid: uid });
        if (!user) {
            throw new NotFoundException('Utilisateur non trouvé. Veuillez créer un compte.');
        }

        if (user.isOnline && user.currentSessionId) {
            throw new ForbiddenException('Ce compte est déjà connecté sur un autre appareil.');
        }

        const sessionId = uuidv4();
        user.currentSessionId = sessionId;
        user.isOnline = true;
        user.lastLoginAt = new Date();
        user.loginHistory.push({ date: new Date(), type: 'login' });

        await user.save();
        this.logger.log(`User logged in: ${uid}`);
        return { user, sessionId };
    }

    async logout(uid: string): Promise<void> {
        const user = await this.getUserByUid(uid);
        user.currentSessionId = null;
        user.isOnline = false;
        user.loginHistory.push({ date: new Date(), type: 'logout' });
        await user.save();
        this.logger.log(`User logged out: ${uid}`);
    }

    async getUserByUid(uid: string): Promise<UserDocument> {
        const user = await this.userModel.findOne({ firebaseUid: uid });
        if (!user) {
            throw new NotFoundException('Utilisateur non trouvé');
        }
        return user;
    }

    async getEmailByUsername(username: string): Promise<string> {
        const user = await this.userModel.findOne({ username });
        if (!user) {
            throw new NotFoundException('Utilisateur non trouvé');
        }
        return user.email;
    }

    async getAvatarsForUsernames(
        usernames: string[],
    ): Promise<{ username: string; avatarId: string | null; avatarUrl: string | null; deleted: boolean }[]> {
        if (!usernames || usernames.length === 0) return [];
        const unique = [...new Set(usernames)];
        const users = await this.userModel.find({ username: { $in: unique } }, { username: 1, avatarId: 1, avatarUrl: 1 });
        const byUsername = new Map(users.map((u) => [u.username, u]));
        return unique.map((username) => {
            const u = byUsername.get(username);
            if (!u) return { username, avatarId: null, avatarUrl: null, deleted: true };
            return { username, avatarId: u.avatarId ?? null, avatarUrl: u.avatarUrl ?? null, deleted: false };
        });
    }

    async getUserByUsername(username: string): Promise<UserDocument> {
        const user = await this.userModel.findOne({ username });
        if (!user) {
            throw new NotFoundException('Utilisateur non trouvé');
        }
        return user;
    }

    async updateUser(uid: string, updateDto: UpdateUserDto): Promise<UserDocument> {
        const user = await this.getUserByUid(uid);

        // Updating username
        if (updateDto.username && updateDto.username !== user.username) {
            await this.checkUsername(updateDto.username, uid);
            user.username = updateDto.username;
            await this.firebaseAdminService.getAuth().updateUser(uid, {
                displayName: updateDto.username,
            });
        }

        // Updating email
        if (updateDto.email && updateDto.email !== user.email) {
            await this.checkEmail(updateDto.email, uid);
            user.email = updateDto.email;
            await this.firebaseAdminService.getAuth().updateUser(uid, {
                email: updateDto.email,
            });
        }

        // Updating avatar
        if (updateDto.avatarId && updateDto.avatarId !== user.avatarId) {
            if (EXCLUSIVE_AVATAR_IDS.includes(updateDto.avatarId) && !(user.purchasedItems ?? []).includes(updateDto.avatarId)) {
                throw new ForbiddenException('Cet avatar est exclusif et doit être acheté en boutique.');
            }
            user.avatarId = updateDto.avatarId;
            user.avatarUrl = undefined;
            user.avatarImageBuffer = undefined;
            user.avatarImageMimeType = undefined;
            user.avatarVersion = undefined;
        }

        // Updating theme
        const validThemes = ['default', 'frost', 'village'];
        if (updateDto.theme && validThemes.includes(updateDto.theme) && updateDto.theme !== user.theme) {
            user.theme = updateDto.theme;
        }

        // Updating language
        const validLanguages = ['fr', 'en'];
        if (updateDto.language && validLanguages.includes(updateDto.language) && updateDto.language !== user.language) {
            user.language = updateDto.language;
        }

        // Updating preferences
        if (updateDto.preferences && updateDto.preferences !== user.preferences) {
            user.preferences = { ...user.preferences, ...updateDto.preferences };
        }

        await user.save();
        return user;
    }

    async deleteUser(uid: string): Promise<void> {
        try {
            const user = await this.getUserByUid(uid);
            const { username } = user;

            // 1. Log out user
            await this.logout(uid);

            // 2. Replace username by "[supprimé]" in chat history
            await this.generalChatService.replaceUsername(username, DELETED_USER_PLACEHOLDER);
            await this.customChannelService.replaceUsername(username, DELETED_USER_PLACEHOLDER);

            // 3. Clean up social data (friendships, friend requests, blocks)
            await this.friendshipService.cleanupForUser(username);
            await this.blockService.cleanupForUser(username);

            // 4. Delete all games owned by this user
            const deletedCount = await this.gameService.deleteGamesByOwner(username);
            this.logger.log(`Deleted ${deletedCount} game(s) owned by user: ${username}`);

            // 4. Delete user from Firebase Auth
            await this.firebaseAdminService.getAuth().deleteUser(uid);

            // 5. Delete user from MongoDB
            await this.userModel.deleteOne({ firebaseUid: uid });

            this.logger.log(`User deleted: ${uid}`);
        } catch (error) {
            this.logger.error(`User deletion failed: ${error.message}`);
            throw error;
        }
    }

    async updateAvatarFromFile(uid: string, file: Express.Multer.File): Promise<UserDocument> {
        const user = await this.getUserByUid(uid);

        const version = uuidv4();
        user.avatarImageBuffer = file.buffer;
        user.avatarImageMimeType = file.mimetype;
        user.avatarVersion = version;
        user.avatarUrl = `/auth/avatar/${uid}?v=${version}`;

        await user.save();

        this.logger.log(`Avatar mis à jour pour l'utilisateur ${uid} (stocké en base)`);

        return user;
    }

    async validateSession(uid: string, sessionId: string): Promise<boolean> {
        const user = await this.userModel.findOne({ firebaseUid: uid });
        return user?.currentSessionId === sessionId && user?.isOnline === true;
    }

    async checkUsername(username: string, excludeUid?: string): Promise<void> {
        // Vérification de la censure (mots bannis)
        if (this.chatModerationService.censor(username) !== username) {
            throw new BadRequestException('validation.username_profanity');
        }

        const query: any = { username };
        if (excludeUid) query.firebaseUid = { $ne: excludeUid };

        const user = await this.userModel.findOne(query);
        if (user) throw new ConflictException("Ce nom d'utilisateur est déjà utilisé");
    }

    async checkEmail(email: string, excludeUid?: string): Promise<void> {
        const query: any = { email };
        if (excludeUid) query.firebaseUid = { $ne: excludeUid };

        const user = await this.userModel.findOne(query);
        if (user) throw new ConflictException('Cet email est déjà utilisé');
    }

    getStatistics(user: UserDocument) {
        const stats = user.statistics;
        const totalGamesPlayed = stats.classicGamesPlayed + stats.ctfGamesPlayed;
        const averagePlaytimePerGame = totalGamesPlayed > 0 ? Math.round(stats.totalPlaytime / totalGamesPlayed) : 0;

        return {
            classicGamesPlayed: stats.classicGamesPlayed,
            ctfGamesPlayed: stats.ctfGamesPlayed,
            totalGamesWon: stats.totalGamesWon,
            averagePlaytimePerGame,
        };
    }

    getLoginHistory(user: UserDocument) {
        return user.loginHistory.sort((a, b) => b.date.getTime() - a.date.getTime()).slice(0, 100);
    }

    getGameHistory(user: UserDocument) {
        return user.gameHistory.sort((a, b) => b.startDate.getTime() - a.startDate.getTime()).slice(0, 100);
    }

    async startGameHistory(uid: string, mode: 'Classique' | 'CTF'): Promise<{ startDate: string }> {
        const user = await this.getUserByUid(uid);

        const startDate = new Date();
        user.gameHistory.push({
            startDate,
            mode,
            hasWon: false,
            hasAbandoned: false,
        });

        await user.save();
        return { startDate: startDate.toISOString() };
    }

    async endGameHistory(uid: string, startDateIso: string, hasWon: boolean): Promise<void> {
        const user = await this.getUserByUid(uid);

        const startMs = new Date(startDateIso).getTime();
        const entry = user.gameHistory.find((g) => g.startDate.getTime() === startMs && !g.endDate);

        if (!entry) throw new NotFoundException("Entrée d'historique introuvable (ou déjà terminée)");

        entry.endDate = new Date();
        entry.hasWon = hasWon;
        entry.hasAbandoned = false;

        await user.save();
    }

    async abandonGameHistory(uid: string, startDateIso: string): Promise<void> {
        const user = await this.getUserByUid(uid);

        const startMs = new Date(startDateIso).getTime();
        const entry = user.gameHistory.find((g) => g.startDate.getTime() === startMs && !g.endDate);

        if (!entry) throw new NotFoundException("Entrée d'historique introuvable (ou déjà terminée)");

        entry.endDate = new Date();
        entry.hasAbandoned = true;
        entry.hasWon = false;

        await user.save();
    }

    async getVirtualCurrency(firebaseUid: string): Promise<number> {
        const user = await this.getUserByUid(firebaseUid);
        return user.virtualCurrency ?? 0;
    }

    async updateVirtualCurrency(firebaseUid: string, delta: number): Promise<number> {
        const user = await this.getUserByUid(firebaseUid);
        user.virtualCurrency = (user.virtualCurrency ?? 0) + delta;
        if (user.virtualCurrency < 0) user.virtualCurrency = 0;
        await user.save();
        return user.virtualCurrency;
    }

    async getPurchasedItems(firebaseUid: string): Promise<string[]> {
        const user = await this.getUserByUid(firebaseUid);
        return user.purchasedItems ?? [];
    }

    async purchaseItem(firebaseUid: string, itemId: string): Promise<{ newBalance: number; purchasedItems: string[] }> {
        const item: ShopItem | undefined = SHOP_CATALOGUE.find((i) => i.id === itemId);
        if (!item) throw new Error('Article introuvable dans la boutique');

        const user = await this.getUserByUid(firebaseUid);
        if ((user.purchasedItems ?? []).includes(itemId)) throw new Error('Article déjà acheté');
        if ((user.virtualCurrency ?? 0) < item.price) throw new Error('Solde insuffisant');

        user.virtualCurrency -= item.price;
        user.purchasedItems = [...(user.purchasedItems ?? []), itemId];
        await user.save();
        return { newBalance: user.virtualCurrency, purchasedItems: user.purchasedItems };
    }

    async updateUserStatistics(
        firebaseUid: string,
        gameMode: 'Classique' | 'CTF',
        hasWon: boolean,
        playtimeSeconds: number,
        hasAbandoned: boolean = false,
    ): Promise<void> {
        const user = await this.getUserByUid(firebaseUid);

        if (gameMode === 'Classique') {
            user.statistics.classicGamesPlayed += 1;
        } else if (gameMode === 'CTF') {
            user.statistics.ctfGamesPlayed += 1;
        }

        if (hasWon) {
            user.statistics.totalGamesWon += 1;
        }

        user.statistics.totalPlaytime += playtimeSeconds;

        await user.save();
        this.logger.log(`Statistics updated for user ${firebaseUid}: ${gameMode} game, won: ${hasWon}, playtime: ${playtimeSeconds}s`);
    }
}

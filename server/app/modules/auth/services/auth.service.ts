/* eslint-disable @typescript-eslint/no-explicit-any */
import { RegisterUserDto, UpdateUserDto } from '@app/modules/auth/dto/auth.dto';
import { User, UserDocument } from '@app/modules/auth/schemas/user.schema';
import { FirebaseAdminService } from '@app/modules/auth/services/firebase-admin.service';
import { ConflictException, ForbiddenException, Injectable, Logger, NotFoundException, UnauthorizedException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { DecodedIdToken } from 'firebase-admin/auth';
import { Model } from 'mongoose';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class AuthService {
    private readonly logger = new Logger(AuthService.name);

    constructor(
        private readonly firebaseAdminService: FirebaseAdminService,
        @InjectModel(User.name) private readonly userModel: Model<UserDocument>,
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
            user.avatarId = updateDto.avatarId;
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
            // TODO: Cascade delete user when services are ready
            // -> Delete user from friends list
            // -> Replace username by "[supprimé]" in games and messages

            // 1. Delete user from Firebase Auth
            await this.firebaseAdminService.getAuth().deleteUser(uid);
            this.logger.log(`Firebase user deleted: ${uid}`);

            // 2. Delete user from MongoDB
            await this.userModel.deleteOne({ firebaseUid: uid });
            this.logger.log(`MongoDB user deleted: ${uid}`);
        } catch (error) {
            this.logger.error(`User deletion failed: ${error.message}`);
            throw error;
        }
    }

    async validateSession(uid: string, sessionId: string): Promise<boolean> {
        const user = await this.userModel.findOne({ firebaseUid: uid });
        return user?.currentSessionId === sessionId && user?.isOnline === true;
    }

    async checkUsername(username: string, excludeUid?: string): Promise<void> {
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

        user.gameHistory.push({
            startDate: new Date(Date.now() - playtimeSeconds * 1000),
            endDate: new Date(),
            mode: gameMode,
            hasWon,
            hasAbandoned,
        });

        await user.save();
        this.logger.log(`Statistics updated for user ${firebaseUid}: ${gameMode} game, won: ${hasWon}, playtime: ${playtimeSeconds}s`);
    }
}

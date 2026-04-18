import { CurrentUser } from '@app/modules/auth/decorators/current-user.decorator';
import { GetEmailByUsernameDto, LoginDto, RegisterUserDto, UpdateUserDto, VerifyTokenDto } from '@app/modules/auth/dto/auth.dto';
import { AuthGuard } from '@app/modules/auth/guards/auth.guard';
import { UserDocument } from '@app/modules/auth/schemas/user.schema';
import { AuthService } from '@app/modules/auth/services/auth.service';
import { GeneralChatGateway } from '@app/modules/general-chat/general-chat.gateway';
import { FriendshipService } from '@app/modules/social/services/friendship.service';
import {
    BadRequestException,
    Body,
    Controller,
    Delete,
    Get,
    HttpCode,
    HttpStatus,
    NotFoundException,
    Param,
    Patch,
    Post,
    Query,
    Res,
    UploadedFile,
    UseGuards,
    UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import type { Response } from 'express';

@Controller('auth')
export class AuthController {
    constructor(
        private readonly authService: AuthService,
        private readonly generalChatGateway: GeneralChatGateway,
        private readonly friendshipService: FriendshipService,
    ) {}

    // POST /auth/register
    @Post('register')
    async register(@Body() registerDto: RegisterUserDto) {
        const user = await this.authService.registerUser(registerDto);
        return {
            message: 'Compte créé avec succès',
            user: {
                id: user._id,
                email: user.email,
                username: user.username,
                avatarId: user.avatarId,
                avatarUrl: user.avatarUrl,
            },
        };
    }

    // POST /auth/login
    @Post('login')
    @HttpCode(HttpStatus.OK)
    async login(@Body() loginDto: LoginDto) {
        const decodedToken = await this.authService.verifyToken(loginDto.token);
        const { user, sessionId } = await this.authService.login(decodedToken);

        return {
            sessionId,
            user: {
                id: user._id,
                firebaseUid: user.firebaseUid,
                email: user.email,
                username: user.username,
                avatarId: user.avatarId,
                avatarUrl: user.avatarUrl,
            },
        };
    }

    // POST /auth/logout
    @Post('logout')
    @UseGuards(AuthGuard)
    @HttpCode(HttpStatus.OK)
    async logout(@CurrentUser('firebaseUid') uid: string) {
        await this.authService.logout(uid);
        return { message: 'Déconnexion réussie' };
    }

    // POST /auth/verify
    @Post('verify')
    @HttpCode(HttpStatus.OK)
    async verifyToken(@Body() verifyDto: VerifyTokenDto) {
        const decodedToken = await this.authService.verifyToken(verifyDto.token);
        return {
            valid: true,
            uid: decodedToken.uid,
            email: decodedToken.email,
        };
    }

    // POST /auth/get-email-by-username
    @Post('get-email-by-username')
    @HttpCode(HttpStatus.OK)
    async getEmailByUsername(@Body() dto: GetEmailByUsernameDto) {
        const email = await this.authService.getEmailByUsername(dto.username);
        return { email };
    }

    // GET /auth/profile
    @Get('profile')
    @UseGuards(AuthGuard)
    getProfile(@CurrentUser() user: UserDocument) {
        return {
            id: user._id,
            firebaseUid: user.firebaseUid,
            email: user.email,
            username: user.username,
            avatarId: user.avatarId,
            avatarUrl: user.avatarUrl,
            theme: user.theme ?? 'default',
            language: user.language ?? 'fr',
            preferences: user.preferences,
        };
    }

    // PATCH /auth/profile
    @Patch('profile')
    @UseGuards(AuthGuard)
    async updateProfile(@CurrentUser('firebaseUid') uid: string, @Body() updateDto: UpdateUserDto) {
        const previous = await this.authService.getUserByUid(uid);
        const oldUsername = previous.username;
        const user = await this.authService.updateUser(uid, updateDto);
        if (updateDto.avatarId) {
            this.generalChatGateway.broadcastAvatarUpdate({
                username: user.username,
                avatarId: user.avatarId ?? null,
                avatarUrl: user.avatarUrl ?? null,
            });
        }
        if (user.username !== oldUsername) {
            await this.generalChatGateway.handleUsernameUpdate(oldUsername, user.username);
            await this.friendshipService.renameUser(oldUsername, user.username);
        }
        return {
            message: 'Profil mis à jour',
            user: {
                id: user._id,
                firebaseUid: user.firebaseUid,
                username: user.username,
                email: user.email,
                avatarId: user.avatarId,
                avatarUrl: user.avatarUrl,
                theme: user.theme ?? 'default',
                language: user.language ?? 'fr',
                preferences: user.preferences,
            },
        };
    }

    // GET /auth/statistics
    @Get('statistics')
    @UseGuards(AuthGuard)
    getStatistics(@CurrentUser() user: UserDocument) {
        return this.authService.getStatistics(user);
    }

    // GET /auth/history/logins
    @Get('history/logins')
    @UseGuards(AuthGuard)
    getLoginHistory(@CurrentUser() user: UserDocument) {
        return this.authService.getLoginHistory(user);
    }

    // GET /auth/history/games
    @Get('history/games')
    @UseGuards(AuthGuard)
    getGameHistory(@CurrentUser() user: UserDocument) {
        return this.authService.getGameHistory(user);
    }

    // DELETE /auth/account
    @Delete('account')
    @UseGuards(AuthGuard)
    @HttpCode(HttpStatus.NO_CONTENT)
    async deleteAccount(@CurrentUser() user: UserDocument) {
        await this.generalChatGateway.forceDisconnectUser(user.username);
        await this.authService.deleteUser(user.firebaseUid);
    }

    // POST /auth/history/games/start
    @Post('history/games/start')
    @UseGuards(AuthGuard)
    @HttpCode(HttpStatus.OK)
    async startGameHistory(@CurrentUser('firebaseUid') uid: string, @Body() body: { mode: 'Classique' | 'CTF' }) {
        return await this.authService.startGameHistory(uid, body.mode);
    }

    // POST /auth/history/games/end
    @Post('history/games/end')
    @UseGuards(AuthGuard)
    @HttpCode(HttpStatus.NO_CONTENT)
    async endGameHistory(@CurrentUser('firebaseUid') uid: string, @Body() body: { startDate: string; hasWon: boolean }) {
        await this.authService.endGameHistory(uid, body.startDate, body.hasWon);
    }

    // POST /auth/history/games/abandon
    @Post('history/games/abandon')
    @UseGuards(AuthGuard)
    @HttpCode(HttpStatus.NO_CONTENT)
    async abandonGameHistory(@CurrentUser('firebaseUid') uid: string, @Body() body: { startDate: string }) {
        await this.authService.abandonGameHistory(uid, body.startDate);
    }

    // POST /auth/avatar
    @Post('avatar')
    @UseGuards(AuthGuard)
    @UseInterceptors(
        FileInterceptor('file', {
            limits: { fileSize: 2 * 1024 * 1024 },
            fileFilter: (req, file, cb) => {
                const allowedMimeTypes = ['image/jpeg', 'image/png'];
                if (!allowedMimeTypes.includes(file.mimetype)) {
                    return cb(new BadRequestException('Formats acceptés : JPG, JPEG, PNG. GIF refusé.'), false);
                }
                cb(null, true);
            },
        }),
    )
    async uploadAvatar(@CurrentUser('firebaseUid') uid: string, @UploadedFile() file: Express.Multer.File) {
        if (!file) {
            throw new BadRequestException('Aucun fichier reçu');
        }

        const user = await this.authService.updateAvatarFromFile(uid, file);
        this.generalChatGateway.broadcastAvatarUpdate({
            username: user.username,
            avatarId: user.avatarId ?? null,
            avatarUrl: user.avatarUrl ?? null,
        });

        return {
            message: 'Avatar mis à jour',
            user: {
                id: user._id,
                firebaseUid: user.firebaseUid,
                email: user.email,
                username: user.username,
                avatarId: user.avatarId,
                avatarUrl: user.avatarUrl,
                theme: user.theme ?? 'default',
                language: user.language ?? 'fr',
                preferences: user.preferences,
            },
        };
    }

    // POST /auth/avatars/batch
    @Post('avatars/batch')
    @HttpCode(HttpStatus.OK)
    async getAvatarsBatch(@Body() body: { usernames: string[] }) {
        return this.authService.getAvatarsForUsernames(body?.usernames ?? []);
    }

    // GET /auth/avatar/:uid
    @Get('avatar/:uid')
    async getAvatar(@Param('uid') uid: string, @Query('v') requestedVersion: string | undefined, @Res() res: Response) {
        const user = await this.authService.getUserByUid(uid);

        if (!user.avatarImageBuffer || !user.avatarImageMimeType) {
            throw new NotFoundException('Avatar introuvable pour cet utilisateur');
        }

        if (requestedVersion && user.avatarVersion && requestedVersion !== user.avatarVersion) {
            throw new NotFoundException('Version d’avatar obsolète');
        }

        res.setHeader('Content-Type', user.avatarImageMimeType);
        res.setHeader('Cache-Control', requestedVersion ? 'public, max-age=31536000, immutable' : 'no-cache');
        return res.send(user.avatarImageBuffer);
    }
}

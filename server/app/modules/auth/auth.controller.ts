import { Controller, Post, Get, Patch, Delete, Body, UseGuards, HttpCode, HttpStatus } from '@nestjs/common';
import { AuthService } from '@app/modules/auth/services/auth.service';
import { AuthGuard } from '@app/modules/auth/guards/auth.guard';
import { CurrentUser } from '@app/modules/auth/decorators/current-user.decorator';
import { RegisterUserDto, VerifyTokenDto, UpdateUserDto, LoginDto } from '@app/modules/auth/dto/auth.dto';
import { UserDocument } from '@app/modules/auth/schemas/user.schema';

@Controller('auth')
export class AuthController {
    constructor(private readonly authService: AuthService) {}

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

    // GET /auth/profile
    @Get('profile')
    @UseGuards(AuthGuard)
    getProfile(@CurrentUser() user: UserDocument) {
        return {
            id: user._id,
            email: user.email,
            username: user.username,
            avatarId: user.avatarId,
            preferences: user.preferences,
        };
    }

    // PATCH /auth/profile
    @Patch('profile')
    @UseGuards(AuthGuard)
    async updateProfile(@CurrentUser('firebaseUid') uid: string, @Body() updateDto: UpdateUserDto) {
        const user = await this.authService.updateUser(uid, updateDto);
        return {
            message: 'Profil mis à jour',
            user: {
                username: user.username,
                email: user.email,
                avatarId: user.avatarId,
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
    async deleteAccount(@CurrentUser('firebaseUid') uid: string) {
        await this.authService.deleteUser(uid);
    }
}

/* eslint-disable @typescript-eslint/no-explicit-any */
import { Injectable, CanActivate, ExecutionContext, UnauthorizedException } from '@nestjs/common';
import { AuthService } from '@app/modules/auth/services/auth.service';

@Injectable()
export class AuthGuard implements CanActivate {
    constructor(private readonly authService: AuthService) {}

    async canActivate(context: ExecutionContext): Promise<boolean> {
        const request = context.switchToHttp().getRequest();
        const token = this.extractTokenFromHeader(request);
        const sessionId = request.headers['x-session-id'];

        if (!token) {
            throw new UnauthorizedException('Token manquant');
        }

        if (!sessionId) {
            throw new UnauthorizedException('Session ID manquant');
        }

        try {
            const decodedToken = await this.authService.verifyToken(token);

            const isSessionValid = await this.authService.validateSession(decodedToken.uid, sessionId);

            if (!isSessionValid) {
                throw new UnauthorizedException('Session invalide ou expirée');
            }

            const user = await this.authService.getUserByUid(decodedToken.uid);
            request.user = user;
            request.firebaseUser = decodedToken;

            return true;
        } catch (error) {
            throw new UnauthorizedException('Authentification invalide');
        }
    }

    private extractTokenFromHeader(request: any): string | undefined {
        const authHeader = request.headers.authorization;
        if (!authHeader) return undefined;

        const [type, token] = authHeader.split(' ');
        return type === 'Bearer' ? token : undefined;
    }
}

import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Auth, onAuthStateChanged, signInWithEmailAndPassword, signOut } from '@angular/fire/auth';
import { ProfileService } from '@app/services/communication/profile.service';
import { SocketService } from '@app/services/communication/socket-handlers/socket.service';
import { LanguageService } from '@app/services/state/language.service';
import { SessionService } from '@app/services/state/session.service';
import { ThemeService } from '@app/services/state/theme.service';
import { firstValueFrom } from 'rxjs';
import { environment } from 'src/environments/environment';

interface RegisterPayload {
    username: string;
    email: string;
    password: string;
    avatarId: string | null;
}

type LoginResponse = {
    sessionId: string;
    user: {
        id: string;
        firebaseUid: string;
        email: string;
        username: string;
        avatarId: string;
        avatarUrl?: string | null;
    };
};

@Injectable({ providedIn: 'root' })
export class AuthService {
    private apiUrl = `${environment.serverUrl}/auth`;
    constructor(
        private http: HttpClient,
        private auth: Auth,
        private session: SessionService,
        private socketService: SocketService,
        private profileService: ProfileService,
        private themeService: ThemeService,
        private languageService: LanguageService,
    ) {}

    get currentUser() {
        return this.auth.currentUser;
    }

    async register(payload: RegisterPayload): Promise<LoginResponse> {
        await firstValueFrom(this.http.post(`${this.apiUrl}/register`, payload));

        await signInWithEmailAndPassword(this.auth, payload.email, payload.password);

        return await this.loginServerSession();
    }

    async login(email: string, password: string): Promise<LoginResponse> {
        await signInWithEmailAndPassword(this.auth, email, password);

        return await this.loginServerSession();
    }

    async loginByUsername(username: string, password: string): Promise<LoginResponse> {
        // 1. Get email from username via backend
        const { email } = await firstValueFrom(this.http.post<{ email: string }>(`${this.apiUrl}/get-email-by-username`, { username }));

        // 2. Login with Firebase using the email
        await signInWithEmailAndPassword(this.auth, email, password);

        return await this.loginServerSession();
    }

    async logout(): Promise<void> {
        try {
            const user = this.auth.currentUser;
            const sessionId = this.session.sessionId;

            if (user && sessionId) {
                const token = await user.getIdToken();
                const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`).set('x-session-id', sessionId);

                await firstValueFrom(this.http.post(`${this.apiUrl}/logout`, {}, { headers }));
            }
            this.socketService.disconnect();
        } finally {
            this.profileService.invalidateCache();
            this.themeService.setTheme('default');
            this.languageService.resetToDefault();
            this.session.clear();
            await signOut(this.auth);
        }
    }

    async isAuthenticatedAsync(): Promise<boolean> {
        // Wait for Firebase to confirm the current user state
        await this.ensureAuthReady();
        return this.isAuthenticatedSync();
    }

    isAuthenticatedSync(): boolean {
        return this.auth.currentUser !== null && this.session.sessionId !== null;
    }

    private async ensureAuthReady(): Promise<void> {
        return new Promise((resolve) => {
            // Unsubscribe immediately after getting the first state
            const unsub = onAuthStateChanged(this.auth, () => {
                unsub();
                resolve();
            });
        });
    }

    private async loginServerSession(): Promise<LoginResponse> {
        const token = await this.getIdTokenOrThrow();

        const res = await firstValueFrom(this.http.post<LoginResponse>(`${this.apiUrl}/login`, { token }));

        this.session.sessionId = res.sessionId;
        return res;
    }

    private async getIdTokenOrThrow(): Promise<string> {
        const user = this.auth.currentUser;
        if (!user) throw new Error('Utilisateur Firebase introuvable (pas connecté)');
        return await user.getIdToken();
    }
}

import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Auth, onAuthStateChanged, signInWithEmailAndPassword, signOut } from '@angular/fire/auth';
import { environment } from 'src/environments/environment';
import { firstValueFrom } from 'rxjs';
import { SessionService } from '@app/services/state/session.service';

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
    };
};

@Injectable({ providedIn: 'root' })
export class AuthService {
    private apiUrl = `${environment.serverUrl}/auth`;
    private readyPromise: Promise<void>;
    constructor(
        private http: HttpClient,
        private auth: Auth,
        private session: SessionService,
    ) {
        this.readyPromise = new Promise<void>((resolve) => {
            const unsub = onAuthStateChanged(this.auth, (user) => {
                if (!user) this.session.clear();

                unsub();
                resolve();
            });
        });
    }

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

    async logout(): Promise<void> {
        try {
            const user = this.auth.currentUser;
            const sessionId = this.session.sessionId;

            if (user && sessionId) {
                const token = await user.getIdToken();
                const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`).set('x-session-id', sessionId);

                await firstValueFrom(this.http.post(`${this.apiUrl}/logout`, {}, { headers }));
            }
        } finally {
            this.session.clear();
            await signOut(this.auth);
        }
    }

    async isAuthenticatedAsync(): Promise<boolean> {
        await this.readyPromise;
        return this.isAuthenticatedSync();
    }

    isAuthenticatedSync(): boolean {
        return this.auth.currentUser !== null && this.session.sessionId !== null;
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

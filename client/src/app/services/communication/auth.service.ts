import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Auth, signInWithEmailAndPassword } from '@angular/fire/auth';
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

    constructor(
        private http: HttpClient,
        private auth: Auth,
        private session: SessionService,
    ) {}

    async register(payload: RegisterPayload): Promise<LoginResponse> {
        await firstValueFrom(this.http.post(`${this.apiUrl}/register`, payload));

        await signInWithEmailAndPassword(this.auth, payload.email, payload.password);

        return await this.loginServerSession();
    }

    async login(email: string, password: string): Promise<LoginResponse> {
        await signInWithEmailAndPassword(this.auth, email, password);

        return await this.loginServerSession();
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

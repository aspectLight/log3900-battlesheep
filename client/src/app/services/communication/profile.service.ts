import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Auth } from '@angular/fire/auth';
import { UpdateProfilePayload, UserProfile, UserStatistics } from '@app/interfaces/profile.interface';
import { SessionService } from '@app/services/state/session.service';
import { firstValueFrom } from 'rxjs';
import { environment } from 'src/environments/environment';

@Injectable({ providedIn: 'root' })
export class ProfileService {
    private apiUrl = `${environment.serverUrl}/auth`;

    constructor(
        private http: HttpClient,
        private auth: Auth,
        private session: SessionService,
    ) {}

    async getProfile(): Promise<UserProfile> {
        const headers = await this.getAuthHeaders();
        return await firstValueFrom(this.http.get<UserProfile>(`${this.apiUrl}/profile`, { headers }));
    }

    async updateProfile(payload: UpdateProfilePayload): Promise<UserProfile> {
        const headers = await this.getAuthHeaders();
        const response = await firstValueFrom(
            this.http.patch<{ message: string; user: UserProfile }>(`${this.apiUrl}/profile`, payload, { headers }),
        );
        return response.user;
    }

    buildUpdatePayload(currentProfile: UserProfile, formValues: { username: string; email: string; avatarId: string }): UpdateProfilePayload {
        const updatePayload: UpdateProfilePayload = {};

        if (formValues.username !== currentProfile.username) {
            updatePayload.username = formValues.username;
        }
        if (formValues.email !== currentProfile.email) {
            updatePayload.email = formValues.email;
        }
        if (formValues.avatarId !== currentProfile.avatarId) {
            updatePayload.avatarId = formValues.avatarId;
        }

        return updatePayload;
    }

    extractErrorMessage(error: unknown): string {
        const httpError = error as { error?: { message?: string }; message?: string };
        if (httpError?.error?.message) {
            return httpError.error.message;
        }
        if (httpError?.message) {
            return httpError.message;
        }
        return 'Erreur lors de la mise à jour du profil';
    }

    async loadProfileAndStatistics(): Promise<{ profile: UserProfile; statistics: UserStatistics }> {
        const [profile, statistics] = await Promise.all([this.getProfile(), this.getStatistics()]);
        return { profile, statistics };
    }

    async submitProfileUpdate(
        currentProfile: UserProfile,
        formValues: { username: string; email: string; avatarId: string },
    ): Promise<{ success: boolean; updatedProfile?: UserProfile; error?: string }> {
        const updatePayload = this.buildUpdatePayload(currentProfile, formValues);

        if (Object.keys(updatePayload).length === 0) {
            return { success: false, error: 'Aucune modification détectée' };
        }

        try {
            const updatedProfile = await this.updateProfile(updatePayload);
            return { success: true, updatedProfile };
        } catch (error: unknown) {
            return { success: false, error: this.extractErrorMessage(error) };
        }
    }

    getDefaultErrorMessage(): string {
        return 'Erreur lors du chargement du profil';
    }

    async getStatistics(): Promise<UserStatistics> {
        const headers = await this.getAuthHeaders();
        return await firstValueFrom(this.http.get<UserStatistics>(`${this.apiUrl}/statistics`, { headers }));
    }

    private async getAuthHeaders(): Promise<HttpHeaders> {
        const user = this.auth.currentUser;
        const sessionId = this.session.sessionId;

        if (!user || !sessionId) {
            throw new Error('Utilisateur non authentifié');
        }

        const token = await user.getIdToken();
        return new HttpHeaders().set('Authorization', `Bearer ${token}`).set('x-session-id', sessionId);
    }
}

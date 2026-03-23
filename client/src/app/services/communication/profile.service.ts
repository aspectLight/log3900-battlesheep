import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Auth } from '@angular/fire/auth';
import { UpdateProfilePayload, UserProfile, UserStatistics } from '@app/interfaces/profile.interface';
import { LanguageService } from '@app/services/state/language.service';
import { SessionService } from '@app/services/state/session.service';
import { ThemeService } from '@app/services/state/theme.service';
import { firstValueFrom } from 'rxjs';
import { environment } from 'src/environments/environment';

@Injectable({ providedIn: 'root' })
export class ProfileService {
    private apiUrl = `${environment.serverUrl}/auth`;

    /** Cache en mémoire du profil — invalidé à la déconnexion */
    private cachedProfile: UserProfile | null = null;

    constructor(
        private http: HttpClient,
        private auth: Auth,
        private session: SessionService,
        private themeService: ThemeService,
        private languageService: LanguageService,
    ) {}

    /**
     * Retourne le profil depuis le cache ou le backend.
     * Applique automatiquement le thème du compte au premier appel.
     */
    async getProfile(): Promise<UserProfile> {
        if (!this.cachedProfile) {
            const headers = await this.getAuthHeaders();
            this.cachedProfile = await firstValueFrom(this.http.get<UserProfile>(`${this.apiUrl}/profile`, { headers }));
            this.themeService.applyFromProfile(this.cachedProfile.theme);
            this.languageService.applyFromProfile(this.cachedProfile.language);
        }
        return this.cachedProfile;
    }

    /** Charge le profil et applique le thème (idempotent grâce au cache). */
    async loadAndApplyTheme(): Promise<void> {
        await this.getProfile();
    }

    /** Invalide le cache (à appeler lors de la déconnexion). */
    invalidateCache(): void {
        this.cachedProfile = null;
    }

    async updateProfile(payload: UpdateProfilePayload): Promise<UserProfile> {
        const headers = await this.getAuthHeaders();
        const response = await firstValueFrom(
            this.http.patch<{ message: string; user: UserProfile }>(`${this.apiUrl}/profile`, payload, { headers }),
        );
        // Met à jour le cache local
        this.cachedProfile = response.user;
        return response.user;
    }

    async uploadAvatar(file: File): Promise<UserProfile> {
        const headers = await this.getAuthHeaders();
        const formData = new FormData();
        formData.append('file', file);

        const response = await firstValueFrom(
            this.http.post<{ message: string; user: UserProfile }>(`${this.apiUrl}/avatar`, formData, {
                headers,
            }),
        );

        return response.user;
    }

    buildUpdatePayload(
        currentProfile: UserProfile,
        formValues: { username: string; email: string; avatarId: string; theme?: string; language?: string },
    ): UpdateProfilePayload {
        const updatePayload: UpdateProfilePayload = {};

        if (formValues.username !== currentProfile.username) {
            updatePayload.username = formValues.username;
        }
        if (formValues.email !== currentProfile.email) {
            updatePayload.email = formValues.email;
        }
        if (formValues.avatarId && formValues.avatarId !== currentProfile.avatarId) {
            updatePayload.avatarId = formValues.avatarId;
        }
        if (formValues.theme !== undefined && formValues.theme !== currentProfile.theme) {
            updatePayload.theme = formValues.theme;
        }

        if (formValues.language !== undefined && formValues.language !== currentProfile.language) { // ← ajouter
            updatePayload.language = formValues.language;
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
        formValues: { username: string; email: string; avatarId: string; theme?: string; language?: string },
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

    async deleteAccount(): Promise<{ success: boolean; error?: string }> {
        const headers = await this.getAuthHeaders();
        try {
            await firstValueFrom(this.http.delete(`${this.apiUrl}/account`, { headers }));
            return { success: true };
        } catch (error: unknown) {
            return { success: false, error: this.extractErrorMessage(error) };
        }
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

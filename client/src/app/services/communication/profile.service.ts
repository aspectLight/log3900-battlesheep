import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Auth } from '@angular/fire/auth';
import { UpdateProfilePayload, UserProfile, UserStatistics } from '@app/interfaces/profile.interface';
import { LanguageService } from '@app/services/state/language.service';
import { SessionService } from '@app/services/state/session.service';
import { ThemeService } from '@app/services/state/theme.service';
import { Observable, Subject, firstValueFrom } from 'rxjs';
import { environment } from 'src/environments/environment';

@Injectable({ providedIn: 'root' })
export class ProfileService {
    private apiUrl = `${environment.serverUrl}/auth`;

    // In-memory profile cache. Cleared at logout.
    private cachedProfile: UserProfile | null = null;

    private readonly profileUpdatedSubject = new Subject<UserProfile>();
    readonly profileUpdated$: Observable<UserProfile> = this.profileUpdatedSubject.asObservable();

    private readonly profileErrorKeyMap: Record<string, string> = {
        'Erreur lors de la mise � jour du profil': 'profile.errors.update_profile',
        'Erreur lors du chargement du profil': 'profile.errors.load_profile',
        'Utilisateur non authentifi�': 'profile.errors.unauthenticated',
    };

    constructor(
        private http: HttpClient,
        private auth: Auth,
        private session: SessionService,
        private themeService: ThemeService,
        private languageService: LanguageService,
    ) {}

    // Returns the profile from cache or backend and applies account theme/language on first fetch.
    async getProfile(): Promise<UserProfile> {
        if (!this.cachedProfile) {
            const headers = await this.getAuthHeaders();
            this.cachedProfile = await firstValueFrom(this.http.get<UserProfile>(`${this.apiUrl}/profile`, { headers }));
            this.themeService.applyFromProfile(this.cachedProfile.theme);
            this.languageService.applyFromProfile(this.cachedProfile.language);
        }
        return this.cachedProfile;
    }

    async loadAndApplyTheme(): Promise<void> {
        await this.getProfile();
    }

    invalidateCache(): void {
        this.cachedProfile = null;
    }

    async updateProfile(payload: UpdateProfilePayload): Promise<UserProfile> {
        const headers = await this.getAuthHeaders();
        const response = await firstValueFrom(
            this.http.patch<{ message: string; user: UserProfile }>(`${this.apiUrl}/profile`, payload, { headers }),
        );
        this.cachedProfile = response.user;
        this.profileUpdatedSubject.next(response.user);
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

        this.cachedProfile = response.user;
        this.profileUpdatedSubject.next(response.user);
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
        if (formValues.language !== undefined && formValues.language !== currentProfile.language) {
            updatePayload.language = formValues.language;
        }

        return updatePayload;
    }

    extractErrorMessage(error: unknown): string {
        const httpError = error as { error?: { message?: string }; message?: string };
        if (httpError?.error?.message) {
            return this.toProfileErrorKey(httpError.error.message);
        }
        if (httpError?.message) {
            return this.toProfileErrorKey(httpError.message);
        }
        return 'profile.errors.update_profile';
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
            return { success: false, error: 'profile.no_changes' };
        }

        try {
            const updatedProfile = await this.updateProfile(updatePayload);
            return { success: true, updatedProfile };
        } catch (error: unknown) {
            return { success: false, error: this.extractErrorMessage(error) };
        }
    }

    getDefaultErrorMessage(): string {
        return 'profile.errors.load_profile';
    }

    async getStatistics(): Promise<UserStatistics> {
        const headers = await this.getAuthHeaders();
        return await firstValueFrom(this.http.get<UserStatistics>(`${this.apiUrl}/statistics`, { headers }));
    }

    async deleteAccount(): Promise<{ success: boolean; error?: string }> {
        const headers = await this.getAuthHeaders();
        try {
            await firstValueFrom(this.http.delete(`${this.apiUrl}/account`, { headers }));
            this.invalidateCache();
            return { success: true };
        } catch (error: unknown) {
            return { success: false, error: this.extractErrorMessage(error) };
        }
    }

    private async getAuthHeaders(): Promise<HttpHeaders> {
        const user = this.auth.currentUser;
        const sessionId = this.session.sessionId;

        if (!user || !sessionId) {
            throw new Error('profile.errors.unauthenticated');
        }

        const token = await user.getIdToken();
        return new HttpHeaders().set('Authorization', `Bearer ${token}`).set('x-session-id', sessionId);
    }

    private toProfileErrorKey(message: string): string {
        return this.profileErrorKeyMap[message] ?? message;
    }
}
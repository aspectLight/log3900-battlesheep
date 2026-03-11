import { Component, OnInit, inject } from '@angular/core';
import { Auth, signOut } from '@angular/fire/auth';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { PopUpComponent } from '@app/components/shared/pop-up/pop-up.component';
import { ACCOUNT_CREATION_AVATARS } from '@app/constants/profile.constants';
import { ROUTES } from '@app/constants/routes.constants';
import { UserProfile, UserStatistics } from '@app/interfaces/profile.interface';
import { ProfileService } from '@app/services/communication/profile.service';
import { SocketService } from '@app/services/communication/socket-handlers/socket.service';
import { StatsService } from '@app/services/communication/stats.service';
import { SessionService } from '@app/services/state/session.service';
import { environment } from 'src/environments/environment';

@Component({
    selector: 'app-profile-page',
    templateUrl: './profile-page.component.html',
    styleUrls: ['./profile-page.component.scss'],
    imports: [ReactiveFormsModule, RouterLink, PopUpComponent],
})
export class ProfilePageComponent implements OnInit {
    avatars = ACCOUNT_CREATION_AVATARS;

    profile: UserProfile | null = null;
    statistics: UserStatistics | null = null;
    isLoading = true;
    isSaving = false;
    isDeleting = false;
    showSuccessMessage = false;
    showErrorMessage = false;
    showDeleteConfirm = false;
    errorMessage = '';

    selectedAvatarFile: File | null = null;
    avatarFileError: string | null = null;
    avatarPreviewUrl: string | null = null;

    form = inject(FormBuilder).nonNullable.group({
        username: ['', [Validators.required, Validators.pattern(/^[a-zA-Z0-9]+$/)]],
        email: ['', [Validators.required, Validators.email, Validators.pattern(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/)]],
        avatarId: [''],
    });

    private profileService = inject(ProfileService);
    private statsService = inject(StatsService);
    private socketService = inject(SocketService);
    private session = inject(SessionService);
    private auth = inject(Auth);
    private router = inject(Router);

    get selectedAvatarId(): string {
        return this.form.controls.avatarId.value ?? '';
    }

    get currentAvatarSrc(): string {
        if (this.profile?.avatarUrl) {
            return `${environment.serverUrl}${this.profile.avatarUrl}`;
        }
        const found = this.avatars.find((a) => a.id === this.profile?.avatarId);
        return found?.image ?? '';
    }

    onAvatarFileSelected(event: Event) {
        const input = event.target as HTMLInputElement;
        const file = input.files?.[0] ?? null;
        this.avatarFileError = null;
        this.selectedAvatarFile = null;
        this.avatarPreviewUrl = null;

        if (!file) return;

        const maxSize = 2 * 1024 * 1024;
        const validTypes = ['image/jpeg', 'image/png'];

        if (!validTypes.includes(file.type)) {
            const extension = file.name.split('.').pop()?.toLowerCase() ?? 'inconnu';
            this.avatarFileError = `Fichier de type "${extension}" non autorisé. Formats permis : JPG, JPEG, PNG (taille maximale 2 MB).`;
            return;
        }

        if (file.size > maxSize) {
            const sizeMb = file.size / (1024 * 1024);
            this.avatarFileError = `Fichier trop volumineux (${sizeMb.toFixed(2)} MB). Taille maximale autorisée : 2 MB.`;
            return;
        }

        this.selectedAvatarFile = file;
        this.form.controls.avatarId.setValue('');

        const reader = new FileReader();
        reader.onload = (e) => {
            this.avatarPreviewUrl = e.target?.result as string;
        };
        reader.readAsDataURL(file);
    }

    async ngOnInit() {
        await this.loadProfile();
    }

    async loadProfile() {
        try {
            const { profile, statistics } = await this.profileService.loadProfileAndStatistics();
            this.profile = profile;
            this.statistics = statistics;
            this.form.patchValue({
                username: profile.username,
                email: profile.email,
                avatarId: profile.avatarId,
            });
            if (profile.avatarUrl) {
                this.avatarPreviewUrl = `${environment.serverUrl}${profile.avatarUrl}?t=${Date.now()}`;
                this.form.controls.avatarId.setValue('');
            }
        } catch (error) {
            this.showError(this.profileService.getDefaultErrorMessage());
        } finally {
            this.isLoading = false;
        }
    }

    selectAvatar(id: string) {
        this.selectedAvatarFile = null;
        this.avatarPreviewUrl = null;
        this.avatarFileError = null;
        this.form.controls.avatarId.setValue(id);
        this.form.controls.avatarId.markAsTouched();
    }

    async submitForm() {
        this.form.markAllAsTouched();

        const hasAvatarSelected = !!this.form.controls.avatarId.value || !!this.selectedAvatarFile || !!this.profile?.avatarUrl;
        if (this.form.invalid || !this.profile || !hasAvatarSelected) {
            return;
        }

        this.isSaving = true;
        this.showErrorMessage = false;
        this.showSuccessMessage = false;

        const formValues = this.form.getRawValue();

        const updatePayload = this.profileService.buildUpdatePayload(this.profile, formValues);
        const hasProfileChanges = Object.keys(updatePayload).length > 0;
        const hasAvatarFile = !!this.selectedAvatarFile;

        if (!hasProfileChanges && !hasAvatarFile) {
            this.showError('Aucune modification détectée');
            this.isSaving = false;
            return;
        }

        try {
            if (hasProfileChanges) {
                const updatedProfile = await this.profileService.updateProfile(updatePayload);
                this.profile = updatedProfile;
                if (!updatedProfile.avatarUrl) {
                    this.avatarPreviewUrl = null;
                }
            }

            if (hasAvatarFile && this.selectedAvatarFile) {
                const updatedProfileWithAvatar = await this.profileService.uploadAvatar(this.selectedAvatarFile);
                this.profile = updatedProfileWithAvatar;
                this.selectedAvatarFile = null;
                this.form.controls.avatarId.setValue('');
                if (updatedProfileWithAvatar.avatarUrl) {
                    this.avatarPreviewUrl = `${environment.serverUrl}${updatedProfileWithAvatar.avatarUrl}?t=${Date.now()}`;
                }
            }

            this.showSuccessMessage = true;
            setTimeout(() => {
                this.showSuccessMessage = false;
            }, 3000);
        } catch (error: unknown) {
            this.showError(this.profileService.extractErrorMessage(error));
        } finally {
            this.isSaving = false;
        }
    }

    showError(message: string) {
        this.errorMessage = message;
        this.showErrorMessage = true;
    }

    onErrorConfirm() {
        this.showErrorMessage = false;
    }

    onSuccessConfirm() {
        this.showSuccessMessage = false;
    }

    formatTime(seconds: number): string {
        return this.statsService.formatTime(seconds);
    }

    deleteAccount() {
        this.showDeleteConfirm = true;
    }

    onDeleteCancel() {
        this.showDeleteConfirm = false;
    }

    async onDeleteConfirm() {
        this.showDeleteConfirm = false;
        this.isDeleting = true;
        this.showErrorMessage = false;

        const result = await this.profileService.deleteAccount();

        if (result.success) {
            this.socketService.disconnect();
            this.session.clear();
            await signOut(this.auth);
            this.router.navigate([ROUTES.signin]);
        } else if (result.error) {
            this.showError(result.error);
        }

        this.isDeleting = false;
    }
}

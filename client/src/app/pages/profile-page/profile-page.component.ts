import { Component, OnInit } from '@angular/core';
import { Auth, signOut } from '@angular/fire/auth';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { PopUpComponent } from '@app/components/shared/pop-up/pop-up.component';
import { ROUTES } from '@app/constants/routes.constants';
import { PROFILE_AVATARS } from '@app/constants/profile.constants';
import { UserProfile, UserStatistics } from '@app/interfaces/profile.interface';
import { SocketService } from '@app/services/communication/socket-handlers/socket.service';
import { ProfileService } from '@app/services/communication/profile.service';
import { StatsService } from '@app/services/communication/stats.service';
import { SessionService } from '@app/services/state/session.service';

@Component({
    selector: 'app-profile-page',
    templateUrl: './profile-page.component.html',
    styleUrls: ['./profile-page.component.scss'],
    imports: [ReactiveFormsModule, RouterLink, PopUpComponent],
})
export class ProfilePageComponent implements OnInit {
    avatars = PROFILE_AVATARS;

    profile: UserProfile | null = null;
    statistics: UserStatistics | null = null;
    isLoading = true;
    isSaving = false;
    isDeleting = false;
    showSuccessMessage = false;
    showErrorMessage = false;
    showDeleteConfirm = false;
    errorMessage = '';

    form = this.fb.nonNullable.group({
        username: ['', [Validators.required, Validators.pattern(/^[a-zA-Z0-9]+$/)]],
        email: ['', [Validators.required, Validators.email, Validators.pattern(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/)]],
        avatarId: ['', [Validators.required]],
    });

    constructor(
        private fb: FormBuilder,
        private profileService: ProfileService,
        private statsService: StatsService,
        private socketService: SocketService,
        private session: SessionService,
        private auth: Auth,
        private router: Router,
    ) {}

    get selectedAvatarId(): string {
        return this.form.controls.avatarId.value ?? '';
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
        } catch (error) {
            this.showError(this.profileService.getDefaultErrorMessage());
        } finally {
            this.isLoading = false;
        }
    }

    selectAvatar(id: string) {
        this.form.controls.avatarId.setValue(id);
        this.form.controls.avatarId.markAsTouched();
    }

    async submitForm() {
        this.form.markAllAsTouched();

        if (this.form.invalid || !this.profile) {
            return;
        }

        this.isSaving = true;
        this.showErrorMessage = false;
        this.showSuccessMessage = false;

        const formValues = this.form.getRawValue();
        const result = await this.profileService.submitProfileUpdate(this.profile, formValues);

        if (result.success && result.updatedProfile) {
            this.profile = result.updatedProfile;
            this.showSuccessMessage = true;
            setTimeout(() => {
                this.showSuccessMessage = false;
            }, 3000);
        } else if (result.error) {
            this.showError(result.error);
        }

        this.isSaving = false;
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

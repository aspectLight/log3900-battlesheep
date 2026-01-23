import { Component, OnInit } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { ProfileService, UserProfile, UserStatistics } from '@app/services/communication/profile.service';
import { StatsService } from '@app/services/communication/stats.service';

type AvatarOption = { id: string; label: string };

@Component({
    selector: 'app-profile-page',
    templateUrl: './profile-page.component.html',
    styleUrls: ['./profile-page.component.scss'],
    imports: [ReactiveFormsModule, RouterLink],
})
export class ProfilePageComponent implements OnInit {
    avatars: AvatarOption[] = [
        { id: 'avatar_01', label: 'Avatar 1' },
        { id: 'avatar_02', label: 'Avatar 2' },
        { id: 'avatar_03', label: 'Avatar 3' },
        { id: 'avatar_04', label: 'Avatar 4' },
        { id: 'avatar_05', label: 'Avatar 5' },
    ];

    profile: UserProfile | null = null;
    statistics: UserStatistics | null = null;
    isLoading = true;
    isSaving = false;
    showSuccessMessage = false;
    showErrorMessage = false;
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
        setTimeout(() => {
            this.showErrorMessage = false;
        }, 5000);
    }

    formatTime(seconds: number): string {
        return this.statsService.formatTime(seconds);
    }
}

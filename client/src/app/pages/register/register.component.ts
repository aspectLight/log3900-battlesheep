import { HttpErrorResponse } from '@angular/common/http';
import { Component } from '@angular/core';
import { AbstractControl, FormBuilder, ReactiveFormsModule, ValidationErrors, ValidatorFn, Validators } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { PROFILE_AVATARS } from '@app/constants/profile.constants';
import { AuthService } from '@app/services/communication/auth.service';
import { ProfileService } from '@app/services/communication/profile.service';

const passwordContainsLetter: ValidatorFn = (control: AbstractControl): ValidationErrors | null => {
    return /[a-zA-Z]/.test(control.value) ? null : { noLetter: true };
};

const passwordContainsDigit: ValidatorFn = (control: AbstractControl): ValidationErrors | null => {
    return /[0-9]/.test(control.value) ? null : { noDigit: true };
};

const passwordNoSpaces: ValidatorFn = (control: AbstractControl): ValidationErrors | null => {
    return /^\S*$/.test(control.value) ? null : { hasSpaces: true };
};

const passwordMatchValidator: ValidatorFn = (group: AbstractControl): ValidationErrors | null => {
    const password = group.get('password')?.value;
    const confirmPassword = group.get('confirmPassword')?.value;
    return password === confirmPassword ? null : { passwordMismatch: true };
};

@Component({
    selector: 'app-signup-page',
    standalone: true,
    imports: [ReactiveFormsModule, RouterLink],
    templateUrl: './register.component.html',
    styleUrl: './register.component.scss',
})
export class RegisterPageComponent {
    errorMessage: string | null = null;
    isSubmitting = false;
    showPassword = false;
    showConfirmPassword = false;

    avatars = PROFILE_AVATARS;

    selectedAvatarFile: File | null = null;
    avatarFileError: string | null = null;
    avatarPreviewUrl: string | null = null;

    form = this.fb.nonNullable.group(
        {
            username: ['', [Validators.required, Validators.minLength(3), Validators.maxLength(15), Validators.pattern(/^[a-zA-Z0-9]+$/)]],
            email: ['', [Validators.required, Validators.email, Validators.pattern(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/)]],
            password: ['', [Validators.required, Validators.minLength(8), passwordContainsLetter, passwordContainsDigit, passwordNoSpaces]],
            confirmPassword: ['', [Validators.required]],
            avatarId: ['', [Validators.required]],
        },
        { validators: passwordMatchValidator },
    );

    constructor(
        private fb: FormBuilder,
        private authService: AuthService,
        private profileService: ProfileService,
        private router: Router,
    ) {}

    get selectedAvatarId(): string {
        return this.form.controls.avatarId.value ?? '';
    }

    onAvatarFileSelected(event: Event) {
        const input = event.target as HTMLInputElement;
        const file = input.files?.[0] ?? null;
        this.avatarFileError = null;
        this.selectedAvatarFile = null;
        this.avatarPreviewUrl = null;

        if (!file) {
            if (!this.form.controls.avatarId.value || this.form.controls.avatarId.value === 'custom') {
                this.form.controls.avatarId.setValue('');
            }
            return;
        }

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

        const reader = new FileReader();
        reader.onload = (e) => {
            this.avatarPreviewUrl = e.target?.result as string;
        };
        reader.readAsDataURL(file);

        this.form.controls.avatarId.setValue('custom');
        this.form.controls.avatarId.markAsTouched();
    }

    selectAvatar(id: string) {
        this.selectedAvatarFile = null;
        this.avatarPreviewUrl = null;
        this.avatarFileError = null;
        this.form.controls.avatarId.setValue(id);
        this.form.controls.avatarId.markAsTouched();
    }

    togglePasswordVisibility() {
        this.showPassword = !this.showPassword;
    }

    toggleConfirmPasswordVisibility() {
        this.showConfirmPassword = !this.showConfirmPassword;
    }

    async submitForm() {
        this.errorMessage = null;
        this.form.markAllAsTouched();

        if (this.form.invalid) return;

        const { username, email, password, avatarId } = this.form.getRawValue();

        this.isSubmitting = true;
        try {
            const res = await this.authService.register({
                username,
                email,
                password,
                avatarId,
            });

            if (this.selectedAvatarFile) {
                try {
                    await this.profileService.uploadAvatar(this.selectedAvatarFile);
                    this.selectedAvatarFile = null;
                } catch {
                    this.errorMessage = "Erreur lors du téléversement de l'avatar (l'image par défaut a été conservée).";
                }
            }

            await this.router.navigate(['/home']);
            // eslint-disable-next-line no-console
            console.log('Session créée:', res.sessionId, res.user);
        } catch (e: unknown) {
            if (e instanceof HttpErrorResponse) {
                const backendMessage = typeof e.error?.message === 'string' ? e.error.message : typeof e.message === 'string' ? e.message : null;
                this.errorMessage = backendMessage ?? `Erreur serveur (${e.status})`;
            } else {
                this.errorMessage = "Erreur lors de l'inscription.";
            }
            // eslint-disable-next-line no-console
            console.error(e);
        } finally {
            this.isSubmitting = false;
        }
    }
}

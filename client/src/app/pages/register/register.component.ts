import { HttpErrorResponse } from '@angular/common/http';
import { Component } from '@angular/core';
import { AbstractControl, FormBuilder, ReactiveFormsModule, ValidationErrors, ValidatorFn, Validators } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { PROFILE_AVATARS } from '@app/constants/profile.constants';
import { AuthService } from '@app/services/communication/auth.service';
import { TranslateModule } from '@ngx-translate/core';

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
    imports: [ReactiveFormsModule, RouterLink, TranslateModule],
    templateUrl: './register.component.html',
    styleUrl: './register.component.scss',
})
export class RegisterPageComponent {
    errorMessage: string | null = null;
    isSubmitting = false;
    showPassword = false;
    showConfirmPassword = false;

    avatars = PROFILE_AVATARS;

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
        private router: Router,
    ) {}

    get selectedAvatarId(): string {
        return this.form.controls.avatarId.value ?? '';
    }

    selectAvatar(id: string) {
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

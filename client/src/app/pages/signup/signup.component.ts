import { Component } from '@angular/core';
import { ReactiveFormsModule, Validators, FormBuilder } from '@angular/forms';
import { AuthService } from '@app/services/communication/auth.service';

type AvatarOption = { id: string; label: string };

@Component({
    selector: 'app-signup-page',
    imports: [ReactiveFormsModule],
    templateUrl: './signup.component.html',
    styleUrl: './signup.component.scss',
})
export class SignUpPageComponent {
    avatars: AvatarOption[] = [
        { id: 'avatar_01', label: 'Avatar 1' },
        { id: 'avatar_02', label: 'Avatar 2' },
        { id: 'avatar_03', label: 'Avatar 3' },
        { id: 'avatar_04', label: 'Avatar 4' },
        { id: 'avatar_05', label: 'Avatar 5' },
    ];

    form = this.fb.nonNullable.group({
        username: ['', [Validators.required, Validators.pattern(/^[a-zA-Z0-9]+$/)]],
        email: ['', [Validators.required, Validators.email, Validators.pattern(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/)]],
        password: ['', [Validators.required, Validators.minLength(8)]],
        avatarId: ['', [Validators.required]],
    });

    constructor(
        private fb: FormBuilder,
        private authService: AuthService,
    ) {}

    get selectedAvatarId(): string {
        return this.form.controls.avatarId.value ?? '';
    }

    selectAvatar(id: string) {
        this.form.controls.avatarId.setValue(id);
        this.form.controls.avatarId.markAsTouched();
    }

    async submitForm() {
        this.form.markAllAsTouched();

        if (this.form.invalid) return;

        const { username, email, password, avatarId } = this.form.getRawValue();

        // eslint-disable-next-line no-console
        console.log({ username, email, password, avatarId });

        try {
            const res = await this.authService.register({
                username,
                email,
                password,
                avatarId,
            });

            // option: rediriger vers home / create-player / etc.
            // eslint-disable-next-line no-console
            console.log('Session créée:', res.sessionId, res.user);
            // eslint-disable-next-line no-console
            console.log('sessionId localStorage:', localStorage.getItem('sessionId'));
            // eslint-disable-next-line no-console
            console.log('firebase currentUser:', this.authService.currentUser?.email);
        } catch (e: unknown) {
            // pour debug rapide
            // eslint-disable-next-line no-console
            console.error(e);
        }
    }
}

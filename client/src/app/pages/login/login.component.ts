/* eslint-disable no-console */
import { Component } from '@angular/core';
import { ReactiveFormsModule, Validators, FormBuilder } from '@angular/forms';
import { AuthService } from '@app/services/communication/auth.service';
import { HttpErrorResponse } from '@angular/common/http';

type FirebaseAuthError = { code?: string; message?: string };

@Component({
    selector: 'app-login-page',
    standalone: true,
    imports: [ReactiveFormsModule],
    templateUrl: './login.component.html',
    styleUrl: './login.component.scss',
})
export class LoginPageComponent {
    errorMessage: string | null = null;
    isSubmitting = false;

    form = this.fb.nonNullable.group({
        email: ['', [Validators.required, Validators.email]],
        password: ['', [Validators.required, Validators.minLength(8)]],
    });

    constructor(
        private fb: FormBuilder,
        private authService: AuthService,
    ) {}

    async submitForm() {
        this.errorMessage = null;
        this.form.markAllAsTouched();
        if (this.form.invalid) return;

        const { email, password } = this.form.getRawValue();

        this.isSubmitting = true;
        try {
            const res = await this.authService.login(email, password);

            // debug
            // eslint-disable-next-line no-console
            console.log('Session créée:', res.sessionId, res.user);
            // eslint-disable-next-line no-console
            console.log('sessionId localStorage:', localStorage.getItem('sessionId'));
        } catch (e: unknown) {
            //  Erreurs backend (Nest)
            if (e instanceof HttpErrorResponse) {
                const backendMessage = typeof e.error?.message === 'string' ? e.error.message : typeof e.message === 'string' ? e.message : null;

                if (e.status === 403) {
                    this.errorMessage = backendMessage ?? 'Ce compte est déjà connecté sur un autre appareil.';
                } else {
                    this.errorMessage = backendMessage ?? `Erreur serveur (${e.status})`;
                }

                console.error(e);
                return;
            }

            // Erreurs Firebase
            const anyErr = e as FirebaseAuthError;
            const code: string | undefined = anyErr?.code;

            if (code === 'auth/invalid-credential' || code === 'auth/wrong-password') {
                this.errorMessage = 'Email ou mot de passe incorrect.';
            } else if (code === 'auth/user-not-found') {
                this.errorMessage = 'Aucun compte n’existe avec cet email.';
            } else {
                this.errorMessage = 'Erreur de connexion.';
            }

            console.error(e);
        } finally {
            this.isSubmitting = false;
        }
    }

    async logoutForTest() {
        this.errorMessage = null;

        try {
            await this.authService.logout();
            // eslint-disable-next-line no-console
            console.log('Logout OK');
            // eslint-disable-next-line no-console
            console.log('sessionId localStorage:', localStorage.getItem('sessionId'));
        } catch (e) {
            // eslint-disable-next-line no-console
            console.error('Logout KO', e);
        }
    }
}

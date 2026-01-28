/* eslint-disable no-console */
import { HttpErrorResponse } from '@angular/common/http';
import { Component } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthService } from '@app/services/communication/auth.service';

type FirebaseAuthError = { code?: string; message?: string };

@Component({
    selector: 'app-login-page',
    standalone: true,
    imports: [ReactiveFormsModule, RouterLink],
    templateUrl: './login.component.html',
    styleUrl: './login.component.scss',
})
export class LoginPageComponent {
    errorMessage: string | null = null;
    isSubmitting = false;

    form = this.fb.nonNullable.group({
        username: ['', [Validators.required]],
        password: ['', [Validators.required]],
    });

    constructor(
        private fb: FormBuilder,
        private authService: AuthService,
        private router: Router,
    ) {}

    async submitForm() {
        this.errorMessage = null;
        this.form.markAllAsTouched();
        if (this.form.invalid) return;

        const { username, password } = this.form.getRawValue();

        this.isSubmitting = true;
        try {
            const response = await this.authService.loginByUsername(username, password);
            await this.router.navigate(['/home']);
            // debug
            // eslint-disable-next-line no-console
            console.log('Session créée:', response.sessionId, response.user);
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
                this.errorMessage = 'Identifiant ou mot de passe incorrect.';
            } else if (code === 'auth/user-not-found') {
                this.errorMessage = "Aucun compte n'existe avec cet identifiant.";
            } else {
                this.errorMessage = 'Erreur de connexion.';
            }

            console.error(e);
        } finally {
            this.isSubmitting = false;
        }
    }
}

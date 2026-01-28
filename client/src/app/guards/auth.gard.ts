import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { AuthService } from '@app/services/communication/auth.service';

export const authGuard: CanActivateFn = async () => {
    const authService = inject(AuthService);
    const router = inject(Router);
    console.log('authGuard', authService.isAuthenticatedAsync()); // eslint-disable-line no-console
    return (await authService.isAuthenticatedAsync()) ? true : router.createUrlTree(['/auth-landing']);
};

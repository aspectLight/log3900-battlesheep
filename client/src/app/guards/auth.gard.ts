import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { AuthService } from '@app/services/communication/auth.service';
import { ProfileService } from '@app/services/communication/profile.service';

export const authGuard: CanActivateFn = async () => {
    const authService = inject(AuthService);
    const profileService = inject(ProfileService);
    const router = inject(Router);

    if (!(await authService.isAuthenticatedAsync())) {
        return router.createUrlTree(['/auth-landing']);
    }

    // Charge le profil (avec cache) → applique le thème du compte si pas encore fait
    try {
        await profileService.loadAndApplyTheme();
    } catch {
        // Si le chargement échoue (ex. réseau), on laisse passer quand même
    }

    return true;
};

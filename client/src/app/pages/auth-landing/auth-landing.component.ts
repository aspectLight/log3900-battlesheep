import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { TranslateModule } from '@ngx-translate/core';
import { LanguageService, LanguageType } from '@app/services/state/language.service';

@Component({
    selector: 'app-auth-landing',
    imports: [TranslateModule],
    templateUrl: './auth-landing.component.html',
    styleUrl: './auth-landing.component.scss',
})
export class AuthLandingPageComponent {
    constructor(
        private router: Router,
        public languageService: LanguageService,
    ) {}

    navigateToLogin() {
        this.router.navigate(['/login']);
    }

    navigateToRegister() {
        this.router.navigate(['/register']);
    }

    setLanguage(lang: LanguageType) {
        this.languageService.setLanguage(lang);
    }
}

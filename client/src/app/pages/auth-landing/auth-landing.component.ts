import { Component } from '@angular/core';
import { Router } from '@angular/router';

@Component({
    selector: 'app-auth-landing',
    imports: [],
    templateUrl: './auth-landing.component.html',
    styleUrl: './auth-landing.component.scss',
})
export class AuthLandingPageComponent {
    constructor(private router: Router) {}

    navigateToLogin() {
        this.router.navigate(['/login']);
    }

    navigateToRegister() {
        this.router.navigate(['/register']);
    }
}

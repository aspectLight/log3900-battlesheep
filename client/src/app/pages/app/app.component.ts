import { Component } from '@angular/core';
import { NavigationEnd, NavigationStart, Router, RouterOutlet } from '@angular/router';
import { LoadingScreenComponent } from '@app/components/loading-screen/loading-screen.component';
import { LOADING_SCREEN_DELAY } from '@app/constants/routes.constants';
@Component({
    selector: 'app-root',
    templateUrl: './app.component.html',
    styleUrls: ['./app.component.scss'],
    imports: [RouterOutlet, LoadingScreenComponent],
})
export class AppComponent {
    isLoading = false;

    constructor(private router: Router) {
        this.router.events.subscribe((event) => {
            if (event instanceof NavigationStart) {
                this.isLoading = true;
            }
            if (event instanceof NavigationEnd) {
                setTimeout(() => {
                    this.isLoading = false;
                }, LOADING_SCREEN_DELAY);
            }
        });
    }
}

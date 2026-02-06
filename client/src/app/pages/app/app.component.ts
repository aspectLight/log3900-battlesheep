import { Component, HostListener } from '@angular/core';
import { NavigationEnd, NavigationStart, Router, RouterOutlet } from '@angular/router';
import { LoadingScreenComponent } from '@app/components/shared/loading-screen/loading-screen.component';
import { LOADING_SCREEN_DELAY } from '@app/constants/routes.constants';
import { SocketService } from '@app/services/communication/socket-handlers/socket.service';
@Component({
    selector: 'app-root',
    templateUrl: './app.component.html',
    styleUrls: ['./app.component.scss'],
    imports: [RouterOutlet, LoadingScreenComponent],
})
export class AppComponent {
    isLoading = false;

    constructor(
        private router: Router,
        private socketService: SocketService,
    ) {
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

    @HostListener('window:beforeunload')
    onBeforeUnload(): void {
        this.socketService.disconnect();
    }
}

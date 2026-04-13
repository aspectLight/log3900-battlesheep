import { Component, HostListener } from '@angular/core';
import { NavigationEnd, NavigationStart, Router, RouterOutlet } from '@angular/router';
import { ChatboxComponent } from '@app/components/shared/chatbox/chatbox.component';
import { LoadingScreenComponent } from '@app/components/shared/loading-screen/loading-screen.component';
import { LOADING_SCREEN_DELAY } from '@app/constants/routes.constants';
import { SocketService } from '@app/services/communication/socket-handlers/socket.service';

const ROUTES_WITHOUT_GENERAL_CHAT = ['/login', '/register', '/auth-landing', '/game'];

@Component({
    selector: 'app-root',
    templateUrl: './app.component.html',
    styleUrls: ['./app.component.scss'],
    imports: [RouterOutlet, LoadingScreenComponent, ChatboxComponent],
})
export class AppComponent {
    isLoading = false;
    showGeneralChat = false;

    constructor(
        private router: Router,
        private socketService: SocketService,
    ) {
        this.router.events.subscribe((event) => {
            if (event instanceof NavigationEnd) {
                setTimeout(() => {
                    this.isLoading = false;
                }, LOADING_SCREEN_DELAY);
                this.showGeneralChat = !ROUTES_WITHOUT_GENERAL_CHAT.some((r) => event.urlAfterRedirects.startsWith(r));
            }
            if (event instanceof NavigationStart) {
                this.isLoading = true;
            }
        });
    }

    @HostListener('window:beforeunload')
    onBeforeUnload(): void {
        this.socketService.disconnect();
    }
}

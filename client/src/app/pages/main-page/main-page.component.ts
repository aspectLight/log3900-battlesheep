import { Component, OnInit } from '@angular/core';
import { Router, RouterLink } from '@angular/router';
import { PopUpComponent } from '@app/components/shared/pop-up/pop-up.component';
import { AuthService } from '@app/services/communication/auth.service';
import { SocketService } from '@app/services/communication/socket-handlers/socket.service';
import { GameManagerService } from '@app/services/state/game-manager.service';
import { AuthService } from '@app/services/communication/auth.service';
import { ChatService } from '@app/services/communication/chat.service';
import { ChatboxComponent } from '@app/components/shared/chatbox/chatbox.component';

@Component({
    selector: 'app-main-page',
    templateUrl: './main-page.component.html',
    styleUrls: ['./main-page.component.scss'],
    imports: [RouterLink, PopUpComponent, ChatboxComponent],
})
export class MainPageComponent implements OnInit {
    readonly title: string = 'Eastern Solace';
    showSettingsMenu = false;

    constructor(
        private gameManagerService: GameManagerService,
        private socketService: SocketService,
        private authService: AuthService,
        private chatService: ChatService,
        private router: Router,
    ) {}

    get isGameCanceled(): boolean {
        return this.gameManagerService.isGameCanceled;
    }

    get isGameFinished(): boolean {
        return this.gameManagerService.isGameFinished;
    }

    ngOnInit(): void {
        this.socketService.reconnect();
        this.chatService.setupListeners();
        const username = this.authService.currentUser?.displayName || 'Utilisateur';
        this.chatService.joinGeneralChat(username);
    }

    understandError() {
        this.gameManagerService.isGameCanceled = false;
    }

    understandMessage() {
        this.gameManagerService.isGameFinished = false;
    }

    toggleSettingsMenu() {
        this.showSettingsMenu = !this.showSettingsMenu;
    }

    goToProfile() {
        this.showSettingsMenu = false;
        this.router.navigate(['/profile']);
    }

    async logout() {
        try {
            await this.authService.logout();
            this.router.navigate(['/auth-landing']);
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

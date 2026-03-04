import { Component, ElementRef, HostListener, OnInit, ViewChild } from '@angular/core';
import { Router, RouterLink } from '@angular/router';
import { ChatboxComponent } from '@app/components/shared/chatbox/chatbox.component';
import { PopUpComponent } from '@app/components/shared/pop-up/pop-up.component';
import { AuthService } from '@app/services/communication/auth.service';
import { ChatService } from '@app/services/communication/chat.service';
import { CustomChannelService } from '@app/services/communication/custom-channel.service';
import { SocketService } from '@app/services/communication/socket-handlers/socket.service';
import { GameManagerService } from '@app/services/state/game-manager.service';

@Component({
    selector: 'app-main-page',
    templateUrl: './main-page.component.html',
    styleUrls: ['./main-page.component.scss'],
    imports: [RouterLink, PopUpComponent, ChatboxComponent],
})
export class MainPageComponent implements OnInit {
    @ViewChild('settingsMenu') settingsMenu!: ElementRef;
    readonly title: string = 'Eastern Solace';
    showSettingsMenu = false;

    // eslint-disable-next-line max-params
    constructor(
        private gameManagerService: GameManagerService,
        private socketService: SocketService,
        private authService: AuthService,
        private chatService: ChatService,
        private customChannelService: CustomChannelService,
        private router: Router,
    ) {}

    get isGameCanceled(): boolean {
        return this.gameManagerService.isGameCanceled;
    }

    get isGameFinished(): boolean {
        return this.gameManagerService.isGameFinished;
    }

    @HostListener('document:click', ['$event'])
    onDocumentClick(event: MouseEvent) {
        if (this.showSettingsMenu && this.settingsMenu && !this.settingsMenu.nativeElement.contains(event.target)) {
            this.showSettingsMenu = false;
        }
    }

    async ngOnInit(): Promise<void> {
        const username = this.authService.currentUser?.displayName || 'Utilisateur';
        // Wait for the socket to be fully reconnected
        await this.socketService.reconnect();
        // Then, configure listeners and join the chat
        this.chatService.setupListeners();
        this.customChannelService.setupListeners();
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

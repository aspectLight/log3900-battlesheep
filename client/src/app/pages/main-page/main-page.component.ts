import { AsyncPipe } from '@angular/common';
import { Component, ElementRef, HostListener, OnDestroy, OnInit, ViewChild } from '@angular/core';
import { Router, RouterLink } from '@angular/router';
import { PopUpComponent } from '@app/components/shared/pop-up/pop-up.component';
import { ACCOUNT_CREATION_AVATARS, PROFILE_AVATARS } from '@app/constants/profile.constants';
import { AuthService } from '@app/services/communication/auth.service';
import { AvatarRegistryService } from '@app/services/communication/avatar-registry.service';
import { ChatService } from '@app/services/communication/chat.service';
import { CustomChannelService } from '@app/services/communication/custom-channel.service';
import { ProfileService } from '@app/services/communication/profile.service';
import { SocialService } from '@app/services/communication/social.service';
import { SocketService } from '@app/services/communication/socket-handlers/socket.service';
import { VirtualCurrencyService } from '@app/services/currency/virtual-currency.service';
import { GameManagerService } from '@app/services/state/game-manager.service';
import { TranslateModule } from '@ngx-translate/core';
import { Subscription } from 'rxjs';
import { environment } from 'src/environments/environment';

@Component({
    selector: 'app-main-page',
    templateUrl: './main-page.component.html',
    styleUrls: ['./main-page.component.scss'],
    imports: [RouterLink, PopUpComponent, AsyncPipe, TranslateModule],
})
export class MainPageComponent implements OnInit, OnDestroy {
    private pendingRequestsSub?: Subscription;
    private profileUpdatedSub?: Subscription;
    @ViewChild('settingsMenu') settingsMenu!: ElementRef;
    readonly title: string = 'Eastern Solace';
    showSettingsMenu = false;
    pendingRequestCount = 0;
    avatarDisplayUrl: string = './assets/ui/profile.png';

    // eslint-disable-next-line max-params
    constructor(
        private gameManagerService: GameManagerService,
        private socketService: SocketService,
        private authService: AuthService,
        private chatService: ChatService,
        private customChannelService: CustomChannelService,
        private profileService: ProfileService,
        private socialService: SocialService,
        private router: Router,
        public currencyService: VirtualCurrencyService,
        private avatarRegistry: AvatarRegistryService,
    ) {}

    get isGameCanceled(): boolean {
        return this.gameManagerService.isGameCanceled;
    }

    get isGameFinished(): boolean {
        return this.gameManagerService.isGameFinished;
    }

    get gameCanceledMessageKey(): string {
        return this.gameManagerService.gameCanceledMessageKey;
    }

    @HostListener('document:click', ['$event'])
    onDocumentClick(event: MouseEvent) {
        if (this.showSettingsMenu && this.settingsMenu && !this.settingsMenu.nativeElement.contains(event.target)) {
            this.showSettingsMenu = false;
        }
    }

    async ngOnInit(): Promise<void> {
        this.customChannelService.resetState();

        this.pendingRequestsSub = this.socialService.pendingRequests$.subscribe((requests) => {
            this.pendingRequestCount = requests.length;
        });

        this.profileUpdatedSub = this.profileService.profileUpdated$.subscribe((profile) => {
            this.refreshAvatarFromProfile(profile.avatarId ?? null, profile.avatarUrl ?? null);
        });

        let username = this.authService.currentUser?.displayName || 'Utilisateur';

        // Reconnect the socket immediately so the server can cancel the auto-logout timeout
        // before it fires. The profile fetch below can take a moment and must not delay this.
        await this.socketService.reconnect();

        // Fetch the user profile to get the avatar of the logged-in user
        let avatarId: string | null = null;
        let avatarUrl: string | null = null;
        try {
            const profile = await this.profileService.getProfile();
            username = profile.username || username;
            avatarId = profile.avatarId ?? null;
            avatarUrl = profile.avatarUrl ? `${environment.serverUrl}${profile.avatarUrl}` : null;
            this.refreshAvatarFromProfile(avatarId, profile.avatarUrl ?? null);
        } catch {
            // Continue without avatar on error
        }
        // Then, configure listeners and join the chat
        this.chatService.setupListeners();
        this.customChannelService.setupListeners();
        this.socialService.setupListeners();
        this.currencyService.setupListeners();
        this.avatarRegistry.setupListeners();
        this.customChannelService.setUsername(username);
        this.chatService.joinGeneralChat(username, avatarId, avatarUrl);
        this.customChannelService.avatarId = avatarId;
        this.customChannelService.avatarUrl = avatarUrl;
        this.avatarRegistry.setLocal(username, { avatarId, avatarUrl });

        // Load pending friend requests after socket is connected
        this.socialService.loadPendingRequests();

        this.currencyService.fetchBalance();
    }

    ngOnDestroy(): void {
        this.pendingRequestsSub?.unsubscribe();
        this.profileUpdatedSub?.unsubscribe();
    }

    private refreshAvatarFromProfile(avatarId: string | null, avatarUrlPath: string | null): void {
        if (avatarUrlPath) {
            this.avatarDisplayUrl = `${environment.serverUrl}${avatarUrlPath}`;
            return;
        }
        if (avatarId) {
            const allAvatars = [...PROFILE_AVATARS, ...ACCOUNT_CREATION_AVATARS];
            const match = allAvatars.find((a) => a.id === avatarId);
            if (match) {
                this.avatarDisplayUrl = match.image;
                return;
            }
        }
        this.avatarDisplayUrl = './assets/ui/profile.png';
    }

    understandError() {
        this.gameManagerService.isGameCanceled = false;
        this.gameManagerService.gameCanceledMessageKey = 'main.game_canceled';
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

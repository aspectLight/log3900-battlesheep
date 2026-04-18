import { AsyncPipe } from '@angular/common';
import { Component, ElementRef, HostListener, OnInit, ViewChild } from '@angular/core';
import { Router, RouterLink } from '@angular/router';
import { ACCOUNT_CREATION_AVATARS, PROFILE_AVATARS } from '@app/constants/profile.constants';
import { AuthService } from '@app/services/communication/auth.service';
import { CustomChannelService } from '@app/services/communication/custom-channel.service';
import { ProfileService } from '@app/services/communication/profile.service';
import { VirtualCurrencyService } from '@app/services/currency/virtual-currency.service';
import { environment } from 'src/environments/environment';

@Component({
    selector: 'app-profile-menu',
    templateUrl: './profile-menu.component.html',
    styleUrls: ['./profile-menu.component.scss'],
    imports: [RouterLink, AsyncPipe],
})
export class ProfileMenuComponent implements OnInit {
    @ViewChild('profileMenu') profileMenuRef!: ElementRef;
    showMenu = false;
    avatarDisplayUrl: string = './assets/ui/profile.png';

    constructor(
        public currencyService: VirtualCurrencyService,
        private profileService: ProfileService,
        private authService: AuthService,
        private customChannelService: CustomChannelService,
        private router: Router,
    ) {}

    @HostListener('document:click', ['$event'])
    onDocumentClick(event: MouseEvent) {
        if (this.showMenu && this.profileMenuRef && !this.profileMenuRef.nativeElement.contains(event.target)) {
            this.showMenu = false;
        }
    }

    async ngOnInit(): Promise<void> {
        try {
            const profile = await this.profileService.getProfile();
            const avatarId = profile.avatarId ?? null;
            const avatarUrl = profile.avatarUrl ? `${environment.serverUrl}${profile.avatarUrl}` : null;
            if (avatarUrl) {
                this.avatarDisplayUrl = avatarUrl;
            } else if (avatarId) {
                const allAvatars = [...PROFILE_AVATARS, ...ACCOUNT_CREATION_AVATARS];
                const match = allAvatars.find((a) => a.id === avatarId);
                if (match) this.avatarDisplayUrl = match.image;
            }
        } catch {
            // Continue without avatar on error
        }
    }

    toggleMenu() {
        this.showMenu = !this.showMenu;
    }

    async logout() {
        try {
            this.customChannelService.resetState();
            await this.authService.logout();
            this.router.navigate(['/auth-landing']);
        } catch (e) {
            // eslint-disable-next-line no-console
            console.error('Logout KO', e);
        }
    }
}

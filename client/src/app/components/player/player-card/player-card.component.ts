import { Component, EventEmitter, Input, OnChanges, OnInit, Output, SimpleChanges } from '@angular/core';
import { Player } from '@app/classes/entity/player';
import { ACCOUNT_CREATION_AVATARS } from '@app/constants/profile.constants';
import { AVATAR_TYPES } from '@app/constants/player.constants';
import { TranslateModule } from '@ngx-translate/core';
import { environment } from 'src/environments/environment';

@Component({
    selector: 'app-player-card',
    imports: [TranslateModule],
    templateUrl: './player-card.component.html',
    styleUrls: ['./player-card.component.scss'],
})
export class PlayerCardComponent implements OnInit, OnChanges {
    @Output() banEvent = new EventEmitter<Player>();
    @Input() player!: Player;
    @Input() isHost: boolean = false;
    @Input() showKick: boolean = false;
    avatar: string;
    profileAvatar: string | null = null;
    isVirtualPlayer: boolean = false;

    onKickClick() {
        this.banEvent.emit(this.player);
    }

    ngOnInit() {
        this.applyPlayerInputs();
    }

    ngOnChanges(changes: SimpleChanges): void {
        if (changes['player'] && this.player) {
            this.applyPlayerInputs();
        }
    }

    private applyPlayerInputs(): void {
        if (this.player && this.player.avatar) {
            const raw = this.player.avatar as any;
            if (typeof raw === 'string') {
                this.avatar = AVATAR_TYPES[raw]?.avatarFull ?? AVATAR_TYPES[raw.toLowerCase()]?.avatarFull ?? '';
            } else {
                this.avatar =
                    raw.avatarFull ??
                    AVATAR_TYPES[raw.name?.toLowerCase()]?.avatarFull ??
                    '';
            }
        } else {
            this.avatar = '';
        }

        this.isVirtualPlayer = !!(this.player && this.player.isVirtual);
        this.profileAvatar = this.resolveProfileAvatar();
    }

    private resolveProfileAvatar(): string | null {
        if (this.player.profileAvatarUrl) {
            const url = this.player.profileAvatarUrl;
            const isAbsolute =
                url.startsWith('http://') ||
                url.startsWith('https://') ||
                url.startsWith('data:');
            return isAbsolute ? url : `${environment.serverUrl}${url}`;
        }
        if (!this.player.profileAvatarId) return null;
        const avatar = ACCOUNT_CREATION_AVATARS.find((a) => a.id === this.player.profileAvatarId);
        return avatar ? avatar.image : null;
    }
}

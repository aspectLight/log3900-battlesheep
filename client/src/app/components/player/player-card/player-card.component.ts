import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { Player } from '@app/classes/entity/player';
import { ACCOUNT_CREATION_AVATARS } from '@app/constants/profile.constants';
@Component({
    selector: 'app-player-card',
    templateUrl: './player-card.component.html',
    styleUrls: ['./player-card.component.scss'],
})
export class PlayerCardComponent implements OnInit {
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
        if (this.player && this.player.avatar) {
            this.avatar = this.player.avatar.avatarFull;
        }

        if (this.player && this.player.isVirtual) {
            this.isVirtualPlayer = true;
        }

        this.profileAvatar = this.resolveProfileAvatar();
    }

    private resolveProfileAvatar(): string | null {
        if (this.player.profileAvatarUrl) return this.player.profileAvatarUrl;
        if (!this.player.profileAvatarId) return null;
        const avatar = ACCOUNT_CREATION_AVATARS.find((a) => a.id === this.player.profileAvatarId);
        return avatar ? avatar.image : null;
    }
}

import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { Player } from '@app/classes/entity/player';
import { TranslateModule } from '@ngx-translate/core';
@Component({
    selector: 'app-player-card',
    imports: [TranslateModule],
    templateUrl: './player-card.component.html',
    styleUrls: ['./player-card.component.scss'],
})
export class PlayerCardComponent implements OnInit {
    @Output() banEvent = new EventEmitter<Player>();
    @Input() player!: Player;
    @Input() isHost: boolean = false;
    @Input() showKick: boolean = false;
    avatar: string;
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
    }
}

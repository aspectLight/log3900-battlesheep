import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { Player } from '@app/classes/player';
@Component({
    selector: 'app-player-card',
    standalone: true,
    templateUrl: './player-card.component.html',
    styleUrls: ['./player-card.component.scss'],
})
export class PlayerCardComponent implements OnInit {
    @Output() banEvent = new EventEmitter<Player>();
    @Input() player!: Player;
    @Input() isHost: boolean = false;
    @Input() showKick: boolean = false;
    avatar: string;

    onKickClick() {
        this.banEvent.emit(this.player);
    }

    ngOnInit() {
        if (this.player && this.player.avatar) {
            this.avatar = this.player.avatar.avatarFull;
        }
    }
}

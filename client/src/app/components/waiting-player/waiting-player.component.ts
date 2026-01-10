import { CommonModule } from '@angular/common';
import { Component, OnDestroy, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { Player } from '@app/classes/player';
import { ChatboxComponent } from '@app/components/chatbox/chatbox.component';
import { PlayerCardComponent } from '@app/components/player-card/player-card.component';
import { PopUpComponent } from '@app/components/pop-up/pop-up.component';
import { ErrorMessages } from '@app/constants/error-messages.constants';
import { ROUTES } from '@app/constants/routes.constants';
import { Room } from '@app/interfaces/room';
import { GameCreationService } from '@app/services/game-creation.service';
import { SocketService } from '@app/services/socket.service';
import { WaitingRoomService } from '@app/services/waiting-room.service';
import { Subscription } from 'rxjs';

@Component({
    imports: [CommonModule, PlayerCardComponent, PopUpComponent, ChatboxComponent],
    selector: 'app-waiting-player',
    templateUrl: './waiting-player.component.html',
    styleUrl: './waiting-player.component.scss',
})
export class WaitingPlayerComponent implements OnInit, OnDestroy {
    showError: boolean = false;
    errorMessage: string = '';
    room: Room | null = null;
    private roomSubscription!: Subscription;

    constructor(
        private gameCreationService: GameCreationService,
        private waitingRoomService: WaitingRoomService,
        private socketService: SocketService,
        public router: Router,
    ) {}

    get code(): string {
        return this.gameCreationService.gameCode;
    }

    get isHost(): boolean {
        return this.gameCreationService.isHost;
    }

    ngOnInit(): void {
        this.roomSubscription = this.waitingRoomService.room$.subscribe((room) => {
            this.room = room;
        });
        this.socketService.roomExists$.subscribe((roomExists) => {
            if (!roomExists) {
                this.errorMessage = ErrorMessages.GameDeleted;
                this.showError = true;
            }
        });
        this.socketService.isKicked$.subscribe((isKicked) => {
            if (isKicked) {
                this.errorMessage = ErrorMessages.PlayerKicked;
                this.showError = true;
            }
        });
    }

    ngOnDestroy(): void {
        this.roomSubscription.unsubscribe();
    }

    startGame() {
        this.socketService.startGame(this.code);
    }

    toggleLockRoom() {
        this.socketService.toggleLockRoom(this.code);
    }

    kickPlayer(player: Player) {
        this.socketService.kickPlayer(this.code, player);
    }

    leaveRoom() {
        this.socketService.leaveRoom(this.code, (success, error) => {
            if (success) {
                this.router.navigate([ROUTES.home]);
            } else {
                this.errorMessage = error || ErrorMessages.QuitError;
                this.showError = true;
            }
        });
    }
}

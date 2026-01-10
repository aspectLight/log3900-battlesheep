import { Component, ElementRef, ViewChild } from '@angular/core';
import { Router, RouterLink } from '@angular/router';
import { PopUpComponent } from '@app/components/pop-up/pop-up.component';
import { ROUTES } from '@app/constants/routes.constants';
import { GameCreationService } from '@app/services/game-creation.service';
import { SocketService } from '@app/services/socket.service';

@Component({
    selector: 'app-game-joiner',
    templateUrl: './game-joiner.component.html',
    imports: [RouterLink, PopUpComponent],
    styleUrl: './game-joiner.component.scss',
})
export class GameJoinerComponent {
    @ViewChild('gameCode') gameCodeInput!: ElementRef<HTMLInputElement>;
    showError: boolean;
    errorMessage: string;

    constructor(
        private socketService: SocketService,
        private gameCreationService: GameCreationService,
        private router: Router,
    ) {
        this.gameCreationService.isHost = false;
    }

    joinGame() {
        const gameCode = this.gameCodeInput.nativeElement.value;
        this.socketService.joinRoom(gameCode, (success, error) => {
            if (success) {
                this.gameCreationService.gameCode = gameCode;
                this.router.navigate([ROUTES.createPlayer]);
            } else {
                this.errorMessage = error || '';
                this.showError = true;
            }
        });
    }
}

import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { PopUpComponent } from '@app/components//pop-up/pop-up.component';
import { GameManagerService } from '@app/services/game-manager.service';
import { SocketService } from '@app/services/socket.service';

@Component({
    selector: 'app-game-settings',
    imports: [PopUpComponent],
    templateUrl: './game-settings.component.html',
    styleUrl: './game-settings.component.scss',
})
export class GameSettingsComponent {
    isSettingsClicked: boolean = false;

    constructor(
        private socketService: SocketService,
        private gameManagerService: GameManagerService,
        private router: Router,
    ) {}

    get title() {
        return this.gameManagerService.getGame().name;
    }

    get description(): string {
        const room = this.gameManagerService.room;
        const activePlayerName = room.players.find((p) => p.id === this.gameManagerService.currentPlayerId)?.name;
        return `${this.gameManagerService.getGame().description}    Joueurs: ${room.players.length}    Actif: ${activePlayerName}    Taille: ${
            this.gameManagerService.getBoard().size
        }`;
    }

    get roomId() {
        return this.gameManagerService.getRoomId();
    }

    toggleSettings() {
        this.isSettingsClicked = !this.isSettingsClicked;
    }

    quitGame() {
        this.socketService.abandonGame(this.roomId);
        this.router.navigate(['/home']);
    }
}

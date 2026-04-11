import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { PopUpComponent } from '@app/components/shared/pop-up/pop-up.component';
import { ROUTES } from '@app/constants/routes.constants';
import { SocketService } from '@app/services/communication/socket-handlers/socket.service';
import { GameManagerService } from '@app/services/state/game-manager.service';
import { TranslateModule, TranslateService } from '@ngx-translate/core';

@Component({
    selector: 'app-game-info',
    standalone: true,
    imports: [PopUpComponent, TranslateModule],
    templateUrl: './game-info.component.html',
    styleUrl: './game-info.component.scss',
})
export class GameInfoComponent {
    isSettingsClicked: boolean = false;

    constructor(
        private socketService: SocketService,
        private gameManagerService: GameManagerService,
        private router: Router,
        private translate: TranslateService,
    ) {}

    get title() {
        return this.gameManagerService.getGame().name;
    }

    get description(): string {
        const room = this.gameManagerService.room;
        const activePlayerName = room.players.find((p) => p.id === this.gameManagerService.currentPlayerId)?.name;
        const details = [
            this.gameManagerService.getGame().description,
            '',
            this.translate.instant('game_info.players_count', { count: room.players.length }),
            this.translate.instant('game_info.active_player', { name: activePlayerName }),
            this.translate.instant('game_info.board_size', { size: this.gameManagerService.getBoard().size }),
        ];
        return details.join('\n');
    }

    get roomId() {
        return this.gameManagerService.getRoomId();
    }

    toggleSettings() {
        this.isSettingsClicked = !this.isSettingsClicked;
    }

    quitGame() {
        this.gameManagerService.cancelGame();
        this.socketService.abandonGame(this.roomId);
        this.router.navigate([ROUTES.home]);
    }
}

import { Component, HostListener, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { Board } from '@app/classes/board';
import { Game } from '@app/classes/game';
import { ActionsHudComponent } from '@app/components/actions-hud/actions-hud.component';
import { BoardComponent } from '@app/components/board/board.component';
import { ChatboxComponent } from '@app/components/chatbox/chatbox.component';
import { CombatComponent } from '@app/components/combat/combat.component';
import { GameSettingsComponent } from '@app/components/game-settings/game-settings.component';
import { NotificationComponent } from '@app/components/notification/notification.component';
import { PlayerHudComponent } from '@app/components/player-hud/player-hud.component';
import { CombatService } from '@app/services/combat.service';
import { GameManagerService } from '@app/services/game-manager.service';
import { SocketService } from '@app/services/socket.service';
import { PopUpComponent } from '@app/components/pop-up/pop-up.component';

@Component({
    selector: 'app-game-play',
    imports: [
        BoardComponent,
        PlayerHudComponent,
        ActionsHudComponent,
        ChatboxComponent,
        GameSettingsComponent,
        CombatComponent,
        NotificationComponent,
        PopUpComponent,
    ],
    templateUrl: './game-play.component.html',
    styleUrl: './game-play.component.scss',
})
export class GamePlayComponent implements OnInit {
    game: Game;
    isGameLoaded: boolean = false;
    gameCountdown: number;
    combatCountdown: number;
    isTurnToFight: boolean;
    showError: boolean;
    debugMode: boolean = false;

    constructor(
        private gameManager: GameManagerService,
        private combatService: CombatService,
        public router: Router,
        private socketService: SocketService,
    ) {}

    get board(): Board {
        return this.gameManager.getBoard();
    }

    get isCombatMode(): boolean {
        return this.combatService.getCombatMode();
    }

    get flightAttemptsLeft(): number {
        return this.combatService.flightAttemptsLeft;
    }

    get isNotificationVisible(): boolean {
        return this.gameManager.isNotificationVisible;
    }

    get notificationMessage(): string {
        return this.gameManager.notificationMessage;
    }

    get notificationDuration(): number {
        return this.gameManager.notificationDuration;
    }

    get isGameCanceled(): boolean {
        return this.gameManager.isGameCanceled;
    }

    get isGameFinished(): boolean {
        return this.gameManager.isGameFinished;
    }

    get isDebugging(): boolean {
        return this.gameManager.room.isDebugging;
    }

    @HostListener('window:keydown', ['$event'])
    onKeyDown(event: KeyboardEvent) {
        if (event.key === 'd') {
            this.socketService.toggleDebugMode();
        }
    }

    ngOnInit(): void {
        if (this.gameManager.getIsGameLoaded() && this.gameManager.room.gameId) {
            this.isGameLoaded = true;
        } else if (this.gameManager.room.gameId) {
            this.gameManager.loadGame().subscribe({
                next: () => {
                    this.isGameLoaded = true;
                    this.gameManager.addPlayersToBoard(this.gameManager.getPlayers());
                },
            });
        } else {
            this.showError = true;
        }

        this.gameManager.gameCountdown.subscribe((count) => {
            this.gameCountdown = count;
        });

        this.combatService.combatCountdown.subscribe((count) => {
            this.combatCountdown = count;
            this.isTurnToFight = this.combatService.isCombatPlayerTurn;
        });
    }

    goBackToMenu() {
        this.router.navigate(['/home']);
    }
}

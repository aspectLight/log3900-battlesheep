import { Component, HostListener, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { Board } from '@app/classes/board/board';
import { Item } from '@app/classes/entity/item';
import { CombatComponent } from '@app/components/game/combat/combat.component';
import { GameInfoComponent } from '@app/components/lobby/game-info/game-info.component';
import { PlayerHudComponent } from '@app/components/player/player-hud/player-hud.component';
import { ActionsHudComponent } from '@app/components/shared/actions-hud/actions-hud.component';
import { BoardComponent } from '@app/components/shared/board/board.component';
import { ChatboxComponent } from '@app/components/shared/chatbox/chatbox.component';
import { LoadingScreenComponent } from '@app/components/shared/loading-screen/loading-screen.component';
import { NotificationComponent } from '@app/components/shared/notification/notification.component';
import { PopUpComponent } from '@app/components/shared/pop-up/pop-up.component';
import { GAME_RESULT_KEYS, MODES, OUTCOME } from '@app/constants/game.constants';
import { ROUTES } from '@app/constants/routes.constants';
import { ActionSocketService } from '@app/services/communication/socket-handlers/action-socket.service';
import { MovementSocketService } from '@app/services/communication/socket-handlers/movement-socket.service';
import { SocketService } from '@app/services/communication/socket-handlers/socket.service';
import { CombatService } from '@app/services/gameplay/combat.service';
import { GameManagerService } from '@app/services/state/game-manager.service';
import { TranslateModule, TranslateService } from '@ngx-translate/core';
@Component({
    selector: 'app-game-play',
    imports: [
        BoardComponent,
        PlayerHudComponent,
        ActionsHudComponent,
        GameInfoComponent,
        CombatComponent,
        NotificationComponent,
        PopUpComponent,
        LoadingScreenComponent,
        ChatboxComponent,
        TranslateModule,
    ],
    templateUrl: './game-play.component.html',
    styleUrl: './game-play.component.scss',
})
export class GamePlayComponent implements OnInit {
    isGameLoaded: boolean = false;
    turnCountdown?: number;
    gameCountdown?: number;
    combatCountdown?: number;
    isTurnToFight: boolean;
    showError: boolean;
    debugMode: boolean = false;
    finishMode: string = 'finishGame';
    turnStartingMode: string = 'turnStarting';

    constructor(
        private gameManager: GameManagerService,
        private combatService: CombatService,
        public router: Router,
        private socketService: SocketService,
        private actionSocketService: ActionSocketService,
        private movementSocketService: MovementSocketService,
        private translate: TranslateService,
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

    get isPopUpVisible(): boolean {
        return this.gameManager.isReplacementPopupVisible;
    }

    get replaceMessage(): string {
        return this.gameManager.replacementPopupMessage;
    }

    get candidateItems() {
        return this.gameManager.pendingReplacement?.candidateItems as Item[];
    }

    get isTrapPopupVisible(): boolean {
        return this.gameManager.isTrapPopupVisible;
    }

    get trapCanAvoid(): boolean {
        return this.gameManager.trapCanAvoid;
    }

    get trapDescription(): string {
        return this.trapCanAvoid
            ? 'Vous pouvez éviter le piège ou tenter de le traverser.'
            : "Vous n'avez pas assez de points pour éviter le piège. Vous devez le traverser.";
    }

    get notificationTime(): number {
        return this.gameManager.notificationTime;
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
        const target = event.target as HTMLElement;
        if (target && (target.tagName === 'INPUT' || target.tagName === 'TEXTAREA')) {
            return;
        }

        if (event.key === 'd') {
            this.actionSocketService.toggleDebugMode();
        }
    }

    ngOnInit(): void {
        if (this.gameManager.getIsGameLoaded() && this.gameManager.room.gameId) {
            this.isGameLoaded = true;
        } else if (!this.gameManager.room.gameId) {
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
        this.router.navigate([ROUTES.home]);
    }

    onItemReplacement(selectedItem: Item): void {
        const [toDrop, coords] = this.gameManager.processReplacement(selectedItem);
        this.socketService.dropItem(toDrop, coords);
    }

    onTrapChoice(choice: 'avoid' | 'traverse'): void {
        if (choice === 'avoid' && !this.trapCanAvoid) return;
        this.movementSocketService.sendTrapChoice(choice);
    }

    generateEndMessage(): string {
        const outcome = this.gameManager.hasWon() ? OUTCOME.WIN : OUTCOME.LOSE;
        const mode = this.gameManager.isCTF ? MODES.CTF : MODES.CLASSIQUE;
        const winner = this.gameManager.getWinner();

        const { key, params } = GAME_RESULT_KEYS[outcome][mode]({ winner });
        return this.translate.instant(key, params);
    }
}

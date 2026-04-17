import { TitleCasePipe } from '@angular/common';
import { Component, EventEmitter, OnDestroy, OnInit, Output } from '@angular/core';
import { Cell } from '@app/classes/board/cell';
import { Player } from '@app/classes/entity/player';
import { ItemCardComponent } from '@app/components/shared/item-card/item-card.component';
import { BonusType } from '@app/constants/bonus.constants';
import { CombatState, FEEDBACK_DURATION, NOTIFICATION_DURATION } from '@app/constants/combat.constants';
import { ActionSocketService } from '@app/services/communication/socket-handlers/action-socket.service';
import { SocketService } from '@app/services/communication/socket-handlers/socket.service';
import { ActionService } from '@app/services/gameplay/action.service';
import { CombatService } from '@app/services/gameplay/combat.service';
import { GameManagerService } from '@app/services/state/game-manager.service';
import { TranslateModule, TranslateService } from '@ngx-translate/core';
import { Subscription } from 'rxjs';
@Component({
    selector: 'app-combat',
    imports: [TitleCasePipe, ItemCardComponent, TranslateModule],
    templateUrl: './combat.component.html',
    styleUrl: './combat.component.scss',
})
export class CombatComponent implements OnInit, OnDestroy {
    @Output() combatMode = new EventEmitter<void>();

    selectedCell: Cell | null = null;
    cellReference: string = './assets/combat/placeholder.png';

    showNotification: boolean = false;
    notificationTitle: string = '';
    notificationMessage: string = '';
    notificationSuccess: boolean = true;

    isWinLossNotification: boolean = false;

    private subscriptions: Subscription[] = [];
    private notificationTimeout: ReturnType<typeof setTimeout>;

    constructor(
        private actionService: ActionService,
        private combatService: CombatService,
        private actionSocketService: ActionSocketService,
        private gameManager: GameManagerService,
        private socketService: SocketService,
        private translate: TranslateService,
    ) {}

    get isCombatPlayerTurn() {
        return this.combatService.isCombatPlayerTurn;
    }
    get showButtons(): boolean {
        return this.gameManager.canEndTurn;
    }

    get isCombatMode(): boolean {
        return this.combatService.getCombatMode();
    }

    get isPlayerTurn(): boolean {
        return this.gameManager.isPlayerTurn;
    }

    get player(): Player | null {
        return this.gameManager.getMainPlayer();
    }

    get enemy(): Player | null {
        return this.combatService.getEnemy();
    }

    get combatState(): string {
        return this.combatService.combatState;
    }

    get showResults(): boolean {
        return this.combatService.showResults;
    }

    get attackValue(): number {
        return this.combatService.attackValue;
    }

    get defenseValue(): number {
        return this.combatService.defenseValue;
    }

    get hasFlightAttempts(): boolean {
        return this.combatService.flightAttemptsLeft > 0;
    }

    get hasEnemyBarbedWire(): boolean {
        return this.enemy?.inventory?.some((item) => item?.type === 'barbedWire') ?? false;
    }

    get isSelectionActive(): boolean {
        return this.actionService.getIsSelectionActive();
    }

    get isActionActive(): boolean {
        return this.actionService.getIsActionActive();
    }

    get isCombatInitiator(): boolean {
        return this.combatService.isCombatInitiator;
    }

    get wasFlightEnd(): boolean {
        return this.combatService.wasFlightEnd;
    }

    private set attackValue(value: number) {
        this.combatService.attackValue = value;
    }

    private set defenseValue(value: number) {
        this.combatService.defenseValue = value;
    }

    ngOnInit(): void {
        // Initialize canEndTurn based on current turn when component loads
        this.gameManager.canEndTurn = this.isPlayerTurn;

        this.subscriptions.push(
            this.actionService.selectedCell$.subscribe((cell) => {
                this.selectedCell = cell;
                this.setCellReference(cell);
            }),
        );
        this.subscriptions.push(
            this.combatService.combatStateChange.subscribe((state) => {
                this.showCombatNotification(state);
            }),
        );
        this.subscriptions.push(
            this.gameManager.turnChange.subscribe(() => {
                if (this.isPlayerTurn) {
                    this.actionService.toggleSelection();
                    this.gameManager.canEndTurn = true;
                } else {
                    this.gameManager.canEndTurn = false;
                }
            }),
        );
    }

    ngOnDestroy(): void {
        this.subscriptions.forEach((sub) => sub.unsubscribe());
    }

    getEnemyStat(stat: string) {
        const statValue = this.combatService.getEnemy()?.stats[stat as BonusType].value;
        if (stat === BonusType.Health && typeof statValue === 'number') {
            return Math.max(0, statValue);
        }
        return statValue;
    }

    toggleAction(): void {
        this.actionService.toggleAction();
    }

    toggleSelection(): void {
        this.actionService.toggleSelection();
    }

    attack() {
        if (this.enemy && this.player) {
            const attackInfo = this.combatService.attack();
            if (!attackInfo) return;
            this.actionSocketService.attack(attackInfo);
        }
    }

    flight() {
        if (this.enemy?.hasItem('barbedWire') && !this.isCombatInitiator) {
            this.displayNotification('Barbed wire', "La fuite est empêché par l'adversaire", false);
            return;
        }
        const flightInfo = this.combatService.flight();
        if (flightInfo) {
            this.actionSocketService.flightAttempt(flightInfo);
        }
    }

    endTurn() {
        if (this.gameManager.isPlayerMoving()) return;
        const gameRoomId = this.gameManager.getRoomId();
        this.socketService.endPlayerTurn(gameRoomId);
        this.displayNotification('Tour terminé', 'Votre tour est terminé', true);
    }

    resetCombat() {
        this.combatService.resetCombat();
        this.showNotification = false;
        this.isWinLossNotification = false;
        if (this.notificationTimeout) {
            clearTimeout(this.notificationTimeout);
        }
    }

    private displayNotification(title: string, message: string, isSuccess: boolean, duration: number = FEEDBACK_DURATION) {
        if (this.notificationTimeout) {
            clearTimeout(this.notificationTimeout);
        }

        this.notificationTitle = title;
        this.notificationMessage = message;
        this.notificationSuccess = isSuccess;
        this.showNotification = true;

        this.notificationTimeout = setTimeout(() => {
            this.showNotification = false;
            if (this.isWinLossNotification) {
                this.isWinLossNotification = false;
            }
        }, duration);
    }

    private showCombatNotification(state: string) {
        if (!this.enemy || !this.player) return;
        let title = '';
        let message = '';
        let isSuccess = true;
        let duration = FEEDBACK_DURATION;

        this.isWinLossNotification = false;

        switch (state) {
            case CombatState.Miss: {
                title = this.translate.instant('combat.notif_miss_title');
                message = '';
                isSuccess = false;
                break;
            }
            case CombatState.Hit: {
                const damage = Math.max(0, this.attackValue - this.defenseValue);
                title = `-${damage}`;
                message = '';
                isSuccess = true;
                break;
            }
            case CombatState.GetHit: {
                const damageTaken = Math.max(0, this.attackValue - this.defenseValue);
                title = `-${damageTaken}`;
                message = '';
                isSuccess = false;
                break;
            }
            case CombatState.GetMissed: {
                title = this.translate.instant('combat.notif_dodge_title');
                message = '';
                isSuccess = true;
                break;
            }
            case CombatState.FlightSuccess: {
                title = this.translate.instant('combat.notif_flight_title');
                message = this.translate.instant('combat.notif_flight_success');
                isSuccess = true;
                duration = NOTIFICATION_DURATION;
                break;
            }
            case CombatState.FlightFailure: {
                title = this.translate.instant('combat.notif_flight_title');
                message = this.translate.instant('combat.notif_flight_failure');
                isSuccess = false;
                duration = NOTIFICATION_DURATION;
                break;
            }
            case CombatState.Won: {
                if (this.wasFlightEnd) {
                    title = this.translate.instant('combat.notif_won_flight_title');
                    message = this.translate.instant('combat.notif_flight_success');
                    isSuccess = true;
                    duration = NOTIFICATION_DURATION;
                } else {
                    title = this.translate.instant('combat.notif_won_title');
                    message = this.translate.instant('combat.notif_won_message');
                    isSuccess = true;
                    duration = NOTIFICATION_DURATION;
                }
                this.isWinLossNotification = true;
                break;
            }
            case CombatState.Lost: {
                if (this.wasFlightEnd) {
                    title = this.translate.instant('combat.notif_lost_flight_title');
                    message = this.translate.instant('combat.notif_lost_flight_message', { name: this.enemy.name });
                    isSuccess = false;
                    duration = NOTIFICATION_DURATION;
                } else {
                    title = this.translate.instant('combat.notif_lost_title');
                    message = this.translate.instant('combat.notif_lost_message', { name: this.enemy.name });
                    isSuccess = false;
                    duration = NOTIFICATION_DURATION;
                }
                this.isWinLossNotification = true;
                break;
            }
            default:
                return;
        }

        this.displayNotification(title, message, isSuccess, duration);
    }

    private setCellReference(cell: Cell | null): void {
        this.cellReference = './assets/combat/placeholder.png';
        if (!cell) return;

        if (cell.tile.type === 'door') {
            this.cellReference = cell.tile.state === 'opened' ? './assets/combat/door_open.png' : './assets/combat/door_closed.png';
        }
    }
}

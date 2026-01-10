import { TitleCasePipe } from '@angular/common';
import { Component, EventEmitter, OnDestroy, OnInit, Output } from '@angular/core';
import { Cell } from '@app/classes/cell';
import { Item } from '@app/classes/item';
import { Player } from '@app/classes/player';
import { BonusType } from '@app/constants/bonus.constants';
import { ActionService } from '@app/services/action.service';
import { CombatService } from '@app/services/combat.service';
import { GameManagerService } from '@app/services/game-manager.service';
import { SocketService } from '@app/services/socket.service';
import { Subscription } from 'rxjs';
import { FEEDBACK_DURATION, NOTIFICATION_DURATION } from '@app/constants/combat.constants';

@Component({
    selector: 'app-combat',
    imports: [TitleCasePipe],
    templateUrl: './combat.component.html',
    styleUrl: './combat.component.scss',
})
export class CombatComponent implements OnInit, OnDestroy {
    @Output() combatMode = new EventEmitter<void>();

    selectedCell: Cell | null = null;
    cellReference: string = './assets/combat/placeholder.png';

    item: Item | null;

    showNotification: boolean = false;
    notificationTitle: string = '';
    notificationMessage: string = '';
    notificationSuccess: boolean = true;
    notificationTimeout: ReturnType<typeof setTimeout>;
    isWinLossNotification: boolean = false;

    private subscriptions: Subscription[] = [];

    constructor(
        private actionService: ActionService,
        private combatService: CombatService,
        private socketService: SocketService,
        private gameManager: GameManagerService,
    ) {}

    get flightAttempts() {
        return this.combatService.flightAttemptsLeft;
    }

    get isCombatPlayerTurn() {
        return this.combatService.isCombatPlayerTurn;
    }

    get isCombatMode(): boolean {
        return this.combatService.getCombatMode();
    }

    get isPlayerTurn(): boolean {
        return this.combatService.isPlayerTurn;
    }

    get player(): Player | undefined {
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
        return this.combatService.flightAttemptsLeft !== 0;
    }

    get isSelectionActive(): boolean {
        return this.actionService.getIsSelectionActive();
    }

    get canFight(): boolean {
        return this.combatService.canFight;
    }

    get canAct(): boolean {
        return this.combatService.canAct;
    }

    set attackValue(value: number) {
        this.combatService.attackValue = value;
    }

    set defenseValue(value: number) {
        this.combatService.defenseValue = value;
    }

    ngOnInit(): void {
        this.subscriptions.push(
            this.actionService.selectedCell$.subscribe((cell) => {
                this.selectedCell = cell;
                this.setCellReference(cell);
            }),
        );
        this.subscriptions.push(
            this.socketService.attackTrigger.subscribe(() => {
                this.attack();
            }),
        );
        this.subscriptions.push(
            this.combatService.combatStateChange.subscribe((state) => {
                this.showCombatNotification(state);
            }),
        );
    }

    ngOnDestroy(): void {
        this.subscriptions.forEach((sub) => sub.unsubscribe());
    }

    getEnemyStat(stat: string) {
        return this.combatService.getEnemy()?.stats[stat as BonusType].value;
    }

    setEnemy(player: Player | null) {
        this.combatService.setEnemy(player);
    }

    interact(): void {
        this.actionService.interact();
    }

    toggleSelection(): void {
        this.actionService.toggleSelection();
    }

    setCellReference(cell: Cell | null): void {
        this.cellReference = './assets/combat/placeholder.png';
        if (!cell) return;

        if (cell.tile.type === 'door') {
            this.cellReference = cell.tile.state === 'opened' ? './assets/combat/door_open.png' : './assets/combat/door_closed.png';
        }

        if (cell.player) {
            this.setEnemy(cell.player);
        }
    }

    startCombat() {
        if (!this.enemy) return;

        this.actionService.setSelectionActive(false);

        const startCombatInfo = this.combatService.startCombat(this.enemy);
        if (!startCombatInfo) return;

        this.socketService.startCombat(startCombatInfo);
    }

    attack() {
        if (this.enemy && this.player) {
            const isDebugging = this.gameManager.room.isDebugging;
            this.defenseValue = isDebugging ? this.enemy.rollStatDebug(BonusType.Defense) : this.enemy.rollStat(BonusType.Defense);
            this.attackValue = isDebugging ? this.player.rollStatDebug(BonusType.Attack) : this.player.rollStat(BonusType.Attack);
            const attackInfo = this.combatService.attack(this.attackValue, this.defenseValue);
            if (!attackInfo) return;
            this.socketService.attack(attackInfo);
        }
    }

    flight() {
        const flightInfo = this.combatService.flight();
        if (flightInfo) {
            this.socketService.flightAttempt(flightInfo);
        }
    }

    endTurn() {
        const gameRoomId = this.gameManager.getRoomId();
        this.socketService.endPlayerTurn(gameRoomId);
        this.displayNotification('Tour terminé', 'Votre tour est terminé', true);
    }

    displayNotification(title: string, message: string, isSuccess: boolean, duration: number = FEEDBACK_DURATION) {
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

    showCombatNotification(state: string) {
        if (!this.enemy || !this.player) return;
        let title = '';
        let message = '';
        let isSuccess = true;
        let duration = FEEDBACK_DURATION;

        this.isWinLossNotification = false;

        switch (state) {
            case 'miss': {
                title = 'Raté!';
                message = '';
                isSuccess = false;
                break;
            }
            case 'hit': {
                const damage = Math.max(0, this.attackValue - this.defenseValue);
                title = `-${damage}`;
                message = '';
                isSuccess = true;
                break;
            }
            case 'getHit': {
                const damageTaken = Math.max(0, this.attackValue - this.defenseValue);
                title = `-${damageTaken}`;
                message = '';
                isSuccess = false;
                break;
            }
            case 'getMissed': {
                title = 'Esquivé!';
                message = '';
                isSuccess = true;
                break;
            }
            case 'won': {
                title = 'Victoire!';
                message = `${this.player.name} a gagné le combat!`;
                isSuccess = true;
                duration = NOTIFICATION_DURATION;
                this.isWinLossNotification = true;
                break;
            }
            case 'lost': {
                title = 'Défaite';
                message = `${this.enemy.name} a gagné le combat!`;
                isSuccess = false;
                duration = NOTIFICATION_DURATION;
                this.isWinLossNotification = true;
                break;
            }
            default:
                return;
        }

        this.displayNotification(title, message, isSuccess, duration);
    }

    exitCombat() {
        this.combatService.setCombatMode(false);
        this.displayNotification('Combat terminé', 'Vous êtes sorti du combat', true);
    }

    resetCombat() {
        this.combatService.resetCombat();
        this.showNotification = false;
        this.isWinLossNotification = false;
        if (this.notificationTimeout) {
            clearTimeout(this.notificationTimeout);
        }
    }
}

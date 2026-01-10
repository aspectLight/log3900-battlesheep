import { Injectable } from '@angular/core';
import { Player } from '@app/classes/player';
import { BonusType } from '@app/constants/bonus.constants';
import { Subject } from 'rxjs';
import { GameManagerService } from './game-manager.service';
import { ANIMATION_DURATION, NOTIFICATION_DURATION, CombatState } from '@app/constants/combat.constants';
import { CombatPayload, CombatRoom, AttackResult, AttackPayload, FlightResult } from '@app/interfaces/payload';

@Injectable({
    providedIn: 'root',
})
export class CombatService {
    combatRoom: CombatRoom | null;
    combatStateChange: Subject<string> = new Subject<string>();
    isCombatMode: boolean = false;
    isCombatPlayerTurn: boolean = false;
    isCombatInitiator: boolean = false;
    enemy: Player | null;
    flightAttemptsLeft: number = 2;
    combatState: CombatState = CombatState.Idle;
    showResults: boolean = false;
    combatCountdown: Subject<number> = new Subject<number>();
    initialPlayerHealth: number;
    initialEnemyHealth: number;
    loserId: string;

    attackValue: number;
    defenseValue: number;

    canFight: boolean = false;
    canAct: boolean = false;

    wasFlightEnd: boolean = false;

    constructor(private gameManagerService: GameManagerService) {}

    get roomId(): string {
        return this.gameManagerService.getRoomId();
    }

    get combatRoomId(): string {
        if (!this.combatRoom) return '';
        return this.combatRoom.combatRoomId;
    }

    get isPlayerTurn(): boolean {
        return this.gameManagerService.isPlayerTurn;
    }

    setIsCombatPlayerTurn(bool: boolean) {
        this.isCombatPlayerTurn = bool;
    }

    setCombatRoom(combatRoom: CombatRoom) {
        this.combatRoom = combatRoom;
        let enemyId: string;
        if (this.isCombatPlayerTurn) enemyId = this.combatRoom.currentOpponentId;
        else enemyId = this.combatRoom.currentPlayerId;
        const enemy = this.gameManagerService.getPlayerById(enemyId);
        this.setEnemy(enemy);
        if (!this.enemy) return;
        this.setCombatMode(true);

        const mainPlayer = this.gameManagerService.getMainPlayer();
        if (mainPlayer) {
            this.initialPlayerHealth = mainPlayer.stats['health'].value;
        }
        this.initialEnemyHealth = this.enemy.stats['health'].value;
    }

    setEnemy(enemy: Player | null): void {
        this.enemy = enemy;
    }

    toggleCombatMode(): void {
        this.isCombatMode = !this.isCombatMode;
    }

    setCombatMode(bool: boolean) {
        this.isCombatMode = bool;
    }

    handleAttackResult(result: AttackResult) {
        if (!this.enemy) return;

        this.attackValue = result.attackValue;
        this.defenseValue = result.defenseValue;

        if (this.isCombatPlayerTurn) {
            if (result.isAttackSuccess) {
                this.hit();
                this.enemy.setStatValue(BonusType.Health, result.opponentHealthPoints);
            } else {
                this.miss();
            }
        } else {
            if (result.isAttackSuccess) {
                this.getHit();
                this.gameManagerService.setMainPlayerHealth(result.opponentHealthPoints);
            } else {
                this.getMissed();
            }
        }

        this.showResults = true;
        setTimeout(() => {
            this.showResults = false;
        }, NOTIFICATION_DURATION);
        this.wasFlightEnd = false;
    }

    showFlightResult(result: FlightResult) {
        if (this.isCombatPlayerTurn) {
            if (result.isSuccess) {
                this.flightSuccess();
            } else {
                this.flightFailure();
            }
        }
    }

    handleFlightResult(result: FlightResult) {
        if (this.isCombatPlayerTurn) {
            if (!result.isSuccess) {
                this.flightAttemptsLeft--;
            }
        }
        this.wasFlightEnd = true;
    }

    handleEnd(winnerId: string, loserId: string) {
        if (this.gameManagerService.getMainPlayer()?.id === winnerId) this.won();
        else {
            this.loserId = loserId;
            this.lost();
        }
        this.flightAttemptsLeft = 2;
        this.gameManagerService.combatLost(loserId);
    }

    resetStats() {
        const mainPlayer = this.gameManagerService.getMainPlayer();
        if (mainPlayer) {
            this.gameManagerService.setMainPlayerHealth(this.initialPlayerHealth);
        }
        if (this.enemy) {
            this.enemy.setStatValue(BonusType.Health, this.initialEnemyHealth);
        }
    }

    getEnemy(): Player | null {
        return this.enemy;
    }

    getCombatMode(): boolean {
        return this.isCombatMode;
    }

    startCombat(enemy: Player): CombatPayload | null {
        if (!enemy || !this.isPlayerTurn) {
            return null;
        }

        this.isCombatInitiator = true;

        return {
            roomId: this.roomId,
            opponentId: enemy.id,
        };
    }

    attack(attackValue: number, defenseValue: number): AttackPayload | null {
        if (!this.isCombatPlayerTurn || !this.enemy) {
            return null;
        }

        return {
            roomId: this.combatRoomId,
            attackValue,
            defenseValue,
        };
    }

    flight(): CombatPayload | null {
        if (!this.isCombatPlayerTurn || !this.enemy || !this.flightAttemptsLeft) return null;
        return {
            roomId: this.combatRoomId,
            opponentId: this.enemy.id,
        };
    }

    miss() {
        this.combatState = CombatState.Miss;
        this.combatStateChange.next(CombatState.Miss);
        setTimeout(() => {
            this.combatState = CombatState.Idle;
        }, ANIMATION_DURATION);
    }

    hit() {
        this.combatState = CombatState.Hit;
        this.combatStateChange.next(CombatState.Hit);
        setTimeout(() => {
            this.combatState = CombatState.Idle;
        }, ANIMATION_DURATION);
    }

    getHit() {
        this.combatState = CombatState.GetHit;
        this.combatStateChange.next(CombatState.GetHit);
        setTimeout(() => {
            this.combatState = CombatState.Idle;
        }, ANIMATION_DURATION);
    }

    getMissed() {
        this.combatState = CombatState.GetMissed;
        this.combatStateChange.next(CombatState.GetMissed);
        setTimeout(() => {
            this.combatState = CombatState.Idle;
        }, ANIMATION_DURATION);
    }

    flightSuccess() {
        this.combatState = CombatState.FlightSuccess;
        this.combatStateChange.next(CombatState.FlightSuccess);
        setTimeout(() => {
            this.resetCombat();
        }, NOTIFICATION_DURATION);
    }
    flightFailure() {
        this.combatState = CombatState.FlightFailure;
        this.combatStateChange.next(CombatState.FlightFailure);
        setTimeout(() => {
            this.combatState = CombatState.Idle;
        }, ANIMATION_DURATION);
    }

    lost() {
        this.combatState = CombatState.Lost;
        this.combatStateChange.next(CombatState.Lost);
        setTimeout(() => {
            this.resetCombat();
        }, NOTIFICATION_DURATION);
    }

    won() {
        this.combatState = CombatState.Won;
        this.combatStateChange.next(CombatState.Won);
        setTimeout(() => {
            this.resetCombat();
        }, NOTIFICATION_DURATION);
    }

    resetCombat() {
        this.combatState = CombatState.Idle;
        this.isCombatMode = false;
        this.resetStats();
        this.isCombatInitiator = false;
    }

    getVirtualPlayerAttack(playerAttacking: Player, playerDefending: Player, combatRoomId: string): AttackPayload {
        const isDebugging = this.gameManagerService.room.isDebugging;
        const defenseValue = isDebugging ? playerDefending.rollStatDebug(BonusType.Defense) : playerDefending.rollStat(BonusType.Defense);
        const attackValue = isDebugging ? playerAttacking.rollStatDebug(BonusType.Attack) : playerAttacking.rollStat(BonusType.Attack);
        const attackInfo: AttackPayload = {
            roomId: combatRoomId,
            attackValue,
            defenseValue,
        };
        return attackInfo;
    }
}

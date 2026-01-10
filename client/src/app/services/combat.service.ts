import { Injectable } from '@angular/core';
import { Player } from '@app/classes/player';
import { BonusType } from '@app/constants/bonus.constants';
import { Subject } from 'rxjs';
import { GameManagerService } from './game-manager.service';
import { ANIMATION_DURATION, NOTIFICATION_DURATION } from '@app/constants/combat.constants';
import { CombatPayload, CombatRoom, AttackResult, AttackPayload, FlightResult } from '@app/interfaces/payload';

@Injectable({
    providedIn: 'root',
})
export class CombatService {
    combatRoom: CombatRoom | null;
    combatStateChange: Subject<string> = new Subject<string>();
    isCombatMode: boolean = false;
    isCombatPlayerTurn: boolean = false;
    enemy: Player | null;
    flightAttemptsLeft: number = 2;
    combatState: 'idle' | 'miss' | 'hit' | 'getHit' | 'getMissed' | 'lost' | 'won' = 'idle';
    showResults: boolean = false;
    combatCountdown: Subject<number> = new Subject<number>();
    initialPlayerHealth: number;
    initialEnemyHealth: number;
    loserId: string;

    attackValue: number;
    defenseValue: number;

    canFight: boolean = false;
    canAct: boolean = false;

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

                // Check if enemy is defeated
                if (result.opponentHealthPoints <= 0) {
                    this.won();
                    return;
                }
            } else {
                this.miss();
            }
        } else {
            if (result.isAttackSuccess) {
                this.getHit();
                this.gameManagerService.setMainPlayerHealth(result.opponentHealthPoints);

                // Check if player is defeated
                if (result.opponentHealthPoints <= 0) {
                    this.lost();
                }
            } else {
                this.getMissed();
            }
        }

        this.showResults = true;
        setTimeout(() => {
            this.showResults = false;
        }, NOTIFICATION_DURATION); // Give more time to see the results
    }

    handleFlightResult(result: FlightResult) {
        if (this.isCombatPlayerTurn) {
            if (!result.isSuccess) {
                this.flightAttemptsLeft--;
            }
        }
    }

    handleEnd(winnerId: string) {
        if (this.gameManagerService.getMainPlayer()?.id === winnerId) this.won();
        else {
            this.lost();
            this.loserId = (this.gameManagerService.getMainPlayer() as Player).id;
        }
        this.flightAttemptsLeft = 2;
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
        this.combatState = 'miss';
        this.combatStateChange.next('miss');
        setTimeout(() => {
            this.combatState = 'idle';
        }, ANIMATION_DURATION);
    }

    hit() {
        this.combatState = 'hit';
        this.combatStateChange.next('hit');
        setTimeout(() => {
            this.combatState = 'idle';
        }, ANIMATION_DURATION);
    }

    getHit() {
        this.combatState = 'getHit';
        this.combatStateChange.next('getHit');
        setTimeout(() => {
            this.combatState = 'idle';
        }, ANIMATION_DURATION);
    }

    getMissed() {
        this.combatState = 'getMissed';
        this.combatStateChange.next('getMissed');
        setTimeout(() => {
            this.combatState = 'idle';
        }, ANIMATION_DURATION);
    }

    lost() {
        this.combatState = 'lost';
        this.combatStateChange.next('lost');
        setTimeout(() => {
            this.resetCombat();
        }, NOTIFICATION_DURATION);
    }

    won() {
        this.combatState = 'won';
        this.combatStateChange.next('won');
        setTimeout(() => {
            this.resetCombat();
        }, NOTIFICATION_DURATION);
    }

    resetCombat() {
        this.combatState = 'idle';
        this.isCombatMode = false;
        this.resetStats();
    }
}

/* eslint-disable max-lines */
import {
    COUNTDOWN_INTERVAL,
    EVASION_PTS,
    FLIGHT_CHANCES,
    MAX_TIME,
    MAX_TIME_WITHOUT_EVASION,
    MIN_TIME,
    TURN_DURATION,
    TURN_DURATION_WITHOUT_EVASION,
} from '@app/modules/combat/constants/game-combat.constants';
import { Combat } from '@app/modules/combat/interfaces/combat';
import { GameMovementService } from '@app/modules/movement/services/game-movement.service';
import { GameRoom } from '@app/modules/shared-room/interfaces/game-room';
import { GameRoomService } from '@app/modules/shared-room/services/game-room.service';
import { BonusType, Player } from '@app/shared/interfaces/player';
import { DiceService } from '@app/shared/services/dice.service';
import { ErrorMessages } from '@common/error-messages.constants';
import { GameRoomEvents } from '@common/socket.constants';
import { Injectable, Logger } from '@nestjs/common';
import { Server } from 'socket.io';
@Injectable()
export class GameCombatService {
    private readonly logger = new Logger(GameCombatService.name);
    private activeCombats: Combat[] = [];
    private server: Server;
    private generalRoom: GameRoom;
    private combatLocks: Map<string, boolean> = new Map();

    constructor(
        private gameRoomService: GameRoomService,
        private diceService: DiceService,
        private gameMovementService: GameMovementService,
    ) {}

    setServer(server: Server) {
        this.server = server;
    }

    startCombat(associatedRoomId: string, combatRoomId: string, players: Player[], attackerId: string, defenderId: string): void {
        const attacker = players.find((player) => player.id === attackerId);
        const defender = players.find((player) => player.id === defenderId);

        const currentPlayerId = attacker.stats['speed'].value >= defender.stats['speed'].value ? attacker.id : defender.id;
        const currentOpponentId = currentPlayerId === attackerId ? defender.id : attacker.id;
        const newCombat: Combat = {
            associatedRoomId,
            combatRoomId,
            players,
            attackerId,
            defenderId,
            currentPlayerId,
            currentOpponentId,
            turnTimer: undefined,
            attackerHealthPts: attacker.stats['health'].value,
            defenderHealthPts: defender.stats['health'].value,
        };
        newCombat.players.forEach((player) => (player.evasionPoints = EVASION_PTS));
        this.activeCombats.push(newCombat);
        if (!(attacker.isVirtual && defender.isVirtual)) {
            this.server.to(combatRoomId).emit(GameRoomEvents.CombatTurnStarted, newCombat);
        }
        this.startTurn(newCombat.combatRoomId);
    }

    startTurn(combatId: string): void {
        const currentRoom = this.findCombatRoomById(combatId);
        if (!currentRoom) {
            throw new Error(ErrorMessages.CombatDoesNotExist);
        }
        const combatRoomId = currentRoom.combatRoomId;
        const currentPlayer = this.findPlayerById(combatId, currentRoom.currentPlayerId);
        const playerInitialHealth = this.isCurrentPlayerAttacker(combatId) ? currentRoom.attackerHealthPts : currentRoom.defenderHealthPts;

        const turnDuration = currentPlayer.evasionPoints > 0 ? TURN_DURATION : TURN_DURATION_WITHOUT_EVASION;
        let countdown = turnDuration;
        const randomDelay = currentPlayer.isVirtual && currentPlayer.evasionPoints > 0 ? this.getRandomDelay(true) : this.getRandomDelay(false);

        // Capture currentTimerId locally so the closure can verify it is still the active timer.
        // This prevents ghost timers from interfering when a new turn starts before this one
        // is fully cleaned up (race condition with setInterval callbacks).
        let currentTimerId: ReturnType<typeof setInterval> | undefined;
        currentTimerId = setInterval(() => {
            const combat = this.findCombatRoomById(combatId);
            if (!combat) {
                this.logger.warn(`[${combatId}] 🔴 Timer callback - combat not found, clearing timer ${currentTimerId}`);
                clearInterval(currentTimerId);
                return;
            }

            // Guard: if currentRoom.turnTimer no longer points to this timer, we are a stale
            // ghost callback — self-terminate without touching the active timer.
            if (currentRoom.turnTimer !== currentTimerId) {
                this.logger.warn(
                    `[${combatId}] 👻 Ghost timer detected - currentTimerId=${currentTimerId}, active turnTimer=${currentRoom.turnTimer}. Stopping ghost.`,
                );
                clearInterval(currentTimerId);
                return;
            }

            this.logger.log(
                `[${combatId}] ⏱️  Timer tick - countdown=${countdown}, turnTimer=${currentRoom.turnTimer}, ` +
                    `player=${currentPlayer.name}, isVirtual=${currentPlayer.isVirtual}, randomDelay=${randomDelay}`,
            );
            this.server.to(combatRoomId).emit(GameRoomEvents.UpdateCombatCountDown, countdown);
            countdown--;
            if (countdown < 0 || (currentPlayer.isVirtual && countdown === randomDelay)) {
                this.logger.log(`[${combatId}] 🛑 Timer stopping condition met - countdown=${countdown}, stopping timer ${currentTimerId}`);
                clearInterval(currentTimerId);

                if (!this.findCombatRoomById(combatId)) {
                    currentRoom.turnTimer = undefined;
                    return;
                }

                const executeAction = async () => {
                    try {
                        if (currentPlayer.isVirtual) {
                            if (
                                currentPlayer.profile === 'defensive' &&
                                currentPlayer.stats['health'].value < playerInitialHealth &&
                                currentPlayer.evasionPoints > 0
                            ) {
                                await this.attemptFlight(combatId);
                            } else {
                                await this.attack(combatId);
                            }
                        } else {
                            // Real player did not act in time — auto-attack on their behalf
                            await this.attack(combatId);
                        }
                    } catch (err) {
                        this.logger.error(`[${combatId}] Unhandled error in timer action: ${err?.message ?? err}`);
                    }
                };
                executeAction();
            }
        }, COUNTDOWN_INTERVAL);
        currentRoom.turnTimer = currentTimerId;
        this.logger.log(`[${combatId}] ✅ Timer created: ${currentRoom.turnTimer} for player ${currentPlayer.name}`);
    }

    async attack(combatId: string): Promise<void> {
        this.logger.log(`[${combatId}] ⚔️ ATTACK action requested - attempting to acquire lock`);
        if (!this.acquireLock(combatId)) {
            this.logger.error(`[${combatId}] ❌ ATTACK failed - lock acquisition refused`);
            return;
        }

        try {
            const currentRoom = this.findCombatRoomById(combatId);

            if (!currentRoom) {
                return;
            }

            if (currentRoom.turnTimer) {
                clearInterval(currentRoom.turnTimer);
            }
            currentRoom.turnTimer = undefined;

            const currentPlayer = this.findPlayerById(combatId, currentRoom.currentPlayerId);
            const currentOpponent = this.findPlayerById(combatId, currentRoom.currentOpponentId);

            const associatedRoom = this.gameRoomService.findRoomById(currentRoom.associatedRoomId);
            const gameId = associatedRoom.gameId;

            const playerCell = currentPlayer.position
                ? this.gameMovementService.getCell(currentRoom.associatedRoomId, currentPlayer.position.x, currentPlayer.position.y)
                : null;

            const opponentCell = currentOpponent.position
                ? this.gameMovementService.getCell(currentRoom.associatedRoomId, currentOpponent.position.x, currentOpponent.position.y)
                : null;

            const playerTileType = playerCell?.tile?.type || 'snow';
            const opponentTileType = opponentCell?.tile?.type || 'snow';

            const rooms = this.gameRoomService.findRoomsByPlayerId(currentPlayer.id);
            const isDebug = rooms.length > 0 ? rooms[0].isDebugging : false;

            const attackValue = isDebug
                ? this.diceService.rollStatDebug(currentPlayer, BonusType.Attack, playerTileType)
                : this.diceService.rollStat(currentPlayer, BonusType.Attack, playerTileType);

            const defenseValue = isDebug
                ? this.diceService.rollStatDebug(currentOpponent, BonusType.Defense, opponentTileType)
                : this.diceService.rollStat(currentOpponent, BonusType.Defense, opponentTileType);

            const attackResult = attackValue - defenseValue;
            const damage = Math.max(0, attackResult);

            if (attackResult > 0) {
                currentOpponent.stats['health'].value -= damage;
                // Re-evaluate propaganda: the buff activates when health drops below the threshold
                this.gameRoomService.reevaluatePropaganda(currentOpponent);
            }

            const room = this.gameRoomService.findRoomById(currentRoom.associatedRoomId);
            const attackerStats = room.playersStats.find((p) => p.name === currentPlayer.name);
            const opponentStats = room.playersStats.find((p) => p.name === currentOpponent.name);
            if (attackerStats) attackerStats.damage += damage;
            if (opponentStats) opponentStats.healthLost += damage;

            this.server.to(currentRoom.combatRoomId).emit(GameRoomEvents.AttackResult, {
                isAttackSuccess: attackResult > 0,
                opponentHealthPoints: currentOpponent.stats['health'].value,
                attackValue,
                defenseValue,
            });

            this.prepareNextTurn(combatId);
        } finally {
            this.releaseLock(combatId);
        }
    }

    async attemptFlight(combatId: string): Promise<void> {
        this.logger.log(`[${combatId}] 🏃 FLIGHT action requested - attempting to acquire lock`);
        if (!this.acquireLock(combatId)) {
            this.logger.error(`[${combatId}] ❌ FLIGHT failed - lock acquisition refused`);
            return;
        }

        try {
            const currentRoom = this.findCombatRoomById(combatId);

            if (!currentRoom) {
                return;
            }

            if (currentRoom.turnTimer) {
                clearInterval(currentRoom.turnTimer);
            }
            currentRoom.turnTimer = undefined;

            const currentPlayer = this.findPlayerById(combatId, currentRoom.currentPlayerId);

            // Barbed wire: if the attacker (instigator) has barbed wire, the defender cannot flee
            if (currentPlayer.id !== currentRoom.attackerId) {
                const attacker = this.findPlayerById(combatId, currentRoom.attackerId);
                const attackerHasBarbedWire = attacker.inventory?.some((i) => i?.type === 'barbedWire');
                if (attackerHasBarbedWire) {
                    currentPlayer.evasionPoints -= 1;
                    this.server
                        .to(currentRoom.combatRoomId)
                        .emit(GameRoomEvents.FlightAttemptResult, { isSuccess: false, attackerEvasionPoints: currentPlayer.evasionPoints });
                    this.prepareNextTurn(combatId);
                    return;
                }
            }

            const flightSuccess = Math.random() <= FLIGHT_CHANCES;
            if (flightSuccess) {
                const room = this.gameRoomService.findRoomById(currentRoom.associatedRoomId);
                const playerStats = room.playersStats.find((p) => p.name === currentPlayer.name);
                if (playerStats) playerStats.evasions++;
                this.server
                    .to(currentRoom.combatRoomId)
                    .emit(GameRoomEvents.FlightAttemptResult, { isSuccess: true, attackerEvasionPoints: currentPlayer.evasionPoints });
                this.endCombat(combatId, true);
                return;
            } else {
                currentPlayer.evasionPoints -= 1;
                this.server
                    .to(currentRoom.combatRoomId)
                    .emit(GameRoomEvents.FlightAttemptResult, { isSuccess: false, attackerEvasionPoints: currentPlayer.evasionPoints });
            }

            this.prepareNextTurn(combatId);
        } finally {
            this.releaseLock(combatId);
        }
    }

    prepareNextTurn(combatId: string): void {
        const currentRoom = this.findCombatRoomById(combatId);
        const currentOpponent = this.findPlayerById(combatId, currentRoom.currentOpponentId);
        if (currentRoom?.turnTimer) {
            clearInterval(currentRoom.turnTimer);
            currentRoom.turnTimer = undefined;
        }
        if (currentOpponent.stats['health'].value <= 0) {
            this.logger.log(`[${combatId}] 💀 Opponent defeated, ending combat`);
            this.endCombat(combatId, false);
            return;
        }
        const temp = currentRoom.currentPlayerId;
        currentRoom.currentPlayerId = currentRoom.currentOpponentId;
        currentRoom.currentOpponentId = temp;
        this.logger.log(`[${combatId}] 🔄 Switching turns, emitting CombatTurnStarted, then starting new turn`);
        this.server.to(currentRoom.combatRoomId).emit(GameRoomEvents.CombatTurnStarted, currentRoom);
        this.startTurn(combatId);
    }

    endCombat(combatId: string, isByFlight: boolean): void {
        const currentRoom = this.findCombatRoomById(combatId);

        if (currentRoom?.turnTimer) {
            clearInterval(currentRoom.turnTimer);
            currentRoom.turnTimer = undefined;
        }

        this.updateHealthPoints(combatId);
        const gameRoomId = currentRoom.associatedRoomId;
        this.server.to(gameRoomId).emit(GameRoomEvents.EndCombat, currentRoom.currentPlayerId, currentRoom.currentOpponentId, isByFlight);
        if (!this.isVirtualCombatOnly(combatId)) this.server.socketsLeave(currentRoom.combatRoomId);
        this.updateScore(combatId, currentRoom.currentPlayerId, currentRoom.attackerId, isByFlight, gameRoomId);

        const room = this.gameRoomService.findRoomById(currentRoom.associatedRoomId);
        const winner = currentRoom.players.find((player) => player.id === currentRoom.currentPlayerId);
        const loser = currentRoom.players.find((player) => player.id === currentRoom.currentOpponentId);
        if (!isByFlight) {
            const winnerStats = room.playersStats.find((p) => p.name === winner.name);
            const loserStats = room.playersStats.find((p) => p.name === loser.name);
            if (winnerStats) winnerStats.victories++;
            if (loserStats) loserStats.defeats++;
        }
    }

    abandonCombat(combatId: string, isByDeath: boolean): void {
        const currentRoom = this.findCombatRoomById(combatId);

        if (currentRoom?.turnTimer) {
            clearInterval(currentRoom.turnTimer);
            currentRoom.turnTimer = undefined;
        }

        this.server.to(currentRoom.combatRoomId).emit(GameRoomEvents.EndCombat, currentRoom.currentPlayerId, currentRoom.currentOpponentId, false);
        this.server.socketsLeave(currentRoom.combatRoomId);
        const room = this.gameRoomService.findRoomById(currentRoom.associatedRoomId);
        const winner = currentRoom.players.find((player) => player.id === currentRoom.currentPlayerId);
        const loser = currentRoom.players.find((player) => player.id === currentRoom.currentOpponentId);
        const winnerStats = room.playersStats.find((p) => p.name === winner.name);
        const loserStats = room.playersStats.find((p) => p.name === loser.name);
        if (winnerStats) winnerStats.victories++;
        if (loserStats) loserStats.defeats++;
        this.updateScore(combatId, currentRoom.currentOpponentId, currentRoom.attackerId, isByDeath);
    }

    updateScore(combatId: string, winnerId: string, attackerId: string, isByFlight: boolean, gameRoomId?: string) {
        const rooms = this.gameRoomService.findRoomsByPlayerId(winnerId);
        const resolvedGameRoomId = gameRoomId ?? (rooms.length > 0 ? rooms[0].roomId : undefined);
        if (!resolvedGameRoomId) {
            this.logger.error(`[${combatId}] ❌ updateScore - no room found for player ${winnerId}, cannot update score`);
            this.activeCombats = this.activeCombats.filter((r) => r.combatRoomId !== combatId);
            return;
        }
        const sourceRooms = rooms.length > 0 ? rooms : [];
        const winner = sourceRooms[0]?.players.find((p) => p.id === winnerId);
        const attacker = sourceRooms[0]?.players.find((p) => p.id === attackerId);
        this.activeCombats = this.activeCombats.filter((r) => r.combatRoomId !== combatId);
        if (isByFlight && attacker) {
            return attacker.isVirtual ? this.gameRoomService.endTurn(resolvedGameRoomId) : this.gameRoomService.resumeTurn(resolvedGameRoomId);
        }
        if (winner) winner.fightsWon = (winner.fightsWon ?? 0) + 1;
        this.server.to(resolvedGameRoomId).emit(GameRoomEvents.UpdateScore, { winnerId, fightsWon: winner?.fightsWon ?? 1 });
        if (winnerId === attackerId) {
            return winner?.isVirtual ? this.gameRoomService.endTurn(resolvedGameRoomId) : this.gameRoomService.resumeTurn(resolvedGameRoomId);
        } else {
            return this.gameRoomService.endTurn(resolvedGameRoomId);
        }
    }

    updateHealthPoints(combatId: string) {
        const currentRoom = this.findCombatRoomById(combatId);
        const attacker = this.findPlayerById(combatId, currentRoom.attackerId);
        attacker.stats['health'].value = currentRoom.attackerHealthPts;
        const defender = this.findPlayerById(combatId, currentRoom.defenderId);
        defender.stats['health'].value = currentRoom.defenderHealthPts;
        // After health is restored to pre-combat values, deactivate propaganda if health is now above threshold
        this.gameRoomService.reevaluatePropaganda(attacker);
        this.gameRoomService.reevaluatePropaganda(defender);
    }

    findCombatsByPlayerId(playerId: string): Combat[] {
        return this.activeCombats.filter((combat) => combat.attackerId === playerId || combat.defenderId === playerId);
    }

    startVirtualCombat(roomId: string, virtualPlayerId: string, opponentId: string, isVirtualPlayerStarter: boolean): void {
        this.gameRoomService.pauseTimer(roomId);
        this.generalRoom = this.gameRoomService.findRoomById(roomId);
        if (!this.generalRoom) {
            throw new Error("La salle n'existe pas");
        }
        const opponent = this.generalRoom.players.find((player) => player.id === opponentId);
        let attacker: Player;
        let defender: Player;
        if (isVirtualPlayerStarter) {
            attacker = this.generalRoom.players.find((player) => player.id === virtualPlayerId);
            defender = this.generalRoom.players.find((player) => player.id === opponentId);
        } else {
            attacker = this.generalRoom.players.find((player) => player.id === opponentId);
            defender = this.generalRoom.players.find((player) => player.id === virtualPlayerId);
        }
        const combatRoom = `combat_${roomId}`;
        const playersFighting = [attacker, defender];
        const attackerStats = this.generalRoom.playersStats.find((p) => p.name === attacker.name);
        const defenderStats = this.generalRoom.playersStats.find((p) => p.name === defender.name);
        if (attackerStats) attackerStats.combats++;
        if (defenderStats) defenderStats.combats++;
        if (!opponent.isVirtual) {
            const opponentSocket = this.server.sockets.sockets.get(opponentId);
            if (!opponentSocket) {
                throw new Error("L'adversaire n'est pas connecté");
            }
            opponentSocket.join(combatRoom);
        }
        this.startCombat(roomId, combatRoom, playersFighting, attacker.id, defender.id);
    }

    private findPlayerById(combatId: string, playerId: string): Player {
        const currentRoom = this.findCombatRoomById(combatId);
        return currentRoom.players.find((player) => player.id === playerId);
    }

    private findCombatRoomById(combatRoomId: string) {
        return this.activeCombats.find((room) => room.combatRoomId === combatRoomId);
    }

    private isVirtualCombatOnly(combatId: string): boolean {
        const currentRoom = this.findCombatRoomById(combatId);
        return currentRoom.players.every((player) => player.isVirtual);
    }

    private isCurrentPlayerAttacker(combatId: string): boolean {
        const currentRoom = this.findCombatRoomById(combatId);
        return currentRoom.currentPlayerId === currentRoom.attackerId;
    }

    private getRandomDelay(hasEvasionPoints: boolean): number {
        let maxTime: number;
        let minTime: number;
        if (hasEvasionPoints) {
            minTime = MIN_TIME;
            maxTime = MAX_TIME;
        } else {
            minTime = MIN_TIME;
            maxTime = MAX_TIME_WITHOUT_EVASION;
        }
        return Math.floor(Math.random() * (maxTime - minTime + 1));
    }

    private acquireLock(combatId: string): boolean {
        if (this.combatLocks.get(combatId)) {
            return false;
        }
        this.combatLocks.set(combatId, true);
        return true;
    }

    private releaseLock(combatId: string): void {
        this.combatLocks.delete(combatId);
    }
}

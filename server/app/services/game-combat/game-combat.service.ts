import { GameRoomEvents } from '@app/gateways/game-room/game-room.gateway.events';
import { Combat } from '@app/interfaces/combat';
import { Player } from '@app/interfaces/player';
import { GameRoomService } from '@app/services/game-room/game-room.service';
import { Injectable } from '@nestjs/common';
import { Server } from 'socket.io';

const TURN_DURATION = 5;
const TURN_DURATION_WITHOUT_EVASION = 3;
const COUNTDOWN_INTERVAL = 1000;
const FLIGHT_CHANCES = 0.3;
const EVASION_PTS = 2;
@Injectable()
export class GameCombatService {
    private attackerHealthPts: number;
    private defenderHealthPts: number;
    private activeCombats: Combat[] = [];
    private server: Server;

    constructor(private gameRoomService: GameRoomService) {}

    setServer(server: Server) {
        this.server = server;
    }

    startCombat(combatRoomId: string, players: Player[], attackerId: string, defenderId: string): void {
        const attacker = players.find((player) => player.id === attackerId);
        const defender = players.find((player) => player.id === defenderId);

        const currentPlayerId = attacker.stats['speed'].value >= defender.stats['speed'].value ? attacker.id : defender.id;
        const currentOpponentId = currentPlayerId === attackerId ? defender.id : attacker.id;
        this.attackerHealthPts = attacker.stats['health'].value;
        this.defenderHealthPts = defender.stats['health'].value;
        const newCombat: Combat = {
            combatRoomId,
            players,
            attackerId,
            defenderId,
            currentPlayerId,
            currentOpponentId,
            turnTimer: undefined,
        };
        newCombat.players.forEach((player) => (player.evasionPoints = EVASION_PTS));
        this.activeCombats.push(newCombat);
        this.server.to(combatRoomId).emit(GameRoomEvents.CombatTurnStarted, newCombat);
        this.startTurn(newCombat.combatRoomId);
    }

    startTurn(combatId: string): void {
        const currentRoom = this.findCombatRoomById(combatId);
        if (!currentRoom) {
            throw new Error("Le combat n'existe pas");
        }
        const combatRoomId = currentRoom.combatRoomId;
        const currentPlayerId = currentRoom.currentPlayerId;
        const currentPlayer = this.findPlayerById(combatId, currentRoom.currentPlayerId);

        const turnDuration = currentPlayer.evasionPoints > 0 ? TURN_DURATION : TURN_DURATION_WITHOUT_EVASION;

        let countdown = turnDuration;

        currentRoom.turnTimer = setInterval(() => {
            this.server.to(combatRoomId).emit(GameRoomEvents.UpdateCombatCountDown, countdown);
            countdown--;
            if (countdown < 0) {
                clearInterval(currentRoom.turnTimer);
                this.server.to(currentPlayerId).emit(GameRoomEvents.PerformAttack, combatRoomId);
            }
        }, COUNTDOWN_INTERVAL);
    }

    attack(combatId: string, attackValue: number, defenseValue: number): void {
        const currentRoom = this.findCombatRoomById(combatId);
        const currentOpponent = this.findPlayerById(combatId, currentRoom.currentOpponentId);

        const attackResult = attackValue - defenseValue;

        if (attackResult > 0) {
            currentOpponent.stats['health'].value -= attackResult;

            this.server.to(currentRoom.combatRoomId).emit(GameRoomEvents.AttackResult, {
                isAttackSuccess: true,
                opponentHealthPoints: currentOpponent.stats['health'].value,
                attackValue,
                defenseValue,
            });
        } else {
            this.server.to(currentRoom.combatRoomId).emit(GameRoomEvents.AttackResult, {
                isAttackSuccess: false,
                opponentHealthPoints: currentOpponent.stats['health'].value,
                attackValue,
                defenseValue,
            });
        }
        this.prepareNextTurn(combatId);
    }

    attemptFlight(combatId: string): void {
        const currentRoom = this.findCombatRoomById(combatId);
        const currentPlayer = this.findPlayerById(combatId, currentRoom.currentPlayerId);
        const flightSuccess = Math.random() <= FLIGHT_CHANCES;
        if (flightSuccess) {
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
    }

    prepareNextTurn(combatId: string): void {
        const currentRoom = this.findCombatRoomById(combatId);
        const currentOpponent = this.findPlayerById(combatId, currentRoom.currentOpponentId);
        if (currentRoom && currentRoom.turnTimer) {
            clearInterval(currentRoom.turnTimer);
            currentRoom.turnTimer = undefined;
            this.server.to(combatId).emit(GameRoomEvents.UpdateCombatCountDown, 0);
        }
        if (currentOpponent.stats['health'].value <= 0) {
            this.endCombat(combatId, false);
            return;
        }
        const temp = currentRoom.currentPlayerId;
        currentRoom.currentPlayerId = currentRoom.currentOpponentId;
        currentRoom.currentOpponentId = temp;

        this.server.to(currentRoom.combatRoomId).emit(GameRoomEvents.CombatTurnStarted, currentRoom);
        this.startTurn(combatId);
    }

    endCombat(combatId: string, isByFlight: boolean): void {
        this.updateHealthPoints(combatId);
        const currentRoom = this.findCombatRoomById(combatId);
        this.server.to(currentRoom.combatRoomId).emit(GameRoomEvents.EndCombat, currentRoom.currentPlayerId);
        this.server.socketsLeave(currentRoom.combatRoomId);
        this.updateScore(currentRoom.currentPlayerId, currentRoom.attackerId, isByFlight);
        this.activeCombats = this.activeCombats.filter((r) => r.combatRoomId !== combatId);
    }

    abandonCombat(combatId: string, isByDeath: boolean): void {
        const currentRoom = this.findCombatRoomById(combatId);
        this.server.to(currentRoom.combatRoomId).emit(GameRoomEvents.EndCombat, currentRoom.currentPlayerId);
        this.server.socketsLeave(currentRoom.combatRoomId);
        this.updateScore(currentRoom.currentOpponentId, currentRoom.attackerId, isByDeath);
    }

    updateScore(winnerId: string, attackerId: string, isByFlight: boolean) {
        const rooms = this.gameRoomService.findRoomsByPlayerId(winnerId);
        const gameRoomId = rooms[0].roomId;
        if (isByFlight) {
            this.gameRoomService.resumeTurn(gameRoomId);
            return;
        }
        this.server.to(gameRoomId).emit(GameRoomEvents.UpdateScore, winnerId);
        if (winnerId === attackerId) {
            this.gameRoomService.resumeTurn(gameRoomId);
        } else {
            this.gameRoomService.endTurn(gameRoomId);
        }
    }

    updateHealthPoints(combatId: string) {
        const currentRoom = this.findCombatRoomById(combatId);
        const attacker = this.findPlayerById(combatId, currentRoom.attackerId);
        attacker.stats['health'].value = this.attackerHealthPts;

        const defender = this.findPlayerById(combatId, currentRoom.defenderId);
        defender.stats['health'].value = this.defenderHealthPts;
    }

    findCombatsByPlayerId(playerId: string): Combat[] {
        return this.activeCombats.filter((combat) => combat.attackerId === playerId || combat.defenderId === playerId);
    }

    private findPlayerById(combatId: string, playerId: string): Player {
        const currentRoom = this.findCombatRoomById(combatId);
        return currentRoom.players.find((player) => player.id === playerId);
    }

    private findCombatRoomById(combatRoomId: string) {
        return this.activeCombats.find((room) => room.combatRoomId === combatRoomId);
    }
}

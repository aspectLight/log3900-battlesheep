import {
    COUNTDOWN_INTERVAL,
    EVASION_PTS,
    FLIGHT_CHANCES,
    TURN_DURATION,
    TURN_DURATION_WITHOUT_EVASION,
    MIN_TIME,
    MAX_TIME,
    MAX_TIME_WITHOUT_EVASION,
} from '@app/constants/game-combat.constants';
import { Combat } from '@app/interfaces/combat';
import { GameRoom } from '@app/interfaces/game-room';
import { Player } from '@app/interfaces/player';
import { GameRoomService } from '@app/services/game-room/game-room.service';
import { ErrorMessages } from '@common/error-messages.constants';
import { GameRoomEvents } from '@common/socket.constants';
import { Injectable } from '@nestjs/common';
import { Server } from 'socket.io';
@Injectable()
export class GameCombatService {
    private attackerHealthPts: number;
    private defenderHealthPts: number;
    private activeCombats: Combat[] = [];
    private server: Server;
    private generalRoom: GameRoom;

    constructor(private gameRoomService: GameRoomService) {}

    setServer(server: Server) {
        this.server = server;
    }

    startCombat(associatedRoomId: string, combatRoomId: string, players: Player[], attackerId: string, defenderId: string): void {
        const attacker = players.find((player) => player.id === attackerId);
        const defender = players.find((player) => player.id === defenderId);

        const currentPlayerId = attacker.stats['speed'].value >= defender.stats['speed'].value ? attacker.id : defender.id;
        const currentOpponentId = currentPlayerId === attackerId ? defender.id : attacker.id;
        this.attackerHealthPts = attacker.stats['health'].value;
        this.defenderHealthPts = defender.stats['health'].value;
        const newCombat: Combat = {
            associatedRoomId,
            combatRoomId,
            players,
            attackerId,
            defenderId,
            currentPlayerId,
            currentOpponentId,
            turnTimer: undefined,
        };
        const entry = {
            type: 'TOUS',
            content: `Début du combat ! ${defender.name} a été attaqué par ${attacker.name} !`,
            time: new Date().toLocaleTimeString('en-GB', {
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit',
                hour12: false,
            }),
        };
        this.gameRoomService.addJournalEntry(associatedRoomId, entry);
        this.server.to(associatedRoomId).emit(GameRoomEvents.AddJournalEntry, entry);
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
        const currentPlayerId = currentRoom.currentPlayerId;
        const currentOpponentId = currentRoom.currentOpponentId;
        const currentPlayer = this.findPlayerById(combatId, currentRoom.currentPlayerId);
        const isVirtualCombatOnly = this.isVirtualCombatOnly(combatId);
        const virtualAttackCalculatorId = isVirtualCombatOnly ? this.generalRoom.organisatorId : currentOpponentId;
        const playerInitialHealth = this.isCurrentPlayerAttacker(combatId) ? this.attackerHealthPts : this.defenderHealthPts;

        const turnDuration = currentPlayer.evasionPoints > 0 ? TURN_DURATION : TURN_DURATION_WITHOUT_EVASION;
        let countdown = turnDuration;
        const randomDelay = currentPlayer.isVirtual && currentPlayer.evasionPoints > 0 ? this.getRandomDelay(true) : this.getRandomDelay(false);
        currentRoom.turnTimer = setInterval(() => {
            this.server.to(combatRoomId).emit(GameRoomEvents.UpdateCombatCountDown, countdown);
            countdown--;
            if (countdown < 0 || (currentPlayer.isVirtual && countdown === randomDelay)) {
                clearInterval(currentRoom.turnTimer);
                if (currentPlayer.isVirtual) {
                    if (
                        currentPlayer.profile === 'defensive' &&
                        currentPlayer.stats['health'].value < playerInitialHealth &&
                        currentPlayer.evasionPoints > 0
                    ) {
                        this.attemptFlight(combatId);
                    } else {
                        this.server
                            .to(virtualAttackCalculatorId)
                            .emit(GameRoomEvents.CalculateVirtualPlayerAttack, isVirtualCombatOnly, currentPlayerId, currentOpponentId, combatRoomId);
                    }
                } else {
                    this.server.to(currentPlayerId).emit(GameRoomEvents.PerformAttack, combatRoomId);
                }
            }
        }, COUNTDOWN_INTERVAL);
    }

    attack(combatId: string, attackValue: number, defenseValue: number): void {
        const currentRoom = this.findCombatRoomById(combatId);
        const currentOpponent = this.findPlayerById(combatId, currentRoom.currentOpponentId);
        const currentPlayer = this.findPlayerById(combatId, currentRoom.currentPlayerId);
        const attackResult = attackValue - defenseValue;
        const room = this.gameRoomService.findRoomById(currentRoom.associatedRoomId);

        room.playersStats.forEach((player) => {
            if (player.name === currentPlayer.name) {
                player.damage += attackResult;
            } else if (player.name === currentOpponent.name) {
                player.healthLost += attackResult;
            }
        });

        const entry = {
            type: 'COMBAT',
            content: `${currentPlayer.name} à ${attackResult > 0 ? 'réussi' : 'échoue'} a attaquer ${
                currentOpponent.name
            } ! ${attackValue} contre ${defenseValue} !`,
            time: new Date().toLocaleTimeString('en-GB', {
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit',
                hour12: false,
            }),
        };
        this.gameRoomService.addJournalEntry(currentRoom.associatedRoomId, entry);
        this.server.to(currentRoom.combatRoomId).emit(GameRoomEvents.AddJournalEntry, entry);

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
        const entry = {
            type: 'COMBAT',
            content: `Tentative de fuite ! ${currentPlayer.name} à ${flightSuccess ? 'réussi' : 'échoue'} à s'échapper!`,
            time: new Date().toLocaleTimeString('en-GB', {
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit',
                hour12: false,
            }),
        };
        this.gameRoomService.addJournalEntry(currentRoom.associatedRoomId, entry);
        this.server.to(currentRoom.combatRoomId).emit(GameRoomEvents.AddJournalEntry, entry);
        if (flightSuccess) {
            const room = this.gameRoomService.findRoomById(currentRoom.associatedRoomId);
            room.playersStats.forEach((player) => {
                if (player.name === currentPlayer.name) {
                    player.evasions++;
                }
            });
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
        const rooms = this.gameRoomService.findRoomsByPlayerId(currentRoom.currentPlayerId);
        const gameRoomId = rooms[0].roomId;
        this.server.to(gameRoomId).emit(GameRoomEvents.EndCombat, currentRoom.currentPlayerId, currentRoom.currentOpponentId);
        if (!this.isVirtualCombatOnly(combatId)) this.server.socketsLeave(currentRoom.combatRoomId);
        this.updateScore(combatId, currentRoom.currentPlayerId, currentRoom.attackerId, isByFlight);

        const room = this.gameRoomService.findRoomById(currentRoom.associatedRoomId);
        const winner = currentRoom.players.find((player) => player.id === currentRoom.currentPlayerId);
        const loser = currentRoom.players.find((player) => player.id === currentRoom.currentOpponentId);
        room.playersStats.forEach((player) => {
            if (player.name === winner.name) {
                player.victories++;
            } else if (player.name === loser.name) {
                player.defeats++;
            }
        });
    }

    abandonCombat(combatId: string, isByDeath: boolean): void {
        const currentRoom = this.findCombatRoomById(combatId);
        this.server.to(currentRoom.combatRoomId).emit(GameRoomEvents.EndCombat, currentRoom.currentPlayerId);
        this.server.socketsLeave(currentRoom.combatRoomId);
        const room = this.gameRoomService.findRoomById(currentRoom.associatedRoomId);
        const winner = currentRoom.players.find((player) => player.id === currentRoom.currentPlayerId);
        const loser = currentRoom.players.find((player) => player.id === currentRoom.currentOpponentId);
        room.playersStats.forEach((player) => {
            if (player.name === winner.name) {
                player.victories++;
            } else if (player.name === loser.name) {
                player.defeats++;
            }
        });
        this.updateScore(combatId, currentRoom.currentOpponentId, currentRoom.attackerId, isByDeath);
    }

    updateScore(combatId: string, winnerId: string, attackerId: string, isByFlight: boolean) {
        const rooms = this.gameRoomService.findRoomsByPlayerId(winnerId);
        const winner = rooms[0].players.find((p) => p.id === winnerId);
        const attacker = rooms[0].players.find((p) => p.id === attackerId);
        const gameRoomId = rooms[0].roomId;
        this.activeCombats = this.activeCombats.filter((r) => r.combatRoomId !== combatId);
        if (isByFlight && attacker) {
            return attacker.isVirtual ? this.gameRoomService.endTurn(gameRoomId) : this.gameRoomService.resumeTurn(gameRoomId);
        }
        this.server.to(gameRoomId).emit(GameRoomEvents.UpdateScore, winnerId);
        if (winnerId === attackerId) {
            return winner.isVirtual ? this.gameRoomService.endTurn(gameRoomId) : this.gameRoomService.resumeTurn(gameRoomId);
        } else {
            return this.gameRoomService.endTurn(gameRoomId);
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
}

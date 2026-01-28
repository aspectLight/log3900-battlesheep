import { GameCombatService } from '@app/modules/combat/services/game-combat.service';
import { GameRoomService } from '@app/modules/shared-room/services/game-room.service';
import { ErrorMessages } from '@common/error-messages.constants';
import { GameRoomEvents } from '@common/socket.constants';
import { Injectable, Logger } from '@nestjs/common';
import { Server, Socket } from 'socket.io';

/**
 * Handler for combat-related events in the game room
 */
@Injectable()
export class CombatHandler {
    private readonly logger = new Logger(CombatHandler.name);

    constructor(
        private readonly gameRoomService: GameRoomService,
        private readonly gameCombatService: GameCombatService,
    ) {}

    /**
     * Handles combat initiation between players
     */
    handleStartFight(data: { roomId: string; opponentId: string }, socket: Socket, server: Server): { success: boolean; error?: string } {
        try {
            this.gameCombatService.setServer(server);
            const generalRoom = this.gameRoomService.findRoomById(data.roomId);
            if (!generalRoom) throw new Error(ErrorMessages.RoomDoesNotExist);

            const combatStarter = generalRoom.players.find((player) => player.id === socket.id);
            const combatRoom = `combat_${data.roomId}`;
            const opponentSocket = server.sockets.sockets.get(data.opponentId);
            const opponent = generalRoom.players.find((player) => player.id === data.opponentId);
            const playersFighting = [combatStarter, opponent];

            if (opponent.isVirtual) {
                this.gameCombatService.startVirtualCombat(data.roomId, data.opponentId, socket.id, false);
                return { success: true };
            }

            const starterStats = generalRoom.playersStats.find((p) => p.name === combatStarter.name);
            const opponentStats = generalRoom.playersStats.find((p) => p.name === opponent.name);
            if (starterStats) starterStats.combats++;
            if (opponentStats) opponentStats.combats++;

            this.gameRoomService.pauseTimer(data.roomId);
            socket.join(combatRoom);
            opponentSocket.join(combatRoom);
            this.gameCombatService.startCombat(data.roomId, combatRoom, playersFighting, socket.id, data.opponentId);

            return { success: true };
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
            return { success: false, error: error.message };
        }
    }

    /**
     * Handles attack action in combat
     */
    async handleAttack(data: { roomId: string }, socket: Socket): Promise<{ success: boolean; error?: string }> {
        try {
            this.logger.log(`[${data.roomId}] Attack attempt`);
            await this.gameCombatService.attack(data.roomId);
            return { success: true };
        } catch (error) {
            this.logger.error(`[${data.roomId}] Attack error: ${error.message}`);
            socket.emit(GameRoomEvents.GameRoomError, error.message);
            return { success: false, error: error.message };
        }
    }

    /**
     * Handles flight attempt in combat
     */
    async handleFlightAttempt(roomId: string, socket: Socket): Promise<{ success: boolean; error?: string }> {
        try {
            await this.gameCombatService.attemptFlight(roomId);
            return { success: true };
        } catch (error) {
            this.logger.error(`[${roomId}] Flight error: ${error.message}`);
            socket.emit(GameRoomEvents.GameRoomError, error.message);
            return { success: false, error: error.message };
        }
    }

    /**
     * Handles virtual player combat initiation
     */
    handleStartVirtualCombat(data: { roomId: string; playerId: string; opponentId: string }, socket: Socket, server: Server): void {
        try {
            this.gameCombatService.setServer(server);
            this.gameCombatService.startVirtualCombat(data.roomId, data.playerId, data.opponentId, true);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }
}

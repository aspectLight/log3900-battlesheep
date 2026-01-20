import { GameCombatService } from '@app/modules/combat/services/game-combat.service';
import { GameMovementService } from '@app/modules/movement/services/game-movement.service';
import { GameRoomService } from '@app/modules/shared-room/services/game-room.service';
import { GameRoomEvents } from '@common/socket.constants';
import { Injectable, Logger } from '@nestjs/common';
import { Server, Socket } from 'socket.io';

/**
 * Handler for player connection lifecycle events (join, leave, disconnect)
 */
@Injectable()
export class PlayerConnectionHandler {
    private readonly logger = new Logger(PlayerConnectionHandler.name);

    constructor(
        private readonly gameRoomService: GameRoomService,
        private readonly gameCombatService: GameCombatService,
        private readonly gameMovementService: GameMovementService,
    ) {}

    /**
     * Handles player leaving the game room
     */
    handleLeaveRoom(roomId: string, socket: Socket, server: Server): void {
        this.logger.log(`${GameRoomEvents.AbandonGame} called by ${socket.id}`);
        try {
            this.handlePlayerAbandonment(roomId, socket.id, server);
            socket.emit(GameRoomEvents.GameAbandoned);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    /**
     * Handles player disconnection
     */
    handleDisconnect(socket: Socket, server: Server): void {
        this.logger.log(`socket déconnecté: ${socket.id}`);
        try {
            const rooms = this.gameRoomService.findRoomsByPlayerId(socket.id);
            const combatRooms = this.gameCombatService.findCombatsByPlayerId(socket.id);

            if (combatRooms && combatRooms.length > 0) {
                combatRooms.forEach((combat) => {
                    this.gameCombatService.abandonCombat(combat.combatRoomId, true);
                });
            }

            rooms.forEach((room) => {
                if (room && room.roomId) {
                    this.handlePlayerAbandonment(room.roomId, socket.id, server);
                }
            });
        } catch (error) {
            this.logger.log(`Error handling disconnect for ${socket.id}: ${error.message}`);
        }
    }

    /**
     * Handles player abandonment logic (private helper)
     */
    private handlePlayerAbandonment(roomId: string, playerId: string, server: Server): boolean {
        const combatRooms = this.gameCombatService.findCombatsByPlayerId(playerId);
        if (combatRooms && combatRooms.length > 0) {
            combatRooms.forEach((combat) => this.gameCombatService.endCombat(combat.combatRoomId, false));
        }

        this.gameRoomService.dropItemsWhenDisconnected(roomId, playerId);
        this.gameMovementService.removePlayerFromBoard(playerId);

        if (this.gameRoomService.isHost(roomId, playerId)) {
            server.to(roomId).emit(GameRoomEvents.DebugModeDisabled);
            this.gameRoomService.changehost(roomId);
        }

        if (this.gameRoomService.isPlayerTurn(roomId, playerId)) {
            this.gameRoomService.endTurn(roomId);
        }

        const isRoomDeleted = this.gameRoomService.abandonGame(roomId, playerId);
        if (isRoomDeleted) {
            server.to(roomId).emit(GameRoomEvents.GameCanceled);
        } else {
            server.to(roomId).emit(GameRoomEvents.PlayerAbandoned, playerId);
        }

        return isRoomDeleted;
    }
}

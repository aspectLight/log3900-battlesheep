import { GameCombatService } from '@app/modules/combat/services/game-combat.service';
import { MovementAlgorithmsService } from '@app/modules/movement/services/movement-algorithms.service';
import { MAX_TURN_DELAY, MIN_TURN_DELAY } from '@app/modules/shared-room/constants/game-room.constants';
import { GameRoomService } from '@app/modules/shared-room/services/game-room.service';
import { GameMovementVPService } from '@app/modules/virtual-players/services/game-movement-vp.service';
import { GameRoomEvents } from '@common/socket.constants';
import { Injectable } from '@nestjs/common';
import { Server, Socket } from 'socket.io';

/**
 * Handler for virtual player-related events in the game room
 */
@Injectable()
export class VirtualPlayerHandler {
    constructor(
        private readonly gameRoomService: GameRoomService,
        private readonly gameCombatService: GameCombatService,
        private readonly gameMovementVPService: GameMovementVPService,
        private readonly movementAlgorithms: MovementAlgorithmsService,
    ) {}

    /**
     * Handles virtual player turn logic
     */
    handleVirtualPlayerTurn(data: { roomId: string; playerId: string; isCTF: boolean; skipTimeout: boolean }, socket: Socket, server: Server): void {
        try {
            const room = this.gameRoomService.findRoomById(data.roomId);
            const player = room.players.find((p) => p.id === data.playerId);
            if (!player) return;

            setTimeout(
                () => {
                    const movement = this.gameMovementVPService.determineVPMovement(data.roomId, player, room.players, data.isCTF);
                    const neighborPlayer = this.movementAlgorithms.findNeighborPlayer(data.roomId, player);

                    if (movement.path.length <= 1) {
                        if (neighborPlayer && this.gameRoomService.isOpponent(player, neighborPlayer, data.isCTF)) {
                            this.gameCombatService.setServer(server);
                            return this.gameCombatService.startVirtualCombat(data.roomId, data.playerId, neighborPlayer.id, true);
                        } else {
                            return this.gameRoomService.endTurn(data.roomId);
                        }
                    } else {
                        if (neighborPlayer && this.gameRoomService.isOpponent(player, neighborPlayer, data.isCTF)) {
                            return server.to(data.roomId).emit(GameRoomEvents.VirtualPlayerMoved, {
                                ...movement,
                                playerId: data.playerId,
                                opponentPlayerId: neighborPlayer.id,
                            });
                        } else {
                            return server.to(data.roomId).emit(GameRoomEvents.VirtualPlayerMoved, { ...movement, playerId: data.playerId });
                        }
                    }
                },
                data.skipTimeout ? 0 : this.gameRoomService.getRandomDelay(MIN_TURN_DELAY, MAX_TURN_DELAY),
            );
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }
}

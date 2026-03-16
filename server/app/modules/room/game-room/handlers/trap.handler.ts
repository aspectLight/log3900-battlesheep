import { TileType } from '@app/modules/game/interfaces/tile';
import { GameMovementService } from '@app/modules/movement/services/game-movement.service';
import { GameRoomService } from '@app/modules/shared-room/services/game-room.service';
import { GameRoomEvents } from '@common/socket.constants';
import { Injectable, Logger } from '@nestjs/common';
import { Server } from 'socket.io';

const TRAP_AVOID_COST = 2;
const TRAP_ACTIVATION_CHANCE = 0.5;

/**
 * Handler for trap tile interaction logic
 */
@Injectable()
export class TrapHandler {
    private readonly logger = new Logger(TrapHandler.name);

    constructor(
        private readonly gameRoomService: GameRoomService,
        private readonly gameMovementService: GameMovementService,
    ) {}

    /**
     * Called after a player lands on a trap tile.
     * Sends TrapPending to the player's socket so they can choose their action.
     */
    handleTrapLanded(roomId: string, playerId: string, server: Server): void {
        const room = this.gameRoomService.findRoomById(roomId);
        const player = room.players.find((p) => p.id === playerId);
        if (!player) return;

        // Give the choice to the player only if he has enough movement points to avoid the trap
        // Otherwise the player automatically traverses the trap
        const canAvoid = player.movementPoints >= TRAP_AVOID_COST;

        server.to(playerId).emit(GameRoomEvents.TrapPending, {
            roomId,
            playerId,
            canAvoid,
        });
    }

    /**
     * Processes the player's trap choice (avoid or traverse).
     * Returns the result to broadcast.
     */
    handleTrapChoice(data: { roomId: string; playerId: string; choice: 'avoid' | 'traverse' }, server: Server): { success: boolean; error?: string } {
        try {
            const { roomId, playerId, choice } = data;
            const room = this.gameRoomService.findRoomById(roomId);
            const player = room.players.find((p) => p.id === playerId);
            if (!player) {
                return { success: false, error: 'Joueur introuvable' };
            }

            if (choice === 'avoid') {
                this.logger.log(`Le joueur ${player.name} a choisi d'éviter le piège`);
                if (player.movementPoints < TRAP_AVOID_COST) {
                    return { success: false, error: 'Points de mouvement insuffisants pour éviter le piège' };
                }
                player.movementPoints -= TRAP_AVOID_COST;

                server.to(roomId).emit(GameRoomEvents.TrapResult, {
                    roomId,
                    playerId,
                    choice: 'avoid',
                    activated: false,
                    remainingMovementPoints: player.movementPoints,
                });

                return { success: true };
            }

            this.logger.log(`Le joueur ${player.name} a choisi de traverser le piège`);

            const activated = Math.random() < TRAP_ACTIVATION_CHANCE;
            this.logger.log(`Le piège a été activé: ${activated}`);

            if (activated) {
                player.movementPoints = 0;
                player.actionPoints = 0;
            }

            server.to(roomId).emit(GameRoomEvents.TrapResult, {
                roomId,
                playerId,
                choice: 'traverse',
                activated,
                remainingMovementPoints: player.movementPoints,
            });

            return { success: true };
        } catch (error) {
            this.logger.error(`Erreur traitement piège: ${error.message}`);
            return { success: false, error: error.message };
        }
    }

    /**
     * Resolves trap for a virtual player automatically.
     * Defensive VPs avoid if they can, aggressive VPs always traverse.
     */
    resolveForVirtualPlayer(roomId: string, playerId: string, server: Server, profile?: string): void {
        const room = this.gameRoomService.findRoomById(roomId);
        const player = room.players.find((p) => p.id === playerId);
        if (!player) return;

        console.log('movement points', player.movementPoints);
        const canAvoid = player.movementPoints >= TRAP_AVOID_COST;
        console.log('canAvoid', canAvoid);
        console.log('profile', profile);
        const shouldAvoid = canAvoid && profile === 'defensive';
        console.log('shouldAvoid', shouldAvoid);

        const choice = shouldAvoid ? 'avoid' : 'traverse';
        this.handleTrapChoice({ roomId, playerId, choice }, server);
    }

    /**
     * Check if a cell at the given position is a trap tile
     */
    isTrapTile(roomId: string, x: number, y: number): boolean {
        const cell = this.gameMovementService.getCell(roomId, x, y);
        return cell?.tile?.type === TileType.Trap;
    }
}

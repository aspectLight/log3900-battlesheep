import { GameCombatService } from '@app/modules/combat/services/game-combat.service';
import { GameService } from '@app/modules/game/services/game.service';
import { GameMovementService } from '@app/modules/movement/services/game-movement.service';
import { SIZE_LIMITS } from '@app/modules/shared-room/constants/waiting-room.constants';
import { GameRoomService } from '@app/modules/shared-room/services/game-room.service';
import { Player } from '@app/shared/interfaces/player';
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
        private readonly gameService: GameService,
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
     * Handles a player joining an in-progress game (drop-in)
     */
    async handleJoinGameRoom(
        data: { roomId: string; player?: Player; firebaseUid?: string },
        socket: Socket,
        server: Server,
    ): Promise<{ success: boolean; error?: string }> {
        try {
            const room = this.gameRoomService.findRoomById(data.roomId);
            if (!room) {
                return { success: false, error: "La partie n'existe pas" };
            }
            if (!room.dropInDropOut) {
                return { success: false, error: "Le drop-in n'est pas activé pour cette partie" };
            }

            // Returning player identified only by firebaseUid (no character creation)
            if (data.firebaseUid && !data.player) {
                const abandonedEntry = room.abandonedPlayers.find((ap) => ap.firebaseUid === data.firebaseUid);
                if (!abandonedEntry) {
                    return { success: false, error: 'Player not found in abandoned players list' };
                }
                data.player = { ...abandonedEntry.player, firebaseUid: data.firebaseUid };
            }

            if (!data.player) {
                return { success: false, error: 'Missing player data' };
            }

            const game = await this.gameService.getGameById(room.gameId);
            const maxPlayers = SIZE_LIMITS[game.board.size] || 2;

            const result = this.gameRoomService.addPlayerToGame(data.roomId, data.player, socket.id, maxPlayers);

            // Spawn the player on the board, excluding the joining player so their
            // own (not-yet-set) spawnPoint doesn't interfere with the free-spot search
            const otherPlayers = room.players.filter((p) => p.id !== result.player.id);
            this.gameMovementService.spawnSinglePlayer(data.roomId, result.player, otherPlayers);

            // Join socket room
            socket.join(data.roomId);

            // Notify existing players
            server.to(data.roomId).emit(GameRoomEvents.PlayerJoinedGame, {
                player: result.player,
                isReturning: result.isReturning,
                players: room.players,
            });

            // Send full game state to the joining player
            // eslint-disable-next-line @typescript-eslint/no-unused-vars
            const { turnTimer, abandonedPlayers, ...serializableRoom } = room;
            socket.emit(GameRoomEvents.JoinGameRoomResponse, {
                success: true,
                gameRoom: serializableRoom,
                currentBoard: this.gameMovementService.getBoardForGame(data.roomId),
                isReturning: result.isReturning,
                currentPlayerId: room.players[0]?.id ?? null,
            });

            this.logger.log(`Joueur ${socket.id} a rejoint la partie ${data.roomId} (${result.isReturning ? 'retour' : 'nouveau'})`);

            return { success: true };
        } catch (error) {
            this.logger.error(`Erreur drop-in: ${error.message}`);
            return { success: false, error: error.message };
        }
    }

    /**
     * Handles player abandonment logic (private helper)
     */
    private handlePlayerAbandonment(roomId: string, playerId: string, server: Server): boolean {
        const room = this.gameRoomService.findRoomById(roomId);
        const combatRooms = this.gameCombatService.findCombatsByPlayerId(playerId);
        if (combatRooms && combatRooms.length > 0) {
            combatRooms.forEach((combat) => this.gameCombatService.endCombat(combat.combatRoomId, false));
        }

        this.gameRoomService.dropItemsWhenDisconnected(roomId, playerId);
        this.gameMovementService.removePlayerFromBoard(roomId, playerId);

        if (this.gameRoomService.isHost(roomId, playerId)) {
            server.to(roomId).emit(GameRoomEvents.DebugModeDisabled);
            this.gameRoomService.changeHost(roomId);
        }

        if (this.gameRoomService.isPlayerTurn(roomId, playerId)) {
            this.gameRoomService.endTurn(roomId);
        }

        const isRoomDeleted = this.gameRoomService.abandonGame(roomId, playerId);
        if (isRoomDeleted) {
            this.gameMovementService.removeBoard(roomId);
            server.to(roomId).emit(GameRoomEvents.GameCanceled, { playerId });
        } else {
            server.to(roomId).emit(GameRoomEvents.PlayerAbandoned, playerId);
        }

        return isRoomDeleted;
    }
}

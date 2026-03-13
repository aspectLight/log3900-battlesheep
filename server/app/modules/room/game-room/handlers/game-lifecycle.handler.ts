import { AuthService } from '@app/modules/auth/services/auth.service';
import { GameService } from '@app/modules/game/services/game.service';
import { CustomChannelService } from '@app/modules/general-chat/services/custom-channel.service';
import { GameMovementService } from '@app/modules/movement/services/game-movement.service';
import { MS_IN_SECOND, SECONDS_IN_MINUTE } from '@app/modules/shared-room/constants/game-room.constants';
import { GameRoom } from '@app/modules/shared-room/interfaces/game-room';
import { GameRoomService } from '@app/modules/shared-room/services/game-room.service';
import { CustomChannelEvents, GameRoomEvents } from '@common/socket.constants';
import { Injectable, Logger } from '@nestjs/common';
import { Server, Socket } from 'socket.io';

/**
 * Handler for game lifecycle events (start, finish, debug mode)
 */
@Injectable()
export class GameLifecycleHandler {
    private readonly logger = new Logger(GameLifecycleHandler.name);

    constructor(
        private readonly gameRoomService: GameRoomService,
        private readonly gameMovementService: GameMovementService,
        private readonly gameService: GameService,
        private readonly authService: AuthService,
        private readonly customChannelService: CustomChannelService,
    ) {}

    /**
     * Handles game start - spawns players and prepares first turn
     */
    async handlePlayGame(roomId: string, socket: Socket, server: Server): Promise<void> {
        try {
            const room = this.gameRoomService.findRoomById(roomId);
            room.players = await this.gameMovementService.addPlayersToBoard(roomId, room.gameId, room.players);
            server.to(roomId).emit(GameRoomEvents.PlayerSpawned, room.players);
            this.gameRoomService.setServer(server);
            this.gameRoomService.prepareNextTurn(roomId);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    /**
     * Handles game completion - calculates duration and notifies players
     */
    async handleFinishGame(data: { roomId: string; winnerId: string }, socket: Socket, server: Server): Promise<void> {
        try {
            const room = this.gameRoomService.findRoomById(data.roomId);
            const diffSeconds = Math.floor((Date.now() - room.startTime.getTime()) / MS_IN_SECOND);
            room.globalStats.gameDuration = `${String(Math.floor(diffSeconds / SECONDS_IN_MINUTE)).padStart(2, '0')}:${String(
                diffSeconds % SECONDS_IN_MINUTE,
            ).padStart(2, '0')}`;
            this.gameRoomService.pauseTimer(data.roomId);

            await this.updatePlayerStatistics(room, data.winnerId, diffSeconds);

            server.to(data.roomId).emit(GameRoomEvents.FinishGame, data.winnerId);
        } catch (error) {
            this.logger.error(`Error finishing game: ${error.message}`);
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    /**
     * Handles players leaving the end game screen
     */
    async handleLeaveEndGame(roomId: string, socket: Socket, server: Server): Promise<void> {
        try {
            const room = this.gameRoomService.findRoomById(roomId);
            socket.leave(roomId);

            // Faire quitter le canal de partie à ce joueur (channelId = roomId sans le préfixe "game_")
            const channelId = roomId.startsWith('game_') ? roomId.slice(5) : roomId;
            socket.leave(`custom-channel-${channelId}`);
            socket.emit(CustomChannelEvents.CustomChannelLeft, { channelId });

            if ((await server.in(roomId).fetchSockets()).length === 0) {
                if (room) this.gameMovementService.removeBoard(roomId);
                this.gameRoomService.deleteRoomById(roomId);

                // Supprimer définitivement le canal de partie
                try {
                    server.to(`custom-channel-${channelId}`).emit(CustomChannelEvents.CustomChannelDeleted, { channelId });
                    await this.customChannelService.deleteGameChannel(channelId);
                } catch (channelError) {
                    this.logger.error(`Erreur suppression canal de partie ${channelId}: ${channelError.message}`);
                }
            }
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    /**
     * Handles debug mode toggle
     */
    handleToggleDebugMode(roomId: string, socket: Socket, server: Server): void {
        try {
            const isDebugging = this.gameRoomService.toggleDebugMode(roomId);
            if (isDebugging) {
                server.to(roomId).emit(GameRoomEvents.DebugModeEnabled);
            } else {
                server.to(roomId).emit(GameRoomEvents.DebugModeDisabled);
            }
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    private async updatePlayerStatistics(room: GameRoom, winnerId: string, playtimeSeconds: number): Promise<void> {
        try {
            const game = await this.gameService.getGameById(room.gameId);
            const gameMode: 'Classique' | 'CTF' = game.mode === 'ctf' ? 'CTF' : 'Classique';

            const updatePromises = room.players
                .filter((player) => !player.isVirtual && player.firebaseUid)
                .map(async (player) => {
                    const hasWon = player.id === winnerId;
                    if (!player.firebaseUid) return;
                    try {
                        await this.authService.updateUserStatistics(player.firebaseUid, gameMode, hasWon, playtimeSeconds, false);
                    } catch (error) {
                        this.logger.warn(`Failed to update statistics for player ${player.firebaseUid}: ${error.message}`);
                    }
                });

            await Promise.all(updatePromises);
            this.logger.log(`Statistics updated for ${updatePromises.length} players in game ${room.roomId}`);
        } catch (error) {
            this.logger.error(`Error updating player statistics: ${error.message}`);
        }
    }
}

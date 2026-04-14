import { AuthService } from '@app/modules/auth/services/auth.service';
import { GameService } from '@app/modules/game/services/game.service';
import { CustomChannelService } from '@app/modules/general-chat/services/custom-channel.service';
import { GameMovementService } from '@app/modules/movement/services/game-movement.service';
import { TorchService } from '@app/modules/movement/services/torch.service';
import { MS_IN_SECOND, SECONDS_IN_MINUTE } from '@app/modules/shared-room/constants/game-room.constants';
import { GameRoom } from '@app/modules/shared-room/interfaces/game-room';
import { GameRoomService } from '@app/modules/shared-room/services/game-room.service';
import { CurrencyEvents, CustomChannelEvents, GameRoomEvents, WaitingRoomEvents } from '@common/socket.constants';
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
        private readonly torchService: TorchService,
    ) {}

    /**
     * Handles game start - spawns players and prepares first turn
     */
    async handlePlayGame(roomId: string, socket: Socket, server: Server): Promise<void> {
        try {
            const room = this.gameRoomService.findRoomById(roomId);
            room.players = await this.gameMovementService.addPlayersToBoard(roomId, room.gameId, room.players);
            server.to(roomId).emit(GameRoomEvents.PlayerSpawned, room.players);
            const illuminatedCells = this.torchService.recalculateIllumination(roomId, room.players);
            server.to(roomId).emit(GameRoomEvents.TorchIlluminationUpdate, { roomId, illuminatedCells, players: room.players });
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

            if (room.isFinished) return;
            room.isFinished = true;

            const diffSeconds = Math.floor((Date.now() - room.startTime.getTime()) / MS_IN_SECOND);
            room.globalStats.gameDuration = `${String(Math.floor(diffSeconds / SECONDS_IN_MINUTE)).padStart(2, '0')}:${String(
                diffSeconds % SECONDS_IN_MINUTE,
            ).padStart(2, '0')}`;
            this.gameRoomService.pauseTimer(data.roomId);

            await this.updatePlayerStatistics(room, data.winnerId, diffSeconds);

            server.to(data.roomId).emit(GameRoomEvents.FinishGame, data.winnerId);

            const REWARDS_DELAY = 6000;
            setTimeout(async () => {
                try {
                    await this.distributePrizePool(room, data.winnerId, server);
                } catch (e) {
                    this.logger.error(`Error distributing prizes: ${e.message}`);
                }
            }, REWARDS_DELAY);
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

            // Retirer le joueur de room.players pour éviter que handleDisconnect
            // ne déclenche handlePlayerAbandonment après un départ propre
            if (room) {
                room.players = room.players.filter((p) => p.id !== socket.id);
            }

            // Faire quitter le canal de partie à ce joueur (channelId = roomId sans le préfixe "game_")
            const channelId = roomId.startsWith('game_') ? roomId.slice(5) : roomId;
            socket.leave(`custom-channel-${channelId}`);
            socket.emit(CustomChannelEvents.CustomChannelLeft, { channelId });

            if (!room || room.players.length === 0 || room.players.every((p) => p.isVirtual)) {
                if (room) this.gameMovementService.removeBoard(roomId);
                this.gameRoomService.deleteRoomById(roomId);
                server.emit(WaitingRoomEvents.AvailableRoomsChanged);

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

    private async distributePrizePool(room: GameRoom, winnerId: string, server: Server): Promise<void> {
        const BASE_WIN = 200;
        const BASE_CONSOLATION = 50;

        const entryFee = room.entryFee ?? 0;
        const paidCount = room.paidPlayerFirebaseUids?.length ?? 0;
        const pool = entryFee * paidCount;
        const winnerShare = Math.round(pool * 2 / 3);
        const consolationTotal = pool - winnerShare;

        const abandonedUids = new Set((room.abandonedPlayers ?? []).map((ap) => ap.firebaseUid).filter(Boolean));
        const humanPlayers = room.players.filter((p) => !p.isVirtual && p.firebaseUid);
        const winnerIds = this.getWinnerIds(room, winnerId);
        const winners = humanPlayers.filter((p) => winnerIds.has(p.id));
        const losers = humanPlayers.filter((p) => !winnerIds.has(p.id) && !abandonedUids.has(p.firebaseUid));

        const winAmountEach = winners.length > 0 ? Math.round((BASE_WIN + winnerShare) / winners.length) : 0;
        const consolationEach = losers.length > 0 ? BASE_CONSOLATION + Math.floor(consolationTotal / losers.length) : BASE_CONSOLATION;

        const rewards: { name: string; gain: number; avatarName: string | null }[] = [];

        for (const player of winners) {
            try {
                const newBalance = await this.authService.updateVirtualCurrency(player.firebaseUid, winAmountEach);
                server.to(player.id).emit(CurrencyEvents.VirtualCurrencyUpdated, { balance: newBalance });
                rewards.push({ name: player.name, gain: winAmountEach, avatarName: player.avatar?.name ?? null });
            } catch (e) {
                this.logger.warn(`Prize distribution failed for winner ${player.firebaseUid}: ${e.message}`);
            }
        }

        for (const player of losers) {
            try {
                const newBalance = await this.authService.updateVirtualCurrency(player.firebaseUid, consolationEach);
                server.to(player.id).emit(CurrencyEvents.VirtualCurrencyUpdated, { balance: newBalance });
                rewards.push({ name: player.name, gain: consolationEach, avatarName: player.avatar?.name ?? null });
            } catch (e) {
                this.logger.warn(`Consolation prize failed for ${player.firebaseUid}: ${e.message}`);
            }
        }

        server.to(room.roomId).emit(CurrencyEvents.GameRewardsInfo, { rewards, entryFee, pool });
    }

    private getWinnerIds(room: GameRoom, winnerId: string): Set<string> {
        const winnerPlayer = room.players.find((p) => p.id === winnerId);
        if (winnerPlayer?.team != null) {
            return new Set(room.players.filter((p) => p.team === winnerPlayer.team).map((p) => p.id));
        }
        return new Set([winnerId]);
    }

    private async updatePlayerStatistics(room: GameRoom, winnerId: string, playtimeSeconds: number): Promise<void> {
        try {
            const game = await this.gameService.getGameById(room.gameId);
            const gameMode: 'Classique' | 'CTF' = game.mode === 'ctf' ? 'CTF' : 'Classique';
            const winnerIds = this.getWinnerIds(room, winnerId);

            const updatePromises = room.players
                .filter((player) => !player.isVirtual && player.firebaseUid)
                .map(async (player) => {
                    const hasWon = winnerIds.has(player.id);
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

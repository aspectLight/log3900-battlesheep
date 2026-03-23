import { AuthService } from '@app/modules/auth/services/auth.service';
import { GameCombatService } from '@app/modules/combat/services/game-combat.service';
import { GameService } from '@app/modules/game/services/game.service';
import { CustomChannelService } from '@app/modules/general-chat/services/custom-channel.service';
import { GameMovementService } from '@app/modules/movement/services/game-movement.service';
import { SIZE_LIMITS } from '@app/modules/shared-room/constants/waiting-room.constants';
import { GameRoomService } from '@app/modules/shared-room/services/game-room.service';
import { BlockService } from '@app/modules/social/services/block.service';
import { Player } from '@app/shared/interfaces/player';
import { CustomChannelEvents, GameRoomEvents } from '@common/socket.constants';
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
        private readonly customChannelService: CustomChannelService,
        private readonly blockService: BlockService,
        private readonly authService: AuthService,
    ) {}

    /**
     * Handles player leaving the game room
     */
    handleLeaveRoom(roomId: string, socket: Socket, server: Server): void {
        this.logger.log(`${GameRoomEvents.AbandonGame} called by ${socket.id}`);
        try {
            this.handlePlayerAbandonment(roomId, socket.id, server);
            socket.emit(GameRoomEvents.GameAbandoned);

            // Faire quitter le canal de partie (roomId = "game_XXX", canal = "XXX")
            const channelId = roomId.startsWith('game_') ? roomId.slice(5) : roomId;
            socket.leave(`custom-channel-${channelId}`);
            socket.emit(CustomChannelEvents.CustomChannelLeft, { channelId });
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
                    // Faire quitter le canal de partie (roomId = "game_XXX", canal = "XXX")
                    const channelId = room.roomId.startsWith('game_') ? room.roomId.slice(5) : room.roomId;
                    socket.leave(`custom-channel-${channelId}`);
                    socket.emit(CustomChannelEvents.CustomChannelLeft, { channelId });
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

            // Block check: resolve joining user's username and check against room players
            const joinerUsername = await this.resolveUsername(socket);
            if (joinerUsername) {
                const roomPlayerUsernames = await this.resolveRoomPlayerUsernames(room.players);
                for (const playerUsername of roomPlayerUsernames) {
                    if (await this.blockService.isBlockedBidirectional(joinerUsername, playerUsername)) {
                        return { success: false, error: 'Vous ne pouvez pas rejoindre cette partie en raison d\'un blocage' };
                    }
                }
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

            // Rejoindre le canal de discussion de la partie
            // Le roomId de la game room est "game_XXX", le channelId est "XXX"
            const channelId = data.roomId.startsWith('game_') ? data.roomId.slice(5) : data.roomId;
            try {
                const messages = await this.customChannelService.getMessages(channelId);
                socket.join(`custom-channel-${channelId}`);
                socket.emit(CustomChannelEvents.CustomChannelJoined, {
                    channelId,
                    channelName: `Partie ${channelId}`,
                    isGameChannel: true,
                });
                socket.emit(CustomChannelEvents.CustomChannelMessagesResponse, { channelId, messages });
            } catch (channelError) {
                this.logger.error(`Erreur rejoindre canal de partie (drop-in) ${channelId}: ${channelError.message}`);
            }

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

    private async resolveUsername(socket: Socket): Promise<string | null> {
        try {
            const { token } = socket.handshake.auth as { token?: string };
            if (!token) return null;
            const decoded = await this.authService.verifyToken(token);
            const user = await this.authService.getUserByUid(decoded.uid);
            return user?.username ?? null;
        } catch {
            return null;
        }
    }

    private async resolveRoomPlayerUsernames(players: Player[]): Promise<string[]> {
        const usernames: string[] = [];
        for (const player of players) {
            if (player.firebaseUid) {
                try {
                    const user = await this.authService.getUserByUid(player.firebaseUid);
                    if (user?.username) usernames.push(user.username);
                } catch {
                    // Virtual players won't have a firebaseUid
                }
            }
        }
        return usernames;
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

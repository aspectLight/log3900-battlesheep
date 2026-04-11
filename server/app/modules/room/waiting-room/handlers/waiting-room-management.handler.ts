import { AuthService } from '@app/modules/auth/services/auth.service';
import { GameService } from '@app/modules/game/services/game.service';
import { SIZE_LIMITS } from '@app/modules/shared-room/constants/waiting-room.constants';
import { GameRoomService } from '@app/modules/shared-room/services/game-room.service';
import { CustomChannelService } from '@app/modules/general-chat/services/custom-channel.service';
import { BlockService } from '@app/modules/social/services/block.service';
import { FriendshipService } from '@app/modules/social/services/friendship.service';
import { WaitingRoomService } from '@app/modules/shared-room/services/waiting-room.service';
import { Player } from '@app/shared/interfaces/player';
import { RoomInfo } from '@app/shared/interfaces/room-info';
import { CurrencyEvents, CustomChannelEvents, SocialEvents, WaitingRoomEvents } from '@common/socket.constants';
import { Injectable, Logger } from '@nestjs/common';
import { Server, Socket } from 'socket.io';

/**
 * Handler for waiting room management events (create, join, leave, lock)
 */
@Injectable()
export class WaitingRoomManagementHandler {
    private readonly logger = new Logger(WaitingRoomManagementHandler.name);

    // Sockets waiting for user choice when a blocked user is in the room
    private pendingBlockChoices = new Map<string, { roomId: string }>();

    constructor(
        private readonly waitingRoomService: WaitingRoomService,
        private readonly gameRoomService: GameRoomService,
        private readonly gameService: GameService,
        private readonly customChannelService: CustomChannelService,
        private readonly blockService: BlockService,
        private readonly friendshipService: FriendshipService,
        private readonly authService: AuthService,
    ) {}

    /**
     * Handles room creation
     */
    async handleCreateRoom(
        data: { roomId: string; gameId: string; host: Player; friendsOnly?: boolean; entryFee?: number },
        socket: Socket,
        server: Server,
    ): Promise<{ success: boolean; error?: string }> {
        try {
            const game = await this.gameService.getGameById(data.gameId);
            if (game.privacy === 'private' && game.owner !== data.host.name) {
                return { success: false, error: 'Seul le propriétaire peut créer une partie avec un jeu privé' };
            }

            const entryFee = Math.max(0, Math.floor(data.entryFee ?? 0));

            // Deduct entry fee from host if applicable
            const hostFirebaseUid = await this.resolveFirebaseUid(socket);
            if (entryFee > 0 && hostFirebaseUid) {
                const balance = await this.authService.getVirtualCurrency(hostFirebaseUid);
                if (balance < entryFee) {
                    return { success: false, error: 'Solde insuffisant pour créer cette partie' };
                }
                await this.authService.updateVirtualCurrency(hostFirebaseUid, -entryFee);
                const newBalance = await this.authService.getVirtualCurrency(hostFirebaseUid);
                socket.emit(CurrencyEvents.VirtualCurrencyUpdated, { balance: newBalance });
            }

            const hostUsername = await this.resolveUsername(socket);
            data.host.inventory = [];
            const room = this.waitingRoomService.createRoom(data.roomId, data.gameId, data.host, socket.id, data.friendsOnly ?? false, hostUsername ?? undefined, entryFee);

            // Track host as paid
            if (entryFee > 0 && hostFirebaseUid) {
                room.paidPlayerFirebaseUids.push(hostFirebaseUid);
            }
            this.logger.log(`Salle ${data.roomId} créée par ${data.host.id}`);
            socket.join(data.roomId);
            server.to(socket.id).emit(WaitingRoomEvents.WaitingRoomCreated, room);
            server.to(data.roomId).emit(WaitingRoomEvents.UpdateAvatarReserved, { reservedAvatars: room.reservedAvatars });

            // Créer le canal de partie et y ajouter le créateur
            try {
                const channelName = `Partie ${data.roomId}`;
                await this.customChannelService.createGameChannel(data.roomId, channelName);
                socket.join(`custom-channel-${data.roomId}`);
                socket.emit(CustomChannelEvents.CustomChannelJoined, {
                    channelId: data.roomId,
                    channelName,
                    isGameChannel: true,
                });
                socket.emit(CustomChannelEvents.CustomChannelMessagesResponse, { channelId: data.roomId, messages: [] });
            } catch (channelError) {
                this.logger.error(`Erreur création canal de partie ${data.roomId}: ${channelError.message}`);
            }

            return { success: true };
        } catch (error) {
            this.logger.error(`Erreur création room: ${error.message}`);
            return { success: false, error: error.message };
        }
    }

    /**
     * Handles player joining a room
     */
    async handleJoinRoom(roomId: string, socket: Socket): Promise<void> {
        try {
            const room = this.waitingRoomService.findRoomById(roomId);
            if (!room) throw new Error("La salle n'existe pas");
            if (room.isLocked) throw new Error('La salle est verrouillée');

            // Block check: resolve joining user's username
            const joinerUsername = await this.resolveUsername(socket);
            if (joinerUsername) {
                const roomPlayerUsernames = await this.resolveRoomPlayerUsernames(room.players);

                // Check if anyone in the room has blocked the joiner -> reject
                for (const playerUsername of roomPlayerUsernames) {
                    if (await this.blockService.isBlocked(playerUsername, joinerUsername)) {
                        throw new Error('Un joueur dans cette salle vous a bloqué');
                    }
                }

                // Check if the joiner has blocked anyone in the room -> warn and let them choose
                const blockedInRoom = [];
                for (const playerUsername of roomPlayerUsernames) {
                    if (await this.blockService.isBlocked(joinerUsername, playerUsername)) {
                        blockedInRoom.push(playerUsername);
                    }
                }

                if (blockedInRoom.length > 0) {
                    this.pendingBlockChoices.set(socket.id, { roomId });
                    socket.emit(SocialEvents.BlockedUserInRoom, { blockedUsernames: blockedInRoom, roomId });
                    return; // Wait for the user's choice
                }

                // Friends-only check
                if (room.friendsOnly && room.hostUsername) {
                    const isFriend = await this.friendshipService.areFriends(room.hostUsername, joinerUsername);
                    if (!isFriend) {
                        throw new Error('Ce salon est réservé aux amis du créateur');
                    }
                }
            } else if (room.friendsOnly) {
                throw new Error('Ce salon est réservé aux amis du créateur');
            }

            await this.completeJoinRoom(roomId, socket);
        } catch (error) {
            socket.emit(WaitingRoomEvents.JoinRoomResponse, { success: false, error: error.message });
        }
    }

    /**
     * Handles the user's choice when a blocked user is in the room
     */
    async handleBlockedUserRoomChoice(socket: Socket, data: { choice: 'enter' | 'cancel' }): Promise<void> {
        const pending = this.pendingBlockChoices.get(socket.id);
        this.pendingBlockChoices.delete(socket.id);

        if (!pending) {
            socket.emit(WaitingRoomEvents.JoinRoomResponse, { success: false, error: 'Aucune demande en attente' });
            return;
        }

        if (data.choice === 'enter') {
            try {
                await this.completeJoinRoom(pending.roomId, socket);
            } catch (error) {
                socket.emit(WaitingRoomEvents.JoinRoomResponse, { success: false, error: error.message });
            }
        } else {
            socket.emit(WaitingRoomEvents.JoinRoomResponse, { success: false, error: 'Vous avez choisi de ne pas rejoindre la salle' });
        }
    }

    /**
     * Completes the join room flow (after block checks pass)
     */
    private async completeJoinRoom(roomId: string, socket: Socket): Promise<void> {
        const room = this.waitingRoomService.findRoomById(roomId);
        if (!room) throw new Error("La salle n'existe pas");

        // Deduct entry fee if applicable
        if (room.entryFee > 0) {
            const joinerUid = await this.resolveFirebaseUid(socket);
            if (!joinerUid) throw new Error('Authentification requise pour rejoindre cette salle');
            const balance = await this.authService.getVirtualCurrency(joinerUid);
            if (balance < room.entryFee) throw new Error('Solde insuffisant pour rejoindre cette partie');
            await this.authService.updateVirtualCurrency(joinerUid, -room.entryFee);
            room.paidPlayerFirebaseUids.push(joinerUid);
            const newBalance = await this.authService.getVirtualCurrency(joinerUid);
            socket.emit(CurrencyEvents.VirtualCurrencyUpdated, { balance: newBalance });
        }

        socket.emit(WaitingRoomEvents.JoinRoomResponse, { success: true, room });
        this.waitingRoomService.joinRoom(roomId, socket.id);
        socket.join(roomId);
        this.logger.log(`Joueur ${socket.id} a rejoint la salle ${roomId}`);

        // Join the game room chat
        try {
            const messages = await this.customChannelService.getMessages(roomId);
            socket.join(`custom-channel-${roomId}`);
            socket.emit(CustomChannelEvents.CustomChannelJoined, {
                channelId: roomId,
                channelName: `Partie ${roomId}`,
                isGameChannel: true,
            });
            socket.emit(CustomChannelEvents.CustomChannelMessagesResponse, { channelId: roomId, messages });
        } catch (channelError) {
            this.logger.error(`Erreur rejoindre canal de partie ${roomId}: ${channelError.message}`);
        }
    }

    /**
     * Handles player leaving a room
     */
    async handleLeaveRoom(roomId: string, socket: Socket, server: Server): Promise<void> {
        try {
            this.logger.log(`Salle ${roomId} : joueur ${socket.id} essaye de quitter la salle`);

            // Capture room state before deletion for refunds
            const room = this.waitingRoomService.findRoomById(roomId);
            const entryFee = room?.entryFee ?? 0;
            const paidUids = room ? [...room.paidPlayerFirebaseUids] : [];
            const leavingUid = await this.resolveFirebaseUid(socket);

            const isRoomDeleted = this.waitingRoomService.leaveRoom(roomId, socket.id);

            if (isRoomDeleted) {
                // Refund all paid players (host left → room deleted)
                if (entryFee > 0) {
                    for (const uid of paidUids) {
                        try {
                            const newBalance = await this.authService.updateVirtualCurrency(uid, entryFee);
                            // Notify the leaving player directly; others will get notified via RoomCanceled + socket reconnect
                            if (uid === leavingUid) {
                                socket.emit(CurrencyEvents.VirtualCurrencyUpdated, { balance: newBalance });
                            }
                        } catch (e) {
                            this.logger.warn(`Refund failed for uid ${uid}: ${e.message}`);
                        }
                    }
                }
                socket.emit(WaitingRoomEvents.LeaveRoomResponse, { success: true });
                server.except(socket.id).to(roomId).emit(WaitingRoomEvents.RoomCanceled);
                this.logger.log(`Salle ${roomId} supprimée, car l'organisateur a quitté.`);

                // Faire quitter le canal de partie à l'organisateur
                socket.leave(`custom-channel-${roomId}`);
                socket.emit(CustomChannelEvents.CustomChannelDeleted, { channelId: roomId });

                // Supprimer le canal de partie et notifier les autres joueurs
                try {
                    server.to(`custom-channel-${roomId}`).emit(CustomChannelEvents.CustomChannelDeleted, { channelId: roomId });
                    await this.customChannelService.deleteGameChannel(roomId);
                } catch (channelError) {
                    this.logger.error(`Erreur suppression canal de partie ${roomId}: ${channelError.message}`);
                }
            } else {
                // Refund the leaving player if they paid
                if (entryFee > 0 && leavingUid && paidUids.includes(leavingUid)) {
                    try {
                        const newBalance = await this.authService.updateVirtualCurrency(leavingUid, entryFee);
                        socket.emit(CurrencyEvents.VirtualCurrencyUpdated, { balance: newBalance });
                        // Remove from paidPlayerFirebaseUids
                        const updatedRoom = this.waitingRoomService.findRoomById(roomId);
                        if (updatedRoom) {
                            updatedRoom.paidPlayerFirebaseUids = updatedRoom.paidPlayerFirebaseUids.filter((uid) => uid !== leavingUid);
                        }
                    } catch (e) {
                        this.logger.warn(`Refund failed for uid ${leavingUid}: ${e.message}`);
                    }
                }
                server.to(roomId).emit(WaitingRoomEvents.PlayerLeft, { playerId: socket.id });
                const updatedRoom = this.waitingRoomService.findRoomById(roomId);
                server.to(roomId).emit(WaitingRoomEvents.UpdateAvatarReserved, { reservedAvatars: updatedRoom.reservedAvatars });
                socket.emit(WaitingRoomEvents.LeaveRoomResponse, { success: true });
                this.logger.log(`Joueur ${socket.id} a quitté la salle ${roomId}`);

                // Faire quitter le canal de partie au joueur qui part
                socket.leave(`custom-channel-${roomId}`);
                socket.emit(CustomChannelEvents.CustomChannelLeft, { channelId: roomId });
            }
        } catch (error) {
            socket.emit(WaitingRoomEvents.LeaveRoomResponse, { success: false, error: error.message });
        }
    }

    /**
     * Handles room lock toggle
     */
    handleLockRoom(roomId: string, socket: Socket, server: Server): void {
        try {
            this.logger.log('toggle lock from gateway', roomId, socket.id);
            const isLocked = this.waitingRoomService.toggleLockRoom(roomId, socket.id);

            if (isLocked) {
                server.to(roomId).emit(WaitingRoomEvents.WaitingRoomLocked);
                this.logger.log(`Salle ${roomId} verrouillée par ${socket.id}`);
            } else {
                server.to(roomId).emit(WaitingRoomEvents.WaitingRoomUnlocked);
                this.logger.log(`Salle ${roomId} déverrouillée par ${socket.id}`);
            }
        } catch (error) {
            socket.emit(WaitingRoomEvents.WaitingRoomError, error.message);
        }
    }

    /**
     * Handles drop-in/drop-out toggle
     */
    handleToggleDropInDropOut(roomId: string, socket: Socket, server: Server): void {
        try {
            const isEnabled = this.waitingRoomService.toggleDropInDropOut(roomId, socket.id);
            server.to(roomId).emit(WaitingRoomEvents.DropInDropOutToggled, { dropInDropOut: isEnabled });
            this.logger.log(`Salle ${roomId} drop-in/drop-out ${isEnabled ? 'activé' : 'désactivé'} par ${socket.id}`);
        } catch (error) {
            socket.emit(WaitingRoomEvents.WaitingRoomError, error.message);
        }
    }

    /**
     * Handles player disconnection
     */
    async handleDisconnect(socket: Socket, server: Server): Promise<void> {
        try {
            this.logger.log(`socket déconnecté: ${socket.id}`);
            const rooms = this.waitingRoomService.findRoomsByPlayerId(socket.id);
            const disconnectedUid = await this.resolveFirebaseUid(socket).catch(() => null);

            if (rooms && rooms.length > 0) {
                for (const room of rooms) {
                    const entryFee = room.entryFee ?? 0;
                    const paidUids = [...(room.paidPlayerFirebaseUids ?? [])];
                    const isRoomDeleted = this.waitingRoomService.leaveRoom(room.roomId, socket.id);

                    // Refund on disconnect
                    if (entryFee > 0) {
                        if (isRoomDeleted) {
                            for (const uid of paidUids) {
                                try { await this.authService.updateVirtualCurrency(uid, entryFee); } catch { /* ignore */ }
                            }
                        } else if (disconnectedUid && paidUids.includes(disconnectedUid)) {
                            try {
                                await this.authService.updateVirtualCurrency(disconnectedUid, entryFee);
                                const updatedRoom = this.waitingRoomService.findRoomById(room.roomId);
                                if (updatedRoom) {
                                    updatedRoom.paidPlayerFirebaseUids = updatedRoom.paidPlayerFirebaseUids.filter((uid) => uid !== disconnectedUid);
                                }
                            } catch { /* ignore */ }
                        }
                    }

                    if (isRoomDeleted) {
                        server.to(room.roomId).emit(WaitingRoomEvents.RoomCanceled);
                        this.logger.log(`Salle ${room.roomId} supprimée, car l'organisateur s'est déconnecté.`);

                        // Faire quitter le canal de partie (le socket peut encore être actif à ce stade)
                        socket.leave(`custom-channel-${room.roomId}`);
                        try {
                            socket.emit(CustomChannelEvents.CustomChannelDeleted, { channelId: room.roomId });
                        } catch {
                            // Le socket peut être déjà déconnecté, ce n'est pas grave
                        }

                        // Supprimer le canal de partie et notifier les autres joueurs
                        try {
                            server.to(`custom-channel-${room.roomId}`).emit(CustomChannelEvents.CustomChannelDeleted, {
                                channelId: room.roomId,
                            });
                            await this.customChannelService.deleteGameChannel(room.roomId);
                        } catch (channelError) {
                            this.logger.error(`Erreur suppression canal de partie ${room.roomId}: ${channelError.message}`);
                        }
                    } else {
                        server.to(room.roomId).emit(WaitingRoomEvents.PlayerLeft, { playerId: socket.id });
                        const updatedRoom = this.waitingRoomService.findRoomById(room.roomId);
                        if (updatedRoom) {
                            server.to(room.roomId).emit(WaitingRoomEvents.UpdateAvatarReserved, {
                                reservedAvatars: updatedRoom.reservedAvatars,
                            });
                        }
                        this.logger.log(`Joueur ${socket.id} a quitté la salle ${room.roomId} suite à une déconnexion`);
                    }
                }
            }
        } catch (error) {
            this.logger.error(`Erreur lors du traitement de la déconnexion du joueur ${socket.id}: ${error.message}`);
        }
    }

    async handleGetAvailableRooms(socket: Socket): Promise<void> {
        try {
            const waitingRooms = this.waitingRoomService.getAvailableRooms();
            const gameRooms = this.gameRoomService.getAvailableRooms();
            const requesterUsername = await this.resolveUsername(socket);

            const roomInfos: RoomInfo[] = [];

            for (const room of waitingRooms) {
                try {
                    const game = await this.gameService.getGameById(room.gameId);
                    const maxPlayers = SIZE_LIMITS[game.board.size] || 2;

                    // Filter: don't show rooms where a player has blocked the requester
                    if (requesterUsername) {
                        const playerUsernames = await this.resolveRoomPlayerUsernames(room.players);
                        let blockedByPlayer = false;
                        for (const playerUsername of playerUsernames) {
                            if (await this.blockService.isBlocked(playerUsername, requesterUsername)) {
                                blockedByPlayer = true;
                                break;
                            }
                        }
                        if (blockedByPlayer) continue;
                    }

                    // Friends-only filter: only show to friends of host
                    if (room.friendsOnly && room.hostUsername) {
                        if (!requesterUsername || !(await this.friendshipService.areFriends(room.hostUsername, requesterUsername))) {
                            continue;
                        }
                    }

                    roomInfos.push({
                        roomId: room.roomId,
                        gameName: game.name,
                        boardSize: game.board.size,
                        board: game.board,
                        mode: game.mode,
                        playerCount: room.players.length,
                        maxPlayers,
                        status: 'waiting',
                        isLocked: room.isLocked,
                        dropInDropOut: room.dropInDropOut || false,
                        friendsOnly: room.friendsOnly || false,
                        entryFee: room.entryFee ?? 0,
                    });
                } catch {
                    this.logger.warn(`Jeu introuvable pour la salle ${room.roomId}`);
                }
            }

            for (const room of gameRooms) {
                try {
                    const game = await this.gameService.getGameById(room.gameId);
                    const maxPlayers = SIZE_LIMITS[game.board.size] || 2;

                    // Filter: don't show rooms where a player has blocked the requester
                    if (requesterUsername) {
                        const playerUsernames = await this.resolveRoomPlayerUsernames(room.players);
                        let blockedByPlayer = false;
                        for (const playerUsername of playerUsernames) {
                            if (await this.blockService.isBlocked(playerUsername, requesterUsername)) {
                                blockedByPlayer = true;
                                break;
                            }
                        }
                        if (blockedByPlayer) continue;
                    }

                    roomInfos.push({
                        roomId: room.roomId,
                        gameName: game.name,
                        boardSize: game.board.size,
                        board: game.board,
                        mode: game.mode,
                        playerCount: room.players.length,
                        maxPlayers,
                        status: 'playing',
                        isLocked: room.isLocked,
                        dropInDropOut: room.dropInDropOut || false,
                        friendsOnly: false,
                        abandonedPlayerFirebaseIds: room.abandonedPlayers
                            .map((ap) => ap.firebaseUid)
                            .filter((uid): uid is string => !!uid),
                        entryFee: room.entryFee ?? 0,
                    });
                } catch {
                    this.logger.warn(`Jeu introuvable pour la game room ${room.roomId}`);
                }
            }

            socket.emit(WaitingRoomEvents.AvailableRoomsResponse, roomInfos);
        } catch (error) {
            this.logger.error(`Erreur lors de la récupération des salles disponibles: ${error.message}`);
            socket.emit(WaitingRoomEvents.AvailableRoomsResponse, []);
        }
    }

    private async resolveFirebaseUid(socket: Socket): Promise<string | null> {
        try {
            const { token } = socket.handshake.auth as { token?: string };
            if (!token) return null;
            const decoded = await this.authService.verifyToken(token);
            return decoded.uid ?? null;
        } catch {
            return null;
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
                    // Player may not have a firebase UID (virtual player)
                }
            }
        }
        return usernames;
    }
}

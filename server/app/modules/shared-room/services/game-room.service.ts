import { GameService } from '@app/modules/game/services/game.service';
import { COUNTDOWN_INTERVAL, RANDOM_CALCULATOR_VALUE, TURN_BREAK, TURN_DURATION } from '@app/modules/shared-room/constants/game-room.constants';
import { GameRoom } from '@app/modules/shared-room/interfaces/game-room';
import {
    ADRENALINE_HEALTH_BOOST,
    PROPAGANDA_ATTACK_BOOST,
    PROPAGANDA_DEFENSE_BOOST,
    PROPAGANDA_HEALTH_THRESHOLD,
    VODKA_ATTACK_BOOST,
    VODKA_SPEED_REDUCTION,
} from '@app/shared/constants/item.constants';
import { Item, ItemType } from '@app/shared/interfaces/item';
import { Player } from '@app/shared/interfaces/player';
import { ErrorMessages } from '@common/error-messages.constants';
import { GameRoomEvents } from '@common/socket.constants';
import { Injectable } from '@nestjs/common';
import { Server } from 'socket.io';
@Injectable()
export class GameRoomService {
    private gameRooms: GameRoom[] = [];
    private server: Server;
    private turnTimeouts: Map<string, NodeJS.Timeout> = new Map();
    private roomsEndingTurn: Set<string> = new Set();
    private propagandaActivePlayers: Set<string> = new Set();

    constructor(private gameService: GameService) {}

    setServer(server: Server) {
        this.server = server;
    }

    async createRoom(waitingRoom: GameRoom): Promise<GameRoom> {
        if (this.findRoomById(waitingRoom.roomId)) {
            throw new Error(ErrorMessages.RoomAlreadyExists);
        }

        const newRoom: GameRoom = {
            roomId: `game_${waitingRoom.roomId}`,
            gameId: waitingRoom.gameId,
            hostId: waitingRoom.hostId,
            players: waitingRoom.players,
            isLocked: true,
            dropInDropOut: waitingRoom.dropInDropOut || false,
            abandonedPlayers: [],
            isDebugging: false,
            turnTimer: undefined,
            timeRemaining: undefined,
            messages: waitingRoom.messages,
            playersStats: [],
            globalStats: {
                gameDuration: '00:00',
                turns: 0,
                doorsToggled: [],
            },
            startTime: new Date(),
        };
        for (const player of newRoom.players) {
            newRoom.playersStats.push({
                name: player.name,
                combats: 0,
                evasions: 0,
                victories: 0,
                defeats: 0,
                healthLost: 0,
                damage: 0,
                itemsCollected: [],
                tilesVisited: [],
            });
        }

        newRoom.players = this.assignTurnOrder(newRoom.players);
        newRoom.players = this.assignColor(newRoom.players);

        const gameInfo = await this.gameService.getGameById(waitingRoom.gameId);
        if (gameInfo.mode === 'ctf') {
            newRoom.players = this.assignTeam(newRoom.players);
        }

        this.gameRooms.push(newRoom);

        return newRoom;
    }

    abandonGame(roomId: string, playerId: string): boolean {
        const room = this.findRoomById(roomId);
        if (!room) {
            throw new Error(ErrorMessages.RoomDoesNotExist);
        }

        // Store abandoned player data for potential rejoin
        const abandonedPlayer = room.players.find((p) => p.id === playerId);
        if (abandonedPlayer && abandonedPlayer.firebaseUid && room.dropInDropOut) {
            const playerStats = room.playersStats?.find((s) => s.name === abandonedPlayer.name);
            // Remove any previous entry for this firebaseUid
            room.abandonedPlayers = room.abandonedPlayers.filter((ap) => ap.firebaseUid !== abandonedPlayer.firebaseUid);
            room.abandonedPlayers.push({
                firebaseUid: abandonedPlayer.firebaseUid,
                player: { ...abandonedPlayer, inventory: [] },
                stats: playerStats ? { ...playerStats } : null,
            });
        }

        room.players = room.players.filter((p) => p.id !== playerId);
        if (room.hostId === playerId) {
            if (room.players.length > 0) {
                room.hostId = room.players[0].id;
            }
            room.isDebugging = false;
        }
        if (room.players.length <= 1) {
            this.deleteRoomById(roomId);
            return true;
        }
        return false;
    }

    isHost(roomId: string, playerId: string): boolean {
        const room = this.findRoomById(roomId);
        if (!room) {
            throw new Error(ErrorMessages.RoomDoesNotExist);
        }
        return room.hostId === playerId;
    }

    deleteRoomById(roomId: string) {
        this.pauseTimer(roomId);
        this.clearTurnTimeout(roomId);
        this.gameRooms = this.gameRooms.filter((r) => r.roomId !== roomId);
    }

    addMessage(roomId: string, message: { type: string; name?: string | null; content: string; time: string }) {
        const room = this.findRoomById(roomId);
        if (!room) {
            throw new Error("La salle n'existe pas");
        }
        room.messages.push(message);
    }

    prepareNextTurn(roomId: string): void {
        const room = this.findRoomById(roomId);
        if (!room || !room.players) {
            throw new Error(ErrorMessages.GameDoesNotExist);
        }

        // Clear any existing timer first to prevent having multiple timers running at the same time
        if (room.turnTimer) {
            clearInterval(room.turnTimer);
            room.turnTimer = undefined;
        }

        for (const player of room.players) {
            player.movementPoints = player.stats['speed'].value;
        }

        let countdown = TURN_BREAK;
        room.timeRemaining = countdown;

        room.turnTimer = setInterval(() => {
            room.timeRemaining = countdown;
            if (countdown === TURN_BREAK) {
                this.server.to(roomId).emit(GameRoomEvents.TurnStarting, {
                    nextPlayer: room.players[0],
                    countdown,
                });
            }
            this.server.to(roomId).emit(GameRoomEvents.UpdateStartingCountdown, countdown);
            if (countdown <= 0) {
                clearInterval(room.turnTimer);
                room.timeRemaining = undefined;
                this.startTurn(roomId);
            }
            countdown--;
        }, COUNTDOWN_INTERVAL);
    }

    startTurn(roomId: string): void {
        const room = this.findRoomById(roomId);
        if (!room) throw new Error(ErrorMessages.GameDoesNotExist);

        // Clear any existing timer first to prevent having multiple timers running at the same time
        if (room.turnTimer) {
            clearInterval(room.turnTimer);
            room.turnTimer = undefined;
        }

        let countdown = TURN_DURATION;
        room.timeRemaining = countdown;

        room.turnTimer = setInterval(() => {
            countdown--;
            room.timeRemaining = countdown;
            this.server.to(roomId).emit(GameRoomEvents.UpdateCountdown, countdown);
            if (countdown <= 0) {
                clearInterval(room.turnTimer);
                room.timeRemaining = undefined;
                this.endTurn(roomId);
            }
        }, COUNTDOWN_INTERVAL);
    }

    endTurn(roomId: string): void {
        const room = this.findRoomById(roomId);
        if (!room) {
            throw new Error(ErrorMessages.GameDoesNotExist);
        }

        if (this.roomsEndingTurn.has(roomId)) {
            return;
        }

        this.roomsEndingTurn.add(roomId);

        try {
            clearInterval(room.turnTimer);
            room.turnTimer = undefined;
            room.globalStats.turns++;
            room.players.push(room.players.shift());

            this.prepareNextTurn(roomId);
        } finally {
            this.roomsEndingTurn.delete(roomId);
        }
    }

    isPlayerTurn(roomId: string, playerId: string): boolean {
        const room = this.findRoomById(roomId);
        if (!room) {
            throw new Error(ErrorMessages.GameDoesNotExist);
        }
        return room.players[0].id === playerId;
    }

    endGame(roomId: string): void {
        const room = this.findRoomById(roomId);
        if (!room) {
            throw new Error(ErrorMessages.GameDoesNotExist);
        }
        this.pauseTimer(roomId);
        this.clearTurnTimeout(roomId);
        this.gameRooms = this.gameRooms.filter((r) => r.roomId !== roomId);
    }

    findRoomById(roomId: string): GameRoom | null {
        return this.gameRooms.find((room) => room.roomId === roomId);
    }

    toggleDebugMode(roomId: string): boolean {
        const room = this.findRoomById(roomId);
        if (!room) {
            throw new Error(ErrorMessages.RoomDoesNotExist);
        }
        room.isDebugging = !room.isDebugging;
        return room.isDebugging;
    }

    pauseTimer(roomId: string): void {
        const room = this.findRoomById(roomId);
        if (room && room.turnTimer) {
            clearInterval(room.turnTimer);
            room.turnTimer = undefined;
        }
    }

    resumeTurn(roomId: string): void {
        const room = this.findRoomById(roomId);
        if (!room) throw new Error(ErrorMessages.GameDoesNotExist);

        const playerTurn = room.players[0];

        if (playerTurn.movementPoints >= 1) {
            let countdown = room.timeRemaining;
            room.turnTimer = setInterval(() => {
                countdown--;
                room.timeRemaining = countdown;
                this.server.to(roomId).emit(GameRoomEvents.UpdateCountdown, countdown);
                if (countdown <= 0) {
                    clearInterval(room.turnTimer);
                    room.timeRemaining = undefined;
                    this.endTurn(roomId);
                }
            }, COUNTDOWN_INTERVAL);
        } else {
            this.endTurn(roomId);
        }
    }

    getAvailableRooms(): GameRoom[] {
        return this.gameRooms.filter((room) => room.dropInDropOut);
    }

    findRoomsByPlayerId(playerId: string): GameRoom[] {
        return this.gameRooms.filter((room) => {
            if (!room || !room.players) {
                return false;
            }
            const playerInRoom = Array.isArray(room.players) && room.players.some((player) => player && player.id === playerId);
            const ishost = room.hostId === playerId;

            return playerInRoom || ishost;
        });
    }

    addPlayerToGame(
        roomId: string,
        player: Player,
        socketId: string,
        maxPlayers: number,
    ): { player: Player; isReturning: boolean; restoredStats?: any } {
        const room = this.findRoomById(roomId);
        if (!room) {
            throw new Error(ErrorMessages.RoomDoesNotExist);
        }
        if (!room.dropInDropOut) {
            throw new Error("Le drop-in n'est pas activé pour cette partie");
        }
        if (room.players.length >= maxPlayers) {
            throw new Error('La limite de joueurs est atteinte');
        }

        // Check if this is a returning player
        const abandonedEntry = player.firebaseUid ? room.abandonedPlayers.find((ap) => ap.firebaseUid === player.firebaseUid) : null;

        if (abandonedEntry) {
            // Returning player: restore their original config with full HP and empty inventory
            const restoredPlayer = {
                ...abandonedEntry.player,
                id: socketId,
                inventory: [],
                fightsWon: abandonedEntry.stats?.victories ?? 0,
            };
            if (restoredPlayer.stats?.['life']) {
                restoredPlayer.stats = {
                    ...restoredPlayer.stats,
                    life: { ...restoredPlayer.stats['life'], value: restoredPlayer.stats['life'].maxValue },
                };
            }
            room.players.push(restoredPlayer);

            // Restore stats
            if (abandonedEntry.stats) {
                const existingStatsIndex = room.playersStats?.findIndex((s) => s.name === restoredPlayer.name);
                if (existingStatsIndex >= 0) {
                    room.playersStats[existingStatsIndex] = { ...abandonedEntry.stats };
                } else {
                    room.playersStats?.push({ ...abandonedEntry.stats });
                }
            }

            // Remove from abandoned list
            room.abandonedPlayers = room.abandonedPlayers.filter((ap) => ap.firebaseUid !== player.firebaseUid);

            return { player: restoredPlayer, isReturning: true, restoredStats: abandonedEntry.stats };
        } else {
            // New player: assign color and add fresh stats
            const usedColors = room.players.map((p) => p.color);
            const allColors = ['yellow', 'blue', 'green', 'pink', 'purple', 'red'];
            const availableColor = allColors.find((c) => !usedColors.includes(c)) || allColors[0];

            player.id = socketId;
            player.color = availableColor;
            player.inventory = [];
            player.team = 0;

            // If either team count is > 0, this is a CTF game
            // Assign to the smallest team (teams are 1 and 2)
            const teamCounts = room.players.reduce(
                (acc, p) => {
                    if (p.team === 1) acc[1]++;
                    else if (p.team === 2) acc[2]++;
                    return acc;
                },
                { 1: 0, 2: 0 },
            );
            if (teamCounts[1] > 0 || teamCounts[2] > 0) {
                player.team = teamCounts[1] <= teamCounts[2] ? 1 : 2;
            }

            room.players.push(player);

            room.playersStats?.push({
                name: player.name,
                combats: 0,
                evasions: 0,
                victories: 0,
                defeats: 0,
                healthLost: 0,
                damage: 0,
                itemsCollected: [],
                tilesVisited: [],
            });

            return { player, isReturning: false };
        }
    }

    addItemToInventory(roomId: string, playerId: string, item: Item): { shouldDrop?: { item: Item }; inventoryFull?: boolean; player: Player } {
        const room = this.findRoomById(roomId);
        const player: Player = room.players.find((p) => p.id === playerId);

        if (player.inventory.length >= 2) {
            if (player.isVirtual) {
                // Virtual players auto-drop a non-flag item
                const itemDropped = player.inventory.find((i) => i.type !== 'flag');
                const index = player.inventory.findIndex((i) => i.type === itemDropped.type);
                if (index >= 0) {
                    player.inventory.splice(index, 1);
                }
                player.inventory.push(item);
                this.removeItemStatEffect(player, itemDropped);
                this.applyItemStatEffect(player, item);
                this.server.to(roomId).emit(GameRoomEvents.ItemDropped, { roomId, playerId, item: itemDropped, coords: player.position });
                return { shouldDrop: { item: itemDropped }, player };
            } else {
                // Real players: push item temporarily (inventory will have 3 items).
                // The client will show a replacement popup — when the player drops
                // an item, ItemDropped will bring inventory back to 2.
                player.inventory.push(item);
                this.applyItemStatEffect(player, item);
                return { inventoryFull: true, player };
            }
        } else {
            player.inventory.push(item);
            this.applyItemStatEffect(player, item);
            return { player };
        }
    }

    removeItemFromInventory(roomId: string, playerId: string, item: Item): Player {
        if (!playerId) return null;
        const room = this.findRoomById(roomId);
        const player: Player = room.players.find((p) => p.id === playerId);
        const index = player.inventory.findIndex((i) => i.type === item.type);
        if (index >= 0) {
            player.inventory.splice(index, 1);
            this.removeItemStatEffect(player, item);
        }
        return player;
    }

    /**
     * Re-evaluates the propaganda buff for a player based on their current health.
     * Should be called whenever the player's health changes (after combat hits or health restoration).
     */
    reevaluatePropaganda(player: Player): void {
        const hasPropaganda = player.inventory?.some((i) => i?.type === 'propaganda');
        if (!hasPropaganda) return;

        const belowThreshold = player.stats['health'].value < PROPAGANDA_HEALTH_THRESHOLD;
        const isActive = this.propagandaActivePlayers.has(player.id);

        if (belowThreshold && !isActive) {
            player.stats['attack'].value += PROPAGANDA_ATTACK_BOOST;
            player.stats['defense'].value += PROPAGANDA_DEFENSE_BOOST;
            this.propagandaActivePlayers.add(player.id);
        } else if (!belowThreshold && isActive) {
            player.stats['attack'].value -= PROPAGANDA_ATTACK_BOOST;
            player.stats['defense'].value -= PROPAGANDA_DEFENSE_BOOST;
            this.propagandaActivePlayers.delete(player.id);
        }
    }

    private applyItemStatEffect(player: Player, item: Item): void {
        if (!player.stats || !item) return;
        switch (item.type) {
            case 'adrenaline':
                player.stats['health'].value += ADRENALINE_HEALTH_BOOST;
                break;
            case 'vodka':
                player.stats['attack'].value += VODKA_ATTACK_BOOST;
                player.stats['speed'].value -= VODKA_SPEED_REDUCTION;
                break;
            case 'propaganda':
                // Propaganda is conditional: activate immediately only if health is already below threshold.
                // reevaluatePropaganda handles activation/deactivation as health changes during combat.
                if (player.stats['health'].value < PROPAGANDA_HEALTH_THRESHOLD && !this.propagandaActivePlayers.has(player.id)) {
                    player.stats['attack'].value += PROPAGANDA_ATTACK_BOOST;
                    player.stats['defense'].value += PROPAGANDA_DEFENSE_BOOST;
                    this.propagandaActivePlayers.add(player.id);
                }
                break;
        }
    }

    private removeItemStatEffect(player: Player, item: Item): void {
        if (!player.stats || !item) return;
        switch (item.type) {
            case 'adrenaline':
                player.stats['health'].value -= ADRENALINE_HEALTH_BOOST;
                break;
            case 'vodka':
                player.stats['attack'].value -= VODKA_ATTACK_BOOST;
                player.stats['speed'].value += VODKA_SPEED_REDUCTION;
                break;
            case 'propaganda':
                if (this.propagandaActivePlayers.has(player.id)) {
                    player.stats['attack'].value -= PROPAGANDA_ATTACK_BOOST;
                    player.stats['defense'].value -= PROPAGANDA_DEFENSE_BOOST;
                    this.propagandaActivePlayers.delete(player.id);
                }
                break;
        }
    }

    dropItemsWhenDisconnected(roomId: string, playerId: string) {
        const room = this.findRoomById(roomId);
        const player = room.players.find((p) => p.id === playerId);
        this.server.to(room.players[0].id).emit(GameRoomEvents.ItemDroppedDisconnected, {
            roomId,
            coords: player.position,
            items: player.inventory,
        });
    }

    isOpponent(player: Player, opponent: Player, isCTF?: boolean) {
        if (isCTF) return player.team !== opponent.team;
        if (!opponent || player.id === opponent.id) return false;
        return true;
    }

    isCarryingFlag(player: Player) {
        return player.inventory.find((item) => item.type === ItemType.Flag);
    }

    isOpponentCarryingFlag(player: Player, opponent: Player) {
        return opponent && this.isOpponent(player, opponent) && this.isCarryingFlag(opponent);
    }

    isFlagWithOurTeam(player: Player) {
        const room = this.findRoomsByPlayerId(player.id)[0];
        if (!room) return false;
        const allies: Player[] = [];
        for (const p of room.players) {
            if (p.team === player.team) allies.push(p);
        }
        return allies.find((p) => this.isCarryingFlag(p));
    }

    changeHost(roomId: string): void {
        const room = this.findRoomById(roomId);
        if (!room) {
            throw new Error(ErrorMessages.RoomDoesNotExist);
        }
        const oldOrganizatorId = room.hostId;
        room.hostId = '';
        const realPlayers = room.players.filter((player) => !player.isVirtual && player.id !== oldOrganizatorId);
        room.hostId = realPlayers[0].id;
        if (this.server) {
            this.server.to(roomId).emit(GameRoomEvents.OrganizatorChanged, {
                roomId,
                newhostId: room.hostId,
            });
        }
    }

    getRandomDelay(minSeconds: number, maxSeconds: number): number {
        const minMs = minSeconds;
        const maxMs = maxSeconds;

        return Math.floor(Math.random() * (maxMs - minMs + 1)) + minMs;
    }

    private assignColor(players: Player[]): Player[] {
        const colors = ['yellow', 'blue', 'green', 'pink', 'purple', 'red'];
        return players.map((player, index) => ({ ...player, color: colors[index] }));
    }

    private assignTurnOrder(players: Player[]): Player[] {
        return players.sort((a, b) => {
            const diff = b.stats['speed'].value - a.stats['speed'].value;
            return diff === 0 ? Math.random() - RANDOM_CALCULATOR_VALUE : diff;
        });
    }

    private clearTurnTimeout(roomId: string): void {
        const timeout = this.turnTimeouts.get(roomId);
        if (timeout) {
            clearTimeout(timeout);
            this.turnTimeouts.delete(roomId);
        }
    }

    private assignTeam(players: Player[]): Player[] {
        const shuffled = [...players];
        for (let i = shuffled.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]];
        }

        const half = shuffled.length / 2;
        for (let i = 0; i < shuffled.length; i++) {
            shuffled[i].team = i < half ? 1 : 2;
        }

        return shuffled;
    }
}

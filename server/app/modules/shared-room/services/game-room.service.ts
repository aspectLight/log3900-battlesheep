import { GameService } from '@app/modules/game/services/game.service';
import { COUNTDOWN_INTERVAL, RANDOM_CALCULATOR_VALUE, TURN_BREAK, TURN_DURATION } from '@app/modules/shared-room/constants/game-room.constants';
import { GameRoom } from '@app/modules/shared-room/interfaces/game-room';
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

        const game = await this.gameService.getGameById(waitingRoom.gameId);
        if (game.mode === 'ctf') {
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

    addItemToInventory(roomId: string, playerId: string, item: Item): { shouldDrop?: { item: Item }; player: Player } {
        const room = this.findRoomById(roomId);
        const player: Player = room.players.find((p) => p.id === playerId);

        if (player.isVirtual && player.inventory.length >= 2) {
            const itemDropped = player.inventory.find((i) => i.type !== 'flag');
            const index = player.inventory.findIndex((i) => i.type === itemDropped.type);
            if (index >= 0) {
                player.inventory.splice(index, 1);
            }
            player.inventory.push(item);
            this.server.to(roomId).emit(GameRoomEvents.ItemDropped, { roomId, playerId, item: itemDropped, coords: player.position });
            return { shouldDrop: { item: itemDropped }, player };
        } else {
            player.inventory.push(item);
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
        }
        return player;
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

    changehost(roomId: string): void {
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

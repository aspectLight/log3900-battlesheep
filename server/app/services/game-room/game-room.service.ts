import { GameRoomEvents } from '@app/gateways/game-room/game-room.gateway.events';
import { GameRoom } from '@app/interfaces/game-room';
import { Player } from '@app/interfaces/player';
import { Injectable } from '@nestjs/common';
import { Server } from 'socket.io';

const TURN_DURATION = 30;
const TURN_BREAK = 3000;
const COUNTDOWN_INTERVAL = 1000;
const RANDOM_CALCULATOR_VALUE = 0.5;
@Injectable()
export class GameRoomService {
    private gameRooms: GameRoom[] = [];
    private server: Server;
    private turnTimeouts: Map<string, NodeJS.Timeout> = new Map();

    setServer(server: Server) {
        this.server = server;
    }

    createRoom(waitingRoom: GameRoom): GameRoom {
        if (this.findRoomById(waitingRoom.roomId)) {
            throw new Error('La salle existe déjà');
        }
        const newRoom: GameRoom = {
            roomId: `game_${waitingRoom.roomId}`,
            gameId: waitingRoom.gameId,
            organisatorId: waitingRoom.organisatorId,
            players: waitingRoom.players,
            isLocked: true,
            isDebugging: false,
            turnTimer: undefined,
            timeRemaining: undefined,
        };
        newRoom.players = this.assignTurnOrder(newRoom.players);
        newRoom.players = this.assignColor(newRoom.players);
        this.gameRooms.push(newRoom);

        return newRoom;
    }

    abandonGame(roomId: string, playerId: string): boolean {
        const room = this.findRoomById(roomId);
        if (!room) {
            throw new Error("La salle n'existe pas");
        }
        room.players = room.players.filter((player) => player.id !== playerId);
        if (room.organisatorId === playerId) {
            if (room.players.length > 0) {
                room.organisatorId = room.players[0].id;
            }
        }
        if (room.players.length <= 1) {
            this.deleteRoomById(roomId);
            return true;
        }
        return false;
    }

    deleteRoomById(roomId: string) {
        this.pauseTimer(roomId);
        this.clearTurnTimeout(roomId);
        this.gameRooms = this.gameRooms.filter((r) => r.roomId !== roomId);
    }

    prepareNextTurn(roomId: string): void {
        const room = this.findRoomById(roomId);
        if (!room || !room.players) {
            throw new Error("La partie n'existe pas");
        }

        for (const player of room.players) {
            player.movementPoints = player.stats['speed'].value;
        }

        const startTime = Date.now() + TURN_BREAK;

        this.server.to(roomId).emit(GameRoomEvents.TurnStarting, {
            nextPlayer: room.players[0],
            startTime,
        });

        const timeoutId = setTimeout(() => {
            this.startTurn(roomId);
        }, TURN_BREAK);
        this.turnTimeouts.set(roomId, timeoutId);
    }

    startTurn(roomId: string): void {
        const room = this.findRoomById(roomId);
        if (!room) throw new Error("La partie n'existe pas");

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
            throw new Error("La partie n'existe pas");
        }
        clearInterval(room.turnTimer);
        room.players.push(room.players.shift());

        this.prepareNextTurn(roomId);
    }

    endGame(roomId: string): void {
        const room = this.findRoomById(roomId);
        if (!room) {
            throw new Error("La partie n'existe pas");
        }

        this.gameRooms = this.gameRooms.filter((r) => r.roomId !== roomId);
    }

    findRoomById(roomId: string): GameRoom | null {
        return this.gameRooms.find((room) => room.roomId === roomId);
    }

    toggleDebugMode(roomId: string): boolean {
        const room = this.findRoomById(roomId);
        if (!room) {
            throw new Error("La salle n'existe pas");
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
        if (!room) throw new Error("La partie n'existe pas");

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
            const isOrganisator = room.organisatorId === playerId;

            return playerInRoom || isOrganisator;
        });
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
}

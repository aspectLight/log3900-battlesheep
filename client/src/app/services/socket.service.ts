/* eslint-disable max-lines */
/* eslint-disable @typescript-eslint/naming-convention */
/* eslint-disable max-params */
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { Player } from '@app/classes/player';
import { MAX_WINS } from '@app/constants/combat.constants';
import { ROUTES } from '@app/constants/routes.constants';
import { Coords } from '@app/interfaces/coords';
import { AttackPayload, AttackResult, CombatPayload, FlightResult } from '@app/interfaces/payload';
import { Room } from '@app/interfaces/room';
import { GameCreationService } from '@app/services/game-creation.service';
import { BehaviorSubject, Observable, Subject } from 'rxjs';
import { io, Socket } from 'socket.io-client';
import { environment } from 'src/environments/environment';
import { CombatService } from './combat.service';
import { GameManagerService } from './game-manager.service';
import { GameRoomService } from './game-room.service';
import { WaitingRoomService } from './waiting-room.service';

const sizeLimits: Record<number, { min: number; max: number }> = {
    10: { min: 2, max: 2 },
    15: { min: 2, max: 4 },
    20: { min: 2, max: 6 },
};

interface MoveInfo {
    roomId: string;
    playerId: string;
    map: Map<Coords, Coords[]>;
    selectedPath: Coords[];
}

@Injectable({
    providedIn: 'root',
})
export class SocketService {
    roomLocked$: Observable<boolean>;
    roomExists$: Observable<boolean>;
    isKicked$: Observable<boolean>;
    reservedAvatars$: Observable<{ reservorId: string; chosenAvatar: string }[]>;
    attackTrigger: Observable<void>;
    private room: Room;
    private roomLockedSubject = new BehaviorSubject<boolean>(false);
    private roomExistsSubject = new BehaviorSubject<boolean>(true);
    private isKickedSubject = new BehaviorSubject<boolean>(false);
    private reservedAvatarsSubject = new BehaviorSubject<{ reservorId: string; chosenAvatar: string }[]>([]);
    private attackTriggerSubject: Subject<void> = new Subject<void>();
    private socket: Socket;

    constructor(
        // private http: HttpClient,
        private waitingPlayerService: WaitingRoomService,
        private gameRoomService: GameRoomService,
        private gameManagerService: GameManagerService,
        private combatService: CombatService,
        private router: Router,
        private gameCreationService: GameCreationService,
    ) {
        this.setUpConnection();
    }

    setUpConnection() {
        this.connect();
        this.setUpListeners();
        this.attackTrigger = this.attackTriggerSubject.asObservable();
        this.roomLocked$ = this.roomLockedSubject.asObservable();
        this.roomExists$ = this.roomExistsSubject.asObservable();
        this.isKicked$ = this.isKickedSubject.asObservable();
        this.reservedAvatars$ = this.reservedAvatarsSubject.asObservable();
        this.roomLockedSubject.next(false);
        this.roomExistsSubject.next(true);
        this.isKickedSubject.next(false);
        this.waitingPlayerService.room$.subscribe((room) => {
            this.room = room;
        });
    }

    connect() {
        this.socket = io(environment.socketUrl);
    }

    getId(): string | undefined {
        return this.socket?.id;
    }

    getRoomId(): string {
        return this.gameRoomService.room.roomId;
    }

    createRoom(roomId: string, gameId: string, organisator: Player): void {
        this.socket.emit('createWaitingRoom', { roomId, gameId, organisator });
    }

    joinRoom(roomId: string, callback: (success: boolean, error?: string) => void): void {
        this.socket.emit('joinWaitingRoom', roomId);
        this.socket.once('joinRoomResponse', (response: { success: boolean; error?: string; room?: Room }) => {
            if (response.success) {
                if (response.room) {
                    this.waitingPlayerService.updateRoom(response.room);
                }
                this.roomLockedSubject.next(false);
                this.roomExistsSubject.next(true);
                this.isKickedSubject.next(false);
                this.waitingPlayerService.toggleLock(false);
            }
            callback(response.success, response.error);
        });
    }

    createPlayer(roomId: string, player: Player): void {
        this.socket.emit('createPlayer', { roomId, player });
    }

    leaveRoom(roomId: string, callback: (success: boolean, error?: string) => void): void {
        this.socket.emit('leaveRoom', roomId);
        this.socket.once('leaveRoomResponse', (response: { success: boolean; error?: string }) => {
            callback(response.success, response.error);
        });
    }

    toggleLockRoom(roomId: string): void {
        if (this.room.players.length < sizeLimits[this.gameCreationService.selectedGame.board.size].max) {
            this.socket.emit('toggleLockWaitingRoom', roomId);
        }
    }

    toggleDebugMode(): void {
        const room = this.gameManagerService.room;
        if (this.gameManagerService.currentPlayerId === this.socket.id && room.organisatorId === this.socket.id) {
            this.socket.emit('toggleDebugMode', room.roomId);
        }
    }

    kickPlayer(roomId: string, player: Player): void {
        this.socket.emit('kickPlayer', { roomId, player });
    }

    reserveAvatar(roomId: string, chosenAvatar: string): void {
        const currentRoom = this.waitingPlayerService.currentRoom.getValue();
        if (!currentRoom.organisatorId) return;
        if (!this.socket.id) {
            throw new Error('Socket ID non défini !');
        }

        const updatedReservations = this.reservedAvatarsSubject.value
            .filter((avatar) => avatar.reservorId !== this.socket.id)
            .concat([{ reservorId: this.socket.id, chosenAvatar }]);
        this.reservedAvatarsSubject.next(updatedReservations);

        this.socket.emit('reserveAvatar', { roomId, chosenAvatar });
    }

    getReservedAvatars(roomId: string): void {
        this.socket.emit('getReservedAvatars', { roomId });
    }

    startGame(roomId: string): void {
        if (
            this.room.players.length <= sizeLimits[this.gameCreationService.selectedGame.board.size].max &&
            this.room.players.length >= sizeLimits[this.gameCreationService.selectedGame.board.size].min &&
            this.roomLocked$
        ) {
            this.socket.emit('startGame', roomId);
        }
    }

    generateCode(callback: (code: string) => void): void {
        this.socket.emit('generateCode');
        this.socket.once('generateCodeResponse', (response: { code: string }) => {
            callback(response.code);
        });
    }

    getSocketId(): string | undefined {
        return this.socket.id;
    }

    abandonGame(roomId: string) {
        this.socket.emit('abandonGame', roomId);
    }

    endPlayerTurn(roomId: string): void {
        this.socket.emit('endTurn', roomId);
    }

    getPlayerMovements() {
        this.socket.emit('playerGetMovements', this.getRoomId());
    }

    movedPlayer({ roomId, playerId, map, selectedPath }: MoveInfo): void {
        const serializedMap = Array.from(map.entries());
        this.socket.emit('playerMoved', { roomId, playerId, serializedMap, selectedPath });
    }

    startCombat(combatPayload: CombatPayload) {
        this.socket.emit('startCombat', combatPayload);
    }

    flightAttempt(combatPayload: CombatPayload) {
        this.socket.emit('flightAttempt', combatPayload.roomId);
    }

    attack(attackPayload: AttackPayload) {
        this.socket.emit('attack', attackPayload);
    }

    teleportPlayer(destinationX: number, destinationY: number): void {
        const roomId = this.gameManagerService.room.roomId;
        const playerId = this.socket.id;
        const destination = { x: destinationX, y: destinationY };
        this.socket.emit('playerTeleported', { roomId, playerId, destination });
    }

    toggleDoor(x: number, y: number) {
        const roomId = this.gameManagerService.room.roomId;
        this.socket.emit('doorToggled', { roomId, x, y });
    }

    finishGame(winnerId: string) {
        const roomId = this.gameManagerService.room.roomId;
        this.socket.emit('finishGame', { roomId, winnerId });
    }

    reconnect(): void {
        if (this.socket) {
            this.socket.disconnect();
        }
        this.setUpConnection();
    }

    private setUpListeners(): void {
        this.socket.on('waitingRoomError', (error) => {
            // eslint-disable-next-line no-console
            console.warn('Erreur depuis le socket serveur de WaitingRoomGateway : \n', error);
        });

        this.socket.on('gameRoomError', (error) => {
            // eslint-disable-next-line no-console
            console.warn('Erreur depuis le socket serveur de GameRoomGateway : \n', error);
        });

        this.socket.on('waitingRoomCreated', (room) => {
            this.waitingPlayerService.updateRoom(room);
        });

        this.socket.on('playerCreated', (players) => {
            this.waitingPlayerService.addPlayer(players);
            this.gameManagerService.setMainPlayer(this.getId());
            if (this.room.players.length >= sizeLimits[this.gameCreationService.selectedGame.board.size].max) {
                this.socket.emit('toggleLockWaitingRoom', this.gameCreationService.gameCode);
            }
        });

        this.socket.on('leaveWaitingRoom', () => {
            this.roomExistsSubject.next(true);
            this.router.navigate([ROUTES.home]);
        });

        this.socket.on('gameRoomCreated', (gameRoom) => {
            this.waitingPlayerService.resetRoom();
            this.gameManagerService.resetManager();
            this.gameRoomService.updateRoom(gameRoom);
            this.gameManagerService.setMainPlayer(this.socket.id);
            if (gameRoom.organisatorId === this.socket.id) {
                this.socket.emit('playGame', gameRoom.roomId);
            }
            this.gameManagerService.redirect();
        });

        this.socket.on('updateAvatarReserved', (data) => {
            this.reservedAvatarsSubject.next(data.reservedAvatars);
        });

        this.socket.on('playerLeft', (playerId) => {
            this.waitingPlayerService.removePlayer(playerId);
        });

        this.socket.on('roomCanceled', () => {
            this.roomExistsSubject.next(false);
            this.waitingPlayerService.resetRoom();
        });

        this.socket.on('playerKicked', () => {
            this.isKickedSubject.next(true);
        });

        this.socket.on('waitingRoomLocked', () => {
            this.roomLockedSubject.next(true);
            this.waitingPlayerService.toggleLock(true);
        });

        this.socket.on('waitingRoomUnlocked', () => {
            this.roomLockedSubject.next(false);
            this.waitingPlayerService.toggleLock(false);
        });

        this.socket.on('playerSpawned', (players) => {
            this.gameRoomService.updatePlayers(players);
        });

        this.socket.on('turnStarting', (data) => {
            this.gameManagerService.handleTurnStarting(data.nextPlayer, data.startTime);

            const room = this.gameManagerService.room;
            const player = room.players.find((p) => p.id === this.socket.id);

            if (!player) return;

            this.gameManagerService.setMovementPoints(player.movementPoints);
            this.gameManagerService.setActionPoints(1);

            if (this.socket.id && data.nextPlayer.id === this.socket.id) {
                if (player) {
                    this.gameManagerService.selectPlayer(player);
                    this.gameManagerService.setMovementPoints(player.movementPoints);
                    this.gameManagerService.setActionPoints(1);
                }
                this.gameManagerService.currentPlayerId = this.socket.id;
                if (!room.isDebugging) return this.getPlayerMovements();
            } else {
                this.gameManagerService.currentPlayerId = data.nextPlayer.id;
            }
        });

        this.socket.on('playerMovements', (paths) => {
            const pathsMap = new Map<Coords, Coords[]>(paths);
            if (!this.gameManagerService.isDebugMode) this.gameManagerService.setPaths(pathsMap);
            else this.gameManagerService.clearPaths();
        });

        this.socket.on('playerMoved', (data) => {
            const player = this.gameManagerService.getBoard().getPlayerById(data.playerId);
            const map = new Map<Coords, Coords[]>(data.map);

            if (!player) {
                return;
            }

            this.gameManagerService.setPlayer(player);
            this.gameManagerService.setMovementPoints(data.movementPoints);
            this.gameManagerService.setPaths(map);
            this.gameManagerService.setSelectedPathFromCoords(data.selectedPath);
            this.gameManagerService.movePlayerFromPath(() => {
                if (this.gameManagerService.currentPlayerId === this.socket.id) {
                    const mainPlayer = this.gameManagerService.getMainPlayer();
                    if (!mainPlayer) return;
                    if (mainPlayer.movementPoints > 0 || mainPlayer.actionPoints > 0) return;
                    const gameRoomId = this.gameManagerService.getRoomId();
                    this.endPlayerTurn(gameRoomId);
                }
            });

            if (this.gameManagerService.currentPlayerId === this.socket.id) this.getPlayerMovements();
        });

        this.socket.on('playerTeleported', (data) => {
            const player = this.gameManagerService.getBoard().getPlayerById(data.playerId);
            if (!player) return;
            this.gameManagerService.setPlayer(player);
            this.gameManagerService.teleportPlayer(data.destination.x, data.destination.y);
            if (this.gameManagerService.currentPlayerId === this.socket.id && !this.gameManagerService.room.isDebugging) {
                this.getPlayerMovements();
            }
        });

        this.socket.on('updateCountdown', (countdown: number) => {
            this.gameManagerService.gameCountdown.next(countdown);
        });

        this.socket.on('combatTurnStarted', (combatRoom) => {
            this.combatService.setIsCombatPlayerTurn(false);
            if (combatRoom.currentPlayerId === this.getSocketId()) {
                this.combatService.setIsCombatPlayerTurn(true);
            }
            if (!this.combatService.isCombatMode) {
                this.combatService.setCombatRoom(combatRoom);
            }
        });

        this.socket.on('performAttack', () => {
            this.attackTriggerSubject.next();
        });

        this.socket.on('attackResult', (data: AttackResult) => {
            this.combatService.handleAttackResult(data);
        });

        this.socket.on('flightAttemptResult', (data: FlightResult) => {
            this.combatService.handleFlightResult(data);
        });

        this.socket.on('endCombat', (winnerId) => {
            this.combatService.handleEnd(winnerId);
            if (this.socket.id === this.combatService.loserId) {
                const player = this.gameManagerService.room.players.find((p) => p.id === this.socket.id);
                if (player) this.teleportPlayer(player?.spawnPoint.x, player?.spawnPoint.y);
                this.combatService.loserId = '';
            }
        });

        this.socket.on('updateScore', (winnerId) => {
            const result = this.gameManagerService.updateScore(winnerId);
            const mainPlayer = this.gameManagerService.getMainPlayer();
            if (!mainPlayer) return;
            if (mainPlayer.id === winnerId && result >= MAX_WINS) {
                this.finishGame(winnerId);
            }
        });

        this.socket.on('updateCombatCountDown', (countdown) => {
            this.combatService.combatCountdown.next(countdown);
        });

        this.socket.on('gameAbandoned', () => {
            this.router.navigate(['/home']);
            this.reconnect();
        });

        this.socket.on('gameCanceled', () => {
            this.gameManagerService.cancelGame();
            this.router.navigate(['/home']);
            this.reconnect();
        });

        this.socket.on('playerAbandoned', (playerId) => {
            this.gameManagerService.disconnectPlayer(playerId);
        });

        this.socket.on('debugModeEnabled', () => {
            this.gameRoomService.toggleDebugMode();
            this.gameManagerService.clearPaths();
            this.gameManagerService.setActionPoints(1);
        });

        this.socket.on('debugModeDisabled', () => {
            this.gameRoomService.toggleDebugMode();

            if (this.gameManagerService.currentPlayerId === this.socket.id) this.getPlayerMovements();
        });

        this.socket.on('doorToggled', (coords) => {
            const door = this.gameManagerService.getBoard().getCell(coords.x, coords.y);
            if (door?.tile.type === 'door') {
                door.tile.toggleState();
            }
            this.getPlayerMovements();
            if (this.gameManagerService.isDebugMode) this.gameManagerService.clearPaths();

            if (this.gameManagerService.currentPlayerId === this.socket.id) {
                const player = this.gameManagerService.getMainPlayer();
                if (player && player.movementPoints <= 0 && player.actionPoints <= 0) {
                    const gameRoomId = this.gameManagerService.getRoomId();
                    this.endPlayerTurn(gameRoomId);
                }
            }
        });

        this.socket.on('finishGame', () => {
            this.gameManagerService.finishGame();
        });
    }
}

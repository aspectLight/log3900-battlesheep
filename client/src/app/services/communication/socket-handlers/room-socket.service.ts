import { Injectable } from '@angular/core';
import { Item } from '@app/classes/entity/item';
import { Player } from '@app/classes/entity/player';
import { Reservation } from '@app/interfaces/reservation.interface';
import { RoomInfo } from '@app/interfaces/room-info.interface';
import { Room } from '@app/interfaces/room.interface';
import { ISocketService } from '@app/interfaces/socket-service.interface';
import { SocketService } from '@app/services/communication/socket-handlers/socket.service';
import { GameCreationService } from '@app/services/lobby/game-creation.service';
import { WaitingRoomService } from '@app/services/lobby/waiting-room.service';
import { GameManagerService } from '@app/services/state/game-manager.service';
import { GameRoomService } from '@app/services/state/game-room.service';
import { ErrorMessages } from '@common/error-messages.constants';
import { GameRoomEvents, WaitingRoomEvents } from '@common/socket.constants';
import { BehaviorSubject, Observable, Subject } from 'rxjs';
import { Socket } from 'socket.io-client';
/* eslint-disable @typescript-eslint/naming-convention */
const SIZE_LIMITS: Record<number, { min: number; max: number }> = {
    10: { min: 2, max: 2 },
    15: { min: 2, max: 4 },
    20: { min: 2, max: 6 },
};

@Injectable({
    providedIn: 'root',
})
export class RoomSocketService implements ISocketService {
    roomLocked$: Observable<boolean>;
    roomExists$: Observable<boolean>;
    isKicked$: Observable<boolean>;
    reservedAvatars$: Observable<Reservation[]>;
    availableRoomsChanged$: Observable<void>;
    /** Server push when `reserveAvatar` fails (same payload as ACK error); use for notifications. */
    avatarReservationFailed$: Observable<{ error: string }>;
    /** Waiting room transitioned to game but this socket is not in `gameRoom.players` (e.g. still on character creation). */
    characterCreationGameStartedLeftOut$: Observable<void>;
    socket: Socket;
    private room: Room;
    private roomLockedSubject = new BehaviorSubject<boolean>(false);
    private roomExistsSubject = new BehaviorSubject<boolean>(true);
    private isKickedSubject = new BehaviorSubject<boolean>(false);
    private reservedAvatarsSubject = new BehaviorSubject<Reservation[]>([]);
    private availableRoomsChangedSubject = new Subject<void>();
    private readonly avatarReservationFailedSubject = new Subject<{ error: string }>();
    private readonly characterCreationGameStartedLeftOutSubject = new Subject<void>();

    constructor(
        private socketService: SocketService,
        private waitingPlayerService: WaitingRoomService,
        private gameCreationService: GameCreationService,
        private gameManagerService: GameManagerService,
        private gameRoomService: GameRoomService,
    ) {
        this.socketService.registerSocketService(this);
        this.setUpConnection();
    }

    setUpConnection(): void {
        this.sync();
        this.roomLockedSubject.next(false);
        this.roomExistsSubject.next(true);
        this.isKickedSubject.next(false);
        this.reservedAvatarsSubject.next([]);

        this.roomLocked$ = this.roomLockedSubject.asObservable();
        this.roomExists$ = this.roomExistsSubject.asObservable();
        this.isKicked$ = this.isKickedSubject.asObservable();
        this.reservedAvatars$ = this.reservedAvatarsSubject.asObservable();
        this.availableRoomsChanged$ = this.availableRoomsChangedSubject.asObservable();
        this.avatarReservationFailed$ = this.avatarReservationFailedSubject.asObservable();
        this.characterCreationGameStartedLeftOut$ = this.characterCreationGameStartedLeftOutSubject.asObservable();

        this.waitingPlayerService.room$.subscribe((room) => {
            this.room = room;
        });

        this.setUpListeners();
    }

    sync() {
        this.socket = this.socketService.socket;
    }

    resetRoomState(): void {
        this.roomLockedSubject.next(false);
        this.roomExistsSubject.next(true);
        this.isKickedSubject.next(false);
        this.reservedAvatarsSubject.next([]);
    }

    getId(): string | undefined {
        return this.socket.id;
    }

    async createRoom(roomId: string, gameId: string, host: Player): Promise<void> {
        const friendsOnly = this.gameCreationService.friendsOnly;
        const entryFee = this.gameCreationService.entryFee ?? 0;
        const result = await this.socket.emitWithAck(WaitingRoomEvents.CreateWaitingRoom, { roomId, gameId, host, friendsOnly, entryFee });
        if (!result.success) {
            throw new Error(result.error || 'Failed to create waiting room');
        }
    }

    joinRoom(roomId: string, callback: (success: boolean, error?: string) => void): void {
        this.socket.emit(WaitingRoomEvents.JoinWaitingRoom, roomId);
        this.socket.once(WaitingRoomEvents.JoinRoomResponse, (response: { success: boolean; error?: string; room?: Room }) => {
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

    createPlayer(roomId: string, player: Player) {
        this.socket.emit(WaitingRoomEvents.CreatePlayer, { roomId, player });
    }

    leaveRoom(roomId: string, callback: (success: boolean, error?: string) => void): void {
        this.socket.emit(WaitingRoomEvents.LeaveWaitingRoom, roomId);
        this.socket.once(WaitingRoomEvents.LeaveRoomResponse, (response: { success: boolean; error?: string }) => {
            callback(response.success, response.error);
        });
    }

    toggleLockRoom(roomId: string): void {
        const boardSize = this.gameCreationService.selectedGame?.board?.size ?? (this.waitingPlayerService.currentRoom.getValue() as any)?.boardSize;

        if (boardSize && this.room.players.length < SIZE_LIMITS[boardSize].max) {
            this.socket.emit(WaitingRoomEvents.ToggleLockWaitingRoom, roomId);
        } else {
            this.waitingPlayerService.maxPlayerLimitReached();
        }
    }

    kickPlayer(roomId: string, player: Player): void {
        this.socket.emit(WaitingRoomEvents.KickPlayer, { roomId, player });
    }

    async reserveAvatar(roomId: string, chosenAvatar: string, playerId: string, isVirtual: boolean = false): Promise<void> {
        const currentRoom = this.waitingPlayerService.currentRoom.getValue();
        if (!currentRoom.hostId) return;
        if (!this.socket.id) {
            throw new Error(ErrorMessages.SocketIdNotDefined);
        }

        const result = await this.socket.emitWithAck(WaitingRoomEvents.ReserveAvatar, { roomId, chosenAvatar, playerId, isVirtual });
        if (!result.success) {
            throw new Error(result.error || 'Failed to reserve avatar');
        }

        const updatedReservations = this.reservedAvatarsSubject.value.concat([{ reservorId: this.socket.id, chosenAvatar }]);
        this.reservedAvatarsSubject.next(updatedReservations);
    }

    getReservedAvatars(roomId: string): void {
        this.socket.emit(WaitingRoomEvents.GetReservedAvatars, { roomId });
    }

    async startGame(roomId: string): Promise<void> {
        const boardSize = this.gameCreationService.selectedGame?.board?.size ?? (this.waitingPlayerService.currentRoom.getValue() as any)?.boardSize;

        if (boardSize && this.room.players.length <= SIZE_LIMITS[boardSize].max && this.room.players.length >= SIZE_LIMITS[boardSize].min) {
            const result = await this.socket.emitWithAck(WaitingRoomEvents.StartGame, roomId);
            if (!result.success) {
                throw new Error(result.error || 'Failed to start game');
            }
        }
    }

    generateCode(callback: (code: string) => void): void {
        this.socket.emit(WaitingRoomEvents.GenerateCode);
        this.socket.once(WaitingRoomEvents.GenerateCodeResponse, (response: { code: string }) => {
            callback(response.code);
        });
    }

    getAvailableRooms(callback: (rooms: RoomInfo[]) => void): void {
        this.socket.emit(WaitingRoomEvents.GetAvailableRooms);
        this.socket.once(WaitingRoomEvents.AvailableRoomsResponse, callback);
    }

    toggleDropInDropOut(roomId: string): void {
        this.socket.emit(WaitingRoomEvents.ToggleDropInDropOut, roomId);
    }

    rejoinGame(roomId: string, firebaseUid: string, callback: (success: boolean, error?: string) => void): void {
        this.socket.emit(GameRoomEvents.JoinGameRoom, { roomId, firebaseUid });
        this.socket.once(
            GameRoomEvents.JoinGameRoomResponse,
            (response: { success: boolean; error?: string; gameRoom?: any; currentBoard?: any; currentPlayerId?: string }) => {
                if (response.success && response.gameRoom) {
                    this.gameManagerService.resetManager();
                    this.gameRoomService.updateRoom(response.gameRoom);
                    this.gameManagerService.loadGame(response.currentBoard).subscribe({
                        next: () => {
                            this.gameManagerService.isGameLoaded = true;
                            this.gameManagerService.addPlayersToBoard(this.gameManagerService.getPlayers(), true);
                            this.gameManagerService.setMainPlayer(this.socket.id);
                            if (response.currentPlayerId) {
                                this.gameManagerService.currentPlayerId = response.currentPlayerId;
                            }
                            this.gameManagerService.redirect();
                        },
                    });
                }
                callback(response.success, response.error);
            },
        );
    }

    joinGameRoom(roomId: string, player: any, callback: (success: boolean, error?: string, gameRoom?: any) => void): void {
        this.socket.emit(GameRoomEvents.JoinGameRoom, { roomId, player });
        this.socket.once(
            GameRoomEvents.JoinGameRoomResponse,
            (response: { success: boolean; error?: string; gameRoom?: any; currentBoard?: any; isReturning?: boolean; currentPlayerId?: string }) => {
                if (response.success && response.gameRoom) {
                    this.gameManagerService.resetManager();
                    this.gameRoomService.updateRoom(response.gameRoom);
                    this.gameManagerService.loadGame(response.currentBoard).subscribe({
                        next: () => {
                            this.gameManagerService.isGameLoaded = true;
                            this.gameManagerService.addPlayersToBoard(this.gameManagerService.getPlayers(), true);
                            this.gameManagerService.setMainPlayer(this.socket.id);
                            if (response.currentPlayerId) {
                                this.gameManagerService.currentPlayerId = response.currentPlayerId;
                            }
                            this.gameManagerService.redirect();
                        },
                    });
                }
                callback(response.success, response.error, response.gameRoom);
            },
        );
    }

    getMessagesFromWaitingRoom(): void {
        this.socket.emit('getMessagesFromWaitingRoom', this.waitingPlayerService.currentRoom.getValue().roomId);
    }

    sendMessageToWaitingRoom(message: string, playerName: string | null): void {
        this.socket.emit('sendMessageToWaitingRoom', { message, playerName, roomId: this.waitingPlayerService.currentRoom.getValue().roomId });
    }

    private setUpListeners(): void {
        this.socket.on(WaitingRoomEvents.WaitingRoomError, (error) => {
            // eslint-disable-next-line no-console
            console.warn('Erreur depuis le socket serveur de WaitingRoomGateway : \n', error);
        });

        this.socket.on(WaitingRoomEvents.WaitingRoomCreated, (room) => {
            this.waitingPlayerService.updateRoom(room);
        });

        this.socket.on(WaitingRoomEvents.PlayerCreated, (players) => {
            this.waitingPlayerService.addPlayer(players);
            const boardSize =
                this.gameCreationService.selectedGame?.board?.size ?? (this.waitingPlayerService.currentRoom.getValue() as any)?.boardSize;

            if (boardSize && this.room.players.length >= SIZE_LIMITS[boardSize].max) {
                this.socket.emit(WaitingRoomEvents.ToggleLockWaitingRoom, this.gameCreationService.gameCode);
            }
        });

        this.socket.on(WaitingRoomEvents.LeaveWaitingRoom, () => {
            this.resetRoomState();
            this.socketService.navigateToHome();
        });

        this.socket.on(GameRoomEvents.GameRoomCreated, (gameRoom: Room) => {
            const socketId = this.socket.id;
            const inRoster = !!(socketId && gameRoom.players?.some((p) => p.id === socketId));
            if (!inRoster) {
                this.resetRoomState();
                this.waitingPlayerService.resetRoom();
                this.socket.emit(GameRoomEvents.LeaveGameRoom, gameRoom.roomId);
                this.characterCreationGameStartedLeftOutSubject.next();
                return;
            }
            this.waitingPlayerService.resetRoom();
            this.gameManagerService.resetManager();
            this.gameRoomService.updateRoom(gameRoom);
            if (gameRoom.hostId === this.socket.id) {
                this.socket.emit(GameRoomEvents.PlayGame, gameRoom.roomId);
            }
            this.gameManagerService.redirect();
        });

        this.socket.on(WaitingRoomEvents.UpdateAvatarReserved, (data) => {
            this.reservedAvatarsSubject.next(data.reservedAvatars);
        });

        this.socket.on(WaitingRoomEvents.AvatarReservationFailed, (data: { error?: string }) => {
            const error = data && typeof data.error === 'string' ? data.error : '';
            if (error.length > 0) {
                this.avatarReservationFailedSubject.next({ error });
            }
        });

        this.socket.on(WaitingRoomEvents.PlayerLeft, (playerId) => {
            this.waitingPlayerService.removePlayer(playerId);
        });

        this.socket.on(WaitingRoomEvents.RoomCanceled, () => {
            this.resetRoomState();
            this.roomExistsSubject.next(false);
            this.waitingPlayerService.resetRoom();
        });

        this.socket.on(WaitingRoomEvents.PlayerKicked, () => {
            // Reset room flags without emitting an intermediate false on isKicked$,
            // then immediately signal the kick so the UI shows the popup.
            this.roomLockedSubject.next(false);
            this.roomExistsSubject.next(true);
            this.reservedAvatarsSubject.next([]);
            this.isKickedSubject.next(true);
        });

        this.socket.on(WaitingRoomEvents.WaitingRoomLocked, () => {
            this.roomLockedSubject.next(true);
            this.waitingPlayerService.toggleLock(true);
        });

        this.socket.on(WaitingRoomEvents.WaitingRoomUnlocked, () => {
            this.roomLockedSubject.next(false);
            this.waitingPlayerService.toggleLock(false);
        });

        this.socket.on(WaitingRoomEvents.DropInDropOutToggled, (data: { dropInDropOut: boolean }) => {
            this.waitingPlayerService.toggleDropInDropOut(data.dropInDropOut);
        });

        this.socket.on(WaitingRoomEvents.AvailableRoomsChanged, () => {
            this.availableRoomsChangedSubject.next();
        });

        this.socket.on(GameRoomEvents.PlayerJoinedGame, (data: { player: any; isReturning: boolean; players: any[] }) => {
            this.gameRoomService.updatePlayers(data.players);

            // Place the newly joined player on the board so their movements are visible to other clients
            const board = this.gameManagerService.getBoard();
            if (board) {
                // Remove any stale board entry for this player first (ghost left by drop-out)
                this.gameManagerService.removePlayer(data.player.id);

                const position = data.player.position;
                if (position) {
                    const cell = board.getCell(position.x, position.y);
                    if (cell && !cell.getEntity()) {
                        const newPlayer = Player.fromObject(data.player);
                        newPlayer.addCell(cell);
                        cell.addEntity(newPlayer);
                    }
                }

                const spawnPoint = data.player.spawnPoint;
                if (spawnPoint) {
                    const spawnCell = board.getCell(spawnPoint.x, spawnPoint.y);
                    if (spawnCell && !spawnCell.item) {
                        spawnCell.item = new Item('spawnPoint');
                        if (data.player.color) {
                            spawnCell.item.imagePath = `assets/items/${data.player.color}_spawn.gif`;
                        }
                    }
                }
            }
        });
    }
}

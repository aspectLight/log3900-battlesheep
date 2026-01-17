import { Injectable } from '@angular/core';
import { Player } from '@app/classes/player';
import { Reservation } from '@app/interfaces/reservation';
import { Room } from '@app/interfaces/room';
import { ISocketService } from '@app/interfaces/socket-service.interface';
import { GameCreationService } from '@app/services/game-creation.service';
import { GameManagerService } from '@app/services/game-manager.service';
import { GameRoomService } from '@app/services/game-room.service';
import { SocketService } from '@app/services/socket.service';
import { WaitingRoomService } from '@app/services/waiting-room.service';
import { ErrorMessages } from '@common/error-messages.constants';
import { GameRoomEvents, WaitingRoomEvents } from '@common/socket.constants';
import { BehaviorSubject, Observable } from 'rxjs';
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
    socket: Socket;
    private room: Room;
    private roomLockedSubject = new BehaviorSubject<boolean>(false);
    private roomExistsSubject = new BehaviorSubject<boolean>(true);
    private isKickedSubject = new BehaviorSubject<boolean>(false);
    private reservedAvatarsSubject = new BehaviorSubject<Reservation[]>([]);

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

        this.waitingPlayerService.room$.subscribe((room) => {
            this.room = room;
        });

        this.setUpListeners();
    }

    sync() {
        this.socket = this.socketService.socket;
    }

    getId(): string | undefined {
        return this.socket.id;
    }

    async createRoom(roomId: string, gameId: string, organisator: Player): Promise<void> {
        const result = await this.socket.emitWithAck(WaitingRoomEvents.CreateWaitingRoom, { roomId, gameId, organisator });
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
        if (this.room.players.length < SIZE_LIMITS[this.gameCreationService.selectedGame.board.size].max) {
            this.socket.emit(WaitingRoomEvents.ToggleLockWaitingRoom, roomId);
        } else {
            this.waitingPlayerService.maxPlayerLimitReached();
        }
    }

    kickPlayer(roomId: string, player: Player): void {
        this.socket.emit(WaitingRoomEvents.KickPlayer, { roomId, player });
    }

    async reserveAvatar(roomId: string, chosenAvatar: string, playerId: string): Promise<void> {
        const currentRoom = this.waitingPlayerService.currentRoom.getValue();
        if (!currentRoom.organisatorId) return;
        if (!this.socket.id) {
            throw new Error(ErrorMessages.SocketIdNotDefined);
        }

        const result = await this.socket.emitWithAck(WaitingRoomEvents.ReserveAvatar, { roomId, chosenAvatar, playerId });
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
        if (
            this.room.players.length <= SIZE_LIMITS[this.gameCreationService.selectedGame.board.size].max &&
            this.room.players.length >= SIZE_LIMITS[this.gameCreationService.selectedGame.board.size].min &&
            this.roomLocked$
        ) {
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
            if (this.room.players.length >= SIZE_LIMITS[this.gameCreationService.selectedGame.board.size].max) {
                this.socket.emit(WaitingRoomEvents.ToggleLockWaitingRoom, this.gameCreationService.gameCode);
            }
        });

        this.socket.on(WaitingRoomEvents.LeaveWaitingRoom, () => {
            this.roomExistsSubject.next(true);
            this.socketService.navigateToHome();
        });

        this.socket.on(GameRoomEvents.GameRoomCreated, (gameRoom) => {
            this.waitingPlayerService.resetRoom();
            this.gameManagerService.resetManager();
            this.gameRoomService.updateRoom(gameRoom);
            if (gameRoom.organisatorId === this.socket.id) {
                this.socket.emit(GameRoomEvents.PlayGame, gameRoom.roomId);
            }
            this.gameManagerService.redirect();
        });

        this.socket.on(WaitingRoomEvents.UpdateAvatarReserved, (data) => {
            this.reservedAvatarsSubject.next(data.reservedAvatars);
        });

        this.socket.on(WaitingRoomEvents.PlayerLeft, (playerId) => {
            this.waitingPlayerService.removePlayer(playerId);
        });

        this.socket.on(WaitingRoomEvents.RoomCanceled, () => {
            this.roomExistsSubject.next(false);
            this.waitingPlayerService.resetRoom();
        });

        this.socket.on(WaitingRoomEvents.PlayerKicked, () => {
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
    }
}

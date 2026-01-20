/* eslint-disable @typescript-eslint/no-empty-function */
/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable max-lines */
import { TestBed } from '@angular/core/testing';
import { Router } from '@angular/router';
import { Player } from '@app/classes/entity/player';
import { ROUTES } from '@app/constants/routes.constants';
import { Room } from '@app/interfaces/room.interface';
import { SocketService } from '@app/services/communication/socket-handlers/socket.service';
import { GameCreationService } from '@app/services/lobby/game-creation.service';
import { WaitingRoomService } from '@app/services/lobby/waiting-room.service';
import { GameManagerService } from '@app/services/state/game-manager.service';
import { GameRoomService } from '@app/services/state/game-room.service';
import { ErrorMessages } from '@common/error-messages.constants';
import { GameRoomEvents, WaitingRoomEvents } from '@common/socket.constants';
import { BehaviorSubject, of } from 'rxjs';
import { Socket } from 'socket.io-client';
import { RoomSocketService } from './room-socket.service';

describe('RoomSocketService', () => {
    let service: RoomSocketService;
    let mockWaitingRoomService: jasmine.SpyObj<WaitingRoomService>;
    let mockGameManagerService: jasmine.SpyObj<GameManagerService>;
    let mockGameRoomService: jasmine.SpyObj<GameRoomService>;
    let mockRouter: jasmine.SpyObj<Router>;
    let mockSocket: jasmine.SpyObj<Socket>;
    let mockGameCreationService: jasmine.SpyObj<GameCreationService>;
    let mockSocketService: jasmine.SpyObj<SocketService>;

    beforeEach(() => {
        mockWaitingRoomService = jasmine.createSpyObj('WaitingRoomService', [
            'updateRoom',
            'toggleLock',
            'addPlayer',
            'removePlayer',
            'startGame',
            'resetRoom',
            'maxPlayerLimitReached',
        ]);
        mockWaitingRoomService.currentRoom = jasmine.createSpyObj('BehaviorSubject', ['getValue']);
        (mockWaitingRoomService.currentRoom.getValue as jasmine.Spy).and.returnValue({ hostId: 'testhostId' });
        Object.defineProperty(mockWaitingRoomService, 'room$', {
            get: () => of(null),
        });

        const mockPlayer = new Player();
        mockPlayer.id = 'testSocketId';
        mockPlayer.movementPoints = 3;
        mockPlayer.actionPoints = 1;
        mockPlayer.spawnPoint = { x: 0, y: 0 };

        mockGameManagerService = jasmine.createSpyObj('GameManagerService', ['setMainPlayer', 'redirect', 'resetManager', 'cancelGame'], {
            room: {
                roomId: 'testRoomId',
                hostId: 'testSocketId',
                isDebugging: false,
                players: [mockPlayer],
            },
            currentPlayerId: 'testSocketId',
            isDebugMode: false,
            gameCountdown: jasmine.createSpyObj('BehaviorSubject', ['next']),
        });
        mockGameManagerService.redirect.and.callFake(() => {
            mockRouter.navigate([ROUTES.game]);
        });

        mockGameRoomService = jasmine.createSpyObj('GameRoomService', ['updateRoom', 'updatePlayers'], {
            room: { roomId: 'testRoomId' },
        });

        mockRouter = jasmine.createSpyObj('Router', ['navigate']);

        mockSocket = jasmine.createSpyObj('Socket', ['emit', 'on', 'once', 'id', 'disconnect'], { id: 'testSocketId' });

        const mockSelectedGameBoard = jasmine.createSpyObj('Board', [
            'getPlayerById',
            'getCell',
            'createMatrix',
            'createMatrixFromData',
            'getMatrix',
            'getSize',
            'getPlayers',
            'addPlayer',
        ]);
        mockSelectedGameBoard.matrix = [];
        mockSelectedGameBoard.size = 10;

        mockGameCreationService = jasmine.createSpyObj('GameCreationService', [], {
            selectedGame: { board: mockSelectedGameBoard },
            gameCode: 'testGameCode',
        });

        mockSocketService = jasmine.createSpyObj('SocketService', ['registerSocketService', 'navigateToHome', 'changeName'], {
            socket: mockSocket,
        });

        TestBed.configureTestingModule({
            providers: [
                RoomSocketService,
                { provide: WaitingRoomService, useValue: mockWaitingRoomService },
                { provide: GameManagerService, useValue: mockGameManagerService },
                { provide: GameRoomService, useValue: mockGameRoomService },
                { provide: Router, useValue: mockRouter },
                { provide: Socket, useValue: mockSocket },
                { provide: GameCreationService, useValue: mockGameCreationService },
                { provide: SocketService, useValue: mockSocketService },
            ],
        });

        service = TestBed.inject(RoomSocketService);

        service['socket'] = mockSocket;
        service['room'] = { players: [] } as any;

        service['roomLockedSubject'] = new BehaviorSubject<boolean>(false);
        service['roomExistsSubject'] = new BehaviorSubject<boolean>(true);
        service['isKickedSubject'] = new BehaviorSubject<boolean>(false);
        service['reservedAvatarsSubject'] = new BehaviorSubject<{ reservorId: string; chosenAvatar: string }[]>([]);

        service.roomLocked$ = service['roomLockedSubject'].asObservable();
        service.roomExists$ = service['roomExistsSubject'].asObservable();
        service.isKicked$ = service['isKickedSubject'].asObservable();
        service.reservedAvatars$ = service['reservedAvatarsSubject'].asObservable();
    });

    describe('Basic functionality', () => {
        it('should create', () => {
            expect(service).toBeTruthy();
        });

        it('should return the socket ID when getId is called', () => {
            expect(service.getId()).toBe('testSocketId');
        });
    });

    describe('Room creation and joining', () => {
        it('should emit "createWaitingRoom" when createRoom is called', () => {
            service.createRoom('room1', 'game1', { id: 'player1', name: 'Test' } as Player);
            expect(mockSocket.emit).toHaveBeenCalledWith(WaitingRoomEvents.CreateWaitingRoom, {
                roomId: 'room1',
                gameId: 'game1',
                host: { id: 'player1', name: 'Test' },
            });
        });

        it('should join a room and update state on success', () => {
            const roomId = 'testRoomId';
            const mockRoom = { id: roomId, players: [], roomId: '', hostId: '', gameId: '', isLocked: false, isDebugging: false } as Room;
            const callback = jasmine.createSpy('callback');

            service.joinRoom(roomId, callback);
            expect(mockSocket.emit).toHaveBeenCalledWith(WaitingRoomEvents.JoinWaitingRoom, roomId);

            const response = { success: true, room: mockRoom };
            mockSocket.once.calls.argsFor(0)[1](response);

            expect(mockWaitingRoomService.updateRoom).toHaveBeenCalledWith(mockRoom);
            expect(mockWaitingRoomService.toggleLock).toHaveBeenCalledWith(false);
            expect(callback).toHaveBeenCalledWith(true, undefined);
        });

        it('should call callback with error on failure of joinRoom', () => {
            const roomId = 'testRoomId';
            const callback = jasmine.createSpy('callback');
            const errorMessage = 'Test Error Message';

            service.joinRoom(roomId, callback);
            expect(mockSocket.emit).toHaveBeenCalledWith(WaitingRoomEvents.JoinWaitingRoom, roomId);

            const response = { success: false, error: errorMessage };
            mockSocket.once.calls.argsFor(0)[1](response);

            expect(mockWaitingRoomService.updateRoom).not.toHaveBeenCalled();
            expect(mockWaitingRoomService.toggleLock).not.toHaveBeenCalled();
            expect(callback).toHaveBeenCalledWith(false, errorMessage);
        });
    });

    describe('Player management', () => {
        it('should emit "createPlayer" on createPlayer call', () => {
            const player = new Player();
            service.createPlayer('testRoomId', player);

            expect(mockSocket.emit).toHaveBeenCalledWith(WaitingRoomEvents.CreatePlayer, { roomId: 'testRoomId', player });
        });

        it('should emit "kickPlayer" on kickPlayer call', () => {
            const roomId = 'testRoomId';
            const player = new Player();
            service.kickPlayer(roomId, player);

            expect(mockSocket.emit).toHaveBeenCalledWith(WaitingRoomEvents.KickPlayer, { roomId: 'testRoomId', player });
        });
    });

    describe('Room management', () => {
        it('should leave the room on success', () => {
            const roomId = 'testRoomId';
            const callback = jasmine.createSpy('callback');

            service.leaveRoom(roomId, callback);

            expect(mockSocket.emit).toHaveBeenCalledWith(WaitingRoomEvents.LeaveWaitingRoom, roomId);

            const response = { success: true };
            mockSocket.once.calls.argsFor(0)[1](response);

            expect(callback).toHaveBeenCalledWith(true, undefined);
        });

        it('should call callback with error on failure of leaveRoom', () => {
            const roomId = 'testRoomId';
            const callback = jasmine.createSpy('callback');
            const errorMessage = 'Test Error Message';

            service.leaveRoom(roomId, callback);
            expect(mockSocket.emit).toHaveBeenCalledWith(WaitingRoomEvents.LeaveWaitingRoom, roomId);

            const response = { success: false, error: errorMessage };
            mockSocket.once.calls.argsFor(0)[1](response);

            expect(mockWaitingRoomService.updateRoom).not.toHaveBeenCalled();
            expect(mockWaitingRoomService.toggleLock).not.toHaveBeenCalled();
            expect(callback).toHaveBeenCalledWith(false, errorMessage);
        });

        it('should emit "toggleLockWaitingRoom" on toggleLockRoom call', () => {
            const roomId = 'testRoomId';
            service.toggleLockRoom(roomId);

            expect(mockSocket.emit).toHaveBeenCalledWith(WaitingRoomEvents.ToggleLockWaitingRoom, 'testRoomId');
        });

        it('should emit "startGame" on startGame call', () => {
            const roomId = 'testRoomId';
            service['room'] = { players: [new Player(), new Player()] } as any;
            service.startGame(roomId);
            expect(mockSocket.emit).toHaveBeenCalledWith(WaitingRoomEvents.StartGame, roomId);
        });

        it('should generate code', () => {
            const callback = jasmine.createSpy('callback');

            service.generateCode(callback);

            expect(mockSocket.emit).toHaveBeenCalledWith(WaitingRoomEvents.GenerateCode);

            const response = { code: '0000' };
            mockSocket.once.calls.argsFor(0)[1](response);

            expect(callback).toHaveBeenCalledWith('0000');
        });

        it('should send message to waiting room', () => {
            const message = 'Hello, world!';
            service.sendMessageToWaitingRoom(message, 'player1');

            expect(mockSocket.emit).toHaveBeenCalled();
        });
    });

    describe('Avatar management', () => {
        it('should emit "reserveAvatar" with correct data', () => {
            const roomId = '123';
            const chosenAvatar = 'avatar1';

            service.reserveAvatar(roomId, chosenAvatar, 'player1');

            service.reservedAvatars$.subscribe((avatars) => {
                expect(avatars).toEqual([{ reservorId: mockSocket.id as string, chosenAvatar }]);
            });

            expect(mockSocket.emit).toHaveBeenCalledWith(WaitingRoomEvents.ReserveAvatar, { roomId, chosenAvatar, playerId: 'player1' });
        });

        it('should return early from reserveAvatar when room has no hostId', () => {
            (mockWaitingRoomService.currentRoom.getValue as jasmine.Spy).and.returnValue({ hostId: null });

            const roomId = '123';
            const chosenAvatar = 'avatar1';

            service.reserveAvatar(roomId, chosenAvatar, 'player1');

            service.reservedAvatars$.subscribe((avatars) => {
                expect(avatars).toEqual([]);
            });
            expect(mockSocket.emit).not.toHaveBeenCalled();
        });

        it('should update reservedAvatars when reserveAvatar is called multiple times', () => {
            const roomId = '123';

            // Reset the subject to make sure we start with a clean state
            service['reservedAvatarsSubject'].next([]);

            // Create a spy to track the values emitted by the subject
            const nextSpy = spyOn(service['reservedAvatarsSubject'], 'next').and.callThrough();

            // First reservation
            const avatar1 = 'avatar1';
            service.reserveAvatar(roomId, avatar1, 'player1');

            // Verify first call's data (in the implementation, concat creates a new array with the existing items + new item)
            expect(nextSpy.calls.mostRecent().args[0]).toEqual([{ reservorId: 'testSocketId', chosenAvatar: avatar1 }]);

            // Reset the spy counter to focus only on the next call
            nextSpy.calls.reset();

            // Make the second reservation
            const avatar2 = 'avatar2';
            service.reserveAvatar(roomId, avatar2, 'player1');

            // Verify second call - after the first call the subject contains one item, the second call adds another
            expect(nextSpy.calls.mostRecent().args[0]).toEqual([
                { reservorId: 'testSocketId', chosenAvatar: avatar1 },
                { reservorId: 'testSocketId', chosenAvatar: avatar2 },
            ]);

            // This is the correct behavior based on how the service is implemented with concat
            // In a real application, the server would respond with UpdateAvatarReserved event
            // which would replace the entire array, but that's tested in a different test
        });

        it('should throw an error if socket ID is undefined', () => {
            delete mockSocket.id;
            expect(async () => service.reserveAvatar('123', 'avatar1', 'player1')).toThrowError(ErrorMessages.SocketIdNotDefined);
        });

        it('should emit "getReservedAvatars" on getReservedAvatars call', () => {
            const roomId = 'testRoomId';
            service.getReservedAvatars(roomId);

            expect(mockSocket.emit).toHaveBeenCalledWith(WaitingRoomEvents.GetReservedAvatars, { roomId: 'testRoomId' });
        });
    });

    describe('Socket event handlers', () => {
        // eslint-disable-next-line @typescript-eslint/promise-function-async
        function triggerSocketEvent(eventName: string, data?: any): ((data?: any) => void) | undefined {
            service['setUpListeners']();

            const args = mockSocket.on.calls.allArgs();
            const eventHandler = args.find((arg) => arg[0] === eventName);

            if (eventHandler && typeof eventHandler[1] === 'function') {
                if (data !== undefined) {
                    eventHandler[1](data);
                } else {
                    eventHandler[1]();
                }
                return eventHandler[1];
            }
            return undefined;
        }

        it('should listen to waitingRoomError and warn about it', () => {
            spyOn(console, 'warn');
            const error = 'Erreur 1';

            triggerSocketEvent(WaitingRoomEvents.WaitingRoomError, error);
            /* eslint-disable no-console */
            expect(console.warn).toHaveBeenCalledWith('Erreur depuis le socket serveur de WaitingRoomGateway : \n', error);
        });

        it('should listen to waitingRoomCreated and call updateRoom', () => {
            const mockRoom = { id: '0000', players: [], roomId: '', hostId: '', gameId: '', isLocked: false, isDebugging: false } as Room;

            triggerSocketEvent(WaitingRoomEvents.WaitingRoomCreated, mockRoom);

            expect(mockWaitingRoomService.updateRoom).toHaveBeenCalledWith(mockRoom);
        });

        it('should listen to playerCreated and call addPlayer', () => {
            const players = [new Player(), new Player()];

            triggerSocketEvent(WaitingRoomEvents.PlayerCreated, players);

            expect(mockWaitingRoomService.addPlayer).toHaveBeenCalledWith(players);
            // The setMainPlayer call is commented out in the actual implementation
            // expect(mockGameManagerService.setMainPlayer).toHaveBeenCalledWith(mockSocket.id);
        });

        it('should automatically lock room when max players is reached', () => {
            const maxPlayers = 2;
            const players = Array(maxPlayers)
                .fill(null)
                .map(() => new Player());
            service['room'] = { players } as any;

            triggerSocketEvent(WaitingRoomEvents.PlayerCreated, players);

            expect(mockSocket.emit).toHaveBeenCalledWith(WaitingRoomEvents.ToggleLockWaitingRoom, 'testGameCode');
        });

        it('should call maxPlayerLimitReached if player count is above size limit in toggleLockRoom', () => {
            const maxPlayers = 2;
            const players = Array(maxPlayers)
                .fill(null)
                .map(() => new Player());
            service['room'] = { players } as any;

            service.toggleLockRoom('room123');

            expect(mockWaitingRoomService.maxPlayerLimitReached).toHaveBeenCalled();
            expect(mockSocket.emit).not.toHaveBeenCalledWith(WaitingRoomEvents.ToggleLockWaitingRoom, 'room123');
        });

        it('should listen to playerLeft and call removePlayer', () => {
            const playerId = { playerId: '0000' };

            triggerSocketEvent(WaitingRoomEvents.PlayerLeft, playerId);

            expect(mockWaitingRoomService.removePlayer).toHaveBeenCalledWith(playerId);
        });

        it('should listen to roomCanceled and update roomExists', () => {
            triggerSocketEvent(WaitingRoomEvents.RoomCanceled);

            expect(service['roomExistsSubject'].getValue()).toBeFalse();
        });

        it('should listen to playerKicked and update isKicked', () => {
            triggerSocketEvent(WaitingRoomEvents.PlayerKicked);

            expect(service['isKickedSubject'].getValue()).toBeTrue();
        });

        it('should listen to waitingRoomLocked, update roomLocked and call toggleLock', () => {
            triggerSocketEvent(WaitingRoomEvents.WaitingRoomLocked);

            expect(service['roomLockedSubject'].getValue()).toBeTrue();
            expect(mockWaitingRoomService.toggleLock).toHaveBeenCalledWith(true);
        });

        it('should listen to waitingRoomUnlocked, update roomLocked and call toggleLock', () => {
            service['roomLockedSubject'].next(true);

            triggerSocketEvent(WaitingRoomEvents.WaitingRoomUnlocked);

            expect(service['roomLockedSubject'].getValue()).toBeFalse();
            expect(mockWaitingRoomService.toggleLock).toHaveBeenCalledWith(false);
        });

        it('should listen to leavingWaitingRoom and handle room exit', () => {
            service['roomExistsSubject'].next(false);

            triggerSocketEvent(WaitingRoomEvents.LeaveWaitingRoom);

            expect(service['roomExistsSubject'].getValue()).toBeTrue();
            expect(mockSocketService.navigateToHome).toHaveBeenCalled();
        });

        it('should listen to gameRoomCreated and handle game room initialization', () => {
            const mockGameRoom = {
                roomId: 'testGameRoomId',
                gameId: 'testGameId',
                hostId: 'testSocketId',
                players: [],
                isLocked: false,
                isDebugging: false,
            };

            triggerSocketEvent(GameRoomEvents.GameRoomCreated, mockGameRoom);

            expect(mockWaitingRoomService.resetRoom).toHaveBeenCalled();
            expect(mockGameManagerService.resetManager).toHaveBeenCalled();
            expect(mockGameRoomService.updateRoom).toHaveBeenCalledWith(mockGameRoom);
            // The setMainPlayer call is commented out in the actual implementation
            // expect(mockGameManagerService.setMainPlayer).toHaveBeenCalledWith(mockSocket.id);
            expect(mockSocket.emit).toHaveBeenCalledWith(GameRoomEvents.PlayGame, mockGameRoom.roomId);
            expect(mockGameManagerService.redirect).toHaveBeenCalled();
        });

        it('should listen to gameRoomCreated without emitting PlayGame for non-organizer', () => {
            const mockGameRoom = {
                roomId: 'testGameRoomId',
                gameId: 'testGameId',
                hostId: 'differentId',
                players: [],
                isLocked: false,
                isDebugging: false,
            };

            triggerSocketEvent(GameRoomEvents.GameRoomCreated, mockGameRoom);

            expect(mockWaitingRoomService.resetRoom).toHaveBeenCalled();
            expect(mockGameManagerService.resetManager).toHaveBeenCalled();
            expect(mockGameRoomService.updateRoom).toHaveBeenCalledWith(mockGameRoom);
            // The setMainPlayer call is commented out in the actual implementation
            // expect(mockGameManagerService.setMainPlayer).toHaveBeenCalledWith(mockSocket.id);
            expect(mockSocket.emit).not.toHaveBeenCalledWith(GameRoomEvents.PlayGame, mockGameRoom.roomId);
            expect(mockGameManagerService.redirect).toHaveBeenCalled();
        });

        it('should listen to updateAvatarReserved and update reservedAvatars', () => {
            const mockReservedAvatars = [
                { reservorId: 'player1', chosenAvatar: 'avatar1' },
                { reservorId: 'player2', chosenAvatar: 'avatar2' },
            ];

            triggerSocketEvent(WaitingRoomEvents.UpdateAvatarReserved, { reservedAvatars: mockReservedAvatars });

            expect(service['reservedAvatarsSubject'].getValue()).toEqual(mockReservedAvatars);
        });
    });
});

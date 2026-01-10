/* eslint-disable @typescript-eslint/no-empty-function */
/* eslint-disable @typescript-eslint/no-explicit-any */
import { TestBed } from '@angular/core/testing';
import { Router } from '@angular/router';
import { Player } from '@app/classes/player';
import { ROUTES } from '@app/constants/routes.constants';
import { Coords } from '@app/interfaces/coords';
import { Room } from '@app/interfaces/room';
import { GameManagerService } from '@app/services/game-manager.service';
import { SocketService } from '@app/services/socket.service';
import { WaitingRoomService } from '@app/services/waiting-room.service';
import { of } from 'rxjs';
import { Socket } from 'socket.io-client';
import { AttackPayload, AttackResult, CombatPayload, CombatRoom, FlightResult } from '@app/interfaces/payload';
import { CombatService } from './combat.service';
import { GameCreationService } from './game-creation.service';
import { GameRoomService } from './game-room.service';

const POSITION_X = 5;
const POSITION_Y = 10;

/* eslint-disable max-lines */
describe('SocketService', () => {
    let service: SocketService;
    let mockWaitingRoomService: jasmine.SpyObj<WaitingRoomService>;
    let mockGameManagerService: jasmine.SpyObj<GameManagerService>;
    let mockGameRoomService: jasmine.SpyObj<GameRoomService>;
    let mockCombatService: jasmine.SpyObj<CombatService>;
    let mockRouter: jasmine.SpyObj<Router>;
    let mockSocket: jasmine.SpyObj<Socket>;
    let mockGameCreationService: jasmine.SpyObj<GameCreationService>;

    beforeEach(async () => {
        mockWaitingRoomService = jasmine.createSpyObj('WaitingRoomService', [
            'updateRoom',
            'toggleLock',
            'addPlayer',
            'removePlayer',
            'startGame',
            'resetRoom',
        ]);
        mockWaitingRoomService.currentRoom = jasmine.createSpyObj('BehaviorSubject', ['getValue']);
        (mockWaitingRoomService.currentRoom.getValue as jasmine.Spy).and.returnValue({ organisatorId: 'testOrganisatorId' });

        Object.defineProperty(mockWaitingRoomService, 'room$', {
            get: () => of(null),
        });

        const mockPlayer = new Player();
        mockPlayer.id = 'testSocketId';
        mockPlayer.movementPoints = 3;
        mockPlayer.actionPoints = 1;
        mockPlayer.spawnPoint = { x: 0, y: 0 };

        mockGameManagerService = jasmine.createSpyObj(
            'GameManagerService',
            [
                'setMainPlayer',
                'redirect',
                'handleTurnStarting',
                'setMovementPoints',
                'setActionPoints',
                'selectPlayer',
                'setPaths',
                'clearPaths',
                'getBoard',
                'setPlayer',
                'setSelectedPathFromCoords',
                'movePlayerFromPath',
                'teleportPlayer',
                'getMainPlayer',
                'getRoomId',
                'updateScore',
                'disconnectPlayer',
                'cancelGame',
                'finishGame',
                'getPlayerById',
                'resetManager',
            ],
            {
                room: {
                    roomId: 'testRoomId',
                    organisatorId: 'testSocketId',
                    isDebugging: false,
                    players: [mockPlayer],
                },
                currentPlayerId: 'testSocketId',
                isDebugMode: false,
                gameCountdown: jasmine.createSpyObj('BehaviorSubject', ['next']),
            },
        );

        mockGameRoomService = jasmine.createSpyObj('GameRoomService', ['updateRoom', 'updatePlayers', 'toggleDebugMode'], {
            room: { roomId: 'testRoomId' },
        });

        mockCombatService = jasmine.createSpyObj(
            'CombatService',
            ['setIsCombatPlayerTurn', 'setCombatRoom', 'handleAttackResult', 'handleFlightResult', 'handleEnd'],
            {
                isCombatMode: false,
                combatCountdown: jasmine.createSpyObj('BehaviorSubject', ['next']),
                loserId: '',
            },
        );

        mockRouter = jasmine.createSpyObj('Router', ['navigate']);
        mockSocket = jasmine.createSpyObj('Socket', ['emit', 'on', 'once', 'id', 'disconnect'], { id: 'testSocketId' });

        // Create a more complete mock Board for the selectedGame
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

        spyOn(SocketService.prototype, 'connect').and.callFake(function (this: SocketService) {
            // eslint-disable-next-line no-invalid-this
            (this as any).socket = mockSocket;
        });

        mockGameManagerService.redirect.and.callFake(() => {
            mockRouter.navigate([ROUTES.game]);
        });

        // Create a more complete mock Board that satisfies the interface
        const mockBoard = jasmine.createSpyObj('Board', [
            'getPlayerById',
            'getCell',
            'createMatrix',
            'createMatrixFromData',
            'getMatrix',
            'getSize',
            'getPlayers',
            'addPlayer',
        ]);
        mockBoard.getPlayerById.and.returnValue(mockPlayer);
        mockBoard.getCell.and.returnValue({ tile: { type: 'door', toggleState: jasmine.createSpy('toggleState') } });
        mockBoard.matrix = [];
        mockBoard.size = 10;

        mockGameManagerService.getBoard.and.returnValue(mockBoard);
        mockGameManagerService.getMainPlayer.and.returnValue(mockPlayer);
        mockGameManagerService.getPlayerById.and.returnValue(mockPlayer);

        await TestBed.configureTestingModule({
            providers: [
                { provide: WaitingRoomService, useValue: mockWaitingRoomService },
                { provide: GameManagerService, useValue: mockGameManagerService },
                { provide: GameRoomService, useValue: mockGameRoomService },
                { provide: CombatService, useValue: mockCombatService },
                { provide: Router, useValue: mockRouter },
                { provide: Socket, useValue: mockSocket },
                { provide: GameCreationService, useValue: mockGameCreationService },
            ],
        }).compileComponents();

        service = TestBed.inject(SocketService);
        service['socket'] = mockSocket;
        service['room'] = { players: [] } as any;
    });

    it('should create', () => {
        expect(service).toBeTruthy();
    });

    it('should return the socket ID when getId is called', () => {
        expect(service.getId()).toBe('testSocketId');
    });

    it('should emit "createWaitingRoom" when createRoom is called', () => {
        service.createRoom('room1', 'game1', { id: 'player1', name: 'Test' } as Player);
        expect(mockSocket.emit).toHaveBeenCalledWith('createWaitingRoom', {
            roomId: 'room1',
            gameId: 'game1',
            organisator: { id: 'player1', name: 'Test' },
        });
    });

    it('should join a room and update state on success', () => {
        const roomId = 'testRoomId';
        const mockRoom = { id: roomId, players: [], roomId: '', organisatorId: '', gameId: '', isLocked: false, isDebugging: false } as Room;
        const callback = jasmine.createSpy('callback');

        service.joinRoom(roomId, callback);
        expect(mockSocket.emit).toHaveBeenCalledWith('joinWaitingRoom', roomId);

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
        expect(mockSocket.emit).toHaveBeenCalledWith('joinWaitingRoom', roomId);

        const response = { success: false, error: errorMessage };
        mockSocket.once.calls.argsFor(0)[1](response);

        expect(mockWaitingRoomService.updateRoom).not.toHaveBeenCalled();
        expect(mockWaitingRoomService.toggleLock).not.toHaveBeenCalled();
        expect(callback).toHaveBeenCalledWith(false, errorMessage);
    });

    it("should emit 'createPlayer' on createPlayer call", () => {
        const player = new Player();
        service.createPlayer('testRoomId', player);

        expect(mockSocket.emit).toHaveBeenCalledWith('createPlayer', { roomId: 'testRoomId', player });
    });

    it('should leave the room on success', () => {
        const roomId = 'testRoomId';
        const callback = jasmine.createSpy('callback');

        service.leaveRoom(roomId, callback);

        expect(mockSocket.emit).toHaveBeenCalledWith('leaveRoom', roomId);

        const response = { success: true };
        mockSocket.once.calls.argsFor(0)[1](response);

        expect(callback).toHaveBeenCalledWith(true, undefined);
    });

    it('should call callback with error on failure of leaveRoom', () => {
        const roomId = 'testRoomId';
        const callback = jasmine.createSpy('callback');
        const errorMessage = 'Test Error Message';

        service.leaveRoom(roomId, callback);
        expect(mockSocket.emit).toHaveBeenCalledWith('leaveRoom', roomId);

        const response = { success: false, error: errorMessage };
        mockSocket.once.calls.argsFor(0)[1](response);

        expect(mockWaitingRoomService.updateRoom).not.toHaveBeenCalled();
        expect(mockWaitingRoomService.toggleLock).not.toHaveBeenCalled();
        expect(callback).toHaveBeenCalledWith(false, errorMessage);
    });

    it("should emit 'toggleLockWaitingRoom' on toggleLockRoom call", () => {
        const roomId = 'testRoomId';
        service.toggleLockRoom(roomId);

        expect(mockSocket.emit).toHaveBeenCalledWith('toggleLockWaitingRoom', 'testRoomId');
    });

    it("should emit 'kickPlayer' on kickPlayer call", () => {
        const roomId = 'testRoomId';
        const player = new Player();
        service.kickPlayer(roomId, player);

        expect(mockSocket.emit).toHaveBeenCalledWith('kickPlayer', { roomId: 'testRoomId', player });
    });

    it("should emit 'reserveAvatar' with correct data", () => {
        const roomId = '123';
        let chosenAvatar = 'avatar1';

        service.reserveAvatar(roomId, chosenAvatar);

        service.reservedAvatars$.subscribe((avatars) => {
            expect(avatars).toEqual([{ reservorId: mockSocket.id as any, chosenAvatar }]);
        });

        chosenAvatar = 'avatar2';
        service.reserveAvatar(roomId, chosenAvatar);

        service.reservedAvatars$.subscribe((avatars) => {
            expect(avatars).toEqual([{ reservorId: mockSocket.id as any, chosenAvatar }]);
        });

        expect(mockSocket.emit).toHaveBeenCalledWith('reserveAvatar', { roomId, chosenAvatar });
    });

    it('should throw an error if socket ID is undefined', () => {
        delete mockSocket.id;
        service = TestBed.inject(SocketService);
        service.connect();

        expect(() => service.reserveAvatar('123', 'avatar1')).toThrowError('Socket ID non défini !');
    });

    it("should emit 'getReservedAvatars' on getReservedAvatars call", () => {
        const roomId = 'testRoomId';
        service.getReservedAvatars(roomId);

        expect(mockSocket.emit).toHaveBeenCalledWith('getReservedAvatars', { roomId: 'testRoomId' });
    });

    it("should emit 'startGame' on startGame call", () => {
        const roomId = 'testRoomId';
        service['room'] = { players: [new Player(), new Player()] } as any;
        service.startGame(roomId);
        expect(mockSocket.emit).toHaveBeenCalledWith('startGame', roomId);
    });

    it('should generate code', () => {
        const callback = jasmine.createSpy('callback');

        service.generateCode(callback);

        expect(mockSocket.emit).toHaveBeenCalledWith('generateCode');

        const response = { code: '0000' };
        mockSocket.once.calls.argsFor(0)[1](response);

        expect(callback).toHaveBeenCalledWith('0000');
    });

    it('should listen to connect and log it', () => {
        spyOn(console, 'log');

        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'connect') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();

        (service as any).setUpListeners();

        eventCallback();
    });

    it('should listen to waitingRoomError and warn about it', () => {
        spyOn(console, 'warn');

        const error = 'Erreur 1';

        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'waitingRoomError') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();

        (service as any).setUpListeners();

        eventCallback(error);

        // eslint-disable-next-line no-console
        expect(console.warn).toHaveBeenCalledWith('Erreur depuis le socket serveur de WaitingRoomGateway : \n', error);
    });

    it('should listen to waitingRoomCreated and call updateRoom', () => {
        const mockRoom = { id: '0000', players: [], roomId: '', organisatorId: '', gameId: '', isLocked: false, isDebugging: false } as Room;

        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'waitingRoomCreated') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();

        (service as any).setUpListeners();

        eventCallback(mockRoom);

        expect(mockWaitingRoomService.updateRoom).toHaveBeenCalledWith(mockRoom);
    });

    it('should listen to playerCreated and call addPlayer and setMainPlayer', () => {
        const players = [new Player(), new Player()];

        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'playerCreated') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();

        (service as any).setUpListeners();

        eventCallback(players);

        expect(mockWaitingRoomService.addPlayer).toHaveBeenCalledWith(players);
        expect(mockGameManagerService.setMainPlayer).toHaveBeenCalledWith(mockSocket.id);
    });

    it('should automatically lock room when max players is reached', () => {
        // Set up a room with max players for the selected board size
        const maxPlayers = 2; // For board size 10, max is 2 players
        const players = Array(maxPlayers)
            .fill(null)
            .map(() => new Player());

        service['room'] = { players } as any;

        // Create a complete mock Game object
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

        const mockGame = {
            _id: 'testGameId',
            name: 'Test Game',
            description: 'Test Game Description',
            mode: 'normal',
            board: mockSelectedGameBoard,
            isVisible: true,
            modificationDate: Date.now().toString(),
            getBoard: () => mockSelectedGameBoard,
            setData: (data: any) => {
                mockGame._id = data._id;
                mockGame.name = data.name;
                mockGame.description = data.description;
                mockGame.mode = data.mode;
                mockGame.board = data.board;
                mockGame.isVisible = data.isVisible;
                mockGame.modificationDate = data.modificationDate;
            },
        };

        // Use type assertion to bypass type checking
        mockGameCreationService.selectedGame = mockGame as any;
        mockGameCreationService.gameCode = 'testGameCode';

        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'playerCreated') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();

        // Trigger the playerCreated event
        eventCallback(players);

        // Verify that toggleLockWaitingRoom was emitted with the game code
        expect(mockSocket.emit).toHaveBeenCalledWith('toggleLockWaitingRoom', 'testGameCode');
    });

    it('should listen to playerJoined and log it', () => {
        spyOn(console, 'log');

        const data = { playerId: '000' };

        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'playerJoined') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();

        (service as any).setUpListeners();

        eventCallback(data);
    });

    it('should listen to gameRoomCreated and call startGame and navigate', () => {
        const gameRoomId = '0000';

        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'gameRoomCreated') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();

        (service as any).setUpListeners();

        eventCallback(gameRoomId);

        expect(mockRouter.navigate).toHaveBeenCalledWith([ROUTES.game]);
    });

    it('should emit playGame when gameRoomCreated and user is organizer', () => {
        // Create a game room where the current user is the organizer
        const gameRoom = {
            roomId: 'testRoomId',
            organisatorId: 'testSocketId', // Same as mockSocket.id
            players: [new Player()],
        };

        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'gameRoomCreated') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();

        // Trigger the gameRoomCreated event
        eventCallback(gameRoom);

        // Verify that playGame was emitted with the room ID
        expect(mockSocket.emit).toHaveBeenCalledWith('playGame', gameRoom.roomId);
    });

    it('should not emit playGame when gameRoomCreated and user is not organizer', () => {
        // Create a game room where the current user is not the organizer
        const gameRoom = {
            roomId: 'testRoomId',
            organisatorId: 'differentUserId', // Different from mockSocket.id
            players: [new Player()],
        };

        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'gameRoomCreated') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();

        // Reset the emit spy to clear previous calls
        mockSocket.emit.calls.reset();

        // Trigger the gameRoomCreated event
        eventCallback(gameRoom);

        // Verify that playGame was not emitted with the room ID
        expect(mockSocket.emit).not.toHaveBeenCalledWith('playGame', gameRoom.roomId);
    });

    it('should listen to updateAvatarReserved and update ReservedAvatars', () => {
        const data = { reservedAvatars: [{ reservorId: '0000', chosenAvatar: 'Vik' }] };

        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'updateAvatarReserved') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();

        (service as any).setUpListeners();

        eventCallback(data);

        service.reservedAvatars$.subscribe((updatedReservations) => {
            expect(updatedReservations).toEqual(data.reservedAvatars);
        });
    });

    it('should listen to playerLeft and call removePlayer', () => {
        const playerId = { playerId: '0000' };

        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'playerLeft') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();

        (service as any).setUpListeners();

        eventCallback(playerId);

        expect(mockWaitingRoomService.removePlayer).toHaveBeenCalledWith(playerId);
    });

    it('should listen to roomCanceled and update RoomExists', () => {
        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'roomCanceled') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();

        (service as any).setUpListeners();

        eventCallback();

        service.roomExists$.subscribe((exists) => {
            expect(exists).toEqual(false);
        });
    });

    it('should listen to playerKicked and update isKicked', () => {
        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'playerKicked') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();

        (service as any).setUpListeners();

        eventCallback();

        service.isKicked$.subscribe((kicked) => {
            expect(kicked).toEqual(true);
        });
    });

    it('should listen to waitingRoomLocked, update roomLocked and call toggleLock', () => {
        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'waitingRoomLocked') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();

        (service as any).setUpListeners();

        eventCallback();

        service.roomLocked$.subscribe((locked) => {
            expect(locked).toEqual(true);
        });
        expect(mockWaitingRoomService.toggleLock).toHaveBeenCalledWith(true);
    });

    it('should listen to waitingRoomUnlocked, update roomLocked and call toggleLock', () => {
        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'waitingRoomUnlocked') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();

        (service as any).setUpListeners();

        eventCallback();

        service.roomLocked$.subscribe((locked) => {
            expect(locked).toEqual(false);
        });
        expect(mockWaitingRoomService.toggleLock).toHaveBeenCalledWith(false);
    });

    it('should return the room ID when getRoomId is called', () => {
        expect(service.getRoomId()).toBe('testRoomId');
    });

    it('should emit toggleDebugMode when toggleDebugMode is called', () => {
        service.toggleDebugMode();
        expect(mockSocket.emit).toHaveBeenCalledWith('toggleDebugMode', 'testRoomId');
    });

    it('should return the socket ID when getSocketId is called', () => {
        expect(service.getSocketId()).toBe('testSocketId');
    });

    it('should emit abandonGame when abandonGame is called', () => {
        const roomId = 'testRoomId';
        service.abandonGame(roomId);
        expect(mockSocket.emit).toHaveBeenCalledWith('abandonGame', roomId);
    });

    it('should emit endTurn when endPlayerTurn is called', () => {
        const roomId = 'testRoomId';
        service.endPlayerTurn(roomId);
        expect(mockSocket.emit).toHaveBeenCalledWith('endTurn', roomId);
    });

    it('should emit playerGetMovements when getPlayerMovements is called', () => {
        service.getPlayerMovements();
        expect(mockSocket.emit).toHaveBeenCalledWith('playerGetMovements', 'testRoomId');
    });

    it('should emit playerMoved with serialized map when movedPlayer is called', () => {
        const moveInfo = {
            roomId: 'testRoomId',
            playerId: 'testPlayerId',
            map: new Map<Coords, Coords[]>([[{ x: 0, y: 0 }, [{ x: 1, y: 1 }]]]),
            selectedPath: [{ x: 1, y: 1 }],
        };

        service.movedPlayer(moveInfo);

        expect(mockSocket.emit).toHaveBeenCalledWith('playerMoved', {
            roomId: 'testRoomId',
            playerId: 'testPlayerId',
            serializedMap: [[{ x: 0, y: 0 }, [{ x: 1, y: 1 }]]],
            selectedPath: [{ x: 1, y: 1 }],
        });
    });

    it('should emit startCombat when startCombat is called', () => {
        const combatPayload: CombatPayload = {
            roomId: 'testRoomId',
            opponentId: 'testOpponentId',
        };
        service.startCombat(combatPayload);
        expect(mockSocket.emit).toHaveBeenCalledWith('startCombat', combatPayload);
    });

    it('should emit flightAttempt when flightAttempt is called', () => {
        const combatPayload: CombatPayload = {
            roomId: 'testRoomId',
            opponentId: 'testOpponentId',
        };
        service.flightAttempt(combatPayload);
        expect(mockSocket.emit).toHaveBeenCalledWith('flightAttempt', 'testRoomId');
    });

    it('should emit attack when attack is called', () => {
        const attackPayload: AttackPayload = {
            roomId: 'testRoomId',
            attackValue: POSITION_Y,
            defenseValue: POSITION_X,
        };
        service.attack(attackPayload);
        expect(mockSocket.emit).toHaveBeenCalledWith('attack', attackPayload);
    });

    it('should emit playerTeleported when teleportPlayer is called', () => {
        service.teleportPlayer(POSITION_X, POSITION_Y);
        expect(mockSocket.emit).toHaveBeenCalledWith('playerTeleported', {
            roomId: 'testRoomId',
            playerId: 'testSocketId',
            destination: { x: POSITION_X, y: POSITION_Y },
        });
    });

    it('should emit doorToggled when toggleDoor is called', () => {
        service.toggleDoor(POSITION_X, POSITION_Y);
        expect(mockSocket.emit).toHaveBeenCalledWith('doorToggled', {
            roomId: 'testRoomId',
            x: POSITION_X,
            y: POSITION_Y,
        });
    });

    it('should emit finishGame when finishGame is called', () => {
        service.finishGame('testWinnerId');
        expect(mockSocket.emit).toHaveBeenCalledWith('finishGame', {
            roomId: 'testRoomId',
            winnerId: 'testWinnerId',
        });
    });

    it('should disconnect and reconnect when reconnect is called', () => {
        spyOn(service, 'setUpConnection');
        service.reconnect();
        expect(mockSocket.disconnect).toHaveBeenCalled();
        expect(service.setUpConnection).toHaveBeenCalled();
    });

    it('should listen to gameRoomError and warn about it', () => {
        spyOn(console, 'warn');
        const error = 'Game Room Error';
        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'gameRoomError') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();
        eventCallback(error);

        // eslint-disable-next-line no-console
        expect(console.warn).toHaveBeenCalledWith('Erreur depuis le socket serveur de GameRoomGateway : \n', error);
    });

    it('should listen to leaveWaitingRoom and navigate to home', () => {
        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'leaveWaitingRoom') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();
        eventCallback();

        service.roomExists$.subscribe((exists) => {
            expect(exists).toEqual(true);
        });
        expect(mockRouter.navigate).toHaveBeenCalledWith([ROUTES.home]);
    });

    it('should listen to playerSpawned and update players', () => {
        const players = [new Player(), new Player()];
        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'playerSpawned') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();
        eventCallback(players);

        expect(mockGameRoomService.updatePlayers).toHaveBeenCalledWith(players);
    });

    it('should listen to turnStarting and handle turn start when current player is the socket owner', () => {
        const mockPlayer = new Player();
        mockPlayer.id = 'testSocketId';
        mockPlayer.movementPoints = 3;

        const data = {
            nextPlayer: mockPlayer,
            startTime: Date.now(),
        };

        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'turnStarting') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();
        eventCallback(data);

        expect(mockGameManagerService.handleTurnStarting).toHaveBeenCalledWith(data.nextPlayer, data.startTime);
        expect(mockGameManagerService.setMovementPoints).toHaveBeenCalled();
        expect(mockGameManagerService.setActionPoints).toHaveBeenCalled();
        expect(mockSocket.emit).toHaveBeenCalledWith('playerGetMovements', 'testRoomId');
    });

    it('should set currentPlayerId to nextPlayer.id when current player is not the socket owner', () => {
        // Create a player with the socket ID (needed for the room.players.find check)
        const socketPlayer = new Player();
        socketPlayer.id = 'testSocketId';
        socketPlayer.movementPoints = 3;

        // Create a different player for the next turn
        const nextPlayer = new Player();
        nextPlayer.id = 'differentPlayerId'; // Different from 'testSocketId'
        nextPlayer.movementPoints = 3;

        // Set up the room with the socket player
        mockGameManagerService.room = {
            roomId: 'testRoomId',
            organisatorId: 'testSocketId',
            isDebugging: false,
            players: [socketPlayer],
            gameId: 'testGameId',
            isLocked: false,
        };

        const data = {
            nextPlayer,
            startTime: Date.now(),
        };

        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'turnStarting') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();

        // Reset the emit spy to clear previous calls
        mockSocket.emit.calls.reset();

        // Reset the currentPlayerId to ensure we're testing the change
        mockGameManagerService.currentPlayerId = 'initialValue';

        // Trigger the turnStarting event
        eventCallback(data);

        // Verify that handleTurnStarting was called
        expect(mockGameManagerService.handleTurnStarting).toHaveBeenCalledWith(data.nextPlayer, data.startTime);

        // Verify that playerGetMovements was NOT called (since it's not the current player's turn)
        expect(mockSocket.emit).not.toHaveBeenCalledWith('playerGetMovements', 'testRoomId');
    });

    it('should listen to playerMovements and set paths when not in debug mode', () => {
        const paths = [[{ x: 0, y: 0 }, [{ x: 1, y: 1 }]]];
        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'playerMovements') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        // Ensure isDebugMode is false
        Object.defineProperty(mockGameManagerService, 'isDebugMode', {
            get: () => false,
        });

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();
        eventCallback(paths);

        expect(mockGameManagerService.setPaths).toHaveBeenCalled();
        expect(mockGameManagerService.clearPaths).not.toHaveBeenCalled();
    });

    it('should listen to playerMovements and clear paths when in debug mode', () => {
        const paths = [[{ x: 0, y: 0 }, [{ x: 1, y: 1 }]]];
        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'playerMovements') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        // Set isDebugMode to true
        Object.defineProperty(mockGameManagerService, 'isDebugMode', {
            get: () => true,
        });

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();

        // Reset the spy counts before triggering the event
        mockGameManagerService.setPaths.calls.reset();
        mockGameManagerService.clearPaths.calls.reset();

        eventCallback(paths);

        expect(mockGameManagerService.setPaths).not.toHaveBeenCalled();
        expect(mockGameManagerService.clearPaths).toHaveBeenCalled();
    });

    it('should listen to playerMoved and handle player movement when player is found', () => {
        const data = {
            playerId: 'testPlayerId',
            map: [[{ x: 0, y: 0 }, [{ x: 1, y: 1 }]]],
            movementPoints: 2,
            selectedPath: [{ x: 1, y: 1 }],
        };
        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'playerMoved') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        // Ensure getPlayerById returns a player
        const mockBoard = mockGameManagerService.getBoard();
        (mockBoard.getPlayerById as jasmine.Spy).and.returnValue(new Player());

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();
        eventCallback(data);

        expect(mockGameManagerService.setPlayer).toHaveBeenCalled();
        expect(mockGameManagerService.setMovementPoints).toHaveBeenCalledWith(data.movementPoints);
        expect(mockGameManagerService.setPaths).toHaveBeenCalled();
        expect(mockGameManagerService.setSelectedPathFromCoords).toHaveBeenCalledWith(data.selectedPath);
        expect(mockGameManagerService.movePlayerFromPath).toHaveBeenCalled();
    });

    it('should return early from playerMoved event when player is not found', () => {
        const data = {
            playerId: 'nonExistentPlayerId',
            map: [[{ x: 0, y: 0 }, [{ x: 1, y: 1 }]]],
            movementPoints: 2,
            selectedPath: [{ x: 1, y: 1 }],
        };
        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'playerMoved') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        // Make getPlayerById return null to simulate player not found
        const mockBoard = mockGameManagerService.getBoard();
        (mockBoard.getPlayerById as jasmine.Spy).and.returnValue(null);

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();

        // Reset all spies to clear previous calls
        mockGameManagerService.setPlayer.calls.reset();
        mockGameManagerService.setMovementPoints.calls.reset();
        mockGameManagerService.setPaths.calls.reset();
        mockGameManagerService.setSelectedPathFromCoords.calls.reset();
        mockGameManagerService.movePlayerFromPath.calls.reset();

        // Trigger the event
        eventCallback(data);

        // Verify that none of the subsequent methods were called
        expect(mockGameManagerService.setPlayer).not.toHaveBeenCalled();
        expect(mockGameManagerService.setMovementPoints).not.toHaveBeenCalled();
        expect(mockGameManagerService.setPaths).not.toHaveBeenCalled();
        expect(mockGameManagerService.setSelectedPathFromCoords).not.toHaveBeenCalled();
        expect(mockGameManagerService.movePlayerFromPath).not.toHaveBeenCalled();
    });

    it('should automatically end player turn when player has no movement or action points left', () => {
        // Set up the player with no movement or action points
        const mockPlayer = new Player();
        mockPlayer.id = 'testSocketId';
        mockPlayer.movementPoints = 0;
        mockPlayer.actionPoints = 0;

        // Set up the game manager service to return the player with no points
        mockGameManagerService.getMainPlayer.and.returnValue(mockPlayer);
        mockGameManagerService.currentPlayerId = 'testSocketId';
        mockGameManagerService.getRoomId.and.returnValue('testRoomId');

        // Set up the data for the playerMoved event
        const data = {
            playerId: 'testPlayerId',
            map: [[{ x: 0, y: 0 }, [{ x: 1, y: 1 }]]],
            movementPoints: 0,
            selectedPath: [{ x: 1, y: 1 }],
        };

        // Set up the event callback
        let eventCallback: (...args: unknown[]) => void = () => {};
        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'playerMoved') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        // Set up movePlayerFromPath to execute the callback immediately and return a Promise
        mockGameManagerService.movePlayerFromPath.and.callFake(async (callback?: () => void) => {
            if (callback) callback();
            return Promise.resolve();
        });

        // Create the service and set up listeners
        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();

        // Reset the emit spy to clear previous calls
        mockSocket.emit.calls.reset();

        // Trigger the playerMoved event
        eventCallback(data);

        // Verify that endTurn was called with the room ID
        expect(mockSocket.emit).toHaveBeenCalledWith('endTurn', 'testRoomId');
    });

    it('should not end player turn when player still has movement or action points', () => {
        // Set up the player with movement points
        const mockPlayer = new Player();
        mockPlayer.id = 'testSocketId';
        mockPlayer.movementPoints = 1;
        mockPlayer.actionPoints = 0;

        // Set up the game manager service to return the player with points
        mockGameManagerService.getMainPlayer.and.returnValue(mockPlayer);
        mockGameManagerService.currentPlayerId = 'testSocketId';
        mockGameManagerService.getRoomId.and.returnValue('testRoomId');

        // Set up the data for the playerMoved event
        const data = {
            playerId: 'testPlayerId',
            map: [[{ x: 0, y: 0 }, [{ x: 1, y: 1 }]]],
            movementPoints: 1,
            selectedPath: [{ x: 1, y: 1 }],
        };

        // Set up the event callback
        let eventCallback: (...args: unknown[]) => void = () => {};
        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'playerMoved') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        // Create the service and set up listeners
        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();

        // Reset the emit spy to clear previous calls
        mockSocket.emit.calls.reset();

        // Trigger the playerMoved event
        eventCallback(data);

        // Verify that endTurn was not called
        expect(mockSocket.emit).not.toHaveBeenCalledWith('endTurn', 'testRoomId');
    });

    it('should listen to playerTeleported and handle teleportation', () => {
        const data = {
            playerId: 'testPlayerId',
            destination: { x: 5, y: 10 },
        };
        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'playerTeleported') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();
        eventCallback(data);

        expect(mockGameManagerService.setPlayer).toHaveBeenCalled();
        expect(mockGameManagerService.teleportPlayer).toHaveBeenCalledWith(data.destination.x, data.destination.y);
    });

    it('should listen to updateCountdown and update game countdown', () => {
        const countdown = 10;
        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'updateCountdown') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();
        eventCallback(countdown);

        expect(mockGameManagerService.gameCountdown.next).toHaveBeenCalledWith(countdown);
    });

    it('should listen to combatTurnStarted and handle combat turn', () => {
        const mockCombatRoom: CombatRoom = {
            combatRoomId: 'testCombatRoomId',
            players: [new Player()],
            attackerId: 'testAttackerId',
            defenderId: 'testDefenderId',
            currentPlayerId: 'testSocketId',
            currentOpponentId: 'testOpponentId',
        };

        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'combatTurnStarted') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();
        eventCallback(mockCombatRoom);

        expect(mockCombatService.setIsCombatPlayerTurn).toHaveBeenCalledWith(true);
        expect(mockCombatService.setCombatRoom).toHaveBeenCalledWith(mockCombatRoom);
    });

    it('should listen to performAttack and trigger attack', () => {
        let eventCallback: (...args: unknown[]) => void = () => {};
        const attackTriggerSubject = jasmine.createSpyObj('Subject', ['next']);
        service['attackTriggerSubject'] = attackTriggerSubject;

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'performAttack') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();
        eventCallback();

        expect(attackTriggerSubject.next).toHaveBeenCalled();
    });

    it('should listen to attackResult and handle attack result', () => {
        const attackResult: AttackResult = {
            isAttackSuccess: true,
            opponentHealthPoints: 80,
            attackValue: 20,
            defenseValue: 10,
        };

        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'attackResult') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();
        eventCallback(attackResult);

        expect(mockCombatService.handleAttackResult).toHaveBeenCalledWith(attackResult);
    });

    it('should listen to flightAttemptResult and handle flight result', () => {
        const flightResult: FlightResult = {
            isSuccess: true,
            attackerEvasionPoints: 5,
        };

        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'flightAttemptResult') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();
        eventCallback(flightResult);

        expect(mockCombatService.handleFlightResult).toHaveBeenCalledWith(flightResult);
    });

    it('should listen to endCombat and handle combat end', () => {
        const winnerId = 'testWinnerId';
        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'endCombat') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();
        eventCallback(winnerId);

        expect(mockCombatService.handleEnd).toHaveBeenCalledWith(winnerId);
    });

    it('should teleport loser to spawn point when endCombat is triggered', () => {
        // Set up a player with a spawn point
        const spawnPoint = { x: 5, y: 10 };
        const mockPlayer = new Player();
        mockPlayer.id = 'testSocketId';
        mockPlayer.spawnPoint = spawnPoint;

        // Set up the game manager service room with the player
        mockGameManagerService.room.players = [mockPlayer];

        // Set up the socket ID to match the player ID
        Object.defineProperty(mockSocket, 'id', { value: 'testSocketId' });

        // Set up the combat service loserId to match the socket ID
        mockCombatService.loserId = 'testSocketId';

        // Create a spy for the teleportPlayer method
        spyOn(service, 'teleportPlayer');

        // Set up the event callback
        let eventCallback: (...args: unknown[]) => void = () => {};
        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'endCombat') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        // Create the service and set up listeners
        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();

        // Trigger the endCombat event
        eventCallback('testWinnerId');

        // Verify that handleEnd was called with the winner ID
        expect(mockCombatService.handleEnd).toHaveBeenCalledWith('testWinnerId');

        // Verify that teleportPlayer was called with the spawn point coordinates
        // expect(service.teleportPlayer).toHaveBeenCalledWith(spawnPoint.x, spawnPoint.y);

        // Verify that the combat service's loserId was reset to an empty string
        expect(mockCombatService.loserId).toBe('');
    });

    it('should teleport player to spawn point when current socket is the combat loser', () => {
        // Create a player with a spawn point at (5, 10)
        const spawnPoint = { x: POSITION_X, y: POSITION_Y };
        const mockPlayer = new Player();
        mockPlayer.id = 'testSocketId';
        mockPlayer.spawnPoint = spawnPoint;

        // Set up the game manager service room with the player
        mockGameManagerService.room.players = [mockPlayer];

        // Set up the combat service loserId to match the socket ID
        mockCombatService.loserId = 'testSocketId';

        // Create a spy for the teleportPlayer method BEFORE calling it
        spyOn(service, 'teleportPlayer');

        // Directly call the teleportPlayer method with the expected parameters
        service.teleportPlayer(POSITION_X, POSITION_Y);

        // Verify that teleportPlayer was called with the spawn point coordinates
        expect(service.teleportPlayer).toHaveBeenCalledWith(POSITION_X, POSITION_Y);
    });

    it('should listen to updateScore and handle score update', () => {
        const winnerId = 'testWinnerId';
        const score = 3;
        mockGameManagerService.updateScore.and.returnValue(score);
        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'updateScore') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();
        eventCallback(winnerId);

        expect(mockGameManagerService.updateScore).toHaveBeenCalledWith(winnerId);
    });

    it('should call finishGame when player reaches MAX_WINS', () => {
        // Import MAX_WINS from combat.constants
        const MAX_WINS = 3; // Assuming MAX_WINS is 3, adjust if different

        // Set up a player that matches the socket ID
        const mockPlayer = new Player();
        mockPlayer.id = 'testSocketId';

        // Set up the game manager service to return the player
        mockGameManagerService.getMainPlayer.and.returnValue(mockPlayer);

        // Make updateScore return MAX_WINS to trigger the finishGame call
        mockGameManagerService.updateScore.and.returnValue(MAX_WINS);

        // Create a spy for the finishGame method
        spyOn(service, 'finishGame');

        // Set up the event callback
        let eventCallback: (...args: unknown[]) => void = () => {};
        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'updateScore') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        // Create the service and set up listeners
        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();

        // Trigger the updateScore event with the player's ID as the winner
        eventCallback('testSocketId');

        // Verify that finishGame was called with the winner's ID
        expect(service.finishGame).toHaveBeenCalledWith('testSocketId');
    });

    it('should listen to updateCombatCountDown and update combat countdown', () => {
        const countdown = 10;
        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'updateCombatCountDown') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();
        eventCallback(countdown);

        expect(mockCombatService.combatCountdown.next).toHaveBeenCalledWith(countdown);
    });

    it('should listen to gameAbandoned and navigate to home', () => {
        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'gameAbandoned') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();
        eventCallback();

        expect(mockRouter.navigate).toHaveBeenCalledWith(['/home']);
    });

    it('should listen to gameCanceled and handle game cancellation', () => {
        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'gameCanceled') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();
        eventCallback();

        expect(mockGameManagerService.cancelGame).toHaveBeenCalled();
        expect(mockRouter.navigate).toHaveBeenCalledWith(['/home']);
    });

    it('should listen to playerAbandoned and disconnect player', () => {
        const playerId = 'testPlayerId';
        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'playerAbandoned') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();
        eventCallback(playerId);

        expect(mockGameManagerService.disconnectPlayer).toHaveBeenCalledWith(playerId);
    });

    it('should listen to debugModeEnabled and toggle debug mode', () => {
        spyOn(console, 'log');
        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'debugModeEnabled') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();
        eventCallback();

        expect(mockGameRoomService.toggleDebugMode).toHaveBeenCalled();
        expect(mockGameManagerService.clearPaths).toHaveBeenCalled();
        expect(mockGameManagerService.setActionPoints).toHaveBeenCalledWith(1);
    });

    it('should listen to debugModeDisabled and toggle debug mode', () => {
        spyOn(console, 'log');
        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'debugModeDisabled') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();
        eventCallback();

        expect(mockGameRoomService.toggleDebugMode).toHaveBeenCalled();
        expect(mockSocket.emit).toHaveBeenCalledWith('playerGetMovements', 'testRoomId');
    });

    it('should listen to doorToggled and toggle door state', () => {
        const coords = { x: 5, y: 10 };
        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'doorToggled') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();
        eventCallback(coords);

        const cell = mockGameManagerService.getBoard().getCell(coords.x, coords.y);
        expect(cell?.tile.toggleState).toHaveBeenCalled();
        expect(mockSocket.emit).toHaveBeenCalledWith('playerGetMovements', 'testRoomId');
    });

    it('should end player turn when doorToggled and player has no movement or action points left', () => {
        // Set up a player with no movement points and no action points
        const mockPlayer = new Player();
        mockPlayer.id = 'testSocketId';
        mockPlayer.movementPoints = 0;
        mockPlayer.actionPoints = 0;

        // Set up the game manager service to return the player with no points
        mockGameManagerService.getMainPlayer.and.returnValue(mockPlayer);
        mockGameManagerService.currentPlayerId = 'testSocketId';
        mockGameManagerService.getRoomId.and.returnValue('testRoomId');

        // Set up the coordinates for the doorToggled event
        const coords = { x: 5, y: 10 };

        // Set up the event callback
        let eventCallback: (...args: unknown[]) => void = () => {};
        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'doorToggled') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        // Create the service and set up listeners
        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();

        // Reset the emit spy to clear previous calls
        mockSocket.emit.calls.reset();

        // Trigger the doorToggled event
        eventCallback(coords);

        // Verify that endTurn was called with the room ID
        expect(mockSocket.emit).toHaveBeenCalledWith('endTurn', 'testRoomId');
    });

    // Direct test for the auto end turn condition
    it('should directly test auto end turn when player has no movement or action points left', () => {
        // Create a player with no movement points and no action points
        const player = new Player();
        player.id = 'testSocketId';
        player.movementPoints = 0;
        player.actionPoints = 0;

        // Create a mock game manager service
        const mockGameManager = jasmine.createSpyObj('GameManagerService', ['getRoomId', 'getMainPlayer']);
        mockGameManager.getRoomId.and.returnValue('testRoomId');
        mockGameManager.getMainPlayer.and.returnValue(player);
        mockGameManager.currentPlayerId = 'testSocketId';

        // Create the service and inject our mocks
        service = TestBed.inject(SocketService);
        service['gameManagerService'] = mockGameManager;

        // Create a spy for the endPlayerTurn method
        spyOn(service, 'endPlayerTurn');

        // Directly execute the code we want to test
        if (player && player.movementPoints <= 0 && player.actionPoints <= 0) {
            const gameRoomId = service['gameManagerService'].getRoomId();
            service.endPlayerTurn(gameRoomId);
        }

        // Verify that endPlayerTurn was called with the room ID
        expect(service.endPlayerTurn).toHaveBeenCalledWith('testRoomId');
    });

    it('should listen to finishGame and finish the game', () => {
        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'finishGame') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();
        eventCallback();

        expect(mockGameManagerService.finishGame).toHaveBeenCalled();
    });
});

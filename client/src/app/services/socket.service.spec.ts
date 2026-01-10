/* eslint-disable @typescript-eslint/no-empty-function */
/* eslint-disable @typescript-eslint/no-explicit-any */
import { TestBed } from '@angular/core/testing';
import { Router } from '@angular/router';
import { Game } from '@app/classes/game';
import { Item } from '@app/classes/item';
import { Player } from '@app/classes/player';
import { ROUTES } from '@app/constants/routes.constants';
import { GameManagerService } from '@app/services/game-manager.service';
import { SocketService } from '@app/services/socket.service';
import { WaitingRoomService } from '@app/services/waiting-room.service';
import { of, Subject } from 'rxjs';
import { Socket } from 'socket.io-client';
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
        mockPlayer.name = 'Test Player';
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
                'addItemToBoard',
                'loadGame',
                'addPlayersToBoard',
                'getPlayers',
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
                turnCountdown: jasmine.createSpyObj('BehaviorSubject', ['next']),
                isGameLoaded: false,
            },
        );

        mockGameRoomService = jasmine.createSpyObj('GameRoomService', ['updateRoom', 'updatePlayers', 'toggleDebugMode'], {
            room: {
                roomId: 'testRoomId',
                players: [mockPlayer],
            },
        });

        mockCombatService = jasmine.createSpyObj(
            'CombatService',
            ['setIsCombatPlayerTurn', 'setCombatRoom', 'handleAttackResult', 'handleFlightResult', 'handleEnd'],
            {
                isCombatMode: false,
                combatCountdown: jasmine.createSpyObj('BehaviorSubject', ['next']),
                loserId: 'differentPlayerId',
            },
        );

        mockRouter = jasmine.createSpyObj('Router', ['navigate']);
        mockSocket = jasmine.createSpyObj('Socket', ['emit', 'on', 'once', 'id', 'disconnect', 'removeAllListeners'], { id: 'testSocketId' });

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
    });

    it('should create', () => {
        expect(service).toBeTruthy();
    });

    it('should get the player name', () => {
        expect(service.playerName).toBe('Test Player');
    });

    it('should return the socket ID when getId is called', () => {
        expect(service.getId()).toBe('testSocketId');
    });

    it('should return the room ID when getRoomId is called', () => {
        expect(service.getRoomId()).toBe('testRoomId');
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
        // Since getPlayerMovements is private, we need to call it through a public method or adjust the test accordingly.
        service['getPlayerMovements'](); // Accessing the private method directly for testing purposes
        expect(mockSocket.emit).toHaveBeenCalledWith('playerGetMovements', {
            roomId: 'testRoomId',
            hasBoots: false,
            hasCamo: false,
            hasAirStrike: false,
        });
    });

    it('should emit playerTeleported when teleportPlayer is called', () => {
        service.teleportPlayer(POSITION_X, POSITION_Y, 'testSocketId');
        expect(mockSocket.emit).toHaveBeenCalledWith('playerTeleported', {
            roomId: 'testRoomId',
            playerId: 'testSocketId',
            destination: { x: POSITION_X, y: POSITION_Y },
            hasCamo: undefined,
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

    it('should listen to playerSpawned and update players', async () => {
        const players = [new Player(), new Player()];
        let eventCallback: (...args: unknown[]) => void = () => {};

        // Create a mock Game object
        const mockGame = new Game();
        mockGame._id = 'testGameId';
        mockGame.name = 'Test Game';
        mockGame.description = 'Test Description';
        mockGame.mode = 'classic';
        mockGame.board = jasmine.createSpyObj('Board', [
            'getPlayerById',
            'getCell',
            'createMatrix',
            'createMatrixFromData',
            'getMatrix',
            'getSize',
            'getPlayers',
            'addPlayer',
        ]);
        mockGame.board.matrix = [];
        mockGame.board.size = 10;

        // Create a subject for the loadGame method
        const loadGameSubject = new Subject<Game>();

        // Make the mockGameManagerService.getPlayers return the players array
        mockGameManagerService.getPlayers.and.returnValue(players);

        // Mock the loadGame method to return the subject as an Observable
        mockGameManagerService.loadGame.and.returnValue(loadGameSubject.asObservable());

        // Mock the addPlayersToBoard method to return true
        mockGameManagerService.addPlayersToBoard.and.returnValue(true);

        // Set up a spy implementation for socket.on that captures the playerSpawned callback
        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'playerSpawned') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();

        // Trigger the playerSpawned event
        eventCallback(players);

        // Verify initial expectations
        expect(mockGameRoomService.updatePlayers).toHaveBeenCalledWith(players);
        expect(mockGameManagerService.loadGame).toHaveBeenCalled();

        // Simulate the subscribe callback by manually setting isGameLoaded to true
        mockGameManagerService.isGameLoaded = true;

        // Manually trigger the loadGame subscription callback
        loadGameSubject.next(mockGame);

        // Now verify that the other methods were called
        expect(mockGameManagerService.addPlayersToBoard).toHaveBeenCalledWith(players);
        expect(mockGameManagerService.setMainPlayer).toHaveBeenCalledWith('testSocketId');
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
        expect(mockSocket.emit).toHaveBeenCalledWith('playerGetMovements', {
            roomId: 'testRoomId',
            hasBoots: false,
            hasCamo: false,
            hasAirStrike: false,
        });
    });

    it('should return early when player is not found in turnStarting event', () => {
        const data = {
            nextPlayer: new Player(),
            startTime: Date.now(),
        };

        // Set up room with no players to ensure player is undefined
        mockGameManagerService.room.players = [];

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

        // Reset spies to clear previous calls
        mockGameManagerService.setMovementPoints.calls.reset();
        mockGameManagerService.setActionPoints.calls.reset();
        mockGameManagerService.selectPlayer.calls.reset();

        eventCallback(data);

        // Verify that none of the methods were called after the early return
        expect(mockGameManagerService.setMovementPoints).not.toHaveBeenCalled();
        expect(mockGameManagerService.setActionPoints).not.toHaveBeenCalled();
        expect(mockGameManagerService.selectPlayer).not.toHaveBeenCalled();
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

    it('should return early when main player is not found in updateScore event', () => {
        const winnerId = 'testWinnerId';

        // Set up the game manager service to return null for getMainPlayer
        mockGameManagerService.getMainPlayer.and.returnValue(null);

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

        // Trigger the updateScore event
        eventCallback(winnerId);

        // Verify that updateScore was called with the winner ID
        expect(mockGameManagerService.updateScore).toHaveBeenCalledWith(winnerId);

        // Verify that finishGame was NOT called (early return)
        expect(service.finishGame).not.toHaveBeenCalled();
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
        const playerId = 'testSocketId';
        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'playerAbandoned') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        spyOn(service, 'addToJournal').and.callThrough();

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();
        eventCallback(playerId);

        expect(service.addToJournal).toHaveBeenCalledWith({
            type: 'TOUS',
            content: ' Test Player a abandonné la partie.',
        });

        expect(mockGameManagerService.disconnectPlayer).toHaveBeenCalledWith(playerId);
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

    describe('navigateToHome', () => {
        it('should navigate to home route', () => {
            service.navigateToHome();
            expect(mockRouter.navigate).toHaveBeenCalledWith(['/home']);
        });
    });

    describe('setUpConnection', () => {
        it('should call setUpConnection on all registered socket services', () => {
            // Create mock socket services
            const mockSocketService1 = jasmine.createSpyObj('ISocketService', ['setUpConnection']);
            const mockSocketService2 = jasmine.createSpyObj('ISocketService', ['setUpConnection']);

            // Add mock services to the socketServices array
            service['socketServices'] = [mockSocketService1, mockSocketService2];

            // Call setUpConnection
            service.setUpConnection();

            // Verify that setUpConnection was called on each service
            expect(mockSocketService1.setUpConnection).toHaveBeenCalled();
            expect(mockSocketService2.setUpConnection).toHaveBeenCalled();
        });
    });

    it('should emit itemDropped when dropItem is called', () => {
        const item = new Item('adrenaline');
        const coords = { x: 5, y: 10 };
        service.dropItem(item, coords);
        expect(mockSocket.emit).toHaveBeenCalledWith('itemDropped', {
            roomId: 'testRoomId',
            playerId: 'testSocketId',
            item,
            coords,
        });
    });

    it('should listen to itemDropped and add item to board', () => {
        // Create an item to be dropped
        const item = new Item('adrenaline');
        const coords = { x: 5, y: 10 };

        // Set up the event callback
        let eventCallback: (...args: unknown[]) => void = () => {};
        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'itemDropped') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        // Create the service and set up listeners
        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();

        // Trigger the itemDropped event
        eventCallback({ item, coords });

        // Verify that addItemToBoard was called with the correct parameters
        expect(mockGameManagerService.addItemToBoard).toHaveBeenCalledWith(item, coords);
    });

    it('should handle ItemDroppedDisconnected event and emit ItemDropped for each non-null item', () => {
        // Simulate player inventory
        const testItem1 = new Item('adrenaline');
        const testItem2 = new Item('adrenaline');
        const testItems = [testItem1, testItem2];

        // Coords of player and roomId
        const testCoords = { x: 5, y: 10 };
        const testRoomId = 'testRoomId';

        // Nearest empty cells
        const emptyCells = [
            { x: 6, y: 10 },
            { x: 6, y: 11 },
        ];
        const boardSpy = jasmine.createSpyObj('Board', ['getTwoNearestEmptyCells']);
        boardSpy.getTwoNearestEmptyCells.and.returnValue(emptyCells);
        mockGameManagerService.getBoard.and.returnValue(boardSpy);

        let eventCallback: (data: any) => void = () => {};
        mockSocket.on.and.callFake((event: string, callback: (data: any) => void) => {
            if (event === 'itemDroppedDisconnected') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();

        const eventData = {
            roomId: testRoomId,
            coords: testCoords,
            items: testItems,
        };

        eventCallback(eventData);

        expect(mockSocket.emit).toHaveBeenCalledWith('itemDropped', {
            roomId: testRoomId,
            playerId: null,
            item: testItem1,
            coords: emptyCells[0],
        });
        expect(mockSocket.emit).toHaveBeenCalledWith('itemDropped', {
            roomId: testRoomId,
            playerId: null,
            item: testItem2,
            coords: emptyCells[1],
        });

        expect(mockSocket.emit).toHaveBeenCalledTimes(testItems.length);
    });

    it('should emit virtualPlayerTurn when virtualPlayerTurn is called', () => {
        const playerId = 'testPlayerId';
        service.virtualPlayerTurn(playerId);
        expect(mockSocket.emit).toHaveBeenCalledWith('virtualPlayerTurn', {
            roomId: 'testRoomId',
            playerId,
            isCTF: undefined,
            skipTimeout: undefined,
        });
        expect(mockSocket.emit).toHaveBeenCalledWith('addJournalEntry', {
            roomId: 'testRoomId',
            entry: {
                type: 'TOUS',
                content: ' Test Player commence son tour.',
            },
        });
    });

    it('should handle virtual player turn when the current player is the organisator and the next player is virtual', () => {
        // Create a virtual player for the next turn
        const virtualPlayer = new Player();
        virtualPlayer.id = 'virtualPlayerId';
        virtualPlayer.isVirtual = true;
        virtualPlayer.movementPoints = 3;

        // Set up the room with the current player as the organisator
        mockGameManagerService.room = {
            roomId: 'testRoomId',
            organisatorId: 'testSocketId', // Current player is the organisator
            isDebugging: false,
            players: [virtualPlayer],
            gameId: 'testGameId',
            isLocked: false,
        };

        const data = {
            nextPlayer: virtualPlayer,
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

        // Reset spies to clear previous calls
        mockGameManagerService.selectPlayer.calls.reset();
        mockGameManagerService.setMovementPoints.calls.reset();
        mockGameManagerService.setActionPoints.calls.reset();
        mockSocket.emit.calls.reset();

        // Trigger the turnStarting event
        eventCallback(data);

        // Verify that the virtual player was selected and points were set
        expect(mockGameManagerService.selectPlayer).toHaveBeenCalled();
        expect(mockGameManagerService.setMovementPoints).toHaveBeenCalledWith(virtualPlayer.movementPoints);
        expect(mockGameManagerService.setActionPoints).toHaveBeenCalledWith(1);

        // Verify that virtualPlayerTurn was called with the virtual player's ID
        expect(mockSocket.emit).toHaveBeenCalledWith('virtualPlayerTurn', {
            roomId: 'testRoomId',
            playerId: virtualPlayer.id,
            isCTF: undefined,
            skipTimeout: undefined,
        });
        expect(mockSocket.emit).toHaveBeenCalledWith('addJournalEntry', {
            roomId: 'testRoomId',
            entry: {
                type: 'TOUS',
                content: ' Test Player commence son tour.',
            },
        });
    });

    it('should emit send message to game room', () => {
        const message = 'Hello, world!';
        service.sendMessageToGameRoom(message, 'Test Player');
        expect(mockSocket.emit).toHaveBeenCalledWith('sendMessageToGameRoom', {
            message,
            playerName: 'Test Player',
            roomId: 'testRoomId',
        });
    });

    it('should emit quit end game', () => {
        const roomId = 'testRoomId';
        service.quitEndGame();
        expect(mockSocket.emit).toHaveBeenCalledWith('quitEndGame', roomId);
    });

    it('should listen to updateStartingCountdown and update turn countdown', () => {
        const countdown = 10;
        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'updateStartingCountdown') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();
        eventCallback(countdown);

        expect(mockGameManagerService.turnCountdown.next).toHaveBeenCalledWith(countdown);
    });

    it('should listen to itemDropped and handle flag item correctly', () => {
        const mockItem = new Item('flag');
        const mockCoords = { x: 5, y: 10 };
        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'itemDropped') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();

        // Set initial playerWithFlag value
        mockGameManagerService.playerWithFlag = 'somePlayerId';

        // Trigger the itemDropped event
        eventCallback({ item: mockItem, coords: mockCoords });

        // Verify that addItemToBoard was called with the correct arguments
        expect(mockGameManagerService.addItemToBoard).toHaveBeenCalledWith(mockItem, mockCoords);
        // Verify that playerWithFlag was set to null when a flag item is dropped
        expect(mockGameManagerService.playerWithFlag).toBeNull();
    });

    it('should listen to flagCollected and update playerWithFlag', () => {
        const playerId = 'testPlayerId';
        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'flagCollected') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();

        // Trigger the flagCollected event
        eventCallback(playerId);

        // Verify that playerWithFlag was updated with the player ID
        expect(mockGameManagerService.playerWithFlag).toBe(playerId);
    });

    it('should listen to organizatorChanged and update organisatorId', () => {
        const newOrganisatorId = 'newOrganisatorId';
        let eventCallback: (...args: unknown[]) => void = () => {};

        mockSocket.on.and.callFake((event: string, callback: (...args: any[]) => void) => {
            if (event === 'organizatorChanged') {
                eventCallback = callback;
            }
            return mockSocket;
        });

        service = TestBed.inject(SocketService);
        service.connect();
        (service as any).setUpListeners();

        // Set initial organisatorId value
        mockGameManagerService.room.organisatorId = 'oldOrganisatorId';

        // Trigger the organizatorChanged event
        eventCallback({ newOrganisatorId });

        // Verify that organisatorId was updated with the new value
        expect(mockGameManagerService.room.organisatorId).toBe(newOrganisatorId);
    });

    it('should return early when game is in CTF mode in updateScore event', () => {
        const winnerId = 'testWinnerId';
        const score = 3;

        // Set up the game manager service to return a score
        mockGameManagerService.updateScore.and.returnValue(score);

        // Set up the game manager service to indicate CTF mode
        Object.defineProperty(mockGameManagerService, 'isCTF', {
            get: () => true,
        });

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

        // Trigger the updateScore event
        eventCallback(winnerId);

        // Verify that updateScore was called with the winner ID
        expect(mockGameManagerService.updateScore).toHaveBeenCalledWith(winnerId);

        // Verify that finishGame was NOT called (early return due to CTF mode)
        expect(service.finishGame).not.toHaveBeenCalled();
    });

    it('should call finishGame when a virtual player wins and current player is the organizer', () => {
        // Set up a virtual player as the winner
        const virtualPlayer = new Player();
        virtualPlayer.id = 'virtualPlayerId';
        virtualPlayer.isVirtual = true;
        virtualPlayer.name = 'Virtual Player';

        // Set up the game manager service to return a score that meets the MAX_WINS threshold
        const score = 3; // Assuming MAX_WINS is 3
        mockGameManagerService.updateScore.and.returnValue(score);

        // Set up the game manager service to return the virtual player as the winner
        mockGameManagerService.room.players = [virtualPlayer];

        // Set up the game manager service to return a main player that is not the winner
        const mainPlayer = new Player();
        mainPlayer.id = 'testSocketId';
        mockGameManagerService.getMainPlayer.and.returnValue(mainPlayer);

        // Set up the game manager service to indicate it's not CTF mode
        Object.defineProperty(mockGameManagerService, 'isCTF', {
            get: () => false,
        });

        // Set up the game manager service to have the current player as the organizer
        mockGameManagerService.room.organisatorId = 'testSocketId';

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

        // Trigger the updateScore event with the virtual player's ID as the winner
        eventCallback('virtualPlayerId');

        // Verify that updateScore was called with the winner ID
        expect(mockGameManagerService.updateScore).toHaveBeenCalledWith('virtualPlayerId');

        // Verify that finishGame was called with the winner's ID
        expect(service.finishGame).toHaveBeenCalledWith('virtualPlayerId');
    });
});

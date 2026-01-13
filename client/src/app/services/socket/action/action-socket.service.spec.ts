/* eslint-disable prettier/prettier */
/* eslint-disable @typescript-eslint/no-empty-function */
/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable max-lines */
import { TestBed } from '@angular/core/testing';
import { Cell } from '@app/classes/cell';
import { Player } from '@app/classes/player';
import { Tile } from '@app/classes/tile';
import { AttackPayload, AttackResult, CombatPayload, CombatRoom, FlightResult } from '@app/interfaces/payload';
import { CombatService } from '@app/services/combat.service';
import { GameManagerService } from '@app/services/game-manager.service';
import { GameRoomService } from '@app/services/game-room.service';
import { SocketService } from '@app/services/socket.service';
import { GameRoomEvents } from '@common/socket.constants';
import { Socket } from 'socket.io-client';
import { ActionSocketService } from '@app/services/socket/action/action-socket.service';
import { MovementSocketService } from '@app/services/socket/movement/movement-socket.service';

describe('ActionSocketService', () => {
    let service: ActionSocketService;
    let mockGameManagerService: jasmine.SpyObj<GameManagerService>;
    let mockSocket: jasmine.SpyObj<Socket>;
    let mockSocketService: jasmine.SpyObj<SocketService>;
    let mockCombatService: jasmine.SpyObj<CombatService>;
    let mockGameRoomService: jasmine.SpyObj<GameRoomService>;
    let mockMovementSocketService: jasmine.SpyObj<MovementSocketService>;
    let currentPlayerIdValue: string;
    let socketIdValue: string;
    let isCombatModeValue: boolean;

    beforeEach(() => {
        // Create a mock room object
        const mockRoom = {
            roomId: 'testRoomId',
            gameId: 'testGameId',
            organisatorId: 'testSocketId',
            players: [],
            isLocked: false,
            isDebugging: false,
        };

        // Initialize the currentPlayerId value
        currentPlayerIdValue = 'testSocketId';
        socketIdValue = 'testSocketId';
        isCombatModeValue = true;

        // Create the spy objects with all methods
        mockGameManagerService = jasmine.createSpyObj('GameManagerService', [
            'getBoard',
            'getMainPlayer',
            'getRoomId',
            'clearPaths',
            'setActionPoints',
            'isDebugMode',
            'getPlayerById',
        ]);
        mockGameManagerService.getPlayerById.and.stub();

        // Add the room property
        Object.defineProperty(mockGameManagerService, 'room', {
            get: () => mockRoom,
        });

        // Add the currentPlayerId property with a getter that returns the current value
        Object.defineProperty(mockGameManagerService, 'currentPlayerId', {
            get: () => currentPlayerIdValue,
        });

        // Create mock socket with all required methods
        mockSocket = jasmine.createSpyObj('Socket', ['emit', 'on', 'id']);

        // Set up the socket id property
        Object.defineProperty(mockSocket, 'id', {
            get: () => socketIdValue,
        });

        // Create mock socket service with all required methods
        mockSocketService = jasmine.createSpyObj('SocketService', [
            'registerSocketService',
            'getId',
            'getPlayerMovements',
            'teleportPlayer',
            'endPlayerTurn',
        ]);

        // Set up the socket property in the socket service
        Object.defineProperty(mockSocketService, 'socket', {
            get: () => mockSocket,
        });

        // Set up the getId method to return the socket id
        mockSocketService.getId.and.returnValue(socketIdValue);

        mockCombatService = jasmine.createSpyObj('CombatService', [
            'handleAttackResult',
            'handleFlightResult',
            'setIsCombatPlayerTurn',
            'setCombatRoom',
            'handleEnd',
            'showFlightResult',
            'getVirtualPlayerAttack',
        ]);

        // Set up isCombatMode to return the current value
        Object.defineProperty(mockCombatService, 'isCombatMode', {
            get: () => isCombatModeValue,
        });

        mockGameRoomService = jasmine.createSpyObj('GameRoomService', ['toggleDebugMode', 'setDebugMode']);

        mockMovementSocketService = jasmine.createSpyObj('MovementSocketService', ['getPlayerMovements']);
        mockMovementSocketService.getPlayerMovements.and.stub();

        TestBed.configureTestingModule({
            providers: [
                ActionSocketService,
                { provide: GameManagerService, useValue: mockGameManagerService },
                { provide: SocketService, useValue: mockSocketService },
                { provide: CombatService, useValue: mockCombatService },
                { provide: GameRoomService, useValue: mockGameRoomService },
                { provide: MovementSocketService, useValue: mockMovementSocketService },
            ],
        });

        service = TestBed.inject(ActionSocketService);

        // Set up the socket property in the service
        Object.defineProperty(service, 'socket', {
            get: () => mockSocket,
        });
    });

    describe('Basic functionality', () => {
        it('should create', () => {
            expect(service).toBeTruthy();
        });

        it('should set up connection and listeners on construction', () => {
            expect(mockSocketService.registerSocketService).toHaveBeenCalledWith(service);
            expect(mockSocket.on).toHaveBeenCalled();
        });

        it('should expose attackTrigger as an observable', () => {
            expect(service.attackTrigger).toBeDefined();
            expect(typeof service.attackTrigger.subscribe).toBe('function');
        });
    });

    describe('Action methods', () => {
        it('should emit ToggleDebugMode with correct data when conditions are met', () => {
            // Set up the conditions for toggleDebugMode to emit
            currentPlayerIdValue = 'testSocketId';
            Object.defineProperty(mockGameManagerService.room, 'organisatorId', {
                get: () => 'testSocketId',
            });

            service.toggleDebugMode();

            expect(mockSocket.emit).toHaveBeenCalledWith(GameRoomEvents.ToggleDebugMode, 'testRoomId');
        });

        it('should not emit ToggleDebugMode when current player is not the socket owner', () => {
            // Set up the conditions for toggleDebugMode to not emit
            currentPlayerIdValue = 'differentSocketId';
            Object.defineProperty(mockGameManagerService.room, 'organisatorId', {
                get: () => 'testSocketId',
            });

            service.toggleDebugMode();

            expect(mockSocket.emit).not.toHaveBeenCalledWith(GameRoomEvents.ToggleDebugMode, 'testRoomId');
        });

        it('should not emit ToggleDebugMode when current player is not the organisator', () => {
            // Set up the conditions for toggleDebugMode to not emit
            currentPlayerIdValue = 'testSocketId';
            Object.defineProperty(mockGameManagerService.room, 'organisatorId', {
                get: () => 'differentSocketId',
            });

            service.toggleDebugMode();

            expect(mockSocket.emit).not.toHaveBeenCalledWith(GameRoomEvents.ToggleDebugMode, 'testRoomId');
        });

        it('should emit StartCombat with correct data', () => {
            const combatPayload: CombatPayload = {
                roomId: 'testRoomId',
                opponentId: 'opponentId',
            };

            service.startCombat(combatPayload);

            expect(mockSocket.emit).toHaveBeenCalledWith(GameRoomEvents.StartCombat, combatPayload);
        });

        it('should emit FlightAttempt with correct data', () => {
            const combatPayload: CombatPayload = {
                roomId: 'testRoomId',
                opponentId: 'opponentId',
            };

            service.flightAttempt(combatPayload);

            expect(mockSocket.emit).toHaveBeenCalledWith(GameRoomEvents.FlightAttempt, combatPayload.roomId);
        });

        it('should emit Attack with correct data', () => {
            const attackPayload: AttackPayload = {
                roomId: 'testRoomId',
                attackValue: 10,
                defenseValue: 5,
            };

            service.attack(attackPayload);

            expect(mockSocket.emit).toHaveBeenCalledWith(GameRoomEvents.Attack, attackPayload);
        });

        it('should emit DoorToggled with correct data', () => {
            const x = 5;
            const y = 10;

            service.toggleDoor(x, y);

            expect(mockSocket.emit).toHaveBeenCalledWith(GameRoomEvents.DoorToggled, {
                roomId: 'testRoomId',
                x,
                y,
            });
        });
    });

    describe('Socket event handlers', () => {
        function triggerSocketEvent(eventName: string, ...args: any[]): void {
            // Get the event handler for the given event
            const eventArgs = mockSocket.on.calls.allArgs();
            const eventHandler = eventArgs.find((arg) => arg[0] === eventName);
            if (eventHandler && typeof eventHandler[1] === 'function') {
                eventHandler[1](...args);
            }
        }

        it('should handle PerformAttack event', () => {
            // Create a spy on the attackTriggerSubject
            const attackTriggerSpy = spyOn(service['attackTriggerSubject'], 'next');

            triggerSocketEvent(GameRoomEvents.PerformAttack);

            expect(attackTriggerSpy).toHaveBeenCalled();
        });

        it('should handle AttackResult event', () => {
            const attackResult: AttackResult = {
                isAttackSuccess: true,
                opponentHealthPoints: 10,
                attackValue: 15,
                defenseValue: 5,
            };

            triggerSocketEvent(GameRoomEvents.AttackResult, attackResult);

            expect(mockCombatService.handleAttackResult).toHaveBeenCalledWith(attackResult);
        });

        it('should handle AttackResult event even if the attack is not a success', () => {
            const attackResult: AttackResult = {
                isAttackSuccess: false,
                opponentHealthPoints: 10,
                attackValue: 15,
                defenseValue: 5,
            };

            triggerSocketEvent(GameRoomEvents.AttackResult, attackResult);

            expect(mockCombatService.handleAttackResult).toHaveBeenCalledWith(attackResult);
        });

        it('should handle FlightAttemptResult event', () => {
            const flightResult: FlightResult = {
                isSuccess: true,
                attackerEvasionPoints: 10,
            };

            triggerSocketEvent(GameRoomEvents.FlightAttemptResult, flightResult);

            expect(mockCombatService.showFlightResult).toHaveBeenCalledWith(flightResult);
            expect(mockCombatService.handleFlightResult).toHaveBeenCalledWith(flightResult);
        });

        it('should handle FlightAttemptResult event even if flight was not a success', () => {
            const flightResult: FlightResult = {
                isSuccess: false,
                attackerEvasionPoints: 10,
            };

            triggerSocketEvent(GameRoomEvents.FlightAttemptResult, flightResult);

            expect(mockCombatService.showFlightResult).toHaveBeenCalledWith(flightResult);
            expect(mockCombatService.handleFlightResult).toHaveBeenCalledWith(flightResult);
        });

        it('should handle CombatTurnStarted event when current player is not the socket owner', () => {
            const combatRoom: CombatRoom = {
                combatRoomId: 'testCombatRoomId',
                players: [],
                attackerId: 'testSocketId',
                defenderId: 'opponentId',
                currentPlayerId: 'differentSocketId',
                currentOpponentId: 'opponentId',
            };

            // Reset the spy calls
            mockCombatService.setIsCombatPlayerTurn.calls.reset();
            mockCombatService.setCombatRoom.calls.reset();

            triggerSocketEvent(GameRoomEvents.CombatTurnStarted, combatRoom);

            expect(mockCombatService.setIsCombatPlayerTurn).toHaveBeenCalledWith(false);
            expect(mockCombatService.setCombatRoom).not.toHaveBeenCalled();
        });

        it('should handle CombatTurnStarted event when current player is the socket owner', () => {
            const combatRoom: CombatRoom = {
                combatRoomId: 'testCombatRoomId',
                players: [],
                attackerId: 'testSocketId',
                defenderId: 'opponentId',
                currentPlayerId: 'testSocketId',
                currentOpponentId: 'opponentId',
            };

            // Reset the spy calls
            mockCombatService.setIsCombatPlayerTurn.calls.reset();
            mockCombatService.setCombatRoom.calls.reset();

            // Make sure the socket ID matches the current player ID
            socketIdValue = 'testSocketId';
            currentPlayerIdValue = 'testSocketId';
            mockSocketService.getId.and.returnValue('testSocketId');

            triggerSocketEvent(GameRoomEvents.CombatTurnStarted, combatRoom);

            expect(mockCombatService.setIsCombatPlayerTurn).toHaveBeenCalledWith(true);
            expect(mockCombatService.setCombatRoom).not.toHaveBeenCalled();
        });

        it('should handle CombatTurnStarted event when not in combat mode', () => {
            const combatRoom: CombatRoom = {
                combatRoomId: 'testCombatRoomId',
                players: [],
                attackerId: 'testSocketId',
                defenderId: 'opponentId',
                currentPlayerId: 'differentSocketId',
                currentOpponentId: 'opponentId',
            };

            // Reset the spy calls
            mockCombatService.setIsCombatPlayerTurn.calls.reset();
            mockCombatService.setCombatRoom.calls.reset();

            // Change the isCombatMode value to false for this test
            isCombatModeValue = false;

            triggerSocketEvent(GameRoomEvents.CombatTurnStarted, combatRoom);

            expect(mockCombatService.setCombatRoom).toHaveBeenCalledWith(combatRoom);
        });

        it('should handle EndCombat event when current player is not the loser', () => {
            const winnerId = 'opponentId';
            const loserId = 'differentSocketId';
            
            // Set up the loserId property in the mockCombatService
            Object.defineProperty(mockCombatService, 'loserId', {
                get: () => loserId,
            });

            triggerSocketEvent(GameRoomEvents.EndCombat, winnerId, loserId);

            expect(mockCombatService.handleEnd).toHaveBeenCalledWith(winnerId, loserId);
            expect(mockSocketService.teleportPlayer).not.toHaveBeenCalled();
        });

        it('should handle EndCombat event when current player is the loser', () => {
            const winnerId = 'opponentId';
            const loserId = 'testSocketId';
            
            // Set up the loserId property in the mockCombatService
            Object.defineProperty(mockCombatService, 'loserId', {
                get: () => loserId,
                set: () => {},
            });

            // Set up the socket id to match the loserId
            socketIdValue = loserId;

            // Set up a player with spawnPoint
            const mockPlayer = new Player();
            mockPlayer.id = loserId;
            mockPlayer.spawnPoint = { x: 0, y: 0 };

            // Set up the room to have the player
            Object.defineProperty(mockGameManagerService.room, 'players', {
                get: () => [mockPlayer],
            });

            triggerSocketEvent(GameRoomEvents.EndCombat, winnerId, loserId);

            expect(mockCombatService.handleEnd).toHaveBeenCalledWith(winnerId, loserId);
            expect(mockSocketService.teleportPlayer).toHaveBeenCalledWith(0, 0, loserId);
        });

        it('should handle EndCombat event when socket ID matches organizer ID and loser is a virtual player', () => {
            const winnerId = 'opponentId';
            const loserId = 'virtualPlayerId';
            const organisatorId = 'testSocketId';
            
            // Set up the loserId property in the mockCombatService
            Object.defineProperty(mockCombatService, 'loserId', {
                get: () => loserId,
                set: () => {},
            });

            // Set up the socket id to match the organisatorId
            socketIdValue = organisatorId;

            // Set up a virtual player with spawnPoint
            const mockVirtualPlayer = new Player('VirtualPlayer');
            mockVirtualPlayer.id = loserId;
            mockVirtualPlayer.isVirtual = true;
            mockVirtualPlayer.spawnPoint = { x: 10, y: 20 };

            // Set up the room to have the virtual player and the correct organisatorId
            Object.defineProperty(mockGameManagerService.room, 'players', {
                get: () => [mockVirtualPlayer],
            });
            Object.defineProperty(mockGameManagerService.room, 'organisatorId', {
                get: () => organisatorId,
            });

            // Set up getPlayerById to return the virtual player
            mockGameManagerService.getPlayerById.and.callFake((id: string) => {
                if (id === loserId) return mockVirtualPlayer;
                return null;
            });

            triggerSocketEvent(GameRoomEvents.EndCombat, winnerId, loserId);

            expect(mockCombatService.handleEnd).toHaveBeenCalledWith(winnerId, loserId);
            expect(mockSocketService.teleportPlayer).toHaveBeenCalledWith(10, 20, loserId);
            expect(mockCombatService.loserId).toBe('virtualPlayerId');
            expect(mockSocket.emit).toHaveBeenCalledWith(GameRoomEvents.AddJournalEntry, {
                roomId: 'testRoomId',
                entry: {
                    type: 'TOUS',
                    content: `Fin du combat ! ${mockGameManagerService.getPlayerById(winnerId)?.name} a battu VirtualPlayer.`,
                },
            });
        });

        it('should handle DebugModeEnabled event', () => {
            triggerSocketEvent(GameRoomEvents.DebugModeEnabled);

            expect(mockGameRoomService.setDebugMode).toHaveBeenCalledWith(true);
            expect(mockGameManagerService.clearPaths).toHaveBeenCalled();
            expect(mockGameManagerService.setActionPoints).toHaveBeenCalledWith(1);
        });

        it('should handle DebugModeDisabled event when current player is the socket owner', () => {
            triggerSocketEvent(GameRoomEvents.DebugModeDisabled);

            expect(mockGameRoomService.setDebugMode).toHaveBeenCalledWith(false);
            expect(mockMovementSocketService.getPlayerMovements).toHaveBeenCalled();
        });

        it('should handle DoorToggled event when door exists and is of type door', () => {
            // Create a mock door cell
            const mockDoorCell = new Cell(new Tile('door'), 5, 10);
            const mockDoorTile = mockDoorCell.tile;
            spyOn(mockDoorTile, 'toggleState');

            // Set up the board to return the mock door cell
            const mockBoard = { getCell: jasmine.createSpy('getCell').and.returnValue(mockDoorCell) };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);

            // Set up isDebugMode to return false
            Object.defineProperty(mockGameManagerService, 'isDebugMode', {
                get: () => false,
            });

            // Set up currentPlayerId to be the socket owner
            currentPlayerIdValue = 'testSocketId';

            // Set up a player with movement and action points
            const mockPlayer = new Player();
            mockPlayer.movementPoints = 1;
            mockPlayer.actionPoints = 1;
            mockGameManagerService.getMainPlayer.and.returnValue(mockPlayer);

            // Set up getRoomId to return a room ID
            mockGameManagerService.getRoomId.and.returnValue('testRoomId');

            triggerSocketEvent(GameRoomEvents.DoorToggled, { x: 5, y: 10 });

            expect(mockDoorTile.toggleState).toHaveBeenCalled();
            expect(mockMovementSocketService.getPlayerMovements).toHaveBeenCalled();
            expect(mockGameManagerService.clearPaths).not.toHaveBeenCalled();
            expect(mockSocketService.endPlayerTurn).not.toHaveBeenCalled();
        });

        it('should handle DoorToggled event when in debug mode', () => {
            // Create a mock door cell
            const mockDoorCell = new Cell(new Tile('door'), 5, 10);
            const mockDoorTile = mockDoorCell.tile;
            spyOn(mockDoorTile, 'toggleState');

            // Set up the board to return the mock door cell
            const mockBoard = { getCell: jasmine.createSpy('getCell').and.returnValue(mockDoorCell) };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);

            // Set up isDebugMode to return true
            Object.defineProperty(mockGameManagerService, 'isDebugMode', {
                get: () => true,
            });

            triggerSocketEvent(GameRoomEvents.DoorToggled, { x: 5, y: 10 });

            expect(mockDoorTile.toggleState).toHaveBeenCalled();
            expect(mockMovementSocketService.getPlayerMovements).toHaveBeenCalled();
            expect(mockGameManagerService.clearPaths).toHaveBeenCalled();
        });

        it('should handle DoorToggled event when player has no movement or action points left', () => {
            // Create a mock door cell
            const mockDoorCell = new Cell(new Tile('door'), 5, 10);
            const mockDoorTile = mockDoorCell.tile;
            spyOn(mockDoorTile, 'toggleState');

            // Set up the board to return the mock door cell
            const mockBoard = { getCell: jasmine.createSpy('getCell').and.returnValue(mockDoorCell) };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);

            // Set up isDebugMode to return false
            Object.defineProperty(mockGameManagerService, 'isDebugMode', {
                get: () => false,
            });

            // Set up currentPlayerId to be the socket owner
            currentPlayerIdValue = 'testSocketId';

            // Set up a player with no movement or action points
            const mockPlayer = new Player();
            mockPlayer.movementPoints = 0;
            mockPlayer.actionPoints = 0;
            mockGameManagerService.getMainPlayer.and.returnValue(mockPlayer);

            // Set up getRoomId to return a room ID
            mockGameManagerService.getRoomId.and.returnValue('testRoomId');

            triggerSocketEvent(GameRoomEvents.DoorToggled, { x: 5, y: 10 });

            expect(mockDoorTile.toggleState).toHaveBeenCalled();
            expect(mockMovementSocketService.getPlayerMovements).toHaveBeenCalled();
            expect(mockGameManagerService.clearPaths).not.toHaveBeenCalled();
            expect(mockSocketService.endPlayerTurn).toHaveBeenCalledWith('testRoomId');
        });

        it('should handle DoorToggled event when door does not exist', () => {
            // Set up the board to return null for the cell
            const mockBoard = { getCell: jasmine.createSpy('getCell').and.returnValue(null) };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);

            triggerSocketEvent(GameRoomEvents.DoorToggled, { x: 5, y: 10 });

            expect(mockMovementSocketService.getPlayerMovements).toHaveBeenCalled();
        });

        it('should handle DoorToggled event when door exists but is not of type door', () => {
            // Create a mock cell that is not a door
            const mockCell = new Cell(new Tile('snow'), 5, 10);
            const mockTile = mockCell.tile;
            spyOn(mockTile, 'toggleState');

            // Set up the board to return the mock cell
            const mockBoard = { getCell: jasmine.createSpy('getCell').and.returnValue(mockCell) };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);

            triggerSocketEvent(GameRoomEvents.DoorToggled, { x: 5, y: 10 });

            expect(mockTile.toggleState).not.toHaveBeenCalled();
            expect(mockMovementSocketService.getPlayerMovements).toHaveBeenCalled();
        });

        it('should add journal entry and end turn when DoorToggled and player has no points', () => {
            const mockDoorCell = new Cell(new Tile('door'), 1, 1);
            spyOn(mockDoorCell.tile, 'toggleState');

            const mockBoard = { getCell: () => mockDoorCell };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);

            // Simuler un joueur sans points
            const mockPlayer = new Player();
            mockPlayer.movementPoints = 0;
            mockPlayer.actionPoints = 0;
            mockGameManagerService.getMainPlayer.and.returnValue(mockPlayer);
            mockGameManagerService.getRoomId.and.returnValue('roomX');
            mockGameManagerService.getPlayerById.and.returnValue(mockPlayer);

            const journalSpy = spyOn<any>(service, 'addToJournal');

            triggerSocketEvent(GameRoomEvents.DoorToggled, { x: 1, y: 1 });

            expect(journalSpy).toHaveBeenCalled();
            expect(mockSocketService.endPlayerTurn).toHaveBeenCalledWith('roomX');
            expect(service.addToJournal).toHaveBeenCalledWith({
                type: 'TOUS',
                content: `La porte (1, 1) a été fermee par ${mockPlayer.name} !`,
            });
        });

        it('should do the same with the opened door state', () => {
            const mockDoorCell = new Cell(new Tile('door'), 1, 1);
            mockDoorCell.tile.state = 'opened';
            spyOn(mockDoorCell.tile, 'toggleState');

            const mockBoard = { getCell: () => mockDoorCell };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);

            // Simuler un joueur sans points
            const mockPlayer = new Player();
            mockPlayer.movementPoints = 0;
            mockPlayer.actionPoints = 0;
            mockGameManagerService.getMainPlayer.and.returnValue(mockPlayer);
            mockGameManagerService.getRoomId.and.returnValue('roomX');
            mockGameManagerService.getPlayerById.and.returnValue(mockPlayer);

            const journalSpy = spyOn<any>(service, 'addToJournal');

            triggerSocketEvent(GameRoomEvents.DoorToggled, { x: 1, y: 1 });

            expect(journalSpy).toHaveBeenCalled();
            expect(mockSocketService.endPlayerTurn).toHaveBeenCalledWith('roomX');
            expect(service.addToJournal).toHaveBeenCalledWith({
                type: 'TOUS',
                content: `La porte (1, 1) a été ouverte par ${mockPlayer.name} !`,
            });
        });

        it('should handle CalculateVirtualPlayerAttack event when isVirtualCombatOnly is true', () => {
            // Create mock players
            const playerAttacking = new Player('Attacker');
            const playerDefending = new Player('Defender');
            const combatRoomId = 'combat123';

            // Set up getPlayerById to return our mock players
            mockGameManagerService.getPlayerById.and.callFake((id: string) => {
                if (id === 'attackerId') return playerAttacking;
                if (id === 'defenderId') return playerDefending;
                return null;
            });

            // Set up getVirtualPlayerAttack to return a mock attack payload
            const mockAttackPayload = {
                roomId: combatRoomId,
                attackValue: 5,
                defenseValue: 3
            };
            mockCombatService.getVirtualPlayerAttack.and.returnValue(mockAttackPayload);

            // Trigger the event with isVirtualCombatOnly set to true
            triggerSocketEvent(GameRoomEvents.CalculateVirtualPlayerAttack, true, 'attackerId', 'defenderId', combatRoomId);

            // Verify that getVirtualPlayerAttack was called with correct parameters
            expect(mockCombatService.getVirtualPlayerAttack).toHaveBeenCalledWith(playerAttacking, playerDefending, combatRoomId);

            // Verify that attack was called with the mock attack payload
            expect(mockSocket.emit).toHaveBeenCalledWith(GameRoomEvents.Attack, mockAttackPayload);
        });

        it('should handle CalculateVirtualPlayerAttack event when isVirtualCombatOnly is false', () => {
            // Create a spy on the attackTriggerSubject
            const attackTriggerSpy = spyOn(service['attackTriggerSubject'], 'next');

            // Trigger the event with isVirtualCombatOnly set to false
            triggerSocketEvent(GameRoomEvents.CalculateVirtualPlayerAttack, false, 'attackerId', 'defenderId', 'combat123');

            // Verify that attackTriggerSubject.next was called
            expect(attackTriggerSpy).toHaveBeenCalled();

            // Verify that getVirtualPlayerAttack and attack were not called
            expect(mockCombatService.getVirtualPlayerAttack).not.toHaveBeenCalled();
            expect(mockSocket.emit).not.toHaveBeenCalledWith(GameRoomEvents.Attack, jasmine.any(Object));
        });
    });
});

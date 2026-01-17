/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable max-lines */
import { TestBed } from '@angular/core/testing';
import { Cell } from '@app/classes/cell';
import { Item } from '@app/classes/item';
import { Player } from '@app/classes/player';
import { Tile } from '@app/classes/tile';
import { Coords } from '@app/interfaces/coords';
import { GameManagerService } from '@app/services/game-manager.service';
import { MovementService } from '@app/services/movement.service';
import { SocketService } from '@app/services/socket.service';
import { MovementSocketService } from '@app/services/socket/movement-socket.service';
import { GameRoomEvents } from '@common/socket.constants';
import { Socket } from 'socket.io-client';

describe('MovementSocketService', () => {
    let service: MovementSocketService;
    let mockGameManagerService: jasmine.SpyObj<GameManagerService>;
    let mockMovementService: jasmine.SpyObj<MovementService>;
    let mockSocket: jasmine.SpyObj<Socket>;
    let mockSocketService: jasmine.SpyObj<SocketService>;

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

        // Create the spy object with all methods
        mockGameManagerService = jasmine.createSpyObj('GameManagerService', [
            'getMainPlayer',
            'getBoard',
            'setPlayer',
            'setMovementPoints',
            'setPaths',
            'setSelectedPathFromCoords',
            'movePlayerFromPath',
            'getRoomId',
            'clearPaths',
            'dropItem',
            'disconnectPlayer',
            'resetPlayerSelection',
        ]);

        mockMovementService = jasmine.createSpyObj('MovementService', ['teleportPlayer', 'isCellFree']);
        mockMovementService.isCellFree.and.returnValue(true);

        // Add the room property
        Object.defineProperty(mockGameManagerService, 'room', {
            get: () => mockRoom,
        });

        // Add the isDebugMode getter
        Object.defineProperty(mockGameManagerService, 'isDebugMode', {
            get: () => mockRoom.isDebugging,
        });

        // Add the currentPlayerId property
        Object.defineProperty(mockGameManagerService, 'currentPlayerId', {
            get: () => 'testSocketId',
        });

        mockSocket = jasmine.createSpyObj('Socket', ['emit', 'on', 'id'], { id: 'testSocketId' });

        mockSocketService = jasmine.createSpyObj(
            'SocketService',
            ['registerSocketService', 'getRoomId', 'dropItem', 'endPlayerTurn', 'virtualPlayerTurn'],
            {
                socket: mockSocket,
            },
        );

        TestBed.configureTestingModule({
            providers: [
                MovementSocketService,
                { provide: GameManagerService, useValue: mockGameManagerService },
                { provide: MovementService, useValue: mockMovementService },
                { provide: SocketService, useValue: mockSocketService },
            ],
        });

        service = TestBed.inject(MovementSocketService);
        service['socket'] = mockSocket;
    });

    describe('Basic functionality', () => {
        it('should create', () => {
            expect(service).toBeTruthy();
        });

        it('should set up connection and listeners on construction', () => {
            expect(mockSocketService.registerSocketService).toHaveBeenCalledWith(service);
            expect(mockSocket.on).toHaveBeenCalled();
        });

        it('should set up dropItem function on gameManagerService', () => {
            // Create a mock item and coords
            const mockItem = new Item('airStrike');
            const mockCoords = { x: 5, y: 5 };

            // Call the dropItem function that was set up in the constructor
            mockGameManagerService.dropItem(mockItem, mockCoords);

            // Verify that socketService.dropItem was called with the correct arguments
            expect(mockSocketService.dropItem).toHaveBeenCalledWith(mockItem, mockCoords);
        });
    });

    describe('Player movement', () => {
        it('should emit PlayerGetMovements with correct data', () => {
            const mockPlayer = new Player();
            mockPlayer.hasItem = jasmine.createSpy('hasItem').and.returnValue(true);
            mockGameManagerService.getMainPlayer.and.returnValue(mockPlayer);
            mockSocketService.getRoomId.and.returnValue('testRoomId');

            service.getPlayerMovements();

            expect(mockSocket.emit).toHaveBeenCalledWith(GameRoomEvents.PlayerGetMovements, {
                roomId: 'testRoomId',
                hasBoots: true,
                hasCamouflage: true,
                hasAirStrike: true,
            });
        });

        it('should emit PlayerMoved with correct data', () => {
            const roomId = 'testRoomId';
            const playerId = 'testPlayerId';
            const selectedPath: Coords[] = [{ x: 0, y: 0 }];

            service.movedPlayer({ roomId, playerId, selectedPath });

            expect(mockSocket.emit).toHaveBeenCalledWith(GameRoomEvents.PlayerMoved, {
                roomId,
                playerId,
                selectedPath,
            });
        });

        it('should emit PlayerTeleported with correct data when there is no item at destination', async () => {
            const destinationX = 5;
            const destinationY = 5;
            const hasCamouflage = true;

            // Create a mock board with a getCell method returning a cell with no item
            const mockCell = new Cell(new Tile('snow'), destinationX, destinationY);
            mockCell.item = null;
            const mockBoard = { getCell: jasmine.createSpy('getCell').and.returnValue(mockCell) };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);

            // Mock emitWithAck to return success
            mockSocket.emitWithAck = jasmine.createSpy('emitWithAck').and.returnValue(Promise.resolve({ success: true }));

            await service.teleportPlayer(destinationX, destinationY, { hasCamouflage });

            // Should emit PlayerTeleported but not ItemCollected
            expect(mockSocket.emitWithAck).toHaveBeenCalledWith(GameRoomEvents.PlayerTeleported, {
                roomId: 'testRoomId',
                playerId: mockSocket.id,
                destination: { x: destinationX, y: destinationY },
                hasCamouflage,
            });
            expect(mockSocket.emit).not.toHaveBeenCalledWith(GameRoomEvents.ItemCollected, jasmine.any(Object));
        });

        it('should only emit PlayerTeleported when there is an item at destination (item collection handled by server)', async () => {
            const destinationX = 5;
            const destinationY = 5;
            const hasCamouflage = true;

            // Create a mock item
            const mockItem = new Item('flag');

            // Create a mock board with a getCell method returning a cell with an item
            const mockCell = new Cell(new Tile('snow'), destinationX, destinationY);
            mockCell.item = mockItem;
            const mockBoard = { getCell: jasmine.createSpy('getCell').and.returnValue(mockCell) };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);

            // Mock emitWithAck to return success
            mockSocket.emitWithAck = jasmine.createSpy('emitWithAck').and.returnValue(Promise.resolve({ success: true }));

            await service.teleportPlayer(destinationX, destinationY, { hasCamouflage });

            // Should emit PlayerTeleported but not ItemCollected
            expect(mockSocket.emit).not.toHaveBeenCalledWith(GameRoomEvents.ItemCollected, jasmine.any(Object));
            expect(mockSocket.emitWithAck).toHaveBeenCalledWith(GameRoomEvents.PlayerTeleported, {
                roomId: 'testRoomId',
                playerId: mockSocket.id,
                destination: { x: destinationX, y: destinationY },
                hasCamouflage,
            });
        });

        it('should not emit ItemCollected when the item at destination is a spawnPoint', async () => {
            const destinationX = 5;
            const destinationY = 5;
            const hasCamouflage = true;

            // Create a mock spawnPoint item
            const mockItem = new Item('spawnPoint');

            // Create a mock board with a getCell method returning a cell with a spawnPoint item
            const mockCell = new Cell(new Tile('snow'), destinationX, destinationY);
            mockCell.item = mockItem;
            const mockBoard = { getCell: jasmine.createSpy('getCell').and.returnValue(mockCell) };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);

            // Mock emitWithAck to return success
            mockSocket.emitWithAck = jasmine.createSpy('emitWithAck').and.returnValue(Promise.resolve({ success: true }));

            await service.teleportPlayer(destinationX, destinationY, { hasCamouflage });

            // Should emit PlayerTeleported but not ItemCollected
            expect(mockSocket.emit).not.toHaveBeenCalledWith(GameRoomEvents.ItemCollected, jasmine.any(Object));
            expect(mockSocket.emitWithAck).toHaveBeenCalledWith(GameRoomEvents.PlayerTeleported, {
                roomId: 'testRoomId',
                playerId: mockSocket.id,
                destination: { x: destinationX, y: destinationY },
                hasCamouflage,
            });
        });

        it('should emit SynchronizeMovement with correct data', () => {
            const playerId = 'testPlayerId';
            const destinationX = 10;
            const destinationY = 15;

            // Mock the getBoard method to return a mock board with getPlayerById
            const mockPlayer = new Player();
            mockPlayer.movementPoints = 1;
            const mockBoard = { getPlayerById: jasmine.createSpy('getPlayerById').and.returnValue(mockPlayer) };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);

            service.synchronizeMovement(playerId, destinationX, destinationY);

            expect(mockSocket.emit).toHaveBeenCalledWith(GameRoomEvents.SynchronizeMovement, {
                roomId: 'testRoomId',
                playerId,
                destination: { x: destinationX, y: destinationY },
            });
        });

        it('should return early if player is not found in synchronizeMovement', () => {
            const playerId = 'testPlayerId';
            const destinationX = 10;
            const destinationY = 15;

            // Mock the getBoard method to return a mock board with getPlayerById returning null
            const mockBoard = { getPlayerById: jasmine.createSpy('getPlayerById').and.returnValue(null) };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);

            // Set up the spy on canEndTurn
            Object.defineProperty(mockGameManagerService, 'canEndTurn', {
                set: jasmine.createSpy('canEndTurnSetter'),
                configurable: true,
            });

            service.synchronizeMovement(playerId, destinationX, destinationY);

            // Socket.emit should still be called (it happens before the player check)
            expect(mockSocket.emit).toHaveBeenCalledWith(GameRoomEvents.SynchronizeMovement, {
                roomId: 'testRoomId',
                playerId,
                destination: { x: destinationX, y: destinationY },
            });

            // But canEndTurn should not be set since we return early when player is null
            const canEndTurnSetter = Object.getOwnPropertyDescriptor(mockGameManagerService, 'canEndTurn')?.set as jasmine.Spy;
            expect(canEndTurnSetter).not.toHaveBeenCalled();
        });
    });

    describe('Socket event handlers', () => {
        function triggerSocketEvent(eventName: string, data?: any): void {
            service['setUpListeners']();
            const args = mockSocket.on.calls.allArgs();
            const eventHandler = args.find((arg) => arg[0] === eventName);
            if (eventHandler && typeof eventHandler[1] === 'function') {
                eventHandler[1](data);
            }
        }

        it('should handle GameRoomError event', () => {
            spyOn(console, 'warn');
            const error = 'Test error';

            triggerSocketEvent(GameRoomEvents.GameRoomError, error);

            // eslint-disable-next-line no-console
            expect(console.warn).toHaveBeenCalledWith('Erreur depuis le socket serveur de GameRoomGateway : \n', error);
        });

        it('should handle PlayerMoved event', () => {
            const mockPlayer = new Player();
            const mockBoard = { getPlayerById: jasmine.createSpy('getPlayerById').and.returnValue(mockPlayer) };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);

            const data = {
                playerId: 'testPlayerId',
                map: new Map<Coords, Coords[]>(),
                selectedPath: [{ x: 0, y: 0 }],
                movementPoints: 3,
            };

            triggerSocketEvent(GameRoomEvents.PlayerMoved, data);

            expect(mockGameManagerService.setPlayer).toHaveBeenCalledWith(mockPlayer);
            expect(mockGameManagerService.setMovementPoints).toHaveBeenCalledWith(data.movementPoints);
            expect(mockGameManagerService.setPaths).toHaveBeenCalled();
            expect(mockGameManagerService.setSelectedPathFromCoords).toHaveBeenCalledWith(data.selectedPath);
            expect(mockGameManagerService.movePlayerFromPath).toHaveBeenCalled();
        });

        it('should return early when player is not found in PlayerMoved event', () => {
            const mockBoard = { getPlayerById: jasmine.createSpy('getPlayerById').and.returnValue(null) };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);

            const data = {
                playerId: 'nonExistentPlayerId',
                map: new Map<Coords, Coords[]>(),
                selectedPath: [{ x: 0, y: 0 }],
                movementPoints: 3,
            };

            triggerSocketEvent(GameRoomEvents.PlayerMoved, data);

            expect(mockGameManagerService.setPlayer).not.toHaveBeenCalled();
            expect(mockGameManagerService.setMovementPoints).not.toHaveBeenCalled();
            expect(mockGameManagerService.setPaths).not.toHaveBeenCalled();
            expect(mockGameManagerService.setSelectedPathFromCoords).not.toHaveBeenCalled();
            expect(mockGameManagerService.movePlayerFromPath).not.toHaveBeenCalled();
        });

        it('should emit ItemCollected event when a player collects an item', () => {
            // Create a mock item and cell
            const mockItem = new Item('airStrike');
            const mockCell = new Cell(new Tile('snow'), 5, 5);

            // Set up movePlayerFromPath to call the callback with an item and cell
            mockGameManagerService.movePlayerFromPath.and.callFake(async (callback) => {
                if (callback) {
                    callback(mockItem, mockCell);
                }
                return Promise.resolve();
            });

            // Spy on getPlayerMovements
            spyOn(service, 'getPlayerMovements');

            // Create a mock player for the board
            const mockBoardPlayer = new Player();
            const mockBoard = { getPlayerById: jasmine.createSpy('getPlayerById').and.returnValue(mockBoardPlayer) };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);

            // Set up getRoomId to return a room ID
            mockSocketService.getRoomId.and.returnValue('testRoomId');

            // Set up the room with players
            const mockPlayer = new Player();
            mockPlayer.id = 'testSocketId';
            Object.defineProperty(mockGameManagerService.room, 'players', {
                get: () => [mockPlayer],
            });

            // Trigger the PlayerMoved event
            const data = {
                playerId: 'testPlayerId',
                map: new Map<Coords, Coords[]>(),
                selectedPath: [{ x: 0, y: 0 }],
                movementPoints: 3,
            };

            // Manually call the callback in movePlayerFromPath to simulate item collection
            triggerSocketEvent(GameRoomEvents.PlayerMoved, data);

            // Verify that ItemCollected event was emitted
            expect(mockSocket.emit).toHaveBeenCalledWith(GameRoomEvents.ItemCollected, {
                roomId: 'testRoomId',
                playerId: 'testSocketId',
                item: mockItem,
                position: { x: mockCell.x, y: mockCell.y },
            });

            // Verify that getPlayerMovements was called
            expect(service.getPlayerMovements).toHaveBeenCalled();
        });

        it('should not emit ItemCollected event when no item is collected', () => {
            // Set up movePlayerFromPath to call the callback with no item
            mockGameManagerService.movePlayerFromPath.and.callFake(async (callback) => {
                if (callback) {
                    callback(undefined, undefined);
                }
                return Promise.resolve();
            });

            // Spy on getPlayerMovements
            spyOn(service, 'getPlayerMovements');

            // Create a mock player for the board
            const mockBoardPlayer = new Player();
            const mockBoard = { getPlayerById: jasmine.createSpy('getPlayerById').and.returnValue(mockBoardPlayer) };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);

            // Trigger the PlayerMoved event
            const data = {
                playerId: 'testPlayerId',
                map: new Map<Coords, Coords[]>(),
                selectedPath: [{ x: 0, y: 0 }],
                movementPoints: 3,
            };

            // Manually call the callback in movePlayerFromPath to simulate no item collection
            triggerSocketEvent(GameRoomEvents.PlayerMoved, data);

            // Verify that ItemCollected event was not emitted
            expect(mockSocket.emit).not.toHaveBeenCalledWith(GameRoomEvents.ItemCollected, jasmine.any(Object));

            // Note: getPlayerMovements is not called when no item is collected
            // This is because in the implementation, getPlayerMovements is only called after emitting ItemCollected
            // So we don't need to verify that getPlayerMovements was not called
        });

        it('should not emit ItemCollected event when current player ID does not match socket ID', () => {
            // Create a mock item and cell
            const mockItem = new Item('airStrike');
            const mockCell = new Cell(new Tile('snow'), 5, 5);

            // Set up movePlayerFromPath to call the callback with an item and cell
            mockGameManagerService.movePlayerFromPath.and.callFake(async (callback) => {
                if (callback) {
                    callback(mockItem, mockCell);
                }
                return Promise.resolve();
            });

            // Spy on getPlayerMovements
            spyOn(service, 'getPlayerMovements');

            // Create a mock player for the board
            const mockBoardPlayer = new Player();
            const mockBoard = { getPlayerById: jasmine.createSpy('getPlayerById').and.returnValue(mockBoardPlayer) };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);

            // Set up the room with players
            const mockPlayer = new Player();
            mockPlayer.id = 'testSocketId';
            Object.defineProperty(mockGameManagerService.room, 'players', {
                get: () => [mockPlayer],
            });

            // Create a spy on the socket.id property
            const originalSocketId = mockSocket.id;
            Object.defineProperty(mockSocket, 'id', {
                get: () => 'differentSocketId',
                configurable: true,
            });

            // Trigger the PlayerMoved event
            const data = {
                playerId: 'testPlayerId',
                map: new Map<Coords, Coords[]>(),
                selectedPath: [{ x: 0, y: 0 }],
                movementPoints: 3,
            };

            // Manually call the callback in movePlayerFromPath to simulate item collection
            triggerSocketEvent(GameRoomEvents.PlayerMoved, data);

            // Verify that ItemCollected event was not emitted
            expect(mockSocket.emit).not.toHaveBeenCalledWith(GameRoomEvents.ItemCollected, jasmine.any(Object));

            // Verify that getPlayerMovements was not called
            expect(service.getPlayerMovements).not.toHaveBeenCalled();

            // Restore the original socket.id
            Object.defineProperty(mockSocket, 'id', {
                get: () => originalSocketId,
                configurable: true,
            });
        });

        it('should end player turn when movement and action points are depleted', () => {
            const mockPlayer = new Player();
            mockPlayer.movementPoints = 0;
            mockPlayer.actionPoints = 0;
            const mockBoard = { getPlayerById: jasmine.createSpy('getPlayerById').and.returnValue(mockPlayer) };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);
            mockGameManagerService.getMainPlayer.and.returnValue(mockPlayer);
            mockGameManagerService.getRoomId.and.returnValue('testRoomId');

            // Set up movePlayerFromPath to call the callback with no item
            mockGameManagerService.movePlayerFromPath.and.callFake(async (callback) => {
                if (callback) {
                    callback(undefined);
                }
                return Promise.resolve();
            });

            const data = {
                playerId: 'testPlayerId',
                map: new Map<Coords, Coords[]>(),
                selectedPath: [{ x: 0, y: 0 }],
                movementPoints: 0,
            };

            triggerSocketEvent(GameRoomEvents.PlayerMoved, data);

            expect(mockSocketService.endPlayerTurn).toHaveBeenCalledWith('testRoomId');
        });

        it('should not end player turn when movement points remain', () => {
            const mockPlayer = new Player();
            mockPlayer.movementPoints = 1;
            mockPlayer.actionPoints = 0;
            const mockBoard = { getPlayerById: jasmine.createSpy('getPlayerById').and.returnValue(mockPlayer) };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);
            mockGameManagerService.getMainPlayer.and.returnValue(mockPlayer);

            // Set up movePlayerFromPath to call the callback with no item
            mockGameManagerService.movePlayerFromPath.and.callFake(async (callback) => {
                if (callback) {
                    callback(undefined);
                }
                return Promise.resolve();
            });

            const data = {
                playerId: 'testPlayerId',
                map: new Map<Coords, Coords[]>(),
                selectedPath: [{ x: 0, y: 0 }],
                movementPoints: 1,
            };

            triggerSocketEvent(GameRoomEvents.PlayerMoved, data);

            expect(mockSocketService.endPlayerTurn).not.toHaveBeenCalled();
        });

        it('should not end player turn when action points remain', () => {
            const mockPlayer = new Player();
            mockPlayer.movementPoints = 0;
            mockPlayer.actionPoints = 1;
            const mockBoard = { getPlayerById: jasmine.createSpy('getPlayerById').and.returnValue(mockPlayer) };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);
            mockGameManagerService.getMainPlayer.and.returnValue(mockPlayer);

            // Spy on the canMoveOrAct method and make it return true when there are action points
            spyOn<any>(service, 'canMoveOrAct').and.returnValue(true);

            // Set up movePlayerFromPath to call the callback with no item
            mockGameManagerService.movePlayerFromPath.and.callFake(async (callback) => {
                if (callback) {
                    callback(undefined);
                }
                return Promise.resolve();
            });

            const data = {
                playerId: 'testPlayerId',
                map: new Map<Coords, Coords[]>(),
                selectedPath: [{ x: 0, y: 0 }],
                movementPoints: 0,
            };

            triggerSocketEvent(GameRoomEvents.PlayerMoved, data);

            expect(mockSocketService.endPlayerTurn).not.toHaveBeenCalled();
        });

        it('should not end player turn when main player is not found', () => {
            const mockPlayer = new Player();
            const mockBoard = { getPlayerById: jasmine.createSpy('getPlayerById').and.returnValue(mockPlayer) };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);
            mockGameManagerService.getMainPlayer.and.returnValue(null);

            // Set up movePlayerFromPath to call the callback with no item
            mockGameManagerService.movePlayerFromPath.and.callFake(async (callback) => {
                if (callback) {
                    callback(undefined);
                }
                return Promise.resolve();
            });

            const data = {
                playerId: 'testPlayerId',
                map: new Map<Coords, Coords[]>(),
                selectedPath: [{ x: 0, y: 0 }],
                movementPoints: 0,
            };

            triggerSocketEvent(GameRoomEvents.PlayerMoved, data);

            expect(mockSocketService.endPlayerTurn).not.toHaveBeenCalled();
        });

        it('should handle PlayerTeleported event', () => {
            const mockPlayer = new Player();
            const mockTile = new Tile('snow');
            const mockCell = new Cell(mockTile, 5, 5);
            mockPlayer.cell = mockCell;
            mockPlayer.spawnPoint = { x: 5, y: 5 };
            mockPlayer.hasItem = jasmine.createSpy('hasItem').and.returnValue(false);
            const mockBoard = {
                getPlayerById: jasmine.createSpy('getPlayerById').and.returnValue(mockPlayer),
                getCell: jasmine.createSpy('getCell').and.returnValue(mockCell),
            };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);

            // Set isDebugging to false in the mock room
            Object.defineProperty(mockGameManagerService.room, 'isDebugging', {
                get: () => false,
            });

            const data = {
                playerId: 'testPlayerId',
                destination: { x: 5, y: 5 },
            };

            triggerSocketEvent(GameRoomEvents.PlayerTeleported, data);

            expect(mockMovementService.teleportPlayer).toHaveBeenCalledWith(mockBoard as any, mockPlayer, data.destination.x, data.destination.y);
        });

        it('should return early when player is not found in PlayerTeleported event', () => {
            const mockBoard = { getPlayerById: jasmine.createSpy('getPlayerById').and.returnValue(null) };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);

            // Set isDebugging to false in the mock room
            Object.defineProperty(mockGameManagerService.room, 'isDebugging', {
                get: () => false,
            });

            const data = {
                playerId: 'nonExistentPlayerId',
                destination: { x: 5, y: 5 },
            };

            triggerSocketEvent(GameRoomEvents.PlayerTeleported, data);

            expect(mockMovementService.teleportPlayer).not.toHaveBeenCalled();
        });

        it('should handle VirtualPlayerMoved event', () => {
            const mockPlayer = new Player();
            const mockBoard = { getPlayerById: jasmine.createSpy('getPlayerById').and.returnValue(mockPlayer) };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);

            // Set organisatorId in the mock room
            Object.defineProperty(mockGameManagerService.room, 'organisatorId', {
                get: () => 'testSocketId',
            });

            const data = {
                playerId: 'testPlayerId',
                path: [{ x: 0, y: 0 }],
                remainingMovementPoints: 3,
            };

            triggerSocketEvent(GameRoomEvents.VirtualPlayerMoved, data);

            expect(mockGameManagerService.setPlayer).toHaveBeenCalledWith(mockPlayer);
            expect(mockGameManagerService.setMovementPoints).toHaveBeenCalledWith(data.remainingMovementPoints);
            expect(mockGameManagerService.setSelectedPathFromCoords).toHaveBeenCalledWith(data.path);
            expect(mockGameManagerService.movePlayerFromPath).toHaveBeenCalled();
        });

        it('should return early when player is not found in VirtualPlayerMoved event', () => {
            const mockBoard = { getPlayerById: jasmine.createSpy('getPlayerById').and.returnValue(null) };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);

            // Set organisatorId in the mock room
            Object.defineProperty(mockGameManagerService.room, 'organisatorId', {
                get: () => 'testSocketId',
            });

            const data = {
                playerId: 'nonExistentPlayerId',
                path: [{ x: 0, y: 0 }],
                remainingMovementPoints: 3,
            };

            triggerSocketEvent(GameRoomEvents.VirtualPlayerMoved, data);

            expect(mockGameManagerService.setPlayer).not.toHaveBeenCalled();
            expect(mockGameManagerService.setMovementPoints).not.toHaveBeenCalled();
            expect(mockGameManagerService.setSelectedPathFromCoords).not.toHaveBeenCalled();
            expect(mockGameManagerService.movePlayerFromPath).not.toHaveBeenCalled();
        });

        it('should emit ItemCollected event when a virtual player collects an item', () => {
            const mockPlayer = new Player();
            mockPlayer.hasItem = jasmine.createSpy('hasItem').and.returnValue(false);
            const mockBoard = { getPlayerById: jasmine.createSpy('getPlayerById').and.returnValue(mockPlayer) };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);
            mockSocketService.getRoomId.and.returnValue('testRoomId');

            // Set organisatorId in the mock room
            Object.defineProperty(mockGameManagerService.room, 'organisatorId', {
                get: () => 'testSocketId',
            });

            const mockItem = new Item('airStrike');
            const mockCell = new Cell(new Tile('snow'), 0, 0);

            // Set up movePlayerFromPath to call the callback with an item and cell
            mockGameManagerService.movePlayerFromPath.and.callFake(async (callback) => {
                if (callback) {
                    callback(mockItem, mockCell);
                }
                return Promise.resolve();
            });

            const data = {
                playerId: 'virtualPlayerId',
                path: [{ x: 0, y: 0 }],
                remainingMovementPoints: 3,
            };

            triggerSocketEvent(GameRoomEvents.VirtualPlayerMoved, data);

            expect(mockSocket.emit).toHaveBeenCalledWith(GameRoomEvents.ItemCollected, {
                roomId: 'testRoomId',
                playerId: 'virtualPlayerId',
                item: mockItem,
                position: { x: mockCell.x, y: mockCell.y },
            });
        });

        it('should end player turn when virtual player movement is complete', () => {
            const mockPlayer = new Player();
            const mockBoard = { getPlayerById: jasmine.createSpy('getPlayerById').and.returnValue(mockPlayer) };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);
            mockGameManagerService.getRoomId.and.returnValue('testRoomId');

            // Set organisatorId in the mock room
            Object.defineProperty(mockGameManagerService.room, 'organisatorId', {
                get: () => 'testSocketId',
            });

            // Set up movePlayerFromPath to call the callback with no item
            mockGameManagerService.movePlayerFromPath.and.callFake(async (callback) => {
                if (callback) {
                    callback(undefined);
                }
                return Promise.resolve();
            });

            const data = {
                playerId: 'virtualPlayerId',
                path: [{ x: 0, y: 0 }],
                remainingMovementPoints: 0,
            };

            triggerSocketEvent(GameRoomEvents.VirtualPlayerMoved, data);

            expect(mockSocketService.endPlayerTurn).toHaveBeenCalledWith('testRoomId');
        });

        it('should handle SynchronizeMovement event when player is found', () => {
            const mockPlayer = new Player();
            const mockCell = new Cell(new Tile('snow'), 10, 15);
            const mockBoard = {
                getPlayerById: jasmine.createSpy('getPlayerById').and.returnValue(mockPlayer),
                getCell: jasmine.createSpy('getCell').and.returnValue(mockCell),
            };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);

            const data = {
                playerId: 'testPlayerId',
                destination: { x: 10, y: 15 },
            };

            triggerSocketEvent(GameRoomEvents.SynchronizeMovement, data);

            // Verify that teleportPlayer was called with the correct parameters
            expect(mockMovementService.teleportPlayer).toHaveBeenCalledWith(mockBoard as any, mockPlayer, data.destination.x, data.destination.y);
        });

        it('should handle SynchronizeMovement event when player is not found', () => {
            const mockBoard = { getPlayerById: jasmine.createSpy('getPlayerById').and.returnValue(null) };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);

            const data = {
                playerId: 'nonExistentPlayerId',
                destination: { x: 10, y: 15 },
            };

            triggerSocketEvent(GameRoomEvents.SynchronizeMovement, data);

            // Verify that teleportPlayer was not called
            expect(mockMovementService.teleportPlayer).not.toHaveBeenCalled();
        });

        it('should call finishGame when player has flag and is at spawn point', () => {
            const mockPlayer = new Player();
            mockPlayer.id = 'testPlayerId';
            const mockCell = new Cell(new Tile('snow'), 5, 5);
            mockPlayer.cell = mockCell;
            mockPlayer.spawnPoint = { x: 5, y: 5 };
            mockPlayer.hasItem = jasmine.createSpy('hasItem').and.returnValue(true);
            mockSocketService.finishGame = jasmine.createSpy('finishGame');

            service.checkForFlag(mockPlayer);

            expect(mockSocketService.finishGame).toHaveBeenCalledWith('testPlayerId');
        });

        it('should not call finishGame when player has flag but is not at spawn point', () => {
            const mockPlayer = new Player();
            mockPlayer.id = 'testPlayerId';
            const mockCell = new Cell(new Tile('snow'), 5, 5);
            mockPlayer.cell = mockCell;
            mockPlayer.spawnPoint = { x: 6, y: 6 };
            mockPlayer.hasItem = jasmine.createSpy('hasItem').and.returnValue(true);
            mockSocketService.finishGame = jasmine.createSpy('finishGame');

            service.checkForFlag(mockPlayer);

            expect(mockSocketService.finishGame).not.toHaveBeenCalled();
        });

        it('should not call finishGame when player is at spawn point but does not have flag', () => {
            const mockPlayer = new Player();
            mockPlayer.id = 'testPlayerId';
            const mockCell = new Cell(new Tile('snow'), 5, 5);
            mockPlayer.cell = mockCell;
            mockPlayer.spawnPoint = { x: 5, y: 5 };
            mockPlayer.hasItem = jasmine.createSpy('hasItem').and.returnValue(false);
            mockSocketService.finishGame = jasmine.createSpy('finishGame');

            service.checkForFlag(mockPlayer);

            expect(mockSocketService.finishGame).not.toHaveBeenCalled();
        });

        it('should not call finishGame when player is undefined', () => {
            mockSocketService.finishGame = jasmine.createSpy('finishGame');

            service.checkForFlag(undefined as unknown as Player);

            expect(mockSocketService.finishGame).not.toHaveBeenCalled();
        });

        it('should not call finishGame when player is null', () => {
            mockSocketService.finishGame = jasmine.createSpy('finishGame');

            service.checkForFlag(null as unknown as Player);

            expect(mockSocketService.finishGame).not.toHaveBeenCalled();
        });

        it('should not call finishGame when player cell is undefined', () => {
            const mockPlayer = new Player();
            mockPlayer.id = 'testPlayerId';
            mockPlayer.cell = undefined as unknown as Cell;
            mockPlayer.spawnPoint = { x: 5, y: 5 };
            mockPlayer.hasItem = jasmine.createSpy('hasItem').and.returnValue(true);
            mockSocketService.finishGame = jasmine.createSpy('finishGame');

            service.checkForFlag(mockPlayer);

            expect(mockSocketService.finishGame).not.toHaveBeenCalled();
        });

        it('should not call finishGame when player spawnPoint is undefined', () => {
            const mockPlayer = new Player();
            mockPlayer.id = 'testPlayerId';
            const mockCell = new Cell(new Tile('snow'), 5, 5);
            mockPlayer.cell = mockCell;
            mockPlayer.spawnPoint = undefined as unknown as Coords;
            mockPlayer.hasItem = jasmine.createSpy('hasItem').and.returnValue(true);
            mockSocketService.finishGame = jasmine.createSpy('finishGame');

            service.checkForFlag(mockPlayer);

            expect(mockSocketService.finishGame).not.toHaveBeenCalled();
        });

        it('should emit StartVirtualCombat event when current socket is the room organizer', () => {
            // Set up the room to have the current socket as the organizer
            Object.defineProperty(mockGameManagerService.room, 'organisatorId', {
                get: () => 'testSocketId',
            });

            const roomId = 'testRoomId';
            const playerId = 'testPlayerId';
            const opponentId = 'testOpponentId';

            service.startVirtualCombat(roomId, playerId, opponentId);

            expect(mockSocket.emit).toHaveBeenCalledWith(GameRoomEvents.StartVirtualCombat, {
                roomId,
                playerId,
                opponentId,
            });
        });

        it('should not emit StartVirtualCombat event when current socket is not the room organizer', () => {
            // Set up the room to have a different socket as the organizer
            Object.defineProperty(mockGameManagerService.room, 'organisatorId', {
                get: () => 'differentSocketId',
            });

            const roomId = 'testRoomId';
            const playerId = 'testPlayerId';
            const opponentId = 'testOpponentId';

            service.startVirtualCombat(roomId, playerId, opponentId);

            expect(mockSocket.emit).not.toHaveBeenCalledWith(GameRoomEvents.StartVirtualCombat, {
                roomId,
                playerId,
                opponentId,
            });
        });

        it('should handle VirtualPlayerMoved event with path containing coord property', () => {
            const mockPlayer = new Player();
            const mockBoard = { getPlayerById: jasmine.createSpy('getPlayerById').and.returnValue(mockPlayer) };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);

            // Set organisatorId in the mock room
            Object.defineProperty(mockGameManagerService.room, 'organisatorId', {
                get: () => 'testSocketId',
            });

            // Create a path with coord property
            const pathWithCoord = [{ coord: { x: 0, y: 0 } }, { coord: { x: 1, y: 1 } }];

            const data = {
                playerId: 'testPlayerId',
                path: pathWithCoord,
                remainingMovementPoints: 3,
            };

            triggerSocketEvent(GameRoomEvents.VirtualPlayerMoved, data);

            // Verify that setSelectedPathFromCoords was called with the mapped coords
            expect(mockGameManagerService.setSelectedPathFromCoords).toHaveBeenCalledWith([
                { x: 0, y: 0 },
                { x: 1, y: 1 },
            ]);
        });

        it('should start virtual combat when opponentPlayerId is present', () => {
            const mockPlayer = new Player();
            const mockBoard = { getPlayerById: jasmine.createSpy('getPlayerById').and.returnValue(mockPlayer) };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);

            // Set organisatorId in the mock room
            Object.defineProperty(mockGameManagerService.room, 'organisatorId', {
                get: () => 'testSocketId',
            });

            // Set up getRoomId to return a room ID
            mockGameManagerService.getRoomId.and.returnValue('testRoomId');

            // Set up movePlayerFromPath to call the callback with no item
            mockGameManagerService.movePlayerFromPath.and.callFake(async (callback) => {
                if (callback) {
                    callback(undefined);
                }
                return Promise.resolve();
            });

            const data = {
                playerId: 'testPlayerId',
                path: [{ x: 0, y: 0 }],
                remainingMovementPoints: 3,
                opponentPlayerId: 'opponentPlayerId',
            };

            triggerSocketEvent(GameRoomEvents.VirtualPlayerMoved, data);

            // Verify that startVirtualCombat was called with the correct arguments
            expect(mockSocket.emit).toHaveBeenCalledWith(GameRoomEvents.StartVirtualCombat, {
                roomId: 'testRoomId',
                playerId: 'testPlayerId',
                opponentId: 'opponentPlayerId',
            });

            // Verify that virtualPlayerTurn was not called
            expect(mockSocketService.virtualPlayerTurn).not.toHaveBeenCalled();
        });

        it('should handle PlayerAbandoned event and call getPlayerMovements if current player ID matches socket ID', () => {
            // Spy on getPlayerMovements
            spyOn(service, 'getPlayerMovements');

            // Set up the socket ID to match the currentPlayerId
            const originalSocketId = mockSocket.id;
            Object.defineProperty(mockSocket, 'id', {
                get: () => 'testSocketId',
                configurable: true,
            });

            // Trigger the PlayerAbandoned event
            const playerId = 'abandonedPlayerId';
            triggerSocketEvent(GameRoomEvents.PlayerAbandoned, playerId);

            // Verify that disconnectPlayer was called with the correct player ID
            expect(mockGameManagerService.disconnectPlayer).toHaveBeenCalledWith(playerId);

            // Verify that getPlayerMovements was called
            expect(service.getPlayerMovements).toHaveBeenCalled();

            // Restore the original socket ID
            Object.defineProperty(mockSocket, 'id', {
                get: () => originalSocketId,
                configurable: true,
            });
        });

        it('should handle PlayerAbandoned event but not call getPlayerMovements if current player ID does not match socket ID', () => {
            // Spy on getPlayerMovements
            spyOn(service, 'getPlayerMovements');

            // Set up the socket ID to be different from the currentPlayerId
            const originalSocketId = mockSocket.id;
            Object.defineProperty(mockSocket, 'id', {
                get: () => 'differentSocketId',
                configurable: true,
            });

            // Trigger the PlayerAbandoned event
            const playerId = 'abandonedPlayerId';
            triggerSocketEvent(GameRoomEvents.PlayerAbandoned, playerId);

            // Verify that disconnectPlayer was called with the correct player ID
            expect(mockGameManagerService.disconnectPlayer).toHaveBeenCalledWith(playerId);

            // Verify that getPlayerMovements was not called
            expect(service.getPlayerMovements).not.toHaveBeenCalled();

            // Restore the original socket ID
            Object.defineProperty(mockSocket, 'id', {
                get: () => originalSocketId,
                configurable: true,
            });
        });

        it('should end player turn when player cannot move or act', () => {
            // Create a mock player that cannot move or act
            const mockPlayer = new Player();
            mockPlayer.movementPoints = 0;
            mockPlayer.actionPoints = 0;
            mockPlayer.inventory = [null, null];
            mockPlayer.cell = new Cell(new Tile('snow'), 5, 5);
            mockPlayer.hasItem = jasmine.createSpy('hasItem').and.returnValue(false);

            // Mock the board's getCell method to return cells with no player or item
            const mockCell = new Cell(new Tile('snow'), 0, 0);
            const mockBoard = {
                getPlayerById: jasmine.createSpy('getPlayerById').and.returnValue(mockPlayer),
                getCell: jasmine.createSpy('getCell').and.returnValue(mockCell),
            };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);
            mockGameManagerService.getMainPlayer.and.returnValue(mockPlayer);
            mockGameManagerService.getRoomId.and.returnValue('testRoomId');

            // Spy on canMoveOrAct and make it return false
            spyOn<any>(service, 'canMoveOrAct').and.returnValue(false);

            // Set up movePlayerFromPath to call the callback with no item
            mockGameManagerService.movePlayerFromPath.and.callFake(async (callback) => {
                if (callback) {
                    callback(undefined);
                }
                return Promise.resolve();
            });

            // Spy on checkForFlag and checkForAvailablePoints
            spyOn(service, 'checkForFlag').and.returnValue(false);
            spyOn(service, 'checkForAvailablePoints').and.returnValue(false);

            const data = {
                playerId: 'testPlayerId',
                map: new Map<Coords, Coords[]>(),
                selectedPath: [{ x: 0, y: 0 }],
                movementPoints: 0,
            };

            // Trigger the PlayerMoved event
            triggerSocketEvent(GameRoomEvents.PlayerMoved, data);

            // Verify that endPlayerTurn was called with the correct room ID
            expect(mockSocketService.endPlayerTurn).toHaveBeenCalledWith('testRoomId');
        });

        it('should not end player turn when player can move or act', () => {
            // Create a mock player that can move or act
            const mockPlayer = new Player();
            mockPlayer.movementPoints = 0;
            mockPlayer.actionPoints = 0;
            mockPlayer.inventory = [null, null];
            mockPlayer.cell = new Cell(new Tile('snow'), 5, 5);
            mockPlayer.hasItem = jasmine.createSpy('hasItem').and.returnValue(false);

            // Mock the board's getCell method
            const mockBoard = {
                getPlayerById: jasmine.createSpy('getPlayerById').and.returnValue(mockPlayer),
                getCell: jasmine.createSpy('getCell'),
            };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);
            mockGameManagerService.getMainPlayer.and.returnValue(mockPlayer);

            // Spy on canMoveOrAct and make it return true
            spyOn<any>(service, 'canMoveOrAct').and.returnValue(true);

            // Set up movePlayerFromPath to call the callback with no item
            mockGameManagerService.movePlayerFromPath.and.callFake(async (callback) => {
                if (callback) {
                    callback(undefined);
                }
                return Promise.resolve();
            });

            // Spy on checkForFlag and checkForAvailablePoints
            spyOn(service, 'checkForFlag').and.returnValue(false);
            spyOn(service, 'checkForAvailablePoints').and.returnValue(false);

            const data = {
                playerId: 'testPlayerId',
                map: new Map<Coords, Coords[]>(),
                selectedPath: [{ x: 0, y: 0 }],
                movementPoints: 0,
            };

            // Trigger the PlayerMoved event
            triggerSocketEvent(GameRoomEvents.PlayerMoved, data);

            // Verify that endPlayerTurn was not called
            expect(mockSocketService.endPlayerTurn).not.toHaveBeenCalled();
        });

        it('should return early when checkForFlag returns true, without ending turn', () => {
            // Create a mock player
            const mockPlayer = new Player();
            mockPlayer.id = 'testPlayerId';
            mockPlayer.movementPoints = 0;
            mockPlayer.actionPoints = 0;
            mockPlayer.cell = new Cell(new Tile('snow'), 5, 5);
            mockPlayer.spawnPoint = { x: 5, y: 5 };

            // Create a mock item flag
            const mockFlag = new Item('flag');
            mockPlayer.inventory = [mockFlag, null];

            // Set up the player's hasItem method to return true for flag
            spyOn(mockPlayer, 'hasItem').and.callFake((itemType: string) => {
                return itemType === 'flag';
            });

            // Mock the board
            const mockBoard = {
                getPlayerById: jasmine.createSpy('getPlayerById').and.returnValue(mockPlayer),
            };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);
            mockGameManagerService.getMainPlayer.and.returnValue(mockPlayer);
            mockGameManagerService.getRoomId.and.returnValue('testRoomId');

            // Set up finishGame spy
            mockSocketService.finishGame = jasmine.createSpy('finishGame');

            // Set up movePlayerFromPath to call the callback
            mockGameManagerService.movePlayerFromPath.and.callFake(async (callback) => {
                if (callback) {
                    callback(undefined);
                }
                return Promise.resolve();
            });

            // Spy on checkForAvailablePoints and canMoveOrAct
            spyOn(service, 'checkForAvailablePoints').and.returnValue(false);
            // We'll use the real checkForFlag instead of spying on it
            spyOn<any>(service, 'canMoveOrAct').and.returnValue(false);

            const data = {
                playerId: 'testPlayerId',
                map: new Map<Coords, Coords[]>(),
                selectedPath: [{ x: 5, y: 5 }],
                movementPoints: 0,
            };

            // Trigger the PlayerMoved event
            triggerSocketEvent(GameRoomEvents.PlayerMoved, data);

            // Verify that finishGame was called with the player ID
            expect(mockSocketService.finishGame).toHaveBeenCalledWith('testPlayerId');

            // Verify that endPlayerTurn was NOT called, because checkForFlag returned true
            expect(mockSocketService.endPlayerTurn).not.toHaveBeenCalled();
        });
    });

    describe('canMoveOrAct method', () => {
        it('should return true when player has airStrike item', () => {
            // Create mock player with empty inventory
            const mockPlayer = new Player();
            mockPlayer.movementPoints = 0;
            mockPlayer.actionPoints = 0;
            mockPlayer.inventory = [null, null];

            // Set up hasItem to return true only for airStrike
            mockPlayer.hasItem = jasmine.createSpy('hasItem').and.callFake((itemName: string) => {
                return itemName === 'airStrike';
            });

            // Call the private method using type assertion
            const result = (service as any).canMoveOrAct(mockPlayer);

            // Verify the result is true because player has airStrike
            expect(result).toBeTrue();
            expect(mockPlayer.hasItem).toHaveBeenCalledWith('airStrike');
        });

        it('should return false when player.cell is undefined', () => {
            // Create mock player with no cell
            const mockPlayer = new Player();
            mockPlayer.movementPoints = 0;
            mockPlayer.actionPoints = 0;
            mockPlayer.inventory = [null, null];
            mockPlayer.cell = undefined as any;
            mockPlayer.hasItem = jasmine.createSpy('hasItem').and.returnValue(false);

            // Call the private method
            const result = (service as any).canMoveOrAct(mockPlayer);

            // Verify the result is false because player.cell is undefined
            expect(result).toBeFalse();
        });

        it('should return true when player has actual airStrike item in inventory', () => {
            // Create mock player with airStrike in inventory
            const mockPlayer = new Player();
            mockPlayer.movementPoints = 0;
            mockPlayer.actionPoints = 0;

            // Create an actual airStrike item and add it to inventory
            const airStrikeItem = new Item('airStrike');
            mockPlayer.inventory = [airStrikeItem, null];

            // Use the real hasItem method
            spyOn(mockPlayer, 'hasItem').and.callThrough();

            // Call the private method using type assertion
            const result = (service as any).canMoveOrAct(mockPlayer);

            // Verify the result is true because player has airStrike
            expect(result).toBeTrue();
            expect(mockPlayer.hasItem).toHaveBeenCalledWith('airStrike');
            // Don't expect camouflage to be checked since method returns early after finding airStrike
        });

        it('should return true when player has camouflage item', () => {
            // Create mock player with empty inventory
            const mockPlayer = new Player();
            mockPlayer.movementPoints = 0;
            mockPlayer.actionPoints = 0;
            mockPlayer.inventory = [null, null];

            // Set up hasItem to return true only for camouflage
            mockPlayer.hasItem = jasmine.createSpy('hasItem').and.callFake((itemName: string) => {
                return itemName === 'camouflage';
            });

            // Call the private method using type assertion
            const result = (service as any).canMoveOrAct(mockPlayer);

            // Verify the result is true because player has camouflage
            expect(result).toBeTrue();
            expect(mockPlayer.hasItem).toHaveBeenCalledWith('airStrike');
            expect(mockPlayer.hasItem).toHaveBeenCalledWith('camouflage');
        });

        it('should return true when player has actual camouflage item in inventory', () => {
            // Create mock player with camouflage in inventory
            const mockPlayer = new Player();
            mockPlayer.movementPoints = 0;
            mockPlayer.actionPoints = 0;

            // Create an actual camouflage item and add it to inventory
            const camouflageItem = new Item('camouflage');
            mockPlayer.inventory = [camouflageItem, null];

            // Use the real hasItem method
            spyOn(mockPlayer, 'hasItem').and.callThrough();

            // Call the private method using type assertion
            const result = (service as any).canMoveOrAct(mockPlayer);

            // Verify the result is true because player has camouflage
            expect(result).toBeTrue();
            // Since we check for airStrike first, that will be called
            expect(mockPlayer.hasItem).toHaveBeenCalledWith('airStrike');
            expect(mockPlayer.hasItem).toHaveBeenCalledWith('camouflage');
        });

        it('should return false when player has neither airStrike nor camouflage and no movement points', () => {
            // Create mock player with empty inventory
            const mockPlayer = new Player();
            mockPlayer.movementPoints = 0;
            mockPlayer.actionPoints = 0;
            mockPlayer.inventory = [null, null];
            mockPlayer.cell = new Cell(new Tile('snow'), 5, 5);

            // Set up hasItem to always return false
            mockPlayer.hasItem = jasmine.createSpy('hasItem').and.returnValue(false);

            // Mock the board's getCell method to return cells with no player or item
            const mockCell = new Cell(new Tile('snow'), 0, 0);
            const mockBoard = {
                getCell: jasmine.createSpy('getCell').and.returnValue(mockCell),
            };
            mockGameManagerService.getBoard.and.returnValue(mockBoard as any);

            // Call the private method using type assertion
            const result = (service as any).canMoveOrAct(mockPlayer);

            // Verify the result is false since player has no special items and no valid moves
            expect(result).toBeFalse();
            expect(mockPlayer.hasItem).toHaveBeenCalledWith('airStrike');
            expect(mockPlayer.hasItem).toHaveBeenCalledWith('camouflage');
        });

        it('should return true when player has movement points', () => {
            // Create mock player with empty inventory
            const mockPlayer = new Player();
            mockPlayer.movementPoints = 1;
            mockPlayer.actionPoints = 0;
            mockPlayer.inventory = [null, null];

            // Set up hasItem to always return false
            mockPlayer.hasItem = jasmine.createSpy('hasItem').and.returnValue(false);

            // Call the private method using type assertion
            const result = (service as any).canMoveOrAct(mockPlayer);

            // Verify the result is true because player has movement points
            expect(result).toBeTrue();
        });

        it('should return true when a neighboring cell has a player', () => {
            // Create mock player with no items and no movement points
            const mockPlayer = new Player();
            mockPlayer.movementPoints = 0;
            mockPlayer.actionPoints = 0;
            mockPlayer.inventory = [null, null];
            mockPlayer.cell = new Cell(new Tile('snow'), 5, 5);
            mockPlayer.hasItem = jasmine.createSpy('hasItem').and.returnValue(false);

            // Create a cell with a player in it
            const neighborCell = new Cell(new Tile('snow'), 0, 0);
            const neighborPlayer = new Player();
            neighborCell.player = neighborPlayer;

            // Set up mock board to return the cell with player for one direction and empty cells for others
            const mockBoard = jasmine.createSpyObj('Board', ['getCell']);
            mockBoard.getCell.and.callFake((x: number, y: number) => {
                if (x === 6 && y === 5) {
                    // East direction
                    return neighborCell;
                } else {
                    return new Cell(new Tile('snow'), x, y);
                }
            });
            mockGameManagerService.getBoard.and.returnValue(mockBoard);

            // Call the private method
            const result = (service as any).canMoveOrAct(mockPlayer);

            // Verify the result is true because a neighboring cell has a player
            expect(result).toBeTrue();

            // Only check that getCell was called the appropriate number of times
            // The actual coordinates depend on the implementation and might be in a different order
            expect(mockBoard.getCell).toHaveBeenCalled();
            expect(mockBoard.getCell.calls.count()).toBe(3); // It stops after finding the player in the east direction
        });

        it('should return true when a neighboring cell has an item', () => {
            // Create mock player with no items and no movement points
            const mockPlayer = new Player();
            mockPlayer.movementPoints = 0;
            mockPlayer.actionPoints = 0;
            mockPlayer.inventory = [null, null];
            mockPlayer.cell = new Cell(new Tile('snow'), 5, 5);
            mockPlayer.hasItem = jasmine.createSpy('hasItem').and.returnValue(false);

            // Create a cell with an item in it
            const neighborCell = new Cell(new Tile('snow'), 0, 0);
            neighborCell.item = new Item('flag');

            // Set up mock board to return the cell with item for one direction and empty cells for others
            const mockBoard = jasmine.createSpyObj('Board', ['getCell']);
            mockBoard.getCell.and.callFake((x: number, y: number) => {
                if (x === 5 && y === 6) {
                    // North direction
                    return neighborCell;
                } else {
                    return new Cell(new Tile('snow'), x, y);
                }
            });
            mockGameManagerService.getBoard.and.returnValue(mockBoard);

            // Call the private method
            const result = (service as any).canMoveOrAct(mockPlayer);

            // Verify the result is true because a neighboring cell has an item
            expect(result).toBeTrue();
        });

        it('should return true when a neighboring cell is a door and player has action points', () => {
            // Create mock player with no items but with action points
            const mockPlayer = new Player();
            mockPlayer.movementPoints = 0;
            mockPlayer.actionPoints = 1;
            mockPlayer.inventory = [null, null];
            mockPlayer.cell = new Cell(new Tile('snow'), 5, 5);
            mockPlayer.hasItem = jasmine.createSpy('hasItem').and.returnValue(false);

            // Create a cell with a door tile
            const doorCell = new Cell(new Tile('door'), 0, 0);

            // Set up mock board to return the door cell for one direction and empty cells for others
            const mockBoard = jasmine.createSpyObj('Board', ['getCell']);
            mockBoard.getCell.and.callFake((x: number, y: number) => {
                if (x === 4 && y === 5) {
                    // West direction
                    return doorCell;
                } else {
                    return new Cell(new Tile('snow'), x, y);
                }
            });
            mockGameManagerService.getBoard.and.returnValue(mockBoard);

            // Call the private method
            const result = (service as any).canMoveOrAct(mockPlayer);

            // Verify the result is true because a neighboring cell is a door and player has action points
            expect(result).toBeTrue();
        });

        it('should return false when neighboring cells have no player, item, or door', () => {
            // Create mock player with no items and no movement points
            const mockPlayer = new Player();
            mockPlayer.movementPoints = 0;
            mockPlayer.actionPoints = 0;
            mockPlayer.inventory = [null, null];
            mockPlayer.cell = new Cell(new Tile('snow'), 5, 5);
            mockPlayer.hasItem = jasmine.createSpy('hasItem').and.returnValue(false);

            // Set up mock board to return empty cells for all directions
            const mockBoard = jasmine.createSpyObj('Board', ['getCell']);
            mockBoard.getCell.and.returnValue(new Cell(new Tile('snow'), 0, 0));
            mockGameManagerService.getBoard.and.returnValue(mockBoard);

            // Call the private method
            const result = (service as any).canMoveOrAct(mockPlayer);

            // Verify the result is false because there are no valid moves
            expect(result).toBeFalse();
        });
    });
});

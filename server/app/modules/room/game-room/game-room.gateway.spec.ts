/* eslint-disable @typescript-eslint/no-empty-function */
/* eslint-disable max-lines */
/* eslint-disable @typescript-eslint/no-explicit-any */
import { Combat } from '@app/modules/combat/interfaces/combat';
import { GameCombatService } from '@app/modules/combat/services/game-combat.service';
import { GameMovementService } from '@app/modules/movement/services/game-movement.service';
import { MovementAlgorithmsService } from '@app/modules/movement/services/movement-algorithms.service';
import { GameRoomGateway } from '@app/modules/room/game-room/game-room.gateway';
import { GameRoomService } from '@app/modules/shared-room/services/game-room.service';
import { CombatHandler } from '@app/modules/room/game-room/handlers/combat.handler';
import { ItemsHandler } from '@app/modules/room/game-room/handlers/items.handler';
import { MovementHandler } from '@app/modules/room/game-room/handlers/movement.handler';
import { VirtualPlayerHandler } from '@app/modules/room/game-room/handlers/virtual-player.handler';
import { GameRoom } from '@app/modules/shared-room/interfaces/game-room';
import { Room } from '@app/modules/shared-room/interfaces/room';
import { GameMovementVPService } from '@app/modules/virtual-players/services/game-movement-vp.service';
import { ErrorMessages } from '@common/error-messages.constants';
import { GameRoomEvents } from '@common/socket.constants';
import { Logger } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { SinonStubbedInstance, createStubInstance, match, stub } from 'sinon';
import { BroadcastOperator, Server, Socket } from 'socket.io';

describe('GameRoomGateway', () => {
    let gateway: GameRoomGateway;
    let logger: SinonStubbedInstance<Logger>;
    let socket: SinonStubbedInstance<Socket>;
    let server: SinonStubbedInstance<Server>;
    let gameRoomService: SinonStubbedInstance<GameRoomService>;
    let gameCombatService: SinonStubbedInstance<GameCombatService>;
    let gameMovementService: SinonStubbedInstance<GameMovementService>;
    let gameMovementVPService: SinonStubbedInstance<GameMovementVPService>;
    let movementAlgorithmsService: SinonStubbedInstance<MovementAlgorithmsService>;
    let loggerSpy;

    beforeEach(async () => {
        logger = createStubInstance(Logger);
        socket = createStubInstance<Socket>(Socket);
        server = createStubInstance<Server>(Server);
        gameRoomService = createStubInstance<GameRoomService>(GameRoomService);
        gameCombatService = createStubInstance<GameCombatService>(GameCombatService);
        gameMovementService = createStubInstance<GameMovementService>(GameMovementService);
        gameMovementVPService = createStubInstance<GameMovementVPService>(GameMovementVPService);
        movementAlgorithmsService = createStubInstance<MovementAlgorithmsService>(MovementAlgorithmsService);

        gameMovementVPService.determineVPMovement.callsFake(() => ({
            path: [],
            remainingMovementPoints: 0,
        }));

        const module: TestingModule = await Test.createTestingModule({
            providers: [
                GameRoomGateway,
                MovementHandler,
                CombatHandler,
                ItemsHandler,
                VirtualPlayerHandler,
                {
                    provide: Logger,
                    useValue: logger,
                },
                {
                    provide: GameRoomService,
                    useValue: gameRoomService,
                },
                {
                    provide: GameCombatService,
                    useValue: gameCombatService,
                },
                {
                    provide: GameMovementService,
                    useValue: gameMovementService,
                },
                {
                    provide: GameMovementVPService,
                    useValue: gameMovementVPService,
                },
                {
                    provide: MovementAlgorithmsService,
                    useValue: movementAlgorithmsService,
                },
            ],
        }).compile();

        gateway = module.get<GameRoomGateway>(GameRoomGateway);
        // eslint-disable-next-line dot-notation
        gateway['server'] = server;

        loggerSpy = jest.spyOn(gateway['logger'], 'log');
    });

    it('should be defined', () => {
        expect(gateway).toBeDefined();
    });

    describe('handleLeaveRoom', () => {
        it('should call handlePlayerAbandonment and emit GameAbandoned', () => {
            const roomId = 'room123';
            const socketId = 'socket789';

            Object.defineProperty(socket, 'id', { value: socketId });
            socket.emit = stub();

            const handlePlayerAbandonmentSpy = jest.spyOn(gateway as any, 'handlePlayerAbandonment').mockReturnValue(true);

            gateway.handleLeaveRoom(roomId, socket);

            expect(handlePlayerAbandonmentSpy).toHaveBeenCalledWith(roomId, socketId);
            expect(socket.emit.calledWith(GameRoomEvents.GameAbandoned)).toBeTruthy();
        });

        it('should emit GameRoomError if an error occurs', () => {
            const roomId = 'room123';
            const socketId = 'socket789';
            const error = new Error('Test error');

            Object.defineProperty(socket, 'id', { value: socketId });
            socket.emit = stub();

            jest.spyOn(gateway as any, 'handlePlayerAbandonment').mockImplementation(() => {
                throw error;
            });

            gateway.handleLeaveRoom(roomId, socket);

            expect(socket.emit.calledWith(GameRoomEvents.GameRoomError, error.message)).toBeTruthy();
        });
    });

    it("should delete the room if there's only 2 players", () => {
        const roomId = 'room123';
        const socketId = 'socket789';

        Object.defineProperty(socket, 'id', { value: socketId });
        socket.join = stub();
        socket.emit = stub();

        server.to.returns({
            emit: (event: string) => {
                expect(event).toEqual(GameRoomEvents.GameCanceled);
            },
        } as BroadcastOperator<unknown, unknown>);

        // Simulate that abandoning the room deletes it.
        gameRoomService.abandonGame.returns(true);

        gateway.handleLeaveRoom(roomId, socket);

        expect(gameRoomService.abandonGame.calledWith(roomId, socketId)).toBeTruthy();
        expect(socket.emit.calledWith(GameRoomEvents.GameAbandoned)).toBeTruthy();
    });

    it("should quit the room if there's more than 2 players", () => {
        const roomId = 'room123';
        const socketId = 'socket789';

        Object.defineProperty(socket, 'id', { value: socketId });
        socket.join = stub();
        socket.emit = stub();

        server.to.returns({
            emit: (event: string) => {
                expect(event).toEqual(GameRoomEvents.PlayerAbandoned);
            },
        } as BroadcastOperator<unknown, unknown>);

        gameRoomService.abandonGame.returns(false);

        gateway.handleLeaveRoom(roomId, socket);

        expect(gameRoomService.abandonGame.calledWith(roomId, socketId)).toBeTruthy();
        expect(socket.emit.calledWith(GameRoomEvents.GameAbandoned)).toBeTruthy();
        expect(loggerSpy).toHaveBeenCalledWith(`${GameRoomEvents.AbandonGame} called by ${socketId}`);
    });

    it('should emit an error if one is encountered on handleLeaveRoom', () => {
        const roomId = 'room123';
        const socketId = 'socket789';
        const error = new Error('Erreur 1');

        Object.defineProperty(socket, 'id', { value: socketId });
        socket.join = stub();
        socket.emit = stub();

        gameRoomService.abandonGame.throws(error);

        gateway.handleLeaveRoom(roomId, socket);

        expect(socket.emit.calledWith(GameRoomEvents.GameRoomError, error.message)).toBeTruthy();
    });

    describe('handlePlayGame', () => {
        it('should start game and emit PlayerSpawned', async () => {
            const roomId = 'room123';
            const mockRoom = {
                roomId,
                gameId: 'game456',
                hostId: 'org1',
                players: [],
                isLocked: false,
                messages: [],
                journalEntries: [],
                playersStats: [],
                globalStats: { gameDuration: '00:00' },
                startTime: new Date(),
            } as GameRoom;

            gameRoomService.findRoomById.returns(mockRoom);
            gameMovementService.addPlayersToBoard.resolves(mockRoom.players);

            const emitStub = stub();
            server.to.returns({ emit: emitStub } as any);

            await gateway.handlePlayGame(roomId, socket);

            expect(gameRoomService.findRoomById.calledWith(roomId)).toBeTruthy();
            expect(gameMovementService.addPlayersToBoard.calledWith(mockRoom.gameId, mockRoom.players)).toBeTruthy();
            expect(emitStub.calledWith(GameRoomEvents.PlayerSpawned, mockRoom.players)).toBeTruthy();
            expect(gameRoomService.setServer.calledWith(server)).toBeTruthy();
            expect(gameRoomService.prepareNextTurn.calledWith(roomId)).toBeTruthy();
        });

        it('should emit GameRoomError if an error occurs', async () => {
            const roomId = 'room123';
            const error = new Error('Test error');

            gameRoomService.findRoomById.throws(error);
            socket.emit = stub();

            await gateway.handlePlayGame(roomId, socket);

            expect(socket.emit.calledWith(GameRoomEvents.GameRoomError, error.message)).toBeTruthy();
        });
    });

    it('should start game', () => {
        const roomId = 'room123';
        const gameId = 'game456';
        const host = { id: 'org1' };
        const socketId = 'socket789';
        const mockRoom = {
            id: roomId,
            gameId,
            hostId: host.id,
            roomId,
            players: [],
            isLocked: false,
            messages: [],
            journalEntries: [],
        };

        Object.defineProperty(socket, 'id', { value: socketId });
        socket.join = stub();
        socket.emit = stub();

        server.to.returns({
            emit: (event: string) => {
                expect(event).toEqual(GameRoomEvents.PlayerSpawned);
            },
        } as BroadcastOperator<unknown, unknown>);

        gameRoomService.findRoomById.returns(mockRoom);
        gameMovementService.addPlayersToBoard.returns(Promise.resolve(mockRoom.players));

        gateway.handlePlayGame(roomId, socket);

        expect(gameRoomService.abandonGame.calledWith(roomId, socketId));
        expect(gameRoomService.prepareNextTurn(roomId));
        expect(gameRoomService.setServer(server));
    });

    it('should handle connection', () => {
        Object.defineProperty(socket, 'id', { value: '1234' });
        gateway.handleConnection(socket);
        expect(loggerSpy).toHaveBeenCalledWith(`socket connecté: ${'1234'}`);
    });

    it('should delete game on disconnect if player quits when there is 2 players left in the game', () => {
        const roomId = 'room123';
        const gameId = 'game456';
        const host = { id: 'org1' };
        const socketId = 'socket789';
        const mockRoom = {
            id: roomId,
            gameId,
            hostId: host.id,
            roomId,
            players: [],
            isLocked: false,
            messages: [],
            journalEntries: [],
        };

        gameRoomService.findRoomsByPlayerId.returns([mockRoom]);
        gameRoomService.abandonGame.returns(true);
        gameRoomService.isHost.returns(true);
        gameRoomService.isPlayerTurn.returns(true);
        const emitSpy = jest.fn();
        const endTurnSpy = jest.spyOn(gameRoomService, 'endTurn');
        const changeHostSpy = jest.spyOn(gameRoomService, 'changeHost');

        server.to.returns({
            emit: emitSpy,
        } as unknown as BroadcastOperator<unknown, unknown>);

        Object.defineProperty(socket, 'id', { value: socketId });
        gateway.handleDisconnect(socket);

        expect(loggerSpy).toHaveBeenCalledWith(`socket déconnecté: ${socketId}`);
        expect(emitSpy).toHaveBeenCalledWith(GameRoomEvents.GameCanceled);
        expect(emitSpy).toHaveBeenCalledWith(GameRoomEvents.DebugModeDisabled);
        expect(changeHostSpy).toHaveBeenCalledWith(mockRoom.roomId);
        expect(endTurnSpy).toHaveBeenCalledWith(mockRoom.roomId);
    });

    it('should quit game on disconnect if player quits when there is more than 2 players left in the game', () => {
        const roomId = 'room123';
        const gameId = 'game456';
        const host = { id: 'org1' };
        const socketId = 'socket789';
        const mockRoom = {
            id: roomId,
            gameId,
            hostId: host.id,
            roomId,
            players: [],
            isLocked: false,
            messages: [],
            journalEntries: [],
        };

        Object.defineProperty(socket, 'id', { value: socketId });
        gameRoomService.findRoomsByPlayerId.returns([mockRoom]);
        gameRoomService.abandonGame.returns(false);

        server.to.returns({
            emit: (event: string) => {
                expect(event).toEqual(GameRoomEvents.PlayerAbandoned);
            },
        } as BroadcastOperator<unknown, unknown>);

        gateway.handleDisconnect(socket);

        expect(loggerSpy).toHaveBeenCalledWith(`socket déconnecté: ${socketId}`);
    });

    it('should emit an error if one is encountered on handleDisconnect', () => {
        const socketId = 'socket789';
        const error = new Error('Erreur 1');

        Object.defineProperty(socket, 'id', { value: socketId });
        gameRoomService.findRoomsByPlayerId.throws(error);

        gateway.handleDisconnect(socket);
        expect(loggerSpy).toHaveBeenCalledWith(`Error handling disconnect for ${socketId}: ${error.message}`);
    });

    it('should end each combat the player was in when handleLeaveRoom is called', () => {
        const socketId = 'socket123';
        const roomId = 'roomId456';

        Object.defineProperty(socket, 'id', { value: socketId });
        const combatRooms: Combat[] = [{ combatRoomId: 'combatRoom1' } as Combat, { combatRoomId: 'combatRoom2' } as Combat];
        gameCombatService.findCombatsByPlayerId.returns(combatRooms);

        gameRoomService.abandonGame.returns(false);

        gateway.handleLeaveRoom(roomId, socket);

        combatRooms.forEach((combat) => {
            expect(gameCombatService.endCombat.calledWith(combat.combatRoomId, false)).toBeTruthy();
            expect(loggerSpy).toHaveBeenCalledWith(`${GameRoomEvents.AbandonGame} called by ${socketId}`);
        });
    });

    describe('handleFinishGame', () => {
        const roomId = 'room123';
        const winnerId = 'winner1';

        it('should emit FinishGame, have all sockets leave, delete the room, and log success', () => {
            const data = { roomId, winnerId };
            const timeToDelete = 342000;
            Object.defineProperty(socket, 'id', { value: 'socket123' });
            const mockRoom = { startTime: new Date(Date.now() - timeToDelete), globalStats: { gameDuration: '' } } as GameRoom;
            gameRoomService.findRoomById.returns(mockRoom);

            server.to.returns({
                emit: (event: string) => {
                    expect(event).toEqual(GameRoomEvents.FinishGame);
                },
            } as BroadcastOperator<unknown, unknown>);

            gateway.handleFinishGame(data, socket);
            expect(gameRoomService.findRoomById.calledWith(roomId)).toBeTruthy();
            expect(mockRoom.globalStats.gameDuration).toEqual('05:42');
        });

        it('should emit GameRoomError if an error occurs', () => {
            const data = { roomId, winnerId };
            Object.defineProperty(socket, 'id', { value: 'socket123' });

            const error = new Error('Test error');
            gameRoomService.findRoomById.throws(error);

            socket.emit = stub();

            gateway.handleFinishGame(data, socket);

            expect(socket.emit.calledWith(GameRoomEvents.GameRoomError, error.message)).toBeTruthy();
        });
    });

    describe('handleLeaveEndGame', () => {
        const roomId = 'room123';

        it('should handle players leaving the end game screen', async () => {
            Object.defineProperty(socket, 'id', { value: 'socket123' });

            const emitStub = stub();
            server.to.returns({ emit: emitStub } as any);

            const fakeSocket2 = { leave: stub() };
            let fetchSocketsStub = stub().resolves([socket, fakeSocket2]);
            server.in.returns({ fetchSockets: fetchSocketsStub } as any);

            gameRoomService.deleteRoomById = stub();

            gateway.handleLeaveEndGame(roomId, socket);

            expect(socket.leave.calledWith(roomId)).toBeTruthy();
            expect(fetchSocketsStub.called).toBeTruthy();

            fetchSocketsStub = stub().resolves([]);
            server.in.returns({ fetchSockets: fetchSocketsStub } as any);

            gateway.handleLeaveEndGame(roomId, socket);
        });

        it('should emit GameRoomError if an error occurs', () => {
            Object.defineProperty(socket, 'id', { value: 'socket123' });

            const error = new Error('Test error');
            server.in.throws(error);

            socket.emit = stub();

            gateway.handleLeaveEndGame(roomId, socket);

            expect(socket.emit.calledWith(GameRoomEvents.GameRoomError, error.message)).toBeTruthy();
        });
    });

    it('should emit GameRoomError if an error occurs in handlePlayGame', async () => {
        const roomId = 'testRoomId';
        const error = new Error('Test error');

        gameRoomService.findRoomById.throws(error);

        await gateway.handlePlayGame(roomId, socket);

        expect(socket.emit.calledWith(GameRoomEvents.GameRoomError, error.message)).toBeTruthy();
    });

    it('should return paths via ACK on success', async () => {
        const roomId = 'roomId123';
        const socketId = 'socketXYZ';
        Object.defineProperty(socket, 'id', { value: socketId });

        const mockPlayer = { id: socketId, hasBoots: false };
        const mockRoom = { players: [mockPlayer, { id: 'p2' }] } as Room;
        gameRoomService.findRoomById.returns(mockRoom);

        const mockPaths = new Map();
        mockPaths.set({ x: 1, y: 1 }, [
            { x: 1, y: 1 },
            { x: 1, y: 2 },
        ]);
        gameMovementService.getAllPaths.returns(mockPaths);

        const result = await gateway.handlePlayerGetMovements({ roomId, hasBoots: false }, socket);

        // Verify ACK response
        expect(result.success).toBe(true);
        expect(result.paths).toEqual(Array.from(mockPaths.entries()));
        expect(result.error).toBeUndefined();

        expect(gameRoomService.findRoomById.calledWith(roomId)).toBeTruthy();
        expect(gameMovementService.getAllPaths.calledWith(socketId, mockRoom.players)).toBeTruthy();
    });

    it('should return error ACK if player not found', async () => {
        const roomId = 'roomId123';
        const socketId = 'socketXYZ';
        Object.defineProperty(socket, 'id', { value: socketId });

        const mockRoom = { players: [{ id: 'otherPlayer' }] } as Room;
        gameRoomService.findRoomById.returns(mockRoom);

        const result = await gateway.handlePlayerGetMovements({ roomId, hasBoots: false }, socket);

        // Verify ACK response
        expect(result.success).toBe(false);
        expect(result.error).toBe(ErrorMessages.PlayerNotFound);
        expect(result.paths).toBeUndefined();
    });

    it('should return error ACK if an error occurs', async () => {
        const roomId = 'roomId123';
        const socketId = 'socketXYZ';
        Object.defineProperty(socket, 'id', { value: socketId });

        const error = new Error('Test error');
        gameRoomService.findRoomById.throws(error);

        const result = await gateway.handlePlayerGetMovements({ roomId, hasBoots: false }, socket);

        // Verify ACK response
        expect(result.success).toBe(false);
        expect(result.error).toBe(error.message);
    });

    describe('handlePlayerMoved', () => {
        const roomId = 'room123';
        const playerId = 'player123';
        const selectedPath = [
            { x: 1, y: 1 },
            { x: 2, y: 2 },
        ];
        const serializedMap = new Map(); // For simplicity, an empty map
        const data = { roomId, playerId, serializedMap, selectedPath };

        it('should return success ACK and emit PlayerMoved when validation passes', async () => {
            const fakeRoom = {
                players: [
                    { id: 'player123', name: 'Player 123' },
                    { id: 'player456', name: 'Player 456' },
                ],
                roomId,
                playersStats: [
                    { name: 'Player 123', tilesVisited: [{ x: 1, y: 1 }] },
                    { name: 'Player 456', tilesVisited: [] },
                ],
            } as any;
            gameRoomService.findRoomById.returns(fakeRoom);

            // Mock validation to succeed
            gameMovementService.validatePath.returns({ isValid: true, cost: 2 });

            const expectedMovementPoints = 3;
            gameMovementService.movePlayer.returns(expectedMovementPoints);

            const emitStub = stub();
            server.to.returns({ emit: emitStub } as any);

            const result = await gateway.handlePlayerMoved(data);

            // Verify ACK response
            expect(result.success).toBe(true);
            expect(result.movementPoints).toBe(expectedMovementPoints);
            expect(result.error).toBeUndefined();

            // Verify validation was called
            expect(gameMovementService.validatePath.calledWith(playerId, selectedPath, fakeRoom.players)).toBeTruthy();

            // Verify movement was executed
            expect(gameMovementService.movePlayer.calledWith(playerId, fakeRoom.players, selectedPath[selectedPath.length - 1])).toBeTruthy();

            // Verify broadcast
            expect(emitStub.calledWith(GameRoomEvents.PlayerMoved, { ...data, movementPoints: expectedMovementPoints })).toBeTruthy();
        });

        it('should return error ACK when path validation fails', async () => {
            const fakeRoom = {
                players: [{ id: 'player123', name: 'Player 123' }],
                roomId,
                playersStats: [{ name: 'Player 123', tilesVisited: [] }],
            } as any;
            gameRoomService.findRoomById.returns(fakeRoom);

            // Mock validation to fail
            const validationError = 'Le chemin doit commencer à la position actuelle du joueur.';
            gameMovementService.validatePath.returns({ isValid: false, error: validationError });

            const result = await gateway.handlePlayerMoved(data);

            // Verify ACK response
            expect(result.success).toBe(false);
            expect(result.error).toBe(validationError);
            expect(result.movementPoints).toBeUndefined();
            // Verify movePlayer was NOT called
            expect(gameMovementService.movePlayer.called).toBeFalsy();
        });

        it('should return error ACK on service exception', async () => {
            const error = new Error('Service error');
            gameRoomService.findRoomById.throws(error);

            const result = await gateway.handlePlayerMoved(data);

            // Verify ACK response
            expect(result.success).toBe(false);
            expect(result.error).toBe(error.message);
        });

        it('should return error ACK when player is not found in room', async () => {
            const fakeRoom = {
                players: [{ id: 'otherPlayer123', name: 'Other Player' }], // Different ID
                roomId,
                playersStats: [],
            } as any;
            gameRoomService.findRoomById.returns(fakeRoom);

            const result = await gateway.handlePlayerMoved(data);

            // Verify ACK response
            expect(result.success).toBe(false);
            expect(result.error).toBe(ErrorMessages.PlayerNotFound);

            // Verify validatePath was NOT called since player check happens first
            expect(gameMovementService.validatePath.called).toBeFalsy();
        });
    });

    describe('handlePlayerTeleported', () => {
        const roomId = 'room123';
        const playerId = 'player123';
        const destination = { x: 2, y: 2 };
        const data = { roomId, playerId, destination };

        it('should emit PlayerTeleported and not call movePlayer if room is not debugging', async () => {
            const fakeRoom = { isDebugging: false, players: [{ id: playerId }], gameId: 'game1' } as any;
            gameRoomService.findRoomById.returns(fakeRoom);

            const emitStub = stub();
            server.to.returns({ emit: emitStub } as any);

            const movePlayerSpy = jest.spyOn(gameMovementService, 'movePlayer');

            await gateway.handlePlayerTeleported(data);

            expect(movePlayerSpy).toHaveBeenCalled();
            expect(emitStub.calledWith(GameRoomEvents.PlayerTeleported, data)).toBeTruthy();
        });

        it('should call movePlayer and then emit PlayerTeleported if room is debugging', async () => {
            const fakeRoom = { isDebugging: true, players: [{ id: playerId }], gameId: 'game1' } as any;
            gameRoomService.findRoomById.returns(fakeRoom);

            const emitStub = stub();
            server.to.returns({ emit: emitStub } as any);

            const movePlayerSpy = jest.spyOn(gameMovementService, 'movePlayer').mockReturnValue(undefined);

            await gateway.handlePlayerTeleported(data);

            expect(movePlayerSpy).toHaveBeenCalledWith(data.playerId, fakeRoom.players, destination, fakeRoom.isDebugging);
            expect(emitStub.calledWith(GameRoomEvents.PlayerTeleported, data)).toBeTruthy();
        });

        it('should emit GameRoomError if an error occurs', async () => {
            const error = new Error('Test error');
            gameRoomService.findRoomById.throws(error);

            socket.emit = stub();

            await gateway.handlePlayerTeleported(data);

            expect(socket.emit.calledWith(GameRoomEvents.GameRoomError, error.message)).toBeTruthy();
        });

        it('should call movePlayer if room is in debug mode and then emit PlayerTeleported', async () => {
            const fakeRoom = {
                isDebugging: true,
                players: [{ id: 'player1' }, { id: 'player2' }],
                gameId: 'game1',
            } as any;

            gameRoomService.findRoomById.returns(fakeRoom);

            const movePlayerSpy = jest.spyOn(gameMovementService, 'movePlayer').mockReturnValue(undefined);

            const emitMock = jest.fn();
            const toMock = jest.fn().mockReturnValue({ emit: emitMock });
            gateway['server'] = { to: toMock } as any;

            await gateway.handlePlayerTeleported(data);

            expect(movePlayerSpy).toHaveBeenCalledWith(data.playerId, fakeRoom.players, data.destination, true);

            expect(toMock).toHaveBeenCalledWith(data.roomId);
            expect(emitMock).toHaveBeenCalledWith(GameRoomEvents.PlayerTeleported, data);
        });
    });

    describe('handleStartFight', () => {
        const data = { roomId: 'room1', opponentId: 'opp1' };

        it('should start combat successfully when room is found', () => {
            const combatStarter = { id: 'socket123', name: 'Player1' };
            const opponent = { id: data.opponentId, name: 'Player2' };
            const fakeRoom = {
                players: [combatStarter, opponent],
                roomId: data.roomId,
                playersStats: [{ name: 'Player1', combats: 0 } as any, { name: 'Player2', combats: 1 } as any],
            } as any;
            const findRoomSpy = jest.spyOn(gameRoomService, 'findRoomById');

            findRoomSpy.mockReturnValue(fakeRoom);
            const setServerSpy = jest.spyOn(gameCombatService, 'setServer').mockImplementation(() => {});
            const pauseTimerSpy = jest.spyOn(gameRoomService, 'pauseTimer').mockImplementation(() => {});

            const opponentSocket = { join: jest.fn() } as unknown as Socket;

            gateway['server'] = {
                sockets: {
                    sockets: new Map([[data.opponentId, opponentSocket]]),
                },
                to: jest.fn().mockReturnValue({ emit: jest.fn() }),
            } as unknown as Server;

            Object.defineProperty(socket, 'id', { value: 'socket123' });
            const socketJoinSpy = jest.spyOn(socket, 'join').mockImplementation(() => {});
            const startCombatSpy = jest.spyOn(gameCombatService, 'startCombat').mockImplementation(() => {});

            gateway.handleStartFight(data, socket);

            expect(setServerSpy).toHaveBeenCalledWith(gateway['server']);
            expect(pauseTimerSpy).toHaveBeenCalledWith(data.roomId);
            expect(findRoomSpy).toHaveBeenCalledWith(data.roomId);

            const combatRoom = `combat_${data.roomId}`;
            expect(socketJoinSpy).toHaveBeenCalledWith(combatRoom);
            expect(opponentSocket.join).toHaveBeenCalledWith(combatRoom);
            expect(startCombatSpy).toHaveBeenCalledWith(data.roomId, combatRoom, [combatStarter, opponent], socket.id, data.opponentId);

            setServerSpy.mockRestore();
            pauseTimerSpy.mockRestore();
            socketJoinSpy.mockRestore();
            startCombatSpy.mockRestore();
        });

        it('should start combat successfully when opponent is virtual player', () => {
            const combatStarter = { id: 'socket123', name: 'Player1' };
            const opponent = { id: data.opponentId, name: 'Player2', isVirtual: true };
            const fakeRoom = {
                players: [combatStarter, opponent],
                roomId: data.roomId,
                playersStats: [{ name: 'Player1', combats: 0 } as any, { name: 'Player2', combats: 1 } as any],
            } as any;
            const findRoomSpy = jest.spyOn(gameRoomService, 'findRoomById');

            findRoomSpy.mockReturnValue(fakeRoom);
            const setServerSpy = jest.spyOn(gameCombatService, 'setServer').mockImplementation(() => {});
            const pauseTimerSpy = jest.spyOn(gameRoomService, 'pauseTimer').mockImplementation(() => {});

            const opponentSocket = { join: jest.fn() } as unknown as Socket;

            gateway['server'] = {
                sockets: {
                    sockets: new Map([[data.opponentId, opponentSocket]]),
                },
                to: jest.fn().mockReturnValue({ emit: jest.fn() }),
            } as unknown as Server;

            Object.defineProperty(socket, 'id', { value: 'socket123' });
            const startVirtualCombatSpy = jest.spyOn(gameCombatService, 'startVirtualCombat').mockImplementation(() => {});

            gateway.handleStartFight(data, socket);

            expect(setServerSpy).toHaveBeenCalledWith(gateway['server']);
            expect(findRoomSpy).toHaveBeenCalledWith(data.roomId);
            expect(startVirtualCombatSpy).toHaveBeenCalledWith(data.roomId, data.opponentId, socket.id, false);

            setServerSpy.mockRestore();
            pauseTimerSpy.mockRestore();
            startVirtualCombatSpy.mockRestore();
        });

        it('should emit GameRoomError with "Room not found" when findRoomById returns null', () => {
            const room = { roomId: 'nonExistentRoom', opponentId: 'opponent123' };

            gameRoomService.findRoomById.returns(null);
            gateway['server'] = {
                sockets: {
                    sockets: new Map(),
                },
                to: stub().returns({ emit: stub() }),
            } as any;

            Object.defineProperty(socket, 'id', { value: 'socket123' });
            socket.emit = stub();

            gateway.handleStartFight(room, socket);

            expect(socket.emit.calledWith(GameRoomEvents.GameRoomError, ErrorMessages.RoomDoesNotExist)).toBeTruthy();
        });
    });

    describe('handleSendMessage', () => {
        it('should add message and emit to other players', async () => {
            const data = { message: 'test message', playerName: 'Player1', roomId: 'room123' };
            const socketId = 'socket123';

            Object.defineProperty(socket, 'id', { value: socketId });

            const emitStub = stub();
            (server.except as any) = stub().returns({ to: stub().returns({ emit: emitStub }) });

            await gateway.handleSendMessage(data, socket);

            expect(gameRoomService.addMessage.calledWith(data.roomId)).toBeTruthy();
            expect(server.except.calledWith(socketId)).toBeTruthy();
        });

        it('should emit GameRoomError if an error occurs', async () => {
            const data = { message: 'test message', playerName: 'Player1', roomId: 'room123' };
            const error = new Error('Test error');

            gameRoomService.addMessage.throws(error);
            socket.emit = stub();

            await gateway.handleSendMessage(data, socket);

            expect(socket.emit.calledWith(GameRoomEvents.GameRoomError, error.message)).toBeTruthy();
        });
    });

    it('should send a message to the gameRoom', () => {
        const socketId = 'socket789';
        const roomId = 'room123';
        const mockRoom = {
            isDebugging: true,
            players: [{ id: 'player1' }, { id: 'player2' }],
            gameId: 'game1',
            messages: [],
        } as any;

        gameRoomService.findRoomById.returns(mockRoom);
        Object.defineProperty(socket, 'id', { value: socketId });

        socket.emit = stub();
        const emitStub = stub();
        server.to = stub();
        const toStub = stub().returns({ emit: emitStub } as any);
        server.to.returns({ emit: emitStub } as any);
        server.except = stub();
        server.except.returns({ to: toStub } as any);

        const message = { message: 'message1', playerName: 'player1', roomId };
        gateway.handleSendMessage(message, socket);
        expect(gameRoomService.addMessage.calledOnce).toBeTruthy();
        expect(server.except.calledWith(socketId)).toBeTruthy();
    });

    it('should emit an error if one is encountered on handleSendMessage', () => {
        const roomId = 'room123';
        const socketId = 'socket789';
        const error = new Error('Erreur 1');

        Object.defineProperty(socket, 'id', { value: socketId });
        socket.emit = stub();

        gameRoomService.addMessage.throws(error);

        const message = { message: 'message1', playerName: 'player1', roomId };
        gateway.handleSendMessage(message, socket);

        expect(socket.emit.calledWith(GameRoomEvents.GameRoomError, error.message)).toBeTruthy();
    });

    it('should add journal entry', () => {
        const socketId = 'socket789';
        const mockRoom = {
            isDebugging: true,
            players: [{ id: 'player1' }, { id: 'player2' }],
            gameId: 'game1',
            messages: [],
        } as any;

        gameRoomService.findRoomById.returns(mockRoom);
        Object.defineProperty(socket, 'id', { value: socketId });

        const emitStub = stub();
        server.to = stub();
        server.to.returns({ emit: emitStub } as any);
    });

    it('should emit an error if one is encountered on handleAddJournalEntry', () => {
        const socketId = 'socket789';
        const error = new Error('Erreur 1');

        Object.defineProperty(socket, 'id', { value: socketId });
        socket.emit = stub();

        gameRoomService.addJournalEntry.throws(error);
    });

    it('should be able to get the statistics', () => {
        const playerStat1 = { name: 'Player1', prop1: 'prop1' };
        const playerStat2 = { name: 'Player2', prop2: 'prop2' };
        const socketId = 'socket789';
        const roomId = 'room123';
        const mockRoom = {
            isDebugging: true,
            players: [{ id: 'player1' }, { id: 'player2' }],
            gameId: 'game1',
            messages: [],
            playersStats: [playerStat1, playerStat2],
            globalStats: { gameDuration: '00:00' },
        } as any;

        socket.emit = stub();
        gameRoomService.findRoomById.returns(mockRoom);
        Object.defineProperty(socket, 'id', { value: socketId });

        server.to = stub();

        gateway.handleGetStatistics(roomId, socket);

        expect(
            socket.emit.calledWithMatch(
                GameRoomEvents.GetStatisticsResponse,
                match({
                    playerStats: mockRoom.playersStats,
                    globalStats: mockRoom.globalStats,
                }),
            ),
        ).toBeTruthy();
    });

    it('should emit an error if one is encountered on handleGetStatistics', () => {
        const roomId = 'room123';
        const socketId = 'socket789';
        const error = new Error('Erreur 1');

        Object.defineProperty(socket, 'id', { value: socketId });
        socket.emit = stub();

        gameRoomService.findRoomById.throws(error);

        gateway.handleGetStatistics(roomId, socket);

        expect(socket.emit.calledWith(GameRoomEvents.GameRoomError, error.message)).toBeTruthy();
    });

    describe('handleAttack', () => {
        const data = { roomId: 'room1' };

        it('should call gameCombatService.attack with correct parameters and log the attack attempt', async () => {
            const logSpy = jest.spyOn(gateway['logger'], 'log').mockImplementation(() => {});
            const attackSpy = jest.spyOn(gameCombatService, 'attack').mockResolvedValue();

            await gateway.handleAttack(data, socket);

            expect(logSpy).toHaveBeenCalledWith(`[${data.roomId}] Attack attempt`);
            expect(attackSpy).toHaveBeenCalledWith(data.roomId);
        });

        it('should emit GameRoomError if an error occurs in handleAttack', async () => {
            const error = new Error('Test error');
            jest.spyOn(gameCombatService, 'attack').mockRejectedValue(error);
            (socket as any).emit = jest.fn();

            await gateway.handleAttack(data, socket);

            expect(socket.emit).toHaveBeenCalledWith(GameRoomEvents.GameRoomError, error.message);
        });
    });

    describe('handleFlightAttempt', () => {
        const roomId = 'testRoom';

        it('should log "received flight attempt" and call gameCombatService.attemptFlight', async () => {
            const attemptFlightSpy = jest.spyOn(gameCombatService, 'attemptFlight').mockResolvedValue();

            await gateway.handleFlightAttempt(roomId, socket);

            expect(attemptFlightSpy).toHaveBeenCalledWith(roomId);
        });

        it('should emit GameRoomError if an error occurs in handleFlightAttempt', async () => {
            const error = new Error('Test error');
            jest.spyOn(gameCombatService, 'attemptFlight').mockRejectedValue(error);
            (socket as any).emit = jest.fn();

            await gateway.handleFlightAttempt(roomId, socket);

            expect((socket as any).emit).toHaveBeenCalledWith(GameRoomEvents.GameRoomError, error.message);
        });
    });

    describe('handleToggleDebugMode', () => {
        const roomId = 'room123';
        const error = new Error('Test error');

        beforeEach(() => {
            (socket as any).emit = jest.fn();
            gateway['server'] = {
                to: jest.fn().mockReturnValue({ emit: jest.fn() }),
            } as any;
        });

        it('should emit DebugModeEnabled and log activation when toggleDebugMode returns true', () => {
            jest.spyOn(gameRoomService, 'toggleDebugMode').mockReturnValue(true);
            const fakeEmit = jest.fn();
            const toMock = jest.fn().mockReturnValue({ emit: fakeEmit });
            gateway['server'] = { to: toMock } as any;
            gateway.handleToggleDebugMode(roomId, socket);

            expect(gameRoomService.toggleDebugMode).toHaveBeenCalledWith(roomId);
            expect(toMock).toHaveBeenCalledWith(roomId);
            expect(fakeEmit).toHaveBeenCalledWith(GameRoomEvents.DebugModeEnabled);
        });

        it('should emit DebugModeDisabled and log deactivation when toggleDebugMode returns false', () => {
            jest.spyOn(gameRoomService, 'toggleDebugMode').mockReturnValue(false);

            const fakeEmit = jest.fn();
            const toMock = jest.fn().mockReturnValue({ emit: fakeEmit });

            gateway['server'] = { to: toMock } as any;
            gateway.handleToggleDebugMode(roomId, socket);

            expect(gameRoomService.toggleDebugMode).toHaveBeenCalledWith(roomId);
            expect(toMock).toHaveBeenCalledWith(roomId);
            expect(fakeEmit).toHaveBeenCalledWith(GameRoomEvents.DebugModeDisabled);
        });

        it('should emit GameRoomError if an error occurs', () => {
            jest.spyOn(gameRoomService, 'toggleDebugMode').mockImplementation(() => {
                throw error;
            });
            gateway.handleToggleDebugMode(roomId, socket);
            expect((socket as any).emit).toHaveBeenCalledWith(GameRoomEvents.GameRoomError, error.message);
        });
    });

    describe('handleEndTurn', () => {
        const roomId = 'room1';

        it('should call gameRoomService.endTurn with the provided roomId', () => {
            const endTurnSpy = jest.spyOn(gameRoomService, 'endTurn').mockImplementation(() => {});
            (socket as any).emit = jest.fn();

            gateway.handleEndTurn(roomId, socket);

            expect(endTurnSpy).toHaveBeenCalledWith(roomId);
            expect((socket as any).emit).not.toHaveBeenCalled();
        });

        it('should emit GameRoomError if an error occurs in endTurn', () => {
            const error = new Error('Test error');
            jest.spyOn(gameRoomService, 'endTurn').mockImplementation(() => {
                throw error;
            });
            (socket as any).emit = jest.fn();

            gateway.handleEndTurn(roomId, socket);

            expect((socket as any).emit).toHaveBeenCalledWith(GameRoomEvents.GameRoomError, error.message);
        });
    });

    describe('handleDoorToggled', () => {
        const data = { roomId: 'room1', x: 5, y: 5 };

        it('should log toggled door, call toggleDoor, and emit DoorToggled on success', () => {
            const toggleDoorSpy = jest.spyOn(gameMovementService, 'toggleDoor').mockImplementation(() => {});

            const fakeEmit = jest.fn();
            const toSpy = jest.fn().mockReturnValue({ emit: fakeEmit });
            gateway['server'] = { to: toSpy } as any;

            (socket as any).emit = jest.fn();

            gateway.handleDoorToggled(data, socket);

            expect(toggleDoorSpy).toHaveBeenCalledWith(data.x, data.y, undefined);
            expect(toSpy).toHaveBeenCalledWith(data.roomId);
            expect(fakeEmit).toHaveBeenCalledWith(GameRoomEvents.DoorToggled, data);
        });

        it('should emit GameRoomError if an error occurs', () => {
            const error = new Error('Test error');
            jest.spyOn(gameMovementService, 'toggleDoor').mockImplementation(() => {
                throw error;
            });
            (socket as any).emit = jest.fn();

            gateway.handleDoorToggled(data, socket);

            expect((socket as any).emit).toHaveBeenCalledWith(GameRoomEvents.GameRoomError, error.message);
        });
    });

    it('should log an error if an exception occurs in handleDisconnect', () => {
        const combatRooms: Combat[] = [{ combatRoomId: 'combatRoom1' } as Combat, { combatRoomId: 'combatRoom2' } as Combat];
        const abandonCombatSpy = jest.spyOn(gameCombatService, 'abandonCombat');
        gameCombatService.findCombatsByPlayerId.returns(combatRooms);
        Object.defineProperty(socket, 'id', { value: 'socket123' });

        gateway.handleDisconnect(socket);

        expect(abandonCombatSpy).toHaveBeenCalled();
    });

    describe('handleItemCollected', () => {
        it('devrait logger la collecte et appeler addItem du service', () => {
            const data = { roomId: 'room1', playerId: 'player1', item: { type: 'flag' }, position: { x: 5, y: 5 } };
            Object.defineProperty(socket, 'id', { value: 'socket1' });
            const mockRoom = { players: [{ id: 'player1', name: 'Player1' }], playersStats: [{ name: 'Player1', itemsCollected: [] }] };
            gameRoomService.findRoomById.returns(mockRoom as GameRoom);

            const fakeEmit = jest.fn();
            const toMock = jest.fn().mockReturnValue({ emit: fakeEmit });
            gateway['server'] = { to: toMock } as any;

            gateway.handleItemCollected(data, socket);

            expect(gameRoomService.addItemToInventory.calledWith('room1', 'player1', data.item)).toBeTruthy();
            expect(fakeEmit).toHaveBeenCalledWith(GameRoomEvents.FlagCollected, data.playerId);
        });

        it('devrait émettre GameRoomError si une erreur survient dans handleItemCollected', () => {
            const data = { roomId: 'room1', playerId: 'player1', item: { type: 'sword' }, position: { x: 5, y: 5 } };
            Object.defineProperty(socket, 'id', { value: 'socket1' });

            (socket as any).emit = jest.fn();

            gateway.handleItemCollected(data, socket);

            expect(socket.emit).toHaveBeenCalledWith(GameRoomEvents.GameRoomError, "Cannot read properties of undefined (reading 'players')");
        });
    });

    it('devrait mettre à jour la propriété hasBoots du joueur si le joueur est trouvé dans la room', async () => {
        const roomId = 'room123';
        const socketId = 'socketXYZ';
        Object.defineProperty(socket, 'id', { value: socketId });
        const player = { id: socketId, hasBoots: false };
        const mockRoom = { players: [player] } as any;
        gameRoomService.findRoomById.returns(mockRoom);

        const mockPaths = new Map();
        gameMovementService.getAllPaths.resolves(mockPaths);

        const emitStub = stub();
        server.to.returns({ emit: emitStub } as any);

        await gateway.handlePlayerGetMovements({ roomId, hasBoots: true }, socket);

        expect(player.hasBoots).toBe(true);
    });

    describe('handleItemDropped', () => {
        it("devrait logger le drop, émettre l'événement et appeler removeItem du service", () => {
            const data = { roomId: 'room1', playerId: 'player1', item: { type: 'adrenaline' }, coords: { x: 10, y: 20 } };
            Object.defineProperty(socket, 'id', { value: 'socket1' });
            const emitSpy = jest.fn();
            jest.spyOn(gateway['server'], 'to').mockReturnValue({ emit: emitSpy } as any);

            gateway.handleItemDropped(data, socket);

            expect(gateway['server'].to).toHaveBeenCalledWith('room1');
            expect(emitSpy).toHaveBeenCalledWith(GameRoomEvents.ItemDropped, data);
            expect(gameRoomService.removeItemFromInventory.calledWith('room1', 'player1', data.item)).toBeTruthy();
        });

        it('devrait émettre GameRoomError si une erreur survient dans handleItemDropped', () => {
            const data = { roomId: 'room1', playerId: 'player1', item: { type: 'shield' }, coords: { x: 10, y: 20 } };
            Object.defineProperty(socket, 'id', { value: 'socket1' });
            const error = new Error('Test error');
            gameRoomService.removeItemFromInventory.callsFake(() => {
                throw error;
            });

            jest.spyOn(gateway['server'], 'to').mockReturnValue({ emit: jest.fn() } as any);

            (socket as any).emit = jest.fn();

            gateway.handleItemDropped(data, socket);

            expect(socket.emit).toHaveBeenCalledWith(GameRoomEvents.GameRoomError, error.message);
        });
    });

    describe('handleVirtualPlayerTurn', () => {
        beforeEach(() => {
            jest.useFakeTimers();
            gameRoomService.isOpponent.returns(true);
        });
        afterEach(() => {
            jest.useRealTimers();
        });

        it('should be defined', () => {
            expect(gateway.handleVirtualPlayerTurn).toBeDefined();
        });

        it('should call gameRoomService.findRoomById with the roomId', () => {
            const data = { roomId: 'room1', playerId: 'player1', isCTF: false, skipTimeout: true };
            Object.defineProperty(socket, 'id', { value: 'socket1' });

            const findRoomByIdSpy = jest.spyOn(gameRoomService, 'findRoomById');
            gateway.handleVirtualPlayerTurn(data, socket);

            expect(findRoomByIdSpy).toHaveBeenCalledWith(data.roomId);
        });

        it("ne devrait rien faire si le joueur n'est pas défini", () => {
            const data = { roomId: 'room1', playerId: 'player1', isCTF: true, skipTimeout: true };
            Object.defineProperty(socket, 'id', { value: 'socket1' });
            const mockRoom = { players: [{ id: 'nonExistantId' }] } as GameRoom;
            gameRoomService.findRoomById.returns(mockRoom);

            (socket as any).emit = jest.fn();

            expect(gateway.handleVirtualPlayerTurn(data, socket)).toEqual(undefined);
        });

        it('devrait émettre GameRoomError si une erreur survient', () => {
            const data = { roomId: 'room1', playerId: 'player1', isCTF: true, skipTimeout: true };
            Object.defineProperty(socket, 'id', { value: 'socket1' });
            const error = new Error('Test error');
            gameRoomService.findRoomById.throws(error);

            (socket as any).emit = jest.fn();

            gateway.handleVirtualPlayerTurn(data, socket);

            expect(socket.emit).toHaveBeenCalledWith(GameRoomEvents.GameRoomError, error.message);
        });

        it('should use immediate timeout (0ms) when skipTimeout is true', () => {
            const data = { roomId: 'room1', playerId: 'virtualPlayer1', isCTF: true, skipTimeout: true };
            Object.defineProperty(socket, 'id', { value: 'socket1' });

            const virtualPlayer = { id: 'virtualPlayer1', name: 'VP1' };
            const mockRoom = { players: [virtualPlayer] } as any;
            gameRoomService.findRoomById.returns(mockRoom);

            const movement = {
                path: [
                    { x: 1, y: 1 },
                    { x: 2, y: 2 },
                ],
                remainingMovementPoints: 1,
            };
            gameMovementVPService.determineVPMovement.returns(movement);
            movementAlgorithmsService.findNeighborPlayer.returns(null);

            const setTimeoutSpy = jest.spyOn(global, 'setTimeout');

            const emitSpy = jest.fn();
            jest.spyOn(server, 'to').mockReturnValue({ emit: emitSpy } as any);

            gateway.handleVirtualPlayerTurn(data, socket);

            expect(setTimeoutSpy).toHaveBeenCalledWith(expect.any(Function), 0);

            // Clean up
            setTimeoutSpy.mockRestore();
        });

        it('should use random delay when skipTimeout is false', () => {
            const data = { roomId: 'room1', playerId: 'virtualPlayer1', isCTF: true, skipTimeout: false };
            Object.defineProperty(socket, 'id', { value: 'socket1' });

            const virtualPlayer = { id: 'virtualPlayer1', name: 'VP1' };
            const mockRoom = { players: [virtualPlayer] } as any;
            gameRoomService.findRoomById.returns(mockRoom);

            const movement = {
                path: [
                    { x: 1, y: 1 },
                    { x: 2, y: 2 },
                ],
                remainingMovementPoints: 1,
            };
            gameMovementVPService.determineVPMovement.returns(movement);
            movementAlgorithmsService.findNeighborPlayer.returns(null);

            const mockRandomDelay = 1500;
            gameRoomService.getRandomDelay.returns(mockRandomDelay);

            const setTimeoutSpy = jest.spyOn(global, 'setTimeout');

            const emitSpy = jest.fn();
            jest.spyOn(server, 'to').mockReturnValue({ emit: emitSpy } as any);

            gateway.handleVirtualPlayerTurn(data, socket);

            expect(gameRoomService.getRandomDelay.calledOnce).toBeTruthy();

            expect(setTimeoutSpy).toHaveBeenCalledWith(expect.any(Function), mockRandomDelay);

            // Clean up
            setTimeoutSpy.mockRestore();
        });

        it('should start virtual combat when path is short and a neighbor opponent is found', () => {
            const data = { roomId: 'room1', playerId: 'virtualPlayer1', isCTF: true, skipTimeout: true };
            Object.defineProperty(socket, 'id', { value: 'socket1' });

            const virtualPlayer = { id: 'virtualPlayer1', name: 'VP1' };
            const neighborPlayer = { id: 'opponent1', name: 'Opponent1' };
            const mockRoom = { players: [virtualPlayer, neighborPlayer] } as any;
            gameRoomService.findRoomById.returns(mockRoom);

            gameMovementVPService.determineVPMovement.returns({ path: [{ x: 1, y: 1 }], remainingMovementPoints: 0 });
            movementAlgorithmsService.findNeighborPlayer.returns(neighborPlayer);
            gameRoomService.isOpponent.returns(true);

            const setServerSpy = jest.spyOn(gameCombatService, 'setServer');
            const startVirtualCombatSpy = jest.spyOn(gameCombatService, 'startVirtualCombat');

            gateway.handleVirtualPlayerTurn(data, socket);

            jest.runAllTimers();

            expect(setServerSpy).toHaveBeenCalledWith(server);
            expect(startVirtualCombatSpy).toHaveBeenCalledWith(data.roomId, data.playerId, neighborPlayer.id, true);
        });

        it('should end turn when path is short and no neighbor opponent is found', () => {
            const data = { roomId: 'room1', playerId: 'virtualPlayer1', isCTF: true, skipTimeout: true };
            Object.defineProperty(socket, 'id', { value: 'socket1' });

            const virtualPlayer = { id: 'virtualPlayer1', name: 'VP1' };
            const mockRoom = { players: [virtualPlayer] } as any;
            gameRoomService.findRoomById.returns(mockRoom);

            gameMovementVPService.determineVPMovement.returns({ path: [{ x: 1, y: 1 }], remainingMovementPoints: 0 });
            movementAlgorithmsService.findNeighborPlayer.returns(null);

            const endTurnSpy = jest.spyOn(gameRoomService, 'endTurn');

            gateway.handleVirtualPlayerTurn(data, socket);

            jest.runAllTimers();

            expect(endTurnSpy).toHaveBeenCalledWith(data.roomId);
        });

        it('should emit VirtualPlayerMoved with opponent when path is long and a neighbor opponent is found', () => {
            const data = { roomId: 'room1', playerId: 'virtualPlayer1', isCTF: true, skipTimeout: true };
            Object.defineProperty(socket, 'id', { value: 'socket1' });

            const virtualPlayer = { id: 'virtualPlayer1', name: 'VP1' };
            const neighborPlayer = { id: 'opponent1', name: 'Opponent1' };
            const mockRoom = { players: [virtualPlayer, neighborPlayer] } as any;
            gameRoomService.findRoomById.returns(mockRoom);

            const movement = {
                path: [
                    { x: 1, y: 1 },
                    { x: 2, y: 2 },
                ],
                remainingMovementPoints: 1,
            };
            gameMovementVPService.determineVPMovement.returns(movement);
            movementAlgorithmsService.findNeighborPlayer.returns(neighborPlayer);
            gameRoomService.isOpponent.returns(true);

            const emitSpy = jest.fn();
            jest.spyOn(server, 'to').mockReturnValue({ emit: emitSpy } as any);

            gateway.handleVirtualPlayerTurn(data, socket);

            jest.runAllTimers();

            expect(server.to).toHaveBeenCalledWith(data.roomId);
            expect(emitSpy).toHaveBeenCalledWith(GameRoomEvents.VirtualPlayerMoved, {
                ...movement,
                playerId: data.playerId,
                opponentPlayerId: neighborPlayer.id,
            });
        });

        it('should emit VirtualPlayerMoved without opponent when path is long and no neighbor opponent is found', () => {
            const data = { roomId: 'room1', playerId: 'virtualPlayer1', isCTF: true, skipTimeout: true };
            Object.defineProperty(socket, 'id', { value: 'socket1' });

            const virtualPlayer = { id: 'virtualPlayer1', name: 'VP1' };
            const mockRoom = { players: [virtualPlayer] } as any;
            gameRoomService.findRoomById.returns(mockRoom);

            const movement = {
                path: [
                    { x: 1, y: 1 },
                    { x: 2, y: 2 },
                ],
                remainingMovementPoints: 1,
            };
            gameMovementVPService.determineVPMovement.returns(movement);
            movementAlgorithmsService.findNeighborPlayer.returns(null);

            const emitSpy = jest.fn();
            jest.spyOn(server, 'to').mockReturnValue({ emit: emitSpy } as any);

            gateway.handleVirtualPlayerTurn(data, socket);

            jest.runAllTimers();

            expect(server.to).toHaveBeenCalledWith(data.roomId);
            expect(emitSpy).toHaveBeenCalledWith(GameRoomEvents.VirtualPlayerMoved, {
                ...movement,
                playerId: data.playerId,
            });
        });
    });

    describe('handleStartVirtualCombat', () => {
        it('devrait commencer le combat virtuel', () => {
            const data = { roomId: 'room1', playerId: 'player1', opponentId: 'player2', coords: { x: 10, y: 20 } };
            Object.defineProperty(socket, 'id', { value: 'socket1' });

            gateway.handleStartVirtualCombat(data, socket);

            expect(gameCombatService.setServer(server));
            expect(gameCombatService.startVirtualCombat(data.roomId, data.playerId, data.opponentId, true));
        });

        it('devrait émettre GameRoomError si une erreur survient dans handleStartVirtualCombat', () => {
            const data = { roomId: 'room1', playerId: 'player1', opponentId: 'player2', coords: { x: 10, y: 20 } };
            Object.defineProperty(socket, 'id', { value: 'socket1' });
            const error = new Error('Test error');
            gameCombatService.setServer.callsFake(() => {
                throw error;
            });

            jest.spyOn(gateway['server'], 'to').mockReturnValue({ emit: jest.fn() } as any);

            (socket as any).emit = jest.fn();

            gateway.handleStartVirtualCombat(data, socket);

            expect(socket.emit).toHaveBeenCalledWith(GameRoomEvents.GameRoomError, error.message);
        });
    });

    describe('handleSynchronizeMovement', () => {
        it('devrait commencer le combat virtuel', () => {
            const data = { roomId: 'room1', playerId: 'player1', destination: { x: 10, y: 20 } };
            Object.defineProperty(socket, 'id', { value: 'socket1' });
            const emitSpy = jest.fn();
            jest.spyOn(gateway['server'], 'to').mockReturnValue({ emit: emitSpy } as any);

            gateway.handleSynchronizeMovement(data, socket);

            expect(emitSpy).toHaveBeenCalledWith(GameRoomEvents.SynchronizeMovement, data);
        });

        it('devrait émettre GameRoomError si une erreur survient dans handleSynchronizeMovement', () => {
            const data = { roomId: 'room1', playerId: 'player1', destination: { x: 10, y: 20 } };
            Object.defineProperty(socket, 'id', { value: 'socket1' });
            const error = new Error('Test error');
            jest.spyOn(gateway['server'], 'to').mockReturnValue({ emit: error } as any);

            (socket as any).emit = jest.fn();

            gateway.handleSynchronizeMovement(data, socket);

            expect(socket.emit).toHaveBeenCalledWith(GameRoomEvents.GameRoomError, 'this.server.to(...).emit is not a function');
        });
    });
});

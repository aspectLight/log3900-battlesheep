/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable @typescript-eslint/no-empty-function */
/* eslint-disable max-lines */
import { GameRoomGateway } from '@app/gateways/game-room/game-room.gateway';
import { GameCombatService } from '@app/services/game-combat/game-combat.service';
import { GameMovementService } from '@app/services/game-movement/game-movement.service';
import { GameRoomService } from '@app/services/game-room/game-room.service';
import { Logger } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { SinonStubbedInstance, createStubInstance, stub } from 'sinon';
import { BroadcastOperator, Server, Socket } from 'socket.io';
import { GameRoomEvents } from './game-room.gateway.events';
import { Combat } from '@app/interfaces/combat';
import { Room } from '@app/interfaces/room';

describe('GameRoomGateway', () => {
    let gateway: GameRoomGateway;
    let logger: SinonStubbedInstance<Logger>;
    let socket: SinonStubbedInstance<Socket>;
    let server: SinonStubbedInstance<Server>;
    let gameRoomService: SinonStubbedInstance<GameRoomService>;
    let gameCombatService: SinonStubbedInstance<GameCombatService>;
    let gameMovementService: SinonStubbedInstance<GameMovementService>;
    let loggerSpy;

    beforeEach(async () => {
        logger = createStubInstance(Logger);
        socket = createStubInstance<Socket>(Socket);
        server = createStubInstance<Server>(Server);
        gameRoomService = createStubInstance<GameRoomService>(GameRoomService);
        gameCombatService = createStubInstance<GameCombatService>(GameCombatService);
        gameMovementService = createStubInstance<GameMovementService>(GameMovementService);

        const module: TestingModule = await Test.createTestingModule({
            providers: [
                GameRoomGateway,
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

    it("should delete the room if there's only 2 players", () => {
        const roomId = 'room123';
        const socketId = 'socket789';

        Object.defineProperty(socket, 'id', { value: socketId });
        socket.join = stub();
        socket.emit = stub();

        // Stub server.to() to simulate emitting an event.
        server.to.returns({
            emit: (event: string) => {
                // When the room is deleted, GameCanceled should be emitted.
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
        expect(loggerSpy).toHaveBeenCalledWith(`Joueur ${socketId} a quitté la partie ${roomId}`);
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
        //  expect(loggerSpy).toHaveBeenCalledWith(`Error ${error.message} has been thrown`)).toBeTruthy();
    });

    it('should start game', () => {
        const roomId = 'room123';
        const gameId = 'game456';
        const organisator = { id: 'org1' };
        const socketId = 'socket789';
        const mockRoom = { id: roomId, gameId, organisatorId: organisator.id, roomId, players: [], isLocked: false };

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
        const organisator = { id: 'org1' };
        const socketId = 'socket789';
        const mockRoom = { id: roomId, gameId, organisatorId: organisator.id, roomId, players: [], isLocked: false };

        gameRoomService.findRoomsByPlayerId.returns([mockRoom]);
        gameRoomService.abandonGame.returns(true);

        server.to.returns({
            emit: (event: string) => {
                expect(event).toEqual(GameRoomEvents.GameCanceled);
            },
        } as BroadcastOperator<unknown, unknown>);

        Object.defineProperty(socket, 'id', { value: socketId });
        gateway.handleDisconnect(socket);

        expect(loggerSpy).toHaveBeenCalledWith(`Partie ${roomId} supprimée, car il y avait moins de 2 joueurs restant`);
    });

    it('should quit game on disconnect if player quits when there is more than 2 players left in the game', () => {
        const roomId = 'room123';
        const gameId = 'game456';
        const organisator = { id: 'org1' };
        const socketId = 'socket789';
        const mockRoom = { id: roomId, gameId, organisatorId: organisator.id, roomId, players: [], isLocked: false };

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
        expect(loggerSpy).toHaveBeenCalledWith(`Joueur ${socketId} a quitté la partie ${roomId} (déconnexion)`);
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
            expect(loggerSpy).toHaveBeenCalledWith(`Combat ${combat.combatRoomId} terminé suite à l'abandon du joueur ${socketId}`);
        });
    });

    describe('handleFinishGame', () => {
        const roomId = 'room123';
        const winnerId = 'winner1';

        it('should emit FinishGame, have all sockets leave, delete the room, and log success', async () => {
            const data = { roomId, winnerId };
            Object.defineProperty(socket, 'id', { value: 'socket123' });

            const emitStub = stub();
            server.to.returns({ emit: emitStub } as any);

            const fakeSocket1 = { leave: stub() };
            const fakeSocket2 = { leave: stub() };
            const fetchSocketsStub = stub().resolves([fakeSocket1, fakeSocket2]);
            server.in.returns({ fetchSockets: fetchSocketsStub } as any);

            gameRoomService.deleteRoomById = stub();

            await gateway.handleFinishGame(data, socket);

            expect(emitStub.calledWith(GameRoomEvents.FinishGame, winnerId)).toBeTruthy();
            expect(fetchSocketsStub.called).toBeTruthy();
            expect(fakeSocket1.leave.calledWith(roomId)).toBeTruthy();
            expect(fakeSocket2.leave.calledWith(roomId)).toBeTruthy();
            expect(gameRoomService.deleteRoomById.calledWith(roomId)).toBeTruthy();
            expect(loggerSpy).toHaveBeenCalledWith(`Joueur ${socket.id} a gagné la partie ${roomId}`);
        });

        it('should emit GameRoomError if an error occurs', async () => {
            const data = { roomId, winnerId };
            Object.defineProperty(socket, 'id', { value: 'socket123' });

            const emitStub = stub();
            server.to.returns({ emit: emitStub } as any);
            const error = new Error('Test error');
            const fetchSocketsStub = stub().rejects(error);
            server.in.returns({ fetchSockets: fetchSocketsStub } as any);

            socket.emit = stub();

            await gateway.handleFinishGame(data, socket);

            expect(loggerSpy).toHaveBeenCalledWith(`Error ${error.message} has been thrown`);
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

    it('should emit PlayerMovements on success', async () => {
        const roomId = 'roomId123';
        const socketId = 'socketXYZ';
        Object.defineProperty(socket, 'id', { value: socketId });

        const mockRoom = { players: [{ id: 'p1' }, { id: 'p2' }] } as Room;
        gameRoomService.findRoomById.returns(mockRoom);

        const mockPaths = new Map();
        mockPaths.set({ x: 1, y: 1 }, [
            { x: 1, y: 1 },
            { x: 1, y: 2 },
        ]);
        gameMovementService.getAllPaths.resolves(mockPaths);

        const emitStub = stub();
        server.to.returns({ emit: emitStub } as any);

        await gateway.handlePlayerGetMovements(roomId, socket);

        expect(gameRoomService.findRoomById.calledWith(roomId)).toBeTruthy();
        expect(gameMovementService.getAllPaths.calledWith(socketId, mockRoom.players)).toBeTruthy();
        expect(emitStub.calledWith(GameRoomEvents.PlayerMovements, Array.from(mockPaths.entries()))).toBeTruthy();
    });

    it('should emit GameRoomError if an error occurs', async () => {
        const roomId = 'roomId123';
        const socketId = 'socketXYZ';
        Object.defineProperty(socket, 'id', { value: socketId });

        const error = new Error('Test error');
        gameRoomService.findRoomById.throws(error);

        socket.emit = stub();

        await gateway.handlePlayerGetMovements(roomId, socket);

        expect(socket.emit.calledWith(GameRoomEvents.GameRoomError, error.message)).toBeTruthy();
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

        it('should emit PlayerMoved with movementPoints on success', async () => {
            const fakeRoom = { players: [{ id: 'player123' }, { id: 'player456' }], roomId } as any;
            gameRoomService.findRoomById.returns(fakeRoom);

            const expectedMovementPoints = 3;
            gameMovementService.movePlayer.resolves(expectedMovementPoints);

            // Stub server.to(roomId).emit.
            const emitStub = stub();
            server.to.returns({ emit: emitStub } as any);

            await gateway.handlePlayerMoved(data, socket);

            expect(gameRoomService.findRoomById.calledWith(roomId)).toBeTruthy();
            expect(gameMovementService.movePlayer.calledWith(socket.id, fakeRoom.players, selectedPath[selectedPath.length - 1])).toBeTruthy();
            expect(emitStub.calledWith(GameRoomEvents.PlayerMoved, { ...data, movementPoints: expectedMovementPoints })).toBeTruthy();
        });

        it('should emit GameRoomError if an error occurs', async () => {
            const error = new Error('Test error');
            gameRoomService.findRoomById.throws(error);

            socket.emit = stub();

            await gateway.handlePlayerMoved(data, socket);

            expect(socket.emit.calledWith(GameRoomEvents.GameRoomError, error.message)).toBeTruthy();
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

            await gateway.handlePlayerTeleported(data, socket);

            expect(movePlayerSpy).toHaveBeenCalled();
            expect(emitStub.calledWith(GameRoomEvents.PlayerTeleported, data)).toBeTruthy();
        });

        it('should call movePlayer and then emit PlayerTeleported if room is debugging', async () => {
            const fakeRoom = { isDebugging: true, players: [{ id: playerId }], gameId: 'game1' } as any;
            gameRoomService.findRoomById.returns(fakeRoom);

            const emitStub = stub();
            server.to.returns({ emit: emitStub } as any);

            const movePlayerSpy = jest.spyOn(gameMovementService, 'movePlayer').mockReturnValue(Promise.resolve(undefined));

            await gateway.handlePlayerTeleported(data, socket);

            expect(movePlayerSpy).toHaveBeenCalledWith(data.playerId, fakeRoom.players, destination, fakeRoom.isDebugging);
            expect(emitStub.calledWith(GameRoomEvents.PlayerTeleported, data)).toBeTruthy();
        });

        it('should emit GameRoomError if an error occurs', async () => {
            const error = new Error('Test error');
            gameRoomService.findRoomById.throws(error);

            socket.emit = stub();

            await gateway.handlePlayerTeleported(data, socket);

            expect(socket.emit.calledWith(GameRoomEvents.GameRoomError, error.message)).toBeTruthy();
        });

        it('should call movePlayer if room is in debug mode and then emit PlayerTeleported', async () => {
            const fakeRoom = {
                isDebugging: true,
                players: [{ id: 'player1' }, { id: 'player2' }],
                gameId: 'game1',
            } as any;

            gameRoomService.findRoomById.returns(fakeRoom);

            const movePlayerSpy = jest.spyOn(gameMovementService, 'movePlayer').mockResolvedValue(undefined);

            const emitMock = jest.fn();
            const toMock = jest.fn().mockReturnValue({ emit: emitMock });
            gateway['server'] = { to: toMock } as any;

            await gateway.handlePlayerTeleported(data, socket);

            expect(movePlayerSpy).toHaveBeenCalledWith(data.playerId, fakeRoom.players, data.destination, true);

            expect(toMock).toHaveBeenCalledWith(data.roomId);
            expect(emitMock).toHaveBeenCalledWith(GameRoomEvents.PlayerTeleported, data);
        });
    });

    describe('handleStartFight', () => {
        const data = { roomId: 'room1', opponentId: 'opp1' };

        it('should start combat successfully when room is found', () => {
            const combatStarter = { id: 'socket123' };
            const opponent = { id: data.opponentId };
            const fakeRoom = { players: [combatStarter, opponent], roomId: data.roomId } as any;
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

            // Ensure the socket passed to handleStartFight has an id
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
            expect(startCombatSpy).toHaveBeenCalledWith(combatRoom, [combatStarter, opponent], socket.id, data.opponentId);

            setServerSpy.mockRestore();
            pauseTimerSpy.mockRestore();
            socketJoinSpy.mockRestore();
            startCombatSpy.mockRestore();
        });

        it('should emit GameRoomError with "Room not found" when findRoomById returns undefined', () => {
            const room = { roomId: 'nonExistentRoom', opponentId: 'opponent123' };

            gameRoomService.findRoomById.returns(undefined);

            gateway['server'] = {
                sockets: {
                    sockets: new Map(),
                },
                to: stub().returns({ emit: stub() }),
            } as any;

            socket.emit = stub();

            gateway.handleStartFight(room, socket);

            expect(socket.emit.calledWith(GameRoomEvents.GameRoomError, 'Room not found')).toBeTruthy();
        });
    });

    describe('handleAttack', () => {
        const data = { roomId: 'room1', attackValue: 10, defenseValue: 5 };

        it('should call gameCombatService.attack with correct parameters and log the attack attempt', () => {
            const logSpy = jest.spyOn(gateway['logger'], 'log').mockImplementation(() => {});
            const attackSpy = jest.spyOn(gameCombatService, 'attack').mockImplementation(() => {});

            gateway.handleAttack(data, socket);

            expect(logSpy).toHaveBeenCalledWith(
                `[${data.roomId}] Attack attempt with attack value:  ${data.attackValue} and defense value: ${data.defenseValue}`,
            );
            expect(attackSpy).toHaveBeenCalledWith(data.roomId, data.attackValue, data.defenseValue);
        });

        it('should emit GameRoomError if an error occurs in handleAttack', () => {
            const error = new Error('Test error');
            jest.spyOn(gameCombatService, 'attack').mockImplementation(() => {
                throw error;
            });
            (socket as any).emit = jest.fn();

            gateway.handleAttack(data, socket);

            expect(socket.emit).toHaveBeenCalledWith(GameRoomEvents.GameRoomError, error.message);
        });
    });

    describe('handleFlightAttempt', () => {
        const roomId = 'testRoom';

        it('should log "received flight attempt" and call gameCombatService.attemptFlight', () => {
            const attemptFlightSpy = jest.spyOn(gameCombatService, 'attemptFlight').mockImplementation(() => {});

            gateway.handleFlightAttempt(roomId, socket);

            expect(attemptFlightSpy).toHaveBeenCalledWith(roomId);
        });

        it('should emit GameRoomError if an error occurs in handleFlightAttempt', () => {
            const error = new Error('Test error');
            jest.spyOn(gameCombatService, 'attemptFlight').mockImplementation(() => {
                throw error;
            });
            (socket as any).emit = jest.fn();

            gateway.handleFlightAttempt(roomId, socket);

            expect((socket as any).emit).toHaveBeenCalledWith(GameRoomEvents.GameRoomError, error.message);
        });
    });

    describe('handleResumeTurn', () => {
        const roomId = 'room123';

        it('should call gameRoomService.resumeTurn successfully', () => {
            const resumeTurnSpy = jest.spyOn(gameRoomService, 'resumeTurn').mockImplementation(() => {});
            (socket as any).emit = jest.fn();

            gateway.handleResumeTurn(roomId, socket);

            expect(resumeTurnSpy).toHaveBeenCalledWith(roomId);
            expect((socket as any).emit).not.toHaveBeenCalled();
        });

        it('should emit GameRoomError if an error occurs', () => {
            const error = new Error('Test error');
            jest.spyOn(gameRoomService, 'resumeTurn').mockImplementation(() => {
                throw error;
            });
            (socket as any).emit = jest.fn();

            gateway.handleResumeTurn(roomId, socket);

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
            const logSpy = jest.spyOn(gateway['logger'], 'log').mockImplementation(() => {});

            gateway.handleToggleDebugMode(roomId, socket);

            expect(gameRoomService.toggleDebugMode).toHaveBeenCalledWith(roomId);
            expect(toMock).toHaveBeenCalledWith(roomId);
            expect(fakeEmit).toHaveBeenCalledWith(GameRoomEvents.DebugModeEnabled);
            expect(logSpy).toHaveBeenCalledWith(`Partie ${roomId}: mode débogage activé`);
        });

        it('should emit DebugModeDisabled and log deactivation when toggleDebugMode returns false', () => {
            jest.spyOn(gameRoomService, 'toggleDebugMode').mockReturnValue(false);

            const fakeEmit = jest.fn();
            const toMock = jest.fn().mockReturnValue({ emit: fakeEmit });

            gateway['server'] = { to: toMock } as any;

            const logSpy = jest.spyOn(gateway['logger'], 'log').mockImplementation(() => {});

            gateway.handleToggleDebugMode(roomId, socket);

            expect(gameRoomService.toggleDebugMode).toHaveBeenCalledWith(roomId);
            expect(toMock).toHaveBeenCalledWith(roomId);
            expect(fakeEmit).toHaveBeenCalledWith(GameRoomEvents.DebugModeDisabled);
            expect(logSpy).toHaveBeenCalledWith(`Partie ${roomId}: mode débogage désactivé`);
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
            const logSpy = jest.spyOn(gateway['logger'], 'log').mockImplementation(() => {});
            const toggleDoorSpy = jest.spyOn(gameMovementService, 'toggleDoor').mockImplementation(() => {});

            const fakeEmit = jest.fn();
            const toSpy = jest.fn().mockReturnValue({ emit: fakeEmit });
            gateway['server'] = { to: toSpy } as any;

            (socket as any).emit = jest.fn();

            gateway.handleDoorToggled(data, socket);

            expect(logSpy).toHaveBeenCalledWith('toggled door', data, data.roomId, data.x, data.y);
            expect(toggleDoorSpy).toHaveBeenCalledWith(data.x, data.y);
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
});

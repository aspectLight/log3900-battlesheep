/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable @typescript-eslint/no-magic-numbers */
/* eslint-disable max-lines */
import { GameRoomEvents } from '@app/gateways/game-room/game-room.gateway.events';
import { WaitingRoomGateway } from '@app/gateways/waiting-room/waiting-room.gateway';
import { GameRoomService } from '@app/services/game-room/game-room.service';
import { WaitingRoomService } from '@app/services/waiting-room/waiting-room.service';
import { Logger } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { SinonStubbedInstance, createStubInstance, stub } from 'sinon';
import { BroadcastOperator, Server, Socket } from 'socket.io';
import { WaitingRoomEvents } from './waiting-room.gateway.events';

describe('WaitingRoomGateway', () => {
    let gateway: WaitingRoomGateway;
    let logger: SinonStubbedInstance<Logger>;
    let socket: SinonStubbedInstance<Socket>;
    let server: SinonStubbedInstance<Server>;
    let waitingRoomService: SinonStubbedInstance<WaitingRoomService>;
    let gameRoomService: SinonStubbedInstance<GameRoomService>;

    beforeEach(async () => {
        logger = createStubInstance(Logger);
        socket = createStubInstance<Socket>(Socket);
        server = createStubInstance<Server>(Server);
        waitingRoomService = createStubInstance<WaitingRoomService>(WaitingRoomService);
        gameRoomService = createStubInstance<GameRoomService>(GameRoomService);

        const module: TestingModule = await Test.createTestingModule({
            providers: [
                WaitingRoomGateway,
                {
                    provide: Logger,
                    useValue: logger,
                },
                {
                    provide: WaitingRoomService,
                    useValue: waitingRoomService,
                },
                {
                    provide: GameRoomService,
                    useValue: gameRoomService,
                },
            ],
        }).compile();

        gateway = module.get<WaitingRoomGateway>(WaitingRoomGateway);
        // eslint-disable-next-line dot-notation
        gateway['server'] = server;
    });

    it('should be defined', () => {
        expect(logger).toBeDefined();
        expect(gateway).toBeDefined();
    });

    it('should create a waiting room and emit the created event', () => {
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
                expect(event).toEqual(WaitingRoomEvents.WaitingRoomCreated);
            },
        } as BroadcastOperator<unknown, unknown>);

        waitingRoomService.createRoom.returns(mockRoom);

        gateway.handleCreateRoom({ roomId, gameId, organisator }, socket);

        expect(waitingRoomService.createRoom.calledWith(roomId, gameId, organisator, socketId));

        expect(socket.join.calledWith(roomId));
    });

    it('should send an error when creating a waiting room has a problem', () => {
        const roomId = 'room123';
        const gameId = 'game456';
        const organisator = { id: 'org1' };
        const socketId = 'socket789';
        const error = new Error('Erreur 1');

        Object.defineProperty(socket, 'id', { value: socketId });
        socket.join = stub();
        socket.emit = stub();

        waitingRoomService.createRoom.throws(error);

        gateway.handleCreateRoom({ roomId, gameId, organisator }, socket);

        expect(socket.emit.calledWith(WaitingRoomEvents.WaitingRoomError, error.message));
    });

    it('should allow a player to join a waiting room and emit the player joined event', () => {
        const gameId = 'game456';
        const organisator = { id: 'org1' };
        const roomId = 'room123';
        const socketId = 'socket789';
        const mockRoom = { id: roomId, gameId, organisatorId: organisator.id, roomId, players: [], isLocked: false };

        Object.defineProperty(socket, 'id', { value: socketId });

        socket.join = stub();
        socket.emit = stub();

        server.to.returns({
            emit: (event: string) => {
                expect(event).toEqual(WaitingRoomEvents.PlayerJoined);
            },
        } as BroadcastOperator<unknown, unknown>);

        waitingRoomService.findRoomById.returns(mockRoom);
        waitingRoomService.joinRoom = stub();

        gateway.handleJoinRoom(roomId, socket);

        expect(waitingRoomService.findRoomById.calledWith(roomId)).toBeTruthy();
        expect(socket.emit.calledWith(WaitingRoomEvents.JoinRoomResponse, { success: true, room: mockRoom })).toBeTruthy();
        expect(waitingRoomService.joinRoom.calledWith(roomId, socketId)).toBeTruthy();
        expect(socket.join.calledWith(roomId)).toBeTruthy();
        expect(server.to.calledWith(roomId)).toBeTruthy();
    });

    it('should return an error if the room does not exist', () => {
        const roomId = 'room123';
        const socketId = 'socket789';

        Object.defineProperty(socket, 'id', { value: socketId });
        socket.emit = stub();

        waitingRoomService.findRoomById.returns(null);

        gateway.handleJoinRoom(roomId, socket);

        expect(socket.emit.calledWith(WaitingRoomEvents.JoinRoomResponse, { success: false, error: "La salle n'existe pas" })).toBeTruthy();
    });

    it('should return an error if the room is locked', () => {
        const organisator = { id: 'org1' };
        const roomId = 'room123';
        const gameId = 'game456';
        const socketId = 'socket789';
        const mockRoom = { id: roomId, gameId, organisatorId: organisator.id, roomId, players: [], isLocked: true };

        Object.defineProperty(socket, 'id', { value: socketId });
        socket.emit = stub();

        waitingRoomService.findRoomById.returns(mockRoom);

        gateway.handleJoinRoom(roomId, socket);

        expect(socket.emit.calledWith(WaitingRoomEvents.JoinRoomResponse, { success: false, error: 'La salle est verrouillée' })).toBeTruthy();
    });

    it('should allow a user to create a player and join the waiting room', () => {
        const organisator = { id: 'org1', name: 'Alice' };
        const roomId = 'room123';
        const gameId = 'game456';
        const socketId = 'socket789';
        const player = { id: 'player1', name: 'Alice' };
        const mockRoom = { id: roomId, gameId, organisatorId: organisator.id, roomId, players: [organisator], isLocked: true };

        Object.defineProperty(socket, 'id', { value: socketId });

        server.to.returns({
            emit: (event: string) => {
                expect(event).toEqual(WaitingRoomEvents.PlayerCreated);
            },
        } as BroadcastOperator<unknown, unknown>);

        socket.emit = stub();

        waitingRoomService.findRoomById.returns(mockRoom);
        waitingRoomService.addCharacter = stub();

        gateway.handleCreatePlayer({ roomId, player }, socket);

        const expectedName = 'Alice -2';

        expect(waitingRoomService.findRoomById.calledWith(roomId)).toBeTruthy();
        expect(waitingRoomService.addCharacter.calledWith(roomId, { ...player, name: expectedName }, socketId)).toBeTruthy();
        expect(server.to.calledWith(roomId)).toBeTruthy();
    });

    it('should emit an error if one is encountered on handleCreatePlayer', () => {
        const roomId = 'room123';
        const socketId = 'socket789';
        const player = { id: 'player1', name: 'Alice' };
        const error = new Error('Erreur 1');
        /* eslint-disable @typescript-eslint/no-empty-function */
        Object.defineProperty(socket, 'id', { value: socketId });
        socket.emit = stub();

        waitingRoomService.findRoomById.throws(error);

        gateway.handleCreatePlayer({ roomId, player }, socket);

        expect(socket.emit.calledWith(WaitingRoomEvents.WaitingRoomError, error.message)).toBeTruthy();
    });

    it('should allow a user to reserve an avatar', () => {
        const organisator = { id: 'org1', name: 'Alice' };
        const roomId = 'room123';
        const gameId = 'game456';
        const socketId = 'socket789';
        const chosenAvatar = 'Avatar 1';
        const mockRoom = { id: roomId, gameId, organisatorId: organisator.id, roomId, players: [organisator], isLocked: true };

        Object.defineProperty(socket, 'id', { value: socketId });

        server.to.returns({
            emit: (event: string) => {
                expect(event).toEqual(WaitingRoomEvents.UpdateAvatarReserved);
            },
        } as BroadcastOperator<unknown, unknown>);

        socket.emit = stub();

        waitingRoomService.findRoomById.returns(mockRoom);

        gateway.handleReserveAvatar({ roomId, chosenAvatar }, socket);

        expect(waitingRoomService.reserveCharacter.calledWith(roomId, socketId, chosenAvatar)).toBeTruthy();
        expect(waitingRoomService.findRoomById.calledWith(roomId)).toBeTruthy();
        expect(server.to.calledWith(roomId)).toBeTruthy();
    });

    it('should emit an error if one is encountered on handleReserveAvatar', () => {
        const roomId = 'room123';
        const socketId = 'socket789';
        const chosenAvatar = 'Avatar 1';
        const error = new Error('Erreur 1');

        Object.defineProperty(socket, 'id', { value: socketId });
        socket.emit = stub();

        waitingRoomService.findRoomById.throws(error);

        gateway.handleReserveAvatar({ roomId, chosenAvatar }, socket);

        expect(socket.emit.calledWith(WaitingRoomEvents.WaitingRoomError, error.message)).toBeTruthy();
    });

    it('should allow a user to get all the reserved avatars of a room', () => {
        const organisator = { id: 'org1', name: 'Alice' };
        const roomId = 'room123';
        const gameId = 'game456';
        const socketId = 'socket789';
        const reservedAvatars = [
            { reservorId: '001', chosenAvatar: 'Avatar 1' },
            { reservorId: '002', chosenAvatar: 'Avatar 2' },
        ];
        const mockRoom = { id: roomId, gameId, organisatorId: organisator.id, roomId, players: [organisator], reservedAvatars, isLocked: true };

        Object.defineProperty(socket, 'id', { value: socketId });

        socket.emit = stub();

        waitingRoomService.findRoomById.returns(mockRoom);

        gateway.handleGetReservedAvatars({ roomId }, socket);

        expect(waitingRoomService.findRoomById.calledWith(roomId)).toBeTruthy();
        expect(socket.emit.calledWith(WaitingRoomEvents.UpdateAvatarReserved, { reservedAvatars: mockRoom.reservedAvatars })).toBeTruthy();
        waitingRoomService.findRoomById.returns(null);

        gateway.handleGetReservedAvatars({ roomId }, socket);

        expect(socket.emit.calledWith(WaitingRoomEvents.UpdateAvatarReserved, { reservedAvatars: [] })).toBeTruthy();
    });

    it('should emit an error if one is encountered on handleGetReservedAvatars', () => {
        const roomId = 'room123';
        const socketId = 'socket789';
        const error = new Error('Erreur 1');

        Object.defineProperty(socket, 'id', { value: socketId });
        socket.emit = stub();

        waitingRoomService.findRoomById.throws(error);

        gateway.handleGetReservedAvatars({ roomId }, socket);

        expect(socket.emit.calledWith(WaitingRoomEvents.WaitingRoomError, error.message)).toBeTruthy();
    });

    it('should allow a user to leave a room he is apart of and delete it when he is the organisor', () => {
        const organisator = { id: 'org1', name: 'Alice' };
        const roomId = 'room123';
        const gameId = 'game456';
        const socketId = 'socket789';
        const mockRoom = { id: roomId, gameId, organisatorId: organisator.id, roomId, players: [organisator], isLocked: true };

        Object.defineProperty(socket, 'id', { value: socketId });
        const emitStub = stub();
        socket.emit = stub();

        server.except.returns({
            to: stub().returns({
                emit: emitStub,
            }),
        } as unknown as BroadcastOperator<unknown, unknown>);

        waitingRoomService.findRoomById.returns(mockRoom);
        waitingRoomService.leaveRoom.returns(true);

        gateway.handleLeaveRoom(roomId, socket);

        expect(waitingRoomService.leaveRoom.calledWith(roomId, socketId)).toBeTruthy();
        expect(socket.emit.calledWith(WaitingRoomEvents.LeaveRoomResponse, { success: true })).toBeTruthy();
        expect(emitStub.callCount).toEqual(1);
        expect(emitStub.firstCall.calledWith(WaitingRoomEvents.RoomCanceled)).toBeTruthy();
    });

    it('should allow a user to leave a room he is apart of and inform the other participants when he is not the organisor', () => {
        const organisator = { id: 'org1', name: 'Alice' };
        const roomId = 'room123';
        const gameId = 'game456';
        const socketId = 'socket789';
        const reservedAvatars = [
            { reservorId: 'org1', chosenAvatar: 'Avatar 1' },
            { reservorId: 'org2', chosenAvatar: 'Avatar 2' },
        ];
        const mockRoom = { id: roomId, gameId, organisatorId: organisator.id, roomId, players: [organisator], reservedAvatars, isLocked: true };

        Object.defineProperty(socket, 'id', { value: socketId });
        socket.emit = stub();
        const emitStub = stub();

        server.to.returns({ emit: emitStub } as unknown as BroadcastOperator<unknown, unknown>);

        waitingRoomService.leaveRoom.returns(false);
        waitingRoomService.findRoomById.returns(mockRoom);

        gateway.handleLeaveRoom(roomId, socket);

        expect(waitingRoomService.leaveRoom.calledWith(roomId, socketId)).toBeTruthy();
        expect(waitingRoomService.findRoomById.calledWith(roomId)).toBeTruthy();
        expect(emitStub.callCount).toEqual(2);
        expect(emitStub.firstCall.calledWith(WaitingRoomEvents.PlayerLeft, { playerId: socketId })).toBeTruthy();
        expect(emitStub.secondCall.calledWith(WaitingRoomEvents.UpdateAvatarReserved, { reservedAvatars })).toBeTruthy();
    });

    it('should emit an error if one is encountered on handleLeaveRoom', () => {
        const roomId = 'room123';
        const socketId = 'socket789';
        const error = new Error('Erreur 1');

        Object.defineProperty(socket, 'id', { value: socketId });
        socket.emit = stub();

        waitingRoomService.leaveRoom.throws(error);

        gateway.handleLeaveRoom(roomId, socket);

        expect(socket.emit.calledWith(WaitingRoomEvents.LeaveRoomResponse, { success: false, error: error.message })).toBeTruthy();
    });

    it('should allow a user to lock a room', () => {
        const roomId = 'room123';
        const socketId = 'socket789';

        Object.defineProperty(socket, 'id', { value: socketId });
        socket.emit = stub();

        server.to.returns({
            emit: (event: string) => {
                expect(event).toEqual(WaitingRoomEvents.WaitingRoomLocked);
            },
        } as BroadcastOperator<unknown, unknown>);

        waitingRoomService.toggleLockRoom.returns(true);

        gateway.handleLockRoom(roomId, socket);

        expect(waitingRoomService.toggleLockRoom.calledWith(roomId, socketId)).toBeTruthy();
        expect(server.to.calledWith(roomId)).toBeTruthy();
    });

    it('should allow a user to unlock a room', () => {
        const roomId = 'room123';
        const socketId = 'socket789';

        Object.defineProperty(socket, 'id', { value: socketId });
        socket.emit = stub();

        server.to.returns({
            emit: (event: string) => {
                expect(event).toEqual(WaitingRoomEvents.WaitingRoomUnlocked);
            },
        } as BroadcastOperator<unknown, unknown>);

        waitingRoomService.toggleLockRoom.returns(false);

        gateway.handleLockRoom(roomId, socket);

        expect(waitingRoomService.toggleLockRoom.calledWith(roomId, socketId)).toBeTruthy();
        expect(server.to.calledWith(roomId)).toBeTruthy();
    });

    it('should emit an error if one is encountered on handleLockRoom', () => {
        const roomId = 'room123';
        const socketId = 'socket789';
        const error = new Error('Erreur 1');

        Object.defineProperty(socket, 'id', { value: socketId });
        socket.emit = stub();

        waitingRoomService.toggleLockRoom.throws(error);

        gateway.handleLockRoom(roomId, socket);

        expect(socket.emit.calledWith(WaitingRoomEvents.WaitingRoomError, error.message)).toBeTruthy();
    });

    it('should allow a user to kick a player', () => {
        const roomId = 'room123';
        const socketId = 'socket789';
        const organisator = { id: 'org1', name: 'Alice' };
        const playerToKick = { id: 'player2', name: 'Bob' };
        const gameId = 'game456';
        const reservedAvatars = [{ reservorId: 'org1', chosenAvatar: 'Avatar 1' }];
        const mockRoom = { id: roomId, gameId, organisatorId: organisator.id, roomId, players: [organisator], reservedAvatars, isLocked: true };

        Object.defineProperty(socket, 'id', { value: socketId });
        socket.emit = stub();
        const emitStub = stub();

        server.to.returns({ emit: emitStub } as unknown as BroadcastOperator<unknown, unknown>);

        waitingRoomService.kickPlayer.returns(true);
        waitingRoomService.findRoomById.returns(mockRoom);

        gateway.handleKickPlayer({ roomId, player: playerToKick }, socket);

        expect(waitingRoomService.kickPlayer.calledWith(roomId, socketId, playerToKick)).toBeTruthy();
        expect(waitingRoomService.findRoomById.calledWith(roomId)).toBeTruthy();
        // eslint-disable-next-line @typescript-eslint/no-magic-numbers
        expect(emitStub.callCount).toEqual(3);
        expect(emitStub.firstCall.calledWith(WaitingRoomEvents.PlayerLeft, { playerId: playerToKick.id })).toBeTruthy();
        expect(emitStub.secondCall.calledWith(WaitingRoomEvents.UpdateAvatarReserved, { reservedAvatars })).toBeTruthy();
        expect(emitStub.thirdCall.calledWith(WaitingRoomEvents.PlayerKicked)).toBeTruthy();
    });

    it('should emit an error if one is encountered on handleKickPlayer', () => {
        const roomId = 'room123';
        const socketId = 'socket789';
        const playerToKick = { id: 'player2', name: 'Bob' };
        const error = new Error('Erreur 1');

        Object.defineProperty(socket, 'id', { value: socketId });
        socket.emit = stub();

        waitingRoomService.kickPlayer.throws(error);

        gateway.handleKickPlayer({ roomId, player: playerToKick }, socket);

        expect(socket.emit.calledWith(WaitingRoomEvents.WaitingRoomError, error.message)).toBeTruthy();
    });

    it('should allow a user to start the game', async () => {
        const roomId = 'room123';
        const socketId1 = 'socket1';
        const socketId2 = 'socket2';
        const organisator = { id: 'org1', name: 'Alice' };
        const gameId = 'game456';
        const mockRoom = { id: roomId, gameId, organisatorId: organisator.id, roomId, players: [organisator], isLocked: true };
        const mockGameRoom = { id: `game_${roomId}`, gameId, organisatorId: organisator.id, roomId: gameId, players: [organisator], isLocked: true };

        const playerSocket1 = createStubInstance<Socket>(Socket);
        const playerSocket2 = createStubInstance<Socket>(Socket);
        Object.defineProperty(playerSocket1, 'id', { value: socketId1 });
        Object.defineProperty(playerSocket2, 'id', { value: socketId2 });

        playerSocket1.leave = stub();
        playerSocket1.join = stub();
        playerSocket2.leave = stub();
        playerSocket2.join = stub();

        server.in.returns({
            fetchSockets: async () => [playerSocket1, playerSocket2],
        } as unknown as BroadcastOperator<unknown, unknown>);

        server.to.returns({
            emit: (event: string) => {
                expect(event).toEqual(GameRoomEvents.GameRoomCreated);
            },
        } as BroadcastOperator<unknown, unknown>);

        waitingRoomService.findRoomById.returns(mockRoom);
        gameRoomService.createRoom.returns(mockGameRoom);
        waitingRoomService.deleteRoom = stub();

        await gateway.handleStartGame(roomId, socket);

        expect(waitingRoomService.findRoomById.calledWith(roomId)).toBeTruthy();
        expect(gameRoomService.createRoom.calledWith(mockRoom)).toBeTruthy();
        expect(playerSocket1.leave.calledWith(roomId)).toBeTruthy();
        expect(playerSocket1.join.calledWith(gameId)).toBeTruthy();
        expect(playerSocket2.leave.calledWith(roomId)).toBeTruthy();
        expect(playerSocket2.join.calledWith(gameId)).toBeTruthy();
        expect(waitingRoomService.deleteRoom.calledWith(roomId)).toBeTruthy();
    });

    it('should not allow a user to start the game if the room is not locked', () => {
        const roomId = 'room123';
        const organisator = { id: 'org1', name: 'Alice' };
        const gameId = 'game456';
        const mockRoom = { id: roomId, gameId, organisatorId: organisator.id, roomId, players: [organisator], isLocked: false };

        waitingRoomService.findRoomById.returns(mockRoom);

        gateway.handleStartGame(roomId, socket);

        expect(waitingRoomService.findRoomById.calledWith(roomId)).toBeTruthy();
        expect(socket.emit.calledWith(GameRoomEvents.GameRoomError, "La salle n'est pas verrouillée")).toBeTruthy();
    });

    it('should emit an error if one is encountered on handleStartGame', () => {
        const roomId = 'room123';
        const socketId = 'socket789';
        const error = new Error('Erreur 1');

        Object.defineProperty(socket, 'id', { value: socketId });
        socket.emit = stub();

        waitingRoomService.findRoomById.throws(error);

        gateway.handleStartGame(roomId, socket);

        expect(socket.emit.calledWith(GameRoomEvents.GameRoomError, error.message)).toBeTruthy();
    });

    it('should allow a user to generate a code', () => {
        const socketId = 'socket789';
        const code = '1234';

        Object.defineProperty(socket, 'id', { value: socketId });
        socket.emit = stub();

        waitingRoomService.generateCode.returns(code);

        gateway.handleGenerateCode(socket);

        expect(waitingRoomService.generateCode.called).toBeTruthy();
        expect(socket.emit.calledWith(WaitingRoomEvents.GenerateCodeResponse, { code })).toBeTruthy();
    });

    it('should handle connection', () => {
        const logSpy = jest.spyOn(gateway['logger'], 'log');
        gateway.handleConnection(socket);
        expect(logSpy).toHaveBeenCalledTimes(1);
    });

    it('should handle player disconnection and notify rooms', () => {
        const socketId = 'socket789';
        const organisator1 = { id: 'org1', name: 'Alice' };
        const organisator2 = { id: 'org2', name: 'Bob' };
        const player = { id: 'pla1', name: 'Alice -2' };
        const roomId1 = 'room1';
        const roomId2 = 'room2';
        const gameId1 = 'game456';
        const gameId2 = 'game456';
        const mockRoom1 = { id: roomId1, gameId1, organisatorId: organisator1.id, roomId: roomId1, players: [organisator1, player], isLocked: false };
        const mockRoom2 = { id: roomId2, gameId2, organisatorId: organisator2.id, roomId: roomId2, players: [organisator2, player], isLocked: false };

        Object.defineProperty(socket, 'id', { value: socketId });

        const rooms = [mockRoom1, mockRoom2] as any[];
        waitingRoomService.findRoomsByPlayerId.returns(rooms);

        waitingRoomService.leaveRoom.withArgs(roomId1, socketId).returns(true);
        waitingRoomService.leaveRoom.withArgs(roomId2, socketId).returns(false);

        const emitStub = stub();

        server.to.returns({ emit: emitStub } as unknown as BroadcastOperator<unknown, unknown>);

        waitingRoomService.findRoomById.returns(mockRoom2 as any);

        gateway.handleDisconnect(socket);

        expect(waitingRoomService.findRoomsByPlayerId.calledWith(socket.id)).toBeTruthy();

        expect(waitingRoomService.leaveRoom.calledTwice).toBeTruthy();
        expect(emitStub.callCount).toEqual(3);
    });

    it('should emit an error if one is encountered on handleDisconnect', () => {
        // eslint-disable-next-line @typescript-eslint/no-empty-function
        const errorSpy = jest.spyOn(gateway['logger'], 'error').mockImplementation(() => {});
        const socketId = 'socket789';
        Object.defineProperty(socket, 'id', { value: socketId });
        const error = new Error('Erreur 1');

        waitingRoomService.findRoomsByPlayerId.throws(error);
        gateway.handleDisconnect(socket);

        expect(errorSpy).toHaveBeenCalledWith(`Erreur lors du traitement de la déconnexion du joueur ${socketId}: ${error.message}`);
    });
});

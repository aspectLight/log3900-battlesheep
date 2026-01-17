import { Player } from '@app/interfaces/player';
import { Test, TestingModule } from '@nestjs/testing';
import { WaitingRoomService } from './waiting-room.service';

describe('WaitingRoomService', () => {
    let service: WaitingRoomService;

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [WaitingRoomService],
        }).compile();

        service = module.get<WaitingRoomService>(WaitingRoomService);
    });

    it('should be defined', () => {
        expect(service).toBeDefined();
    });

    it('should create a room', () => {
        const player = { id: '1', avatar: { name: 'Avatar1' } };
        const room = service.createRoom('room1', 'game1', player, 'socket1');
        expect(room).toBeDefined();
        expect(room.roomId).toBe('room1');
        expect(room.gameId).toBe('game1');
        expect(room.organisatorId).toBe('socket1');
        expect(room.players.length).toBe(1);
        expect(room.players[0].id).toBe('socket1');
    });

    it('should check room existence', () => {
        const player = { id: '1', avatar: { name: 'Avatar1' } };
        service.createRoom('room1', 'game1', player, 'socket1');
        expect(service.checkRoomExistence('room1')).toBe(true);
    });

    it('should throw error if room does not exist when calling checkRoomExistence', () => {
        expect(() => service.checkRoomExistence('room2')).toThrowError("La salle n'existe pas");
    });

    it('should throw error if room is locked when calling checkRoomExistence', () => {
        const player = { id: '1', avatar: { name: 'Avatar1' } };
        service.createRoom('room1', 'game1', player, 'socket1');
        service.toggleLockRoom('room1', 'socket1');
        expect(() => service.checkRoomExistence('room1')).toThrowError('La salle est verrouillée');
    });

    it('should join a room', () => {
        const player = { id: '1', avatar: { name: 'Avatar1' } };
        service.createRoom('room1', 'game1', player, 'socket1');
        const room = service.joinRoom('room1', 'player2');
        service.joinRoom('room1', 'player2');
        expect(room).toBeDefined();
        expect(room?.players.length).toBe(1);
        expect(room?.futurePlayers.length).toBe(1);
    });

    it('should throw error if room does not exist when calling joinRoom', () => {
        expect(() => service.joinRoom('room1', 'player2')).toThrowError("La salle n'existe pas");
    });

    it('should throw error if room is locked when calling joinRoom', () => {
        const player = { id: '1', avatar: { name: 'Avatar1' } };
        service.createRoom('room1', 'game1', player, 'socket1');
        service.toggleLockRoom('room1', 'socket1');
        expect(() => service.joinRoom('room1', 'player2')).toThrowError('La salle est verrouillée');
    });

    it('should add a character to a room', () => {
        const player = { id: '1', avatar: { name: 'Avatar1' } };
        service.createRoom('room1', 'game1', player, 'socket1');
        const newPlayer: Player = { id: '2' };
        const room = service.addCharacter('room1', newPlayer, 'socket2');
        expect(room).toBeDefined();
        expect(room?.players.length).toBe(2);
        expect(room?.players[1].id).toBe('socket2');
    });

    it('should throw error if room does not exist when calling joinRoom', () => {
        const newPlayer: Player = { id: '2' };
        expect(() => service.addCharacter('room1', newPlayer, 'socket2')).toThrowError("La salle n'existe pas");
    });

    it('should throw error if room is locked when calling joinRoom', () => {
        const player = { id: '1', avatar: { name: 'Avatar1' } };
        service.createRoom('room1', 'game1', player, 'socket1');
        service.toggleLockRoom('room1', 'socket1');
        const newPlayer: Player = { id: '2' };
        expect(() => service.addCharacter('room1', newPlayer, 'socket2')).toThrowError('La salle est verrouillée');
    });

    it('should throw error if player is already in room when calling joinRoom', () => {
        const player = { id: '1', avatar: { name: 'Avatar1' } };
        service.createRoom('room1', 'game1', player, 'socket1');
        const newPlayer: Player = { id: '2' };
        service.addCharacter('room1', newPlayer, 'socket2');
        expect(() => service.addCharacter('room1', newPlayer, 'socket1')).toThrowError('Le joueur est déjà dans la salle');
    });

    it('should add message to room', () => {
        const player = { id: '1', avatar: { name: 'Avatar1' } };
        service.createRoom('room1', 'game1', player, 'socket1');
        const message = {
            type: 'test',
            name: 'testName',
            content: 'testContent',
            time: 'testTime',
        };
        const room = service.findRoomById('room1');
        service.addMessage('room1', message);
        expect(room.messages).toEqual([message]);
    });

    it('should throw an error if the room does not exist', () => {
        expect(() => {
            service.addMessage('nonExistingRoom', { type: 'test', content: 'testContent', time: 'testTime' });
        }).toThrowError("La salle n'existe pas");
    });

    it('should reserve an avatar', () => {
        const playerId = '0001';
        const player = { id: playerId, avatar: { name: 'Avatar1' } };
        service.createRoom('room1', 'game1', player, playerId);
        const room = service.findRoomById('room1');
        expect(room.reservedAvatars.length).toBe(1);

        service.reserveCharacter('room1', playerId, 'Avatar2');

        expect(room.reservedAvatars.length).toBe(1);
        expect(room.reservedAvatars[0]).toEqual({ reservorId: playerId, chosenAvatar: 'Avatar2' });
    });

    it('should throw error if room does not exist when calling reserveCharacter', () => {
        expect(() => service.reserveCharacter('room1', '0001', 'Avatar2')).toThrowError("La salle n'existe pas");
    });

    it('should leave a room', () => {
        const player = { id: '1', avatar: { name: 'Avatar1' } };
        service.createRoom('room1', 'game1', player, 'socket1');
        service.joinRoom('room1', 'player2');
        service.leaveRoom('room1', 'player2');
        const room = service.findRoomById('room1');
        expect(room?.players.length).toBe(1);
    });

    it('should delete a room if organisator leaves', () => {
        const player = { id: '1', avatar: { name: 'Avatar1' } };
        service.createRoom('room1', 'game1', player, 'socket1');
        service.leaveRoom('room1', 'socket1');
        const room = service.findRoomById('room1');
        expect(room).toBeUndefined();
    });

    it('should throw error if room does not exist when calling leaveRoom', () => {
        expect(() => service.leaveRoom('room1', 'player2')).toThrowError("La salle n'existe pas");
    });

    it('should toggle lock room', () => {
        const player = { id: '1', avatar: { name: 'Avatar1' } };
        service.createRoom('room1', 'game1', player, 'socket1');
        const isLocked = service.toggleLockRoom('room1', 'socket1');
        expect(isLocked).toBe(true);
    });

    it('should throw error if room does not exist when calling toggleLockRoom', () => {
        expect(() => service.toggleLockRoom('room1', 'socket1')).toThrowError("La salle n'existe pas");
    });

    it('should throw error if locker is not the organisator', () => {
        const player = { id: '1', avatar: { name: 'Avatar1' } };
        service.createRoom('room1', 'game1', player, 'socket1');
        expect(() => service.toggleLockRoom('room1', 'socket2')).toThrowError("Seul l'organisteur de la partie peut verrouiller la partie");
    });

    it('should kick a player from the room', () => {
        const player = { id: '1', avatar: { name: 'Avatar1' } };
        service.createRoom('room1', 'game1', player, 'socket1');
        service.joinRoom('room1', 'player2');
        service.kickPlayer('room1', 'socket1', { id: 'player2' });
        const room = service.findRoomById('room1');
        expect(room?.players.length).toBe(1);
    });

    it('should throw error if room does not exist when calling kickPlayer', () => {
        expect(() => service.kickPlayer('room1', 'socket1', { id: 'player2' })).toThrowError("La salle n'existe pas");
    });

    it('should throw error if kicker is not the organisator', () => {
        const player = { id: '1', avatar: { name: 'Avatar1' } };
        service.createRoom('room1', 'game1', player, 'socket1');
        service.joinRoom('room1', 'player2');
        expect(() => service.kickPlayer('room1', 'socket2', { id: 'player1' })).toThrowError(
            "Seul l'organisteur de la partie peut exclure un joueur",
        );
    });

    it('should delete a room', () => {
        expect(service.findRoomById('room1')).toBeUndefined();
        const player = { id: '1', avatar: { name: 'Avatar1' } };
        service.createRoom('room1', 'game1', player, 'socket1');
        expect(service.findRoomById('room1')).toBeDefined();
        service.deleteRoom('room1');
        expect(service.findRoomById('room1')).toBeUndefined();
    });

    it('should find a room by id', () => {
        const player = { id: '1', avatar: { name: 'Avatar1' } };
        service.createRoom('room1', 'game1', player, 'socket1');
        const room = service.findRoomById('room1');
        expect(room).toBeDefined();
        expect(room?.roomId).toBe('room1');
    });

    it('should generate a unique room code', () => {
        const player = { id: '1', avatar: { name: 'Avatar1' } };
        const room = service.createRoom('0015', 'game1', player, 'socket1');
        jest.spyOn(Math, 'floor')
            .mockImplementationOnce(() => parseInt(room.roomId, 10) - 1)
            .mockImplementationOnce(() => 1233);

        const code = service.generateCode();

        expect(code).toStrictEqual('1234');
        expect(parseInt(code, 10)).toBeGreaterThan(0);
        expect(service['waitingRooms'].some((r) => r.roomId === code)).toBeFalsy();
    });

    it('should find rooms where the player is', () => {
        const player = { id: '1', avatar: { name: 'Avatar1' } };
        const player2: Player = { id: '2' };
        const player3Id = 'socketId2';
        const room = service.createRoom('room1', 'game1', player, 'socket1');
        room.futurePlayers.push(player3Id);
        service.addCharacter('room1', player2, 'socket2');

        let rooms = service.findRoomsByPlayerId('fake id');
        expect(rooms).toStrictEqual([]);

        rooms = service.findRoomsByPlayerId(player.id);
        expect(rooms).toStrictEqual([room]);

        rooms = service.findRoomsByPlayerId(player2.id);
        expect(rooms).toStrictEqual([room]);
        rooms = service.findRoomsByPlayerId(player3Id);
        expect(rooms).toStrictEqual([room]);
    });

    it('should return the number of players in a room', () => {
        const player = { id: '1', avatar: { name: 'Avatar1' } };
        service.createRoom('room1', 'game1', player, 'socket1');
        const room = service.findRoomById('room1');
        const playersNumber = room ? room.players.length : 0;
        expect(playersNumber).toBe(1);
    });
});

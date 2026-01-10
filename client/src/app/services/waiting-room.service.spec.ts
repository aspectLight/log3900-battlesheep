import { TestBed } from '@angular/core/testing';

import { WaitingRoomService } from './waiting-room.service';
import { Player } from '@app/classes/player';
import { Room } from '@app/interfaces/room';

describe('WaitingRoomService', () => {
    const player = new Player('mockPlayerId');
    const mockPlayerList: Player[] = [player];
    let service: WaitingRoomService;
    const mockRoom = {
        roomId: 'mockRoomId',
        gameId: 'mockGameId',
        organisatorId: 'mockOrganisatorId',
        players: mockPlayerList,
        isLocked: false,
        isDebugging: false,
    } as Room;

    beforeEach(() => {
        TestBed.configureTestingModule({});
        service = TestBed.inject(WaitingRoomService);
    });

    it('should be created', () => {
        expect(service).toBeTruthy();
    });

    it('should have a currentRoom BehaviorSubject', () => {
        expect(service['currentRoom']).toBeTruthy();
    });

    it('should get the room observable', () => {
        expect(service.room$).toBeTruthy();
    });

    it('should update the room', () => {
        service.updateRoom(mockRoom);
        service.room$.subscribe((room) => {
            expect(room).toEqual(mockRoom);
        });
    });

    it('should add a player', () => {
        service.updateRoom(mockRoom);
        service.addPlayer(mockPlayerList);
        service.room$.subscribe((room) => {
            expect(room.players).toEqual([player]);
        });
    });

    it('should remove a player', () => {
        service.updateRoom(mockRoom);
        service.removePlayer({ playerId: player.id });
        service.room$.subscribe((room) => {
            expect(room.players).toEqual([]);
        });
    });

    it('should toggle the room lock', () => {
        service.updateRoom(mockRoom);
        service.toggleLock(true);
        service.room$.subscribe((room) => {
            expect(room.isLocked).toBeTrue();
        });
    });

    it('should start the game', () => {
        service.updateRoom(mockRoom);
        service.startGame('mockRoomId');
        service.room$.subscribe((room) => {
            expect(room.roomId).toEqual('mockRoomId');
        });
    });

    it('should reset the room', () => {
        service.updateRoom(mockRoom);
        service.resetRoom();
        service.room$.subscribe((room) => {
            expect(room).toEqual({
                roomId: '',
                gameId: '',
                organisatorId: '',
                players: [],
                isLocked: false,
                isDebugging: false,
            });
        });
    });
});

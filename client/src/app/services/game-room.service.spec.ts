import { TestBed } from '@angular/core/testing';
import { Player } from '@app/classes/player';
import { Room } from '@app/interfaces/room';
import { GameRoomService } from './game-room.service';

describe('GameRoomService', () => {
    let service: GameRoomService;

    beforeEach(() => {
        TestBed.configureTestingModule({});
        service = TestBed.inject(GameRoomService);
    });

    it('should be created', () => {
        expect(service).toBeTruthy();
    });

    it('should get the room', () => {
        const room = service.room;
        expect(room).toBeDefined();
    });

    it('should have an initial room state', () => {
        const initialRoom: Room = {
            roomId: '',
            gameId: '',
            organisatorId: '',
            players: [],
            isLocked: false,
            isDebugging: false,
        };
        service.room$.subscribe((room) => {
            expect(room).toEqual(initialRoom);
        });
    });

    it('should update the room', () => {
        const newRoom: Room = {
            roomId: 'room1',
            gameId: 'game1',
            organisatorId: 'org1',
            players: [{ id: 'player1' } as Player],
            isLocked: true,
            isDebugging: false,
        };
        service.updateRoom(newRoom);
        service.room$.subscribe((room) => {
            expect(room).toEqual(newRoom);
        });
    });

    it('should update the players in the room', () => {
        const players: Player[] = [{ id: 'player1' } as Player, { id: 'player2' } as Player];
        service.updatePlayers(players);
        service.room$.subscribe((room) => {
            expect(room.players).toEqual(players);
        });
    });

    it('should toggle debug mode', () => {
        const initialRoom: Room = {
            roomId: 'room1',
            gameId: 'game1',
            organisatorId: 'org1',
            players: [{ id: 'player1' } as Player],
            isLocked: true,
            isDebugging: false,
        };
        service.updateRoom(initialRoom);
        service.toggleDebugMode();
        expect(service.room.isDebugging).toBeTrue();
        service.toggleDebugMode();
        expect(service.room.isDebugging).toBeFalse();
    });
});

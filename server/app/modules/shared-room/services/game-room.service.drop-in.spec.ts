import { GameService } from '@app/modules/game/services/game.service';
import { GameMovementService } from '@app/modules/movement/services/game-movement.service';
import { GameRoom } from '@app/modules/shared-room/interfaces/game-room';
import { Player } from '@app/shared/interfaces/player';
import { Test, TestingModule } from '@nestjs/testing';
import { createStubInstance } from 'sinon';
import { GameRoomService } from './game-room.service';

describe('GameRoomService drop-in turn order', () => {
    let service: GameRoomService;
    let fakeServer: { to: jest.Mock; emit: jest.Mock };
    const gameService = createStubInstance<GameService>(GameService);
    const mockGameMovementService = { removeItemFromBoard: jest.fn(), addItemToBoard: jest.fn() };

    const baseStats = (speed: number) => ({
        health: { maxValue: 4, value: 4, description: 'd' },
        speed: { maxValue: 10, value: speed, description: 'd' },
        attack: { maxValue: 4, value: 4, description: 'd' },
        defense: { maxValue: 4, value: 4, description: 'd' },
    });

    function dropInGameRoom(players: Player[]): GameRoom {
        return {
            roomId: 'game_dropin',
            gameId: 'g1',
            hostId: players[0]?.id ?? 'h',
            players,
            isLocked: true,
            dropInDropOut: true,
            abandonedPlayers: [],
            messages: [],
            playersStats: players.map((p) => ({
                name: p.name ?? p.id,
                combats: 0,
                evasions: 0,
                victories: 0,
                defeats: 0,
                healthLost: 0,
                damage: 0,
                itemsCollected: [],
                tilesVisited: [],
            })),
            globalStats: { gameDuration: '00:00', turns: 0, doorsToggled: [] },
            startTime: new Date(),
            entryFee: 0,
            paidPlayerFirebaseUids: [],
            actionPointsPerTurn: 1,
        };
    }

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                GameRoomService,
                { provide: GameService, useValue: gameService },
                { provide: GameMovementService, useValue: mockGameMovementService },
            ],
        }).compile();

        service = module.get<GameRoomService>(GameRoomService);
        fakeServer = {
            to: jest.fn().mockReturnThis(),
            emit: jest.fn(),
        };
        service.setServer(fakeServer as any);
    });

    it('addPlayerToGame keeps active player first and orders cycle by speed', () => {
        const players: Player[] = [
            { id: 'slowMid', name: 'slowMid', color: 'yellow', inventory: [], stats: baseStats(5) } as Player,
            { id: 'fast', name: 'fast', color: 'blue', inventory: [], stats: baseStats(8) } as Player,
            { id: 'slow', name: 'slow', color: 'green', inventory: [], stats: baseStats(3) } as Player,
        ];
        const room = dropInGameRoom(players);
        service['gameRooms'] = [room];

        const joiner: Player = {
            id: 'tmp',
            name: 'joiner',
            color: 'purple',
            inventory: [],
            stats: baseStats(6),
        } as Player;

        service.addPlayerToGame('game_dropin', joiner, 'socket_new', 6);

        expect(room.players[0].id).toBe('slowMid');
        expect(room.players.map((p) => p.id)).toEqual(['slowMid', 'slow', 'fast', 'socket_new']);
    });

    it('addPlayerToGame keeps active player first when all speeds are equal', () => {
        const players: Player[] = [
            { id: 'p2', name: 'p2', color: 'yellow', inventory: [], stats: baseStats(4) } as Player,
            { id: 'p1', name: 'p1', color: 'blue', inventory: [], stats: baseStats(4) } as Player,
            { id: 'p3', name: 'p3', color: 'green', inventory: [], stats: baseStats(4) } as Player,
        ];
        const room = dropInGameRoom(players);
        service['gameRooms'] = [room];

        const joiner: Player = {
            id: 'tmp',
            name: 'p4',
            color: 'purple',
            inventory: [],
            stats: baseStats(4),
        } as Player;

        service.addPlayerToGame('game_dropin', joiner, 'socket_join', 6);

        expect(room.players[0].id).toBe('p2');
        expect(new Set(room.players.map((p) => p.id)).size).toBe(4);
    });

    it('reorderTurnQueueAfterDropIn rotates to preserve current when sorted order differs', () => {
        const players: Player[] = [
            { id: 'current', name: 'current', color: 'yellow', inventory: [], stats: baseStats(5) } as Player,
            { id: 'fast', name: 'fast', color: 'blue', inventory: [], stats: baseStats(9) } as Player,
        ];
        const room = dropInGameRoom(players);
        room.players.push({ id: 'join', name: 'join', color: 'green', inventory: [], stats: baseStats(7) } as Player);
        service['gameRooms'] = [room];

        (service as any).reorderTurnQueueAfterDropIn(room);

        expect(room.players[0].id).toBe('current');
        expect(room.players.map((p) => p.id)).toEqual(['current', 'fast', 'join']);
    });
});

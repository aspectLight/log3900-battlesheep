/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable @typescript-eslint/no-magic-numbers */
import { Test, TestingModule } from '@nestjs/testing';
import { GameMovementService } from './game-movement.service';
import { GameService } from '@app/services/game/game.service';
import { Board } from '@app/interfaces/board';
import { Cell } from '@app/interfaces/cell';
import { Player } from '@app/interfaces/player';
import { ItemType } from '@app/interfaces/item';
import { TileType } from '@app/interfaces/tile';
import { Coords } from '@app/interfaces/coords';

const BASE_MP = 4;

describe('GameMovementService', () => {
    let service: GameMovementService;
    const mockGameService = { getGameById: jest.fn() };

    const createMockBoard = (): Board => {
        const matrix: Cell[][] = [];
        const size = 10;
        for (let y = 0; y < size; y++) {
            const row: Cell[] = [];
            for (let x = 0; x < size; x++) {
                row.push({
                    x,
                    y,
                    tile: { type: TileType.Snow },
                    item: null,
                    player: null,
                });
            }
            matrix.push(row);
        }

        matrix[0][1].tile.type = TileType.Wall;
        matrix[1][3].tile.type = TileType.Tree;
        matrix[3][5].tile.type = TileType.Stone;
        matrix[5][7].tile.type = TileType.Corner;
        matrix[7][2].tile.type = TileType.Intersection;
        matrix[8][8].tile = { type: TileType.Door, state: 'closed' };

        matrix[0][0].item = { type: ItemType.SpawnPoint };
        matrix[9][9].item = { type: ItemType.SpawnPoint };
        matrix[0][9].item = { type: ItemType.SpawnPoint };
        matrix[9][0].item = { type: ItemType.SpawnPoint };
        return { size, matrix };
    };

    const createMockPlayers = (): Player[] => [
        {
            id: 'player1',
            position: { x: 0, y: 0 },
            spawnPoint: { x: 0, y: 0 },
            movementPoints: BASE_MP,
        },
        {
            id: 'player2',
            position: { x: 9, y: 9 },
            spawnPoint: { x: 9, y: 9 },
            movementPoints: BASE_MP,
        },
    ];

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [GameMovementService, { provide: GameService, useValue: mockGameService }],
        }).compile();
        service = module.get<GameMovementService>(GameMovementService);
    });

    afterEach(() => {
        jest.clearAllMocks();
    });

    describe('toggleDoor', () => {
        it('should toggle door state from closed to opened', async () => {
            const board = createMockBoard();
            mockGameService.getGameById.mockResolvedValue({ board });
            await service['loadBoard']('game1');
            service.toggleDoor(8, 8);
            expect(board.matrix[8][8].tile.state).toBe('opened');
        });

        it('should toggle door state from opened to closed', async () => {
            const board = createMockBoard();
            board.matrix[8][8].tile = { type: TileType.Door, state: 'opened' };
            mockGameService.getGameById.mockResolvedValue({ board });
            await service['loadBoard']('game1');
            service.toggleDoor(8, 8);
            expect(board.matrix[8][8].tile.state).toBe('closed');
        });

        it('should not toggle non-door tiles', async () => {
            const board = createMockBoard();
            mockGameService.getGameById.mockResolvedValue({ board });
            await service['loadBoard']('game1');
            service.toggleDoor(0, 0);
            expect(board.matrix[0][0].tile.type).toBe(TileType.Snow);
        });
    });

    describe('addPlayersToBoard', () => {
        it('should add players to the board on spawn points', async () => {
            const board = createMockBoard();
            const players = [
                {
                    id: 'player1',
                    position: null,
                    spawnPoint: null,
                    movementPoints: BASE_MP,
                },
            ];
            mockGameService.getGameById.mockResolvedValue({ board });
            const res = await service.addPlayersToBoard('game1', players);
            expect(res).toBe(players);
            expect(players[0].position).toBeDefined();
            expect(players[0].spawnPoint).toBeDefined();
            const cell = board.matrix.flat().find((c) => c.player && c.player.id === 'player1');
            expect(cell).toBeDefined();
        });

        it('should throw error when board not found', async () => {
            mockGameService.getGameById.mockResolvedValue(null);
            await expect(service.addPlayersToBoard('game1', [])).rejects.toThrow('Partie introuvable');
        });

        it('should throw error when no spawn points are available', async () => {
            const board = createMockBoard();
            mockGameService.getGameById.mockResolvedValue({ board });
            board.matrix.forEach((row) => row.forEach((c) => (c.item = null)));
            const players = Array(5)
                .fill(0)
                .map((_, i) => ({
                    id: `player${i + 1}`,
                    position: null,
                    spawnPoint: null,
                    movementPoints: BASE_MP,
                }));
            await expect(service.addPlayersToBoard('game1', players)).rejects.toThrow('Pas assez de spawnpoints');
        });
    });

    describe('movePlayer', () => {
        beforeEach(async () => {
            const board = createMockBoard();
            mockGameService.getGameById.mockResolvedValue({ board });
            await service['loadBoard']('game1');
        });

        it('should move a player to a valid destination', async () => {
            const players = createMockPlayers();
            const startPos = { ...players[0].position };
            const dest: Coords = { x: 2, y: 2 };
            const remaining = await service.movePlayer('player1', players, dest);
            expect(remaining).toBeLessThan(BASE_MP);
            const newCell = service['getCell'](dest.x, dest.y);
            expect(newCell.player).toBe(players[0]);
            const oldCell = service['getCell'](startPos.x, startPos.y);
            expect(oldCell.player).toBeNull();
        });

        it('should throw error for non-existent player', async () => {
            const players = createMockPlayers();
            await expect(service.movePlayer('nonexistent', players, { x: 2, y: 2 })).rejects.toThrow('Joueur introuvable');
        });

        it('should throw error for invalid destination', async () => {
            const players = createMockPlayers();
            await expect(service.movePlayer('player1', players, { x: 15, y: 15 })).rejects.toThrow('Case introuvable');
        });

        it('should throw error for occupied destination', async () => {
            const players = createMockPlayers();
            const cell = service['getCell'](2, 2);
            cell.player = { ...players[1] };
            await expect(service.movePlayer('player1', players, { x: 2, y: 2 })).rejects.toThrow('Case occupée');
        });

        it('should throw error when getReachableTilesAndPaths returns null', async () => {
            const players = createMockPlayers();
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            jest.spyOn(service as any, 'getReachableTilesAndPaths').mockResolvedValue(null);
            await expect(service.movePlayer('player1', players, { x: 1, y: 1 })).rejects.toThrow('Erreur de calcul des chemins');
        });

        it('should throw error for unreachable destination', async () => {
            const players = createMockPlayers();
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            jest.spyOn(service as any, 'getReachableTilesAndPaths').mockResolvedValue({
                reachableTiles: [{ coord: { x: 0, y: 0 }, cost: 0 }],
                pathsMap: new Map(),
            });
            await expect(service.movePlayer('player1', players, { x: 1, y: 1 })).rejects.toThrow('Destination inatteignable');
        });

        it('should throw error for insufficient movement points', async () => {
            const players = createMockPlayers();
            players[0].movementPoints = 1;
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            jest.spyOn(service as any, 'getReachableTilesAndPaths').mockResolvedValue({
                reachableTiles: [
                    { coord: { x: 0, y: 0 }, cost: 0 },
                    { coord: { x: 3, y: 3 }, cost: 2 },
                ],
                pathsMap: new Map(),
            });
            await expect(service.movePlayer('player1', players, { x: 3, y: 3 })).rejects.toThrow('Points de mouvement insuffisants');
        });

        it('should allow debug movement regardless of constraints', async () => {
            const players = createMockPlayers();
            const startPos = { ...players[0].position };
            await service.movePlayer('player1', players, { x: 5, y: 5 }, true);
            expect(players[0].position.x).toBe(5);
            expect(players[0].position.y).toBe(5);
            const newCell = service['getCell'](5, 5);
            expect(newCell.player).toBe(players[0]);
            const oldCell = service['getCell'](startPos.x, startPos.y);
            expect(oldCell.player).toBeNull();
        });
    });

    describe('getAllPaths / getReachableTilesAndPaths', () => {
        it('should throw "Joueur introuvable" if player not found', async () => {
            const board = createMockBoard();
            mockGameService.getGameById.mockResolvedValue({ board });
            const players = createMockPlayers().filter((p) => p.id !== 'player1');
            await expect(service['getAllPaths']('player1', players)).rejects.toThrow('Joueur introuvable');
        });

        it('should throw "Joueur introuvable" if player not found', async () => {
            const board = createMockBoard();
            mockGameService.getGameById.mockResolvedValue({ board });
            const players = createMockPlayers().filter((p) => p.id !== 'player1');
            await expect(service['getReachableTilesAndPaths']('player1', players)).rejects.toThrow('Joueur introuvable');
        });

        it('should throw error if getShortestPath returns null', async () => {
            jest.spyOn(service as any, 'getReachableTilesAndPaths').mockResolvedValue({
                reachableTiles: [{ coord: { x: 2, y: 2 }, cost: 1 }],
                pathsMap: new Map(),
            });
            jest.spyOn(service as any, 'getShortestPath').mockReturnValue(null);
            const players = [
                {
                    id: 'player1',
                    position: { x: 0, y: 0 },
                    movementPoints: BASE_MP,
                    spawnPoint: { x: 0, y: 0 },
                },
            ];
            await expect(service.getAllPaths('player1', players)).rejects.toThrow('Chemin introuvable pour la cellule (2,2)');
        });

        it('should return only the starting cell when movementPoints are zero', async () => {
            const board = createMockBoard();
            const players = createMockPlayers();
            players[0].movementPoints = 0;
            mockGameService.getGameById.mockResolvedValue({ board });
            await service['loadBoard']('game1');
            const paths = await service.getAllPaths('player1', players);
            expect(paths.size).toBe(1);
            for (const [coord] of paths.entries()) {
                expect(coord.x).toBe(0);
                expect(coord.y).toBe(0);
            }
        });

        it('should handle non-existent neighbor cells (board boundaries)', async () => {
            const board = createMockBoard();
            const players = createMockPlayers();
            players[0].position = { x: 0, y: 0 };

            mockGameService.getGameById.mockResolvedValue({ board });
            await service['loadBoard']('game1');

            const getCellSpy = jest.spyOn(service as any, 'getCell');

            const result = await (service as any).getReachableTilesAndPaths('player1', players);

            expect(getCellSpy).toHaveBeenCalledWith(-1, 0);
            expect(getCellSpy).toHaveBeenCalledWith(0, -1);

            expect(result).toBeDefined();
            expect(result.reachableTiles.length).toBeGreaterThan(0);
        });

        it('should respect player movement points limit', async () => {
            const board = createMockBoard();
            const players = createMockPlayers();

            players[0].movementPoints = 1;

            mockGameService.getGameById.mockResolvedValue({ board });
            await service['loadBoard']('game1');

            players[0].position = { x: 2, y: 2 };
            board.matrix[2][2].player = players[0];

            const result = await (service as any).getReachableTilesAndPaths('player1', players);

            result.reachableTiles.forEach((tile) => {
                expect(tile.cost).toBeLessThanOrEqual(players[0].movementPoints);
            });

            const maxPossibleReachableTiles = 5;
            expect(result.reachableTiles.length).toBeLessThanOrEqual(maxPossibleReachableTiles);

            const startTile = result.reachableTiles.find((t) => t.coord.x === 2 && t.coord.y === 2);
            expect(startTile).toBeDefined();
            expect(startTile.cost).toBe(0);

            const distantCoords = [
                { x: 4, y: 2 },
                { x: 0, y: 2 },
                { x: 2, y: 4 },
                { x: 2, y: 0 },
            ];

            for (const coord of distantCoords) {
                const distantTile = result.reachableTiles.find((t) => t.coord.x === coord.x && t.coord.y === coord.y);
                expect(distantTile).toBeUndefined();
            }
        });
    });

    describe('getCell', () => {
        it('should return null for out-of-bounds coordinates', async () => {
            const board = createMockBoard();
            mockGameService.getGameById.mockResolvedValue({ board });
            await service['loadBoard']('game1');
            expect(service['getCell'](-1, 0)).toBeNull();
            expect(service['getCell'](0, -1)).toBeNull();
            expect(service['getCell'](10, 0)).toBeNull();
            expect(service['getCell'](0, 10)).toBeNull();
        });
        it('should return the correct cell for valid coordinates', async () => {
            const board = createMockBoard();
            mockGameService.getGameById.mockResolvedValue({ board });
            await service['loadBoard']('game1');
            const cell = service['getCell'](5, 5);
            expect(cell).toBeDefined();
            expect(cell.x).toBe(5);
            expect(cell.y).toBe(5);
        });
    });

    describe('getShortestPath', () => {
        it('should throw error for unreachable destination', () => {
            const pathsMap = new Map<string, Coords>();
            expect(() => {
                service['getShortestPath']({ x: 0, y: 0 }, { x: 5, y: 5 }, pathsMap);
            }).toThrow('Chemin introuvable');
        });
        it('should return correct path for reachable destination', () => {
            const pathsMap = new Map<string, Coords>();
            pathsMap.set('1,0', { x: 0, y: 0 });
            pathsMap.set('2,0', { x: 1, y: 0 });
            const path = service['getShortestPath']({ x: 0, y: 0 }, { x: 2, y: 0 }, pathsMap);
            expect(path).toEqual([
                { x: 0, y: 0 },
                { x: 1, y: 0 },
                { x: 2, y: 0 },
            ]);
        });
    });

    describe('isCellFree', () => {
        it('should return true for free cells', () => {
            const cell: Cell = { x: 0, y: 0, tile: { type: TileType.Snow }, item: null, player: null };
            expect(service['isCellFree'](cell)).toBe(true);
        });

        it('should identify open door as free', () => {
            const cell: Cell = { x: 0, y: 0, tile: { type: TileType.Door, state: 'opened' }, item: null, player: null };
            expect(service['isCellFree'](cell)).toBe(true);
        });

        it('should identify closed door as not free', () => {
            const cell: Cell = { x: 0, y: 0, tile: { type: TileType.Door, state: 'closed' }, item: null, player: null };
            expect(service['isCellFree'](cell)).toBe(false);
        });

        it('should identify obstacles as not free', () => {
            const obstacles = [TileType.Wall, TileType.Tree, TileType.Stone, TileType.Corner, TileType.Intersection];
            for (const type of obstacles) {
                const cell: Cell = { x: 0, y: 0, tile: { type }, item: null, player: null };
                expect(service['isCellFree'](cell)).toBe(false);
            }
        });

        it('should return false for null cell', () => {
            expect(service['isCellFree'](null)).toBe(false);
        });
    });
});

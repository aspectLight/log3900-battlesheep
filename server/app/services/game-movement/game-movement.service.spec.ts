/* eslint-disable max-lines */
/* eslint-disable @typescript-eslint/no-explicit-any */
import { Board } from '@app/interfaces/board';
import { Cell } from '@app/interfaces/cell';
import { Coords } from '@app/interfaces/coords';
import { GameRoom } from '@app/interfaces/game-room';
import { ItemType } from '@app/interfaces/item';
import { Player } from '@app/interfaces/player';
import { TileType } from '@app/interfaces/tile';
import { GameService } from '@app/services/game/game.service';
import { ErrorMessages } from '@common/error-messages.constants';
import { Test, TestingModule } from '@nestjs/testing';
import { GameMovementService } from './game-movement.service';

const BASE_MP = 4;

describe('GameMovementService', () => {
    let service: GameMovementService;
    const mockGameService = { getGameById: jest.fn() };
    const testRoom: GameRoom = {
        roomId: 'test_room',
        gameId: 'game1',
        organisatorId: 'player1',
        players: [
            {
                id: 'player1',
                stats: {
                    health: { maxValue: 4, value: 4, description: 'desc' },
                    speed: { maxValue: 4, value: 4, description: 'desc' },
                    attack: { maxValue: 4, value: 4, description: 'desc' },
                    defense: { maxValue: 4, value: 4, description: 'desc' },
                },
            },
            {
                id: 'player2',
                stats: {
                    health: { maxValue: 4, value: 4, description: 'desc' },
                    speed: { maxValue: 4, value: 4, description: 'desc' },
                    attack: { maxValue: 4, value: 4, description: 'desc' },
                    defense: { maxValue: 4, value: 4, description: 'desc' },
                },
            },
        ],
        isLocked: true,
        messages: [],
        journalEntries: [],
        playersStats: [
            {
                name: 'Player 1',
                combats: 8,
                evasions: 4,
                victories: 6,
                defeats: 2,
                healthLost: 20,
                damage: 25,
                itemsCollected: [],
                tilesVisited: [],
            },
            {
                name: 'Player 2',
                combats: 0,
                evasions: 0,
                victories: 1,
                defeats: 0,
                healthLost: 0,
                damage: 0,
                itemsCollected: [],
                tilesVisited: [],
            },
        ],
        globalStats: {
            gameDuration: '00:00',
            turns: 0,
            doorsToggled: [],
        },
    };

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
            service.toggleDoor(8, 8, testRoom);
            expect(board.matrix[8][8].tile.state).toBe('opened');
        });

        it('should toggle door state from opened to closed', async () => {
            const board = createMockBoard();
            board.matrix[8][8].tile = { type: TileType.Door, state: 'opened' };
            mockGameService.getGameById.mockResolvedValue({ board });
            await service['loadBoard']('game1');
            service.toggleDoor(8, 8, testRoom);
            expect(board.matrix[8][8].tile.state).toBe('closed');
        });

        it('should not toggle non-door tiles', async () => {
            const board = createMockBoard();
            mockGameService.getGameById.mockResolvedValue({ board });
            await service['loadBoard']('game1');
            service.toggleDoor(0, 0, testRoom);
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
            await expect(service.addPlayersToBoard('game1', [])).rejects.toThrow("Le jeu n'existe pas");
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
            await expect(service.addPlayersToBoard('game1', players)).rejects.toThrow('Il doit y avoir au moins un point de départ.');
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
            expect(() => {
                service.movePlayer('nonexistent', players, { x: 2, y: 2 });
            }).toThrow(ErrorMessages.PlayerNotFound);
        });

        it('should throw error for invalid destination', async () => {
            const players = createMockPlayers();
            expect(() => {
                service.movePlayer('player1', players, { x: 15, y: 15 });
            }).toThrow(ErrorMessages.CellNotFound);
        });

        it('should throw error for occupied destination', async () => {
            const players = createMockPlayers();
            const cell = service['getCell'](9, 9);
            cell.player = { ...players[1] };
            expect(() => {
                service.movePlayer('player1', players, { x: 9, y: 9 });
            }).toThrow(ErrorMessages.CellOccupied);
        });

        it('should throw error when getReachableTilesAndPaths returns null', async () => {
            const players = createMockPlayers();
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            jest.spyOn(service as any, 'getReachableTilesAndPaths').mockReturnValue(null);
            expect(() => {
                service.movePlayer('player1', players, { x: 1, y: 1 });
            }).toThrow(ErrorMessages.PathCalculationError);
        });

        it('should throw error for unreachable destination', async () => {
            const players = createMockPlayers();
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            jest.spyOn(service as any, 'getReachableTilesAndPaths').mockReturnValue({
                reachableTiles: [{ coord: { x: 0, y: 0 }, cost: 0 }],
                pathsMap: new Map(),
            });
            expect(() => {
                service.movePlayer('player1', players, { x: 1, y: 1 });
            }).toThrow(ErrorMessages.UnreachableDestination);
        });

        it('should throw error for insufficient movement points', async () => {
            const players = createMockPlayers();
            players[0].movementPoints = 1;
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            jest.spyOn(service as any, 'getReachableTilesAndPaths').mockReturnValue({
                reachableTiles: [
                    { coord: { x: 0, y: 0 }, cost: 0 },
                    { coord: { x: 3, y: 3 }, cost: 2 },
                ],
                pathsMap: new Map(),
            });
            expect(() => {
                service.movePlayer('player1', players, { x: 3, y: 3 });
            }).toThrow(ErrorMessages.InsufficientMovementPoints);
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

    describe('removePlayerFromBoard', () => {
        it('should remove player from board', async () => {
            const board = createMockBoard();
            const players = createMockPlayers();
            mockGameService.getGameById.mockResolvedValue({ board });
            await service['loadBoard']('game1');
            const cell = service['getCell'](0, 0);
            cell.player = players[0];
            service.removePlayerFromBoard('player1');
            expect(cell.player).toBeNull();
        });
        it('should do nothing if player not found', async () => {
            const board = createMockBoard();
            const players = createMockPlayers();
            mockGameService.getGameById.mockResolvedValue({ board });
            await service['loadBoard']('game1');
            const cell = service['getCell'](0, 0);
            cell.player = players[0];
            service.removePlayerFromBoard('nonexistent');
            expect(cell.player).toBe(players[0]);
        });
    });

    describe('getAllPaths / getReachableTilesAndPaths', () => {
        it('should throw "Joueur introuvable" if player not found', async () => {
            const board = createMockBoard();
            mockGameService.getGameById.mockResolvedValue({ board });
            const players = createMockPlayers().filter((p) => p.id !== 'player1');
            expect(() => {
                service.getAllPaths('player1', players);
            }).toThrow(ErrorMessages.PlayerNotFound);
        });

        it('should throw "Joueur introuvable" if player not found', async () => {
            const board = createMockBoard();
            mockGameService.getGameById.mockResolvedValue({ board });
            const players = createMockPlayers().filter((p) => p.id !== 'player1');
            expect(() => {
                service.getReachableTilesAndPaths('player1', players);
            }).toThrow(ErrorMessages.PlayerNotFound);
        });

        it('should throw error if getShortestPath returns null', async () => {
            jest.spyOn(service as any, 'getReachableTilesAndPaths').mockResolvedValue({
                reachableTiles: [{ coord: { x: 2, y: 2 }, cost: 1 }],
                pathsMap: new Map(),
            });
            jest.spyOn(service as any, 'getReachableTilesAndPaths').mockReturnValue({
                reachableTiles: [{ coord: { x: 1, y: 1 }, cost: 0 }],
                pathsMap: new Map<string, Coords>(),
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
            expect(() => {
                service.getAllPaths('player1', players);
            }).toThrow('Chemin introuvable pour la cellule (1,1)');
        });

        it('should return only the starting cell when movementPoints are zero', async () => {
            const board = createMockBoard();
            const players = createMockPlayers();
            players[0].movementPoints = 0;
            mockGameService.getGameById.mockResolvedValue({ board });
            await service['loadBoard']('game1');
            const paths = service.getAllPaths('player1', players);
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

            const result = await (service as any).getReachableTilesAndPaths('player1', players, true);

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

    // it("should use 'WaterWithBoots' cost when player has boots and neighbor tile is water", async () => {
    //     // Créer un board personnalisé
    //     const board = createMockBoard();
    //     // Modifier une cellule voisine de (0,0) pour qu'elle soit de type "water"
    //     // Ici, on modifie la cellule (1,0) (voisin vers la droite)
    //     board.matrix[1][0].tile.type = TileType.Water; // en minuscules pour forcer la capitalisation vers "Water"

    //     // Configurer le mock de getGameById pour retourner notre board personnalisé
    //     mockGameService.getGameById.mockResolvedValue({ board });
    //     await service['loadBoard']('game1');

    //     // Créer un joueur avec des boots (hasBoots=true) et assez de points de mouvement
    //     const player = {
    //         id: 'player1',
    //         position: { x: 0, y: 0 },
    //         movementPoints: 10,
    //         hasBoots: true,
    //         spawnPoint: { x: 0, y: 0 },
    //     };
    //     const players = [player];

    //     // Appeler la méthode privée getReachableTilesAndPaths
    //     const result = await service['getReachableTilesAndPaths']('player1', players);

    //     // Vérifier que la cellule (1,0) est bien atteignable
    //     const targetTile = result.reachableTiles.find((tile) => tile.coord.x === 1 && tile.coord.y === 0);
    //     expect(targetTile).toBeDefined();
    //     // Comme le joueur a des boots et que le voisin est "water", le type devrait être transformé en "WaterWithBoots"
    //     expect(targetTile.cost).toBe(MoveCosts['WaterWithBoots']);
    // });

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
            }).toThrow('Chemin non trouvé');
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

    describe('isCellReachable', () => {
        it('should return false if cell is null', () => {
            const cell = null;
            expect(service['isCellReachable'](cell)).toBe(false);
        });
        it('should return false if cell is a wall', () => {
            const cell: Cell = { x: 0, y: 0, tile: { type: TileType.Wall }, item: null, player: {} as Player };
            expect(service['isCellReachable'](cell)).toBe(false);
        });
        it('should return false if cell is a closed door', () => {
            const cell: Cell = { x: 0, y: 0, tile: { type: TileType.Door }, item: null, player: null };
            cell.tile.state = 'closed';
            expect(service['isCellReachable'](cell)).toBe(false);
        });
        it('should return true if cell is a walkable tile', () => {
            const cell: Cell = { x: 0, y: 0, tile: { type: TileType.Snow }, item: null, player: null };
            expect(service['isCellReachable'](cell)).toBe(true);
        });
    });

    describe('isCellFree', () => {
        it('should return true if player is on the cell', () => {
            const players = createMockPlayers();
            const cell: Cell = { x: 0, y: 0, tile: { type: TileType.Snow }, item: null, player: players[0] };
            expect(service['isCellFree'](cell, players[0].id)).toBe(true);
        });
        it('should return true for free cells', () => {
            const cell: Cell = { x: 0, y: 0, tile: { type: TileType.Snow }, item: null, player: null };
            expect(service['isCellFree'](cell)).toBe(true);
        });
        it('should return false for cells with players cells', () => {
            const cell: Cell = { x: 0, y: 0, tile: { type: TileType.Snow }, item: null, player: createMockPlayers()[0] };
            expect(service['isCellFree'](cell)).toBe(false);
        });
        it('should return false if cell is occupied by another player (playerId provided)', () => {
            const players = createMockPlayers();
            const cell: Cell = {
                x: 0,
                y: 0,
                tile: { type: TileType.Snow },
                item: null,
                player: players[0],
            };
            expect(service['isCellFree'](cell, 'another-player')).toBe(false);
        });
    });

    it('should get distance between two coords', () => {
        expect(service.getDistance({ x: 0, y: 0 }, { x: 0, y: 1 })).toEqual(1);
    });

    describe('validatePath', () => {
        beforeEach(async () => {
            const board = createMockBoard();
            mockGameService.getGameById.mockResolvedValue({ board });
            await service['loadBoard']('game1');
        });

        it('should return valid for a legal path with sufficient movement points', () => {
            const players = createMockPlayers();
            const path: Coords[] = [
                { x: 0, y: 0 },
                { x: 1, y: 0 },
                { x: 2, y: 0 },
            ];
            const result = service.validatePath('player1', path, players);
            expect(result.isValid).toBe(true);
            if (result.isValid) {
                expect(result.cost).toBeGreaterThan(0);
            }
        });

        it('should return error if player not found', () => {
            const players = createMockPlayers();
            const path: Coords[] = [{ x: 0, y: 0 }];
            const result = service.validatePath('nonexistent', path, players);
            expect(result.isValid).toBe(false);
            if (result.isValid === false) {
                expect(result.error).toBe(ErrorMessages.PlayerNotFound);
            }
        });

        it('should return valid with cost 0 for empty path', () => {
            const players = createMockPlayers();
            const path: Coords[] = [];
            const result = service.validatePath('player1', path, players);
            expect(result.isValid).toBe(true);
            if (result.isValid) {
                expect(result.cost).toBe(0);
            }
        });

        it('should return valid with cost 0 for single cell path (no movement)', () => {
            const players = createMockPlayers();
            const path: Coords[] = [{ x: 0, y: 0 }];
            const result = service.validatePath('player1', path, players);
            expect(result.isValid).toBe(true);
            if (result.isValid) {
                expect(result.cost).toBe(0);
            }
        });

        it('should return error if path does not start at player position', () => {
            const players = createMockPlayers();
            const path: Coords[] = [
                { x: 1, y: 1 },
                { x: 2, y: 1 },
            ];
            const result = service.validatePath('player1', path, players);
            expect(result.isValid).toBe(false);
            if (result.isValid === false) {
                expect(result.error).toBe(ErrorMessages.PathStartInvalid);
            }
        });

        it('should return error for non-adjacent segments (teleport attempt)', () => {
            const players = createMockPlayers();
            const path: Coords[] = [
                { x: 0, y: 0 },
                { x: 0, y: 1 },
                { x: 0, y: 3 },
            ];
            const result = service.validatePath('player1', path, players);
            expect(result.isValid).toBe(false);
            if (result.isValid === false) {
                expect(result.error).toBe(ErrorMessages.PathNotAdjacent);
            }
        });

        it('should return error for path including out-of-bounds cell', () => {
            const players = createMockPlayers();
            const path: Coords[] = [
                { x: 0, y: 0 },
                { x: -1, y: 0 },
            ];
            const result = service.validatePath('player1', path, players);
            expect(result.isValid).toBe(false);
            if (result.isValid === false) {
                expect(result.error).toBe(ErrorMessages.CellNotFound);
            }
        });

        it('should return error for path including wall', () => {
            const players = createMockPlayers();
            const path: Coords[] = [
                { x: 0, y: 0 },
                { x: 0, y: 1 },
            ];
            const result = service.validatePath('player1', path, players);
            expect(result.isValid).toBe(false);
            if (result.isValid === false) {
                expect(result.error).toContain("n'est pas accessible");
            }
        });

        it('should return error for path including occupied cell', () => {
            const players = createMockPlayers();
            const cell = service['getCell'](2, 0);
            cell.player = players[1];
            const path: Coords[] = [
                { x: 0, y: 0 },
                { x: 1, y: 0 },
                { x: 2, y: 0 },
            ];
            const result = service.validatePath('player1', path, players);
            expect(result.isValid).toBe(false);
            if (result.isValid === false) {
                expect(result.error).toBe(ErrorMessages.CellOccupied);
            }
        });

        it('should return error for insufficient movement points', () => {
            const players = createMockPlayers();
            players[0].movementPoints = 1;
            const path: Coords[] = [
                { x: 0, y: 0 },
                { x: 1, y: 0 },
                { x: 2, y: 0 },
                { x: 3, y: 0 },
            ];
            const result = service.validatePath('player1', path, players);
            expect(result.isValid).toBe(false);
            if (result.isValid === false) {
                expect(result.error).toBe(ErrorMessages.InsufficientMovementPoints);
            }
        });

        it('should allow player to move to cell they currently occupy', () => {
            const players = createMockPlayers();
            const path: Coords[] = [
                { x: 0, y: 0 },
                { x: 1, y: 0 },
                { x: 0, y: 0 },
            ];
            const result = service.validatePath('player1', path, players);
            expect(result.isValid).toBe(true);
        });

        it('should calculate correct cost for path with different terrain types', () => {
            const players = createMockPlayers();
            const path: Coords[] = [
                { x: 0, y: 0 },
                { x: 1, y: 0 },
                { x: 2, y: 0 },
            ];
            const result = service.validatePath('player1', path, players);
            expect(result.isValid).toBe(true);
            if (result.isValid) {
                expect(result.cost).toBeGreaterThan(0);
            }
        });

        it('should account for boots when calculating cost', () => {
            const players = createMockPlayers();
            players[0].hasBoots = true;
            const board = service['board'];
            board.matrix[1][0].tile.type = TileType.Water;
            const path: Coords[] = [
                { x: 0, y: 0 },
                { x: 1, y: 0 },
            ];
            const result = service.validatePath('player1', path, players);
            expect(result.isValid).toBe(true);
            if (result.isValid) {
                expect(result.cost).toBeLessThan(2);
            }
        });

        it('should reject diagonal movement', () => {
            const players = createMockPlayers();
            const path: Coords[] = [
                { x: 0, y: 0 },
                { x: 1, y: 1 },
            ];
            const result = service.validatePath('player1', path, players);
            expect(result.isValid).toBe(false);
            if (result.isValid === false) {
                expect(result.error).toBe(ErrorMessages.PathNotAdjacent);
            }
        });

        it('should validate long path correctly', () => {
            const players = createMockPlayers();
            players[0].movementPoints = 10;
            const path: Coords[] = [
                { x: 0, y: 0 },
                { x: 1, y: 0 },
                { x: 2, y: 0 },
                { x: 3, y: 0 },
                { x: 4, y: 0 },
            ];
            const result = service.validatePath('player1', path, players);
            expect(result.isValid).toBe(true);
            if (result.isValid) {
                expect(result.cost).toBeGreaterThan(0);
            }
        });
    });

    it('should get door number', () => {
        (service as any).board = createMockBoard();
        expect(service.getAllDoors()).toEqual(1);
    });

    it('should add item to board', () => {
        (service as any).board = createMockBoard();
        const item = { type: ItemType.SpawnPoint };
        const cell = { x: 0, y: 0 };
        service.addItemToBoard(item, cell);
        const boardCell = (service as any).board.matrix[cell.y][cell.x];
        expect(boardCell.item).toEqual(item);
    });

    it('should remove item from board', () => {
        (service as any).board = createMockBoard();
        const item = { type: ItemType.SpawnPoint };
        const cell = { x: 0, y: 0 };
        (service as any).board.matrix[cell.y][cell.x].item = item;
        service.removeItemFromBoard(cell);
        const boardCell = (service as any).board.matrix[cell.y][cell.x];
        expect(boardCell.item).toBeNull();
    });

    it('should get walkable tile number', () => {
        (service as any).board = createMockBoard();
        expect(service.getWalkableTiles()).toEqual(97);
    });
});

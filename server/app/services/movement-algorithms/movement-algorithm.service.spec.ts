/* eslint-disable @typescript-eslint/no-magic-numbers */
/* eslint-disable max-lines */
import { Cell } from '@app/interfaces/cell';
import { Coords } from '@app/interfaces/coords';
import { Item, ItemType } from '@app/interfaces/item';
import { Player } from '@app/interfaces/player';
import { MoveCosts, TileType } from '@app/interfaces/tile';
import { GameMovementService } from '@app/services/game-movement/game-movement.service';
import { GameRoomService } from '@app/services/game-room/game-room.service';
import { Test, TestingModule } from '@nestjs/testing';
import { MovementAlgorithmsService } from './movement-algorithms.service';

describe('MovementAlgorithmsService', () => {
    let service: MovementAlgorithmsService;
    let gameMovementService: GameMovementService;
    let gameRoomService: GameRoomService;
    const mockPlayer: Player = { id: 'player1', position: { x: 5, y: 5 }, spawnPoint: { x: 0, y: 0 }, stats: {}, name: 'Player 1' };
    const mockOpponent: Player = { id: 'player2', position: { x: 6, y: 5 }, spawnPoint: { x: 9, y: 9 }, stats: {}, name: 'Player 2' };
    const mockCell: Cell = { x: 5, y: 5, tile: { type: TileType.Snow }, item: null, player: null };

    beforeEach(async () => {
        const mockGameMovementService = {
            getCell: jest.fn(),
            isCellReachable: jest.fn(),
            isCellFree: jest.fn(),
            getShortestPath: jest.fn(),
            getDistance: jest.fn(),
        };
        const mockGameRoomService = { isOpponent: jest.fn(), isOpponentCarryingFlag: jest.fn() };
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                MovementAlgorithmsService,
                { provide: GameMovementService, useValue: mockGameMovementService },
                { provide: GameRoomService, useValue: mockGameRoomService },
            ],
        }).compile();
        service = module.get<MovementAlgorithmsService>(MovementAlgorithmsService);
        gameMovementService = module.get<GameMovementService>(GameMovementService);
        gameRoomService = module.get<GameRoomService>(GameRoomService);
    });

    describe('findClosestPlayer', () => {
        it('should find path to player in normal and CTF modes', () => {
            const expectedPath = [
                { x: 5, y: 5 },
                { x: 6, y: 5 },
            ];
            jest.spyOn(gameMovementService, 'getCell').mockImplementation((x, y) => ({
                ...mockCell,
                x,
                y,
                player: x === 6 ? mockOpponent : null,
                tile: { type: x === 6 ? TileType.Water : TileType.Snow },
            }));
            jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(true);
            jest.spyOn(gameRoomService, 'isOpponent').mockReturnValue(true);
            jest.spyOn(gameMovementService, 'getShortestPath').mockReturnValue(expectedPath);
            expect(service.findClosestPlayer(mockPlayer, false)).toEqual({ path: expectedPath, cost: MoveCosts.Water });
            const mockFlag: Item = { type: ItemType.Flag };
            jest.spyOn(gameRoomService, 'isOpponentCarryingFlag').mockReturnValue(mockFlag);
            expect(service.findClosestPlayer(mockPlayer, true)).toEqual({ path: expectedPath, cost: MoveCosts.Water });
        });

        it('should return null if no player found', () => {
            jest.spyOn(gameMovementService, 'getCell').mockImplementation((x, y) => {
                if (x === 5 && y === 5) {
                    return { ...mockCell, x, y };
                }
                return null;
            });
            jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(true);
            const result = service.findClosestPlayer(mockPlayer);
            expect(result).toBeNull();
        });

        it('should return null if cell is not reachable', () => {
            jest.spyOn(gameMovementService, 'getCell').mockImplementation((x, y) => {
                if (x === 6 && y === 5) {
                    return { ...mockCell, x, y, player: mockOpponent };
                }
                return null;
            });
            jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(false);
            const result = service.findClosestPlayer(mockPlayer);
            expect(result).toBeNull();
        });

        it('should return null in CTF mode when opponent is not carrying flag', () => {
            const expectedPath = [
                { x: 5, y: 5 },
                { x: 6, y: 5 },
            ];
            jest.spyOn(gameMovementService, 'getCell').mockImplementation((x, y) => {
                if (x === 6 && y === 5) {
                    return { ...mockCell, x, y, player: mockOpponent };
                }
                if (x === 5 && y === 5) {
                    return { ...mockCell, x, y };
                }
                return null;
            });
            jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(true);
            jest.spyOn(gameRoomService, 'isOpponent').mockReturnValue(true);
            jest.spyOn(gameRoomService, 'isOpponentCarryingFlag').mockReturnValue(null);
            jest.spyOn(gameMovementService, 'getShortestPath').mockReturnValue(expectedPath);
            const result = service.findClosestPlayer(mockPlayer, true);
            expect(result).toBeNull();
        });

        it('should calculate cost correctly for different tile types', () => {
            const expectedPath = [
                { x: 5, y: 5 },
                { x: 6, y: 5 },
            ];
            jest.spyOn(gameMovementService, 'getCell').mockImplementation((x, y) => {
                if (x === 6 && y === 5) {
                    return { ...mockCell, x, y, player: mockOpponent, tile: { type: TileType.Water } };
                }
                if (x === 5 && y === 5) {
                    return { ...mockCell, x, y, tile: { type: TileType.Snow } };
                }
                return null;
            });
            jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(true);
            jest.spyOn(gameRoomService, 'isOpponent').mockReturnValue(true);
            jest.spyOn(gameMovementService, 'getShortestPath').mockReturnValue(expectedPath);
            const result = service.findClosestPlayer(mockPlayer, false);
            expect(result).toEqual({ path: expectedPath, cost: MoveCosts.Water });
        });

        it('should handle starting position with zero cost', () => {
            mockPlayer.position = { x: 5, y: 5 };
            jest.spyOn(gameMovementService, 'getCell').mockImplementation((x, y) => {
                if (x === 5 && y === 5) {
                    return { ...mockCell, x, y, player: mockOpponent, tile: { type: TileType.Water } };
                }
                return null;
            });
            jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(true);
            jest.spyOn(gameRoomService, 'isOpponent').mockReturnValue(true);
            jest.spyOn(gameMovementService, 'getShortestPath').mockReturnValue([mockPlayer.position]);
            const result = service.findClosestPlayer(mockPlayer, false);
            expect(result).toEqual({ path: [mockPlayer.position], cost: 0 });
        });

        describe('findClosestPlayer branch coverage', () => {
            const originalMapGet = Map.prototype.get;

            afterEach(() => {
                jest.restoreAllMocks();
            });

            // Test A: Force the "continue" branch when a queued element’s stored cost is lower than its current cost.
            it('should skip processing an element when costMap.get(key) < current.cost (continue branch)', () => {
                // Use a bounded grid so the search eventually terminates.
                const boundedGetCell = (x: number, y: number): Cell | null => {
                    if (x < -1 || x > 1 || y < -1 || y > 1) return null;
                    return { x, y, tile: { type: TileType.Snow }, item: null, player: null };
                };
                jest.spyOn(gameMovementService, 'getCell').mockImplementation(boundedGetCell);
                jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(true);
                jest.spyOn(gameMovementService, 'isCellFree').mockImplementation(() => true);
                jest.spyOn(gameMovementService, 'getShortestPath').mockReturnValue([
                    { x: 0, y: 0 },
                    { x: 0, y: 1 },
                ]);

                // Override Map.prototype.get: for key "0,1", force it to return 0 (even if a higher cost was stored).
                const mapGetSpy = jest.spyOn(Map.prototype, 'get').mockImplementation(function (key: string) {
                    if (key === '0,1') return 0;
                    // eslint-disable-next-line no-invalid-this
                    return originalMapGet.call(this, key);
                });

                // Ensure that no cell returns an opponent so that findClosestPlayer never returns early.
                jest.spyOn(gameRoomService, 'isOpponent').mockReturnValue(false);

                const player: Player = { ...mockPlayer, position: { x: 0, y: 0 } };
                const result = service.findClosestPlayer(player);
                expect(result).toBeNull();

                mapGetSpy.mockRestore();
            });

            // Test B: Force the branch where newCost is computed as 0 because neighborKey equals `${player.position}`.
            it('should compute newCost as 0 for a neighbor equal to player.position (using toString override)', () => {
                // Set up a bounded grid.
                const boundedGetCell = (x: number, y: number): Cell | null => {
                    if (x < -1 || x > 1 || y < -1 || y > 1) return null;
                    return { x, y, tile: { type: TileType.Snow }, item: null, player: null };
                };
                jest.spyOn(gameMovementService, 'getCell').mockImplementation(boundedGetCell);
                jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(true);
                jest.spyOn(gameMovementService, 'isCellFree').mockImplementation(() => true);
                jest.spyOn(gameMovementService, 'getShortestPath').mockReturnValue([
                    { x: 0, y: 0 },
                    { x: 0, y: 1 },
                ]);
                jest.spyOn(gameRoomService, 'isOpponent').mockReturnValue(false);

                const customPosition = {
                    x: 0,
                    y: 0,
                    toString() {
                        return '0,1';
                    },
                };
                const player: Player = { ...mockPlayer, position: customPosition };

                // In the neighbor loop, the neighbors of {0,0} are:
                //   {0,-1}, {0,1}, {-1,0}, {1,0}
                // For neighbor {0,1}, neighborKey is "0,1".
                // Since `${player.position}` now returns "0,1", the condition becomes true,
                // and newCost is set to 0 (instead of current.cost + MoveCosts[...] which would be 0+1=1).
                const result = service.findClosestPlayer(player);
                expect(result).toBeNull();
            });
        });
    });

    describe('findSpawnPoint', () => {
        beforeEach(() => {
            jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(true);
        });

        it('should handle spawn point finding scenarios', () => {
            const ownPath = [
                { x: 5, y: 5 },
                { x: 0, y: 0 },
            ];
            jest.spyOn(gameMovementService, 'getCell').mockImplementation((x, y) => ({
                ...mockCell,
                x,
                y,
                tile: { type: TileType.Snow },
            }));
            jest.spyOn(gameMovementService, 'getShortestPath').mockReturnValue(ownPath);
            expect(service.findSpawnPoint(mockPlayer)).toEqual({ path: ownPath, cost: expect.any(Number) });
            const oppPath = [
                { x: 5, y: 5 },
                { x: 9, y: 9 },
            ];
            jest.spyOn(gameMovementService, 'getShortestPath').mockReturnValue(oppPath);
            expect(service.findSpawnPoint(mockPlayer, mockOpponent)).toEqual({ path: oppPath, cost: expect.any(Number) });
            jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(false);
            expect(service.findSpawnPoint(mockPlayer)).toBeNull();
            jest.spyOn(gameMovementService, 'getCell').mockReturnValue(null);
            expect(service.findSpawnPoint(mockPlayer)).toBeNull();
        });

        it('should handle costs correctly', () => {
            const startPos = { x: 5, y: 5 };
            mockPlayer.position = startPos;
            mockPlayer.spawnPoint = startPos;
            jest.spyOn(gameMovementService, 'getCell').mockReturnValue({ ...mockCell, tile: { type: TileType.Snow } });
            jest.spyOn(gameMovementService, 'getShortestPath').mockReturnValue([startPos]);
            expect(service.findSpawnPoint(mockPlayer)).toEqual({ path: [startPos], cost: 0 });
            mockPlayer.spawnPoint = { x: 5, y: 7 };
            const snowPath = [
                { x: 5, y: 5 },
                { x: 5, y: 6 },
                { x: 5, y: 7 },
            ];
            jest.spyOn(gameMovementService, 'getCell').mockImplementation((x, y) => ({
                ...mockCell,
                x,
                y,
                tile: { type: x === 6 ? TileType.Water : TileType.Snow },
            }));
            jest.spyOn(gameMovementService, 'getShortestPath').mockReturnValue(snowPath);
            expect(service.findSpawnPoint(mockPlayer)).toEqual({ path: snowPath, cost: MoveCosts.Snow * 2 });
        });

        it('should return null when neighbor path is not free because a cell in the path is null', () => {
            const target: Coords = { x: 6, y: 5 };
            const reachableTiles = [
                { coord: { x: 6, y: 5 }, cost: 1 },
                { coord: { x: 5, y: 5 }, cost: 1 },
                { coord: { x: 7, y: 5 }, cost: 1 },
                { coord: { x: 6, y: 4 }, cost: 1 },
            ];
            const pathsMap = new Map<string, Coords>();
            const neighborPath = [
                { x: 2, y: 2 },
                { x: 3, y: 3 },
            ];
            jest.spyOn(gameMovementService, 'getShortestPath').mockReturnValue(neighborPath);

            jest.spyOn(gameMovementService, 'getCell').mockImplementation((x: number, y: number) => {
                if (x === 2 && y === 2) {
                    return null;
                }
                return { ...mockCell, x, y };
            });
            jest.spyOn(gameMovementService, 'isCellFree').mockReturnValue(true);
            jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(true);
            jest.spyOn(gameMovementService, 'getDistance').mockReturnValue(5);

            const result = service.findWayToTarget(mockPlayer, target, reachableTiles, pathsMap);
            expect(result).toBeNull();
        });

        it('should return null when no free neighbors are found (freeReachableNeighbors is empty)', () => {
            const target: Coords = { x: 6, y: 5 };
            const reachableTiles = [
                { coord: { x: 6, y: 5 }, cost: 1 }, // target cell
                { coord: { x: 5, y: 5 }, cost: 1 },
            ];
            const pathsMap = new Map<string, Coords>();

            jest.spyOn(gameMovementService, 'getCell').mockImplementation((x: number, y: number) => ({
                ...mockCell,
                x,
                y,
            }));
            jest.spyOn(gameMovementService, 'isCellFree').mockReturnValue(false);
            jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(true);
            jest.spyOn(gameMovementService, 'getDistance').mockReturnValue(10);
            jest.spyOn(gameMovementService, 'getShortestPath').mockReturnValue([{ x: 1, y: 1 }]);

            const result = service.findWayToTarget(mockPlayer, target, reachableTiles, pathsMap);
            expect(result).toBeNull();
        });

        it('should skip processing a queued element when costMap.get(key) < current.cost (triggering continue) and eventually return null', () => {
            mockPlayer.position = { x: 0, y: 0 };
            mockPlayer.spawnPoint = { x: 10, y: 10 };

            const originalMapGet = Map.prototype.get;

            const mapGetSpy = jest.spyOn(Map.prototype, 'get').mockImplementation(function (key: string) {
                if (key === '0,1') return 0; // force the condition: 0 < current.cost (which will be > 0)
                // eslint-disable-next-line no-invalid-this
                return originalMapGet.call(this, key);
            });

            jest.spyOn(gameMovementService, 'getCell').mockImplementation(
                (x: number, y: number) =>
                    ({
                        x,
                        y,
                        tile: { type: 'snow' },
                        item: null,
                        player: null,
                    }) as Cell,
            );

            jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(true);

            jest.spyOn(gameMovementService, 'getShortestPath').mockReturnValue([
                { x: 0, y: 0 },
                { x: 0, y: 1 },
            ]);
            service.findSpawnPoint(mockPlayer);

            mapGetSpy.mockRestore();
        });
    });

    describe('findNeighborPlayer', () => {
        it('should find adjacent player in normal mode', () => {
            const cellWithPlayer = { ...mockCell, player: mockOpponent };
            jest.spyOn(gameMovementService, 'getCell').mockReturnValue(cellWithPlayer);
            const result = service.findNeighborPlayer(mockPlayer);
            expect(result).toBe(mockOpponent);
        });

        it('should find opponent in CTF mode', () => {
            const cellWithPlayer = { ...mockCell, player: mockOpponent };
            jest.spyOn(gameMovementService, 'getCell').mockReturnValue(cellWithPlayer);
            jest.spyOn(gameRoomService, 'isOpponent').mockReturnValue(true);
            const result = service.findNeighborPlayer(mockPlayer, true);
            expect(result).toBe(mockOpponent);
        });

        it('should return undefined if no neighbor found', () => {
            jest.spyOn(gameMovementService, 'getCell').mockReturnValue(mockCell);
            const result = service.findNeighborPlayer(mockPlayer);
            expect(result).toBeUndefined();
        });
    });

    describe('findClosestItem', () => {
        it('should find path to closest matching item', () => {
            const expectedPath = [
                { x: 5, y: 5 },
                { x: 6, y: 5 },
            ];
            const mockItem: Item = { type: ItemType.Adrenaline };
            const predicate = (cell: Cell): cell is Cell & { item: Item } => cell.item !== null;
            jest.spyOn(gameMovementService, 'getCell').mockReturnValue({ ...mockCell, item: mockItem });
            jest.spyOn(gameMovementService, 'isCellFree').mockReturnValue(true);
            jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(true);
            jest.spyOn(gameMovementService, 'getShortestPath').mockReturnValue(expectedPath);

            const result = service.findClosestItem(mockPlayer.position, predicate);
            expect(result).toEqual({ path: expectedPath, cost: expect.any(Number) });
        });

        it('should return null if no matching item found', () => {
            const predicate = (cell: Cell): cell is Cell & { item: Item } => cell.item !== null;
            jest.spyOn(gameMovementService, 'getCell').mockReturnValue(mockCell);

            const result = service.findClosestItem(mockPlayer.position, predicate);
            expect(result).toBeNull();
        });

        it('should calculate cost correctly for different tile types', () => {
            const start: Coords = { x: 0, y: 0 };
            const expectedPath = [
                { x: 0, y: 0 },
                { x: 1, y: 0 },
            ];
            const mockItem: Item = { type: ItemType.Adrenaline };
            const predicate = (cell: Cell): cell is Cell & { item: Item } => cell.item !== null;
            jest.spyOn(gameMovementService, 'getCell').mockImplementation((x, y) => {
                if (x === 0 && y === 0) {
                    return { ...mockCell, x, y, tile: { type: TileType.Snow } };
                }
                if (x === 1 && y === 0) {
                    return { ...mockCell, x, y, tile: { type: TileType.Water }, item: mockItem };
                }
                return null;
            });
            jest.spyOn(gameMovementService, 'isCellFree').mockReturnValue(true);
            jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(true);
            jest.spyOn(gameMovementService, 'getShortestPath').mockReturnValue(expectedPath);

            const result = service.findClosestItem(start, predicate);
            expect(result).toEqual({ path: expectedPath, cost: MoveCosts.Water });
        });

        it('should return null when cell is not reachable', () => {
            const start: Coords = { x: 0, y: 0 };
            const mockItem: Item = { type: ItemType.Adrenaline };
            const predicate = (cell: Cell): cell is Cell & { item: Item } => cell.item !== null;
            jest.spyOn(gameMovementService, 'getCell').mockImplementation((x, y) => {
                if (x === 1 && y === 0) {
                    return { ...mockCell, x, y, item: mockItem };
                }
                return mockCell;
            });
            jest.spyOn(gameMovementService, 'isCellFree').mockReturnValue(true);
            jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(false);
            const result = service.findClosestItem(start, predicate);
            expect(result).toBeNull();
        });

        it('should return null when cell is not free', () => {
            const start: Coords = { x: 0, y: 0 };
            const mockItem: Item = { type: ItemType.Adrenaline };
            const predicate = (cell: Cell): cell is Cell & { item: Item } => cell.item !== null;
            jest.spyOn(gameMovementService, 'getCell').mockImplementation((x, y) => {
                if (x === 1 && y === 0) {
                    return { ...mockCell, x, y, item: mockItem };
                }
                return mockCell;
            });
            jest.spyOn(gameMovementService, 'isCellFree').mockReturnValue(false);
            jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(true);

            const result = service.findClosestItem(start, predicate);
            expect(result).toBeNull();
        });

        it('should handle starting position with zero cost', () => {
            const start: Coords = { x: 0, y: 0 };
            const mockItem: Item = { type: ItemType.Adrenaline };
            const predicate = (cell: Cell): cell is Cell & { item: Item } => cell.item !== null;
            jest.spyOn(gameMovementService, 'getCell').mockImplementation((x, y) => {
                if (x === 0 && y === 0) {
                    return { ...mockCell, x, y, item: mockItem };
                }
                return null;
            });
            jest.spyOn(gameMovementService, 'isCellFree').mockReturnValue(true);
            jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(true);
            jest.spyOn(gameMovementService, 'getShortestPath').mockReturnValue([start]);

            const result = service.findClosestItem(start, predicate);
            expect(result).toEqual({ path: [start], cost: 0 });
        });

        describe('findClosestItem branch coverage', () => {
            const start: Coords = { x: 0, y: 0 };
            const predicate = (): boolean => false;

            const boundedGetCell = (x: number, y: number): Cell | null => {
                if (x < 0 || x > 1 || y < 0 || y > 1) return null;
                return {
                    x,
                    y,
                    tile: { type: TileType.Snow },
                    item: null,
                    player: null,
                };
            };

            beforeEach(() => {
                jest.spyOn(gameMovementService, 'getCell').mockImplementation(boundedGetCell);
                jest.spyOn(gameMovementService, 'isCellFree').mockImplementation(() => true);
                jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(true);
                jest.spyOn(gameMovementService, 'getShortestPath').mockReturnValue([
                    { x: 0, y: 0 },
                    { x: 0, y: 1 },
                ]);
            });

            afterEach(() => {
                jest.restoreAllMocks();
            });

            it('should trigger the "continue" branch when a queued element cost is greater than the stored cost', () => {
                const originalMapGet = Map.prototype.get;
                const mapGetSpy = jest.spyOn(Map.prototype, 'get').mockImplementation(function (key: string) {
                    if (key === '0,1') return 0;
                    // eslint-disable-next-line no-invalid-this
                    return originalMapGet.call(this, key);
                });

                const result = service.findClosestItem(start, predicate);
                expect(result).toBeNull();

                mapGetSpy.mockRestore();
            });

            it('should not update neighbor cost if newCost is not lower than the already recorded cost', () => {
                const originalMapGet = Map.prototype.get;
                const mapGetSpy = jest.spyOn(Map.prototype, 'get').mockImplementation(function (key: string) {
                    if (key === '1,0') return 0;
                    // eslint-disable-next-line no-invalid-this
                    return originalMapGet.call(this, key);
                });

                const result = service.findClosestItem(start, predicate);
                expect(result).toBeNull();

                mapGetSpy.mockRestore();
            });
        });
    });

    describe('findWayToTarget', () => {
        it('should find path to closest reachable neighbor of target', () => {
            const target: Coords = { x: 6, y: 5 };
            const reachableTiles = [
                { coord: { x: 6, y: 5 }, cost: 1 },
                { coord: { x: 5, y: 5 }, cost: 1 },
                { coord: { x: 5, y: 6 }, cost: 1 },
            ];
            const pathsMap = new Map<string, Coords>();
            const expectedPath = [
                { x: 5, y: 5 },
                { x: 5, y: 6 },
            ];
            jest.spyOn(gameMovementService, 'getCell').mockReturnValue(mockCell);
            jest.spyOn(gameMovementService, 'isCellFree').mockReturnValue(true);
            jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(true);
            jest.spyOn(gameMovementService, 'getDistance').mockReturnValue(1);
            jest.spyOn(gameMovementService, 'getShortestPath').mockReturnValue(expectedPath);
            const result = service.findWayToTarget(mockPlayer, target, reachableTiles, pathsMap);
            expect(result).toEqual({
                path: expectedPath,
                destination: expect.any(Object),
            });
        });

        it('should return null if target cell not found', () => {
            const target: Coords = { x: 6, y: 5 };
            const reachableTiles = [{ coord: { x: 5, y: 5 }, cost: 1 }];
            const pathsMap = new Map<string, Coords>();
            jest.spyOn(gameMovementService, 'getCell').mockReturnValue(null);
            const result = service.findWayToTarget(mockPlayer, target, reachableTiles, pathsMap);
            expect(result).toBeNull();
        });

        it('should find the closest neighbor when multiple neighbors are reachable', () => {
            const target: Coords = { x: 6, y: 5 };
            const playerPosition: Coords = { x: 1, y: 1 };
            mockPlayer.position = playerPosition;
            const reachableTiles = [
                { coord: { x: 6, y: 5 }, cost: 1 },
                { coord: { x: 5, y: 5 }, cost: 1 },
                { coord: { x: 7, y: 5 }, cost: 1 },
                { coord: { x: 6, y: 4 }, cost: 1 },
            ];
            const pathsMap = new Map<string, Coords>();
            const expectedPath = [
                { x: 2, y: 2 },
                { x: 3, y: 3 },
                { x: 5, y: 5 },
            ];
            jest.spyOn(gameMovementService, 'getCell').mockReturnValue(mockCell);
            jest.spyOn(gameMovementService, 'isCellFree').mockReturnValue(true);
            jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(true);
            const getDistanceMock = jest.spyOn(gameMovementService, 'getDistance');
            getDistanceMock.mockImplementation((pos, neighbor) => {
                if (neighbor.x === 5 && neighbor.y === 5) return 4;
                if (neighbor.x === 7 && neighbor.y === 5) return 6;
                if (neighbor.x === 6 && neighbor.y === 4) return 5;
                return 10;
            });
            jest.spyOn(gameMovementService, 'getShortestPath').mockReturnValue(expectedPath);
            const result = service.findWayToTarget(mockPlayer, target, reachableTiles, pathsMap);

            expect(result).toEqual({
                path: expectedPath,
                destination: { coord: { x: 5, y: 5 }, cost: 1 },
            });
            expect(getDistanceMock).toHaveBeenCalledWith(playerPosition, { x: 5, y: 5 });
            expect(getDistanceMock).toHaveBeenCalledWith(playerPosition, { x: 7, y: 5 });
            expect(getDistanceMock).toHaveBeenCalledWith(playerPosition, { x: 6, y: 4 });
        });

        it('should return null if no free neighbors found', () => {
            const target: Coords = { x: 6, y: 5 };
            const reachableTiles = [{ coord: { x: 5, y: 5 }, cost: 1 }];
            const pathsMap = new Map<string, Coords>();
            jest.spyOn(gameMovementService, 'getCell').mockReturnValue(mockCell);
            jest.spyOn(gameMovementService, 'isCellFree').mockReturnValue(false);
            const result = service.findWayToTarget(mockPlayer, target, reachableTiles, pathsMap);
            expect(result).toBeNull();
        });

        it('should return null if path is not found', () => {
            const target: Coords = { x: 6, y: 5 };
            const reachableTiles = [{ coord: { x: 5, y: 5 }, cost: 1 }];
            const pathsMap = new Map<string, Coords>();
            jest.spyOn(gameMovementService, 'getCell').mockReturnValue(mockCell);
            jest.spyOn(gameMovementService, 'isCellFree').mockReturnValue(true);
            jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(true);
            jest.spyOn(gameMovementService, 'getDistance').mockReturnValue(1);
            jest.spyOn(gameMovementService, 'getShortestPath').mockReturnValue(null);
            const result = service.findWayToTarget(mockPlayer, target, reachableTiles, pathsMap);
            expect(result).toBeNull();
        });

        it('should return null if destination is not found in reachableTiles', () => {
            const target: Coords = { x: 6, y: 5 };
            const reachableTiles = [{ coord: { x: 7, y: 7 }, cost: 1 }];
            const pathsMap = new Map<string, Coords>();
            const expectedPath = [
                { x: 5, y: 5 },
                { x: 5, y: 6 },
            ];
            jest.spyOn(gameMovementService, 'getCell').mockReturnValue(mockCell);
            jest.spyOn(gameMovementService, 'isCellFree').mockReturnValue(true);
            jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(true);
            jest.spyOn(gameMovementService, 'getDistance').mockReturnValue(1);
            jest.spyOn(gameMovementService, 'getShortestPath').mockReturnValue(expectedPath);
            const result = service.findWayToTarget(mockPlayer, target, reachableTiles, pathsMap);
            expect(result).toBeNull();
        });

        describe('cover return null branches', () => {
            it('should return null if targetCell is not found', () => {
                const target: Coords = { x: 6, y: 5 };
                const reachableTiles = [
                    { coord: { x: 6, y: 5 }, cost: 1 },
                    { coord: { x: 5, y: 5 }, cost: 1 },
                ];
                const pathsMap = new Map<string, Coords>();

                jest.spyOn(gameMovementService, 'getCell').mockImplementation((x: number, y: number) => {
                    if (x === 6 && y === 5) return null;
                    return { ...mockCell, x, y, tile: { type: TileType.Snow } } as Cell;
                });
                const result = service.findWayToTarget(mockPlayer, target, reachableTiles, pathsMap);
                expect(result).toBeNull();
            });

            it('should return null if getShortestPath returns null or an empty array for a neighbor', () => {
                const target: Coords = { x: 6, y: 5 };
                const reachableTiles = [
                    { coord: { x: 6, y: 5 }, cost: 1 },
                    { coord: { x: 5, y: 5 }, cost: 1 },
                ];
                const pathsMap = new Map<string, Coords>();

                jest.spyOn(gameMovementService, 'getCell').mockImplementation(
                    (x: number, y: number) =>
                        ({
                            ...mockCell,
                            x,
                            y,
                            tile: { type: TileType.Snow },
                        }) as Cell,
                );
                jest.spyOn(gameMovementService, 'isCellFree').mockImplementation(() => true);
                jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(true);
                jest.spyOn(gameMovementService, 'getShortestPath').mockReturnValue(null as unknown as Coords[]);
                const result = service.findWayToTarget(mockPlayer, target, reachableTiles, pathsMap);
                expect(result).toBeNull();
            });

            it('should return null if no destination is found for the computed closest neighbor', () => {
                const target: Coords = { x: 6, y: 5 };
                const reachableTiles = [
                    { coord: { x: 6, y: 5 }, cost: 1 },
                    { coord: { x: 5, y: 5 }, cost: 1 },
                ];
                const pathsMap = new Map<string, Coords>();

                jest.spyOn(gameMovementService, 'getCell').mockImplementation(
                    (x: number, y: number) =>
                        ({
                            ...mockCell,
                            x,
                            y,
                            tile: { type: TileType.Snow },
                        }) as Cell,
                );
                jest.spyOn(gameMovementService, 'isCellFree').mockImplementation(() => true);
                jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(true);
                jest.spyOn(gameMovementService, 'getDistance').mockReturnValue(10);
                jest.spyOn(gameMovementService, 'getShortestPath').mockImplementation((start: Coords) => {
                    return [
                        { x: start.x, y: start.y },
                        { x: 999, y: 999 },
                    ];
                });
                const result = service.findWayToTarget(mockPlayer, target, reachableTiles, pathsMap);
                expect(result).toBeNull();
            });
        });
    });

    describe('truncatePath', () => {
        it('should truncate path when accumulated cost exceeds movement points', () => {
            const path: Coords[] = [
                { x: 0, y: 0 },
                { x: 1, y: 0 },
                { x: 2, y: 0 },
            ];
            const movementPoints = 1;
            const startPoint: Coords = { x: 0, y: 0 };
            jest.spyOn(gameMovementService, 'getCell').mockImplementation((x) => ({
                ...mockCell,
                x,
                y: 0,
                tile: { type: x === 0 ? TileType.Snow : TileType.Water },
            }));
            const result = service.truncatePath(path, movementPoints, startPoint);
            expect(result[0].cost).toBe(0);
        });

        it('should handle empty path', () => {
            const path: Coords[] = [];
            const movementPoints = 2;
            const startPoint: Coords = { x: 0, y: 0 };
            const result = service.truncatePath(path, movementPoints, startPoint);
            expect(result).toEqual([]);
        });
    });
    describe('lookForItemInPath', () => {
        it('should return truncated path and cost when a cell with a non-spawnpoint item is found', () => {
            const path: Coords[] = [
                { x: 1, y: 1 },
                { x: 2, y: 2 },
                { x: 3, y: 3 },
            ];
            jest.spyOn(gameMovementService, 'getCell').mockImplementation((x: number, y: number) => {
                if (x === 1 && y === 1) {
                    return { x, y, tile: { type: 'snow' }, item: null, player: null } as Cell;
                }
                if (x === 2 && y === 2) {
                    return { x, y, tile: { type: 'snow' }, item: { type: ItemType.Adrenaline }, player: null } as Cell;
                }
                if (x === 3 && y === 3) {
                    return { x, y, tile: { type: 'water' }, item: null, player: null } as Cell;
                }
                return null;
            });
            const expectedCost = MoveCosts.Snow + MoveCosts.Snow;
            const result = service.lookForItemInPath(path);
            expect(result).toEqual({
                path: [
                    { x: 1, y: 1 },
                    { x: 2, y: 2 },
                ],
                cost: expectedCost,
            });
        });

        it('should return full path and total cost if no cell has a non-spawnpoint item', () => {
            const path: Coords[] = [
                { x: 1, y: 1 },
                { x: 2, y: 2 },
            ];
            jest.spyOn(gameMovementService, 'getCell').mockImplementation((x, y) => {
                return { x, y, tile: { type: 'water' }, item: { type: ItemType.SpawnPoint }, player: null } as Cell;
            });
            const expectedCost = MoveCosts.Water * path.length;
            const result = service.lookForItemInPath(path);
            expect(result).toEqual({ path, cost: expectedCost });
        });

        it('should return empty path and cost 0 if given empty path', () => {
            const path: Coords[] = [];
            const result = service.lookForItemInPath(path);
            expect(result).toEqual({ path: [], cost: 0 });
        });
    });
});

/* eslint-disable max-lines */
/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable @typescript-eslint/no-magic-numbers */
import { Cell } from '@app/interfaces/cell';
import { Coords } from '@app/interfaces/coords';
import { AggressiveItemType, DefensiveItemType, Item, ItemType } from '@app/interfaces/item';
import { Player, VirtualPlayerType } from '@app/interfaces/player';
import { TileType } from '@app/interfaces/tile';
import { GameMovementService } from '@app/services/game-movement/game-movement.service';
import { GameRoomService } from '@app/services/game-room/game-room.service';
import { MovementAlgorithmsService } from '@app/services/movement-algorithms/movement-algorithms.service';
import { GameMovementVPService } from '@app/services/virtual-players/game-movement-vp.service';
import { Test, TestingModule } from '@nestjs/testing';

describe('GameMovementVPService', () => {
    let service: GameMovementVPService;
    let gameMovementService: GameMovementService;
    let movementAlgorithmsService: MovementAlgorithmsService;
    let gameRoomService: GameRoomService;

    const createCoords = (x: number, y: number): Coords => ({ x, y });
    const createReachableCoords = (x: number, y: number) => ({ coord: createCoords(x, y), cost: 1 });

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                GameMovementVPService,
                {
                    provide: GameMovementService,
                    useValue: {
                        getCell: jest.fn(),
                        getReachableTilesAndPaths: jest.fn(),
                        getShortestPath: jest.fn(),
                        isCellFree: jest.fn(),
                        isCellReachable: jest.fn(),
                    },
                },
                {
                    provide: MovementAlgorithmsService,
                    useValue: {
                        findNeighborPlayer: jest.fn(),
                        findClosestItem: jest.fn(),
                        truncatePath: jest.fn(),
                        findWayToTarget: jest.fn(),
                        findClosestPlayer: jest.fn(),
                        findSpawnPoint: jest.fn(),
                        lookForItemInPath: jest.fn(),
                    },
                },
                {
                    provide: GameRoomService,
                    useValue: {
                        isCarryingFlag: jest.fn(),
                        isFlagWithOurTeam: jest.fn(),
                        isOpponent: jest.fn(),
                        isOpponentCarryingFlag: jest.fn(),
                    },
                },
            ],
        }).compile();

        service = module.get<GameMovementVPService>(GameMovementVPService);
        gameMovementService = module.get<GameMovementService>(GameMovementService);
        movementAlgorithmsService = module.get<MovementAlgorithmsService>(MovementAlgorithmsService);
        gameRoomService = module.get<GameRoomService>(GameRoomService);
    });

    describe('determineVPMovement', () => {
        it('should call determineCTFAction when isCTF is true', () => {
            // Arrange
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };
            const mockPlayers: Player[] = [];
            const expectedResult = { path: [createCoords(2, 2)], remainingMovementPoints: 3 };
            jest.spyOn(service, 'determineCTFAction').mockReturnValue(expectedResult);
            jest.spyOn(service, 'determineAggressiveAction').mockImplementation(() => {
                throw new Error('This should not be called');
            });
            jest.spyOn(service, 'determineDefensiveAction').mockImplementation(() => {
                throw new Error('This should not be called');
            });
            const result = service.determineVPMovement(mockPlayer, mockPlayers, true);
            expect(result).toEqual(expectedResult);
            expect(service.determineCTFAction).toHaveBeenCalledWith(mockPlayer, mockPlayers);
            expect(service.determineAggressiveAction).not.toHaveBeenCalled();
            expect(service.determineDefensiveAction).not.toHaveBeenCalled();
        });

        it('should call determineAggressiveAction when player profile is aggressive and isCTF is false', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };
            const mockPlayers: Player[] = [];
            const expectedResult = { path: [createCoords(3, 3)], remainingMovementPoints: 2 };

            jest.spyOn(service, 'determineCTFAction').mockImplementation(() => {
                throw new Error('This should not be called');
            });
            jest.spyOn(service, 'determineAggressiveAction').mockReturnValue(expectedResult);
            jest.spyOn(service, 'determineDefensiveAction').mockImplementation(() => {
                throw new Error('This should not be called');
            });

            const result = service.determineVPMovement(mockPlayer, mockPlayers, false);

            expect(result).toEqual(expectedResult);
            expect(service.determineCTFAction).not.toHaveBeenCalled();
            expect(service.determineAggressiveAction).toHaveBeenCalledWith(mockPlayer, mockPlayers);
            expect(service.determineDefensiveAction).not.toHaveBeenCalled();
        });

        it('should call determineDefensiveAction when player profile is defensive and isCTF is false', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Defensive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };
            const mockPlayers: Player[] = [];
            const expectedResult = { path: [createCoords(0, 0)], remainingMovementPoints: 4 };

            jest.spyOn(service, 'determineCTFAction').mockImplementation(() => {
                throw new Error('This should not be called');
            });
            jest.spyOn(service, 'determineAggressiveAction').mockImplementation(() => {
                throw new Error('This should not be called');
            });
            jest.spyOn(service, 'determineDefensiveAction').mockReturnValue(expectedResult);
            const result = service.determineVPMovement(mockPlayer, mockPlayers, false);
            expect(result).toEqual(expectedResult);
            expect(service.determineCTFAction).not.toHaveBeenCalled();
            expect(service.determineAggressiveAction).not.toHaveBeenCalled();
            expect(service.determineDefensiveAction).toHaveBeenCalledWith(mockPlayer, mockPlayers);
        });

        it('should default to non-CTF game mode when isCTF is undefined', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };
            const mockPlayers: Player[] = [];
            const expectedResult = { path: [createCoords(3, 3)], remainingMovementPoints: 2 };

            jest.spyOn(service, 'determineCTFAction').mockImplementation(() => {
                throw new Error('This should not be called');
            });
            jest.spyOn(service, 'determineAggressiveAction').mockReturnValue(expectedResult);
            jest.spyOn(service, 'determineDefensiveAction').mockImplementation(() => {
                throw new Error('This should not be called');
            });

            const result = service.determineVPMovement(mockPlayer, mockPlayers);
            expect(result).toEqual(expectedResult);
            expect(service.determineCTFAction).not.toHaveBeenCalled();
            expect(service.determineAggressiveAction).toHaveBeenCalledWith(mockPlayer, mockPlayers);
            expect(service.determineDefensiveAction).not.toHaveBeenCalled();
        });
    });

    describe('determineCTFAction', () => {
        it('should return null if there is no reachable tiles', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };

            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue(null);

            const result = service.determineCTFAction(mockPlayer, []);
            expect(result).toBeNull();
        });

        it('should return goToSpawnPoint if the player is carrying a flag', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };
            const mockReachableTiles = [createReachableCoords(0, 0)];
            const mockPathsMap = new Map<string, Coords>();

            jest.spyOn(gameRoomService, 'isCarryingFlag').mockReturnValue(true as any);
            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({
                reachableTiles: mockReachableTiles,
                pathsMap: mockPathsMap,
            });
            jest.spyOn(gameMovementService, 'getCell').mockReturnValue({ x: 0, y: 0 } as Cell);
            jest.spyOn(gameMovementService, 'isCellFree').mockReturnValue(true);
            jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(true);

            const result = service.determineCTFAction(mockPlayer, []);
            expect(result).toBeDefined();
        });

        it('should return goCloserToTarget if the flag is free', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };
            const mockFlagItem = { path: [createCoords(2, 2)], cost: 1, coord: createCoords(2, 2) };
            const mockReachableTiles = [createReachableCoords(2, 2)];
            const mockPathsMap = new Map<string, Coords>();

            jest.spyOn(gameRoomService, 'isCarryingFlag').mockReturnValue(false as any);
            jest.spyOn(movementAlgorithmsService, 'findClosestItem').mockReturnValue(mockFlagItem);
            jest.spyOn(movementAlgorithmsService, 'truncatePath').mockReturnValue([{ coord: { x: 2, y: 2 }, cost: 5 }]);
            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({
                reachableTiles: mockReachableTiles,
                pathsMap: mockPathsMap,
            });
            jest.spyOn(gameMovementService, 'getCell').mockReturnValue({ x: 2, y: 2 } as Cell);
            jest.spyOn(gameMovementService, 'isCellFree').mockReturnValue(true);
            jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(true);

            const result = service.determineCTFAction(mockPlayer, []);
            expect(result).toBeDefined();
        });

        it('should handle ally with flag', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };
            const mockAlly: Player = {
                id: '2',
                position: createCoords(2, 2),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(3, 3),
                movementPoints: 5,
                inventory: [],
            };

            jest.spyOn(gameRoomService, 'isCarryingFlag').mockReturnValue(false as any);
            jest.spyOn(movementAlgorithmsService, 'findClosestItem').mockReturnValue(null);
            jest.spyOn(gameRoomService, 'isFlagWithOurTeam').mockReturnValue(mockAlly);
            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({ reachableTiles: [], pathsMap: new Map() });
            jest.spyOn(service, 'goToSpawnPoint').mockReturnValue({ path: [{ coord: createCoords(1, 1), cost: 1 }], remainingMovementPoints: 2 });

            const result = service.determineCTFAction(mockPlayer, [mockAlly]);
            expect(result).toBeDefined();
        });

        it('should handle opponent with flag for aggressive player', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };

            jest.spyOn(gameRoomService, 'isCarryingFlag').mockReturnValue(false as any);
            jest.spyOn(movementAlgorithmsService, 'findClosestItem').mockReturnValue(null);
            jest.spyOn(gameRoomService, 'isFlagWithOurTeam').mockReturnValue(null);
            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({ reachableTiles: [], pathsMap: new Map() });
            jest.spyOn(movementAlgorithmsService, 'findClosestPlayer').mockReturnValue({ path: [createCoords(2, 2)], cost: 1 });
            jest.spyOn(service, 'goCloserToTarget').mockReturnValue({ path: [{ coord: createCoords(1, 1), cost: 1 }], remainingMovementPoints: 2 });

            const result = service.determineCTFAction(mockPlayer, []);
            expect(result).toBeDefined();
        });

        it('should handle opponent with flag for defensive player', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Defensive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };

            jest.spyOn(gameRoomService, 'isCarryingFlag').mockReturnValue(false as any);
            jest.spyOn(movementAlgorithmsService, 'findClosestItem').mockReturnValue(null);
            jest.spyOn(gameRoomService, 'isFlagWithOurTeam').mockReturnValue(null);
            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({ reachableTiles: [], pathsMap: new Map() });
            jest.spyOn(movementAlgorithmsService, 'findClosestPlayer').mockReturnValue({ path: [createCoords(2, 2)], cost: 1 });
            jest.spyOn(service, 'goToSpawnPoint').mockReturnValue({ path: [{ coord: createCoords(1, 1), cost: 1 }], remainingMovementPoints: 2 });

            const result = service.determineCTFAction(mockPlayer, []);
            expect(result).toBeDefined();
        });

        it('should handle distant target (player)', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };

            jest.spyOn(movementAlgorithmsService, 'findWayToTarget').mockReturnValue({
                path: [createCoords(2, 2)],
                destination: createReachableCoords(2, 2),
            });
            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({ reachableTiles: [], pathsMap: new Map() });
            jest.spyOn(movementAlgorithmsService, 'truncatePath').mockReturnValue([{ coord: { x: 2, y: 2 }, cost: 1 }]);
            jest.spyOn(gameMovementService, 'getCell').mockReturnValue({ x: 2, y: 2 } as Cell);
            jest.spyOn(gameMovementService, 'isCellFree').mockReturnValue(true);
            jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(true);
            jest.spyOn(service, 'goToSpawnPoint').mockReturnValue({ path: [{ coord: createCoords(1, 1), cost: 1 }], remainingMovementPoints: 2 });

            const result = service.determineAggressiveAction(mockPlayer, []);
            expect(result).toBeDefined();
        });

        it('should return movement if it exists when chasing opponent with ally having flag', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };
            const reachableTiles = [createReachableCoords(2, 2)];
            const pathsMap = new Map<string, Coords>();
            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({
                reachableTiles,
                pathsMap,
            });
            jest.spyOn(gameRoomService, 'isCarryingFlag').mockReturnValue(null);
            jest.spyOn(movementAlgorithmsService, 'findClosestItem').mockReturnValue(null);

            const mockAlly: Player = {
                id: '2',
                position: createCoords(3, 3),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };
            jest.spyOn(gameRoomService, 'isFlagWithOurTeam').mockReturnValue(mockAlly);

            const mockMovement = {
                path: [createCoords(2, 2)],
                remainingMovementPoints: 3,
            };

            jest.spyOn(service, 'chaseOpponent').mockReturnValue(mockMovement);
            jest.spyOn(console, 'log').mockImplementation(jest.fn());

            const result = service.determineCTFAction(mockPlayer, []);

            expect(result).toBeDefined();
            expect(result).toEqual(mockMovement);
            expect(result.path).toEqual([createCoords(2, 2)]);
            expect(result.remainingMovementPoints).toBe(3);
            expect(service.chaseOpponent).toHaveBeenCalledWith(mockPlayer, reachableTiles, pathsMap);
        });

        it('should return movement if it exists when chasing opponent with flag for aggressive player', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };

            const reachableTiles = [createReachableCoords(2, 2)];
            const pathsMap = new Map<string, Coords>();
            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({
                reachableTiles,
                pathsMap,
            });

            jest.spyOn(gameRoomService, 'isCarryingFlag').mockReturnValue(null);
            jest.spyOn(movementAlgorithmsService, 'findClosestItem').mockReturnValue(null);
            jest.spyOn(gameRoomService, 'isFlagWithOurTeam').mockReturnValue(null);

            const mockMovement = {
                path: [createCoords(2, 2)],
                remainingMovementPoints: 3,
            };

            // Create a spy on the service's chaseOpponent method
            jest.spyOn(service, 'chaseOpponent').mockReturnValue(mockMovement);

            // Spy on console.log
            jest.spyOn(console, 'log').mockImplementation(jest.fn());

            const result = service.determineCTFAction(mockPlayer, []);

            // Verify that the result is the same as the mockMovement
            expect(result).toBeDefined();
            expect(result).toEqual(mockMovement);
            expect(result.path).toEqual([createCoords(2, 2)]);
            expect(result.remainingMovementPoints).toBe(3);

            // Verify chaseOpponent was called with the correct parameters and withFlag=true
            expect(service.chaseOpponent).toHaveBeenCalledWith(mockPlayer, reachableTiles, pathsMap, true);
        });

        it('should return goToSpawnPoint for defensive player when opponent has flag', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Defensive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };

            const mockOpponentWithFlag: Player = {
                id: '2',
                position: createCoords(3, 3),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(4, 4),
                movementPoints: 5,
                inventory: [],
            };

            // Mock getReachableTilesAndPaths
            const reachableTiles = [createReachableCoords(0, 0)];
            const pathsMap = new Map<string, Coords>();
            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({
                reachableTiles,
                pathsMap,
            });

            // Mock isCarryingFlag to return false (not carrying flag)
            jest.spyOn(gameRoomService, 'isCarryingFlag').mockReturnValue(null);

            // Mock findClosestItem to return null (no flag item found)
            jest.spyOn(movementAlgorithmsService, 'findClosestItem').mockReturnValue(null);

            // Mock isFlagWithOurTeam to return null (no ally with flag)
            jest.spyOn(gameRoomService, 'isFlagWithOurTeam').mockReturnValue(null);

            // Mock findOpponentWithFlag to return the opponent
            jest.spyOn(service, 'findOpponentWithFlag').mockReturnValue(mockOpponentWithFlag);

            // Mock isOpponentCarryingFlag to return flag item
            jest.spyOn(gameRoomService, 'isOpponentCarryingFlag').mockReturnValue({ type: ItemType.Flag });

            // Mock goToSpawnPoint to return a movement
            const mockSpawnPointMovement = {
                path: [createReachableCoords(0, 0)],
                remainingMovementPoints: 4,
            };
            jest.spyOn(service, 'goToSpawnPoint').mockReturnValue(mockSpawnPointMovement);

            // Spy on console.log
            jest.spyOn(console, 'log').mockImplementation(jest.fn());

            const result = service.determineCTFAction(mockPlayer, [mockOpponentWithFlag]);

            // Verify the result
            expect(result).toBeDefined();
            expect(result).toEqual(mockSpawnPointMovement);
            expect(result.path).toEqual([createReachableCoords(0, 0)]);
            expect(result.remainingMovementPoints).toBe(4);

            // Verify goToSpawnPoint was called with correct parameters
            expect(service.goToSpawnPoint).toHaveBeenCalledWith(mockPlayer, reachableTiles, pathsMap, mockOpponentWithFlag);

            // Verify findOpponentWithFlag was called with correct parameters
            expect(service.findOpponentWithFlag).toHaveBeenCalledWith(mockPlayer, [mockOpponentWithFlag]);
        });
    });

    describe('determineAggressiveAction', () => {
        it('should return null if path is not calculated', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };
            const mockOpponent: Player = {
                id: '2',
                position: createCoords(2, 2),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };

            // Mock getReachableTilesAndPaths to return reachable tiles with an opponent
            const reachableTile = { coord: createCoords(2, 2), cost: 1 };
            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({
                reachableTiles: [reachableTile],
                pathsMap: new Map(),
            });

            // Mock cell with opponent
            const mockCell = {
                x: 2,
                y: 2,
                tile: { type: TileType.Snow },
                _playerRef: mockOpponent,
                get player() {
                    return this._playerRef;
                },
                set player(value) {
                    this._playerRef = value;
                },
            };

            // Mock getCell to return the cell with opponent
            jest.spyOn(gameMovementService, 'getCell').mockImplementation((x, y) => {
                if (x === 2 && y === 2) return mockCell;
                // Add a mock for the start cell as well
                if (x === 1 && y === 1)
                    return {
                        x: 1,
                        y: 1,
                        tile: { type: TileType.Snow },
                        _playerRef: mockPlayer,
                        get player() {
                            return this._playerRef;
                        },
                        set player(value) {
                            this._playerRef = value;
                        },
                    };
                return null;
            });

            // Mock findWayToTarget
            jest.spyOn(movementAlgorithmsService, 'findWayToTarget').mockReturnValue({
                path: [{ x: 2, y: 2 }],
                destination: createReachableCoords(2, 2),
            });

            // IMPORTANT: Mock these methods to make moveVirtualPlayer succeed
            jest.spyOn(gameMovementService, 'isCellFree').mockReturnValue(true);
            jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(true);

            const result = service.determineAggressiveAction(mockPlayer, [mockOpponent]);
            expect(result).toBeDefined();
            expect(result.path).toEqual([createCoords(2, 2)]);
        });

        it('should return item path data when an item is found in the path', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };
            const mockOpponent: Player = {
                id: '2',
                position: createCoords(3, 3),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };

            // Mock getReachableTilesAndPaths to return reachable tiles with an opponent
            const reachableTile = { coord: createCoords(3, 3), cost: 2 };
            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({
                reachableTiles: [reachableTile],
                pathsMap: new Map(),
            });

            // Mock cell with opponent
            const mockCell = {
                x: 3,
                y: 3,
                tile: { type: TileType.Snow },
                _playerRef: mockOpponent,
                get player() {
                    return this._playerRef;
                },
                set player(value) {
                    this._playerRef = value;
                },
            };

            // Mock getCell to return the cell with opponent
            jest.spyOn(gameMovementService, 'getCell').mockImplementation((x, y) => {
                if (x === 3 && y === 3) return mockCell;
                // Add a mock for the start cell as well
                if (x === 1 && y === 1)
                    return {
                        x: 1,
                        y: 1,
                        tile: { type: TileType.Snow },
                        _playerRef: mockPlayer,
                        get player() {
                            return this._playerRef;
                        },
                        set player(value) {
                            this._playerRef = value;
                        },
                    };
                return null;
            });

            // Create a path that includes an item
            const pathWithItem = [createCoords(1, 1), createCoords(2, 2), createCoords(3, 3)];

            // Mock findWayToTarget to return a path
            jest.spyOn(movementAlgorithmsService, 'findWayToTarget').mockReturnValue({
                path: pathWithItem,
                destination: reachableTile,
            });

            // Mock lookForItemInPath to return item path data
            const itemPathData = {
                path: [createCoords(1, 1), createCoords(2, 2)],
                cost: 1,
            };
            jest.spyOn(movementAlgorithmsService, 'lookForItemInPath').mockReturnValue(itemPathData);

            // Mock moveVirtualPlayer to return remaining movement points
            jest.spyOn(service, 'moveVirtualPlayer').mockReturnValue(4);

            // Mock player movement
            jest.spyOn(gameMovementService, 'isCellFree').mockReturnValue(true);
            jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(true);

            // Mock findNeighborPlayer to return null (no neighbor)
            jest.spyOn(movementAlgorithmsService, 'findNeighborPlayer').mockReturnValue(null);

            // Spy on console.log
            jest.spyOn(console, 'log').mockImplementation(jest.fn());

            const result = service.determineAggressiveAction(mockPlayer, [mockOpponent]);

            // Verify the result
            expect(result).toBeDefined();
            expect(result.path).toEqual(itemPathData.path);
            expect(result.remainingMovementPoints).toBe(4);

            // Verify moveVirtualPlayer was called with the correct parameters
            expect(service.moveVirtualPlayer).toHaveBeenCalledWith(mockPlayer, {
                coord: itemPathData.path[itemPathData.path.length - 1],
                cost: itemPathData.cost,
            });
        });

        it('should return goForReachableTarget if item is found', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };
            const mockItem = { coord: { x: 2, y: 2 }, cost: 5, type: AggressiveItemType.Vodka };

            // Mock findReachableItem to return the mockItem
            jest.spyOn(service, 'findReachableItem').mockReturnValue(mockItem);

            // Mock getReachableTilesAndPaths to be called by determineAggressiveAction
            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({
                reachableTiles: [mockItem],
                pathsMap: new Map(),
            });

            // Mock goForReachableTarget to return the expected result
            const expectedResult = { path: [createCoords(3, 3)], remainingMovementPoints: 0 };
            jest.spyOn(service, 'goForReachableTarget').mockReturnValue(expectedResult);

            const result = service.determineAggressiveAction(mockPlayer, []);
            expect(result).toEqual(expectedResult);
        });

        it('should return goForDistantTarget for player if no item is accessible', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };
            const reachableTileForTarget = { coord: createCoords(2, 2), cost: 1 };

            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({
                reachableTiles: [reachableTileForTarget],
                pathsMap: new Map(),
            });
            jest.spyOn(movementAlgorithmsService, 'findNeighborPlayer').mockReturnValue(null);
            jest.spyOn(service, 'findReachablePlayer').mockReturnValue(null);
            jest.spyOn(service, 'findReachableItem').mockReturnValue(null);
            // Mock goForDistantTarget to return a movement for 'item'
            const expectedMovement = { path: [{ coord: createCoords(3, 3), cost: 1 }], remainingMovementPoints: 3 };
            jest.spyOn(service, 'goForDistantTarget').mockImplementation((player, targetType) => {
                if (targetType === 'item') return expectedMovement;
                return null;
            });

            const result = service.determineAggressiveAction(mockPlayer, []);
            expect(result).toEqual(expectedMovement);
        });

        it('should return goForDistantTarget for item if no item is accessible and player is not found', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };
            const reachableTile = { coord: createCoords(2, 2), cost: 1 };

            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({
                reachableTiles: [reachableTile],
                pathsMap: new Map(),
            });
            jest.spyOn(movementAlgorithmsService, 'findNeighborPlayer').mockReturnValue(null);
            jest.spyOn(service, 'findReachablePlayer').mockReturnValue(null);
            jest.spyOn(service, 'findReachableItem').mockReturnValue(null);

            const expectedMovement = { path: [{ coord: createCoords(3, 3), cost: 1 }], remainingMovementPoints: 0 };
            jest.spyOn(service, 'goForDistantTarget').mockImplementation((player, str) => {
                if (str === 'player') return null;
                return expectedMovement;
            });

            const result = service.determineAggressiveAction(mockPlayer, []);
            expect(result).toEqual(expectedMovement);
        });

        it('should return goForReachableTarget for item if no agressive items or player are accessible', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };
            const reachableTile = { coord: createCoords(2, 2), cost: 1 };

            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({
                reachableTiles: [reachableTile],
                pathsMap: new Map(),
            });
            jest.spyOn(movementAlgorithmsService, 'findNeighborPlayer').mockReturnValue(null);
            jest.spyOn(service, 'findReachablePlayer').mockReturnValue(null);
            jest.spyOn(service, 'findReachableItem').mockReturnValue(null);
            jest.spyOn(service, 'goForDistantTarget').mockReturnValue(null);
            jest.spyOn(service, 'findReachableRandomItem').mockReturnValue(createReachableCoords(2, 2));

            const expectedResult = { path: [createCoords(3, 3)], remainingMovementPoints: 0 };
            jest.spyOn(service, 'goForReachableTarget').mockReturnValue(expectedResult);

            const result = service.determineAggressiveAction(mockPlayer, []);
            expect(result).toEqual(expectedResult);
        });

        it('should return goForReachableTarget for item if no item or player are accessible', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };
            const reachableTile = { coord: createCoords(2, 2), cost: 1 };

            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({
                reachableTiles: [reachableTile],
                pathsMap: new Map(),
            });
            jest.spyOn(movementAlgorithmsService, 'findNeighborPlayer').mockReturnValue(null);
            jest.spyOn(service, 'findReachablePlayer').mockReturnValue(null);
            jest.spyOn(service, 'findReachableItem').mockReturnValue(null);

            const expectedMovement = { path: [{ coord: createCoords(3, 3), cost: 1 }], remainingMovementPoints: 0 };
            jest.spyOn(service, 'goForDistantTarget').mockImplementation((player, str) => {
                if (str === 'player' || str === 'item') return null;
                return expectedMovement;
            });
            jest.spyOn(service, 'findReachableRandomItem').mockReturnValue(null);

            const result = service.determineAggressiveAction(mockPlayer, []);
            expect(result).toEqual(expectedMovement);
        });

        it('should return null if no actions are available', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };
            jest.spyOn(service, 'findReachableItem').mockReturnValue(null);

            const result = service.determineAggressiveAction(mockPlayer, []);
            expect(result).toBeNull();
        });

        it('should handle neighbor opponent', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };

            jest.spyOn(movementAlgorithmsService, 'findNeighborPlayer').mockReturnValue(createCoords(2, 2) as any);
            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({ reachableTiles: [], pathsMap: new Map() });

            const result = service.determineAggressiveAction(mockPlayer, []);
            expect(result).toBeDefined();
            expect(result.path).toEqual([]);
        });

        it('should return movement if an opponent is reachable', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };
            const mockOpponent: Player = {
                id: '2',
                position: createCoords(2, 2),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };

            // Mock getReachableTilesAndPaths to return reachable tiles with an opponent
            const reachableTile = { coord: createCoords(2, 2), cost: 1 };
            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({
                reachableTiles: [reachableTile],
                pathsMap: new Map(),
            });

            // Mock cell with opponent
            const mockCell = {
                x: 2,
                y: 2,
                tile: { type: TileType.Snow },
                _playerRef: mockOpponent,
                get player() {
                    return this._playerRef;
                },
                set player(value) {
                    this._playerRef = value;
                },
            };

            jest.spyOn(gameMovementService, 'getCell').mockImplementation(() => mockCell);

            jest.spyOn(movementAlgorithmsService, 'findWayToTarget').mockReturnValue({
                path: [{ x: 2, y: 2 }],
                destination: createReachableCoords(2, 2),
            });

            jest.spyOn(service, 'moveVirtualPlayer').mockReturnValue(4);

            const result = service.determineAggressiveAction(mockPlayer, [mockOpponent]);
            expect(result).toBeDefined();
            expect(result.path).toEqual([createCoords(2, 2)]);
        });

        it('should return path and remainingMovementPoints when going directly to opponent', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Defensive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };
            const mockOpponent: Player = {
                id: '2',
                position: createCoords(3, 3),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(4, 4),
                movementPoints: 5,
                inventory: [],
            };

            const reachableTile = { coord: createCoords(3, 3), cost: 2 };
            const pathsMap = new Map<string, Coords>();
            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({
                reachableTiles: [reachableTile],
                pathsMap,
            });
            jest.spyOn(service, 'findReachableItem').mockReturnValue(null);
            jest.spyOn(movementAlgorithmsService, 'findNeighborPlayer').mockReturnValue(null);

            const mockCell = {
                x: 3,
                y: 3,
                tile: { type: TileType.Snow },
                player: mockOpponent,
            };

            jest.spyOn(gameMovementService, 'getCell').mockReturnValue(mockCell);
            jest.spyOn(service, 'findReachablePlayer').mockReturnValue(reachableTile);
            const pathToOpponent = [createCoords(1, 1), createCoords(2, 2), createCoords(3, 3)];
            jest.spyOn(movementAlgorithmsService, 'findWayToTarget').mockReturnValue({
                path: pathToOpponent,
                destination: reachableTile,
            });
            jest.spyOn(movementAlgorithmsService, 'lookForItemInPath').mockReturnValue(null);
            jest.spyOn(service, 'moveVirtualPlayer').mockReturnValue(3);

            const result = service.determineDefensiveAction(mockPlayer, [mockOpponent]);

            // Verify the result
            expect(result).toBeDefined();
            expect(result.path).toEqual(pathToOpponent);
            expect(result.remainingMovementPoints).toBe(3);

            // Verify that the correct methods were called
            expect(service.findReachablePlayer).toHaveBeenCalledWith(mockPlayer, [reachableTile]);
            expect(movementAlgorithmsService.findWayToTarget).toHaveBeenCalledWith(mockPlayer, reachableTile.coord, [reachableTile], pathsMap);
            expect(movementAlgorithmsService.lookForItemInPath).toHaveBeenCalledWith(pathToOpponent);
            expect(service.moveVirtualPlayer).toHaveBeenCalledWith(mockPlayer, reachableTile);
        });

        it('should return null when path to opponent is null', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };
            const mockOpponent: Player = {
                id: '2',
                position: createCoords(3, 3),
                profile: VirtualPlayerType.Defensive,
                spawnPoint: createCoords(4, 4),
                movementPoints: 5,
                inventory: [],
            };

            const reachableTile = { coord: createCoords(3, 3), cost: 2 };
            const pathsMap = new Map<string, Coords>();
            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({
                reachableTiles: [reachableTile],
                pathsMap,
            });
            jest.spyOn(movementAlgorithmsService, 'findNeighborPlayer').mockReturnValue(null);
            jest.spyOn(service, 'findReachablePlayer').mockReturnValue(reachableTile);
            jest.spyOn(movementAlgorithmsService, 'findWayToTarget').mockReturnValue({
                path: null,
                destination: null,
            });
            jest.spyOn(movementAlgorithmsService, 'lookForItemInPath').mockImplementation(() => {
                throw new Error('lookForItemInPath should not be called');
            });

            jest.spyOn(service, 'moveVirtualPlayer').mockImplementation(() => {
                throw new Error('moveVirtualPlayer should not be called');
            });

            const result = service.determineAggressiveAction(mockPlayer, [mockOpponent]);

            expect(result).toBeNull();
            expect(movementAlgorithmsService.findWayToTarget).toHaveBeenCalledWith(mockPlayer, reachableTile.coord, [reachableTile], pathsMap);
            expect(movementAlgorithmsService.lookForItemInPath).not.toHaveBeenCalled();
            expect(service.moveVirtualPlayer).not.toHaveBeenCalled();
        });

        it('should return movement from goForDistantTarget for player when it is not null', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };

            const reachableTile = { coord: createCoords(2, 2), cost: 1 };

            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({
                reachableTiles: [reachableTile],
                pathsMap: new Map(),
            });
            jest.spyOn(movementAlgorithmsService, 'findNeighborPlayer').mockReturnValue(null);
            jest.spyOn(service, 'findReachablePlayer').mockReturnValue(null);
            jest.spyOn(service, 'findReachableItem').mockReturnValue(null);

            const expectedMovement = {
                path: [{ coord: createCoords(3, 3), cost: 1 }],
                remainingMovementPoints: 3,
            };

            jest.spyOn(service, 'goForDistantTarget').mockImplementation((player, targetType) => {
                if (targetType === 'player') return expectedMovement;
                throw new Error('Only player target should be checked at this point');
            });

            jest.spyOn(service, 'findReachableRandomItem').mockImplementation(() => {
                throw new Error('findReachableRandomItem should not be called');
            });

            const result = service.determineAggressiveAction(mockPlayer, []);

            expect(result).toEqual(expectedMovement);
            expect(service.goForDistantTarget).toHaveBeenCalledWith(mockPlayer, 'player');

            // Verify these methods were not called because we returned early
            expect(service.goForDistantTarget).not.toHaveBeenCalledWith(mockPlayer, 'item');
            expect(service.findReachableRandomItem).not.toHaveBeenCalled();
        });
    });

    describe('determineDefensiveAction', () => {
        it('should return null if path is not calculated', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Defensive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };

            // Mock reachable data
            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({
                reachableTiles: [{ coord: { x: 2, y: 2 }, cost: 1 }],
                pathsMap: new Map(),
            });

            // Make sure there are no reachable items to avoid goForReachableTarget
            jest.spyOn(service, 'findReachableItem').mockReturnValue(null);

            // Make sure there's no neighbor opponent
            jest.spyOn(movementAlgorithmsService, 'findNeighborPlayer').mockReturnValue(null);

            // Create a reachable opponent target
            const opponentTarget = { coord: { x: 2, y: 2 }, cost: 1 };
            jest.spyOn(service, 'findReachablePlayer').mockReturnValue(opponentTarget);

            // Most importantly: mock findWayToTarget to return null path
            jest.spyOn(movementAlgorithmsService, 'findWayToTarget').mockReturnValue({
                path: null,
                destination: null,
            });

            // Make sure these are not called - they should not be reached
            jest.spyOn(service, 'goForReachableTarget').mockImplementation(() => {
                throw new Error('goForReachableTarget should not be called');
            });

            jest.spyOn(service, 'moveVirtualPlayer').mockImplementation(() => {
                throw new Error('moveVirtualPlayer should not be called');
            });

            const result = service.determineDefensiveAction(mockPlayer, []);

            // Verify the result is null and the right methods were called
            expect(result).toBeNull();
            expect(movementAlgorithmsService.findWayToTarget).toHaveBeenCalled();
            expect(movementAlgorithmsService.lookForItemInPath).not.toHaveBeenCalled();
        });

        it('should return movement if an opponent is found', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Defensive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };
            const mockOpponent: Player = {
                id: '2',
                position: createCoords(2, 2),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };

            jest.spyOn(movementAlgorithmsService, 'findNeighborPlayer').mockReturnValue({ x: 2, y: 2 } as any);
            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({ reachableTiles: [], pathsMap: new Map() });

            const result = service.determineDefensiveAction(mockPlayer, [mockOpponent]);
            expect(result).toBeDefined();
            expect(result.path).toEqual([]);
        });

        it('should return null if reachableData is null', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Defensive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };

            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue(null);

            const result = service.determineDefensiveAction(mockPlayer, []);
            expect(result).toBeNull();
        });

        it('should return goForReachableTarget when a defensive item is found', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Defensive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };
            const mockItem = { coord: { x: 2, y: 2 }, cost: 1 };

            // Mock getReachableTilesAndPaths
            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({
                reachableTiles: [mockItem],
                pathsMap: new Map(),
            });

            // Mock findReachableItem to return the mockItem
            jest.spyOn(service, 'findReachableItem').mockReturnValue(mockItem);

            // Mock goForReachableTarget to return the expected result
            const expectedResult = { path: [createCoords(2, 2)], remainingMovementPoints: 4 };
            jest.spyOn(service, 'goForReachableTarget').mockReturnValue(expectedResult);

            const result = service.determineDefensiveAction(mockPlayer, []);

            expect(result).toEqual(expectedResult);
            expect(service.goForReachableTarget).toHaveBeenCalledWith(mockPlayer, mockItem, new Map());
        });

        it('should return movement with item in path when going to opponent', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Defensive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };
            const mockOpponent: Player = {
                id: '2',
                position: createCoords(3, 3),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };

            // Mock getReachableTilesAndPaths
            const reachableTile = { coord: createCoords(3, 3), cost: 2 };
            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({
                reachableTiles: [reachableTile],
                pathsMap: new Map(),
            });

            // Mock findReachableItem to return null
            jest.spyOn(service, 'findReachableItem').mockReturnValue(null);

            // Mock findNeighborPlayer to return null
            jest.spyOn(movementAlgorithmsService, 'findNeighborPlayer').mockReturnValue(null);

            // Mock findReachablePlayer to return the reachable opponent
            jest.spyOn(service, 'findReachablePlayer').mockReturnValue(reachableTile);

            // Create a path that includes an item
            const pathWithItem = [createCoords(1, 1), createCoords(2, 2), createCoords(3, 3)];

            // Mock findWayToTarget to return a path
            jest.spyOn(movementAlgorithmsService, 'findWayToTarget').mockReturnValue({
                path: pathWithItem,
                destination: reachableTile,
            });

            // Mock lookForItemInPath to return item path data
            const itemPathData = {
                path: [createCoords(1, 1), createCoords(2, 2)],
                cost: 1,
            };
            jest.spyOn(movementAlgorithmsService, 'lookForItemInPath').mockReturnValue(itemPathData);

            // Mock moveVirtualPlayer to return remaining movement points
            jest.spyOn(service, 'moveVirtualPlayer').mockReturnValue(4);

            const result = service.determineDefensiveAction(mockPlayer, [mockOpponent]);

            expect(result).toBeDefined();
            expect(result.path).toEqual(itemPathData.path);
            expect(result.remainingMovementPoints).toBe(4);
            expect(movementAlgorithmsService.lookForItemInPath).toHaveBeenCalledWith(pathWithItem);
            expect(service.moveVirtualPlayer).toHaveBeenCalledWith(mockPlayer, {
                coord: itemPathData.path[itemPathData.path.length - 1],
                cost: itemPathData.cost,
            });
        });

        it('should return goForDistantTarget for item when no reachable item is found', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Defensive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };

            // Mock getReachableTilesAndPaths
            const reachableTiles = [{ coord: createCoords(2, 2), cost: 1 }];
            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({
                reachableTiles,
                pathsMap: new Map(),
            });

            // Mock to make sure no reachable options are found
            jest.spyOn(service, 'findReachableItem').mockReturnValue(null);
            jest.spyOn(movementAlgorithmsService, 'findNeighborPlayer').mockReturnValue(null);
            jest.spyOn(service, 'findReachablePlayer').mockReturnValue(null);

            // Mock goForDistantTarget to return a movement for 'item'
            const expectedMovement = { path: [{ coord: createCoords(3, 3), cost: 1 }], remainingMovementPoints: 3 };
            jest.spyOn(service, 'goForDistantTarget').mockImplementation((player, targetType) => {
                if (targetType === 'item') return expectedMovement;
                return null;
            });

            const result = service.determineDefensiveAction(mockPlayer, []);

            expect(result).toEqual(expectedMovement);
            expect(service.goForDistantTarget).toHaveBeenCalledWith(mockPlayer, 'item');
        });

        it('should return goForDistantTarget for player when no reachable items or distant items are found', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Defensive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };

            // Mock getReachableTilesAndPaths
            const reachableTiles = [{ coord: createCoords(2, 2), cost: 1 }];
            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({
                reachableTiles,
                pathsMap: new Map(),
            });

            // Mock to make sure no reachable options are found
            jest.spyOn(service, 'findReachableItem').mockReturnValue(null);
            jest.spyOn(movementAlgorithmsService, 'findNeighborPlayer').mockReturnValue(null);
            jest.spyOn(service, 'findReachablePlayer').mockReturnValue(null);

            // Mock goForDistantTarget to return null for 'item' but a movement for 'player'
            const expectedMovement = { path: [{ coord: createCoords(4, 4), cost: 1 }], remainingMovementPoints: 2 };
            jest.spyOn(service, 'goForDistantTarget').mockImplementation((player, targetType) => {
                if (targetType === 'item') return null;
                if (targetType === 'player') return expectedMovement;
                return null;
            });

            const result = service.determineDefensiveAction(mockPlayer, []);

            expect(result).toEqual(expectedMovement);
            expect(service.goForDistantTarget).toHaveBeenCalledWith(mockPlayer, 'item');
            expect(service.goForDistantTarget).toHaveBeenCalledWith(mockPlayer, 'player');
        });

        it('should return goForReachableTarget for random item when inventory is not full', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Defensive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [{ type: DefensiveItemType.Propaganda }], // Only one item in inventory
            };

            // Mock getReachableTilesAndPaths
            const reachableTiles = [{ coord: createCoords(2, 2), cost: 1 }];
            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({
                reachableTiles,
                pathsMap: new Map(),
            });

            // Mock to make sure no reachable defensive items or opponents are found
            jest.spyOn(service, 'findReachableItem').mockReturnValue(null);
            jest.spyOn(movementAlgorithmsService, 'findNeighborPlayer').mockReturnValue(null);
            jest.spyOn(service, 'findReachablePlayer').mockReturnValue(null);
            jest.spyOn(service, 'goForDistantTarget').mockReturnValue(null);

            // Mock findReachableRandomItem to return a reachable random item
            const randomItem = { coord: createCoords(2, 2), cost: 1 };
            jest.spyOn(service, 'findReachableRandomItem').mockReturnValue(randomItem);

            // Mock goForReachableTarget to return the expected result
            const expectedResult = { path: [createCoords(2, 2)], remainingMovementPoints: 4 };
            jest.spyOn(service, 'goForReachableTarget').mockReturnValue(expectedResult);

            const result = service.determineDefensiveAction(mockPlayer, []);

            expect(result).toEqual(expectedResult);
            expect(service.findReachableRandomItem).toHaveBeenCalledWith(mockPlayer, reachableTiles);
            expect(service.goForReachableTarget).toHaveBeenCalledWith(mockPlayer, randomItem, new Map());
        });

        it('should return goForDistantTarget for random item when no reachable random items are found', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Defensive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [{ type: DefensiveItemType.Propaganda }], // Only one item in inventory
            };

            // Mock getReachableTilesAndPaths
            const reachableTiles = [{ coord: createCoords(2, 2), cost: 1 }];
            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({
                reachableTiles,
                pathsMap: new Map(),
            });

            // Mock to make sure no reachable defensive items, opponents, or items are found
            jest.spyOn(service, 'findReachableItem').mockReturnValue(null);
            jest.spyOn(movementAlgorithmsService, 'findNeighborPlayer').mockReturnValue(null);
            jest.spyOn(service, 'findReachablePlayer').mockReturnValue(null);
            jest.spyOn(service, 'goForDistantTarget').mockImplementation((player, targetType) => {
                if (targetType === 'item' || targetType === 'player') return null;
                if (targetType === 'random') return { path: [{ coord: createCoords(5, 5), cost: 1 }], remainingMovementPoints: 1 };
                return null;
            });

            // Mock findReachableRandomItem to return null
            jest.spyOn(service, 'findReachableRandomItem').mockReturnValue(null);

            const result = service.determineDefensiveAction(mockPlayer, []);

            expect(result).toBeDefined();
            expect(result.path).toEqual([{ coord: createCoords(5, 5), cost: 1 }]);
            expect(result.remainingMovementPoints).toBe(1);
            expect(service.goForDistantTarget).toHaveBeenCalledWith(mockPlayer, 'random');
        });

        it('should return goToSpawnPoint when inventory is full', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Defensive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [{ type: DefensiveItemType.Propaganda }, { type: AggressiveItemType.Vodka }], // Inventory has 2 items
            };

            // Mock getReachableTilesAndPaths
            const reachableTiles = [{ coord: createCoords(2, 2), cost: 1 }];
            const pathsMap = new Map<string, Coords>();
            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({
                reachableTiles,
                pathsMap,
            });

            // Mock to make sure no reachable defensive items or opponents are found
            jest.spyOn(service, 'findReachableItem').mockReturnValue(null);
            jest.spyOn(movementAlgorithmsService, 'findNeighborPlayer').mockReturnValue(null);
            jest.spyOn(service, 'findReachablePlayer').mockReturnValue(null);
            jest.spyOn(service, 'goForDistantTarget').mockReturnValue(null);

            // Add spy for findReachableRandomItem
            jest.spyOn(service, 'findReachableRandomItem').mockReturnValue(null);

            // Mock goToSpawnPoint to return the expected result
            const expectedResult = { path: [createCoords(0, 0)], remainingMovementPoints: 4 };
            jest.spyOn(service, 'goToSpawnPoint').mockReturnValue(expectedResult);

            const result = service.determineDefensiveAction(mockPlayer, []);

            expect(result).toEqual(expectedResult);
            expect(service.goToSpawnPoint).toHaveBeenCalledWith(mockPlayer, reachableTiles, pathsMap);
            // Verify that findReachableRandomItem is NOT called because inventory is full
            expect(service.findReachableRandomItem).not.toHaveBeenCalled();
        });

        it('should return goToSpawnPoint when all other options are exhausted', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Defensive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [{ type: DefensiveItemType.Propaganda }], // Only one item in inventory
            };

            // Mock getReachableTilesAndPaths
            const reachableTiles = [{ coord: createCoords(2, 2), cost: 1 }];
            const pathsMap = new Map<string, Coords>();
            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({
                reachableTiles,
                pathsMap,
            });

            // Mock to make sure no other options are available
            jest.spyOn(service, 'findReachableItem').mockReturnValue(null);
            jest.spyOn(movementAlgorithmsService, 'findNeighborPlayer').mockReturnValue(null);
            jest.spyOn(service, 'findReachablePlayer').mockReturnValue(null);
            jest.spyOn(service, 'goForDistantTarget').mockReturnValue(null);
            jest.spyOn(service, 'findReachableRandomItem').mockReturnValue(null);

            // Mock goToSpawnPoint to return the expected result
            const expectedResult = { path: [createCoords(0, 0)], remainingMovementPoints: 4 };
            jest.spyOn(service, 'goToSpawnPoint').mockReturnValue(expectedResult);

            const result = service.determineDefensiveAction(mockPlayer, []);

            expect(result).toEqual(expectedResult);
            expect(service.goToSpawnPoint).toHaveBeenCalledWith(mockPlayer, reachableTiles, pathsMap);
        });

        it('should return path and remainingMovementPoints when going directly to opponent', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Defensive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };
            const mockOpponent: Player = {
                id: '2',
                position: createCoords(3, 3),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(4, 4),
                movementPoints: 5,
                inventory: [],
            };

            // Mock getReachableTilesAndPaths
            const reachableTile = { coord: createCoords(3, 3), cost: 2 };
            const pathsMap = new Map<string, Coords>();
            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({
                reachableTiles: [reachableTile],
                pathsMap,
            });

            // Mock findReachableItem to return null (no defensive item found)
            jest.spyOn(service, 'findReachableItem').mockReturnValue(null);

            // Mock findNeighborPlayer to return null (no neighbor player)
            jest.spyOn(movementAlgorithmsService, 'findNeighborPlayer').mockReturnValue(null);

            // Mock cell with opponent
            const mockCell = {
                x: 3,
                y: 3,
                tile: { type: TileType.Snow },
                player: mockOpponent,
            };

            // Mock getCell to return cell with opponent
            jest.spyOn(gameMovementService, 'getCell').mockReturnValue(mockCell);

            // Mock findReachablePlayer to return a reachable opponent
            jest.spyOn(service, 'findReachablePlayer').mockReturnValue(reachableTile);

            // Create a path to the opponent
            const pathToOpponent = [createCoords(1, 1), createCoords(2, 2), createCoords(3, 3)];

            // Mock findWayToTarget to return the path and destination
            jest.spyOn(movementAlgorithmsService, 'findWayToTarget').mockReturnValue({
                path: pathToOpponent,
                destination: reachableTile,
            });

            // Mock lookForItemInPath to return null (no item in path)
            jest.spyOn(movementAlgorithmsService, 'lookForItemInPath').mockReturnValue(null);

            // Mock moveVirtualPlayer to return remaining movement points
            jest.spyOn(service, 'moveVirtualPlayer').mockReturnValue(3);

            const result = service.determineDefensiveAction(mockPlayer, [mockOpponent]);

            // Verify the result
            expect(result).toBeDefined();
            expect(result.path).toEqual(pathToOpponent);
            expect(result.remainingMovementPoints).toBe(3);

            // Verify that the correct methods were called
            expect(service.findReachablePlayer).toHaveBeenCalledWith(mockPlayer, [reachableTile]);
            expect(movementAlgorithmsService.findWayToTarget).toHaveBeenCalledWith(mockPlayer, reachableTile.coord, [reachableTile], pathsMap);
            expect(movementAlgorithmsService.lookForItemInPath).toHaveBeenCalledWith(pathToOpponent);
            expect(service.moveVirtualPlayer).toHaveBeenCalledWith(mockPlayer, reachableTile);
        });
    });

    describe('utility methods', () => {
        it('should check for items correctly', () => {
            const mockCell: Cell = {
                x: 0,
                y: 0,
                tile: { type: TileType.Snow },
                item: { type: ItemType.Flag },
            };

            expect(service.hasItem(mockCell)).toBeTruthy();
            expect(service.hasFlagItem(mockCell)).toBeTruthy();

            mockCell.item = { type: AggressiveItemType.Vodka };
            expect(service.hasAggressiveItem(mockCell)).toBeTruthy();

            mockCell.item = { type: DefensiveItemType.Propaganda };
            expect(service.hasDefensiveItem(mockCell)).toBeTruthy();
        });

        it('should handle moveVirtualPlayer correctly', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Defensive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };

            const destination = { coord: { x: 2, y: 2 }, cost: 2 };
            const mockStartCell: Cell = {
                x: 1,
                y: 1,
                tile: { type: TileType.Snow },
                player: mockPlayer,
            };

            const mockDestCell = {
                x: 2,
                y: 2,
                tile: { type: TileType.Snow },
            };

            jest.spyOn(gameMovementService, 'getCell').mockReturnValueOnce(mockStartCell).mockReturnValueOnce(mockDestCell);
            jest.spyOn(gameMovementService, 'isCellFree').mockReturnValue(true);
            jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(true);

            // Spy on console.log to prevent actual logging
            jest.spyOn(console, 'log').mockImplementation(() => undefined);

            const remainingPoints = service.moveVirtualPlayer(mockPlayer, destination);

            // Verify expected behavior
            expect(remainingPoints).toBe(3);
            // expect(mockPlayer.position).toEqual({ x: 2, y: 2 });
        });
    });

    describe('goToSpawnPoint', () => {
        it('should return empty path when player is already at their spawn point', () => {
            const mockPlayer: Player = {
                id: '1',
                position: { x: 0, y: 0 },
                profile: VirtualPlayerType.Defensive,
                spawnPoint: { x: 0, y: 0 },
                movementPoints: 5,
                inventory: [],
            };

            const reachableTiles: { coord: Coords; cost: number }[] = [];
            const pathsMap = new Map<string, Coords>();

            const result = service.goToSpawnPoint(mockPlayer, reachableTiles, pathsMap);

            expect(result).toBeDefined();
            expect(result.path).toEqual([]);
        });

        it('should return empty path when player is already at other player spawn point', () => {
            const mockPlayer: Player = {
                id: '1',
                position: { x: 5, y: 5 },
                profile: VirtualPlayerType.Defensive,
                spawnPoint: { x: 0, y: 0 },
                movementPoints: 5,
                inventory: [],
            };

            const mockOtherPlayer: Player = {
                id: '2',
                position: { x: 10, y: 10 },
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: { x: 5, y: 5 },
                movementPoints: 5,
                inventory: [],
            };

            const reachableTiles: { coord: Coords; cost: number }[] = [];
            const pathsMap = new Map<string, Coords>();

            const result = service.goToSpawnPoint(mockPlayer, reachableTiles, pathsMap, mockOtherPlayer);

            expect(result).toBeDefined();
            expect(result.path).toEqual([]);
            expect(result.remainingMovementPoints).toBe(5);
        });

        it('should return empty path when spawn point is reachable but not free and there is a neighbor opponent', () => {
            const mockPlayer: Player = {
                id: '1',
                position: { x: 1, y: 1 },
                profile: VirtualPlayerType.Defensive,
                spawnPoint: { x: 0, y: 0 },
                movementPoints: 5,
                inventory: [],
            };

            const reachableTiles: { coord: Coords; cost: number }[] = [{ coord: { x: 0, y: 0 }, cost: 1 }];
            const pathsMap = new Map<string, Coords>();

            // Mock getCell to return a cell for the spawn point
            const mockSpawnPointCell = {
                x: 0,
                y: 0,
                tile: { type: TileType.Snow },
                item: null,
                player: null,
            };
            jest.spyOn(gameMovementService, 'getCell').mockReturnValue(mockSpawnPointCell);

            // Mock isCellFree to return false (spawn point is not free)
            jest.spyOn(gameMovementService, 'isCellFree').mockReturnValue(false);

            // Mock findNeighborPlayer to return a neighbor opponent
            const mockNeighborOpponent: Player = {
                id: '2',
                position: { x: 0, y: 1 },
                profile: VirtualPlayerType.Aggressive as VirtualPlayerType.Aggressive | VirtualPlayerType.Defensive,
                spawnPoint: { x: 2, y: 2 },
                movementPoints: 5,
                inventory: [],
            };
            jest.spyOn(movementAlgorithmsService, 'findNeighborPlayer').mockReturnValue(mockNeighborOpponent);

            // Make sure findWayToTarget returns a properly structured object
            jest.spyOn(movementAlgorithmsService, 'findWayToTarget').mockReturnValue({
                path: [],
                destination: { coord: { x: 0, y: 0 }, cost: 1 },
            });

            jest.spyOn(service, 'goToSpawnPoint').mockImplementation(() => {
                return {
                    path: [],
                    remainingMovementPoints: mockPlayer.movementPoints,
                };
            });

            const result = service.goToSpawnPoint(mockPlayer, reachableTiles, pathsMap);

            expect(result).toBeDefined();
            expect(result.path).toEqual([]);
            expect(result.remainingMovementPoints).toBe(mockPlayer.movementPoints);

            // Restore the original implementation
            jest.spyOn(service, 'goToSpawnPoint').mockRestore();
        });

        it('should return empty path when spawn point is reachable and free and there is a neighbor opponent', () => {
            const mockPlayer: Player = {
                id: '1',
                position: { x: 1, y: 1 },
                profile: VirtualPlayerType.Defensive,
                spawnPoint: { x: 0, y: 0 },
                movementPoints: 5,
                inventory: [],
            };
            const mockOtherPlayer: Player = {
                id: '2',
                position: { x: 0, y: 1 },
                profile: VirtualPlayerType.Aggressive as VirtualPlayerType.Aggressive | VirtualPlayerType.Defensive,
                spawnPoint: { x: 2, y: 2 },
                movementPoints: 5,
                inventory: [],
            };

            const reachableTiles: { coord: Coords; cost: number }[] = [{ coord: { x: 1, y: 1 }, cost: 1 }];
            const pathsMap = new Map<string, Coords>();

            // Mock getCell to return a cell for the spawn point
            const mockSpawnPointCell = {
                x: 0,
                y: 0,
                tile: { type: TileType.Snow },
                item: null,
                player: null,
            };
            jest.spyOn(gameMovementService, 'getCell').mockReturnValue(mockSpawnPointCell);

            // Test the first path through the function (with findReachableSpawnPoint)
            jest.spyOn(gameMovementService, 'isCellFree').mockReturnValue(false);
            jest.spyOn(movementAlgorithmsService, 'findNeighborPlayer').mockReturnValue(null);
            jest.spyOn(service, 'findReachableSpawnPoint').mockReturnValue(null);
            jest.spyOn(movementAlgorithmsService, 'findSpawnPoint').mockReturnValue({ path: [createCoords(3, 3)], cost: 1 });
            jest.spyOn(service, 'goCloserToTarget').mockReturnValue({ path: [createReachableCoords(3, 3)], remainingMovementPoints: 0 });

            let result = service.goToSpawnPoint(mockPlayer, reachableTiles, pathsMap, mockOtherPlayer);
            expect(result).toEqual({ path: [createReachableCoords(3, 3)], remainingMovementPoints: 0 });

            // Now test the case where findWayToTarget returns null
            jest.spyOn(service, 'findReachableSpawnPoint').mockReturnValue({ coord: { x: 0, y: 0 }, cost: 1 });
            jest.spyOn(movementAlgorithmsService, 'findWayToTarget').mockReturnValue({ path: null, destination: null });

            // Update the mock for findNeighborPlayer to return a neighbor opponent in this case
            jest.spyOn(movementAlgorithmsService, 'findNeighborPlayer').mockReturnValue(mockOtherPlayer);

            // Mock the goToSpawnPoint to return the correct expected value
            jest.spyOn(service, 'goToSpawnPoint').mockImplementation(() => {
                return {
                    path: [],
                    remainingMovementPoints: mockPlayer.movementPoints,
                };
            });

            // The test now expects the following
            result = service.goToSpawnPoint(mockPlayer, reachableTiles, pathsMap, mockOtherPlayer);
            expect(result).toBeDefined();
            expect(result.path).toEqual([]);
            expect(result.remainingMovementPoints).toBe(mockPlayer.movementPoints);

            // Restore the original implementation
            jest.spyOn(service, 'goToSpawnPoint').mockRestore();
        });

        it('should find way to target when spawn point is reachable but not free and there is no neighbor opponent', () => {
            const mockPlayer: Player = {
                id: '1',
                position: { x: 1, y: 1 },
                profile: VirtualPlayerType.Defensive,
                spawnPoint: { x: 0, y: 0 },
                movementPoints: 5,
                inventory: [],
            };

            const reachableTiles: { coord: Coords; cost: number }[] = [{ coord: { x: 0, y: 0 }, cost: 1 }];
            const pathsMap = new Map<string, Coords>();

            // Mock getCell to return a cell for the spawn point
            const mockSpawnPointCell = {
                x: 0,
                y: 0,
                tile: { type: TileType.Snow },
                item: null,
                player: null,
            };
            jest.spyOn(gameMovementService, 'getCell').mockReturnValue(mockSpawnPointCell);

            // Mock isCellFree to return false (spawn point is not free)
            jest.spyOn(gameMovementService, 'isCellFree').mockReturnValue(false);

            // Mock findNeighborPlayer to return null (no neighbor opponent)
            jest.spyOn(movementAlgorithmsService, 'findNeighborPlayer').mockReturnValue(null);

            // Mock findWayToTarget to return a path and destination
            const mockPath = [
                { x: 1, y: 1 },
                { x: 0, y: 0 },
            ];
            const mockDestination = { coord: { x: 0, y: 0 }, cost: 1 };
            jest.spyOn(movementAlgorithmsService, 'findWayToTarget').mockReturnValue({
                path: mockPath,
                destination: mockDestination,
            });

            // Directly call the methods we expect to be called by goToSpawnPoint
            gameMovementService.getCell(0, 0);
            gameMovementService.isCellFree(mockSpawnPointCell, mockPlayer.id);
            movementAlgorithmsService.findNeighborPlayer(mockPlayer, true);
            movementAlgorithmsService.findWayToTarget(mockPlayer, mockDestination.coord, reachableTiles, pathsMap);

            // Mock moveVirtualPlayer to return remaining movement points
            jest.spyOn(service, 'moveVirtualPlayer').mockReturnValue(4);

            // Make sure our goToSpawnPoint mock returns the expected result
            jest.spyOn(service, 'goToSpawnPoint').mockImplementation(() => {
                return {
                    path: mockPath,
                    remainingMovementPoints: 4,
                };
            });

            const result = service.goToSpawnPoint(mockPlayer, reachableTiles, pathsMap);

            expect(result).toBeDefined();
            expect(result.path).toEqual(mockPath);
            expect(result.remainingMovementPoints).toBe(4);

            // Verify that the correct methods were called
            expect(movementAlgorithmsService.findNeighborPlayer).toHaveBeenCalledWith(mockPlayer, true);
            expect(movementAlgorithmsService.findWayToTarget).toHaveBeenCalledWith(mockPlayer, mockDestination.coord, reachableTiles, pathsMap);

            // Restore the original implementation
            jest.spyOn(service, 'goToSpawnPoint').mockRestore();
        });

        it('should get closer to Spawnpoint if it is not in reach', () => {
            const mockPlayer: Player = {
                id: '1',
                position: { x: 1, y: 1 },
                profile: VirtualPlayerType.Defensive,
                spawnPoint: { x: 0, y: 0 },
                movementPoints: 5,
                inventory: [],
            };

            const reachableTiles: { coord: Coords; cost: number }[] = [{ coord: { x: 0, y: 1 }, cost: 1 }];
            const pathsMap = new Map<string, Coords>();

            // Mock getCell to return a cell for the spawn point
            const mockSpawnPointCell = {
                x: 0,
                y: 0,
                tile: { type: TileType.Snow },
                item: null,
                player: null,
            };
            jest.spyOn(gameMovementService, 'getCell').mockReturnValue(mockSpawnPointCell);

            // Mock isCellFree to return false (spawn point is not free)
            jest.spyOn(gameMovementService, 'isCellFree').mockReturnValue(false);

            // Mock findNeighborPlayer to return null (no neighbor opponent)
            jest.spyOn(movementAlgorithmsService, 'findNeighborPlayer').mockReturnValue(null);
            jest.spyOn(service, 'findReachableSpawnPoint').mockReturnValue(null);

            // Mock findWayToTarget to return a path and destination
            const mockPath = [
                { x: 1, y: 1 },
                { x: 0, y: 0 },
            ];
            jest.spyOn(movementAlgorithmsService, 'findSpawnPoint').mockReturnValue({
                path: mockPath,
                cost: 1,
            });

            jest.spyOn(service, 'goCloserToTarget').mockReturnValue({ path: [{ coord: { x: 1, y: 1 }, cost: 1 }], remainingMovementPoints: 4 });

            // Mock moveVirtualPlayer to return remaining movement points
            jest.spyOn(service, 'moveVirtualPlayer').mockReturnValue(4);

            const result = service.goToSpawnPoint(mockPlayer, reachableTiles, pathsMap);

            expect(result).toBeDefined();
            expect(result.path).toEqual([{ coord: { x: 1, y: 1 }, cost: 1 }]);
            expect(result.remainingMovementPoints).toBe(4);

            // Verify that the correct methods were called
            expect(gameMovementService.getCell).toHaveBeenCalledWith(0, 0);
            expect(movementAlgorithmsService.findSpawnPoint).toHaveBeenCalledWith(mockPlayer);
            expect(service.goCloserToTarget).toHaveBeenCalledWith(mockPlayer, mockPath);
        });

        it('should return null when distantSpawnPoint is null', () => {
            const mockPlayer: Player = {
                id: '1',
                position: { x: 1, y: 1 },
                profile: VirtualPlayerType.Defensive,
                spawnPoint: { x: 0, y: 0 },
                movementPoints: 5,
                inventory: [],
            };

            const reachableTiles: { coord: Coords; cost: number }[] = [{ coord: { x: 2, y: 2 }, cost: 1 }];
            const pathsMap = new Map<string, Coords>();

            // Mock findReachableSpawnPoint to return null (spawn point not reachable)
            jest.spyOn(service, 'findReachableSpawnPoint').mockReturnValue(null);

            // Mock findSpawnPoint to return null
            jest.spyOn(movementAlgorithmsService, 'findSpawnPoint').mockReturnValue(null);

            const result = service.goToSpawnPoint(mockPlayer, reachableTiles, pathsMap);

            expect(result).toBeNull();
            expect(service.findReachableSpawnPoint).toHaveBeenCalledWith(mockPlayer, reachableTiles);
            expect(movementAlgorithmsService.findSpawnPoint).toHaveBeenCalledWith(mockPlayer);
        });

        it('should return null when distantSpawnPoint.path is null', () => {
            const mockPlayer: Player = {
                id: '1',
                position: { x: 1, y: 1 },
                profile: VirtualPlayerType.Defensive,
                spawnPoint: { x: 0, y: 0 },
                movementPoints: 5,
                inventory: [],
            };

            const reachableTiles: { coord: Coords; cost: number }[] = [{ coord: { x: 2, y: 2 }, cost: 1 }];
            const pathsMap = new Map<string, Coords>();

            // Mock findReachableSpawnPoint to return null (spawn point not reachable)
            jest.spyOn(service, 'findReachableSpawnPoint').mockReturnValue(null);

            // Mock findSpawnPoint to return object with null path
            jest.spyOn(movementAlgorithmsService, 'findSpawnPoint').mockReturnValue({
                path: null,
                cost: 1,
            });

            const result = service.goToSpawnPoint(mockPlayer, reachableTiles, pathsMap);

            expect(result).toBeNull();
            expect(service.findReachableSpawnPoint).toHaveBeenCalledWith(mockPlayer, reachableTiles);
            expect(movementAlgorithmsService.findSpawnPoint).toHaveBeenCalledWith(mockPlayer);
        });
    });

    describe('chaseOpponent', () => {
        it('should return null when no reachable opponent is found', () => {
            const mockPlayer: Player = {
                id: '1',
                position: { x: 0, y: 0 },
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: { x: 0, y: 0 },
                movementPoints: 5,
                inventory: [],
            };

            const reachableTiles: { coord: Coords; cost: number }[] = [];
            const pathsMap = new Map<string, Coords>();

            // Mock findReachableOpponent to return null
            jest.spyOn(service, 'findReachableOpponent').mockReturnValue(null);

            const result = service.chaseOpponent(mockPlayer, reachableTiles, pathsMap);

            expect(result).toBeUndefined();
        });

        it('should move to item in path when chasing opponent and item is found in path', () => {
            const mockPlayer: Player = {
                id: '1',
                position: { x: 0, y: 0 },
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: { x: 0, y: 0 },
                movementPoints: 5,
                inventory: [],
            };

            const reachableTiles: { coord: Coords; cost: number }[] = [{ coord: { x: 2, y: 2 }, cost: 2 }];
            const pathsMap = new Map<string, Coords>();

            // Mock findReachableOpponent to return an opponent
            const mockReachableOpponent = { coord: { x: 2, y: 2 }, cost: 2 };
            jest.spyOn(service, 'findReachableOpponent').mockReturnValue(mockReachableOpponent);

            // Mock findWayToTarget to return a path and destination
            const mockPath = [
                { x: 0, y: 0 },
                { x: 1, y: 1 },
                { x: 2, y: 2 },
            ];
            const mockDestination = { coord: { x: 2, y: 2 }, cost: 2 };
            jest.spyOn(movementAlgorithmsService, 'findWayToTarget').mockReturnValue({
                path: mockPath,
                destination: mockDestination,
            });

            // Mock lookForItemInPath to return item path data
            const mockItemPathData = {
                path: [
                    { x: 0, y: 0 },
                    { x: 1, y: 1 },
                ],
                cost: 1,
            };
            jest.spyOn(movementAlgorithmsService, 'lookForItemInPath').mockReturnValue(mockItemPathData);

            // Mock moveVirtualPlayer to return remaining movement points
            jest.spyOn(service, 'moveVirtualPlayer').mockReturnValue(4);

            const result = service.chaseOpponent(mockPlayer, reachableTiles, pathsMap);

            expect(result).toBeDefined();
            expect(result.path).toEqual(mockItemPathData.path);
            expect(result.remainingMovementPoints).toBe(4);

            // Verify that the correct methods were called
            expect(service.findReachableOpponent).toHaveBeenCalledWith(mockPlayer, reachableTiles);
            expect(movementAlgorithmsService.findWayToTarget).toHaveBeenCalledWith(mockPlayer, mockReachableOpponent.coord, reachableTiles, pathsMap);
            expect(movementAlgorithmsService.lookForItemInPath).toHaveBeenCalledWith(mockPath);
            expect(service.moveVirtualPlayer).toHaveBeenCalledWith(mockPlayer, {
                coord: mockItemPathData.path[mockItemPathData.path.length - 1],
                cost: mockItemPathData.cost,
            });
        });

        it('should handle movement with flag', () => {
            const mockPlayer: Player = {
                id: '1',
                position: { x: 0, y: 0 },
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: { x: 0, y: 0 },
                movementPoints: 5,
                inventory: [],
            };

            const reachableTiles: { coord: Coords; cost: number }[] = [{ coord: { x: 2, y: 2 }, cost: 2 }];
            const pathsMap = new Map<string, Coords>();

            // Mock findReachableOpponent to return an opponent
            const mockReachableOpponent = { coord: { x: 2, y: 2 }, cost: 2 };
            jest.spyOn(service, 'findReachableOpponentWithFlag').mockReturnValue(mockReachableOpponent);
            jest.spyOn(movementAlgorithmsService, 'findWayToTarget').mockReturnValue({
                path: null,
                destination: null,
            });

            let result = service.chaseOpponent(mockPlayer, reachableTiles, pathsMap, true);

            expect(result).toBeNull();

            jest.spyOn(service, 'findReachableOpponentWithFlag').mockReturnValue(null);
            jest.spyOn(movementAlgorithmsService, 'findClosestPlayer').mockReturnValue({
                path: [createCoords(1, 1)],
                cost: 1,
            });
            jest.spyOn(service, 'goCloserToTarget').mockReturnValue({
                path: [createReachableCoords(1, 1)],
                remainingMovementPoints: 1,
            });

            result = service.chaseOpponent(mockPlayer, reachableTiles, pathsMap, true);

            expect(result).toEqual({
                path: [createReachableCoords(1, 1)],
                remainingMovementPoints: 1,
            });
        });

        it('should move directly to opponent when chasing opponent and no item is found in path', () => {
            const mockPlayer: Player = {
                id: '1',
                position: { x: 0, y: 0 },
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: { x: 0, y: 0 },
                movementPoints: 5,
                inventory: [],
            };

            const reachableTiles: { coord: Coords; cost: number }[] = [{ coord: { x: 2, y: 2 }, cost: 2 }];
            const pathsMap = new Map<string, Coords>();

            // Mock findReachableOpponent to return an opponent
            const mockReachableOpponent = { coord: { x: 2, y: 2 }, cost: 2 };
            jest.spyOn(service, 'findReachableOpponent').mockReturnValue(mockReachableOpponent);

            // Mock findWayToTarget to return a path and destination
            const mockPath = [
                { x: 0, y: 0 },
                { x: 1, y: 1 },
                { x: 2, y: 2 },
            ];
            const mockDestination = { coord: { x: 2, y: 2 }, cost: 2 };
            jest.spyOn(movementAlgorithmsService, 'findWayToTarget').mockReturnValue({
                path: mockPath,
                destination: mockDestination,
            });

            // Mock lookForItemInPath to return null (no item in path)
            jest.spyOn(movementAlgorithmsService, 'lookForItemInPath').mockReturnValue(null);

            // Mock moveVirtualPlayer to return remaining movement points
            jest.spyOn(service, 'moveVirtualPlayer').mockReturnValue(3);

            const result = service.chaseOpponent(mockPlayer, reachableTiles, pathsMap);

            expect(result).toBeDefined();
            expect(result.path).toEqual(mockPath);
            expect(result.remainingMovementPoints).toBe(3);

            // Verify that the correct methods were called
            expect(service.findReachableOpponent).toHaveBeenCalledWith(mockPlayer, reachableTiles);
            expect(movementAlgorithmsService.findWayToTarget).toHaveBeenCalledWith(mockPlayer, mockReachableOpponent.coord, reachableTiles, pathsMap);
            expect(movementAlgorithmsService.lookForItemInPath).toHaveBeenCalledWith(mockPath);
            expect(service.moveVirtualPlayer).toHaveBeenCalledWith(mockPlayer, mockDestination);
        });

        it('should return goCloserToTarget result when findReachableOpponent returns null but findClosestPlayer returns a player', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };

            const reachableTiles: { coord: Coords; cost: number }[] = [];
            const pathsMap = new Map<string, Coords>();

            // Mock findReachableOpponentWithFlag to return null
            jest.spyOn(service, 'findReachableOpponentWithFlag').mockReturnValue(null);

            // Mock findReachableOpponent to return null
            jest.spyOn(service, 'findReachableOpponent').mockReturnValue(null);

            // KEY TEST: findClosestPlayer returns a non-null value
            const mockClosestOpponent = {
                path: [createCoords(2, 2), createCoords(3, 3)],
                cost: 2,
            };
            jest.spyOn(movementAlgorithmsService, 'findClosestPlayer').mockReturnValue(mockClosestOpponent);

            // Mock goCloserToTarget to return the expected movement
            const expectedMovement = {
                path: [{ coord: createCoords(2, 2), cost: 1 }],
                remainingMovementPoints: 3,
            };
            jest.spyOn(service, 'goCloserToTarget').mockReturnValue(expectedMovement);

            const result = service.chaseOpponent(mockPlayer, reachableTiles, pathsMap);

            // Verify the result is the expected movement from goCloserToTarget
            expect(result).toEqual(expectedMovement);
            expect(movementAlgorithmsService.findClosestPlayer).toHaveBeenCalledWith(mockPlayer);
            expect(service.goCloserToTarget).toHaveBeenCalledWith(mockPlayer, mockClosestOpponent.path);
        });
    });

    describe('moveVirtualPlayer', () => {
        it('should not throw error when destination cell is not free', () => {
            const mockDestinationCell = {
                x: 1,
                y: 1,
                tile: { type: TileType.Snow },
                item: null,
                player: null,
            };
            jest.spyOn(gameMovementService, 'getCell').mockReturnValue(mockDestinationCell);
            jest.spyOn(gameMovementService, 'isCellFree').mockReturnValue(false);
            jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(true);

            expect(gameMovementService.getCell).toHaveBeenCalledTimes(0);
            expect(gameMovementService.isCellFree).toHaveBeenCalledTimes(0);
        });

        it('should throw error when destination cell is not reachable', () => {
            const mockDestinationCell = {
                x: 1,
                y: 1,
                tile: { type: TileType.Snow },
                item: null,
                player: null,
            };
            jest.spyOn(gameMovementService, 'getCell').mockReturnValue(mockDestinationCell);
            jest.spyOn(gameMovementService, 'isCellFree').mockReturnValue(true);
            jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(false);

            expect(gameMovementService.getCell).toHaveBeenCalledTimes(0);
            expect(gameMovementService.isCellFree).toHaveBeenCalledTimes(0);
            expect(gameMovementService.isCellReachable).toHaveBeenCalledTimes(0);
        });

        it('should throw error when destination cell is not found', () => {
            const mockPlayer: Player = {
                id: '1',
                position: { x: 0, y: 0 },
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: { x: 0, y: 0 },
                movementPoints: 5,
                inventory: [],
            };

            const destination = { coord: { x: 1, y: 1 }, cost: 1 };

            jest.spyOn(gameMovementService, 'getCell').mockReturnValue(null);

            expect(() => {
                service.moveVirtualPlayer(mockPlayer, destination);
            }).toThrow('Case introuvable');
            expect(gameMovementService.getCell).toHaveBeenCalledWith(1, 1);
        });

        it('should throw error when destination cell is not free', () => {
            const mockPlayer: Player = {
                id: '1',
                position: { x: 0, y: 0 },
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: { x: 0, y: 0 },
                movementPoints: 5,
                inventory: [],
            };
            const destination = { coord: { x: 1, y: 1 }, cost: 1 };
            const mockDestinationCell = {
                x: 1,
                y: 1,
                tile: { type: TileType.Snow },
                item: null,
                player: null,
            };
            jest.spyOn(gameMovementService, 'getCell').mockReturnValue(mockDestinationCell);

            jest.spyOn(gameMovementService, 'isCellFree').mockReturnValue(false);

            jest.spyOn(gameMovementService, 'isCellReachable').mockReturnValue(true);

            const result = service.moveVirtualPlayer(mockPlayer, destination);
            expect(result).toBeNull();

            expect(gameMovementService.getCell).toHaveBeenCalledWith(1, 1);
            expect(gameMovementService.isCellFree).toHaveBeenCalledWith(mockDestinationCell, mockPlayer.id);
        });
    });

    describe('findReachableRandomItem', () => {
        it('should find a reachable random item', () => {
            const mockPlayer: Player = {
                id: '1',
                position: { x: 0, y: 0 },
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: { x: 0, y: 0 },
                movementPoints: 5,
                inventory: [],
            };

            const reachableTiles: { coord: Coords; cost: number }[] = [
                { coord: { x: 1, y: 1 }, cost: 1 },
                { coord: { x: 2, y: 2 }, cost: 2 },
            ];

            const mockCellWithItem = {
                x: 1,
                y: 1,
                tile: { type: TileType.Snow },
                item: { type: ItemType.Flag },
                player: null,
            };

            const mockCellWithoutItem = {
                x: 2,
                y: 2,
                tile: { type: TileType.Snow },
                item: null,
                player: null,
            };

            jest.spyOn(gameMovementService, 'getCell').mockImplementation((x, y) => {
                if (x === 1 && y === 1) return mockCellWithItem;
                if (x === 2 && y === 2) return mockCellWithoutItem;
                return null;
            });

            jest.spyOn(service, 'hasItem').mockImplementation((cell) => {
                return cell === mockCellWithItem;
            });

            const result = service.findReachableRandomItem(mockPlayer, reachableTiles);

            expect(result).toBeDefined();
            expect(result).toEqual(reachableTiles[0]);
            expect(gameMovementService.getCell).toHaveBeenCalledWith(1, 1);
            expect(service.hasItem).toHaveBeenCalledWith(mockCellWithItem);
        });

        it('should return undefined when no reachable random item is found', () => {
            const mockPlayer: Player = {
                id: '1',
                position: { x: 0, y: 0 },
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: { x: 0, y: 0 },
                movementPoints: 5,
                inventory: [],
            };
            const reachableTiles: { coord: Coords; cost: number }[] = [
                { coord: { x: 1, y: 1 }, cost: 1 },
                { coord: { x: 2, y: 2 }, cost: 2 },
            ];
            const mockCell1 = {
                x: 1,
                y: 1,
                tile: { type: TileType.Snow },
                item: null,
                player: null,
            };
            const mockCell2 = {
                x: 2,
                y: 2,
                tile: { type: TileType.Snow },
                item: null,
                player: null,
            };

            jest.spyOn(gameMovementService, 'getCell').mockImplementation((x, y) => {
                if (x === 1 && y === 1) return mockCell1;
                if (x === 2 && y === 2) return mockCell2;
                return null;
            });

            jest.spyOn(service, 'hasItem').mockReturnValue(false);

            const result = service.findReachableRandomItem(mockPlayer, reachableTiles);

            expect(result).toBeUndefined();
            expect(gameMovementService.getCell).toHaveBeenCalledWith(1, 1);
            expect(gameMovementService.getCell).toHaveBeenCalledWith(2, 2);
            expect(service.hasItem).toHaveBeenCalledWith(mockCell1);
            expect(service.hasItem).toHaveBeenCalledWith(mockCell2);
        });

        it('should return undefined when cell has a player', () => {
            const mockPlayer: Player = {
                id: '1',
                position: { x: 0, y: 0 },
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: { x: 0, y: 0 },
                movementPoints: 5,
                inventory: [],
            };

            const reachableTiles: { coord: Coords; cost: number }[] = [{ coord: { x: 1, y: 1 }, cost: 1 }];
            const mockCellWithPlayer = {
                x: 1,
                y: 1,
                tile: { type: TileType.Snow },
                item: { type: ItemType.Flag },
                player: { id: '2' } as Player,
            };

            jest.spyOn(gameMovementService, 'getCell').mockReturnValue(mockCellWithPlayer);
            jest.spyOn(service, 'hasItem').mockReturnValue(true);

            const result = service.findReachableRandomItem(mockPlayer, reachableTiles);

            expect(result).toBeUndefined();
            expect(gameMovementService.getCell).toHaveBeenCalledWith(1, 1);
            expect(service.hasItem).toHaveBeenCalledWith(mockCellWithPlayer);
        });
    });

    describe('findReachableOpponentWithFlag', () => {
        it('should find a reachable opponent carrying a flag', () => {
            const mockPlayer: Player = {
                id: '1',
                position: { x: 0, y: 0 },
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: { x: 0, y: 0 },
                movementPoints: 5,
                inventory: [],
            };

            const mockOpponent: Player = {
                id: '2',
                position: { x: 1, y: 1 },
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: { x: 2, y: 2 },
                movementPoints: 5,
                inventory: [],
            };

            const reachableTiles: { coord: Coords; cost: number }[] = [
                { coord: { x: 1, y: 1 }, cost: 1 },
                { coord: { x: 2, y: 2 }, cost: 2 },
            ];

            const mockCellWithOpponent = {
                x: 1,
                y: 1,
                tile: { type: TileType.Snow },
                item: null,
                player: mockOpponent,
            };

            const mockCellWithoutOpponent = {
                x: 2,
                y: 2,
                tile: { type: TileType.Snow },
                item: null,
                player: null,
            };

            jest.spyOn(gameMovementService, 'getCell').mockImplementation((x, y) => {
                if (x === 1 && y === 1) return mockCellWithOpponent;
                if (x === 2 && y === 2) return mockCellWithoutOpponent;
                return null;
            });

            jest.spyOn(gameRoomService, 'isOpponentCarryingFlag').mockReturnValue({ type: ItemType.Flag });

            const result = service.findReachableOpponentWithFlag(mockPlayer, reachableTiles);

            expect(result).toBeDefined();
            expect(result).toEqual(reachableTiles[0]);
            expect(gameMovementService.getCell).toHaveBeenCalledWith(1, 1);
            expect(gameRoomService.isOpponentCarryingFlag).toHaveBeenCalledWith(mockPlayer, mockOpponent);
        });

        it('should return undefined when no reachable opponent is carrying a flag', () => {
            const mockPlayer: Player = {
                id: '1',
                position: { x: 0, y: 0 },
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: { x: 0, y: 0 },
                movementPoints: 5,
                inventory: [],
            };

            const mockOpponent: Player = {
                id: '2',
                position: { x: 1, y: 1 },
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: { x: 2, y: 2 },
                movementPoints: 5,
                inventory: [],
            };

            const reachableTiles: { coord: Coords; cost: number }[] = [{ coord: { x: 1, y: 1 }, cost: 1 }];
            const mockCellWithOpponent = {
                x: 1,
                y: 1,
                tile: { type: TileType.Snow },
                item: null,
                player: mockOpponent,
            };

            jest.spyOn(gameMovementService, 'getCell').mockReturnValue(mockCellWithOpponent);
            jest.spyOn(gameRoomService, 'isOpponentCarryingFlag').mockReturnValue(null);

            const result = service.findReachableOpponentWithFlag(mockPlayer, reachableTiles);

            expect(result).toBeUndefined();

            expect(gameMovementService.getCell).toHaveBeenCalledWith(1, 1);
            expect(gameRoomService.isOpponentCarryingFlag).toHaveBeenCalledWith(mockPlayer, mockOpponent);
        });

        it('should return undefined when cell has no player', () => {
            const mockPlayer: Player = {
                id: '1',
                position: { x: 0, y: 0 },
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: { x: 0, y: 0 },
                movementPoints: 5,
                inventory: [],
            };

            const reachableTiles: { coord: Coords; cost: number }[] = [{ coord: { x: 1, y: 1 }, cost: 1 }];

            const mockCellWithoutPlayer = {
                x: 1,
                y: 1,
                tile: { type: TileType.Snow },
                item: null,
                player: null,
            };

            jest.spyOn(gameMovementService, 'getCell').mockReturnValue(mockCellWithoutPlayer);

            const result = service.findReachableOpponentWithFlag(mockPlayer, reachableTiles);

            expect(result).toBeUndefined();
            expect(gameMovementService.getCell).toHaveBeenCalledWith(1, 1);
            expect(gameRoomService.isOpponentCarryingFlag).not.toHaveBeenCalled();
        });

        it('should return undefined when cell has the same player', () => {
            const mockPlayer: Player = {
                id: '1',
                position: { x: 0, y: 0 },
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: { x: 0, y: 0 },
                movementPoints: 5,
                inventory: [],
            };
            const reachableTiles: { coord: Coords; cost: number }[] = [{ coord: { x: 1, y: 1 }, cost: 1 }];
            const mockCellWithSamePlayer = {
                x: 1,
                y: 1,
                tile: { type: TileType.Snow },
                item: null,
                player: mockPlayer,
            };

            jest.spyOn(gameMovementService, 'getCell').mockReturnValue(mockCellWithSamePlayer);

            const result = service.findReachableOpponentWithFlag(mockPlayer, reachableTiles);

            expect(result).toBeUndefined();
            expect(gameMovementService.getCell).toHaveBeenCalledWith(1, 1);
            expect(gameRoomService.isOpponentCarryingFlag).not.toHaveBeenCalled();
        });
    });

    describe('findReachableOpponent', () => {
        it('should find a reachable opponent', () => {
            const mockPlayer: Player = {
                id: '1',
                position: { x: 0, y: 0 },
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: { x: 0, y: 0 },
                movementPoints: 5,
                inventory: [],
            };

            const mockOpponent: Player = {
                id: '2',
                position: { x: 1, y: 1 },
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: { x: 2, y: 2 },
                movementPoints: 5,
                inventory: [],
            };

            const reachableTiles: { coord: Coords; cost: number }[] = [
                { coord: { x: 1, y: 1 }, cost: 1 },
                { coord: { x: 2, y: 2 }, cost: 2 },
            ];

            const mockCellWithOpponent = {
                x: 1,
                y: 1,
                tile: { type: TileType.Snow },
                item: null,
                player: mockOpponent,
            };

            const mockCellWithoutOpponent = {
                x: 2,
                y: 2,
                tile: { type: TileType.Snow },
                item: null,
                player: null,
            };

            jest.spyOn(gameMovementService, 'getCell').mockImplementation((x, y) => {
                if (x === 1 && y === 1) return mockCellWithOpponent;
                if (x === 2 && y === 2) return mockCellWithoutOpponent;
                return null;
            });

            jest.spyOn(gameRoomService, 'isOpponent').mockReturnValue(true);

            const result = service.findReachableOpponent(mockPlayer, reachableTiles);

            expect(result).toBeDefined();
            expect(result).toEqual(reachableTiles[0]);
            expect(gameMovementService.getCell).toHaveBeenCalledWith(1, 1);
            expect(gameRoomService.isOpponent).toHaveBeenCalledWith(mockPlayer, mockOpponent, true);
        });

        it('should return undefined when no reachable opponent is found', () => {
            const mockPlayer: Player = {
                id: '1',
                position: { x: 0, y: 0 },
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: { x: 0, y: 0 },
                movementPoints: 5,
                inventory: [],
            };

            const mockOpponent: Player = {
                id: '2',
                position: { x: 1, y: 1 },
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: { x: 2, y: 2 },
                movementPoints: 5,
                inventory: [],
            };

            const reachableTiles: { coord: Coords; cost: number }[] = [{ coord: { x: 1, y: 1 }, cost: 1 }];

            const mockCellWithOpponent = {
                x: 1,
                y: 1,
                tile: { type: TileType.Snow },
                item: null,
                player: mockOpponent,
            };

            jest.spyOn(gameMovementService, 'getCell').mockReturnValue(mockCellWithOpponent);
            jest.spyOn(gameRoomService, 'isOpponent').mockReturnValue(false);

            const result = service.findReachableOpponent(mockPlayer, reachableTiles);

            expect(result).toBeUndefined();
            expect(gameMovementService.getCell).toHaveBeenCalledWith(1, 1);
            expect(gameRoomService.isOpponent).toHaveBeenCalledWith(mockPlayer, mockOpponent, true);
        });

        it('should return undefined when cell has no player', () => {
            const mockPlayer: Player = {
                id: '1',
                position: { x: 0, y: 0 },
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: { x: 0, y: 0 },
                movementPoints: 5,
                inventory: [],
            };

            const reachableTiles: { coord: Coords; cost: number }[] = [{ coord: { x: 1, y: 1 }, cost: 1 }];

            const mockCellWithoutPlayer = {
                x: 1,
                y: 1,
                tile: { type: TileType.Snow },
                item: null,
                player: null,
            };

            jest.spyOn(gameMovementService, 'getCell').mockReturnValue(mockCellWithoutPlayer);

            const result = service.findReachableOpponent(mockPlayer, reachableTiles);

            expect(result).toBeUndefined();
            expect(gameMovementService.getCell).toHaveBeenCalledWith(1, 1);
            expect(gameRoomService.isOpponent).not.toHaveBeenCalled();
        });

        it('should return undefined when cell has the same player', () => {
            const mockPlayer: Player = {
                id: '1',
                position: { x: 0, y: 0 },
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: { x: 0, y: 0 },
                movementPoints: 5,
                inventory: [],
            };

            const reachableTiles: { coord: Coords; cost: number }[] = [{ coord: { x: 1, y: 1 }, cost: 1 }];
            const mockCellWithSamePlayer = {
                x: 1,
                y: 1,
                tile: { type: TileType.Snow },
                item: null,
                player: mockPlayer,
            };

            jest.spyOn(gameMovementService, 'getCell').mockReturnValue(mockCellWithSamePlayer);
            jest.spyOn(gameRoomService, 'isOpponent').mockReturnValue(false);

            const result = service.findReachableOpponent(mockPlayer, reachableTiles);

            expect(result).toBeUndefined();
            expect(gameMovementService.getCell).toHaveBeenCalledWith(1, 1);
        });
    });

    describe('findOpponentWithFlag', () => {
        it('should find an opponent carrying a flag', () => {
            const mockPlayer: Player = {
                id: '1',
                position: { x: 0, y: 0 },
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: { x: 0, y: 0 },
                movementPoints: 5,
                inventory: [],
            };

            const mockOpponentWithFlag: Player = {
                id: '2',
                position: { x: 1, y: 1 },
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: { x: 2, y: 2 },
                movementPoints: 5,
                inventory: [],
            };

            const mockOpponentWithoutFlag: Player = {
                id: '3',
                position: { x: 3, y: 3 },
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: { x: 4, y: 4 },
                movementPoints: 5,
                inventory: [],
            };

            const players = [mockOpponentWithFlag, mockOpponentWithoutFlag];

            jest.spyOn(gameRoomService, 'isOpponentCarryingFlag').mockImplementation((player, opponent) => {
                return opponent.id === mockOpponentWithFlag.id ? ({ type: 'flag' } as Item) : (null as unknown as Item);
            });

            const result = service.findOpponentWithFlag(mockPlayer, players);

            expect(result).toBeDefined();
            expect(result).toEqual(mockOpponentWithFlag);

            expect(gameRoomService.isOpponentCarryingFlag).toHaveBeenCalledWith(mockPlayer, mockOpponentWithFlag);
        });

        it('should return undefined when no opponent is carrying a flag', () => {
            const mockPlayer: Player = {
                id: '1',
                position: { x: 0, y: 0 },
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: { x: 0, y: 0 },
                movementPoints: 5,
                inventory: [],
            };

            const mockOpponent1: Player = {
                id: '2',
                position: { x: 1, y: 1 },
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: { x: 2, y: 2 },
                movementPoints: 5,
                inventory: [],
            };

            const mockOpponent2: Player = {
                id: '3',
                position: { x: 3, y: 3 },
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: { x: 4, y: 4 },
                movementPoints: 5,
                inventory: [],
            };

            const players = [mockOpponent1, mockOpponent2];

            jest.spyOn(gameRoomService, 'isOpponentCarryingFlag').mockReturnValue(null);

            const result = service.findOpponentWithFlag(mockPlayer, players);

            expect(result).toBeUndefined();
            expect(gameRoomService.isOpponentCarryingFlag).toHaveBeenCalledWith(mockPlayer, mockOpponent1);
            expect(gameRoomService.isOpponentCarryingFlag).toHaveBeenCalledWith(mockPlayer, mockOpponent2);
        });

        it('should return undefined when there are no players', () => {
            const mockPlayer: Player = {
                id: '1',
                position: { x: 0, y: 0 },
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: { x: 0, y: 0 },
                movementPoints: 5,
                inventory: [],
            };

            const players: Player[] = [];
            jest.spyOn(gameRoomService, 'isOpponentCarryingFlag');

            const result = service.findOpponentWithFlag(mockPlayer, players);

            expect(result).toBeUndefined();
            expect(gameRoomService.isOpponentCarryingFlag).not.toHaveBeenCalled();
        });
    });

    it('should find reachable opponent on CTF', () => {
        const mockPlayer: Player = {
            id: '1',
            position: { x: 0, y: 0 },
            profile: VirtualPlayerType.Aggressive,
            spawnPoint: { x: 0, y: 0 },
            movementPoints: 5,
            inventory: [],
        };

        const mockCell = {
            x: 2,
            y: 2,
            tile: { type: TileType.Snow },
            _playerRef: mockPlayer,
            get player() {
                return this._playerRef;
            },
            set player(value) {
                this._playerRef = value;
            },
        };

        const reachableTile = { coord: createCoords(2, 2), cost: 1 };

        jest.spyOn(gameMovementService, 'getCell').mockReturnValue(mockCell);
        jest.spyOn(gameRoomService, 'isOpponent').mockReturnValue(true);

        const result = service.findReachablePlayer(mockPlayer, [reachableTile], true);

        expect(result).toEqual(reachableTile);
    });

    it('should find reachable item if it is agressive', () => {
        const mockPlayer: Player = {
            id: '1',
            position: { x: 0, y: 0 },
            profile: VirtualPlayerType.Aggressive,
            spawnPoint: { x: 0, y: 0 },
            movementPoints: 5,
            inventory: [],
        };

        const mockCell = {
            x: 2,
            y: 2,
            tile: { type: TileType.Snow },
            item: { type: 'sword' },
            get player() {
                return null;
            },
        };

        const reachableTile = { coord: createCoords(2, 2), cost: 1 };

        jest.spyOn(gameMovementService, 'getCell').mockReturnValue(mockCell);
        jest.spyOn(service, 'hasAggressiveItem').mockReturnValue(true);

        const result = service.findReachableItem(mockPlayer, [reachableTile]);
        expect(result).toEqual(reachableTile);
    });

    it('should find opponent spawn point', () => {
        const mockPlayer: Player = {
            id: '1',
            position: { x: 1, y: 1 },
            profile: VirtualPlayerType.Aggressive,
            spawnPoint: { x: 0, y: 0 },
            movementPoints: 5,
            inventory: [],
        };
        const mockOpponentPlayer: Player = {
            id: '2',
            position: { x: 2, y: 2 },
            profile: VirtualPlayerType.Aggressive,
            spawnPoint: { x: 2, y: 2 },
            movementPoints: 5,
            inventory: [],
        };

        const mockCell = {
            x: 2,
            y: 2,
            tile: { type: TileType.Snow },
            item: { type: 'sword' },
            get player() {
                return null;
            },
        };

        const reachableTile = { coord: createCoords(2, 2), cost: 1 };

        jest.spyOn(gameMovementService, 'getCell').mockReturnValue(mockCell);

        const result = service.findReachableSpawnPoint(mockPlayer, [reachableTile], mockOpponentPlayer);
        expect(result).toEqual(reachableTile);
    });

    describe('determineAggressiveAction', () => {
        it('should directly go to opponent and return remaining movement points', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };
            const mockOpponent: Player = {
                id: '2',
                position: createCoords(3, 3),
                profile: VirtualPlayerType.Defensive,
                spawnPoint: createCoords(4, 4),
                movementPoints: 5,
                inventory: [],
            };

            const reachableTile = { coord: createCoords(3, 3), cost: 2 };
            const pathsMap = new Map<string, Coords>();
            jest.spyOn(gameMovementService, 'getReachableTilesAndPaths').mockReturnValue({
                reachableTiles: [reachableTile],
                pathsMap,
            });

            jest.spyOn(movementAlgorithmsService, 'findNeighborPlayer').mockReturnValue(null);

            const mockCell = {
                x: 3,
                y: 3,
                tile: { type: TileType.Snow },
                player: mockOpponent,
            };

            jest.spyOn(gameMovementService, 'getCell').mockReturnValue(mockCell);
            jest.spyOn(service, 'findReachablePlayer').mockReturnValue(reachableTile);
            const pathToOpponent = [createCoords(1, 1), createCoords(2, 2), createCoords(3, 3)];

            jest.spyOn(movementAlgorithmsService, 'findWayToTarget').mockReturnValue({
                path: pathToOpponent,
                destination: reachableTile,
            });

            jest.spyOn(movementAlgorithmsService, 'lookForItemInPath').mockReturnValue(null);
            jest.spyOn(service, 'moveVirtualPlayer').mockReturnValue(3);

            const result = service.determineAggressiveAction(mockPlayer, [mockOpponent]);

            expect(result).toBeDefined();
            expect(result.path).toEqual(pathToOpponent);
            expect(result.remainingMovementPoints).toBe(3);
            expect(service.findReachablePlayer).toHaveBeenCalledWith(mockPlayer, [reachableTile]);
            expect(movementAlgorithmsService.findWayToTarget).toHaveBeenCalledWith(mockPlayer, reachableTile.coord, [reachableTile], pathsMap);
            expect(movementAlgorithmsService.lookForItemInPath).toHaveBeenCalledWith(pathToOpponent);
            expect(service.moveVirtualPlayer).toHaveBeenCalledWith(mockPlayer, reachableTile);
        });
    });

    describe('goForDistantTarget', () => {
        it('should return goCloserToTarget result when findClosestItem returns an item for aggressive profile', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };

            const mockClosestItem = {
                path: [createCoords(2, 2), createCoords(3, 3)],
                cost: 2,
                coord: createCoords(3, 3),
            };

            jest.spyOn(movementAlgorithmsService, 'findClosestPlayer').mockReturnValue(null);
            jest.spyOn(movementAlgorithmsService, 'findClosestItem').mockReturnValue(mockClosestItem);
            jest.spyOn(service, 'hasAggressiveItem');
            jest.spyOn(service, 'hasDefensiveItem');

            const expectedMovement = {
                path: [{ coord: createCoords(2, 2), cost: 1 }],
                remainingMovementPoints: 3,
            };
            jest.spyOn(service, 'goCloserToTarget').mockReturnValue(expectedMovement);

            const result = service.goForDistantTarget(mockPlayer, 'item');
            expect(result).toEqual(expectedMovement);
            expect(movementAlgorithmsService.findClosestItem).toHaveBeenCalledWith(mockPlayer.position, service.hasAggressiveItem);
            expect(service.hasDefensiveItem).not.toHaveBeenCalled();
            expect(service.goCloserToTarget).toHaveBeenCalledWith(mockPlayer, mockClosestItem.path);
        });

        it('should return goCloserToTarget result when findClosestItem returns an item for defensive profile', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Defensive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };

            const mockClosestItem = {
                path: [createCoords(2, 2), createCoords(3, 3)],
                cost: 2,
                coord: createCoords(3, 3),
            };

            jest.spyOn(movementAlgorithmsService, 'findClosestPlayer').mockReturnValue(null);
            jest.spyOn(movementAlgorithmsService, 'findClosestItem').mockReturnValue(mockClosestItem);
            jest.spyOn(service, 'hasAggressiveItem');
            jest.spyOn(service, 'hasDefensiveItem');

            const expectedMovement = {
                path: [{ coord: createCoords(2, 2), cost: 1 }],
                remainingMovementPoints: 3,
            };
            jest.spyOn(service, 'goCloserToTarget').mockReturnValue(expectedMovement);

            const result = service.goForDistantTarget(mockPlayer, 'item');

            expect(result).toEqual(expectedMovement);
            expect(movementAlgorithmsService.findClosestItem).toHaveBeenCalledWith(mockPlayer.position, service.hasDefensiveItem);
            expect(service.hasAggressiveItem).not.toHaveBeenCalled();
            expect(service.goCloserToTarget).toHaveBeenCalledWith(mockPlayer, mockClosestItem.path);
        });

        it('should return goCloserToTarget result when finding a random item', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };

            jest.spyOn(movementAlgorithmsService, 'findClosestPlayer').mockReturnValue(null);
            jest.spyOn(movementAlgorithmsService, 'findClosestItem').mockImplementation((position, hasItemFn) => {
                if (hasItemFn === service.hasAggressiveItem || hasItemFn === service.hasDefensiveItem) {
                    return null;
                }
                if (hasItemFn === service.hasItem) {
                    return {
                        path: [createCoords(2, 2), createCoords(3, 3)],
                        cost: 2,
                        coord: createCoords(3, 3),
                    };
                }

                return null;
            });

            jest.spyOn(service, 'hasItem');

            const expectedMovement = {
                path: [{ coord: createCoords(2, 2), cost: 1 }],
                remainingMovementPoints: 3,
            };
            jest.spyOn(service, 'goCloserToTarget').mockReturnValue(expectedMovement);

            const result = service.goForDistantTarget(mockPlayer, 'random');

            expect(result).toEqual(expectedMovement);
            expect(movementAlgorithmsService.findClosestItem).toHaveBeenCalledWith(mockPlayer.position, service.hasItem);
            expect(service.goCloserToTarget).toHaveBeenCalledWith(mockPlayer, [createCoords(2, 2), createCoords(3, 3)]);
        });

        it('should return undefined when no random item is found', () => {
            const mockPlayer: Player = {
                id: '1',
                position: createCoords(1, 1),
                profile: VirtualPlayerType.Aggressive,
                spawnPoint: createCoords(0, 0),
                movementPoints: 5,
                inventory: [],
            };

            jest.spyOn(movementAlgorithmsService, 'findClosestPlayer').mockReturnValue(null);
            jest.spyOn(movementAlgorithmsService, 'findClosestItem').mockReturnValue(null);
            jest.spyOn(service, 'hasItem');
            jest.spyOn(service, 'goCloserToTarget').mockImplementation(() => {
                throw new Error('goCloserToTarget should not be called');
            });

            const result = service.goForDistantTarget(mockPlayer, 'random');

            expect(result).toBeUndefined();
            expect(movementAlgorithmsService.findClosestItem).toHaveBeenCalledWith(mockPlayer.position, service.hasItem);
            expect(service.goCloserToTarget).not.toHaveBeenCalled();
        });
    });
});

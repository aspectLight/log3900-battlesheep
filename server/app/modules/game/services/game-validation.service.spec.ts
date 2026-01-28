import { BOARD_SIZES } from '@app/modules/game/constants/game-validation.constants';
import { Board } from '@app/modules/game/interfaces/board';
import { Cell } from '@app/modules/game/interfaces/cell';
import { TileType } from '@app/modules/game/interfaces/tile';
import { ErrorMessages, SPECIFIC_ERROR } from '@common/error-messages.constants';
import { Test, TestingModule } from '@nestjs/testing';
import { GameValidationService } from './game-validation.service';

describe('GameValidationService', () => {
    let service: GameValidationService;

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [GameValidationService],
        }).compile();

        service = module.get<GameValidationService>(GameValidationService);
    });

    it('should be defined', () => {
        expect(service).toBeDefined();
    });

    // Helper function to create a basic board with specified size and tile type
    const createBoard = (size: number, tileType: TileType = TileType.Water, itemType?: string): Board => {
        const matrix: Cell[][] = [];
        for (let i = 0; i < size; i++) {
            const row: Cell[] = [];
            for (let j = 0; j < size; j++) {
                row.push({
                    tile: { type: tileType, state: 'default', orientation: '' },
                    item: itemType ? { type: itemType } : null,
                    x: i,
                    y: j,
                });
            }
            matrix.push(row);
        }
        return { size, matrix };
    };

    // Helper to set specific cells
    const setCell = (board: Board, x: number, y: number, tileType: TileType, itemType?: string): void => {
        board.matrix[x][y].tile.type = tileType;
        board.matrix[x][y].item = itemType ? { type: itemType } : null;
    };

    describe('validateName', () => {
        it('should return valid for non-empty name', () => {
            const result = service.validateName('Valid Game Name');
            expect(result.isValid).toBe(true);
        });

        it('should return invalid for empty name', () => {
            const result = service.validateName('');
            expect(result.isValid).toBe(false);
            expect(result.message).toBe(ErrorMessages.GameShouldHaveName);
        });

        it('should return invalid for whitespace-only name', () => {
            const result = service.validateName('   ');
            expect(result.isValid).toBe(false);
            expect(result.message).toBe(ErrorMessages.GameShouldHaveName);
        });
    });

    describe('validateDescription', () => {
        it('should return valid for non-empty description', () => {
            const result = service.validateDescription('Valid game description');
            expect(result.isValid).toBe(true);
        });

        it('should return invalid for empty description', () => {
            const result = service.validateDescription('');
            expect(result.isValid).toBe(false);
            expect(result.message).toBe(ErrorMessages.GameShouldHaveDescription);
        });

        it('should return invalid for whitespace-only description', () => {
            const result = service.validateDescription('   ');
            expect(result.isValid).toBe(false);
            expect(result.message).toBe(ErrorMessages.GameShouldHaveDescription);
        });
    });

    describe('validateTerrainTilesCoverage', () => {
        it('should return valid when >50% terrain tiles', () => {
            const board = createBoard(10, TileType.Water);
            const result = service.validateTerrainTilesCoverage(board);
            expect(result.isValid).toBe(true);
        });

        it('should return invalid when <50% terrain tiles', () => {
            const board = createBoard(10, TileType.Wall);
            // Only add 40% terrain
            for (let i = 0; i < 4; i++) {
                for (let j = 0; j < 10; j++) {
                    setCell(board, i, j, TileType.Water);
                }
            }
            const result = service.validateTerrainTilesCoverage(board);
            expect(result.isValid).toBe(false);
            expect(result.message).toBe(ErrorMessages.HalfTilesCoverage);
        });

        it('should return invalid when exactly 50% terrain tiles', () => {
            const board = createBoard(10, TileType.Wall);
            // Exactly 50%
            for (let i = 0; i < 5; i++) {
                for (let j = 0; j < 10; j++) {
                    setCell(board, i, j, TileType.Water);
                }
            }
            const result = service.validateTerrainTilesCoverage(board);
            expect(result.isValid).toBe(false);
            expect(result.message).toBe(ErrorMessages.HalfTilesCoverage);
        });

        it('should count ice and snow as terrain tiles', () => {
            const board = createBoard(10, TileType.Wall);
            // Add different terrain types
            for (let i = 0; i < 3; i++) {
                for (let j = 0; j < 10; j++) {
                    setCell(board, i, j, TileType.Water);
                }
            }
            for (let i = 3; i < 5; i++) {
                for (let j = 0; j < 10; j++) {
                    setCell(board, i, j, TileType.Ice);
                }
            }
            for (let i = 5; i < 7; i++) {
                for (let j = 0; j < 10; j++) {
                    setCell(board, i, j, TileType.Snow);
                }
            }
            const result = service.validateTerrainTilesCoverage(board);
            expect(result.isValid).toBe(true);
        });
    });

    describe('validateSpawnPoints', () => {
        it('should return valid for small board with 2 spawn points', () => {
            const board = createBoard(BOARD_SIZES.small, TileType.Water);
            setCell(board, 0, 0, TileType.Water, 'spawnPoint');
            setCell(board, 9, 9, TileType.Water, 'spawnPoint');
            const result = service.validateSpawnPoints(board);
            expect(result.isValid).toBe(true);
        });

        it('should return valid for medium board with 4 spawn points', () => {
            const board = createBoard(BOARD_SIZES.medium, TileType.Water);
            setCell(board, 0, 0, TileType.Water, 'spawnPoint');
            setCell(board, 0, 14, TileType.Water, 'spawnPoint');
            setCell(board, 14, 0, TileType.Water, 'spawnPoint');
            setCell(board, 14, 14, TileType.Water, 'spawnPoint');
            const result = service.validateSpawnPoints(board);
            expect(result.isValid).toBe(true);
        });

        it('should return valid for large board with 6 spawn points', () => {
            const board = createBoard(BOARD_SIZES.large, TileType.Water);
            setCell(board, 0, 0, TileType.Water, 'spawnPoint');
            setCell(board, 0, 10, TileType.Water, 'spawnPoint');
            setCell(board, 0, 19, TileType.Water, 'spawnPoint');
            setCell(board, 19, 0, TileType.Water, 'spawnPoint');
            setCell(board, 19, 10, TileType.Water, 'spawnPoint');
            setCell(board, 19, 19, TileType.Water, 'spawnPoint');
            const result = service.validateSpawnPoints(board);
            expect(result.isValid).toBe(true);
        });

        it('should return invalid when too few spawn points', () => {
            const board = createBoard(BOARD_SIZES.small, TileType.Water);
            setCell(board, 0, 0, TileType.Water, 'spawnPoint');
            const result = service.validateSpawnPoints(board);
            expect(result.isValid).toBe(false);
            expect(result.message).toBe(SPECIFIC_ERROR.spawnPoints({ min: 2, max: 2 }));
        });

        it('should return invalid when too many spawn points', () => {
            const board = createBoard(BOARD_SIZES.small, TileType.Water);
            setCell(board, 0, 0, TileType.Water, 'spawnPoint');
            setCell(board, 5, 5, TileType.Water, 'spawnPoint');
            setCell(board, 9, 9, TileType.Water, 'spawnPoint');
            const result = service.validateSpawnPoints(board);
            expect(result.isValid).toBe(false);
            expect(result.message).toBe(SPECIFIC_ERROR.spawnPoints({ min: 2, max: 2 }));
        });
    });

    describe('validateItems', () => {
        it('should return valid for standard mode with correct number of items', () => {
            const board = createBoard(BOARD_SIZES.small, TileType.Water);
            setCell(board, 0, 0, TileType.Water, 'adrenaline');
            setCell(board, 5, 5, TileType.Water, 'vodka');
            const result = service.validateItems(board, false);
            expect(result.isValid).toBe(true);
        });

        it('should return invalid for standard mode with too few items', () => {
            const board = createBoard(BOARD_SIZES.small, TileType.Water);
            setCell(board, 0, 0, TileType.Water, 'adrenaline');
            const result = service.validateItems(board, false);
            expect(result.isValid).toBe(false);
            expect(result.message).toBe(SPECIFIC_ERROR.items(2));
        });

        it('should return valid for CTF mode with flag and correct items', () => {
            const board = createBoard(BOARD_SIZES.small, TileType.Water);
            setCell(board, 0, 0, TileType.Water, 'flag');
            setCell(board, 5, 5, TileType.Water, 'vodka');
            const result = service.validateItems(board, true);
            expect(result.isValid).toBe(true);
        });

        it('should return invalid for CTF mode without flag', () => {
            const board = createBoard(BOARD_SIZES.small, TileType.Water);
            setCell(board, 0, 0, TileType.Water, 'adrenaline');
            setCell(board, 5, 5, TileType.Water, 'vodka');
            const result = service.validateItems(board, true);
            expect(result.isValid).toBe(false);
            expect(result.message).toBe(ErrorMessages.GameShouldHaveFlag);
        });

        it('should return invalid for CTF mode with flag but wrong item count', () => {
            const board = createBoard(BOARD_SIZES.small, TileType.Water);
            setCell(board, 0, 0, TileType.Water, 'flag');
            const result = service.validateItems(board, true);
            expect(result.isValid).toBe(false);
            expect(result.message).toBe(SPECIFIC_ERROR.items(2));
        });

        it('should not count spawn points as items', () => {
            const board = createBoard(BOARD_SIZES.small, TileType.Water);
            setCell(board, 0, 0, TileType.Water, 'spawnPoint');
            setCell(board, 1, 1, TileType.Water, 'spawnPoint');
            setCell(board, 5, 5, TileType.Water, 'adrenaline');
            setCell(board, 8, 8, TileType.Water, 'vodka');
            const result = service.validateItems(board, false);
            expect(result.isValid).toBe(true);
        });
    });

    describe('validateTerrainTilesAccessibility', () => {
        it('should return valid when all terrain tiles are connected', () => {
            const board = createBoard(10, TileType.Water);
            const result = service.validateTerrainTilesAccessibility(board);
            expect(result.isValid).toBe(true);
        });

        it('should return invalid when terrain tiles are isolated', () => {
            const board = createBoard(10, TileType.Wall);
            // Create isolated terrain islands
            setCell(board, 1, 1, TileType.Water);
            setCell(board, 8, 8, TileType.Water);
            const result = service.validateTerrainTilesAccessibility(board);
            expect(result.isValid).toBe(false);
            expect(result.message).toBe(ErrorMessages.AllTerrainTilesAccessible);
        });

        it('should return invalid when no terrain tiles exist', () => {
            const board = createBoard(10, TileType.Wall);
            const result = service.validateTerrainTilesAccessibility(board);
            expect(result.isValid).toBe(false);
            expect(result.message).toBe(ErrorMessages.NoTerrainTiles);
        });

        it('should consider doors as accessible', () => {
            const board = createBoard(10, TileType.Wall);
            // Create path through doors
            for (let i = 1; i < 5; i++) {
                setCell(board, i, 1, TileType.Water);
            }
            setCell(board, 5, 1, TileType.Door);
            for (let i = 6; i < 9; i++) {
                setCell(board, i, 1, TileType.Water);
            }
            const result = service.validateTerrainTilesAccessibility(board);
            expect(result.isValid).toBe(true);
        });
    });

    describe('validateDoors', () => {
        it('should return empty array for valid board without doors', () => {
            const board = createBoard(10, TileType.Water);
            const result = service.validateDoors(board);
            expect(result).toEqual([]);
        });

        it('should return error when door is on edge', () => {
            const board = createBoard(10, TileType.Water);
            setCell(board, 0, 5, TileType.Door);
            const result = service.validateDoors(board);
            expect(result.length).toBeGreaterThan(0);
            expect(result[0].isValid).toBe(false);
            expect(result[0].message).toBe(SPECIFIC_ERROR.notOnEdge(0, 5));
        });

        it('should return error when door is not surrounded by walls on same axis', () => {
            const board = createBoard(10, TileType.Water);
            setCell(board, 5, 5, TileType.Door);
            const result = service.validateDoors(board);
            expect(result.some((r) => r.message?.includes('murs'))).toBe(true);
        });

        it('should return error when door is not surrounded by terrain on same axis', () => {
            const board = createBoard(10, TileType.Wall);
            setCell(board, 5, 5, TileType.Door);
            setCell(board, 4, 5, TileType.Wall);
            setCell(board, 6, 5, TileType.Wall);
            const result = service.validateDoors(board);
            expect(result.some((r) => r.message?.includes('terrain'))).toBe(true);
        });

        it('should return valid for properly placed door (horizontal walls, vertical terrain)', () => {
            const board = createBoard(10, TileType.Water);
            setCell(board, 5, 5, TileType.Door);
            // Walls on left and right
            setCell(board, 5, 4, TileType.Wall);
            setCell(board, 5, 6, TileType.Wall);
            // Terrain on top and bottom (already water)
            const result = service.validateDoors(board);
            expect(result).toEqual([]);
        });

        it('should return valid for properly placed door (vertical walls, horizontal terrain)', () => {
            const board = createBoard(10, TileType.Water);
            setCell(board, 5, 5, TileType.Door);
            // Walls on top and bottom
            setCell(board, 4, 5, TileType.Wall);
            setCell(board, 6, 5, TileType.Wall);
            // Terrain on left and right (already water)
            const result = service.validateDoors(board);
            expect(result).toEqual([]);
        });
    });

    describe('validateGame', () => {
        it('should return empty array for completely valid game', () => {
            const board = createBoard(BOARD_SIZES.small, TileType.Water);
            setCell(board, 0, 0, TileType.Water, 'spawnPoint');
            setCell(board, 9, 9, TileType.Water, 'spawnPoint');
            setCell(board, 3, 3, TileType.Water, 'adrenaline');
            setCell(board, 6, 6, TileType.Water, 'vodka');

            const result = service.validateGame('Valid Game', 'Valid description', board, false);
            expect(result).toEqual([]);
        });

        it('should return all errors for invalid game', () => {
            const board = createBoard(BOARD_SIZES.small, TileType.Wall);
            const result = service.validateGame('', '', board, false);
            expect(result.length).toBeGreaterThan(0);
            expect(result.some((r) => r.message === ErrorMessages.GameShouldHaveName)).toBe(true);
            expect(result.some((r) => r.message === ErrorMessages.GameShouldHaveDescription)).toBe(true);
        });

        it('should return only errors, not valid results', () => {
            const board = createBoard(BOARD_SIZES.small, TileType.Water);
            setCell(board, 0, 0, TileType.Water, 'spawnPoint');
            setCell(board, 9, 9, TileType.Water, 'spawnPoint');
            setCell(board, 3, 3, TileType.Water, 'adrenaline');
            setCell(board, 6, 6, TileType.Water, 'vodka');

            const result = service.validateGame('', 'Valid desc', board, false);
            expect(result.length).toBe(1);
            expect(result[0].message).toBe(ErrorMessages.GameShouldHaveName);
        });

        it('should validate CTF mode correctly', () => {
            const board = createBoard(BOARD_SIZES.small, TileType.Water);
            setCell(board, 0, 0, TileType.Water, 'spawnPoint');
            setCell(board, 9, 9, TileType.Water, 'spawnPoint');
            setCell(board, 3, 3, TileType.Water, 'adrenaline');
            setCell(board, 6, 6, TileType.Water, 'vodka');

            const result = service.validateGame('Valid', 'Valid', board, true);
            expect(result.some((r) => r.message === ErrorMessages.GameShouldHaveFlag)).toBe(true);
        });

        it('should include door validation errors', () => {
            const board = createBoard(BOARD_SIZES.small, TileType.Water);
            setCell(board, 0, 0, TileType.Water, 'spawnPoint');
            setCell(board, 9, 9, TileType.Water, 'spawnPoint');
            setCell(board, 3, 3, TileType.Water, 'adrenaline');
            setCell(board, 6, 6, TileType.Water, 'vodka');
            setCell(board, 0, 5, TileType.Door);

            const result = service.validateGame('Valid', 'Valid', board, false);
            expect(result.some((r) => r.message?.includes('bord'))).toBe(true);
        });
    });
});

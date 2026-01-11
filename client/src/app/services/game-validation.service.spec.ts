import { TestBed } from '@angular/core/testing';
import { Board } from '@app/classes/board';
import { Item } from '@app/classes/item';
import { Tile } from '@app/classes/tile';
import { GameValidationService, ITEMS } from './game-validation.service';

describe('GameValidationService', () => {
    let service: GameValidationService;
    let board: Board;

    beforeEach(() => {
        TestBed.configureTestingModule({});
        service = TestBed.inject(GameValidationService);
    });

    it('should be created', () => {
        expect(service).toBeTruthy();
    });

    describe('Basic validations', () => {
        it('should have a non-empty name', () => {
            const result = service.validateName('Name');
            expect(result.isValid).toBeTrue();
        });

        it('should invalidate an empty name', () => {
            const result = service.validateName('');
            expect(result.isValid).toBeFalse();
            expect(result.message).toBe('Le jeu doit avoir un nom.');
        });

        it('should have a non-empty description', () => {
            const result = service.validateDescription('Description');
            expect(result.isValid).toBeTrue();
        });

        it('should invalidate an empty description', () => {
            const result = service.validateDescription('');
            expect(result.isValid).toBeFalse();
            expect(result.message).toBe('Le jeu doit avoir une description.');
        });
    });

    describe('Spawn Points and Items Validations', () => {
        const testScenarios = [
            { boardSize: 10, spawnPointsNumber: 2, itemsNumber: 2, spawnPointsValid: true, itemsValid: true },
            { boardSize: 15, spawnPointsNumber: 4, itemsNumber: 4, spawnPointsValid: true, itemsValid: true },
            { boardSize: 20, spawnPointsNumber: 6, itemsNumber: 6, spawnPointsValid: true, itemsValid: true },
            {
                boardSize: 10,
                spawnPointsNumber: 1,
                itemsNumber: 2,
                spawnPointsValid: false,
                itemsValid: true,
                errorMessage: 'Il doit y avoir 2 points de départ.',
            },
            {
                boardSize: 15,
                spawnPointsNumber: 4,
                itemsNumber: 3,
                spawnPointsValid: true,
                itemsValid: false,
                errorMessage: 'Il doit y avoir 4 items.',
            },
        ];

        const configureBoard = (size: number, spawnPoints: number, items: number, hasFlag: boolean = false): Board => {
            board = new Board(size);
            const positions = new Set<string>();
            let count = 0;

            for (let i = 0; i < spawnPoints + items; i++) {
                let x;
                let y;
                do {
                    x = Math.floor(i / size);
                    y = i % size;
                } while (positions.has(`${x},${y}`));

                positions.add(`${x},${y}`);

                if (count < spawnPoints) {
                    board.matrix[x][y].item = new Item('spawnPoint');
                } else if (hasFlag && count === spawnPoints) {
                    board.matrix[x][y].item = new Item('flag');
                } else {
                    board.matrix[x][y].item = new Item(ITEMS[0]);
                }
                count++;
            }
            return board;
        };

        testScenarios.forEach(({ boardSize, spawnPointsNumber, itemsNumber, spawnPointsValid, itemsValid, errorMessage }) => {
            it(`should validate spawn points on a board of ${boardSize} with ${spawnPointsNumber} spawn points`, () => {
                board = configureBoard(boardSize, spawnPointsNumber, itemsNumber);
                const spawnPointsTest = service.validateSpawnPoints(board);

                if (spawnPointsValid) {
                    expect(spawnPointsTest.isValid).toBeTrue();
                } else {
                    expect(spawnPointsTest.isValid).toBeFalse();
                    expect(spawnPointsTest.message).toBe(errorMessage);
                }
            });

            it(`should validate items on a board of ${boardSize} with ${itemsNumber} items`, () => {
                board = configureBoard(boardSize, spawnPointsNumber, itemsNumber);
                const itemsTest = service.validateItems(board, false);

                if (itemsValid) {
                    expect(itemsTest.isValid).toBeTrue();
                } else {
                    expect(itemsTest.isValid).toBeFalse();
                    expect(itemsTest.message).toBe(errorMessage);
                }
            });
        });

        it('should validate CTF game with required flag and items', () => {
            board = configureBoard(10, 2, 2, true);
            const itemsTest = service.validateItems(board, true);
            expect(itemsTest.isValid).toBeTrue();
        });

        it('should invalidate CTF game without flag', () => {
            board = configureBoard(10, 2, 2, false);
            const itemsTest = service.validateItems(board, true);
            expect(itemsTest.isValid).toBeFalse();
            expect(itemsTest.message).toBe('Le jeu doit avoir au moins un drapeau.');
        });

        it('should invalidate CTF game with flag but wrong number of items', () => {
            board = configureBoard(10, 2, 1, true);
            const itemsTest = service.validateItems(board, true);
            expect(itemsTest.isValid).toBeFalse();
            expect(itemsTest.message).toBe('Il doit y avoir 2 items.');
        });
    });

    describe('Tiles coverage validations', () => {
        beforeEach(() => {
            const BOARD_SIZE = 5;
            board = new Board(BOARD_SIZE);
        });

        it('should validate coverage if more than 50% of board tiles are terrain', () => {
            const result = service.validateTerrainTilesCoverage(board);
            expect(result.isValid).toBeTrue();
        });

        it('should invalidate coverage if less than 50% of board tiles are terrain', () => {
            board.matrix.forEach((row) => row.forEach((cell) => (cell.tile = new Tile('wall'))));
            const result = service.validateTerrainTilesCoverage(board);
            expect(result.isValid).toBeFalse();
            expect(result.message).toBe('Plus de 50% de la surface totale de la zone de jeu doit être occupée par des tuiles de terrain.');
        });
    });

    describe('Tiles accessibility validations', () => {
        beforeEach(() => {
            const BOARD_SIZE = 5;
            board = new Board(BOARD_SIZE);
        });
        it('should validate when all terrain tiles are accessible', () => {
            const result = service.validateTerrainTilesAccessibility(board);
            expect(result.isValid).toBeTrue();
        });

        it('should invalidate when there are no terrain tiles', () => {
            board.matrix.forEach((row) => row.forEach((cell) => (cell.tile = new Tile('wall'))));
            const result = service.validateTerrainTilesAccessibility(board);
            expect(result.isValid).toBeFalse();
            expect(result.message).toBe("Aucune tuile de terrain n'a été trouvée.");
        });

        it('should invalidate when a terrain tile is inaccessible', () => {
            board.matrix[1][2].tile = new Tile('tree');
            board.matrix[3][2].tile = new Tile('corner');
            board.matrix[2][1].tile = new Tile('wall');
            board.matrix[2][3].tile = new Tile('stone');

            const result = service.validateTerrainTilesAccessibility(board);
            expect(result.isValid).toBeFalse();
            expect(result.message).toBe('Toutes les tuiles de terrain doivent être accessibles.');
        });

        it('should invalidate when a terrain tile is inaccessible on edge', () => {
            board.matrix[0][0].tile = new Tile('wall');
            board.matrix[1][1].tile = new Tile('wall');
            board.matrix[2][0].tile = new Tile('wall');

            const result = service.validateTerrainTilesAccessibility(board);
            expect(result.isValid).toBeFalse();
            expect(result.message).toBe('Toutes les tuiles de terrain doivent être accessibles.');
        });

        describe('Private methods', () => {
            it('should return the first terrain tile on the board', () => {
                // eslint-disable-next-line @typescript-eslint/no-explicit-any
                const result = (service as any).findStartingTile(board);
                expect(result).toEqual([0, 0]);
            });

            it('should return null if no terrain tile is found', () => {
                board.matrix.forEach((row) => row.forEach((cell) => (cell.tile = new Tile('wall'))));
                // eslint-disable-next-line @typescript-eslint/no-explicit-any
                const result = (service as any).findStartingTile(board);
                expect(result).toBeNull();
            });

            it('should mark all reachable terrain tiles as visited', () => {
                board.matrix[2][3].tile = new Tile('water');
                board.matrix[0][0].tile = new Tile('ice');

                const visited = board.matrix.map((row) => row.map(() => false));
                // eslint-disable-next-line @typescript-eslint/no-explicit-any
                (service as any).performBFS(board, [0, 0], visited);

                expect(visited[0][0]).toBeTrue();
                expect(visited[0][1]).toBeTrue();
                expect(visited[1][0]).toBeTrue();
            });

            it('should not visit walls', () => {
                board.matrix[4][4].tile = new Tile('wall');
                board.matrix[3][3].tile = new Tile('wall');

                const visited = board.matrix.map((row) => row.map(() => false));
                // eslint-disable-next-line @typescript-eslint/no-explicit-any
                (service as any).performBFS(board, [0, 0], visited);

                expect(visited[4][4]).toBeFalse();
                expect(visited[3][3]).toBeFalse();
            });

            it('should return true for a valid terrain tile', () => {
                const visited = board.matrix.map((row) => row.map(() => false));
                // eslint-disable-next-line @typescript-eslint/no-explicit-any
                const result = (service as any).isValidTile(board.matrix, visited, { x: 0, y: 0 });
                expect(result).toBeTrue();
            });

            it('should return false for a wall tile', () => {
                board.matrix[3][3].tile = new Tile('wall');
                const X_COORD = 3;
                const Y_COORD = 3;
                const visited = board.matrix.map((row) => row.map(() => false));
                // eslint-disable-next-line @typescript-eslint/no-explicit-any
                const result = (service as any).isValidTile(board.matrix, visited, { x: X_COORD, y: Y_COORD });
                expect(result).toBeFalse();
            });

            it('should return false for an already visited tile', () => {
                const visited = board.matrix.map((row) => row.map(() => false));
                visited[0][0] = true;
                // eslint-disable-next-line @typescript-eslint/no-explicit-any
                const result = (service as any).isValidTile(board.matrix, visited, { x: 0, y: 0 });
                expect(result).toBeFalse();
            });

            it('should return false for invalid coordinates', () => {
                const visited = board.matrix.map((row) => row.map(() => false));
                // eslint-disable-next-line @typescript-eslint/no-explicit-any
                const result = (service as any).isValidTile(board.matrix, visited, { x: -1, y: -1 });
                expect(result).toBeFalse();
            });

            it('should validate when a terrain tile is accessible by a door only', () => {
                board.matrix[0][0].tile = new Tile('wall');
                board.matrix[1][1].tile = new Tile('door');
                board.matrix[2][0].tile = new Tile('wall');

                const result = service.validateTerrainTilesAccessibility(board);
                expect(result.isValid).toBeTrue();
            });
        });
    });
    describe('Doors validations', () => {
        beforeEach(() => {
            const BOARD_SIZE = 5;
            board = new Board(BOARD_SIZE);
        });
        describe('ValidateDoors', () => {
            it('should return an empty array if all doors are valid', () => {
                board.matrix[2][2].tile = new Tile('door');
                board.matrix[2][1].tile = new Tile('wall');
                board.matrix[2][3].tile = new Tile('wall');

                const result = service.validateDoors(board);
                expect(result.length).toBe(0);
            });

            it('should return an array of 1 element if a door is on the edge', () => {
                board.matrix[0][2].tile = new Tile('door');
                const result = service.validateDoors(board);
                expect(result.length).toBe(1);
                expect(result[0].message).toBe('La porte à (0, 2) est sur le bord du plateau.');
            });

            it('should return an array of 1 element if a door is not surrounded by walls', () => {
                board.matrix[2][2].tile = new Tile('door');
                board.matrix[2][1].tile = new Tile('wall');

                const result = service.validateDoors(board);
                expect(result.length).toBe(1);
                expect(result[0].message).toBe("La porte à (2, 2) n'est pas entourée par des murs sur le même axe.");
            });

            it('should return an array of 1 element if a door is not surrounded by terrain tiles', () => {
                board.matrix[2][2].tile = new Tile('door');
                board.matrix[2][1].tile = new Tile('wall');
                board.matrix[2][3].tile = new Tile('wall');
                board.matrix[1][2].tile = new Tile('wall');
                board.matrix[3][2].tile = new Tile('wall');

                const result = service.validateDoors(board);
                expect(result.length).toBe(1);
                expect(result[0].message).toBe("La porte à (2, 2) n'est pas entourée par des tuiles de terrain sur le même axe.");
            });

            it('should return an array of 2 elements if a door is not surrounded by terrain and wall tiles', () => {
                board.matrix[2][2].tile = new Tile('door');
                board.matrix[2][1].tile = new Tile('wall');
                board.matrix[1][2].tile = new Tile('wall');

                const result = service.validateDoors(board);
                expect(result.length).toBe(2);
                expect(result[0].message).toBe("La porte à (2, 2) n'est pas entourée par des murs sur le même axe.");
                expect(result[1].message).toBe("La porte à (2, 2) n'est pas entourée par des tuiles de terrain sur le même axe.");
            });

            describe('Private methods', () => {
                const BOARD_SIZE = 5;
                it('should return false for a door not on the edge', () => {
                    // eslint-disable-next-line @typescript-eslint/no-explicit-any
                    const result = (service as any).isNotOnEdge(2, 2, BOARD_SIZE);
                    expect(result.isValid).toBeTrue();
                });

                it('should return false for a door on the top edge', () => {
                    // eslint-disable-next-line @typescript-eslint/no-explicit-any
                    const result = (service as any).isNotOnEdge(0, 2, BOARD_SIZE);
                    expect(result).toEqual({ isValid: false, message: 'La porte à (0, 2) est sur le bord du plateau.' });
                });

                it('should return false for a door on the left edge', () => {
                    // eslint-disable-next-line @typescript-eslint/no-explicit-any
                    const result = (service as any).isNotOnEdge(1, 0, BOARD_SIZE);
                    expect(result).toEqual({ isValid: false, message: 'La porte à (1, 0) est sur le bord du plateau.' });
                });

                it('should return true if the door is surrounded by walls on the same axis', () => {
                    board.matrix[2][1].tile = new Tile('wall');
                    board.matrix[2][3].tile = new Tile('wall');
                    // eslint-disable-next-line @typescript-eslint/no-explicit-any
                    const result = (service as any).isSurroundedByWalls(board.matrix, 2, 2);
                    expect(result.isValid).toBeTrue();
                });

                it('should return false if the door is not surrounded by walls on the same axis', () => {
                    board.matrix[1][0].tile = new Tile('wall');
                    board.matrix[3][2].tile = new Tile('wall');
                    // eslint-disable-next-line @typescript-eslint/no-explicit-any
                    const result = (service as any).isSurroundedByWalls(board.matrix, 2, 2);
                    expect(result).toEqual({ isValid: false, message: "La porte à (2, 2) n'est pas entourée par des murs sur le même axe." });
                });

                it('should return true if the door is surrounded by terrain tiles on the same axis', () => {
                    // eslint-disable-next-line @typescript-eslint/no-explicit-any
                    const result = (service as any).isSurroundedByTerrain(board.matrix, 2, 2);
                    expect(result.isValid).toBeTrue();
                });

                it('should return false if the door is not surrounded by terrain tiles on the same axis', () => {
                    board.matrix[1][2].tile = new Tile('wall');
                    board.matrix[3][2].tile = new Tile('wall');
                    board.matrix[2][3].tile = new Tile('wall');
                    // eslint-disable-next-line @typescript-eslint/no-explicit-any
                    const result = (service as any).isSurroundedByTerrain(board.matrix, 2, 2);
                    expect(result).toEqual({
                        isValid: false,
                        message: "La porte à (2, 2) n'est pas entourée par des tuiles de terrain sur le même axe.",
                    });
                });
            });
        });
    });

    describe('Validate all game', () => {
        const BOARD_SIZE = 10;
        board = new Board(BOARD_SIZE);

        it('should call all validation methods when validateGame is executed', () => {
            const name = 'name';
            const description = 'description';

            const spyValidateName = spyOn(service, 'validateName').and.callFake(() => ({ isValid: true }));
            const spyValidateDescription = spyOn(service, 'validateDescription').and.callFake(() => ({ isValid: true }));
            const spyValidateTerrainTilesCoverage = spyOn(service, 'validateTerrainTilesCoverage').and.callFake(() => ({ isValid: true }));
            const spyValidateSpawnPoints = spyOn(service, 'validateSpawnPoints').and.callFake(() => ({ isValid: true }));
            const spyValidateTerrainTilesAccessibility = spyOn(service, 'validateTerrainTilesAccessibility').and.callFake(() => ({ isValid: true }));
            const spyValidateDoors = spyOn(service, 'validateDoors').and.callFake(() => []);
            service.validateGame(name, description, board, false);

            expect(spyValidateName).toHaveBeenCalledWith(name);
            expect(spyValidateDescription).toHaveBeenCalledWith(description);
            expect(spyValidateTerrainTilesCoverage).toHaveBeenCalledWith(board);
            expect(spyValidateSpawnPoints).toHaveBeenCalledWith(board);
            expect(spyValidateTerrainTilesAccessibility).toHaveBeenCalledWith(board);
            expect(spyValidateDoors).toHaveBeenCalledWith(board);
        });
    });
});

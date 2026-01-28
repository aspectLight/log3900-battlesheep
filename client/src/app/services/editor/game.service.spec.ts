import { TestBed } from '@angular/core/testing';
import { GameService } from '@app/services/editor/game.service';
import { provideHttpClient } from '@angular/common/http';
import { HttpTestingController, provideHttpClientTesting } from '@angular/common/http/testing';
import { Game } from '@app/classes/game/game';
import { Board } from '@app/classes/board/board';
import { environment } from 'src/environments/environment';
import { BoardSizes, BOARD_CONFIGS } from '@app/constants/board.constants';
import { HTTP_STATUS_CODES } from '@app/constants/http-status-code.constants';

describe('GameService', () => {
    let service: GameService;
    let httpController: HttpTestingController;

    beforeEach(() => {
        TestBed.configureTestingModule({
            providers: [GameService, provideHttpClient(), provideHttpClientTesting()],
        });
        service = TestBed.inject(GameService);
        httpController = TestBed.inject(HttpTestingController);
    });

    afterEach(() => {
        httpController.verify();
        localStorage.clear();
    });

    it('should be created', () => {
        expect(service).toBeTruthy();
    });

    describe('Game properties management', () => {
        let mockGame: Game;

        beforeEach(() => {
            mockGame = new Game();
            mockGame._id = '12345';
            mockGame.name = 'TestGame';
            mockGame.description = 'Test description';
            mockGame.mode = 'classique';
            mockGame.board = new Board(BOARD_CONFIGS[BoardSizes.Moyenne].board);
            service.setGame(mockGame);
        });

        it('should get game id correctly', () => {
            expect(service.getId()).toBe('12345');
        });

        it('should get and set name correctly', () => {
            expect(service.getName()).toBe('TestGame');
            service.setName('NewGameName');
            expect(service.getName()).toBe('NewGameName');
        });

        it('should get and set description correctly', () => {
            expect(service.getDescription()).toBe('Test description');
            service.setDescription('New description');
            expect(service.getDescription()).toBe('New description');
        });

        it('should get game settings correctly', () => {
            const settings = service.getGameSettings();
            expect(settings).toEqual({
                mode: 'classique',
                boardSize: BOARD_CONFIGS[BoardSizes.Moyenne].board,
            });
        });

        it('should get mode correctly', () => {
            expect(service.getMode()).toBe('classique');
        });

        it('should set game settings correctly', () => {
            service.setGameSettings('ctf', BOARD_CONFIGS[BoardSizes.Petite].board);
            const settings = service.getGameSettings();
            expect(settings).toEqual({
                mode: 'ctf',
                boardSize: BOARD_CONFIGS[BoardSizes.Petite].board,
            });
        });

        it('should get and set board correctly', () => {
            const newBoard = new Board(BOARD_CONFIGS[BoardSizes.Grande].board);
            service.setBoard(newBoard);
            expect(service.getBoard().size).toBe(BOARD_CONFIGS[BoardSizes.Grande].board);
        });
    });

    describe('Game state management', () => {
        it('should initialize a new game correctly', () => {
            service.setNewGame();
            expect(service.isGameBeingModified).toBeFalse();
            expect(service.getBoard()).toBeTruthy();
            expect(service.getBoard().size).toBeGreaterThan(0);
        });

        it('should set an existing game correctly', () => {
            const mockGame = new Game();
            mockGame.name = 'ExistingGame';
            mockGame.board = new Board(BOARD_CONFIGS[BoardSizes.Moyenne].board);
            service.setGame(mockGame);

            expect(service.isGameBeingModified).toBeTrue();
            expect(service.getName()).toBe('ExistingGame');
            expect(service.getBoard().size).toBe(BOARD_CONFIGS[BoardSizes.Moyenne].board);
        });

        it('should initialize a new game when no saved game exists in localStorage', () => {
            localStorage.removeItem('savedGame');

            const gameService = TestBed.inject(GameService);

            expect(gameService.getId()).toBeUndefined();
            expect(gameService.getName()).toBe('');
        });

        it('should correctly undo modifications', () => {
            const mockGame = new Game();
            mockGame.name = 'MockGame';
            service.setGame(mockGame);

            service.setName('ChangedGame');
            expect(service.getName()).toBe('ChangedGame');

            service.undoModifications();
            expect(service.getName()).toBe('MockGame');
        });
    });

    describe('HTTP operations', () => {
        it('should save new game successfully', () => {
            const mockGame = new Game();
            service.setNewGame();
            service.saveNewGame().subscribe();

            const req = httpController.expectOne(`${environment.serverUrl}/games/`);
            expect(req.request.method).toBe('POST');
            expect(req.request.headers.get('contentType')).toBe('application/json');
            req.flush(mockGame);
        });

        it('should handle error when saving new game', () => {
            service.setNewGame();
            service.saveNewGame().subscribe({
                error: (error) => {
                    expect(error.status).toBe(HTTP_STATUS_CODES.conflict);
                    expect(error.statusText).toBe('Bad Request');
                },
            });
            const req = httpController.expectOne(`${environment.serverUrl}/games/`);
            req.flush('Bad request error', { status: 409, statusText: 'Bad Request' });
        });

        it('should save modifications successfully', () => {
            const mockGame = new Game();
            mockGame._id = '12345';
            service.setGame(mockGame);

            service.saveModifications().subscribe((response) => {
                expect(response).toBeTruthy();
            });

            const req = httpController.expectOne(`${environment.serverUrl}/games/12345`);
            expect(req.request.method).toBe('PATCH');
            expect(req.request.headers.get('contentType')).toBe('application/json');
            req.flush(mockGame);
        });

        it('should handle error when saving modifications', () => {
            const mockGame = new Game();
            mockGame._id = '12345';
            service.setGame(mockGame);

            service.saveModifications().subscribe({
                error: (error) => {
                    expect(error.status).toBe(HTTP_STATUS_CODES.internalServerError);
                },
            });

            const req = httpController.expectOne(`${environment.serverUrl}/games/12345`);
            req.flush('Save error', { status: 500, statusText: 'Internal Server Error' });
        });

        it('should fetch games successfully', () => {
            const mockGames: Game[] = [new Game(), new Game()];

            service.fetchGames().subscribe((games) => {
                expect(games.length).toBe(2);
                expect(games).toEqual(mockGames);
            });

            const req = httpController.expectOne(`${environment.serverUrl}/games/`);
            expect(req.request.method).toBe('GET');
            req.flush(mockGames);
        });

        it('should handle error when fetching games', () => {
            service.fetchGames().subscribe({
                error: (error) => {
                    expect(error.status).toBe(HTTP_STATUS_CODES.notFound);
                },
            });

            const req = httpController.expectOne(`${environment.serverUrl}/games/`);
            req.flush('Fetch error', { status: 404, statusText: 'Internal Server Error' });
        });
    });
});

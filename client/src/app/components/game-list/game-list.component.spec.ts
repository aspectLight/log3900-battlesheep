import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { Board } from '@app/classes/board';
import { Game } from '@app/classes/game';
import { GameListService } from '@app/services/game-list.service';
import { GameService } from '@app/services/game.service';
import { of, throwError } from 'rxjs';
import { GameListComponent } from './game-list.component';

const MEDIUM_BOARD_SIZE = 15;
const LARGE_BOARD_SIZE = 20;

describe('GameListComponent', () => {
    let component: GameListComponent;
    let fixture: ComponentFixture<GameListComponent>;
    let gameListServiceSpy: jasmine.SpyObj<GameListService>;
    let gameServiceSpy: jasmine.SpyObj<GameService>;
    let httpClientSpy: jasmine.SpyObj<HttpClient>;

    beforeEach(async () => {
        gameListServiceSpy = jasmine.createSpyObj('GameListService', ['onCheckboxClick', 'onModifyClick', 'onDeleteClick', 'getDate']);

        httpClientSpy = jasmine.createSpyObj('HttpClient', ['get', 'post', 'put', 'delete']);

        gameListServiceSpy.getDate.and.returnValue('2025-02-06');

        gameServiceSpy = jasmine.createSpyObj('GameListService', ['fetchGames']);

        const mockGame1 = new Game();
        mockGame1['setData']({
            _id: '1',
            name: 'Game 1',
            description: 'Description 1',
            mode: 'ctf',
            board: new Board(MEDIUM_BOARD_SIZE),
            isVisible: true,
            modificationDate: new Date().toISOString(),
        } as Game);

        const mockGame2 = new Game();
        mockGame2['setData']({
            _id: '2',
            name: 'Game 2',
            description: 'Description 2',
            mode: 'classique',
            board: new Board(LARGE_BOARD_SIZE),
            isVisible: false,
            modificationDate: new Date().toISOString(),
        } as Game);

        gameServiceSpy.fetchGames.and.returnValue(of([mockGame1, mockGame2]));

        await TestBed.configureTestingModule({
            imports: [GameListComponent],
            providers: [
                { provide: GameListService, useValue: gameListServiceSpy },
                { provide: GameService, useValue: gameServiceSpy },
                { provide: HttpClient, useValue: httpClientSpy },
            ],
        }).compileComponents();
    });

    beforeEach(() => {
        fixture = TestBed.createComponent(GameListComponent);
        component = fixture.componentInstance;
        fixture.detectChanges();
        spyOn(window, 'alert');
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });

    it('should fetch games on init', () => {
        expect(component.games.length).toBeGreaterThan(0);
        expect(component.games[0].name).toBe('Game 1');
    });

    it('should return the correct _id of the game', () => {
        const mockGame = new Game();
        mockGame['setData']({
            _id: '1',
            name: 'Game 1',
            description: 'Description 1',
            mode: 'ctf',
            board: new Board(MEDIUM_BOARD_SIZE),
            isVisible: true,
            modificationDate: new Date().toISOString(),
        } as Game);

        expect(component.trackById(mockGame)).toBe('1');

        mockGame['setData']({
            _id: '20',
            name: 'Game 1',
            description: 'Description 1',
            mode: 'ctf',
            board: new Board(LARGE_BOARD_SIZE),
            isVisible: true,
            modificationDate: new Date().toISOString(),
        } as Game);

        expect(component.trackById(mockGame)).toBe('20');
    });

    it('should return the correct date for a game', () => {
        const mockGame = new Game();
        mockGame['setData']({
            _id: '1',
            name: 'Game 1',
            description: 'Description 1',
            mode: 'ctf',
            board: new Board(MEDIUM_BOARD_SIZE),
            isVisible: true,
            modificationDate: new Date('2025-02-06').toISOString(),
        } as Game);

        gameListServiceSpy.getDate.and.returnValue('2025-02-06');

        const result = component.getDate(mockGame);

        expect(gameListServiceSpy.getDate).toHaveBeenCalledWith(mockGame);
        expect(result).toBe('2025-02-06');
    });

    it('should call onCheckboxClick and fetchGames', () => {
        const mockGame = new Game();
        mockGame['setData']({
            _id: '1',
            name: 'Game 1',
            description: 'Description 1',
            mode: 'ctf',
            board: new Board(MEDIUM_BOARD_SIZE),
            isVisible: true,
            modificationDate: new Date().toISOString(),
        } as Game);

        gameListServiceSpy.onCheckboxClick.and.returnValue(of(mockGame));

        component.onCheckboxClick(mockGame);

        expect(gameListServiceSpy.onCheckboxClick).toHaveBeenCalledWith(mockGame);

        expect(gameServiceSpy.fetchGames).toHaveBeenCalled();
    });

    it('should call onModifyClick', () => {
        const mockGame = new Game();
        mockGame['setData']({
            _id: '1',
            name: 'Game 1',
            description: 'Description 1',
            mode: 'ctf',
            board: new Board(MEDIUM_BOARD_SIZE),
            isVisible: true,
            modificationDate: new Date().toISOString(),
        } as Game);

        component.onModifyClick(mockGame);

        expect(gameListServiceSpy.onModifyClick).toHaveBeenCalledWith(mockGame);
    });

    it('should select GameId with selectedGameId ', () => {
        const mockGame1 = new Game();
        mockGame1['setData']({
            _id: '1',
            name: 'Game 1',
            description: 'Description 1',
            mode: 'ctf',
            board: new Board(MEDIUM_BOARD_SIZE),
            isVisible: true,
            modificationDate: new Date().toISOString(),
        } as Game);

        const mockGame2 = new Game();
        mockGame2['setData']({
            _id: '20',
            name: 'Game 2',
            description: 'Description 2',
            mode: 'classique',
            board: new Board(LARGE_BOARD_SIZE),
            isVisible: false,
            modificationDate: new Date().toISOString(),
        } as Game);

        component.onSelectGame(mockGame1);
        expect(component.selectedGameId).toEqual(mockGame1._id);
        component.onSelectGame(mockGame2);
        expect(component.selectedGameId).toEqual(mockGame2._id);
    });

    it('should call onDeleteClick and fetchGames', () => {
        const mockGame = new Game();
        mockGame['setData']({
            _id: '1',
            name: 'Game 1',
            description: 'Description 1',
            mode: 'ctf',
            board: new Board(MEDIUM_BOARD_SIZE),
            isVisible: true,
            modificationDate: new Date().toISOString(),
        } as Game);

        gameListServiceSpy.onDeleteClick.and.returnValue(of(mockGame));

        component.onDeleteClick(mockGame);

        expect(gameListServiceSpy.onDeleteClick).toHaveBeenCalledWith(mockGame);
    });

    it('should call handleDeleteError when onDeleteClick fails', () => {
        const mockGame = new Game();
        mockGame['setData']({
            _id: '1',
            name: 'Game 1',
            description: 'Description 1',
            mode: 'ctf',
            board: new Board(MEDIUM_BOARD_SIZE),
            isVisible: true,
            modificationDate: new Date().toISOString(),
        } as Game);

        const errorResponse = new HttpErrorResponse({ status: 404, statusText: 'Not Found' });

        gameListServiceSpy.onDeleteClick.and.returnValue(throwError(() => errorResponse));

        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const handleDeleteErrorSpy = spyOn<any>(component, 'handleDeleteError');

        component.onDeleteClick(mockGame);

        expect(gameListServiceSpy.onDeleteClick).toHaveBeenCalledWith(mockGame);
        expect(handleDeleteErrorSpy).toHaveBeenCalledWith(errorResponse);
    });

    it('should show "Le jeu a déjà été supprimé." when error is 404', () => {
        const errorResponse = new HttpErrorResponse({ status: 404, statusText: 'Not Found' });

        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        (component as any).handleDeleteError(errorResponse);

        expect(component.errorMessage).toBe('Le jeu a déjà été supprimé.');
    });

    it('should show "Une erreur est survenue. Veuillez réessayer." for other errors', () => {
        const errorResponse = new HttpErrorResponse({ status: 500, statusText: 'Internal Server Error' });

        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        (component as any).handleDeleteError(errorResponse);

        expect(component.errorMessage).toBe('Une erreur est survenue. Veuillez réessayer.');
    });

    it('getAllGames() should handle errors by setting games to an empty array', () => {
        gameServiceSpy.fetchGames.and.returnValue(throwError(() => new Error('Failed to fetch games')));

        component['getAllGames']();

        expect(component.games).toEqual([]);
    });
});

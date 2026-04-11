import { provideHttpClient } from '@angular/common/http';
import { HttpTestingController, provideHttpClientTesting } from '@angular/common/http/testing';
import { fakeAsync, TestBed, tick } from '@angular/core/testing';
import { environment } from '@app/../environments/environment';
import { Game } from '@app/classes/game/game';
import { GameListService } from '@app/services/lobby/game-list.service';
import { GameService } from '@app/services/editor/game.service';

describe('GameListService', () => {
    let service: GameListService;
    let httpTestingController: HttpTestingController;
    let gameServiceSpy: jasmine.SpyObj<GameService>;

    beforeEach(() => {
        const gameServiceMock = jasmine.createSpyObj('GameService', ['setGame']);

        TestBed.configureTestingModule({
            providers: [GameListService, { provide: GameService, useValue: gameServiceMock }, provideHttpClient(), provideHttpClientTesting()],
        });
        service = TestBed.inject(GameListService);
        httpTestingController = TestBed.inject(HttpTestingController);
        gameServiceSpy = TestBed.inject(GameService) as jasmine.SpyObj<GameService>;
    });

    afterEach(() => {
        httpTestingController.verify();
    });

    it('should be created', () => {
        expect(service).toBeTruthy();
    });

    it('should format date correctly', () => {
        const mockGame = { modificationDate: '2025-02-06T12:00:00Z' } as Game;
        const formattedDate = service.getDate(mockGame);
        expect(formattedDate).toContain('jeudi'); // Vérifie que le jour de la semaine est présent en français
    });

    it('should call delete API on delete click', () => {
        const mockGame = { _id: '123' } as Game;
        service.onDeleteClick(mockGame).subscribe();

        const req = httpTestingController.expectOne(`${environment.serverUrl}/games/123`);
        expect(req.request.method).toBe('DELETE');
    });

    it('should call setGame on onModifyClick', () => {
        const mockGame: Game = { _id: '1' } as Game;
        service.onModifyClick(mockGame);

        expect(gameServiceSpy.setGame).toHaveBeenCalledWith(mockGame);
    });
    it('should return false if the game is found', fakeAsync(() => {
        const mockGame: Game = { _id: '123', name: 'Test Game' } as Game;

        let result: boolean | undefined;
        service.fetchGameById('123').then((res) => {
            result = res;
        });

        const req = httpTestingController.expectOne(`${environment.serverUrl}/games/123`);
        expect(req.request.method).toBe('GET');

        req.flush(mockGame);
        tick();

        expect(result).toBeFalse();
    }));

    it('should return true if the game is not found (404 error)', fakeAsync(() => {
        let result: boolean | undefined;
        service.fetchGameById('999').then((res) => {
            result = res;
        });

        const req = httpTestingController.expectOne(`${environment.serverUrl}/games/999`);
        expect(req.request.method).toBe('GET');

        req.flush({}, { status: 404, statusText: 'Not Found' });
        tick();

        expect(result).toBeTrue();
    }));
});

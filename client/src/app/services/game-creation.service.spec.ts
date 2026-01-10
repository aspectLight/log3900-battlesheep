import { TestBed } from '@angular/core/testing';
import { Game } from '@app/classes/game';
import { GameCreationService } from './game-creation.service';

describe('GameCreationService', () => {
    let service: GameCreationService;

    beforeEach(() => {
        TestBed.configureTestingModule({});
        service = TestBed.inject(GameCreationService);
    });

    it('should be created', () => {
        expect(service).toBeTruthy();
    });

    it('should store and retrieve a game code', () => {
        const mockGameCode = 'XYZ789';

        service.setGameCode(mockGameCode);

        expect(sessionStorage.getItem('gameCode')).toEqual(JSON.stringify(mockGameCode));
    });

    it('should set isHost to true', () => {
        service.isHost = true;
        expect(service.isHost).toBeTrue();
    });

    it('should set isHost to false', () => {
        service.isHost = false;
        expect(service.isHost).toBeFalse();
    });

    it('should get isHost', () => {
        expect(service.isHost).toBeFalse();
    });

    it('should set selected game', () => {
        const game = new Game();
        service.setSelectedGame(game);
        expect(service.selectedGame).toEqual(game);
    });
});

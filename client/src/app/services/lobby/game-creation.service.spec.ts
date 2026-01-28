import { TestBed } from '@angular/core/testing';
import { Game } from '@app/classes/game/game';
import { GameCreationService } from '@app/services/lobby/game-creation.service';
import { MODES } from '@app/constants/game.constants';

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

    describe('isCTF getter', () => {
        it('should return true when game mode is CTF', () => {
            const game = new Game();
            game.mode = MODES.CTF;
            service.setSelectedGame(game);
            expect(service.isCTF).toBeTrue();
        });

        it('should return false when game mode is not CTF', () => {
            const game = new Game();
            game.mode = MODES.CLASSIQUE;
            service.setSelectedGame(game);
            expect(service.isCTF).toBeFalse();
        });

        it('should return false when no game is selected', () => {
            service.selectedGame = null as unknown as Game;
            expect(service.isCTF).toBeFalse();
        });
    });
});

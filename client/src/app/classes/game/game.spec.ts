import { Game } from '@app/classes/game/game';

describe('Game', () => {
    it('should create an instance', () => {
        expect(new Game()).toBeTruthy();
    });

    describe('isCTF', () => {
        it('should return true when mode is ctf', () => {
            const game = new Game();
            game.mode = 'ctf';
            expect(game.isCTF).toBeTrue();
        });

        it('should return false when mode is not ctf', () => {
            const game = new Game();
            game.mode = 'other';
            expect(game.isCTF).toBeFalse();
        });
    });
});

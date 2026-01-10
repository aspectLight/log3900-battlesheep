import { GAME_RESULT_MESSAGES, MODES, OUTCOME } from './game.constants';

describe('Game Constants', () => {
    describe('GAME_RESULT_MESSAGES', () => {
        describe('OUTCOME.LOSE messages', () => {
            describe('MODES.CLASSIQUE', () => {
                it('should return default defeat message when no winner is specified', () => {
                    const message = GAME_RESULT_MESSAGES[OUTCOME.LOSE][MODES.CLASSIQUE]();
                    expect(message).toBe('Défaite! Un joueur a gagné trois combats');
                });

                it('should return defeat message with winner name when specified', () => {
                    const winner = 'Joueur 1';
                    const message = GAME_RESULT_MESSAGES[OUTCOME.LOSE][MODES.CLASSIQUE]({ winner });
                    expect(message).toBe(`Défaite! ${winner} a gagné trois combats`);
                });
            });

            describe('MODES.CTF', () => {
                it('should return default defeat message when no winner is specified', () => {
                    const message = GAME_RESULT_MESSAGES[OUTCOME.LOSE][MODES.CTF]();
                    expect(message).toBe("Défaite! L'équipe adverse a capturé le drapeau !");
                });

                it('should return defeat message with team number when specified', () => {
                    const winner = 2;
                    const message = GAME_RESULT_MESSAGES[OUTCOME.LOSE][MODES.CTF]({ winner });
                    expect(message).toBe(`Défaite! L'équipe ${winner} a capturé le drapeau !`);
                });

                it('should return defeat message with team name when string is specified', () => {
                    const winner = 'Rouge';
                    const message = GAME_RESULT_MESSAGES[OUTCOME.LOSE][MODES.CTF]({ winner });
                    expect(message).toBe(`Défaite! L'équipe ${winner} a capturé le drapeau !`);
                });
            });
        });
    });
});

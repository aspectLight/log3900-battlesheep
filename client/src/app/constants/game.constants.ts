export enum MODES {
    CLASSIQUE = 'classique',
    CTF = 'ctf',
}

export const MODE_DESCRIPTIONS: { [key in MODES]: string } = {
    [MODES.CLASSIQUE]: 'Gagnez 3 combats pour être déclaré vainqueur et mettre fin à la partie.',
    [MODES.CTF]: 'Capturez le drapeau adverse et ramenez-le à votre point de départ pour gagner la partie.',
};

export enum OUTCOME {
    WIN = 'win',
    LOSE = 'lose',
}

export interface GameResult {
    outcome: OUTCOME;
    victoryType: MODES;
}

export const GAME_RESULT_MESSAGES: {
    [outcome in OUTCOME]: {
        [mode in MODES]: (args?: { winner?: string | number }) => string;
    };
} = {
    [OUTCOME.WIN]: {
        [MODES.CLASSIQUE]: () => 'Victoire! Tu as gagné trois combats',
        [MODES.CTF]: () => 'Victoire! Ton équipe a capturé le drapeau !',
    },
    [OUTCOME.LOSE]: {
        [MODES.CLASSIQUE]: ({ winner } = {}) => `Défaite! ${winner ?? 'Un joueur'} a gagné trois combats`,
        [MODES.CTF]: ({ winner } = {}) => `Défaite! ${winner ? "L'équipe " + winner : "L'équipe adverse"} a capturé le drapeau !`,
    },
};

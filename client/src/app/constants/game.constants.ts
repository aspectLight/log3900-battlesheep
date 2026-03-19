import { GameResult } from '@app/interfaces/game-result.interface';

export { GameResult };

export enum MODES {
    CLASSIQUE = 'classique',
    CTF = 'ctf',
}

export const MODE_DESCRIPTIONS: { [key in MODES]: string } = {
    [MODES.CLASSIQUE]: 'game_configurator.mode_desc_classic',
    [MODES.CTF]: 'game_configurator.mode_desc_ctf',
};

export enum OUTCOME {
    WIN = 'win',
    LOSE = 'lose',
}

export const GAME_RESULT_KEYS: {
    [outcome in OUTCOME]: {
        [mode in MODES]: (args?: { winner?: string | number }) => { key: string; params?: object };
    };
} = {
    [OUTCOME.WIN]: {
        [MODES.CLASSIQUE]: () => ({ key: 'game_result.win_classic' }),
        [MODES.CTF]: () => ({ key: 'game_result.win_ctf' }),
    },
    [OUTCOME.LOSE]: {
        [MODES.CLASSIQUE]: ({ winner } = {}) => ({
            key: winner ? 'game_result.lose_classic_known' : 'game_result.lose_classic_unknown',
            params: { winner },
        }),
        [MODES.CTF]: ({ winner } = {}) => ({
            key: winner ? 'game_result.lose_ctf_known' : 'game_result.lose_ctf_unknown',
            params: { winner },
        }),
    },
};

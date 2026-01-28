import { MODES, OUTCOME } from '@app/constants/game.constants';

export interface GameResult {
    outcome: OUTCOME;
    victoryType: MODES;
}

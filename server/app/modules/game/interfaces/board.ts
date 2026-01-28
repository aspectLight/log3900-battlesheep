import { Cell } from '@app/modules/game/interfaces/cell';

export interface Board {
    size: number;
    matrix: Cell[][];
}

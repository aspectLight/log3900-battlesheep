import { Cell } from '@app/interfaces/cell';

export interface Board {
    size: number;
    matrix: Cell[][];
}

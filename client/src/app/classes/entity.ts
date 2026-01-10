import { MAX_ENTITY_ID } from '@app/constants/player.constants';
import { Cell } from './cell';

/* 
Ceci est une classe en prévision des prochains sprints, notamment avec l'ajout d'une ia

NOTE: 
    - addCell est pour attribuer une case au player (pour permettre d'accéder au données de sa case)
*/

export abstract class Entity {
    id: string;
    cell: Cell | null = null;

    constructor() {
        this.id = this.generateRandomId();
    }

    addCell(cell: Cell) {
        this.cell = cell;
    }

    removeCell() {
        this.cell = null;
    }

    protected generateRandomId(): string {
        const timestamp = Date.now();
        const random = Math.floor(Math.random() * MAX_ENTITY_ID);
        return parseInt(`${timestamp}${random}`, 10).toString();
    }
}

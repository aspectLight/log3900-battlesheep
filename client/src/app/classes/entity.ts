import { MAX_ENTITY_ID } from '@app/constants/player.constants';
import { Cell } from './cell';

/* NOTE: 
    - addCell is meant to assign a cell to the entity ( so that the player "knows where he is" )
*/

export abstract class Entity {
    cell: Cell | null = null;

    private _id: string;

    constructor() {
        this._id = this.generateRandomId();
    }

    get id(): string {
        return this._id;
    }

    // For simplification, we allow the id to be set, only on specific cases
    set id(id: string) {
        this._id = id;
    }

    addCell(cell: Cell) {
        this.cell = cell;
    }

    protected generateRandomId(): string {
        const timestamp = Date.now();
        const random = Math.floor(Math.random() * MAX_ENTITY_ID);
        return parseInt(`${timestamp}${random}`, 10).toString();
    }
}

import { ErrorMessages } from '@common/error-messages.constants';
import { Entity } from './entity';
import { ITEM_TYPES } from '@app/constants/item.constants';

export class Item extends Entity {
    name: string;
    description: string;
    imagePath: string;
    type: string;

    constructor(type: string) {
        super();
        const itemData = ITEM_TYPES[type];
        if (!itemData) {
            throw new Error(ErrorMessages.InvalidItem + type);
        }
        this.name = itemData.name;
        this.description = itemData.description;
        this.imagePath = itemData.imagePath;
        this.type = type;
    }
}

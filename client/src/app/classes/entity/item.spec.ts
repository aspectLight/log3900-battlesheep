import { Item } from '@app/classes/entity/item';
import { ITEM_TYPES } from '@app/constants/item.constants';

describe('Item', () => {
    it('should create an instance', () => {
        expect(new Item('adrenaline')).toBeTruthy();
    });

    it('should create an item with valid type', () => {
        const item = new Item('vodka');
        expect(item).toBeInstanceOf(Item);
        expect(item.type).toBe('vodka');
        expect(item.name).toBe(ITEM_TYPES['vodka'].name);
        expect(item.description).toBe(ITEM_TYPES['vodka'].description);
        expect(item.imagePath).toBe(ITEM_TYPES['vodka'].imagePath);
    });

    it('should throw an error for an invalid item type', () => {
        expect(() => new Item('invalidType')).toThrowError('Invalid item type: invalidType');
    });
});

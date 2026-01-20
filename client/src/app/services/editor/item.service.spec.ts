import { TestBed } from '@angular/core/testing';
import { ITEM_TYPES } from '@app/constants/item.constants';
import { ItemService } from '@app/services/editor/item.service';
import { BoardSizes, BOARD_CONFIGS } from '@app/constants/board.constants';
import { Board } from '@app/classes/board/board';
import { Item } from '@app/classes/entity/item';

const ITEM_COUNT = 6;
const UNIQUE_ITEM_COUNT = 1;

describe('ItemService', () => {
    let service: ItemService;
    let mockBoard: Board;

    beforeEach(() => {
        TestBed.configureTestingModule({
            providers: [ItemService],
        });
        service = TestBed.inject(ItemService);
        service.maxItemCount = ITEM_COUNT;
        service.resetCount();
    });

    it('should be created', () => {
        expect(service).toBeTruthy();
    });

    it('should initialize inventory correctly based on item type', () => {
        Object.keys(ITEM_TYPES).forEach((key) => {
            const expectedCount = key === 'random' || key === 'spawnPoint' ? ITEM_COUNT : UNIQUE_ITEM_COUNT;
            expect(service.inventory[key]).toBe(expectedCount);
        });
    });

    it('should increase item count when putting back or placing an item', () => {
        const itemType = Object.keys(ITEM_TYPES)[0];

        service.placeItem(itemType);
        expect(service.getItemCount(itemType)).toBe(0);

        service.putBackItem(itemType);
        expect(service.getItemCount(itemType)).toBe(1);
    });

    it('should throw an error when placing an invalid item type', () => {
        expect(() => service.placeItem('INVALID_TYPE')).toThrowError('Invalid item type: INVALID_TYPE');
    });

    it('should throw an error when putting back an invalid item type', () => {
        expect(() => service.putBackItem('INVALID_TYPE')).toThrowError('Invalid item type: INVALID_TYPE');
    });

    it('should return the correct inventory object', () => {
        const inventory = service.getInventory();
        expect(Object.keys(inventory)).toEqual(Object.keys(ITEM_TYPES));
        Object.keys(ITEM_TYPES).forEach((key) => {
            const expectedCount = key === 'random' || key === 'spawnPoint' ? ITEM_COUNT : UNIQUE_ITEM_COUNT;
            expect(inventory[key]).toBe(expectedCount);
        });
    });

    it('should get item count', () => {
        const itemType = 'adrenaline';
        const initialCount = service.getItemCount(itemType);

        service.placeItem(itemType);
        expect(service.getItemCount(itemType)).toBe(initialCount - 1);
    });

    it('should return 0 when random is 0 and type is not spawnPoint', () => {
        const nonSpawnItemType = 'adrenaline';
        service.inventory['random'] = 0;

        expect(service.getItemCount(nonSpawnItemType)).toBe(0);
    });

    it('should get inventory', () => {
        expect(service.getInventory()).toEqual(service.inventory);
    });

    it('should get the good number of items placed', () => {
        const itemType = 'adrenaline';
        service.placeItem(itemType);
        expect(service.getTotalItemsPlaced()).toEqual(1);
    });

    it('should get the correct number of spawn points placed', () => {
        const itemType = 'spawnPoint';
        const initialSpawnCount = service.getSpawnPointCount();
        service.placeItem(itemType);
        expect(service.getSpawnPointCount()).toEqual(initialSpawnCount - 1);
    });

    it('should correctly update inventory and totalItemsPlaced when setting item count from board', () => {
        mockBoard = new Board(BOARD_CONFIGS[BoardSizes.Grande].board);
        const item = new Item('adrenaline');
        const spawn = new Item('spawnPoint');

        mockBoard.getCell(0, 0)?.addItem(item);
        mockBoard.getCell(1, 1)?.addItem(spawn);
        service.setItemCountFromBoard(mockBoard);

        expect(service.getItemCount('adrenaline')).toBe(0);
        expect(service.getItemCount('spawnPoint')).toBe(ITEM_COUNT - 1);
        expect(service.getTotalItemsPlaced()).toBe(1);
        expect(service.getItemCount('random')).toBe(ITEM_COUNT - 1);
    });

    it('should throw an error when the board size is invalid', () => {
        const invalidBoard = new Board(1);
        expect(() => service.getMaximumItemCount(invalidBoard)).toThrowError('Invalid board size: 1');
    });
});

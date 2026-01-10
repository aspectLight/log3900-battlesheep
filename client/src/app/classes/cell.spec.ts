import { Cell } from './cell';
import { Item } from './item';
import { Player } from './player';
import { Tile } from './tile';

describe('Cell', () => {
    let cell: Cell;
    let tile: Tile;
    const x = 2;
    const y = 3;

    beforeEach(() => {
        tile = new Tile('ice');
        cell = new Cell(tile, x, y);
    });

    it('should create a cell with correct properties', () => {
        expect(cell.tile).toBe(tile);
        expect(cell.x).toBe(x);
        expect(cell.y).toBe(y);
        expect(cell.getItem()).toBeNull();
    });

    it('should add an item to the cell', () => {
        const item = new Item('adrenaline');
        cell.addItem(item);
        expect(cell.getItem()).toBeInstanceOf(Item);
        expect(cell.getItem()?.type).toBe('adrenaline');
    });

    it('should replace existing item when adding a new one', () => {
        const firstItem = new Item('propaganda');
        const secondItem = new Item('camouflage');

        cell.addItem(firstItem);
        expect(cell.getItem()?.type).toBe('propaganda');

        cell.addItem(secondItem);
        expect(cell.getItem()?.type).toBe('camouflage');
    });

    it('should remove an item from the cell', () => {
        const item = new Item('vodka');
        cell.addItem(item);
        expect(cell.getItem()).not.toBeNull();

        cell.removeItem();
        expect(cell.getItem()).toBeNull();
    });

    it('should return null when getting an item from an empty cell', () => {
        expect(cell.getEntity()).toBeNull();
    });

    it('should add a player to the cell', () => {
        const player = { name: 'TestPlayer' } as Player;
        cell.addEntity(player);
        expect(cell.getEntity()).toBe(player);
    });

    it('should remove a player from the cell', () => {
        const player = { name: 'TestPlayer' } as Player;
        cell.addEntity(player);
        expect(cell.getEntity()).toBe(player);

        cell.removeEntity();
        expect(cell.getEntity()).toBeNull();
    });

    it('should correctly copy properties from another Cell object', () => {
        const item = new Item('adrenaline');
        const player = new Player('player1', 'Player One');
        cell.player = player;
        cell.item = item;

        cell.hasPathUp = true;
        cell.hasPathDown = false;
        cell.hasPathLeft = true;
        cell.hasPathRight = false;

        const copiedCell = Cell.fromObject(cell);

        expect(copiedCell.tile).toBe(tile);
        expect(copiedCell.x).toBe(x);
        expect(copiedCell.y).toBe(y);
        expect(copiedCell.hasPathUp).toBe(true);
        expect(copiedCell.hasPathDown).toBe(false);
        expect(copiedCell.hasPathLeft).toBe(true);
        expect(copiedCell.hasPathRight).toBe(false);

        expect(copiedCell.item?.type).toEqual(item.type);
        expect(copiedCell.player).toEqual(player);
    });

    it('should handle missing properties like item and player', () => {
        const copiedCell = Cell.fromObject(cell);
        expect(copiedCell.getItem()).toBeNull();
        expect(copiedCell.getEntity()).toBeNull();
    });
});

import { Cell } from './cell';
import { Entity } from './entity';
import { Tile } from './tile';

class TestEntity extends Entity {}

describe('Entity', () => {
    let entity: TestEntity;
    let cell: Cell;

    beforeEach(() => {
        entity = new TestEntity();
        cell = new Cell(new Tile('ice'), 1, 1);
    });

    it('should initially have no assigned cell', () => {
        expect(entity.cell).toBeNull();
    });

    it('should assign a cell correctly', () => {
        entity.addCell(cell);
        expect(entity.cell).toBe(cell);
    });

    it('should remove a cell correctly', () => {
        entity.addCell(cell);
        entity.removeCell();
        expect(entity.cell).toBeNull();
    });
});

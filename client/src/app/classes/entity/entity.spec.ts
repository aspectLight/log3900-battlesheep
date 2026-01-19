import { Cell } from '@app/classes/board/cell';
import { Tile } from '@app/classes/board/tile';
import { Entity } from '@app/classes/entity/entity';

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
});

import { TestBed } from '@angular/core/testing';
import { Cell } from '@app/classes/board/cell';
import { Item } from '@app/classes/entity/item';
import { DragDropService } from '@app/services/editor/drag-drop.service';
import { ItemService } from '@app/services/editor/item.service';

describe('DragDropService', () => {
    let service: DragDropService;
    let itemServiceSpy: jasmine.SpyObj<ItemService>;

    beforeEach(() => {
        itemServiceSpy = jasmine.createSpyObj('ItemService', ['putBackItem', 'placeItem']);

        TestBed.configureTestingModule({
            providers: [DragDropService, { provide: ItemService, useValue: itemServiceSpy }],
        });
        service = TestBed.inject(DragDropService);
    });

    it('should be created', () => {
        expect(service).toBeTruthy();
    });

    it('should start drag correctly', () => {
        const mockItem = { type: 'Adrenaline' } as Item;
        const mockCell = { x: 1, y: 1, tile: { moveModifier: 1 } } as Cell;

        service.startDrag(mockItem, mockCell);

        expect(service['isDragging']).toBeTrue();
        expect(service['draggedItem']).toEqual(mockItem);
        expect(service['sourceCell']).toEqual(mockCell);
    });

    it('should reset state and return item if drag ends', () => {
        const mockItem = { type: 'Adrenaline' } as Item;
        const mockCell = { removeItem: jasmine.createSpy() } as unknown as Cell;

        service.startDrag(mockItem, mockCell);
        service.handleDragEnd();

        expect(mockCell.removeItem).toHaveBeenCalled();
        expect(itemServiceSpy.putBackItem).toHaveBeenCalledWith('Adrenaline');
        expect(service['isDragging']).toBeFalse();
        expect(service['draggedItem']).toBeNull();
    });

    it('should allow drop by preventing default event behavior', () => {
        const event = new DragEvent('dragover');
        spyOn(event, 'preventDefault');

        service.allowDrop(event);

        expect(event.preventDefault).toHaveBeenCalled();
    });

    it('should do nothing if not dragging or no dragged item', () => {
        const mockCell = { tile: { moveModifier: 1 } } as Cell;
        service.handleDrop(mockCell);
        expect(itemServiceSpy.putBackItem).not.toHaveBeenCalled();
        expect(itemServiceSpy.placeItem).not.toHaveBeenCalled();
    });

    it('should reset state if dropped on an invalid cell', () => {
        const mockItem = { type: 'Adrenaline' } as Item;
        const invalidCell = { tile: { moveModifier: -1 } } as Cell;

        service.startDrag(mockItem);
        service.handleDrop(invalidCell);

        expect(service['isDragging']).toBeFalse();
        expect(service['draggedItem']).toBeNull();
    });

    it('should return item to inventory if dropped at source cell', () => {
        const mockItem = { type: 'Adrenaline' } as Item;
        const mockCell = {
            x: 1,
            y: 1,
            tile: { moveModifier: 1 },
            removeItem: jasmine.createSpy('removeItem'),
            getItem: jasmine.createSpy('getItem').and.returnValue(null),
            addItem: jasmine.createSpy('addItem'),
        } as unknown as Cell;

        service.startDrag(mockItem, mockCell);
        service.handleDrop(mockCell);

        expect(mockCell.removeItem).toHaveBeenCalled();
        expect(itemServiceSpy.putBackItem).toHaveBeenCalledWith(mockItem.type);
    });

    it('should move item and update services if dropped elsewhere', () => {
        const mockItem = { type: 'Adrenaline' } as Item;
        const sourceCell = {
            x: 1,
            y: 1,
            tile: { moveModifier: 1 },
            removeItem: jasmine.createSpy('removeItem'),
            getItem: jasmine.createSpy('getItem').and.returnValue(null),
            addItem: jasmine.createSpy('addItem'),
        } as unknown as Cell;
        const targetCell = {
            x: 2,
            y: 2,
            tile: { moveModifier: 1 },
            removeItem: jasmine.createSpy('removeItem'),
            getItem: jasmine.createSpy('getItem').and.returnValue(null),
            addItem: jasmine.createSpy('addItem'),
        } as unknown as Cell;

        service.startDrag(mockItem, sourceCell);
        service.handleDrop(targetCell);

        expect(targetCell.addItem).toHaveBeenCalledWith(mockItem);
        expect(itemServiceSpy.placeItem).toHaveBeenCalledWith(mockItem.type);
        expect(sourceCell.removeItem).toHaveBeenCalled();
        expect(itemServiceSpy.putBackItem).toHaveBeenCalledWith(mockItem.type);
    });

    it('should return the dragged item type when dragging', () => {
        const mockItem = { type: 'propaganda' } as Item;
        service.startDrag(mockItem);

        expect(service.getDraggedItem()).toBe('propaganda');
    });

    it('should put back the replaced item and remove it if target cell already has an item', () => {
        const draggedItem = { type: 'Adrenaline' } as unknown as Item;

        const sourceCell = {
            x: 1,
            y: 1,
            tile: { moveModifier: 1 },
            removeItem: jasmine.createSpy('removeItem'),
            getItem: jasmine.createSpy('getItem').and.returnValue(null),
            addItem: jasmine.createSpy('addItem'),
        } as unknown as Cell;

        const replacedItem = { type: 'Propaganda' } as unknown as Item;
        const targetCell = {
            x: 2,
            y: 2,
            tile: { moveModifier: 1 },

            item: replacedItem,
            removeItem: jasmine.createSpy('removeItem'),
            getItem: jasmine.createSpy('getItem').and.returnValue(replacedItem),
            addItem: jasmine.createSpy('addItem'),
        } as unknown as Cell;

        service.startDrag(draggedItem, sourceCell);

        service.handleDrop(targetCell);

        expect(itemServiceSpy.putBackItem).toHaveBeenCalledWith(replacedItem.type);

        expect(targetCell.removeItem).toHaveBeenCalled();
    });

    it('should reset state if dropped on a closed door', () => {
        const mockItem = { type: 'Adrenaline' } as Item;
        const doorCell = {
            tile: {
                type: 'door',
                state: 'closed',
                moveModifier: 1,
            },
        } as Cell;

        service.startDrag(mockItem);
        service.handleDrop(doorCell);

        expect(service['isDragging']).toBeFalse();
        expect(service['draggedItem']).toBeNull();
        expect(itemServiceSpy.putBackItem).not.toHaveBeenCalled();
        expect(itemServiceSpy.placeItem).not.toHaveBeenCalled();
    });
});

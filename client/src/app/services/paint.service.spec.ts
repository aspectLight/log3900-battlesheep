import { TestBed } from '@angular/core/testing';

import { Board } from '@app/classes/board';
import { Cell } from '@app/classes/cell';
import { Item } from '@app/classes/item';
import { Tile } from '@app/classes/tile';
import { PaintService } from './paint.service';

describe('PaintService', () => {
    let service: PaintService;
    const cell = new Cell(new Tile('snow'), 0, 0);
    const board = new Board(2);

    beforeEach(() => {
        TestBed.configureTestingModule({});
        service = TestBed.inject(PaintService);
    });

    it('should be created', () => {
        expect(service).toBeTruthy();
    });

    it('should disable painting', () => {
        service.disable('tiles');
        expect(service['isDisabled']).toBeFalse();
    });

    it('should enable painting', () => {
        service.disable('paint');
        expect(service['isDisabled']).toBeTrue();
    });

    it('should not paint on click if paint disabled', () => {
        const setTileSpy = spyOn(board, 'setTile');
        const event = new MouseEvent('contextmenu', { button: 0 });
        service.isDisabled = true;
        service.handleMouseDown(event, cell, board);
        expect(setTileSpy).not.toHaveBeenCalled();
    });

    it('should paint on click', () => {
        const setTileSpy = spyOn(board, 'setTile');

        spyOn(service['tileService'], 'getActiveTile').and.returnValue(new Tile('water'));
        service.isDisabled = false;

        const event = new MouseEvent('click', { button: 0 });
        service.handleMouseDown(event, cell, board);
        expect(setTileSpy).toHaveBeenCalledWith(cell.x, cell.y, jasmine.any(Tile));
    });

    it('should change state of cell if same tile', () => {
        const door = new Cell(new Tile('door'), 0, 0);
        const toggleStateSpy = spyOn(door.tile, 'toggleState');
        spyOn(service['tileService'], 'getActiveTile').and.returnValue(new Tile('door'));
        service.isDisabled = false;
        const event = new MouseEvent('click', { button: 0 });
        service.handleMouseDown(event, door, board);
        service.handleMouseDown(event, door, board);
        expect(toggleStateSpy).toHaveBeenCalled();
    });

    it('should erase item if cell has an item before painting', () => {
        cell.addItem(new Item('propaganda'));
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const eraseItemSpy = spyOn<any>(service, 'eraseItem').and.callThrough();
        const setTileSpy = spyOn(board, 'setTile');

        spyOn(service['tileService'], 'getActiveTile').and.returnValue(new Tile('water'));

        const event = new MouseEvent('click', { button: 0 });
        service.handleMouseDown(event, cell, board);

        expect(eraseItemSpy).toHaveBeenCalledWith(cell);
        expect(setTileSpy).toHaveBeenCalledWith(cell.x, cell.y, jasmine.objectContaining({ type: 'water' }));
    });

    it('should update surrounding tiles when painting a structural tile', () => {
        const updateSurroundingTilesSpy = spyOn(service['autoTileService'], 'updateSurroundingTiles');
        spyOn(service['tileService'], 'getActiveTile').and.returnValue(new Tile('wall'));

        const event = new MouseEvent('click', { button: 0 });
        service.handleMouseDown(event, cell, board);

        expect(updateSurroundingTilesSpy).toHaveBeenCalledWith(cell.x, cell.y, board);
    });

    it('should paint on move', () => {
        const setTileSpy = spyOn(board, 'setTile');
        const toggleStateSpy = spyOn(cell.tile, 'toggleState');

        spyOn(service['tileService'], 'getActiveTile').and.returnValue(new Tile('ice'));

        service.isPainting = true;
        service.handleMouseMove(cell, board);

        expect(setTileSpy).toHaveBeenCalledWith(cell.x, cell.y, jasmine.objectContaining({ type: 'ice' }));

        expect(toggleStateSpy).not.toHaveBeenCalled();
    });

    it('should reset interaction state after releasing the mouse', () => {
        service.isPainting = true;
        service.isErasing = true;
        service.handleMouseUp();
        expect(service.isPainting).toBeFalse();
        expect(service.isErasing).toBeFalse();
    });

    it('should only erase item when isDisabled is true', () => {
        cell.addItem(new Item('adrenaline'));
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const eraseItemSpy = spyOn<any>(service, 'eraseItem').and.callThrough();
        const event = new MouseEvent('contextmenu', { button: 2 });

        service.isDisabled = true;
        service.handleMouseDown(event, cell, board);

        expect(eraseItemSpy).toHaveBeenCalledWith(cell);
    });

    it('should reset tile and update surrounding tiles when erasing', () => {
        const setTileDefaultSpy = spyOn(board, 'setTileDefault');
        const updateSurroundingTilesSpy = spyOn(service['autoTileService'], 'updateSurroundingTiles');
        service.isDisabled = false;
        const event = new MouseEvent('contextmenu', { button: 2 });
        service.handleMouseDown(event, cell, board);
        expect(setTileDefaultSpy).toHaveBeenCalledWith(cell.x, cell.y);
        expect(updateSurroundingTilesSpy).toHaveBeenCalledWith(cell.x, cell.y, board);
    });

    it('paint() should return early if active tile is undefined', () => {
        spyOn(service['tileService'], 'getActiveTile').and.returnValue(undefined as unknown as Tile);
        const setTileSpy = spyOn(board, 'setTile');
        const toggleStateSpy = spyOn(cell.tile, 'toggleState');
        const event = new MouseEvent('click', { button: 0 });
        service.handleMouseDown(event, cell, board);
        expect(setTileSpy).not.toHaveBeenCalled();
        expect(toggleStateSpy).not.toHaveBeenCalled();
    });

    it('should erase on mouse move when isErasing is true', () => {
        // Spy on the private erase method (which is called by handleMouseMove when isErasing is true)
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const eraseSpy = spyOn<any>(service, 'erase').and.callThrough();
        const setTileDefaultSpy = spyOn(board, 'setTileDefault');
        const updateSurroundingTilesSpy = spyOn(service['autoTileService'], 'updateSurroundingTiles');

        // Force the service into erasing mode
        service.isErasing = true;

        // Call handleMouseMove: it should execute this.erase(cell, board)
        service.handleMouseMove(cell, board);

        // Verify that the private erase method was called with both cell and board as arguments
        expect(eraseSpy).toHaveBeenCalledWith(cell, board);
        expect(setTileDefaultSpy).toHaveBeenCalledWith(cell.x, cell.y);
        expect(updateSurroundingTilesSpy).toHaveBeenCalledWith(cell.x, cell.y, board);
    });
});

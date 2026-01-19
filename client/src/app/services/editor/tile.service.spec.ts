import { TestBed } from '@angular/core/testing';
import { Tile } from '@app/classes/board/tile';
import { TileService } from '@app/services/editor/tile.service';

describe('TileService', () => {
    let service: TileService;
    let testTile: Tile;
    const ROTATION = 'Vertical';

    beforeEach(() => {
        TestBed.configureTestingModule({});
        service = TestBed.inject(TileService);
        testTile = new Tile('door');
        service.setActiveTile(testTile);
    });

    it('should be created', () => {
        expect(service).toBeTruthy();
    });

    it('should get the active tile', () => {
        expect(service.getActiveTile()).toEqual(testTile);
    });

    it('should set the active tile', () => {
        expect(service.getActiveTile()).toEqual(testTile);
    });

    it('should change the active tile if you set a different tile', () => {
        const newTile = new Tile('water');
        service.setActiveTile(newTile);
        expect(service.getActiveTile()).toEqual(newTile);
    });

    it('should toggle state if you want to set the same tile', () => {
        spyOn(service, 'toggleState');
        const newTile = new Tile('door');
        service.setActiveTile(newTile);
        return expect(service.toggleState).toHaveBeenCalled();
    });

    it('should toggle the active tile state', () => {
        service.toggleState();
        expect(service.getActiveTile().state).toEqual('opened');
    });

    it('should toggle the active tile rotation', () => {
        service.toggleRotation();
        expect(service.getActiveTile().orientation).toEqual(ROTATION);
    });

    it('should clear the active tile when clearActiveTile() is called', () => {
        const activeTile = new Tile('water');
        service.setActiveTile(activeTile);
        expect(service.getActiveTile().type).toBe('water');
        service.clearActiveTile();
        expect(service.getActiveTile().type).toBe('snow');
    });
});

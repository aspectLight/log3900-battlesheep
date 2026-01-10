import { ComponentFixture, TestBed } from '@angular/core/testing';
import { SimpleChange, SimpleChanges } from '@angular/core';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { Tile } from '@app/classes/tile';
import { DragDropService } from '@app/services/drag-drop.service';
import { GameService } from '@app/services/game.service';
import { ItemService } from '@app/services/item.service';
import { PaintService } from '@app/services/paint.service';
import { TileService } from '@app/services/tile.service';

import { ToolboxComponent } from './toolbox.component';

const ITEM_COUNT = 1;
const TOTAL_ITEM_COUNT = 3;

describe('ToolboxComponent', () => {
    let component: ToolboxComponent;
    let fixture: ComponentFixture<ToolboxComponent>;
    let dragDropServiceSpy: jasmine.SpyObj<DragDropService>;
    let gameServiceSpy: jasmine.SpyObj<GameService>;
    let itemServiceSpy: jasmine.SpyObj<ItemService>;
    let paintServiceSpy: jasmine.SpyObj<PaintService>;
    let tileServiceSpy: jasmine.SpyObj<TileService>;

    beforeEach(async () => {
        dragDropServiceSpy = jasmine.createSpyObj('DragndropService', ['handleDragEnd', 'startDrag', 'getDraggedItem']);
        gameServiceSpy = jasmine.createSpyObj('GameService', ['getName', 'getDescription', 'getDescription', 'setName', 'setDescription']);
        itemServiceSpy = jasmine.createSpyObj('ItemService', ['getItemCount', 'getSpawnPointCount', 'getTotalItemsPlaced']);
        paintServiceSpy = jasmine.createSpyObj('PaintService', ['disable']);
        tileServiceSpy = jasmine.createSpyObj('TileService', [
            'setActiveTile',
            'getActiveTile',
            'getActiveTileImage',
            'toggleRotation',
            'clearActiveTile',
        ]);
        await TestBed.configureTestingModule({
            imports: [ToolboxComponent, BrowserAnimationsModule],
            providers: [
                { provide: DragDropService, useValue: dragDropServiceSpy },
                { provide: GameService, useValue: gameServiceSpy },
                { provide: ItemService, useValue: itemServiceSpy },
                { provide: PaintService, useValue: paintServiceSpy },
                { provide: TileService, useValue: tileServiceSpy },
            ],
        }).compileComponents();

        tileServiceSpy.getActiveTile.and.returnValue(new Tile('snow'));
        itemServiceSpy.getItemCount.and.returnValue(ITEM_COUNT);
        dragDropServiceSpy.getDraggedItem.and.returnValue('adrenaline');
        tileServiceSpy.setActiveTile.and.returnValue();
        tileServiceSpy.getActiveTileImage.and.returnValue('/assets/tiles/snow_variant1.png');
        paintServiceSpy.disable.and.returnValue();
        itemServiceSpy.getTotalItemsPlaced.and.returnValue(TOTAL_ITEM_COUNT);

        fixture = TestBed.createComponent(ToolboxComponent);
        component = fixture.componentInstance;
        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });

    it('should call resetInputs when resetSignal changes', () => {
        spyOn(component, 'resetInputs');
        // Create a SimpleChanges object where the resetSignal value has changed.
        const changes: SimpleChanges = {
            resetSignal: new SimpleChange(false, true, false),
        };
        component.ngOnChanges(changes);
        expect(component.resetInputs).toHaveBeenCalled();
    });

    it('should not call resetInputs when resetSignal does not change', () => {
        spyOn(component, 'resetInputs');
        // Create a SimpleChanges object where the resetSignal value remains the same.
        const changes: SimpleChanges = {
            resetSignal: new SimpleChange(true, true, false),
        };
        component.ngOnChanges(changes);
        expect(component.resetInputs).not.toHaveBeenCalled();
    });

    it('should get active tile', () => {
        expect(component.activeTile).toEqual('/assets/tiles/snow_variant1.png');
    });

    it('should not call toggleRotation when a key other than "r" is pressed', () => {
        const event = new KeyboardEvent('keydown', { key: 'a' });
        spyOn(component, 'toggleRotation');
        document.dispatchEvent(event);
        expect(component.toggleRotation).not.toHaveBeenCalled();
    });

    it('should call ngOnInit', () => {
        component.ngOnInit();
        expect(gameServiceSpy.getName).toHaveBeenCalled();
        expect(gameServiceSpy.getDescription).toHaveBeenCalled();
    });

    it('should set active tile', () => {
        component.setActiveTile('snow');
        expect(tileServiceSpy.setActiveTile).toHaveBeenCalled();
    });

    it('should not set active tile if tileKey is incorrect', () => {
        component.setActiveTile('incorrect tile');
        expect(tileServiceSpy.setActiveTile).not.toHaveBeenCalled();
    });

    it('should get game name', () => {
        component.getGameName();
        expect(gameServiceSpy.getName).toHaveBeenCalled();
    });

    it('should update name', () => {
        component.nameInput = 'test';
        component.updateName();
        expect(gameServiceSpy.setName).toHaveBeenCalledWith('test');
    });

    it('should get game description', () => {
        component.getGameDescription();
        expect(gameServiceSpy.getDescription).toHaveBeenCalled();
    });

    it('should update description', () => {
        component.descriptionInput = 'test description';
        component.updateDescription();
        expect(gameServiceSpy.setDescription).toHaveBeenCalledWith('test description');
    });

    it('should get item count', () => {
        expect(component.getItemCount('adrenaline')).toEqual(1);
        expect(itemServiceSpy.getItemCount).toHaveBeenCalled();
    });

    it('should toggle rotation', () => {
        component.toggleRotation();
        expect(tileServiceSpy.toggleRotation).toHaveBeenCalled();
    });

    it('should toggle tab', () => {
        component.toggleTab('tiles');
        expect(tileServiceSpy.clearActiveTile).not.toHaveBeenCalled();
        expect(paintServiceSpy.disable).toHaveBeenCalled();
        component.toggleTab('test');
        expect(tileServiceSpy.clearActiveTile).toHaveBeenCalled();
        expect(paintServiceSpy.disable).toHaveBeenCalled();
    });

    it('should start dragging', () => {
        component.startDrag('adrenaline');
        expect(dragDropServiceSpy.startDrag).toHaveBeenCalled();
    });

    it('should not start dragging if tileKey is incorrect', () => {
        component.startDrag('incorrect item');
        expect(dragDropServiceSpy.startDrag).not.toHaveBeenCalled();
    });

    it('should handle drag end', () => {
        component.handleDragEnd();
        expect(dragDropServiceSpy.handleDragEnd).toHaveBeenCalled();
    });

    it('should get spawn point count', () => {
        component.getSpawnPointCount();
        expect(itemServiceSpy.getSpawnPointCount).toHaveBeenCalled();
    });

    it('should get total item count', () => {
        expect(component.getTotalItemsCount()).toEqual(TOTAL_ITEM_COUNT);
        expect(itemServiceSpy.getTotalItemsPlaced).toHaveBeenCalled();
    });

    it('should reset inputs', () => {
        component.nameInput = 'testName';
        component.descriptionInput = 'testDescription';

        component.resetInputs();

        expect(component.nameInput).toBe('');
        expect(component.descriptionInput).toBe('');
    });
});

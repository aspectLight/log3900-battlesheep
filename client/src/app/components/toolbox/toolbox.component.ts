import { animate, style, transition, trigger } from '@angular/animations';
import { KeyValuePipe } from '@angular/common';
import { Component, Input, OnInit, OnChanges, SimpleChanges } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Item } from '@app/classes/item';
import { Tile } from '@app/classes/tile';
import { ITEM_TYPES } from '@app/constants/item.constants';
import { TILE_TYPES } from '@app/constants/tile.constants';
import { DragDropService } from '@app/services/drag-drop.service';
import { GameService } from '@app/services/game.service';
import { ItemService } from '@app/services/item.service';
import { PaintService } from '@app/services/paint.service';
import { TileService } from '@app/services/tile.service';

@Component({
    selector: 'app-toolbox',
    imports: [KeyValuePipe, FormsModule],
    templateUrl: './toolbox.component.html',
    styleUrls: ['./toolbox.component.scss'],
    animations: [
        trigger('fadeInOut', [
            transition(':enter', [
                style({ opacity: 0, transform: 'translateY(-10px)' }),
                animate('400ms ease-out', style({ opacity: 1, transform: 'translateY(0)' })),
            ]),
        ]),
    ],
})
export class ToolboxComponent implements OnInit, OnChanges {
    @Input() resetSignal: boolean;
    /*
    On doit filtrer les tuiles à afficher, donc, en gros, cacher les variantes.
    De plus, on utilisera un keyvalue pipe pour les items, pour simplifier et rendre plus lisible le code.
    */
    items = ITEM_TYPES;

    allowedTileKeys = ['door', 'water', 'ice', 'wall', 'tree', 'stone'];
    filteredTiles = Object.keys(TILE_TYPES)
        .filter((key) => this.allowedTileKeys.includes(key))
        .map((key) => ({
            key,
            value: TILE_TYPES[key],
        }));

    activeTab: string = 'tiles';
    namePlaceholder: string = 'Entrez un nom';
    descriptionPlaceholder: string = 'Entrez une description';

    nameInput: string = '';
    descriptionInput: string = '';

    constructor(
        private tileService: TileService,
        private paintService: PaintService,
        private dragDrop: DragDropService,
        private itemService: ItemService,
        private gameService: GameService,
    ) {}

    get activeTile(): string {
        return this.tileService.getActiveTileImage();
    }

    ngOnInit(): void {
        this.namePlaceholder = this.gameService.getName();
        this.descriptionPlaceholder = this.gameService.getDescription();
    }

    ngOnChanges(changes: SimpleChanges): void {
        if (changes.resetSignal && changes.resetSignal.currentValue !== changes.resetSignal.previousValue) {
            this.resetInputs();
        }
    }

    setActiveTile(tileKey: string): void {
        const tileData = TILE_TYPES[tileKey];
        if (!tileData) return;
        const defaultOrientation = tileData.defaultOrientation;
        this.tileService.setActiveTile(new Tile(tileKey, defaultOrientation));
    }

    getActiveTile(): Tile {
        return this.tileService.getActiveTile();
    }

    getGameName(): string {
        return this.gameService.getName();
    }

    updateName(): void {
        this.gameService.setName(this.nameInput);
    }

    getGameDescription(): string {
        return this.gameService.getDescription();
    }

    updateDescription(): void {
        this.gameService.setDescription(this.descriptionInput);
    }

    getItemCount(type: string): number {
        return this.itemService.getItemCount(type);
    }

    toggleRotation(): void {
        this.tileService.toggleRotation();
    }

    toggleTab(tab: string): void {
        this.activeTab = tab;
        if (tab !== 'tiles') {
            this.tileService.clearActiveTile();
        }
        this.paintService.disable(this.activeTab);
    }

    startDrag(itemKey: string): void {
        const itemData = ITEM_TYPES[itemKey];
        if (!itemData) return;

        const draggedItem = new Item(itemKey);
        this.dragDrop.startDrag(draggedItem);
    }

    isItemDragging(itemKey: string): boolean {
        return this.dragDrop.getDraggedItem() === itemKey;
    }

    handleDragEnd() {
        this.dragDrop.handleDragEnd();
    }

    getSpawnPointCount(): number {
        return this.itemService.getSpawnPointCount();
    }

    getTotalItemsCount(): number {
        return this.itemService.getTotalItemsPlaced();
    }

    resetInputs(): void {
        this.nameInput = '';
        this.descriptionInput = '';
    }

    noSort = () => 0;
}

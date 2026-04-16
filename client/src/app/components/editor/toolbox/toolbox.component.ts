import { animate, style, transition, trigger } from '@angular/animations';
import { KeyValuePipe } from '@angular/common';
import { Component, EventEmitter, Input, OnChanges, OnInit, Output, SimpleChanges } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Item } from '@app/classes/entity/item';
import { Tile } from '@app/classes/board/tile';
import { ITEM_TYPES, ItemType } from '@app/constants/item.constants';
import { TILE_TYPES, ALLOWED_TILES } from '@app/constants/tile.constants';
import { DragDropService } from '@app/services/editor/drag-drop.service';
import { GameService } from '@app/services/editor/game.service';
import { ItemService } from '@app/services/editor/item.service';
import { PaintService } from '@app/services/editor/paint.service';
import { TeleportService } from '@app/services/editor/teleport.service';
import { TileService } from '@app/services/editor/tile.service';
import { Board } from '@app/classes/board/board';
import { SaveGameComponent } from '@app/components/editor/save-game/save-game.component';
import { GenerateMapComponent } from '@app/components/editor/generate-map/generate-map.component';
import { RestartGameComponent } from '@app/components/game/restart-game/restart-game.component';
import { TranslateModule } from '@ngx-translate/core';

@Component({
    selector: 'app-toolbox',
    imports: [KeyValuePipe, FormsModule, SaveGameComponent, GenerateMapComponent, RestartGameComponent, TranslateModule],
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
    @Input() board!: Board;
    @Output() mapGenerated = new EventEmitter<void>();
    @Output() restartConfirmed = new EventEmitter<void>();

    items = ITEM_TYPES;

    filteredTiles = Object.keys(TILE_TYPES)
        .filter((key) => ALLOWED_TILES.includes(key))
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
        private teleportService: TeleportService,
    ) {}

    get gameMode() {
        return this.gameService.getMode();
    }

    ngOnInit(): void {
        this.namePlaceholder = this.gameService.getName();
        this.descriptionPlaceholder = this.gameService.getDescription();
        this.filterItems();
    }

    ngOnChanges(changes: SimpleChanges): void {
        if (changes.resetSignal && changes.resetSignal.currentValue !== changes.resetSignal.previousValue) {
            this.resetInputs();
        }
    }

    filterItems() {
        if (this.gameMode === 'classique') {
            this.items = Object.keys(ITEM_TYPES)
                .filter((key) => key !== 'flag')
                .reduce(
                    (acc, key) => {
                        acc[key] = ITEM_TYPES[key];
                        return acc;
                    },
                    {} as { [key: string]: ItemType },
                );
        }
    }

    setActiveTile(tileKey: string): void {
        this.teleportService.cancelPending(this.board);
        const tileData = TILE_TYPES[tileKey];
        if (!tileData) return;
        const defaultOrientation = tileData.defaultOrientation;
        this.tileService.setActiveTile(new Tile(tileKey, defaultOrientation));
    }

    getActiveTile(): Tile {
        return this.tileService.getActiveTile();
    }

    updateName(): void {
        this.gameService.setName(this.nameInput);
    }

    updateDescription(): void {
        this.gameService.setDescription(this.descriptionInput);
    }

    getItemCount(type: string): number {
        return this.itemService.getItemCount(type);
    }

    toggleTab(tab: string): void {
        this.teleportService.cancelPending(this.board);
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

    noSort = () => 0;

    onRestartConfirmed(): void {
        this.resetInputs();
        this.restartConfirmed.emit();
    }

    onMapGenerated(): void {
        this.resetInputs();
        this.mapGenerated.emit();
    }

    getGameName(): string {
        return this.gameService.getName();
    }

    private resetInputs(): void {
        this.nameInput = '';
        this.descriptionInput = '';
    }
}

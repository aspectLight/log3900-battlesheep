import { Injectable } from '@angular/core';
import { Item } from '@app/classes/item';
import { Cell } from '@app/classes/cell';
import { ItemService } from './item.service';

@Injectable({
    providedIn: 'root',
})
export class DragDropService {
    private isDragging = false;
    private draggedItem: Item | null = null;
    private sourceCell: Cell | null = null;

    constructor(private itemService: ItemService) {}

    getDraggedItem(): string | undefined {
        return this.draggedItem?.type;
    }

    startDrag(item: Item, sourceCell?: Cell): void {
        this.isDragging = true;
        this.draggedItem = item;
        this.sourceCell = sourceCell || null;
    }

    handleDrop(cell: Cell): void {
        if (!this.isDragging || !this.draggedItem) return;

        if (cell.tile.moveModifier < 0 && cell.tile.type !== 'door') {
            this.resetInteractionState();
            return;
        }

        if (cell.tile.type === 'door' && cell.tile.state === 'closed') {
            this.resetInteractionState();
            return;
        }

        if (this.sourceCell?.x === cell.x && this.sourceCell?.y === cell.y) {
            this.sourceCell.removeItem();
            this.itemService.putBackItem(this.draggedItem.type);
            this.resetInteractionState();
            return;
        }

        if (this.sourceCell) {
            this.sourceCell.removeItem();
            this.itemService.putBackItem(this.draggedItem.type);
        }

        if (cell.item) {
            this.itemService.putBackItem(cell.item.type);
            cell.removeItem();
        }

        cell.addItem(this.draggedItem);
        this.itemService.placeItem(this.draggedItem.type);

        this.resetInteractionState();
    }

    handleDragEnd(): void {
        if (this.isDragging) {
            if (this.draggedItem && this.sourceCell) {
                this.sourceCell.removeItem();
                this.itemService.putBackItem(this.draggedItem.type);
            }
            this.resetInteractionState();
        }
    }

    allowDrop(event: DragEvent): void {
        event.preventDefault();
    }

    private resetInteractionState(): void {
        this.isDragging = false;
        this.draggedItem = null;
    }
}

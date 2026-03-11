import { Injectable } from '@angular/core';
import { Board } from '@app/classes/board/board';
import { Cell } from '@app/classes/board/cell';
import { AutoTileService } from '@app/services/editor/auto-tile.service';
import { ItemService } from '@app/services/editor/item.service';
import { TeleportService } from '@app/services/editor/teleport.service';
import { TileService } from '@app/services/editor/tile.service';

@Injectable({
    providedIn: 'root',
})
export class PaintService {
    isDisabled = false;
    isPainting = false;
    isErasing = false;

    constructor(
        private tileService: TileService,
        private itemService: ItemService,
        private autoTileService: AutoTileService,
        private teleportService: TeleportService,
    ) {}

    handleMouseDown(event: MouseEvent, cell: Cell, board: Board): void {
        if (event.button === 0) {
            if (this.isDisabled) return;
            event.preventDefault();

            const activeTile = this.tileService.getActiveTile();
            if (activeTile?.type === 'teleportPad') {
                this.teleportService.placeTeleportTile(cell, board);
            } else {
                this.isPainting = true;
                this.paint(cell, board);
            }
        } else if (event.button === 2) {
            this.isErasing = true;
            this.erase(cell, board);
        }
    }

    handleMouseMove(cell: Cell, board: Board): void {
        if (this.isPainting) {
            this.paint(cell, board);
        } else if (this.isErasing) {
            this.erase(cell, board);
        }
    }

    handleMouseUp(): void {
        this.resetInteractionState();
    }

    disable(mode: string) {
        this.isDisabled = mode !== 'tiles';
    }

    private paint(cell: Cell, board: Board): void {
        const activeTile = this.tileService.getActiveTile();
        if (!activeTile) return;

        const isSameType = cell.tile.type !== activeTile.type;

        if (isSameType) {
            if (cell.item) {
                this.eraseItem(cell);
            }
            board.setTile(cell.x, cell.y, activeTile);

            this.autoTileService.updateSurroundingTiles(cell.x, cell.y, board);
        } else {
            cell.tile.toggleState();
        }
    }

    private erase(cell: Cell, board: Board): void {
        if (cell.tile.type === 'teleportPad') {
            this.teleportService.erasePair(cell, board);
            return;
        }
        this.eraseItem(cell);
        board.setTileDefault(cell.x, cell.y);
        this.autoTileService.updateSurroundingTiles(cell.x, cell.y, board);
    }

    private eraseItem(cell: Cell): void {
        const item = cell.getItem();
        if (item) {
            cell.removeItem();
            this.itemService.putBackItem(item.type);
        }
    }

    private resetInteractionState(): void {
        this.isPainting = false;
        this.isErasing = false;
    }
}

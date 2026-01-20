import { Injectable } from '@angular/core';
import { Tile } from '@app/classes/board/tile';

@Injectable({
    providedIn: 'root',
})
export class TileService {
    private activeTile: Tile = new Tile('snow');

    getActiveTile(): Tile {
        return this.activeTile.clone();
    }

    setActiveTile(tile: Tile): void {
        if (tile.type !== this.activeTile.type) {
            this.activeTile = tile;
        } else if (this.activeTile.state !== 'default') {
            this.toggleState();
        }
    }

    clearActiveTile(): void {
        this.activeTile = new Tile('snow');
    }

    toggleState(): void {
        this.activeTile.toggleState();
    }

    toggleRotation(): void {
        this.activeTile.toggleRotation();
    }
}

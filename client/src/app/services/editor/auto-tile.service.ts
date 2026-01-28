import { Injectable } from '@angular/core';
import { Board } from '@app/classes/board/board';
import { Tile } from '@app/classes/board/tile';
import { Cell } from '@app/classes/board/cell';
import { AUTO_TILE_CONFIG, BitmaskMapping, CategoryConfig } from '@app/constants/auto-tile.constants';

type TileCategory = 'wall' | 'water' | 'ice' | 'none';

/*
ATTENTION!

For this code, we find it justified to disable certain lint checks.
The "autotile" is a function that can be found in several game engines (e.g., Godot), and
is implemented in a very similar way with bitmasks and a map corresponding to different values.

The linter wants to prevent us from using numbers as attributes and applying camel case, which is impossible.
It also wants to prevent us from using bitwise operations, which goes against the common method we're trying to implement.

Here are our sources:
https://code.tutsplus.com/how-to-use-tile-bitmasking-to-auto-tile-your-level-layouts--cms-25673t
https://www.youtube.com/watch?v=mQRokJfkLY4&ab_channel=UnitOfTime
*/

/* eslint-disable @typescript-eslint/no-magic-numbers, 
                  no-bitwise, 
                  @typescript-eslint/naming-convention */

@Injectable({
    providedIn: 'root',
})
export class AutoTileService {
    updateSurroundingTiles(x: number, y: number, board: Board): void {
        if (!this.isInBounds(x, y, board)) return;
        this.applyAutoTile(x, y, board);

        const directions = [
            { dx: -1, dy: -1 },
            { dx: -1, dy: 0 },
            { dx: -1, dy: 1 },
            { dx: 0, dy: -1 },
            { dx: 0, dy: 1 },
            { dx: 1, dy: -1 },
            { dx: 1, dy: 0 },
            { dx: 1, dy: 1 },
        ];
        for (const { dx, dy } of directions) {
            const nx = x + dx;
            const ny = y + dy;
            if (this.isInBounds(nx, ny, board)) {
                this.applyAutoTile(nx, ny, board);
            }
        }
    }

    private applyAutoTile(x: number, y: number, board: Board): void {
        const cell = board.matrix[x][y];
        if (cell.tile.type === 'door') {
            this.applyDoorOrientation(x, y, board);
            return;
        }
        const category = this.getTileCategory(cell.tile);
        if (category === 'none') return;

        const mapping = this.getTileMapping(category, x, y, board);
        if (!mapping) return;

        this.replaceTileAndRestoreItem(x, y, board, mapping.type, mapping.orientation);
    }

    private getTileMapping(category: TileCategory, x: number, y: number, board: Board): BitmaskMapping | undefined {
        const config: CategoryConfig = AUTO_TILE_CONFIG[category];
        if (!config) return undefined;

        const cardinalMask = this.getCardinalMask(x, y, board, category);
        const baseMapping = config.bitmaskMap[cardinalMask];
        if (!baseMapping) return undefined;

        const diagSuffix = this.getDiagonalSuffix(x, y, board, category);
        return {
            type: baseMapping.type,
            orientation: baseMapping.orientation + diagSuffix,
        };
    }

    private getCardinalMask(x: number, y: number, board: Board, category: TileCategory): number {
        let mask = 0;

        if (this.isCategoryAt(x - 1, y, board, category)) {
            mask |= 1;
        }

        if (this.isCategoryAt(x, y + 1, board, category)) {
            mask |= 2;
        }

        if (this.isCategoryAt(x + 1, y, board, category)) {
            mask |= 4;
        }

        if (this.isCategoryAt(x, y - 1, board, category)) {
            mask |= 8;
        }
        return mask;
    }

    private getDiagonalSuffix(x: number, y: number, board: Board, category: TileCategory): string {
        let suffix = '';

        if (
            this.isCategoryAt(x - 1, y - 1, board, category) &&
            this.isCategoryAt(x - 1, y, board, category) &&
            this.isCategoryAt(x, y - 1, board, category)
        ) {
            suffix += '_TL';
        }

        if (
            this.isCategoryAt(x - 1, y + 1, board, category) &&
            this.isCategoryAt(x - 1, y, board, category) &&
            this.isCategoryAt(x, y + 1, board, category)
        ) {
            suffix += '_TR';
        }

        if (
            this.isCategoryAt(x + 1, y + 1, board, category) &&
            this.isCategoryAt(x + 1, y, board, category) &&
            this.isCategoryAt(x, y + 1, board, category)
        ) {
            suffix += '_BR';
        }

        if (
            this.isCategoryAt(x + 1, y - 1, board, category) &&
            this.isCategoryAt(x + 1, y, board, category) &&
            this.isCategoryAt(x, y - 1, board, category)
        ) {
            suffix += '_BL';
        }
        return suffix;
    }

    private isCategoryAt(x: number, y: number, board: Board, category: TileCategory): boolean {
        if (!this.isInBounds(x, y, board)) return false;
        const neighborTile = board.matrix[x][y].tile;
        return this.getTileCategory(neighborTile) === category;
    }

    private getTileCategory(tile: Tile): TileCategory {
        if (['wall', 'corner', 'intersection', 'door'].includes(tile.type)) return 'wall';
        if (tile.type === 'water') return 'water';
        if (tile.type === 'ice') return 'ice';
        return 'none';
    }

    private applyDoorOrientation(x: number, y: number, board: Board): void {
        const cell = board.matrix[x][y];
        const left = this.getNeighborCell(x, y - 1, board);
        const right = this.getNeighborCell(x, y + 1, board);
        const top = this.getNeighborCell(x - 1, y, board);
        const bottom = this.getNeighborCell(x + 1, y, board);
        let newOrientation: string | null = null;
        if (left && right && this.isWallLike(left.tile) && this.isWallLike(right.tile)) {
            newOrientation = 'Horizontal';
        }
        if (top && bottom && this.isWallLike(top.tile) && this.isWallLike(bottom.tile)) {
            newOrientation = 'Vertical';
        }
        if (newOrientation && cell.tile.orientation !== newOrientation) {
            board.setTile(x, y, new Tile('door', newOrientation, cell.tile.state));
        }
    }

    private isWallLike(tile: Tile): boolean {
        return ['wall', 'corner', 'intersection', 'door'].includes(tile.type);
    }

    private isInBounds(x: number, y: number, board: Board): boolean {
        return x >= 0 && y >= 0 && x < board.matrix.length && y < board.matrix[0].length;
    }

    private getNeighborCell(x: number, y: number, board: Board): Cell | null {
        return this.isInBounds(x, y, board) ? board.matrix[x][y] : null;
    }

    private replaceTileAndRestoreItem(x: number, y: number, board: Board, type: string, orientation: string): void {
        const cell = board.getCell(x, y);
        if (!cell) return;
        board.setTile(x, y, new Tile(type, orientation, cell.tile.state));
    }
}

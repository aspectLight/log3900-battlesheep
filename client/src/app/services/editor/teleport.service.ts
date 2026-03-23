import { Injectable } from '@angular/core';
import { Board } from '@app/classes/board/board';
import { Cell } from '@app/classes/board/cell';
import { Tile } from '@app/classes/board/tile';

const TELEPORT_COLORS = ['default', 'blue', 'green', 'purple', 'red', 'yellow'];

@Injectable({
    providedIn: 'root',
})
export class TeleportService {
    private pendingCell: { x: number; y: number } | null = null;
    private pairs: Map<string, string> = new Map();
    private pairCount = 0;

    hasPending(): boolean {
        return this.pendingCell !== null;
    }

    placeTeleportTile(cell: Cell, board: Board): void {
        if (cell.tile.type === 'teleportPad') {
            this.erasePair(cell, board);
        }

        if (!this.pendingCell) {
            const color = TELEPORT_COLORS[this.pairCount % TELEPORT_COLORS.length];
            board.setTile(cell.x, cell.y, new Tile('teleportPad', '', color));
            this.pendingCell = { x: cell.x, y: cell.y };
        } else {
            if (this.pendingCell.x === cell.x && this.pendingCell.y === cell.y) return;

            const color = TELEPORT_COLORS[this.pairCount % TELEPORT_COLORS.length];
            board.setTile(cell.x, cell.y, new Tile('teleportPad', '', color));

            const firstKey = `${this.pendingCell.x},${this.pendingCell.y}`;
            const secondKey = `${cell.x},${cell.y}`;
            this.pairs.set(firstKey, secondKey);
            this.pairs.set(secondKey, firstKey);

            this.pendingCell = null;
            this.pairCount++;
        }
    }

    cancelPending(board: Board): void {
        if (this.pendingCell) {
            board.setTileDefault(this.pendingCell.x, this.pendingCell.y);
            this.pendingCell = null;
        }
    }

    erasePair(cell: Cell, board: Board): void {
        if (this.pendingCell && this.pendingCell.x === cell.x && this.pendingCell.y === cell.y) {
            this.pendingCell = null;
            board.setTileDefault(cell.x, cell.y);
            return;
        }

        const key = `${cell.x},${cell.y}`;
        const color = cell.tile.state;
        board.setTileDefault(cell.x, cell.y);

        const partnerKey = this.pairs.get(key);
        if (partnerKey) {
            const [px, py] = partnerKey.split(',').map(Number);
            board.setTileDefault(px, py);
            this.pairs.delete(key);
            this.pairs.delete(partnerKey);
            return;
        }

        // Fallback: scan board for partner with same color (for loaded boards)
        for (let i = 0; i < board.size; i++) {
            for (let j = 0; j < board.size; j++) {
                const candidate = board.getCell(i, j);
                if (candidate && candidate.tile.type === 'teleportPad' && candidate.tile.state === color) {
                    board.setTileDefault(i, j);
                    return;
                }
            }
        }
    }

    initializePairsFromBoard(board: Board): void {
        this.reset();
        const colorMap = new Map<string, { x: number; y: number }[]>();

        for (let i = 0; i < board.size; i++) {
            for (let j = 0; j < board.size; j++) {
                const cell = board.getCell(i, j);
                if (cell && cell.tile.type === 'teleportPad') {
                    const color = cell.tile.state;
                    if (!colorMap.has(color)) colorMap.set(color, []);
                    colorMap.get(color)!.push({ x: i, y: j });
                }
            }
        }

        colorMap.forEach((coords) => {
            if (coords.length === 2) {
                const key1 = `${coords[0].x},${coords[0].y}`;
                const key2 = `${coords[1].x},${coords[1].y}`;
                this.pairs.set(key1, key2);
                this.pairs.set(key2, key1);
                this.pairCount++;
            }
        });
    }

    reset(): void {
        this.pendingCell = null;
        this.pairs.clear();
        this.pairCount = 0;
    }
}

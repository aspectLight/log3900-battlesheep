import { Injectable } from '@angular/core';
import { Board } from '@app/classes/board/board';
import { BOARD_CONFIGS, UNIQUE_ITEM_COUNT } from '@app/constants/board.constants';
import { ErrorMessages } from '@common/error-messages.constants';
import { ITEM_TYPES } from '@app/constants/item.constants';

@Injectable({
    providedIn: 'root',
})
export class ItemService {
    inventory: { [key: string]: number } = {};
    totalItemsPlaced: number = 0;
    maxItemCount: number = 0;

    constructor() {
        Object.keys(ITEM_TYPES).forEach((key) => {
            if (key === 'random' || key === 'spawnPoint') {
                this.inventory[key] = this.maxItemCount;
                return;
            }
            this.inventory[key] = 1;
        });
    }

    placeItem(type: string): void {
        if (!Object.prototype.hasOwnProperty.call(this.inventory, type)) {
            throw new Error(ErrorMessages.InvalidItem + type);
        }
        this.inventory[type]--;
        if (type !== 'spawnPoint') {
            this.totalItemsPlaced++;
            this.inventory['random'] = this.maxItemCount - this.totalItemsPlaced;
        }
    }

    putBackItem(type: string): void {
        if (!Object.prototype.hasOwnProperty.call(this.inventory, type)) {
            throw new Error(ErrorMessages.InvalidItem + type);
        }
        this.inventory[type]++;
        if (type !== 'spawnPoint') {
            this.totalItemsPlaced--;
            this.inventory['random'] = this.maxItemCount - this.totalItemsPlaced;
        }
    }

    getItemCount(type: string): number {
        if (this.inventory['random'] === 0 && type !== 'spawnPoint') {
            return 0;
        }

        return this.inventory[type];
    }

    getInventory(): { [key: string]: number } {
        return this.inventory;
    }

    getTotalItemsPlaced(): number {
        return this.totalItemsPlaced;
    }

    getSpawnPointCount(): number {
        return this.inventory.spawnPoint;
    }

    setItemCountFromBoard(board: Board) {
        this.maxItemCount = this.getMaximumItemCount(board);
        this.resetCount();

        board.matrix.forEach((row) => {
            row.forEach((cell) => {
                if (!cell.item) return;
                this.inventory[cell.item.type]--;
                if (cell.item.type !== 'spawnPoint') {
                    this.totalItemsPlaced++;
                    this.inventory['random'] = this.maxItemCount - this.totalItemsPlaced;
                }
            });
        });
    }

    getMaximumItemCount(board: Board): number {
        const boardSize = Object.values(BOARD_CONFIGS).find((size) => size.board === board.size);

        if (!boardSize) {
            throw new Error(ErrorMessages.InvalidBoardSize + board.size);
        }

        return boardSize.items;
    }

    resetCount() {
        Object.keys(this.inventory).forEach((key) => {
            if (key === 'random' || key === 'spawnPoint') {
                this.inventory[key] = this.maxItemCount;
                return;
            }
            this.inventory[key] = UNIQUE_ITEM_COUNT;
        });
        this.totalItemsPlaced = 0;
    }
}

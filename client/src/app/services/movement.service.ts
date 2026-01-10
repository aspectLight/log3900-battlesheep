import { Injectable } from '@angular/core';
import { Board } from '@app/classes/board';
import { Cell } from '@app/classes/cell';
import { Player } from '@app/classes/player';
import { Coords } from '@app/interfaces/coords';

const DELAY = 150;

@Injectable({
    providedIn: 'root',
})
export class MovementService {
    selectedPlayer: Player;

    selectPlayer(player: Player) {
        this.selectedPlayer = player;
    }

    movePlayer(board: Board, dx: number, dy: number): boolean {
        if (!this.selectedPlayer) return false;

        if (!this.selectedPlayer.isAlive()) {
            this.selectedPlayer.setState('dead');
            return false;
        }

        if (!this.selectedPlayer.cell) {
            return false;
        }

        const oldCell = this.selectedPlayer.cell;
        const newX = oldCell.x + dx;
        const newY = oldCell.y + dy;

        this.updatePlayerOrientation(this.selectedPlayer, dx, dy);

        const targetCell = board.getCell(newX, newY);
        if (!targetCell) {
            return false;
        }

        if (targetCell.player) {
            return false;
        }

        if (targetCell.tile.type === 'wall') return false;

        oldCell.removeEntity();
        targetCell.addEntity(this.selectedPlayer);
        this.selectedPlayer.addCell(targetCell);

        this.selectedPlayer.setState('moving');
        return true;
    }

    teleportPlayer(board: Board, destinationX: number, destinationY: number): boolean {
        const player = this.selectedPlayer;
        if (!player) return false;

        const targetCell = board.getCell(destinationX, destinationY);
        if (!targetCell) return false;
        if (!this.isCellFree(targetCell)) return false;

        if (player.cell) {
            const oldCell = board.getCell(player.cell.x, player.cell.y);
            if (oldCell) oldCell.removeEntity();
            targetCell.addEntity(player);
            player.addCell(targetCell);
        }
        return true;
    }

    stopPlayer(player: Player): void {
        player.setState('idle');
    }

    async movePlayerFromPath(board: Board, paths: Coords[]): Promise<boolean> {
        if (!this.selectedPlayer || !this.selectedPlayer.cell) {
            return false;
        }
        for (let i = 1; i < paths.length; i++) {
            const currentPos = {
                x: this.selectedPlayer.cell.x,
                y: this.selectedPlayer.cell.y,
            };
            const nextPos = paths[i];

            const dx = nextPos.x - currentPos.x;
            const dy = nextPos.y - currentPos.y;

            this.selectedPlayer.setState('moving');

            const moved = this.movePlayer(board, dx, dy);

            if (moved) {
                await this.delay(DELAY);
            } else {
                return false;
            }
        }
        this.selectedPlayer.setState('idle');
        return true;
    }

    private isCellFree(cell: Cell) {
        if (
            cell.player ||
            ['wall', 'tree', 'stone', 'corner', 'intersection'].includes(cell.tile.type) ||
            (cell.tile.type === 'door' && cell.tile.state === 'closed')
        )
            return false;
        return true;
    }

    private updatePlayerOrientation(player: Player, dx: number, dy: number): void {
        if (dx > 0) player.setOrientation('down');
        else if (dx < 0) player.setOrientation('up');
        else if (dy > 0) player.setOrientation('right');
        else if (dy < 0) player.setOrientation('left');
    }

    private async delay(ms: number) {
        return new Promise((resolve) => setTimeout(resolve, ms));
    }
}

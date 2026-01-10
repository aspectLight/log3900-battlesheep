import { Injectable } from '@angular/core';
import { Board } from '@app/classes/board';
import { Cell } from '@app/classes/cell';
import { Player } from '@app/classes/player';
import { Coords } from '@app/interfaces/coords';
import { DELAY } from '@app/constants/player.constants';

@Injectable({
    providedIn: 'root',
})
export class MovementService {
    selectedPlayer: Player;
    private movingPlayer: Player | null = null;
    private isExecutingPath = false;

    selectPlayer(player: Player) {
        this.selectedPlayer = player;
    }

    movePlayer(board: Board, dx: number, dy: number): { success: boolean; cell?: Cell } {
        const player = this.isExecutingPath ? this.movingPlayer : this.selectedPlayer;
        if (!player) return { success: false };

        if (!player.cell) {
            return { success: false };
        }

        const oldCell = player.cell;
        const newX = oldCell.x + dx;
        const newY = oldCell.y + dy;

        this.updatePlayerOrientation(player, dx, dy);

        const targetCell = board.getCell(newX, newY);
        if (!targetCell) {
            return { success: false };
        }

        if (targetCell.player) {
            return { success: false };
        }

        if (targetCell.tile.type === 'wall') return { success: false };

        oldCell.removeEntity();
        targetCell.addEntity(player);
        player.addCell(targetCell);

        player.setState('moving');
        return { success: true, cell: targetCell };
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
        player.setState('idle');
        return true;
    }

    stopPlayer(player: Player): void {
        player.setState('idle');
    }

    isMoving(): boolean {
        return this.isExecutingPath || this.selectedPlayer?.animationState === 'moving';
    }

    async movePlayerFromPath(board: Board, paths: Coords[]): Promise<{ success: boolean; cell?: Cell }> {
        if (!this.selectedPlayer || !this.selectedPlayer.cell || paths.length <= 1) {
            return { success: false };
        }

        this.movingPlayer = this.selectedPlayer;
        this.isExecutingPath = true;

        try {
            let lastCell: Cell | undefined;
            for (let i = 1; i < paths.length; i++) {
                if (!this.movingPlayer || !this.movingPlayer.cell) {
                    this.isExecutingPath = false;
                    this.movingPlayer = null;
                    return { success: false };
                }

                const currentPos = {
                    x: this.movingPlayer.cell.x,
                    y: this.movingPlayer.cell.y,
                };
                const nextPos = paths[i];

                const dx = nextPos.x - currentPos.x;
                const dy = nextPos.y - currentPos.y;

                this.movingPlayer.setState('moving');

                const moveResult = this.movePlayer(board, dx, dy);

                if (!moveResult.success) {
                    this.isExecutingPath = false;
                    this.movingPlayer = null;
                    return { success: false };
                }

                if (moveResult.cell) {
                    lastCell = moveResult.cell;
                }

                await new Promise((resolve) => {
                    const timer = setTimeout(() => {
                        clearTimeout(timer);
                        resolve(null);
                    }, DELAY);
                });
            }

            if (this.movingPlayer) {
                this.movingPlayer.setState('idle');
            }

            this.isExecutingPath = false;
            this.movingPlayer = null;
            return { success: true, cell: lastCell };
        } catch (error) {
            this.isExecutingPath = false;
            this.movingPlayer = null;
            return { success: false };
        }
    }

    isCellFree(cell: Cell) {
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
}

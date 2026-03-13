import { Injectable } from '@angular/core';
import { Board } from '@app/classes/board/board';
import { Cell } from '@app/classes/board/cell';
import { Player } from '@app/classes/entity/player';
import { DELAY } from '@app/constants/player.constants';
import { Coords } from '@app/interfaces/coords.interface';

@Injectable({
    providedIn: 'root',
})
export class MovementService {
    selectedPlayer: Player;
    private movingPlayer: Player | null = null;
    private isExecutingPath = false;
    // Unique ID for the current animation — incremented on each new animation so that
    // stale animations can detect they've been superseded and bail out.
    private animationId = 0;
    // The final destination of the current animation, used to teleport the player
    // if the animation is interrupted by a new one.
    private pendingDestination: Coords | null = null;

    selectPlayer(player: Player) {
        this.selectedPlayer = player;
    }

    /**
     * Moves the player by a given amount of cells in a given direction.
     * @param board The board to move the player on.
     * @param dx The amount of cells to move the player in the x direction.
     * @param dy The amount of cells to move the player in the y direction.
     * @param player The player to move.
     * @returns A promise that resolves to the cell the player was moved to.
     */
    movePlayer(board: Board, dx: number, dy: number, player?: Player): { success: boolean; cell?: Cell } {
        // Find the target player to move by checking if a player is being moved from a path or the selected player
        const target = player ?? (this.isExecutingPath ? this.movingPlayer : this.selectedPlayer);
        if (!target) return { success: false };

        if (!target.cell) {
            return { success: false };
        }

        const oldCell = target.cell;
        const newX = oldCell.x + dx;
        const newY = oldCell.y + dy;

        this.updatePlayerOrientation(target, dx, dy);

        const targetCell = board.getCell(newX, newY);
        if (!targetCell) {
            return { success: false };
        }

        if (targetCell.player) {
            return { success: false };
        }

        if (targetCell.tile.type === 'wall') return { success: false };

        oldCell.removeEntity();
        targetCell.addEntity(target);
        target.addCell(targetCell);

        target.setState('moving');
        return { success: true, cell: targetCell };
    }

    /**
     * Teleports the player to a given cell.
     * @param board The board to move the player on.
     * @param player The player to move.
     * @param destinationX The x coordinate of the cell to move the player to.
     * @param destinationY The y coordinate of the cell to move the player to.
     * @returns A boolean indicating whether the player was successfully teleported.
     */
    teleportPlayer(board: Board, player: Player, destinationX: number, destinationY: number): boolean {
        if (!player) {
            return false;
        }

        const targetCell = board.getCell(destinationX, destinationY);
        if (!targetCell) {
            return false;
        }

        if (player.cell) {
            const oldCell = board.getCell(player.cell.x, player.cell.y);
            if (oldCell) oldCell.removeEntity();
            targetCell.addEntity(player);
            player.addCell(targetCell);
        }
        player.setState('idle');
        return true;
    }

    /**
     * Stops the player.
     * @param player The player to stop.
     */
    stopPlayer(player: Player): void {
        player.setState('idle');
    }

    /**
     * Checks if the player is moving.
     * @returns A boolean indicating whether the player is moving.
     */
    isMoving(): boolean {
        return this.isExecutingPath || this.selectedPlayer?.animationState === 'moving';
    }

    /**
     * Moves the player from a path.
     * @param board The board to move the player on.
     * @param paths The path to move the player on.
     * @returns A promise that resolves to the cell the player was moved to.
     */
    async movePlayerFromPath(board: Board, paths: Coords[]): Promise<{ success: boolean; cell?: Cell }> {
        if (!this.selectedPlayer || !this.selectedPlayer.cell || paths.length <= 1) {
            return { success: false };
        }

        // If a previous animation is still running, interrupt it by teleporting
        // the old moving player to their intended destination immediately.
        if (this.isExecutingPath && this.movingPlayer && this.pendingDestination) {
            this.teleportPlayer(board, this.movingPlayer, this.pendingDestination.x, this.pendingDestination.y);
            this.movingPlayer = null;
        }

        // Increment the animation ID so the old animation loop detects it's stale.
        const currentAnimationId = ++this.animationId;
        const currentMovingPlayer = this.selectedPlayer;

        this.movingPlayer = currentMovingPlayer;
        this.isExecutingPath = true;
        this.pendingDestination = paths[paths.length - 1];

        try {
            let lastCell: Cell | undefined;
            for (let i = 1; i < paths.length; i++) {
                // Check if this animation has been superseded by a new one.
                if (this.animationId !== currentAnimationId) {
                    return { success: false };
                }

                // Check if the player or their cell is no longer valid.
                if (!currentMovingPlayer || !currentMovingPlayer.cell) {
                    this.isExecutingPath = false;
                    this.movingPlayer = null;
                    this.pendingDestination = null;
                    return { success: false };
                }

                const currentPos = {
                    x: currentMovingPlayer.cell.x,
                    y: currentMovingPlayer.cell.y,
                };
                const nextPos = paths[i];

                const dx = nextPos.x - currentPos.x;
                const dy = nextPos.y - currentPos.y;

                currentMovingPlayer.setState('moving');

                const moveResult = this.movePlayer(board, dx, dy, currentMovingPlayer);

                if (!moveResult.success) {
                    // Movement failed : teleport to destination to stay in sync with the server
                    // which has already validated the move.
                    this.teleportPlayer(board, currentMovingPlayer, this.pendingDestination.x, this.pendingDestination.y);
                    if (this.animationId === currentAnimationId) {
                        this.isExecutingPath = false;
                        this.movingPlayer = null;
                        this.pendingDestination = null;
                    }
                    const destCell = board.getCell(paths[paths.length - 1].x, paths[paths.length - 1].y);
                    return { success: true, cell: destCell ?? undefined };
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

            // The player has reached their destination
            if (currentMovingPlayer) {
                currentMovingPlayer.setState('idle');
            }

            // Only clear shared state if this is still the active animation
            if (this.animationId === currentAnimationId) {
                this.isExecutingPath = false;
                this.movingPlayer = null;
                this.pendingDestination = null;
            }
            return { success: true, cell: lastCell };
        } catch (error) {
            // If the animation was interrupted, clear shared state
            if (this.animationId === currentAnimationId) {
                this.isExecutingPath = false;
                this.movingPlayer = null;
                this.pendingDestination = null;
            }
            return { success: false };
        }
    }

    /**
     * Checks if a cell is free to move on.
     * @param cell The cell to check.
     * @returns A boolean indicating whether the cell is free.
     */
    isCellFree(cell: Cell) {
        if (
            cell.player ||
            ['wall', 'tree', 'stone', 'corner', 'intersection'].includes(cell.tile.type) ||
            (cell.tile.type === 'door' && cell.tile.state === 'closed')
        )
            return false;
        return true;
    }

    /**
     * Updates the orientation of a player based on their movement.
     * @param player The player to update.
     * @param dx The amount of cells moved in the x direction.
     * @param dy The amount of cells moved in the y direction.
     */
    private updatePlayerOrientation(player: Player, dx: number, dy: number): void {
        if (dx > 0) player.setOrientation('down');
        else if (dx < 0) player.setOrientation('up');
        else if (dy > 0) player.setOrientation('right');
        else if (dy < 0) player.setOrientation('left');
    }
}

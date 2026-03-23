import { Board } from '@app/modules/game/interfaces/board';
import { Cell } from '@app/modules/game/interfaces/cell';
import { TileType } from '@app/modules/game/interfaces/tile';
import { GameMovementService } from '@app/modules/movement/services/game-movement.service';
import { TORCH_ATTACK_BOOST, TORCH_DEFENSE_BOOST, TORCH_ILLUMINATION_RADIUS } from '@app/shared/constants/item.constants';
import { Player } from '@app/shared/interfaces/player';
import { Injectable } from '@nestjs/common';

@Injectable()
export class TorchService {
    // Map<roomId, Set<cellKey>> — currently illuminated cells per room
    private illuminationMap: Map<string, Set<string>> = new Map();
    // Map<roomId, Set<playerId>> — players currently receiving the torch bonus
    private bonusPlayers: Map<string, Set<string>> = new Map();

    constructor(private readonly gameMovementService: GameMovementService) {}

    /**
     * Recalculates torch illumination for a room and applies/removes bonuses.
     * Returns the set of illuminated cell keys for client broadcast.
     */
    recalculateIllumination(roomId: string, players: Player[]): string[] {
        const board = this.gameMovementService.getBoardForGame(roomId);
        if (!board) return [];

        const illuminated = new Set<string>();

        // Determine which players carry a torch
        const torchCarriers = new Set<string>();
        for (const player of players) {
            if (player.inventory?.some((i) => i?.type === 'torch')) {
                torchCarriers.add(player.id);
            }
        }

        // 1. Find torches on the board (not carried) — illuminate 2-tile radius
        if (torchCarriers.size === 0) {
            for (let x = 0; x < board.size; x++) {
                for (let y = 0; y < board.size; y++) {
                    const cell = board.matrix[x][y];
                    if (cell.item && cell.item.type === 'torch') {
                        if (this.isTorchLitOnTile(cell.tile.type as TileType)) {
                            const reachable = this.bfsIllumination(roomId, board, x, y, TORCH_ILLUMINATION_RADIUS);
                            for (const key of reachable) {
                                illuminated.add(key);
                            }
                        }
                    }
                }
            }
        }

        // 2. Find torches in player inventories — only the carrier's tile is illuminated
        for (const player of players) {
            if (player.inventory && player.position) {
                const hasTorch = player.inventory.some((i) => i?.type === 'torch');
                if (hasTorch) {
                    illuminated.add(`${player.position.x},${player.position.y}`);
                }
            }
        }

        this.illuminationMap.set(roomId, illuminated);

        // 3. Apply/remove bonuses
        this.updateBonuses(roomId, players, illuminated, torchCarriers);

        return Array.from(illuminated);
    }

    /**
     * Returns whether a given cell is illuminated in the current state.
     */
    isIlluminated(roomId: string, x: number, y: number): boolean {
        const set = this.illuminationMap.get(roomId);
        return set ? set.has(`${x},${y}`) : false;
    }

    /**
     * Cleans up room data when a game ends.
     */
    removeRoom(roomId: string): void {
        this.illuminationMap.delete(roomId);
        this.bonusPlayers.delete(roomId);
    }

    /**
     * A torch on snow (or any non-water/ice tile) is lit.
     * On water or ice it's extinguished.
     */
    private isTorchLitOnTile(tileType: TileType): boolean {
        return tileType !== TileType.Water && tileType !== TileType.Ice;
    }

    /**
     * BFS illumination from a torch position within a given radius.
     * Doesn't cross walls, closed doors, trees, stones, corners, or intersections.
     * Goes through opened doors, snow, water, ice, traps, teleport pads.
     */
    private bfsIllumination(roomId: string, board: Board, startX: number, startY: number, radius: number): Set<string> {
        const illuminated = new Set<string>();
        const visited = new Map<string, number>();
        const queue: { x: number; y: number; dist: number }[] = [{ x: startX, y: startY, dist: 0 }];
        const startKey = `${startX},${startY}`;
        visited.set(startKey, 0);
        illuminated.add(startKey);

        while (queue.length > 0) {
            const { x, y, dist } = queue.shift()!;
            if (dist >= radius) continue;

            const neighbors = [
                { x: x - 1, y },
                { x: x + 1, y },
                { x, y: y - 1 },
                { x, y: y + 1 },
            ];

            for (const { x: nx, y: ny } of neighbors) {
                const key = `${nx},${ny}`;
                const newDist = dist + 1;

                if (visited.has(key) && visited.get(key)! <= newDist) continue;

                const cell = this.gameMovementService.getCell(roomId, nx, ny);
                if (!cell) continue;

                if (this.isLightBlocking(cell)) continue;

                visited.set(key, newDist);
                illuminated.add(key);
                queue.push({ x: nx, y: ny, dist: newDist });
            }
        }

        return illuminated;
    }

    /**
     * Returns true if a cell blocks light propagation.
     */
    private isLightBlocking(cell: Cell): boolean {
        const blockingTypes = [TileType.Wall, TileType.Tree, TileType.Stone, TileType.Corner, TileType.Intersection];
        if (blockingTypes.includes(cell.tile.type as TileType)) return true;
        if (cell.tile.type === TileType.Door && cell.tile.state !== 'opened') return true;
        return false;
    }

    /**
     * Apply +1 Attack/Defense to players on illuminated tiles, remove from those who left.
     * If a torch is carried, only the carrier benefits — not others on the illuminated tile.
     * If no one carries the torch, any player on an illuminated tile benefits.
     */
    private updateBonuses(roomId: string, players: Player[], illuminated: Set<string>, torchCarriers: Set<string>): void {
        if (!this.bonusPlayers.has(roomId)) {
            this.bonusPlayers.set(roomId, new Set());
        }
        const currentBonusPlayers = this.bonusPlayers.get(roomId)!;

        for (const player of players) {
            if (!player.position || !player.stats) continue;

            const playerKey = `${player.position.x},${player.position.y}`;
            const isOnIlluminatedTile = illuminated.has(playerKey);
            const isCarryingTorch = torchCarriers.has(player.id);
            const hasBonus = currentBonusPlayers.has(player.id);

            // Player gets the bonus IF:
            // - They carry the torch themselves, OR
            // - They are on an illuminated tile AND no one is carrying any torch
            const shouldHaveBonus = isCarryingTorch || (isOnIlluminatedTile && torchCarriers.size === 0);

            if (shouldHaveBonus && !hasBonus) {
                player.stats['attack'].value += TORCH_ATTACK_BOOST;
                player.stats['defense'].value += TORCH_DEFENSE_BOOST;
                currentBonusPlayers.add(player.id);
            } else if (!shouldHaveBonus && hasBonus) {
                player.stats['attack'].value -= TORCH_ATTACK_BOOST;
                player.stats['defense'].value -= TORCH_DEFENSE_BOOST;
                currentBonusPlayers.delete(player.id);
            }
        }
    }
}

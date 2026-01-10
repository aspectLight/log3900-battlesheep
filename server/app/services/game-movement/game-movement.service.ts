import { Board } from '@app/interfaces/board';
import { Cell } from '@app/interfaces/cell';
import { Coords } from '@app/interfaces/coords';
import { ItemType } from '@app/interfaces/item';
import { Player } from '@app/interfaces/player';
import { MoveCosts, TileType } from '@app/interfaces/tile';
import { GameService } from '@app/services/game/game.service';
import { Injectable } from '@nestjs/common';

@Injectable()
export class GameMovementService {
    private board: Board | null = null;

    constructor(private readonly gameService: GameService) {}

    toggleDoor(x: number, y: number) {
        const door = this.board.matrix[x][y];
        if (door.tile.type === TileType.Door) {
            if (door.tile.state === 'closed') door.tile.state = 'opened';
            else if (door.tile.state === 'opened') door.tile.state = 'closed';
        }
    }

    async addPlayersToBoard(gameId: string, players: Player[]) {
        await this.loadBoard(gameId);
        if (!this.board) throw new Error('Partie introuvable');
        return this.spawnPlayer(players);
    }

    async getAllPaths(playerId: string, players: Player[]): Promise<Map<Coords, Coords[]>> {
        const player = players.find((p) => p.id === playerId);
        if (!player) throw new Error('Joueur introuvable');

        const paths: Map<Coords, Coords[]> = new Map<Coords, Coords[]>();
        const { reachableTiles, pathsMap } = await this.getReachableTilesAndPaths(playerId, players);

        for (const coord of reachableTiles) {
            const path = this.getShortestPath(player.position, coord.coord, pathsMap);
            if (!path) throw new Error(`Chemin introuvable pour la cellule (${coord.coord.x},${coord.coord.y})`);
            paths.set(coord.coord, path);
        }

        return paths;
    }

    async movePlayer(playerId: string, players: Player[], destination: Coords, isTeleport?: boolean) {
        const targetCell = this.getCell(destination.x, destination.y);
        if (!targetCell) throw new Error('Case introuvable');
        if (!this.isCellFree(targetCell)) throw new Error('Case occupée');

        const player = players.find((p) => p.id === playerId);
        if (!player) throw new Error('Joueur introuvable');

        const startCell = this.getCell(player.position.x, player.position.y);

        if (isTeleport) {
            if (startCell) startCell.player = null;
            player.position = targetCell;
            targetCell.player = player;
            return;
        }
        const reachableTilesAndPaths = await this.getReachableTilesAndPaths(playerId, players);
        if (!reachableTilesAndPaths) throw new Error('Erreur de calcul des chemins');
        const reachableTiles = reachableTilesAndPaths.reachableTiles;

        const targetTile = reachableTiles.find((tile) => tile.coord.x === destination.x && tile.coord.y === destination.y);
        if (!targetTile) throw new Error('Destination inatteignable');

        if (targetTile.cost > player.movementPoints) {
            throw new Error('Points de mouvement insuffisants');
        }

        if (startCell) startCell.player = null;
        player.position = targetCell;
        player.movementPoints = player.movementPoints - targetTile.cost;
        targetCell.player = player;
        return player.movementPoints;
    }

    private async getReachableTilesAndPaths(
        playerId: string,
        players: Player[],
    ): Promise<{
        reachableTiles: { coord: Coords; cost: number }[];
        pathsMap: Map<string, Coords>;
    } | null> {
        const player = players.find((p) => p.id === playerId);
        if (!player) throw new Error('Joueur introuvable');

        const costMap = new Map<string, number>();
        const pathsMap = new Map<string, { x: number; y: number }>();
        const queue: { coord: Coords; cost: number }[] = [{ coord: { x: player.position.x, y: player.position.y }, cost: 0 }];
        const reachableTiles: { coord: Coords; cost: number }[] = [];

        costMap.set(`${player.position.x},${player.position.y}`, 0);
        reachableTiles.push({ coord: { x: player.position.x, y: player.position.y }, cost: 0 });

        while (queue.length > 0) {
            queue.sort((a, b) => a.cost - b.cost);
            const {
                coord: { x, y },
                cost,
            } = queue.shift();
            const key = `${x},${y}`;
            if (costMap.get(key) < cost) continue;
            if (cost > player.movementPoints) continue;

            const neighbors = [
                { x, y: y - 1 },
                { x, y: y + 1 },
                { x: x - 1, y },
                { x: x + 1, y },
            ];

            for (const { x: nx, y: ny } of neighbors) {
                const neighborCell = this.getCell(nx, ny);
                const neighborKey = `${nx},${ny}`;

                if (!neighborCell) continue;
                if (!this.isCellFree(neighborCell)) continue;

                const type = neighborCell.tile.type.replace(/^\w/, (c) => c.toUpperCase());
                const newCost = cost + MoveCosts[type];

                if (!costMap.has(neighborKey) || newCost < costMap.get(neighborKey)) {
                    costMap.set(neighborKey, newCost);
                    pathsMap.set(neighborKey, { x, y });

                    if (newCost <= player.movementPoints) {
                        queue.push({ coord: { x: nx, y: ny }, cost: newCost });
                        reachableTiles.push({ coord: { x: nx, y: ny }, cost: newCost });
                    }
                }
            }
        }
        return { reachableTiles, pathsMap };
    }

    private isCellFree(cell: Cell): boolean {
        if (!cell || cell.player) return false;
        if (['wall', 'tree', 'stone', 'corner', 'intersection'].includes(cell.tile.type)) return false;
        if (cell.tile.type === TileType.Door && cell.tile.state !== 'opened') return false;
        return true;
    }

    private async loadBoard(gameId: string): Promise<Board | null> {
        const game = await this.gameService.getGameById(gameId);
        this.board = game ? game.board : null;
        return this.board;
    }

    private getCell(x: number, y: number): Cell | null {
        if (x < 0 || y < 0 || x >= this.board.size || y >= this.board.size) return null;
        return this.board.matrix[x][y];
    }

    private spawnPlayer(players: Player[]): Player[] {
        const spawnPoints: Cell[] = this.board.matrix.flat().filter((cell) => cell.item && cell.item.type === ItemType.SpawnPoint && !cell.player);
        if (spawnPoints.length < players.length) throw new Error('Pas assez de spawnpoints');

        for (let i = spawnPoints.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [spawnPoints[i], spawnPoints[j]] = [spawnPoints[j], spawnPoints[i]];
        }

        for (let i = 0; i < players.length; i++) {
            const spawnCell = spawnPoints[i];
            players[i].spawnPoint = { x: spawnCell.x, y: spawnCell.y };
            players[i].position = { x: spawnCell.x, y: spawnCell.y };
            this.board.matrix[spawnCell.x][spawnCell.y].player = players[i];
        }
        return players;
    }

    private getShortestPath(playerPosition: Coords, destination: Coords, pathsMap: Map<string, Coords>): Coords[] | null {
        const destinationKey = `${destination.x},${destination.y}`;
        if (!pathsMap.has(destinationKey) && !(destination.x === playerPosition.x && destination.y === playerPosition.y))
            throw new Error('Chemin introuvable');

        const path: Coords[] = [];
        let current = { x: destination.x, y: destination.y };

        while (!(current.x === playerPosition.x && current.y === playerPosition.y)) {
            path.unshift(current);
            const key = `${current.x},${current.y}`;
            current = pathsMap.get(key);
        }

        path.unshift({ x: playerPosition.x, y: playerPosition.y });
        return path;
    }
}

import { Tile } from '@app/interfaces/tile';
import { Item } from '@app/interfaces/item';
import { Player } from '@app/interfaces/player';
import { Coords } from '@app/interfaces/coords';

export interface Cell {
    tile: Tile;
    item?: Item | null;
    player?: Player | null;
    x: number;
    y: number;
}

export interface ReachableTile {
    coords: Coords;
    moveCost: number;
}

export interface ShortestPath {
    playerId: string;
    path: Coords[];
}

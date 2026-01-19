import { Tile } from '@app/modules/game/interfaces/tile';
import { Item } from '@app/shared/interfaces/item';
import { Player } from '@app/shared/interfaces/player';
import { Coords } from '@app/modules/movement/interfaces/coords';

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

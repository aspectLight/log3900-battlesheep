import { Coords } from './coords';

export interface PlayerStats {
    name: string;
    combats: number;
    evasions: number;
    victories: number;
    defeats: number;
    healthLost: number;
    damage: number;
    itemsCollected: string[];
    tilesVisited: Coords[];
}

export interface GlobalStats {
    gameDuration: string;
    turns: number;
    doorsToggled: Coords[];
}

import { Coords } from '@app/interfaces/coords.interface';

export interface PlayerStatsData {
    name?: string;
    combats?: number;
    evasions?: number;
    victories?: number;
    defeats?: number;
    healthLost?: number;
    damage?: number;
    itemsCollected?: string[];
    tilesVisited?: Coords[];
}

import { Coords } from '@app/interfaces/coords';

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

export class PlayerStats {
    name: string;
    combats: number;
    evasions: number;
    victories: number;
    defeats: number;
    healthLost: number;
    damage: number;
    itemsCollected: string[];
    tilesVisited: Coords[];

    constructor(data: PlayerStatsData = {}) {
        this.name = data.name ?? '';
        this.combats = data.combats ?? 0;
        this.evasions = data.evasions ?? 0;
        this.victories = data.victories ?? 0;
        this.defeats = data.defeats ?? 0;
        this.healthLost = data.healthLost ?? 0;
        this.damage = data.damage ?? 0;
        this.itemsCollected = data.itemsCollected ?? [];
        this.tilesVisited = data.tilesVisited ?? [];
    }
}

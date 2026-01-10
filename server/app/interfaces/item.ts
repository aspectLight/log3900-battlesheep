export interface Item {
    type: string;
}

export enum ItemType {
    Adrenaline = 'adrenaline',
    Vodka = 'vodka',
    Propaganda = 'propaganda',
    BarbedWire = 'barbedWire',
    Camouflage = 'camouflage',
    WaterProofBoots = 'waterproofBoots',
    AirStrike = 'airStrike',
    SpawnPoint = 'spawnPoint',
    Random = 'random',
    Flag = 'flag',
}

export enum AggressiveItemType {
    Vodka = 'vodka',
    Propaganda = 'propaganda',
}

export enum DefensiveItemType {
    Adrenaline = 'adrenaline',
    WaterProofBoots = 'waterproofBoots',
    Propaganda = 'propaganda',
}

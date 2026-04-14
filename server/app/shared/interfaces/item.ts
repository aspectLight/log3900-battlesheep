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
    Torch = 'torch',
    SpawnPoint = 'spawnPoint',
    Random = 'random',
    Flag = 'flag',
}

export enum AggressiveItemType {
    Vodka = 'vodka',
    Propaganda = 'propaganda',
    Torch = 'torch',
}

export enum DefensiveItemType {
    Adrenaline = 'adrenaline',
    WaterProofBoots = 'waterproofBoots',
    Propaganda = 'propaganda',
    Torch = 'torch',
}

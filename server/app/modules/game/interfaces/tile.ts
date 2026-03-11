export interface Tile {
    type: TileType;
    orientation?: string;
    state?: string;
}

export enum TileType {
    Snow = 'snow',
    Tree = 'tree',
    Stone = 'stone',
    Ice = 'ice',
    Water = 'water',
    Door = 'door',
    Wall = 'wall',
    Corner = 'corner',
    Intersection = 'intersection',
    Trap = 'trap',
    TeleportPad = 'teleportPad',
}

export enum MoveCosts {
    Ice = 0,
    Snow = 1,
    Water = 2,
    WaterWithBoots = 1,
    Tree = Infinity,
    Stone = Infinity,
    Door = 1,
    Wall = Infinity,
    Corner = Infinity,
    Intersection = Infinity,
    Trap = 1,
    TeleportPad = 1,
}

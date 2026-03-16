export interface ItemType {
    name: string;
    description: string;
    imagePath: string;
}

export const ADRENALINE_HEALTH_BOOST = 2;
export const VODKA_ATTACK_BOOST = 2;
export const VODKA_SPEED_REDUCTION = 1;
export const PROPAGANDA_ATTACK_BOOST = 5;
export const PROPAGANDA_DEFENSE_BOOST = 5;
export const PROPAGANDA_HEALTH_THRESHOLD = 3;

export const TORCH_ATTACK_BOOST = 1;
export const TORCH_DEFENSE_BOOST = 1;
export const TORCH_ILLUMINATION_RADIUS = 2;

export const ITEM_TYPES: { [key: string]: ItemType } = {
    adrenaline: {
        name: 'Adrenaline',
        description: 'Ajoute 2 points de vie',
        imagePath: './assets/items/drug.png',
    },
    vodka: {
        name: 'Vodka',
        description: "Ajoute 2 points d'attaque, enlève 1 point de rapidité",
        imagePath: './assets/items/vodka.png',
    },
    propaganda: {
        name: 'Propaganda',
        description: "Ajoute 5 points d'attaque et 5 points de défense si le joueur est à moins de 3 points de vie",
        imagePath: './assets/items/propaganda.png',
    },
    barbedWire: {
        name: 'Barbed Wire',
        description: "La fuite est impossible pour l'adversaire, seulement si vous êtes l'instigateur du combat",
        imagePath: './assets/items/barbed_wire.png',
    },
    camouflage: {
        name: 'Camouflage',
        description: "Permet de se déplacer vers n'importe quelle case pour 1 point d'action",
        imagePath: './assets/items/camouflage.png',
    },
    waterproofBoots: {
        name: 'Waterproof Boots',
        description: 'Les déplacements vers une autre case coûtent 1 point de mouvement',
        imagePath: './assets/items/boots.png',
    },
    airStrike: {
        name: 'Air Strike',
        description: "Permet d'attaquer à distance",
        imagePath: './assets/items/air_strike.png',
    },
    torch: {
        name: 'Torch',
        description: 'Une torche enflammée',
        imagePath: './assets/items/torch.png',
    },
    random: {
        name: 'Random',
        description: 'Un item aléatoire qui sera révélé en pleine partie',
        imagePath: './assets/items/dice.png',
    },
    flag: {
        name: 'Flag',
        description: 'Un drapeau à ramener à la base',
        imagePath: './assets/items/flag.png',
    },
    spawnPoint: {
        name: 'Spawn',
        description: 'Un feu de camp servant de base',
        imagePath: './assets/items/spawn.gif',
    },
};

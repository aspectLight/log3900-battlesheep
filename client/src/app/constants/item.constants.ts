export interface ItemType {
    name: string;
    description: string;
    imagePath: string;
}

export const ITEM_TYPES: { [key: string]: ItemType } = {
    adrenaline: {
        name: 'Adrenaline',
        description: 'Ajoute 2 points de rapidité, enlève 1 point de défense',
        imagePath: './assets/items/drug.png',
    },

    vodka: {
        name: 'Vodka',
        description: "Ajoute 2 points d'attaque, enlève 1 point de rapidité",
        imagePath: './assets/items/vodka.png',
    },

    propaganda: {
        name: 'Propaganda',
        description: "Ajoute 2 points d'attaque et 1 point de défense si le joueur est à 1 point de vie",
        imagePath: './assets/items/propaganda.png',
    },

    barbedWire: {
        name: 'Barbed Wire',
        description: 'Enlève 1 point de vie à votre adversaire si sa tentative de fuite échoue',
        imagePath: './assets/items/barbed_wire.png',
    },

    camouflage: {
        name: 'Camouflage',
        description: "Augmente les chances de s'enfuir du combat à 50%",
        imagePath: './assets/items/camouflage.png',
    },

    waterproofBoots: {
        name: 'Waterproof Boots',
        description: 'Les déplacements vers une autre case coûtent 1 point de mouvement',
        imagePath: './assets/items/boots.png',
    },

    spawnPoint: {
        name: 'Spawn',
        description: 'Un feu de camp servant de base',
        imagePath: './assets/items/spawn.gif',
    },
    random: {
        name: 'Random',
        description: 'Un item aléatoire qui sera révélé en pleine partie',
        imagePath: './assets/items/dice.png',
    },
};

/* Ce fichier contient les constantes utilisées pour un système d'autotile.
 * L'orientation des tuiles suit une nomenclature spécifique qui utilise `_` comme séparateur
 * afin de différencier :
 * - Les orientations classiques, qui représentent des connexions directes entre tuiles adjacentes.
 * - Les diagonales (`_`), qui permettent de gérer des cas plus spécifiques dans l'affichage des tuiles.
 *
 * Le format des clés (`defaultUpRight_BL`, etc.) est conçu pour être facilement exploitable via `split('_')`,
 * permettant d'extraire les différentes composantes de l'orientation sans ambiguïté. Cela évite des traitements
 * complexes et assure une gestion dynamique des tuiles.
 */
/* eslint-disable @typescript-eslint/naming-convention */

export const TILE_TYPES: {
    [key: string]: {
        name: string;
        description: string;
        baseMoveModifier: number;
        images: {
            [key: string]: string;
        };
        defaultState: string;
        defaultOrientation: string;
        rotations?: string[];
        states?: string[];
        variants?: string[];
        variantProbability?: number;
    };
} = {
    tree: {
        name: 'Tree',
        description: 'Un arbre qui ne peut pas être grimpé',
        baseMoveModifier: -1,
        images: {
            default: './assets/tiles/tree.png',
        },
        defaultState: 'default',
        defaultOrientation: '',
    },
    stone: {
        name: 'Stone',
        description: 'Une grande pierre qui bloque la route',
        baseMoveModifier: -1,
        images: {
            default: './assets/tiles/stone.png',
        },
        defaultState: 'default',
        defaultOrientation: '',
    },
    trap: {
        name: 'Trap',
        description: 'Un piège qui freine les déplacements',
        baseMoveModifier: 1,
        images: {
            default: './assets/tiles/trap.png',
        },
        defaultState: 'default',
        defaultOrientation: '',
    },
    teleportPad: {
        name: 'Teleport Pad',
        description: 'Un téléporteur qui mène à un autre téléporteur',
        baseMoveModifier: 1,
        images: {
            default: './assets/tiles/teleport.png',
            blue: './assets/tiles/teleport_blue.png',
            green: './assets/tiles/teleport_green.png',
            purple: './assets/tiles/teleport_purple.png',
            red: './assets/tiles/teleport_red.png',
            yellow: './assets/tiles/teleport_yellow.png',
        },
        defaultState: 'default',
        defaultOrientation: '',
        states: ['default', 'blue', 'green', 'purple', 'red', 'yellow'],
    },
    ice: {
        name: 'Ice',
        description: 'Une tuile de glace',
        baseMoveModifier: 1,
        images: {
            default: './assets/tiles/ice.png',
            defaultUp: './assets/tiles/ice_up.png', // Bitmask 1
            defaultRight: './assets/tiles/ice_right.png', // Bitmask 2
            defaultUpRight: './assets/tiles/ice_up_right.png', // Bitmask 3
            defaultDown: './assets/tiles/ice_down.png', // Bitmask 4
            defaultVertical: './assets/tiles/ice_vertical.png', // Bitmask 5 (Up + Down)
            defaultDownRight: './assets/tiles/ice_down_right.png', // Bitmask 6
            defaultUpRightDown: './assets/tiles/ice_up_right_down.png', // Bitmask 7
            defaultLeft: './assets/tiles/ice_left.png', // Bitmask 8
            defaultUpLeft: './assets/tiles/ice_up_left.png', // Bitmask 9
            defaultHorizontal: './assets/tiles/ice_horizontal.png', // Bitmask 10 (Left + Right)
            defaultUpRightLeft: './assets/tiles/ice_up_right_left.png', // Bitmask 11
            defaultDownLeft: './assets/tiles/ice_down_left.png', // Bitmask 12
            defaultUpDownLeft: './assets/tiles/ice_up_down_left.png', // Bitmask 13
            defaultDownRightLeft: './assets/tiles/ice_down_right_left.png', // Bitmask 14
            defaultAll: './assets/tiles/ice_all.png', // Bitmask 15 (Up + Right + Down + Left)
        },
        defaultState: 'default',
        defaultOrientation: '',
        rotations: [
            'Up',
            'Right',
            'UpRight',
            'Down',
            'Vertical',
            'DownRight',
            'UpRightDown',
            'Left',
            'UpLeft',
            'Horizontal',
            'UpRightLeft',
            'DownLeft',
            'UpDownLeft',
            'DownRightLeft',
            'All',
        ],
    },
    water: {
        name: 'Water',
        description: "Une tuile d'eau",
        baseMoveModifier: 2,
        images: {
            default: './assets/tiles/water.png',
            defaultUp: './assets/tiles/water_up.png', // Bitmask 1
            defaultRight: './assets/tiles/water_right.png', // Bitmask 2
            defaultUpRight: './assets/tiles/water_up_right.png', // Bitmask 3
            defaultUpRight_BL: './assets/tiles/water_up_right_BL.png',
            defaultDown: './assets/tiles/water_down.png', // Bitmask 4
            defaultVertical: './assets/tiles/water_vertical.png', // Bitmask 5 (Up + Down)
            defaultDownRight: './assets/tiles/water_down_right.png', // Bitmask 6
            defaultDownRight_TL: './assets/tiles/water_down_right_TL.png',
            defaultUpRightDown: './assets/tiles/water_up_right_down.png', // Bitmask 7
            defaultUpRightDown_TR: './assets/tiles/water_up_right_down_TR.png',
            defaultUpRightDown_BR: './assets/tiles/water_up_right_down_BR.png',
            defaultUpRightDown_TR_BR: './assets/tiles/water_up_right_down_TR_BR.png',
            defaultLeft: './assets/tiles/water_left.png', // Bitmask 8
            defaultUpLeft: './assets/tiles/water_up_left.png', // Bitmask 9
            defaultUpLeft_BR: './assets/tiles/water_up_left_BR.png',
            defaultHorizontal: './assets/tiles/water_horizontal.png', // Bitmask 10 (Left + Right)
            defaultUpRightLeft: './assets/tiles/water_up_right_left.png', // Bitmask 11
            defaultUpRightLeft_TL: './assets/tiles/water_up_right_left_TL.png',
            defaultUpRightLeft_TR: './assets/tiles/water_up_right_left_TR.png',
            defaultUpRightLeft_TL_TR: './assets/tiles/water_up_right_left_TR_TL.png',
            defaultDownLeft: './assets/tiles/water_down_left.png', // Bitmask 12
            defaultDownLeft_TR: './assets/tiles/water_down_left_TR.png',
            defaultUpDownLeft: './assets/tiles/water_up_down_left.png', // Bitmask 13
            defaultUpDownLeft_BL: './assets/tiles/water_up_down_left_BL.png',
            defaultUpDownLeft_TL: './assets/tiles/water_up_down_left_TL.png',
            defaultUpDownLeft_TL_BL: './assets/tiles/water_up_down_left_TL_BL.png',
            defaultDownRightLeft: './assets/tiles/water_down_right_left.png', // Bitmask 14
            defaultDownRightLeft_BR: './assets/tiles/water_down_right_left_BR.png',
            defaultDownRightLeft_BL: './assets/tiles/water_down_right_left_BL.png',
            defaultDownRightLeft_BR_BL: './assets/tiles/water_down_right_left_BL_BR.png',
            defaultAll: './assets/tiles/water_all.png', // Bitmask 15 (Up + Right + Down + Left)
            defaultAll_TL_TR_BR_BL: './assets/tiles/water_full.png',
            defaultAll_BR: './assets/tiles/water_all_BR.png',
            defaultAll_BL: './assets/tiles/water_all_BL.png',
            defaultAll_TL: './assets/tiles/water_all_TL.png',
            defaultAll_TR: './assets/tiles/water_all_TR.png',
            defaultAll_TL_BL: './assets/tiles/water_all_TL_BL.png',
            defaultAll_TL_BR: './assets/tiles/water_all_TL_BR.png',
            defaultAll_TR_BL: './assets/tiles/water_all_TR_BL.png',
            defaultAll_TL_TR: './assets/tiles/water_all_TL_TR.png',
            defaultAll_TR_BR: './assets/tiles/water_all_TR_BR.png',
            defaultAll_BR_BL: './assets/tiles/water_all_BR_BL.png',
            defaultAll_TR_BR_BL: './assets/tiles/water_all_TR_BR_BL.png',
            defaultAll_TL_BR_BL: './assets/tiles/water_all_TL_BR_BL.png',
            defaultAll_TL_TR_BL: './assets/tiles/water_all_TL_TR_BL.png',
            defaultAll_TL_TR_BR: './assets/tiles/water_all_TL_TR_BR.png',
        },
        defaultState: 'default',
        defaultOrientation: '',
        rotations: [
            'Up',
            'Right',
            'UpRight',
            'Down',
            'Vertical',
            'DownRight',
            'UpRightDown',
            'Left',
            'UpLeft',
            'Horizontal',
            'UpRightLeft',
            'DownLeft',
            'UpDownLeft',
            'DownRightLeft',
            'All',
        ],
    },

    door: {
        name: 'Door',
        description: 'Une porte qui peut être ouverte ou fermée',
        baseMoveModifier: -1,
        images: {
            closedHorizontal: './assets/tiles/door_horizontal_closed.png',
            openedHorizontal: './assets/tiles/door_horizontal_opened.png',
            closedVertical: './assets/tiles/door_vertical_closed.png',
            openedVertical: './assets/tiles/door_vertical_opened.png',
            default: './assets/tiles/door_horizontal_closed.png',
        },
        defaultState: 'closed',
        defaultOrientation: 'Horizontal',
        states: ['closed', 'opened'],
        rotations: ['Horizontal', 'Vertical'],
    },
    wall: {
        name: 'Wall',
        description: 'Un mur infranchissable',
        baseMoveModifier: -1,
        images: {
            defaultHorizontal: './assets/tiles/wall_horizontal.png',
            defaultVertical: './assets/tiles/wall_vertical.png',
            default: './assets/tiles/wall_horizontal.png',
        },
        defaultState: 'default',
        defaultOrientation: 'Horizontal',
        rotations: ['Horizontal', 'Vertical'],
    },
    corner: {
        name: 'Corner',
        description: 'Un mur infranchissable',
        baseMoveModifier: -1,
        images: {
            defaultUpRight: './assets/tiles/corner_up_right.png',
            defaultUpLeft: './assets/tiles/corner_up_left.png',
            defaultDownRight: './assets/tiles/corner_down_right.png',
            defaultDownLeft: './assets/tiles/corner_down_left.png',
            default: './assets/tiles/corner_up_right.png',
        },
        defaultState: 'default',
        defaultOrientation: 'UpRight',
        rotations: ['UpRight', 'UpLeft', 'DownRight', 'DownLeft'],
    },
    snow: {
        name: 'Snow',
        description: 'Une tuile de neige basique',
        baseMoveModifier: 1,
        images: {
            default: './assets/tiles/snow.png',
        },
        defaultState: 'default',
        defaultOrientation: 'Horizontal',
        rotations: ['Horizontal', 'Vertical'],
        variants: ['./assets/tiles/snow_variant1.png', './assets/tiles/snow_variant2.png'],
        variantProbability: 0.1,
    },

    intersection: {
        name: 'Intersection',
        description: 'Un mur infranchissable',
        baseMoveModifier: -1,
        images: {
            defaultTUp: './assets/tiles/intersection_T_up.png',
            defaultTRight: './assets/tiles/intersection_T_right.png',
            defaultTDown: './assets/tiles/intersection_T_down.png',
            defaultTLeft: './assets/tiles/intersection_T_left.png',
            defaultCross: './assets/tiles/intersection_cross.png',
            default: './assets/tiles/intersection_T_up.png',
        },
        defaultState: 'default',
        defaultOrientation: 'TUp',
        rotations: ['TUp', 'TRight', 'TDown', 'TLeft', 'Cross'],
    },
};

export const ALLOWED_TILES = ['door', 'water', 'ice', 'wall', 'tree', 'stone', 'trap', 'teleportPad'];

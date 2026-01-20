export const TILES_COVERAGE_PERCENTAGE = 0.5;
export const TERRAIN_TILES = ['water', 'ice', 'snow'];
export const ACCESSIBLE_TILES = ['water', 'ice', 'snow', 'door'];
export const WALL_TYPE_TILES = ['wall', 'corner', 'intersection', 'stone', 'tree'];

export const BOARD_SIZES = {
    small: 10,
    medium: 15,
    large: 20,
};

export const REQUIRED_OBJECTS = {
    spawnPoints: {
        [BOARD_SIZES.small]: {
            min: 2,
            max: 2,
        },
        [BOARD_SIZES.medium]: {
            min: 2,
            max: 4,
        },
        [BOARD_SIZES.large]: {
            min: 2,
            max: 6,
        },
    },
    items: {
        [BOARD_SIZES.small]: 2,
        [BOARD_SIZES.medium]: 4,
        [BOARD_SIZES.large]: 6,
    },
};

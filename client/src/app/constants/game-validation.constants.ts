import { TILE_TYPES } from './tile.constants';

export const TILES_COVERAGE_PERCENTAGE = 0.5;
export const TERRAIN_TILES = Object.keys(TILE_TYPES).filter((key) => ['water', 'ice', 'snow'].includes(key));
export const ACCESIBLE_TILES = Object.keys(TILE_TYPES).filter((key) => ['water', 'ice', 'snow', 'door'].includes(key));
export const WALL_TYPE_TILES = Object.keys(TILE_TYPES).filter((key) => ['wall', 'corner', 'intersection', 'stone', 'tree'].includes(key));

export const BOARD_SIZES = {
    small: 10,
    medium: 15,
    large: 20,
};

export const REQUIRED_OBJECTS = {
    [BOARD_SIZES.small]: 2,
    [BOARD_SIZES.medium]: 4,
    [BOARD_SIZES.large]: 6,
};

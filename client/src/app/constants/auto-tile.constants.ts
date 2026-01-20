export interface BitmaskMapping {
    type: string;
    orientation: string;
}

export interface CategoryConfig {
    use8Directions: boolean;
    bitmaskMap: Record<number, BitmaskMapping>;
}

/* eslint-disable no-bitwise, @typescript-eslint/naming-convention */
export const AUTO_TILE_CONFIG: Record<string, CategoryConfig> = {
    wall: {
        use8Directions: false,
        bitmaskMap: {
            0: { type: 'wall', orientation: 'Horizontal' },
            1: { type: 'wall', orientation: 'Vertical' },
            2: { type: 'wall', orientation: 'Horizontal' },
            3: { type: 'corner', orientation: 'DownLeft' },
            4: { type: 'wall', orientation: 'Vertical' },
            5: { type: 'wall', orientation: 'Vertical' },
            6: { type: 'corner', orientation: 'UpLeft' },
            7: { type: 'intersection', orientation: 'TRight' },
            8: { type: 'wall', orientation: 'Horizontal' },
            9: { type: 'corner', orientation: 'DownRight' },
            10: { type: 'wall', orientation: 'Horizontal' },
            11: { type: 'intersection', orientation: 'TUp' },
            12: { type: 'corner', orientation: 'UpRight' },
            13: { type: 'intersection', orientation: 'TLeft' },
            14: { type: 'intersection', orientation: 'TDown' },
            15: { type: 'intersection', orientation: 'Cross' },
        },
    },

    water: {
        use8Directions: true,
        bitmaskMap: {
            0: { type: 'water', orientation: 'Default' },
            1: { type: 'water', orientation: 'Up' },
            2: { type: 'water', orientation: 'Right' },
            3: { type: 'water', orientation: 'DownLeft' },
            4: { type: 'water', orientation: 'Down' },
            5: { type: 'water', orientation: 'Vertical' },
            6: { type: 'water', orientation: 'UpLeft' },
            7: { type: 'water', orientation: 'UpRightDown' },
            8: { type: 'water', orientation: 'Left' },
            9: { type: 'water', orientation: 'DownRight' },
            10: { type: 'water', orientation: 'Horizontal' },
            11: { type: 'water', orientation: 'UpRightLeft' },
            12: { type: 'water', orientation: 'UpRight' },
            13: { type: 'water', orientation: 'UpDownLeft' },
            14: { type: 'water', orientation: 'DownRightLeft' },
            15: { type: 'water', orientation: 'All' },
        },
    },

    ice: {
        use8Directions: true,
        bitmaskMap: {
            0: { type: 'ice', orientation: 'Default' },
            1: { type: 'ice', orientation: 'Up' },
            2: { type: 'ice', orientation: 'Right' },
            3: { type: 'ice', orientation: 'UpRight' },
            4: { type: 'ice', orientation: 'Down' },
            5: { type: 'ice', orientation: 'Vertical' },
            6: { type: 'ice', orientation: 'DownRight' },
            7: { type: 'ice', orientation: 'UpRightDown' },
            8: { type: 'ice', orientation: 'Left' },
            9: { type: 'ice', orientation: 'UpLeft' },
            10: { type: 'ice', orientation: 'Horizontal' },
            11: { type: 'ice', orientation: 'UpRightLeft' },
            12: { type: 'ice', orientation: 'DownLeft' },
            13: { type: 'ice', orientation: 'UpDownLeft' },
            14: { type: 'ice', orientation: 'DownRightLeft' },
            15: { type: 'ice', orientation: 'All' },
        },
    },
};

export interface BoardConfig {
    board: number;
    players: string;
    items: number;
}

export const BOARD_SIZES: { [key: string]: BoardConfig } = {
    petite: { board: 10, players: '2', items: 2 },
    moyenne: { board: 15, players: '2-4', items: 4 },
    grande: { board: 20, players: '2-6', items: 6 },
};

export const ITEM_COUNT = 6;
export const UNIQUE_ITEM_COUNT = 1;

export interface BoardConfig {
    board: number;
    players: string;
    items: number;
}

export enum BoardSizes {
    Petite = 'petite',
    Moyenne = 'moyenne',
    Grande = 'grande',
}

export const BOARD_CONFIGS: { [key in BoardSizes]: BoardConfig } = {
    [BoardSizes.Petite]: { board: 10, players: '2', items: 2 },
    [BoardSizes.Moyenne]: { board: 15, players: '2-4', items: 4 },
    [BoardSizes.Grande]: { board: 20, players: '2-6', items: 6 },
};

export const ITEM_COUNT = 6;
export const UNIQUE_ITEM_COUNT = 1;

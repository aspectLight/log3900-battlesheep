export type ShopItemType = 'avatar' | 'banner' | 'character';

export interface ShopItem {
    id: string;
    name: string;
    type: ShopItemType;
    price: number;
    imagePath?: string;
}

export const SHOP_CATALOGUE: ShopItem[] = [
    // Player banners
    { id: 'banner_gold', name: 'Bannière dorée', type: 'banner', price: 200 },
    { id: 'banner_shadow', name: 'Bannière sombre', type: 'banner', price: 200 },
    { id: 'banner_flame', name: 'Bannière flamme', type: 'banner', price: 200 },
    { id: 'banner_ice', name: 'Bannière glaciale', type: 'banner', price: 200 },
    { id: 'banner_neon', name: 'Bannière néon', type: 'banner', price: 200 },

    // Exclusive avatars
    { id: 'streetFighter', name: 'Street Fighter', type: 'avatar', price: 500, imagePath: './assets/avatars/account-creation/street-fighter.png' },
    {
        id: 'tacticalOperator',
        name: 'Tactical Operator',
        type: 'avatar',
        price: 500,
        imagePath: './assets/avatars/account-creation/tactical-operator.png',
    },
    { id: 'screamGhostface', name: 'Ghostface', type: 'avatar', price: 500, imagePath: './assets/avatars/account-creation/scream-ghostface.png' },

    // Exclusive in-game characters
    { id: 'sergei', name: 'Sergei', type: 'character', price: 300, imagePath: './assets/avatars/new/sergeiAvatar.png' },
    { id: 'sokolov', name: 'Sokolov', type: 'character', price: 300, imagePath: './assets/avatars/new/sokolovAvatar.png' },
    { id: 'viktor', name: 'Viktor', type: 'character', price: 300, imagePath: './assets/avatars/new/viktorAvatar.png' },
    { id: 'volkov', name: 'Volkov', type: 'character', price: 300, imagePath: './assets/avatars/new/volkovAvatar.png' },
];

export const EXCLUSIVE_AVATAR_IDS = SHOP_CATALOGUE.filter((item) => item.type === 'avatar').map((item) => item.id);
export const EXCLUSIVE_CHARACTER_IDS = SHOP_CATALOGUE.filter((item) => item.type === 'character').map((item) => item.id);

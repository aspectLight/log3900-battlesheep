import { Item } from '@app/classes/item';
import { Player } from '@app/classes/player';

export enum BonusValue {
    DEFAULT = 4,
    BOOSTED = 6,
}

export interface Bonus {
    life: BonusValue.DEFAULT | BonusValue.BOOSTED;
    speed: BonusValue.DEFAULT | BonusValue.BOOSTED;
    defense: BonusValue.DEFAULT | BonusValue.BOOSTED | null;
    attack: BonusValue.DEFAULT | BonusValue.BOOSTED | null;
}

export interface Character {
    character: {
        name: string;
        id: number;
        avatar: string;
        avatarFull: string;
    };
    bonus: Bonus;
}

export interface ItemCard {
    item: Item;
    isExpanded: boolean;
}

export interface PlayerCard {
    player: Player;
    playerColor: string;
    isActive: boolean;
    isHost?: boolean;
    isDisconnected?: boolean;
}

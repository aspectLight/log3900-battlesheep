import { Coords } from '@app/modules/movement/interfaces/coords';
import { Item } from '@app/shared/interfaces/item';

export enum VirtualPlayerType {
    Aggressive = 'aggressive',
    Defensive = 'defensive',
}

export interface Player {
    id: string;
    name?: string;
    avatar?: { name: string };
    position?: Coords;
    spawnPoint?: Coords;
    actionPoints?: number;
    movementPoints?: number;
    bonusChoice?: string;
    d4Choice?: string;
    d6Choice?: string;
    evasionPoints?: number;
    color?: string;
    inventory?: Item[];
    stats?: { [key: string]: { maxValue: number; value: number; description: string } };
    isVirtual?: boolean;
    profile?: VirtualPlayerType;
    hasBoots?: boolean;
    team?: number;
    firebaseUid?: string;
    fightsWon?: number;
}

export const enum BonusType {
    Health = 'health',
    Speed = 'speed',
    Attack = 'attack',
    Defense = 'defense',
}

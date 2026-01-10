import { Item } from '@app/interfaces/item';
import { Coords } from './coords';

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
}

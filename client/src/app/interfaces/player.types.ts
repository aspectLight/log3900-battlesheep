import { BonusType } from '@app/constants/bonus.constants';

export type Orientation = 'up' | 'down' | 'left' | 'right';
export type PlayerState = 'idle' | 'moving' | 'dead' | 'attacking';
export type Stats = BonusType.Health | BonusType.Speed | BonusType.Attack | BonusType.Defense;

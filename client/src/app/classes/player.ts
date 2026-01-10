import { BonusType } from '@app/constants/bonus.constants';
import {
    AVATAR_TYPES,
    AvatarType,
    BONUS_VALUE,
    D4_VALUE,
    D6_VALUE,
    DEFAULT_ACTION_POINTS,
    DEFAULT_MOVEMENT_POINTS,
} from '@app/constants/player.constants';
import { Coords } from '@app/interfaces/coords';
import { StatInfo } from '@app/interfaces/stat-info';
import { Entity } from './entity';
import { Item } from './item';

export type Orientation = 'up' | 'down' | 'left' | 'right';
export type PlayerState = 'idle' | 'moving' | 'dead' | 'attacking';
export type Stats = BonusType.Health | BonusType.Speed | BonusType.Attack | BonusType.Defense;

export class Player extends Entity {
    name: string | null;
    avatar: AvatarType | null;
    stats: { [key in BonusType]: StatInfo } = {
        [BonusType.Health]: {
            value: 4,
            description: "Représente les points de vie du personnage. S'il tombe à zéro, le joueur est battu",
        },
        [BonusType.Speed]: {
            value: 4,
            description: "Détermine l'ordre de passage du personnage en combat et le nombre de points de mouvement par tour",
        },
        [BonusType.Attack]: {
            value: 4,
            description: 'Détermine les dégâts infligés par le personnage aux adversaires.',
        },
        [BonusType.Defense]: {
            value: 4,
            description: 'Représente la capacité du personnage à bloquer les dégâts des attaques ennemies.',
        },
    };
    inventory: [Item | null, Item | null];

    spawnPoint: Coords;
    position: Coords;
    actionPoints: number;
    movementPoints: number;

    bonusChoice: Stats | null;
    d4Choice: Stats;
    d6Choice: Stats | null;

    orientation: Orientation;
    animationState: PlayerState;
    color: string = 'yellow';

    fightsWon: number = 0;

    constructor(name?: string, avatar?: string, bonusChoice?: Stats, d6Choice?: Stats) {
        super();
        this.name = name || null;
        this.avatar = avatar ? AVATAR_TYPES[avatar] : null;
        this.actionPoints = DEFAULT_ACTION_POINTS;
        this.movementPoints = DEFAULT_MOVEMENT_POINTS;
        this.bonusChoice = bonusChoice || null;
        this.d6Choice = d6Choice || null;
        this.d4Choice = d6Choice === BonusType.Attack ? BonusType.Defense : BonusType.Attack;
        this.inventory = [null, null];
        this.orientation = 'down';
        this.animationState = 'idle';
        this.applyBonus();
    }

    static fromObject(obj: Player): Player {
        const player = new Player();

        player.id = obj.id;
        player.name = obj.name;
        player.avatar = obj.avatar;
        player.actionPoints = obj.actionPoints;
        player.movementPoints = obj.movementPoints;
        player.bonusChoice = obj.bonusChoice;
        player.d6Choice = obj.d6Choice;
        player.d4Choice = obj.d4Choice;
        player.orientation = obj.orientation;
        player.animationState = obj.animationState;
        player.color = obj.color;
        if (obj.spawnPoint) {
            player.spawnPoint = obj.spawnPoint;
        }

        player.stats = { ...obj.stats };

        return player;
    }

    setOrientation(orientation: Orientation): void {
        this.orientation = orientation;
    }

    setState(state: PlayerState): void {
        this.animationState = state;
    }

    setStatValue(stat: BonusType, value: number) {
        this.stats[stat].value = value;
    }

    isAlive(): boolean {
        return this.stats.health.value > 0;
    }

    rollDice(diceNumber: number) {
        return this.generateDiceValue(diceNumber);
    }

    rollStat(stat: Stats): number {
        const malus = this.cell?.tile.type === 'ice' ? 2 : 0;

        if (stat === this.d6Choice) {
            return this.generateDiceValue(D6_VALUE) + this.stats[stat].value - malus;
        } else {
            return this.generateDiceValue(D4_VALUE) + this.stats[stat].value - malus;
        }
    }

    rollStatDebug(stat: Stats): number {
        const malus = this.cell?.tile.type === 'ice' ? 2 : 0;

        if (stat === BonusType.Attack) {
            if (stat === this.d6Choice) return D6_VALUE + this.stats[stat].value - malus;
            if (stat === this.d4Choice) return D4_VALUE + this.stats[stat].value - malus;
        } else if (stat === BonusType.Defense) {
            if (stat === this.d6Choice) return 1 + this.stats[stat].value - malus;
            if (stat === this.d4Choice) return 1 + this.stats[stat].value - malus;
        }
        return 0;
    }

    protected generateDiceValue(diceNumber: number) {
        return Math.floor(Math.random() * diceNumber) + 1;
    }

    protected applyBonus(): void {
        if (this.bonusChoice) this.stats[this.bonusChoice].value += BONUS_VALUE;
        this.movementPoints = this.stats[BonusType.Speed].value;
    }

    protected applyDiceBonus(): void {
        if (this.d6Choice) {
            this.stats[this.d6Choice].value += this.generateDiceValue(D6_VALUE);
            this.stats[this.d4Choice].value += this.generateDiceValue(D4_VALUE);
        }
    }
}

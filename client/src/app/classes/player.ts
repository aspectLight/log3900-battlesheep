import { BonusType } from '@app/constants/bonus.constants';
import { PROPAGANDA_ATTACK_BOOST, PROPAGANDA_DEFENSE_BOOST, VODKA_ATTACK_BOOST, VODKA_SPEED_REDUCTION } from '@app/constants/item.constants';
import {
    AVATAR_TYPES,
    AvatarType,
    BONUS_VALUE,
    DEFAULT_ACTION_POINTS,
    DEFAULT_MOVEMENT_POINTS,
    PROPAGANDA_ATTACK_THRESHOLD,
    PROPAGANDA_HEALTH_THRESHOLD,
    VirtualPlayerType,
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
    actionPoints: number;
    movementPoints: number;

    d4Choice: Stats;
    d6Choice: Stats | null;

    orientation: Orientation;
    animationState: PlayerState;
    color: string = 'yellow';

    fightsWon: number = 0;
    team: number;
    onReplaceItem?: (newItem: Item, currentInventory: [Item | null, Item | null], cellCoords: Coords) => void;

    isVirtual: boolean = false;
    private profile: VirtualPlayerType | undefined;
    private bonusChoice: Stats | null;
    private appliedItemEffects: { [itemId: string]: boolean } = {};

    constructor(name?: string, avatar?: string, bonusChoice?: Stats, d6Choice?: Stats, profile?: VirtualPlayerType) {
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
        this.isVirtual = profile !== undefined;
        this.profile = profile;
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
        if (obj.team !== undefined) {
            player.team = obj.team;
        }

        player.stats = { ...obj.stats };
        player.profile = obj.profile;
        player.isVirtual = obj.isVirtual;

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

        if (stat === BonusType.Health) {
            this.updatePropagandaEffects();
        }
    }

    isAlive(): boolean {
        return this.stats.health.value > 0;
    }

    addItem(item: Item): boolean | (Item | null)[] {
        if (this.inventory[0] === null) {
            this.inventory[0] = item;
            this.applyItemEffect(item);
            return true;
        } else if (this.inventory[1] === null) {
            this.inventory[1] = item;
            this.applyItemEffect(item);
            return true;
        } else {
            return this.inventory;
        }
    }

    replaceItem(newItem: Item, coords: Coords): void {
        if (this.onReplaceItem) {
            const cellCoords: Coords = { x: coords.x, y: coords.y };
            this.onReplaceItem(newItem, this.inventory, cellCoords);
        }
    }

    updateItemsEffect(multiplier: number) {
        if (multiplier !== 0) {
            if (multiplier > 0) {
                this.inventory.forEach((item) => {
                    if (item && this.appliedItemEffects[item.id]) {
                        this.updateItemEffects(item, -1);
                        delete this.appliedItemEffects[item.id];
                    }
                });
            }

            this.inventory.forEach((item) => {
                if (item) {
                    this.updateItemEffects(item, multiplier);
                    if (multiplier > 0) {
                        this.appliedItemEffects[item.id] = true;
                    }
                }
            });
        }
    }

    updatePropagandaEffects() {
        const propagandaItem = this.findItem('propaganda');
        if (propagandaItem) {
            this.removeItemEffect(propagandaItem);
            this.applyItemEffect(propagandaItem);
        }
    }

    hasItem(itemType: string): boolean {
        return this.findItem(itemType) !== null;
    }

    clearInfo(): void {
        this.clearAllItemEffects();

        this.stats[BonusType.Health].value = 4;
        this.stats[BonusType.Speed].value = 4;
        this.stats[BonusType.Attack].value = 4;
        this.stats[BonusType.Defense].value = 4;
        this.actionPoints = DEFAULT_ACTION_POINTS;
        this.movementPoints = DEFAULT_MOVEMENT_POINTS;
        this.inventory = [null, null];
        this.bonusChoice = null;
        this.d6Choice = null;
        this.avatar = null;
    }

    clearAllItemEffects(): void {
        this.inventory.forEach((item) => {
            if (item && this.appliedItemEffects[item.id]) {
                this.removeItemEffect(item);
            }
        });
        this.appliedItemEffects = {};
    }

    applyItemEffect(item: Item): void {
        if (!this.appliedItemEffects[item.id]) {
            this.updateItemEffects(item, 1);
            this.appliedItemEffects[item.id] = true;
        }
    }

    removeItemEffect(item: Item): void {
        if (this.appliedItemEffects[item.id]) {
            this.updateItemEffects(item, -1);
            delete this.appliedItemEffects[item.id];
        }
    }

    private findItem(itemType: string): Item | null {
        return this.inventory.find((item) => item?.type === itemType) || null;
    }

    private applyBonus(): void {
        if (this.bonusChoice) this.stats[this.bonusChoice].value += BONUS_VALUE;
        this.movementPoints = this.stats[BonusType.Speed].value;
    }

    private updateItemEffects(item: Item, multiplier: number) {
        switch (item.type) {
            case 'adrenaline':
                this.stats[BonusType.Health].value += 2 * multiplier;
                break;
            case 'vodka':
                this.stats[BonusType.Attack].value += VODKA_ATTACK_BOOST * multiplier;
                this.stats[BonusType.Speed].value -= VODKA_SPEED_REDUCTION * multiplier;
                break;
            case 'propaganda':
                if (this.stats[BonusType.Health].value < PROPAGANDA_HEALTH_THRESHOLD && multiplier > 0) {
                    this.stats[BonusType.Attack].value += PROPAGANDA_ATTACK_BOOST * multiplier;
                    this.stats[BonusType.Defense].value += PROPAGANDA_DEFENSE_BOOST * multiplier;
                } else if (multiplier < 0) {
                    if (this.stats[BonusType.Attack].value > PROPAGANDA_ATTACK_THRESHOLD) {
                        this.stats[BonusType.Attack].value += PROPAGANDA_ATTACK_BOOST * multiplier;
                        this.stats[BonusType.Defense].value += PROPAGANDA_DEFENSE_BOOST * multiplier;
                    }
                }
                break;
            case 'camouflage':
                break;
            case 'waterproofBoots':
                break;
            case 'airStrike':
                break;
        }
    }
}

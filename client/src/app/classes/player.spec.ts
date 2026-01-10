import { BonusType } from '@app/constants/bonus.constants';
import { AVATAR_TYPES, D4_VALUE, D6_VALUE, DEFAULT_ACTION_POINTS } from '@app/constants/player.constants';
import { Cell } from './cell';
import { Player } from './player';
import { Tile } from './tile';

const ATTACK_VALUE = 6;

describe('Player', () => {
    let player: Player;
    const pointFive = 0.5;
    const defaultValue = 4;
    const boostedValue = 6;
    const initialMoves = 4;
    const minDice = 1;
    const maxD4 = 4;
    const maxD6 = 6;
    const malus = 2;

    const obj = new Player('j1');
    obj.inventory = [null, null];
    obj.spawnPoint = { x: 0, y: 0 };

    beforeEach(() => {
        player = new Player('TestPlayer', 'irina', BonusType.Health, BonusType.Defense);
        player.spawnPoint = { x: 0, y: 0 };
    });

    it('should create an instance', () => {
        expect(new Player('Player1', 'irina', BonusType.Health, BonusType.Attack)).toBeTruthy();
    });

    it('should create a player with correct initial values', () => {
        expect(player.name).toBe('TestPlayer');
        expect(player.avatar).toBe(AVATAR_TYPES['irina']);
        expect(player.actionPoints).toBe(DEFAULT_ACTION_POINTS);
        expect(player.movementPoints).toBe(initialMoves);
        expect(player.bonusChoice).toBe(BonusType.Health);
        expect(player.d6Choice).toBe(BonusType.Defense);
        expect(player.d4Choice).toBe(BonusType.Attack);
        expect(player.inventory).toEqual([null, null]);
        expect(player.stats.health.value).toBe(boostedValue);
        expect(player.stats.speed.value).toBe(defaultValue);
        expect(player.stats.attack.value).toBe(defaultValue);
        expect(player.stats.defense.value).toBe(defaultValue);
    });

    it('should create a player with default values when no parameters are provided', () => {
        const defaultPlayer = new Player();
        expect(defaultPlayer.name).toBeNull();
        expect(defaultPlayer.avatar).toBeNull();
        expect(defaultPlayer.actionPoints).toBe(DEFAULT_ACTION_POINTS);
        expect(defaultPlayer.movementPoints).toBe(defaultValue);
        expect(defaultPlayer.bonusChoice).toBeNull();
        expect(defaultPlayer.d6Choice).toBeNull();
        expect(defaultPlayer.d4Choice).toBe(BonusType.Attack);
        expect(defaultPlayer.inventory).toEqual([null, null]);
        expect(defaultPlayer.orientation).toBe('down');
        expect(defaultPlayer.animationState).toBe('idle');
        expect(defaultPlayer.fightsWon).toBe(0);
    });

    it('should apply dice bonus correctly', () => {
        player['applyDiceBonus']();
        expect(player.stats['defense'].value).toBeGreaterThanOrEqual(minDice);
        expect(player.stats['defense'].value).toBeLessThanOrEqual(maxD6 + defaultValue);
    });

    it('should generate correct D4 value', () => {
        spyOn(Math, 'random').and.returnValue(pointFive);
        const roll = player.rollDice(maxD4);
        expect(roll).toBeGreaterThanOrEqual(minDice);
        expect(roll).toBeLessThanOrEqual(maxD4);
    });

    it('should generate correct D6 value', () => {
        spyOn(Math, 'random').and.returnValue(pointFive);
        const roll = player.rollDice(maxD6);
        expect(roll).toBeGreaterThanOrEqual(minDice);
        expect(roll).toBeLessThanOrEqual(maxD6);
    });

    describe('fromObject', () => {
        it('should copy object correctly', () => {
            const copiedPlayer = Player.fromObject(obj);
            expect(copiedPlayer).toEqual(obj);
            expect(copiedPlayer.inventory).toEqual(obj.inventory);
        });

        it('should copy complex properties correctly', () => {
            const testPlayer = new Player('TestPlayer', 'irina', BonusType.Health, BonusType.Defense);
            testPlayer.id = 'test-id';
            testPlayer.spawnPoint = { x: 5, y: 10 };
            testPlayer.color = 'red';
            testPlayer.orientation = 'up';
            testPlayer.animationState = 'moving';
            testPlayer.fightsWon = 3;

            const copiedPlayer = Player.fromObject(testPlayer);

            expect(copiedPlayer.id).toBe(testPlayer.id);
            expect(copiedPlayer.name).toBe(testPlayer.name);
            expect(copiedPlayer.avatar).toBe(testPlayer.avatar);
            expect(copiedPlayer.spawnPoint).toEqual(testPlayer.spawnPoint);
            expect(copiedPlayer.color).toBe(testPlayer.color);
            expect(copiedPlayer.orientation).toBe(testPlayer.orientation);
            expect(copiedPlayer.animationState).toBe(testPlayer.animationState);
            expect(copiedPlayer.stats).toEqual(testPlayer.stats);
            expect(copiedPlayer.fightsWon).toBe(0);
        });
    });

    it('should set orientation correctly', () => {
        player.setOrientation('up');
        expect(player.orientation).toBe('up');
    });

    it('should set state correctly', () => {
        player.setState('moving');
        expect(player.animationState).toBe('moving');
    });

    it('should check if player is alive', () => {
        expect(player.isAlive()).toBeTrue();
        player.stats.health.value = 0;
        expect(player.isAlive()).toBeFalse();
    });

    it('should set stat value correctly', () => {
        player.setStatValue(BonusType.Attack, ATTACK_VALUE);
        expect(player.stats.attack.value).toBe(ATTACK_VALUE);
    });

    describe('rollStat', () => {
        it('should roll 6 sides dice correctly for d6Choice stat', () => {
            player.d6Choice = BonusType.Attack;
            const roll = player.rollStat(BonusType.Attack);
            expect(roll).toBeGreaterThanOrEqual(minDice + defaultValue);
            expect(roll).toBeLessThanOrEqual(maxD6 + defaultValue);
        });

        it('should roll 4 sides dice correctly for d4Choice stat', () => {
            player.d4Choice = BonusType.Attack;
            player.d6Choice = BonusType.Defense;
            const roll = player.rollStat(BonusType.Attack);
            expect(roll).toBeGreaterThanOrEqual(minDice + defaultValue);
            expect(roll).toBeLessThanOrEqual(maxD4 + defaultValue);
        });

        it('should apply malus when on ice tile', () => {
            player.d6Choice = BonusType.Attack;
            const tile = new Tile('ice');
            const cell = new Cell(tile, 0, 0);
            player.addCell(cell);
            const roll = player.rollStat(BonusType.Attack);
            expect(roll).toBeGreaterThanOrEqual(minDice + defaultValue - malus);
            expect(roll).toBeLessThanOrEqual(maxD6 + defaultValue - malus);
        });

        it('should not apply malus when not on ice tile', () => {
            player.d6Choice = BonusType.Attack;
            const tile = new Tile('snow');
            const cell = new Cell(tile, 0, 0);
            player.addCell(cell);
            const roll = player.rollStat(BonusType.Attack);
            expect(roll).toBeGreaterThanOrEqual(minDice + defaultValue);
            expect(roll).toBeLessThanOrEqual(maxD6 + defaultValue);
        });
    });

    describe('rollStatDebug', () => {
        it('should return max value for d6Choice attack in debug mode', () => {
            player.d6Choice = BonusType.Attack;
            const result = player.rollStatDebug(BonusType.Attack);
            expect(result).toBe(D6_VALUE + defaultValue);
        });

        it('should return max value for d4Choice attack in debug mode', () => {
            player.d4Choice = BonusType.Attack;
            player.d6Choice = BonusType.Defense;
            const result = player.rollStatDebug(BonusType.Attack);
            expect(result).toBe(D4_VALUE + defaultValue);
        });

        it('should return 1 + stat value for d6Choice defense in debug mode', () => {
            player.d6Choice = BonusType.Defense;
            const result = player.rollStatDebug(BonusType.Defense);
            expect(result).toBe(1 + defaultValue);
        });

        it('should return 1 + stat value for d4Choice defense in debug mode', () => {
            player.d4Choice = BonusType.Defense;
            player.d6Choice = BonusType.Attack;
            const result = player.rollStatDebug(BonusType.Defense);
            expect(result).toBe(1 + defaultValue);
        });

        it('should apply malus when on ice tile in debug mode', () => {
            player.d6Choice = BonusType.Attack;
            const tile = new Tile('ice');
            const cell = new Cell(tile, 0, 0);
            player.addCell(cell);
            const result = player.rollStatDebug(BonusType.Attack);
            expect(result).toBe(D6_VALUE + defaultValue - malus);
        });

        it('should return 0 for stats other than attack and defense', () => {
            const result = player.rollStatDebug(BonusType.Speed);
            expect(result).toBe(0);
        });
    });

    it('should increment fightsWon when a player wins a fight', () => {
        expect(player.fightsWon).toBe(0);
        player.fightsWon++;
        expect(player.fightsWon).toBe(1);
    });
});

/* eslint-disable @typescript-eslint/no-magic-numbers */
/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable max-lines */
import { BonusType, Player } from '@app/interfaces/player';
import { DiceService } from './dice.service';

describe('DiceService', () => {
    let service: DiceService;

    beforeEach(async () => {
        service = new DiceService();
    });

    describe('generateDiceValue', () => {
        it('should return a value between 1 and the dice number (inclusive)', () => {
            const diceNumber = 6;
            const result = service.generateDiceValue(diceNumber);

            expect(result).toBeGreaterThanOrEqual(1);
            expect(result).toBeLessThanOrEqual(diceNumber);
        });

        it('should return different values on multiple calls', () => {
            const diceNumber = 6;
            const results = new Set();

            // Call multiple times to ensure randomness
            for (let i = 0; i < 100; i++) {
                results.add(service.generateDiceValue(diceNumber));
            }

            // Should have generated at least some different values
            expect(results.size).toBeGreaterThan(1);
        });
    });

    describe('rollStat', () => {
        let mockPlayer: Player;

        beforeEach(() => {
            mockPlayer = {
                id: 'player1',
                stats: {
                    attack: { value: 10, maxValue: 20, description: 'Attack stat' },
                    defense: { value: 5, maxValue: 15, description: 'Defense stat' },
                    health: { value: 100, maxValue: 100, description: 'Health stat' },
                    speed: { value: 8, maxValue: 12, description: 'Speed stat' },
                },
                d6Choice: BonusType.Attack,
                d4Choice: BonusType.Defense,
            };
        });

        it('should use D6 when stat matches d6Choice and no tile malus', () => {
            const currentTileType = 'grass';
            const stat = BonusType.Attack;

            jest.spyOn(Math, 'random').mockReturnValue(0.5);

            const result = service.rollStat(mockPlayer, stat, currentTileType);

            // D6 roll: floor(0.5 * 6) + 1 = 3 + 1 = 4
            // Plus stat value: 4 + 10 = 14
            // No malus since tile is not 'ice'
            expect(result).toBe(14);

            jest.restoreAllMocks();
        });

        it('should use D4 when stat matches d4Choice and no tile malus', () => {
            const currentTileType = 'grass';
            const stat = BonusType.Defense;

            jest.spyOn(Math, 'random').mockReturnValue(0.5);

            const result = service.rollStat(mockPlayer, stat, currentTileType);

            // D4 roll: floor(0.5 * 4) + 1 = 2 + 1 = 3
            // Plus stat value: 3 + 5 = 8
            // No malus since tile is not 'ice'
            expect(result).toBe(8);

            jest.restoreAllMocks();
        });

        it('should use D4 when stat does not match any choice and no tile malus', () => {
            const currentTileType = 'grass';
            const stat = BonusType.Health;

            jest.spyOn(Math, 'random').mockReturnValue(0.5);

            const result = service.rollStat(mockPlayer, stat, currentTileType);

            // D4 roll: floor(0.5 * 4) + 1 = 2 + 1 = 3
            // Plus stat value: 3 + 100 = 103
            // No malus since tile is not 'ice'
            expect(result).toBe(103);

            jest.restoreAllMocks();
        });

        it('should apply ice tile malus for all stats', () => {
            const currentTileType = 'ice';
            const stat = BonusType.Attack;

            jest.spyOn(Math, 'random').mockReturnValue(0.5);

            const result = service.rollStat(mockPlayer, stat, currentTileType);

            // D6 roll: floor(0.5 * 6) + 1 = 3 + 1 = 4
            // Plus stat value: 4 + 10 = 14
            // Ice malus: 14 - 2 = 12
            expect(result).toBe(12);

            jest.restoreAllMocks();
        });

        it('should apply ice tile malus for D4 rolls', () => {
            const currentTileType = 'ice';
            const stat = BonusType.Health;

            jest.spyOn(Math, 'random').mockReturnValue(0.5);

            const result = service.rollStat(mockPlayer, stat, currentTileType);

            // D4 roll: floor(0.5 * 4) + 1 = 2 + 1 = 3
            // Plus stat value: 3 + 100 = 103
            // Ice malus: 103 - 2 = 101
            expect(result).toBe(101);

            jest.restoreAllMocks();
        });

        it('should handle edge case with Math.random returning 0', () => {
            const currentTileType = 'grass';
            const stat = BonusType.Attack;

            jest.spyOn(Math, 'random').mockReturnValue(0);

            const result = service.rollStat(mockPlayer, stat, currentTileType);

            // D6 roll: floor(0 * 6) + 1 = 0 + 1 = 1
            // Plus stat value: 1 + 10 = 11
            expect(result).toBe(11);

            jest.restoreAllMocks();
        });

        it('should handle edge case with Math.random returning value just below 1', () => {
            const currentTileType = 'grass';
            const stat = BonusType.Attack;

            jest.spyOn(Math, 'random').mockReturnValue(0.999);

            const result = service.rollStat(mockPlayer, stat, currentTileType);

            // D6 roll: floor(0.999 * 6) + 1 = 5 + 1 = 6
            // Plus stat value: 6 + 10 = 16
            expect(result).toBe(16);

            jest.restoreAllMocks();
        });
    });

    describe('rollStatDebug', () => {
        let mockPlayer: Player;

        beforeEach(() => {
            mockPlayer = {
                id: 'player1',
                stats: {
                    attack: { value: 10, maxValue: 20, description: 'Attack stat' },
                    defense: { value: 5, maxValue: 15, description: 'Defense stat' },
                    health: { value: 100, maxValue: 100, description: 'Health stat' },
                    speed: { value: 8, maxValue: 12, description: 'Speed stat' },
                },
                d6Choice: BonusType.Attack,
                d4Choice: BonusType.Defense,
            };
        });

        it('should return max D6 value for attack stat when stat matches d6Choice', () => {
            const currentTileType = 'grass';
            const stat = BonusType.Attack;

            const result = service.rollStatDebug(mockPlayer, stat, currentTileType);

            // D6 max value + stat value - no malus = 6 + 10 = 16
            expect(result).toBe(16);
        });

        it('should return max D4 value for attack stat when stat matches d4Choice', () => {
            const currentTileType = 'grass';
            const stat = BonusType.Attack;

            // Change d6Choice to something else so attack uses d4Choice
            mockPlayer.d6Choice = BonusType.Health;
            mockPlayer.d4Choice = BonusType.Attack;

            const result = service.rollStatDebug(mockPlayer, stat, currentTileType);

            // D4 max value + stat value - no malus = 4 + 10 = 14
            expect(result).toBe(14);
        });

        it('should return min D6 value for defense stat when stat matches d6Choice', () => {
            const currentTileType = 'grass';
            const stat = BonusType.Defense;

            // Change d6Choice to defense
            mockPlayer.d6Choice = BonusType.Defense;

            const result = service.rollStatDebug(mockPlayer, stat, currentTileType);

            // D6 min value + stat value - no malus = 1 + 5 = 6
            expect(result).toBe(6);
        });

        it('should return min D4 value for defense stat when stat matches d4Choice', () => {
            const currentTileType = 'grass';
            const stat = BonusType.Defense;

            const result = service.rollStatDebug(mockPlayer, stat, currentTileType);

            // D4 min value + stat value - no malus = 1 + 5 = 6
            expect(result).toBe(6);
        });

        it('should apply ice tile malus for debug rolls', () => {
            const currentTileType = 'ice';
            const stat = BonusType.Attack;

            const result = service.rollStatDebug(mockPlayer, stat, currentTileType);

            // D6 max value + stat value - ice malus = 6 + 10 - 2 = 14
            expect(result).toBe(14);
        });

        it('should return 0 for non-attack and non-defense stats', () => {
            const currentTileType = 'grass';
            const stat = BonusType.Health;

            const result = service.rollStatDebug(mockPlayer, stat, currentTileType);

            expect(result).toBe(0);
        });

        it('should return 0 for non-attack and non-defense stats even with ice tile', () => {
            const currentTileType = 'ice';
            const stat = BonusType.Health;

            const result = service.rollStatDebug(mockPlayer, stat, currentTileType);

            expect(result).toBe(0);
        });

        it('should return 0 when d6Choice and d4Choice are not set for attack/defense', () => {
            const currentTileType = 'grass';
            const stat = BonusType.Attack;

            // Remove choices
            mockPlayer.d6Choice = undefined;
            mockPlayer.d4Choice = undefined;

            const result = service.rollStatDebug(mockPlayer, stat, currentTileType);

            expect(result).toBe(0);
        });

        it('should return 0 when d6Choice and d4Choice are set to different stats for attack', () => {
            const currentTileType = 'grass';
            const stat = BonusType.Attack;

            // Set choices to other stats
            mockPlayer.d6Choice = BonusType.Health;
            mockPlayer.d4Choice = BonusType.Speed;

            const result = service.rollStatDebug(mockPlayer, stat, currentTileType);

            expect(result).toBe(0);
        });
    });
});

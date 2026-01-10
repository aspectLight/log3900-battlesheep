/* eslint-disable max-lines */
/* eslint-disable @typescript-eslint/no-magic-numbers */
/* eslint-disable @typescript-eslint/no-explicit-any */
import { BonusType } from '@app/constants/bonus.constants';
import {
    AVATAR_TYPES,
    D4_VALUE,
    D6_VALUE,
    DEFAULT_ACTION_POINTS,
    DEFAULT_MOVEMENT_POINTS,
    PROPAGANDA_HEALTH_THRESHOLD,
    PROPAGANDA_ATTACK_THRESHOLD,
} from '@app/constants/player.constants';
import { PROPAGANDA_ATTACK_BOOST, PROPAGANDA_DEFENSE_BOOST } from '@app/constants/item.constants';
import { Cell } from './cell';
import { Player } from './player';
import { Tile } from './tile';
import { Item } from './item';

const ATTACK_VALUE = 6;

describe('Player', () => {
    let player: Player;
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
        expect(defaultPlayer.d6Choice).toBeNull();
        expect(defaultPlayer.d4Choice).toBe(BonusType.Attack);
        expect(defaultPlayer.inventory).toEqual([null, null]);
        expect(defaultPlayer.orientation).toBe('down');
        expect(defaultPlayer.animationState).toBe('idle');
        expect(defaultPlayer.fightsWon).toBe(0);
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
            testPlayer.team = 1;

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

    it('should update item effects when setting stat value', () => {
        // Add propaganda to the inventory
        const propaganda = new Item('propaganda');
        player.inventory[0] = propaganda;
        (player as any).appliedItemEffects = {};

        // Spy on the updatePropagandaEffects method
        spyOn(player, 'updatePropagandaEffects').and.callThrough();

        // Set a health stat to trigger propaganda effect update
        player.setStatValue(BonusType.Health, 3);

        // Check that updatePropagandaEffects was called
        expect(player.updatePropagandaEffects).toHaveBeenCalledTimes(1);
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

    describe('addItem', () => {
        it('should add an item to the first empty slot', () => {
            const item = new Item('adrenaline');
            const result = player.addItem(item);
            expect(result).toBeTrue();
            expect(player.inventory[0]).toBe(item);
            expect(player.inventory[1]).toBeNull();
        });

        it('should add an item to the second slot when first is occupied', () => {
            const firstItem = new Item('vodka');
            const secondItem = new Item('propaganda');
            player.addItem(firstItem);
            const result = player.addItem(secondItem);
            expect(result).toBeTrue();
            expect(player.inventory[0]).toBe(firstItem);
            expect(player.inventory[1]).toBe(secondItem);
        });

        it('should return inventory when both slots are full', () => {
            const firstItem = new Item('vodka');
            const secondItem = new Item('propaganda');
            player.addItem(firstItem);
            player.addItem(secondItem);
            const thirdItem = new Item('adrenaline');
            const result = player.addItem(thirdItem);
            expect(result).toEqual([firstItem, secondItem]);
            expect(player.inventory[0]).toBe(firstItem);
            expect(player.inventory[1]).toBe(secondItem);
        });
    });

    describe('replaceItem', () => {
        it('should call onReplaceItem callback with correct parameters', () => {
            const newItem = new Item('vodka');
            const coords = { x: 1, y: 2 };
            let callbackCalled = false;
            let callbackParams: any = null;

            player.onReplaceItem = (item, inventory, cellCoords) => {
                callbackCalled = true;
                callbackParams = { item, inventory, cellCoords };
            };

            player.replaceItem(newItem, coords);

            expect(callbackCalled).toBeTrue();
            expect(callbackParams.item).toBe(newItem);
            expect(callbackParams.inventory).toEqual([null, null]);
            expect(callbackParams.cellCoords).toEqual(coords);
        });

        it('should not call onReplaceItem if callback is not set', () => {
            const newItem = new Item('vodka');
            const coords = { x: 1, y: 2 };
            player.onReplaceItem = undefined;
            expect(() => player.replaceItem(newItem, coords)).not.toThrow();
        });
    });

    describe('updateItemsEffect', () => {
        it('should update effects of all items in inventory with given multiplier', () => {
            const adrenaline = new Item('adrenaline');
            const vodka = new Item('vodka');

            // Reset the player's stats to have predictable values
            player.stats.health.value = 6; // Default value (4) + bonus (2)
            player.stats.attack.value = 4; // Default value
            player.stats.speed.value = 4; // Default value

            // First add the items without effects - we'll simulate that the player already has items
            // but the effects haven't been applied yet (like what happens after loading a saved game)
            player.inventory[0] = adrenaline;
            player.inventory[1] = vodka;

            // Clear the effect tracking to simulate a fresh state
            (player as any).appliedItemEffects = {};

            // Now apply effects with multiplier 2
            player.updateItemsEffect(2);

            // With the new implementation, effects should be applied with the multiplier
            expect(player.stats.health.value).toBe(10); // 6 (initial) + (2 * 2) from adrenaline
            expect(player.stats.attack.value).toBe(8); // 4 (initial) + (2 * 2) from vodka
            expect(player.stats.speed.value).toBe(2); // 4 (initial) - (1 * 2) from vodka
        });

        it('should handle empty inventory', () => {
            expect(() => player.updateItemsEffect(1)).not.toThrow();
            expect(player.stats.health.value).toBe(6); // Default value (4) + bonus (2)
            expect(player.stats.attack.value).toBe(4); // Default value
            expect(player.stats.speed.value).toBe(4); // Default value
        });

        it('should handle inventory with null slots', () => {
            player.inventory = [null, null];
            expect(() => player.updateItemsEffect(1)).not.toThrow();
            expect(player.stats.health.value).toBe(6); // Default value (4) + bonus (2)
            expect(player.stats.attack.value).toBe(4); // Default value
            expect(player.stats.speed.value).toBe(4); // Default value
        });

        it('should handle null items in inventory', () => {
            // Create spies on the application and removal methods
            spyOn(player as any, 'updateItemEffects');

            // Set up inventory with a null item
            const vodka = new Item('vodka');
            player.inventory = [null, vodka];
            (player as any).appliedItemEffects = {};

            player.updateItemsEffect(1);

            // Verify updateItemEffects was only called for the non-null item
            expect((player as any).updateItemEffects).toHaveBeenCalledTimes(1);
            expect((player as any).updateItemEffects).toHaveBeenCalledWith(player.inventory[1], 1);
        });

        describe('propaganda item effects', () => {
            it('should boost attack and defense when health is below threshold', () => {
                const propaganda = new Item('propaganda');
                player.addItem(propaganda);

                // Set health below threshold
                player.stats.health.value = PROPAGANDA_HEALTH_THRESHOLD - 1;

                const initialAttack = player.stats.attack.value;
                const initialDefense = player.stats.defense.value;

                player.updateItemsEffect(1);

                expect(player.stats.attack.value).toBe(initialAttack + PROPAGANDA_ATTACK_BOOST);
                expect(player.stats.defense.value).toBe(initialDefense + PROPAGANDA_DEFENSE_BOOST);
            });

            it('should not boost stats when health is at or above threshold', () => {
                const propaganda = new Item('propaganda');
                player.addItem(propaganda);

                // Set health at threshold
                player.stats.health.value = PROPAGANDA_HEALTH_THRESHOLD;

                const initialAttack = player.stats.attack.value;
                const initialDefense = player.stats.defense.value;

                player.updateItemsEffect(1);

                expect(player.stats.attack.value).toBe(initialAttack);
                expect(player.stats.defense.value).toBe(initialDefense);
            });

            it('should reduce attack and defense when attack is above threshold', () => {
                const propaganda = new Item('propaganda');

                // First set health above threshold so propagana boost doesn't apply
                player.stats.health.value = PROPAGANDA_HEALTH_THRESHOLD + 1;

                // Then set attack above threshold to test decrease effect
                player.stats.attack.value = PROPAGANDA_ATTACK_THRESHOLD + 1;
                player.stats.defense.value = 5; // Some value above default

                // Add the item directly to inventory to bypass normal effect application
                player.inventory[0] = propaganda;
                (player as any).appliedItemEffects = {};

                // We need to modify implementation for test to make propaganda think its effects are active
                // This simulates a case where propaganda effects were already applied
                (player as any).appliedItemEffects[propaganda.id] = true;

                // Now remove the effects by using multiplier -1
                player.updateItemsEffect(-1);

                // The stats should be decreased by the propaganda boost values
                expect(player.stats.attack.value).toBe(PROPAGANDA_ATTACK_THRESHOLD + 1 - PROPAGANDA_ATTACK_BOOST);
                expect(player.stats.defense.value).toBe(5 - PROPAGANDA_DEFENSE_BOOST);
            });

            it('should apply multiplier correctly when health is below threshold', () => {
                const propaganda = new Item('propaganda');

                // Set health below threshold
                player.stats.health.value = PROPAGANDA_HEALTH_THRESHOLD - 1;

                // Reset attack and defense
                player.stats.attack.value = 4;
                player.stats.defense.value = 4;

                // Add the item directly to inventory
                player.inventory[0] = propaganda;
                (player as any).appliedItemEffects = {};

                // Now apply effects with multiplier 2
                player.updateItemsEffect(2);

                // The stats should be increased by twice the propaganda boost values
                expect(player.stats.attack.value).toBe(4 + PROPAGANDA_ATTACK_BOOST * 2);
                expect(player.stats.defense.value).toBe(4 + PROPAGANDA_DEFENSE_BOOST * 2);
            });
        });

        describe('camouflage item effects', () => {
            it('should not modify stats when camouflage is added', () => {
                const camouflage = new Item('camouflage');
                player.addItem(camouflage);

                const initialHealth = player.stats.health.value;
                const initialAttack = player.stats.attack.value;
                const initialDefense = player.stats.defense.value;
                const initialSpeed = player.stats.speed.value;

                player.updateItemsEffect(1);

                expect(player.stats.health.value).toBe(initialHealth);
                expect(player.stats.attack.value).toBe(initialAttack);
                expect(player.stats.defense.value).toBe(initialDefense);
                expect(player.stats.speed.value).toBe(initialSpeed);
            });

            it('should be detectable via findItem method', () => {
                const camouflage = new Item('camouflage');
                player.addItem(camouflage);

                expect(player.hasItem('camouflage')).toBeTrue();
            });
        });

        describe('waterproofBoots item effects', () => {
            it('should not modify stats when waterproofBoots is added', () => {
                const boots = new Item('waterproofBoots');
                player.addItem(boots);

                const initialHealth = player.stats.health.value;
                const initialAttack = player.stats.attack.value;
                const initialDefense = player.stats.defense.value;
                const initialSpeed = player.stats.speed.value;

                player.updateItemsEffect(1);

                expect(player.stats.health.value).toBe(initialHealth);
                expect(player.stats.attack.value).toBe(initialAttack);
                expect(player.stats.defense.value).toBe(initialDefense);
                expect(player.stats.speed.value).toBe(initialSpeed);
            });

            it('should be detectable via findItem method', () => {
                const boots = new Item('waterproofBoots');
                player.addItem(boots);

                expect(player.hasItem('waterproofBoots')).toBeTrue();
            });
        });

        describe('airStrike item effects', () => {
            it('should not modify stats when airStrike is added', () => {
                const airStrike = new Item('airStrike');
                player.addItem(airStrike);

                const initialHealth = player.stats.health.value;
                const initialAttack = player.stats.attack.value;
                const initialDefense = player.stats.defense.value;
                const initialSpeed = player.stats.speed.value;

                player.updateItemsEffect(1);

                expect(player.stats.health.value).toBe(initialHealth);
                expect(player.stats.attack.value).toBe(initialAttack);
                expect(player.stats.defense.value).toBe(initialDefense);
                expect(player.stats.speed.value).toBe(initialSpeed);
            });

            it('should be detectable via findItem method', () => {
                const airStrike = new Item('airStrike');
                player.addItem(airStrike);

                expect(player.hasItem('airStrike')).toBeTrue();
            });
        });
    });

    describe('hasItem', () => {
        it('should return true when player has the specified item type', () => {
            const item = new Item('vodka');
            player.addItem(item);
            expect(player.hasItem('vodka')).toBeTrue();
        });

        it('should return false when player does not have the specified item type', () => {
            const item = new Item('vodka');
            player.addItem(item);
            expect(player.hasItem('adrenaline')).toBeFalse();
        });

        it('should return false when inventory is empty', () => {
            expect(player.hasItem('vodka')).toBeFalse();
            expect(player.hasItem('adrenaline')).toBeFalse();
            expect(player.hasItem('propaganda')).toBeFalse();
        });

        it('should return false when inventory has null slots', () => {
            player.inventory = [null, null];
            expect(player.hasItem('vodka')).toBeFalse();
        });

        it('should return true when item is in first slot', () => {
            const item = new Item('vodka');
            player.addItem(item);
            expect(player.hasItem('vodka')).toBeTrue();
        });

        it('should return true when item is in second slot', () => {
            const firstItem = new Item('adrenaline');
            const secondItem = new Item('vodka');
            player.addItem(firstItem);
            player.addItem(secondItem);
            expect(player.hasItem('vodka')).toBeTrue();
        });
    });

    describe('clearInfo', () => {
        it('should reset all player stats and properties to default values', () => {
            // Set up initial values
            player.stats[BonusType.Health].value = 10;
            player.stats[BonusType.Speed].value = 8;
            player.stats[BonusType.Attack].value = 6;
            player.stats[BonusType.Defense].value = 5;
            player.actionPoints = 10;
            player.movementPoints = 8;
            player.inventory = [new Item('vodka'), new Item('propaganda')];
            player.d4Choice = BonusType.Attack;
            player.d6Choice = BonusType.Defense;
            player.avatar = AVATAR_TYPES['irina'];

            // Call clearInfo
            player.clearInfo();

            // Verify all values are reset to defaults
            expect(player.stats[BonusType.Health].value).toBe(4);
            expect(player.stats[BonusType.Speed].value).toBe(4);
            expect(player.stats[BonusType.Attack].value).toBe(4);
            expect(player.stats[BonusType.Defense].value).toBe(4);
            expect(player.actionPoints).toBe(DEFAULT_ACTION_POINTS);
            expect(player.movementPoints).toBe(DEFAULT_MOVEMENT_POINTS);
            expect(player.inventory).toEqual([null, null]);
            expect(player.d6Choice).toBeNull();
            expect(player.avatar).toBeNull();
        });
    });

    describe('clearAllItemEffects', () => {
        it('should remove effects from all applied items in inventory', () => {
            // Set up items with effects applied
            const vodka = new Item('vodka');
            const adrenaline = new Item('adrenaline');
            player.inventory = [vodka, adrenaline];

            // Set up initial stat values
            player.stats[BonusType.Attack].value = 6; // Base 4 + 2 from vodka
            player.stats[BonusType.Speed].value = 3; // Base 4 - 1 from vodka
            player.stats[BonusType.Health].value = 8; // Base 4 + 2 bonus + 2 from adrenaline

            // Mark effects as applied
            (player as any).appliedItemEffects = {
                [vodka.id]: true,
                [adrenaline.id]: true,
            };

            // Spy on removeItemEffect to verify it's called for each item
            spyOn(player, 'removeItemEffect').and.callThrough();

            // Call the method
            player.clearAllItemEffects();

            // Verify removeItemEffect was called for each item
            expect(player.removeItemEffect).toHaveBeenCalledTimes(2);
            expect(player.removeItemEffect).toHaveBeenCalledWith(vodka);
            expect(player.removeItemEffect).toHaveBeenCalledWith(adrenaline);

            // Verify the applied effects tracking is cleared
            expect((player as any).appliedItemEffects).toEqual({});
        });

        it('should only remove effects for items that have applied effects', () => {
            // Set up items but only mark one as having applied effects
            const vodka = new Item('vodka');
            const adrenaline = new Item('adrenaline');
            player.inventory = [vodka, adrenaline];

            // Only mark vodka as having applied effects
            (player as any).appliedItemEffects = {
                [vodka.id]: true,
            };

            // Spy on removeItemEffect
            spyOn(player, 'removeItemEffect').and.callThrough();

            // Call the method
            player.clearAllItemEffects();

            // Verify removeItemEffect was only called for vodka
            expect(player.removeItemEffect).toHaveBeenCalledTimes(1);
            expect(player.removeItemEffect).toHaveBeenCalledWith(vodka);
            expect(player.removeItemEffect).not.toHaveBeenCalledWith(adrenaline);
        });

        it('should handle inventory with null slots', () => {
            // Set up inventory with null slots
            const vodka = new Item('vodka');
            player.inventory = [null, vodka];

            // Mark vodka as having applied effects
            (player as any).appliedItemEffects = {
                [vodka.id]: true,
            };

            // Spy on removeItemEffect
            spyOn(player, 'removeItemEffect').and.callThrough();

            // Call the method
            player.clearAllItemEffects();

            // Verify removeItemEffect was only called for non-null items
            expect(player.removeItemEffect).toHaveBeenCalledTimes(1);
            expect(player.removeItemEffect).toHaveBeenCalledWith(vodka);
        });

        it('should handle empty appliedItemEffects tracking', () => {
            // Set up items but no applied effects
            const vodka = new Item('vodka');
            const adrenaline = new Item('adrenaline');
            player.inventory = [vodka, adrenaline];

            // No applied effects
            (player as any).appliedItemEffects = {};

            // Spy on removeItemEffect
            spyOn(player, 'removeItemEffect').and.callThrough();

            // Call the method
            player.clearAllItemEffects();

            // Verify removeItemEffect was not called
            expect(player.removeItemEffect).not.toHaveBeenCalled();
        });
    });

    describe('removeItemEffect', () => {
        it('should remove effects for an item that has applied effects', () => {
            const vodka = new Item('vodka');
            player.inventory = [vodka, null];

            // Set up initial stat values
            player.stats[BonusType.Attack].value = 6; // Base 4 + 2 from vodka
            player.stats[BonusType.Speed].value = 3; // Base 4 - 1 from vodka

            // Mark effects as applied
            (player as any).appliedItemEffects = {
                [vodka.id]: true,
            };

            // Spy on updateItemEffects
            spyOn(player as any, 'updateItemEffects').and.callThrough();

            // Call the method
            player.removeItemEffect(vodka);

            // Verify updateItemEffects was called with negative multiplier
            expect((player as any).updateItemEffects).toHaveBeenCalledWith(vodka, -1);

            // Verify the effect tracking was updated
            expect((player as any).appliedItemEffects[vodka.id]).toBeUndefined();

            // Verify stats were updated
            expect(player.stats[BonusType.Attack].value).toBe(4); // 6 - 2
            expect(player.stats[BonusType.Speed].value).toBe(4); // 3 + 1
        });

        it('should not remove effects for an item that does not have applied effects', () => {
            const vodka = new Item('vodka');
            player.inventory = [vodka, null];

            // No applied effects
            (player as any).appliedItemEffects = {};

            // Spy on updateItemEffects
            spyOn(player as any, 'updateItemEffects').and.callThrough();

            // Call the method
            player.removeItemEffect(vodka);

            // Verify updateItemEffects was not called
            expect((player as any).updateItemEffects).not.toHaveBeenCalled();
        });
    });
});

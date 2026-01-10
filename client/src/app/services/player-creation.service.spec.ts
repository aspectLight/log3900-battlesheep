import { TestBed } from '@angular/core/testing';
import { PlayerCreationService } from './player-creation.service';
import { AVATAR_TYPES, BONUS_VALUE, D4_VALUE, DEFAULT_STATS_VALUE } from '@app/constants/player.constants';
import { Bonus } from '@app/interfaces/character';
import { Player } from '@app/classes/player';
import { BonusType } from '@app/constants/bonus.constants';

describe('PlayerCreationService', () => {
    let service: PlayerCreationService;

    beforeEach(() => {
        TestBed.configureTestingModule({
            providers: [PlayerCreationService],
        });
        service = TestBed.inject(PlayerCreationService);
    });

    it('should be created', () => {
        expect(service).toBeTruthy();
    });

    describe('selectedCharacter', () => {
        it('should return the default character initially', () => {
            const character = service.selectedCharacter;
            expect(character.character.name).toBe('');
            expect(character.character.id).toBe(0);
        });

        it('should update selectedCharacter when set', () => {
            const chosenCharacter = { name: 'Viktor', id: 1 };
            service.selectedCharacter = chosenCharacter;

            expect(service.selectedCharacter.character).toEqual(AVATAR_TYPES['viktor']);
        });
    });

    describe('selectedBonus', () => {
        it('should update the bonus when set', () => {
            const bonus: Bonus = {
                life: DEFAULT_STATS_VALUE + BONUS_VALUE,
                speed: DEFAULT_STATS_VALUE,
                defense: DEFAULT_STATS_VALUE + BONUS_VALUE,
                attack: DEFAULT_STATS_VALUE,
            };

            service.selectedBonus = bonus;

            expect(service.selectedCharacter.bonus).toEqual(bonus);
        });
    });

    describe('createPlayer', () => {
        it('should return null if character is not valid', () => {
            // Empty name
            const result = service.createPlayer('');
            expect(result).toBeNull();
        });

        it('should return null if bonus is not selected properly', () => {
            // Default bonus values (no selection made)
            const result = service.createPlayer('John Doe');
            expect(result).toBeNull();
        });

        it('should create a player with health bonus when life is increased', () => {
            // Set character
            service.selectedCharacter = { name: 'Viktor', id: 1 };

            // Set bonus with increased life
            service.selectedBonus = {
                life: DEFAULT_STATS_VALUE + BONUS_VALUE,
                speed: DEFAULT_STATS_VALUE,
                defense: D4_VALUE + BONUS_VALUE,
                attack: DEFAULT_STATS_VALUE,
            };

            const player = service.createPlayer('John Doe');

            expect(player).not.toBeNull();
            if (player) {
                expect(player instanceof Player).toBeTrue();
                expect(player.name).toBe('John Doe');
                expect(player.avatar).not.toBeNull();
                expect(player.bonusChoice).toBe(BonusType.Health);
                expect(player.d4Choice).toBe('attack');
            }
        });

        it('should create a player with speed bonus when speed is increased', () => {
            // Set character
            service.selectedCharacter = { name: 'Viktor', id: 1 };

            // Set bonus with increased speed
            service.selectedBonus = {
                life: DEFAULT_STATS_VALUE,
                speed: DEFAULT_STATS_VALUE + BONUS_VALUE,
                defense: DEFAULT_STATS_VALUE,
                attack: D4_VALUE + BONUS_VALUE,
            };

            const player = service.createPlayer('John Doe');

            expect(player).not.toBeNull();
            if (player) {
                expect(player instanceof Player).toBeTrue();
                expect(player.name).toBe('John Doe');
                expect(player.avatar).not.toBeNull();
                expect(player.bonusChoice).toBe(BonusType.Speed);
                expect(player.d4Choice).toBe('defense');
            }
        });

        it('should return the created player through the player getter', () => {
            // Set character
            service.selectedCharacter = { name: 'Viktor', id: 1 };

            // Set bonus
            service.selectedBonus = {
                life: DEFAULT_STATS_VALUE + BONUS_VALUE,
                speed: DEFAULT_STATS_VALUE,
                defense: D4_VALUE + BONUS_VALUE,
                attack: DEFAULT_STATS_VALUE,
            };

            const player = service.createPlayer('John Doe');

            expect(service.player).toBe(player);
        });
    });

    describe('gameModified flag', () => {
        it('should be false by default', () => {
            expect(service.gameModified).toBeFalse();
        });
    });
});

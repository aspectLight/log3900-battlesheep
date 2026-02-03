import { Injectable } from '@angular/core';
import { Player } from '@app/classes/entity/player';
import { BonusType } from '@app/constants/bonus.constants';
import { AVATAR_TYPES, BONUS_VALUE, D4_VALUE, DEFAULT_STATS_VALUE } from '@app/constants/player.constants';
import { Bonus, Character } from '@app/interfaces/character.interface';
import { AuthService } from '@app/services/communication/auth.service';

@Injectable({
    providedIn: 'root',
})
export class PlayerCreationService {
    gameModified: boolean = false;

    private _selectedCharacter: Character = this.defaultCharacter();
    private _player: Player;

    constructor(private readonly authService: AuthService) {}

    get selectedCharacter(): Character {
        return this._selectedCharacter;
    }

    get player(): Player | null {
        return this._player;
    }

    set selectedCharacter(chosenCharacter: { name: string; id: number }) {
        this._selectedCharacter = {
            character: AVATAR_TYPES[chosenCharacter.name.toLowerCase()],
            bonus: this.defaultBonuses(),
        };
    }

    set selectedBonus(chosenBonus: Bonus) {
        this._selectedCharacter.bonus = chosenBonus;
    }

    createPlayer(playerName: string): Player | null {
        if (!this.isCharacterValid(playerName)) return null;
        this._player = this.buildNewPlayer(playerName);
        if (this.authService.currentUser?.uid) {
            this._player.firebaseUid = this.authService.currentUser.uid;
        }
        return this._player;
    }

    private isCharacterValid(playerName: string): boolean {
        const bonus = this._selectedCharacter.bonus;
        return (
            playerName.trim() !== '' &&
            (bonus.life !== DEFAULT_STATS_VALUE || bonus.speed !== DEFAULT_STATS_VALUE) &&
            bonus.defense !== null &&
            bonus.attack !== null
        );
    }

    private buildNewPlayer(playerName: string): Player {
        const { character, bonus } = this._selectedCharacter;
        return new Player(
            playerName,
            character.name.toLowerCase(),
            bonus.life === DEFAULT_STATS_VALUE + BONUS_VALUE ? BonusType.Health : BonusType.Speed,
            bonus.defense === D4_VALUE + BONUS_VALUE ? BonusType.Defense : BonusType.Attack,
        );
    }

    private defaultCharacter(): Character {
        return {
            character: { name: '', id: 0, avatar: '', avatarFull: '' },
            bonus: this.defaultBonuses(),
        };
    }

    private defaultBonuses(): Bonus {
        return {
            life: DEFAULT_STATS_VALUE,
            speed: DEFAULT_STATS_VALUE,
            defense: DEFAULT_STATS_VALUE,
            attack: DEFAULT_STATS_VALUE,
        };
    }
}

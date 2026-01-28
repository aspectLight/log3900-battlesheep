import { Component, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Player } from '@app/classes/entity/player';
import { BONUS_VALUE, DEFAULT_STATS_VALUE, D4_VALUE, D6_VALUE } from '@app/constants/player.constants';
import { Bonus } from '@app/interfaces/character.interface';

@Component({
    selector: 'app-bonus-choices',
    imports: [CommonModule],
    templateUrl: './bonus-choices.component.html',
    styleUrl: './bonus-choices.component.scss',
})
export class BonusChoicesComponent {
    @Output() bonusSelected = new EventEmitter<Bonus>();

    selectedBonus: 'healthBonus' | 'speedBonus' | null = null;
    health = DEFAULT_STATS_VALUE;
    speed = DEFAULT_STATS_VALUE;
    d4Value: number = D4_VALUE;
    d6Value: number = D6_VALUE;
    attackDice: number | null = null;
    defenseDice: number | null = null;

    private actualBonus: Bonus = {
        life: DEFAULT_STATS_VALUE,
        speed: DEFAULT_STATS_VALUE,
        defense: DEFAULT_STATS_VALUE,
        attack: DEFAULT_STATS_VALUE,
    };

    private _player = new Player();
    get player() {
        return this._player;
    }

    selectBonus(bonus: 'healthBonus' | 'speedBonus'): void {
        this.selectedBonus = bonus;
        this.health = bonus === 'healthBonus' ? DEFAULT_STATS_VALUE + BONUS_VALUE : DEFAULT_STATS_VALUE;
        this.speed = bonus === 'speedBonus' ? DEFAULT_STATS_VALUE + BONUS_VALUE : DEFAULT_STATS_VALUE;
        this.updateActualBonus();
    }

    selectAttackDice(dice: number): void {
        this.attackDice = dice;
        this.defenseDice = dice === D4_VALUE ? D6_VALUE : D4_VALUE;
        this.updateActualBonus();
    }

    selectDefenseDice(dice: number): void {
        this.defenseDice = dice;
        this.attackDice = dice === D4_VALUE ? D6_VALUE : D4_VALUE;
        this.updateActualBonus();
    }

    private updateActualBonus(): void {
        this.actualBonus = {
            life: this.health,
            speed: this.speed,
            defense: this.defenseDice,
            attack: this.attackDice,
        };
        this.bonusSelected.emit(this.actualBonus);
    }
}

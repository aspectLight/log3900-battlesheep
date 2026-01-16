import { D4_VALUE, D6_VALUE } from '@app/constants/game-combat.constants';
import { BonusType, Player } from '@app/interfaces/player';
import { Injectable } from '@nestjs/common';
export type Stats = BonusType.Health | BonusType.Speed | BonusType.Attack | BonusType.Defense;
@Injectable()
export class DiceService {
    generateDiceValue(diceNumber: number) {
        return Math.floor(Math.random() * diceNumber) + 1;
    }

    rollStat(player: Player, stat: Stats, currentTileType: string): number {
        const malus = currentTileType === 'ice' ? 2 : 0;

        if (stat === player.d6Choice) {
            return this.generateDiceValue(D6_VALUE) + player.stats[stat].value - malus;
        } else {
            return this.generateDiceValue(D4_VALUE) + player.stats[stat].value - malus;
        }
    }

    rollStatDebug(player: Player, stat: Stats, currentTileType: string): number {
        const malus = currentTileType === 'ice' ? 2 : 0;

        if (stat === BonusType.Attack) {
            if (stat === player.d6Choice) return D6_VALUE + player.stats[stat].value - malus;
            if (stat === player.d4Choice) return D4_VALUE + player.stats[stat].value - malus;
        } else if (stat === BonusType.Defense) {
            if (stat === player.d6Choice) return 1 + player.stats[stat].value - malus;
            if (stat === player.d4Choice) return 1 + player.stats[stat].value - malus;
        }
        return 0;
    }
}

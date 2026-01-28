import { MovementModule } from '@app/modules/movement/movement.module';
import { SharedRoomModule } from '@app/modules/shared-room/shared-room.module';
import { DiceService } from '@app/shared/services/dice.service';
import { Module } from '@nestjs/common';
import { GameCombatService } from './services/game-combat.service';

@Module({
    imports: [SharedRoomModule, MovementModule],
    providers: [GameCombatService, DiceService],
    exports: [GameCombatService],
})
export class CombatModule {}

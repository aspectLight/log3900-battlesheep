import { GameModule } from '@app/modules/game/game.module';
import { SharedRoomModule } from '@app/modules/shared-room/shared-room.module';
import { Module } from '@nestjs/common';
import { GameMovementService } from './services/game-movement.service';
import { MovementAlgorithmsService } from './services/movement-algorithms.service';
import { TorchService } from './services/torch.service';

@Module({
    imports: [GameModule, SharedRoomModule],
    providers: [GameMovementService, MovementAlgorithmsService, TorchService],
    exports: [GameMovementService, MovementAlgorithmsService, TorchService],
})
export class MovementModule {}

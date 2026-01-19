import { MovementModule } from '@app/modules/movement/movement.module';
import { SharedRoomModule } from '@app/modules/shared-room/shared-room.module';
import { Module } from '@nestjs/common';
import { GameMovementVPService } from './services/game-movement-vp.service';

@Module({
    imports: [MovementModule, SharedRoomModule],
    providers: [GameMovementVPService],
    exports: [GameMovementVPService],
})
export class VirtualPlayersModule {}

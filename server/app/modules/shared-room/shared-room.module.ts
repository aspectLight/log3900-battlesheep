import { GameModule } from '@app/modules/game/game.module';
import { Module } from '@nestjs/common';
import { GameRoomService } from './services/game-room.service';
import { WaitingRoomService } from './services/waiting-room.service';

@Module({
    imports: [GameModule],
    providers: [GameRoomService, WaitingRoomService],
    exports: [GameRoomService, WaitingRoomService],
})
export class SharedRoomModule {}

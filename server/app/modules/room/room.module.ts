import { AuthModule } from '@app/modules/auth/auth.module';
import { CombatModule } from '@app/modules/combat/combat.module';
import { GameModule } from '@app/modules/game/game.module';
import { GeneralChatModule } from '@app/modules/general-chat/general-chat.module';
import { MovementModule } from '@app/modules/movement/movement.module';
import { SharedRoomModule } from '@app/modules/shared-room/shared-room.module';
import { VirtualPlayersModule } from '@app/modules/virtual-players/virtual-players.module';
import { Module } from '@nestjs/common';
import { GameRoomGateway } from './game-room/game-room.gateway';
import { ChatHandler } from './game-room/handlers/chat.handler';
import { CombatHandler } from './game-room/handlers/combat.handler';
import { GameLifecycleHandler } from './game-room/handlers/game-lifecycle.handler';
import { ItemsHandler } from './game-room/handlers/items.handler';
import { MovementHandler } from './game-room/handlers/movement.handler';
import { PlayerConnectionHandler } from './game-room/handlers/player-connection.handler';
import { StatisticsHandler } from './game-room/handlers/statistics.handler';
import { TrapHandler } from './game-room/handlers/trap.handler';
import { TurnHandler } from './game-room/handlers/turn.handler';
import { VirtualPlayerHandler } from './game-room/handlers/virtual-player.handler';
import { WaitingRoomChatHandler } from './waiting-room/handlers/waiting-room-chat.handler';
import { WaitingRoomGameHandler } from './waiting-room/handlers/waiting-room-game.handler';
import { WaitingRoomManagementHandler } from './waiting-room/handlers/waiting-room-management.handler';
import { WaitingRoomPlayerHandler } from './waiting-room/handlers/waiting-room-player.handler';
import { WaitingRoomGateway } from './waiting-room/waiting-room.gateway';

@Module({
    imports: [SharedRoomModule, GameModule, CombatModule, MovementModule, VirtualPlayersModule, AuthModule, GeneralChatModule],
    providers: [
        GameRoomGateway,
        WaitingRoomGateway,
        // Game room handlers
        MovementHandler,
        CombatHandler,
        ItemsHandler,
        VirtualPlayerHandler,
        GameLifecycleHandler,
        TurnHandler,
        TrapHandler,
        ChatHandler,
        StatisticsHandler,
        PlayerConnectionHandler,
        // Waiting room handlers
        WaitingRoomManagementHandler,
        WaitingRoomPlayerHandler,
        WaitingRoomGameHandler,
        WaitingRoomChatHandler,
    ],
})
export class RoomModule {}

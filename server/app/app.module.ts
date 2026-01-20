import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { MongooseModule } from '@nestjs/mongoose';
import configuration from './config/configuration';
import { CombatModule } from './modules/combat/combat.module';
import { GameModule } from './modules/game/game.module';
import { MovementModule } from './modules/movement/movement.module';
import { RoomModule } from './modules/room/room.module';
import { VirtualPlayersModule } from './modules/virtual-players/virtual-players.module';
import { SharedModule } from './shared/shared.module';

@Module({
    imports: [
        ConfigModule.forRoot({
            isGlobal: true,
            load: [configuration],
        }),
        MongooseModule.forRootAsync({
            imports: [ConfigModule],
            inject: [ConfigService],
            useFactory: async (config: ConfigService) => ({
                uri: config.get<string>('DATABASE_CONNECTION_STRING'),
            }),
        }),
        SharedModule,
        GameModule,
        CombatModule,
        MovementModule,
        RoomModule,
        VirtualPlayersModule,
    ],
})
export class AppModule {}

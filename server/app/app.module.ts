import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { MongooseModule } from '@nestjs/mongoose';
import configuration from '@app/config/configuration';
import { AuthModule } from '@app/modules/auth/auth.module';
import { CombatModule } from '@app/modules/combat/combat.module';
import { GameModule } from '@app/modules/game/game.module';
import { MovementModule } from '@app/modules/movement/movement.module';
import { RoomModule } from '@app/modules/room/room.module';
import { VirtualPlayersModule } from '@app/modules/virtual-players/virtual-players.module';
import { SharedModule } from '@app/shared/shared.module';
import { GeneralChatModule } from '@app/modules/general-chat/general-chat.module';
import { SocialModule } from '@app/modules/social/social.module';

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
        AuthModule,
        GameModule,
        CombatModule,
        MovementModule,
        RoomModule,
        VirtualPlayersModule,
        GeneralChatModule,
        SocialModule,
    ],
})
export class AppModule {}

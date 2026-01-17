import { GameController } from '@app/controllers/game/games.controller';
import { Game, gameSchema } from '@app/model/schema/game.schema';
import { GameService } from '@app/services/game/game.service';
import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { MongooseModule } from '@nestjs/mongoose';
import { DateService } from './services/date/date.service';
import { WaitingRoomGateway } from './gateways/waiting-room/waiting-room.gateway';
import { WaitingRoomService } from './services/waiting-room/waiting-room.service';
import { GameRoomGateway } from './gateways/game-room/game-room.gateway';
import { GameRoomService } from './services/game-room/game-room.service';
import { GameMovementService } from './services/game-movement/game-movement.service';
import { GameCombatService } from './services/game-combat/game-combat.service';
import { GameMovementVPService } from './services/virtual-players/game-movement-vp.service';
import { MovementAlgorithmsService } from './services/movement-algorithms/movement-algorithms.service';
import { DiceService } from './services/dice.service';

@Module({
    imports: [
        ConfigModule.forRoot({
            isGlobal: true,
        }),
        MongooseModule.forRootAsync({
            imports: [ConfigModule],
            inject: [ConfigService],
            useFactory: async (config: ConfigService) => ({
                uri: config.get<string>('DATABASE_CONNECTION_STRING'), // Loaded from .env
            }),
        }),
        MongooseModule.forFeature([{ name: Game.name, schema: gameSchema }]),
    ],
    controllers: [GameController],
    providers: [
        GameService,
        DateService,
        WaitingRoomGateway,
        WaitingRoomService,
        GameRoomGateway,
        GameRoomService,
        GameMovementService,
        GameCombatService,
        GameMovementVPService,
        MovementAlgorithmsService,
        DiceService,
    ],
})
export class AppModule {}

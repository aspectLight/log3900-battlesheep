import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { GameController } from './controllers/game.controller';
import { Game, gameSchema } from './schemas/game.schema';
import { GameValidationService } from './services/game-validation.service';
import { GameService } from './services/game.service';

@Module({
    imports: [MongooseModule.forFeature([{ name: Game.name, schema: gameSchema }])],
    controllers: [GameController],
    providers: [GameService, GameValidationService],
    exports: [GameService, GameValidationService],
})
export class GameModule {}

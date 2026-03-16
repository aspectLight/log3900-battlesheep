import { Module, forwardRef } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { AuthModule } from '@app/modules/auth/auth.module';
import { GameController } from './controllers/game.controller';
import { Game, gameSchema } from './schemas/game.schema';
import { GameValidationService } from './services/game-validation.service';
import { GameService } from './services/game.service';


@Module({
    imports: [MongooseModule.forFeature([{ name: Game.name, schema: gameSchema }]), forwardRef(() => AuthModule)],
    controllers: [GameController],
    providers: [GameService, GameValidationService],
    exports: [GameService, GameValidationService],
})
export class GameModule {}

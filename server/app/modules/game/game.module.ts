import { AuthModule } from '@app/modules/auth/auth.module';
import { Module, forwardRef } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { GameController } from './controllers/game.controller';
import { Game, gameSchema } from './schemas/game.schema';
import { GameSoftDeletePurgeService } from './services/game-soft-delete-purge.service';
import { GameValidationService } from './services/game-validation.service';
import { GameService } from './services/game.service';

@Module({
    imports: [MongooseModule.forFeature([{ name: Game.name, schema: gameSchema }]), forwardRef(() => AuthModule)],
    controllers: [GameController],
    providers: [GameService, GameValidationService, GameSoftDeletePurgeService],
    exports: [GameService, GameValidationService],
})
export class GameModule {}

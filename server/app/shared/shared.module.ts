import { Global, Module } from '@nestjs/common';
import { DateService } from './services/date.service';
import { DiceService } from './services/dice.service';

@Global()
@Module({
    providers: [DiceService, DateService],
    exports: [DiceService, DateService],
})
export class SharedModule {}

import { GameService } from '@app/modules/game/services/game.service';
import { Injectable, Logger, OnModuleDestroy, OnModuleInit } from '@nestjs/common';

const PURGE_INTERVAL_MS = 5 * 60 * 1000;

/** Periodically hard-deletes soft-deleted game blueprints after {@link GameService.SOFT_DELETE_RETENTION_MS}. */
@Injectable()
export class GameSoftDeletePurgeService implements OnModuleInit, OnModuleDestroy {
    private readonly logger = new Logger(GameSoftDeletePurgeService.name);
    private intervalId: ReturnType<typeof setInterval> | undefined;

    constructor(private readonly gameService: GameService) {}

    onModuleInit(): void {
        void this.gameService.purgeSoftDeletedGamesPastRetention();
        this.intervalId = setInterval(() => {
            void this.gameService.purgeSoftDeletedGamesPastRetention();
        }, PURGE_INTERVAL_MS);
    }

    onModuleDestroy(): void {
        if (this.intervalId !== undefined) {
            clearInterval(this.intervalId);
        }
    }
}

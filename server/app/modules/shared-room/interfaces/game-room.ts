import { Player } from '@app/shared/interfaces/player';
import { GlobalStats, PlayerStats } from '@app/shared/interfaces/stats';

export interface GameRoom {
    roomId: string;
    gameId: string;
    hostId: string;
    players: Player[];
    isLocked: boolean;
    isDebugging?: boolean;
    turnTimer?: NodeJS.Timeout;
    timeRemaining?: number;
    messages: { type: string; content: string; time: string }[];
    playersStats?: PlayerStats[];
    globalStats?: GlobalStats;
    startTime?: Date;
}

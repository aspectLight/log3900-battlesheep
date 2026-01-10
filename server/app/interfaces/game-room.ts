import { Player } from '@app/interfaces/player';
import { GlobalStats, PlayerStats } from '@app/interfaces/stats';

export interface GameRoom {
    roomId: string;
    gameId: string;
    organisatorId: string;
    players: Player[];
    isLocked: boolean;
    isDebugging?: boolean;
    turnTimer?: NodeJS.Timeout;
    timeRemaining?: number;
    messages: { type: string; content: string; time: string }[];
    journalEntries: { type: string; content: string; time: string }[];
    playersStats?: PlayerStats[];
    globalStats?: GlobalStats;
    startTime?: Date;
}

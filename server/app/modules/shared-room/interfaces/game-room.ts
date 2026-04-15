import { Player } from '@app/shared/interfaces/player';
import { GlobalStats, PlayerStats } from '@app/shared/interfaces/stats';

export interface AbandonedPlayer {
    firebaseUid: string;
    player: Player;
    stats: PlayerStats;
}

export interface GameRoom {
    roomId: string;
    gameId: string;
    hostId: string;
    players: Player[];
    isLocked: boolean;
    dropInDropOut: boolean;
    abandonedPlayers: AbandonedPlayer[];
    isDebugging?: boolean;
    turnTimer?: NodeJS.Timeout;
    timeRemaining?: number;
    messages: { type: string; content: string; time: string }[];
    playersStats?: PlayerStats[];
    globalStats?: GlobalStats;
    startTime?: Date;
    entryFee: number;
    paidPlayerFirebaseUids: string[];
    isFinished?: boolean;
    actionPointsPerTurn: number;
}

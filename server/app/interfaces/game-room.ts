import { Player } from '@app/interfaces/player';

export interface GameRoom {
    roomId: string;
    gameId: string;
    organisatorId: string;
    players: Player[];
    isLocked: boolean;
    isDebugging?: boolean;
    turnTimer?: NodeJS.Timeout;
    timeRemaining?: number;
}

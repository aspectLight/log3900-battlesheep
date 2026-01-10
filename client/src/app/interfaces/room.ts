import { Player } from '@app/classes/player';

export interface Room {
    roomId: string;
    gameId: string;
    organisatorId: string;
    players: Player[];
    isLocked: boolean;
    isDebugging: boolean;
}

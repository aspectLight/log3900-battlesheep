import { Player } from '@app/classes/entity/player';

export interface Room {
    roomId: string;
    gameId: string;
    hostId: string;
    players: Player[];
    isLocked: boolean;
    isDebugging: boolean;
}

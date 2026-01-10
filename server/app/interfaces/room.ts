import { Player } from '@app/interfaces/player';

export interface Room {
    roomId: string;
    gameId: string;
    organisatorId: string;
    players: Player[];
    futurePlayers?: string[];
    reservedAvatars?: { reservorId: string; chosenAvatar: string }[];
    isLocked: boolean;
}

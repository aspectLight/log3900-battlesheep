import { Player } from '@app/shared/interfaces/player';

export interface Room {
    roomId: string;
    gameId: string;
    hostId: string;
    players: Player[];
    futurePlayers?: string[];
    reservedAvatars?: Reservation[];
    isLocked: boolean;
    dropInDropOut: boolean;
    messages: { type: string; content: string; time: string }[];
}

export interface Reservation {
    reservorId: string;
    chosenAvatar: string;
}

import { Player } from '@app/interfaces/player';

export interface Room {
    roomId: string;
    gameId: string;
    organisatorId: string;
    players: Player[];
    futurePlayers?: string[];
    reservedAvatars?: Reservation[];
    isLocked: boolean;
    messages: { type: string; content: string; time: string }[];
    journalEntries: { type: string; content: string; time: string }[];
}

export interface Reservation {
    reservorId: string;
    chosenAvatar: string;
}

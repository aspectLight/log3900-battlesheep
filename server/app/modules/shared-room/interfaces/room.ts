import { Player } from '@app/shared/interfaces/player';

export interface Room {
    roomId: string;
    gameId: string;
    hostId: string;
    hostUsername?: string;
    players: Player[];
    futurePlayers?: string[];
    reservedAvatars?: Reservation[];
    isLocked: boolean;
    dropInDropOut: boolean;
    friendsOnly: boolean;
    messages: { type: string; content: string; time: string }[];
    entryFee: number;
    paidPlayerFirebaseUids: string[];
}

export interface Reservation {
    reservorId: string;
    chosenAvatar: string;
}

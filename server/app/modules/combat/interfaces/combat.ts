import { Player } from '@app/shared/interfaces/player';

export interface Combat {
    associatedRoomId: string;
    combatRoomId: string;
    players: Player[];
    attackerId: string;
    defenderId: string;
    currentPlayerId: string;
    currentOpponentId: string;
    turnTimer?: NodeJS.Timeout;
}

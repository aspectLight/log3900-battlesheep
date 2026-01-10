import { Player } from '@app/interfaces/player';

export interface Combat {
    combatRoomId: string;
    players: Player[];
    attackerId: string;
    defenderId: string;
    currentPlayerId: string;
    currentOpponentId: string;
    turnTimer?: NodeJS.Timeout;
}

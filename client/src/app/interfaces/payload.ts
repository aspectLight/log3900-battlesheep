import { Player } from '@app/classes/player';

export interface CombatRoom {
    combatRoomId: string;
    players: Player[];
    attackerId: string;
    defenderId: string;
    currentPlayerId: string;
    currentOpponentId: string;
}

export interface CombatPayload {
    roomId: string;
    opponentId: string;
}

export interface CombatValue {
    attackValue: number;
    defenseValue: number;
}

export interface AttackResult {
    isAttackSuccess: boolean;
    opponentHealthPoints: number;
    attackValue: number;
    defenseValue: number;
}

export interface FlightResult {
    isSuccess: boolean;
    attackerEvasionPoints: number;
}

export interface AttackPayload {
    roomId: string;
}

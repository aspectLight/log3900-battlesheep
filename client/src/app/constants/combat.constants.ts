export const FEEDBACK_DURATION = 800;
export const ANIMATION_DURATION = 500;
export const MAX_WINS = 3;
export const NOTIFICATION_DURATION = 3000;

export const MS_TO_SECONDS = 1000;

export enum CombatState {
    Idle = 'idle',
    Miss = 'miss',
    Hit = 'hit',
    GetHit = 'getHit',
    GetMissed = 'getMissed',
    FlightSuccess = 'flightSuccess',
    FlightFailure = 'flightFailure',
    Lost = 'lost',
    Won = 'won',
}

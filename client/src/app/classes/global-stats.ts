import { Coords } from '@app/interfaces/coords';

export class GlobalStats {
    gameDuration: string;
    turns: number;
    doorsToggled: Coords[];

    constructor(gameDuration?: string, turns?: number, doorsToggled?: Coords[]) {
        this.gameDuration = gameDuration ?? '0:00';
        this.turns = turns ?? 0;
        this.doorsToggled = doorsToggled ?? [];
    }
}

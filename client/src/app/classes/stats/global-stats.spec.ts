import { GlobalStats } from '@app/classes/stats/global-stats';
import { Coords } from '@app/interfaces/coords.interface';

const gameDuration = '10:30';
const turns = 10;
const doorsToggled = new Set<Coords>([
    { x: 0, y: 0 },
    { x: 1, y: 1 },
]);

describe('GlobalStats', () => {
    it('should create an instance', () => {
        expect(new GlobalStats(gameDuration, turns, Array.from(doorsToggled))).toBeTruthy();
    });
});

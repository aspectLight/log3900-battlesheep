import { PlayerStats } from '@app/classes/stats/player-stats';

const name = 'Player 1';
const combats = 5;
const evasions = 3;
const victories = 2;
const defeats = 1;
const healthLost = 10;
const damage = 15;
const itemsCollected = ['vodka'];
const tilesVisited = [
    { x: 1, y: 2 },
    { x: 3, y: 4 },
];

describe('PlayerStats', () => {
    it('should create an instance', () => {
        expect(new PlayerStats({ name, combats, evasions, victories, defeats, healthLost, damage, itemsCollected, tilesVisited })).toBeTruthy();
    });

    it('should create a default instance', () => {
        expect(new PlayerStats()).toEqual(
            new PlayerStats({
                name: '',
                combats: 0,
                evasions: 0,
                victories: 0,
                defeats: 0,
                healthLost: 0,
                damage: 0,
                itemsCollected: [],
                tilesVisited: [],
            }),
        );
    });
});

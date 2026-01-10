import { CommonModule } from '@angular/common';
import { provideHttpClient } from '@angular/common/http';
import { provideHttpClientTesting } from '@angular/common/http/testing';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { Router } from '@angular/router';
import { GlobalStats } from '@app/classes/global-stats';
import { SocketService } from '@app/services/socket.service';
import { EndGameComponent } from './end-game.component';

const player1stats = {
    name: 'Player 1',
    combats: 5,
    evasions: 3,
    victories: 2,
    defeats: 1,
    healthLost: 10,
    damage: 15,
    itemsCollected: ['flag'],
    tilesVisited: [{ x: 0, y: 1 }],
};
const player2stats = {
    name: 'Player 2',
    combats: 8,
    evasions: 4,
    victories: 6,
    defeats: 2,
    healthLost: 20,
    damage: 25,
    itemsCollected: [],
    tilesVisited: [
        { x: 0, y: 1 },
        { x: 1, y: 1 },
    ],
};
const player3stats = {
    name: 'Player 3',
    combats: 5,
    evasions: 2,
    victories: 1,
    defeats: 7,
    healthLost: 30,
    damage: 10,
    itemsCollected: ['vodka'],
    tilesVisited: [
        { x: 0, y: 1 },
        { x: 1, y: 1 },
        { x: 1, y: 2 },
    ],
};

const TILE_EXPLORED_PERCENTAGE = 30;
const DOORS_TOGGLED_PERCENTAGE = 40;
const PLAYER1_TILE_EXPLORED_PERCENTAGE = 10;

describe('EndGameComponent', () => {
    let socketServiceSpy: jasmine.SpyObj<SocketService>;
    let routerSpy: jasmine.SpyObj<Router>;
    let component: EndGameComponent;
    let fixture: ComponentFixture<EndGameComponent>;
    // eslint-disable-next-line @typescript-eslint/ban-types
    const eventHandlers: { [key: string]: Function } = {};
    beforeEach(async () => {
        socketServiceSpy = jasmine.createSpyObj('SocketService', [
            'connect',
            'on',
            'emit',
            'disconnect',
            'send',
            'getRoomId',
            'quitEndGame',
            'setUpListeners',
            'registerSocketService',
        ]);

        // eslint-disable-next-line @typescript-eslint/ban-types
        socketServiceSpy.on.and.callFake((event: string, callback: Function) => {
            eventHandlers[event] = callback;
        });

        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        (socketServiceSpy as any).socket = {
            on: jasmine.createSpy('on'),
            emit: jasmine.createSpy('emit'),
            off: jasmine.createSpy('off'),
            disconnect: jasmine.createSpy('disconnect'),
        };

        socketServiceSpy.getRoomId.and.returnValue('roomId');
        socketServiceSpy.registerSocketService.and.stub();

        routerSpy = jasmine.createSpyObj('Router', ['navigate']);

        await TestBed.configureTestingModule({
            imports: [CommonModule],
            providers: [
                provideHttpClient(),
                provideHttpClientTesting(),
                { provide: SocketService, useValue: socketServiceSpy },
                { provide: Router, useValue: routerSpy },
            ],
        }).compileComponents();

        fixture = TestBed.createComponent(EndGameComponent);
        component = fixture.componentInstance;
        fixture.detectChanges();
        component.playersStats = [player1stats, player2stats, player3stats];
        component.globalStats = {
            gameDuration: '0:10',
            turns: 20,
            doorsToggled: [
                { x: 0, y: 1 },
                { x: 1, y: 1 },
            ],
        };
        component.walkableTiles = 10;
        component.toggableDoors = 5;
        component.isAscending = true;
    });

    it('should create', () => {
        expect(component).toBeTruthy();
        expect(socketServiceSpy.send).toHaveBeenCalledWith('getStatistics', 'roomId');
    });

    it('should sort by properties', () => {
        component.sortBy('name');
        expect(component.playersStats).toEqual([player1stats, player2stats, player3stats]);
        expect(component.isAscending).toBe(false);
        component.sortBy('evasions');
        expect(component.playersStats).toEqual([player2stats, player1stats, player3stats]);
        expect(component.isAscending).toBe(true);
        component.sortBy('combats');
        expect(component.playersStats).toEqual([player1stats, player3stats, player2stats]);
        expect(component.isAscending).toBe(false);
    });

    it('should listen to "getStatisticsResponse" and update stats', () => {
        const teststats = {
            playerStats: [player1stats],
            globalStats: new GlobalStats(),
            walkableTiles: 10,
            toggableDoors: 5,
        };

        eventHandlers['getStatisticsResponse'](teststats);

        expect(component.playersStats).toEqual(teststats.playerStats);
        expect(component.globalStats).toEqual(teststats.globalStats);
        expect(component.walkableTiles).toEqual(teststats.walkableTiles);
        expect(component.toggableDoors).toEqual(teststats.toggableDoors);
    });

    it('should quit game and navigate to home', () => {
        component.quitGame();
        expect(socketServiceSpy.quitEndGame).toHaveBeenCalled();
        expect(routerSpy.navigate).toHaveBeenCalledWith(['/home']);
    });

    it('should get tileExploredPercentage', () => {
        expect(component.tileExploredPercentage).toEqual(TILE_EXPLORED_PERCENTAGE);
    });

    it('should get playersHadFlag', () => {
        expect(component.playersHadFlag).toEqual(1);
    });

    it('should get doorsToggledPercentage', () => {
        expect(component.doorsToggledPercentage).toEqual(DOORS_TOGGLED_PERCENTAGE);
    });

    it('should get player tile percentage', () => {
        expect(component.getPlayersTilePercentage(player1stats.name)).toEqual(PLAYER1_TILE_EXPLORED_PERCENTAGE);
        component.walkableTiles = 0;
        expect(component.getPlayersTilePercentage(player1stats.name)).toEqual(0);
        expect(component.getPlayersTilePercentage('No Player')).toEqual(0);
    });

    it('should sort by victories descending then ascending', () => {
        component.isAscending = false;
        component.sortBy('victories');
        expect(component.playersStats).toEqual([player2stats, player1stats, player3stats]);

        component.sortBy('victories');
        expect(component.playersStats).toEqual([player3stats, player1stats, player2stats]);
    });

    it('should sort by itemsCollected length', () => {
        component.isAscending = true;
        component.sortBy('itemsCollected');
        expect(component.playersStats).toEqual([player2stats, player1stats, player3stats]);
    });

    it('should sort by tilesVisited length', () => {
        component.isAscending = true;
        component.sortBy('tilesVisited');
        expect(component.playersStats).toEqual([player1stats, player2stats, player3stats]);
    });
});

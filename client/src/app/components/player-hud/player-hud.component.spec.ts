import { provideHttpClient } from '@angular/common/http';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { Item } from '@app/classes/item';
import { Player, Stats } from '@app/classes/player';
import { ItemCard } from '@app/interfaces/character';
import { GameManagerService } from '@app/services/game-manager.service';
import { MovementService } from '@app/services/movement.service';
import { PlayerHudComponent } from './player-hud.component';

describe('PlayerHudComponent', () => {
    let component: PlayerHudComponent;
    let fixture: ComponentFixture<PlayerHudComponent>;
    let gameManagerServiceSpy: jasmine.SpyObj<GameManagerService>;
    let movementServiceSpy: jasmine.SpyObj<MovementService>;

    let cards: ItemCard[];

    const mockPlayer = new Player('player');
    const mockEnemy = new Player('enemy');

    beforeEach(async () => {
        movementServiceSpy = jasmine.createSpyObj('MovementService', [], { selectedPlayer: mockEnemy });
        gameManagerServiceSpy = jasmine.createSpyObj('GameManagerService', ['getMainPlayer', 'isMainPlayerTurn'], {
            movementService: movementServiceSpy,
        });

        await TestBed.configureTestingModule({
            imports: [PlayerHudComponent],
            providers: [
                provideHttpClient(),
                { provide: GameManagerService, useValue: gameManagerServiceSpy },
                { provide: MovementService, useValue: movementServiceSpy },
            ],
        }).compileComponents();

        fixture = TestBed.createComponent(PlayerHudComponent);
        component = fixture.componentInstance;
        gameManagerServiceSpy.getMainPlayer.and.returnValue(mockPlayer);
        movementServiceSpy.selectedPlayer = mockEnemy;

        cards = [
            { item: new Item('vodka'), isExpanded: false },
            { item: new Item('adrenaline'), isExpanded: true },
        ];

        component.cards = cards;

        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });

    it('should not get points if they are undefined', () => {
        spyOnProperty(component, 'player', 'get').and.returnValue(undefined);
        expect(component.defensePoints).toEqual([]);
        expect(component.attackPoints).toEqual([]);
        expect(component.speedPoints).toEqual([]);
        expect(component.healthPoints).toEqual([]);
    });

    it('should get main player', () => {
        gameManagerServiceSpy.isMainPlayerTurn = false;
        expect(component.player).toEqual(mockPlayer);
    });

    it('should get defense points', () => {
        expect(component.defensePoints.length).toBe(mockPlayer.stats['defense'].value);
    });

    it('should return empty array for defense points when player is null', () => {
        gameManagerServiceSpy.getMainPlayer.and.returnValue(undefined);
        expect(component.defensePoints).toEqual([]);
    });

    it('should get attack points', () => {
        expect(component.attackPoints.length).toBe(mockPlayer.stats['attack'].value);
    });

    it('should return empty array for attack points when player is null', () => {
        gameManagerServiceSpy.getMainPlayer.and.returnValue(undefined);
        expect(component.attackPoints).toEqual([]);
    });

    it('should get speed points', () => {
        expect(component.speedPoints.length).toBe(mockPlayer.stats['speed'].value);
    });

    it('should return empty array for speed points when player is null', () => {
        gameManagerServiceSpy.getMainPlayer.and.returnValue(undefined);
        expect(component.speedPoints).toEqual([]);
    });

    it('should get health points', () => {
        expect(component.healthPoints.length).toBe(mockPlayer.stats['health'].value);
    });

    it('should return empty array for health points when player is null', () => {
        gameManagerServiceSpy.getMainPlayer.and.returnValue(undefined);
        expect(component.healthPoints).toEqual([]);
    });

    it('should get movement points', () => {
        expect(component.movementPoints).toBe(mockPlayer.movementPoints);
    });

    it('should get action points', () => {
        expect(component.actionPoints).toBe(mockPlayer.actionPoints);
    });

    it('should get dice', () => {
        mockPlayer.d6Choice = 'defense' as Stats;
        expect(component.getDice('defense')).toBe('./assets/items/D6.png');
        expect(component.getDice('attack')).toBe('./assets/items/D4.png');
    });

    it('should toggle card', () => {
        component.toggleCard(0);
        expect(component.cards[0].isExpanded).toBe(true);
    });

    it('should hover card', () => {
        component.cards[0].isExpanded = false;
        component.hoverCard(0);
        expect(component.cards[0].isExpanded).toBe(true);
    });

    it('should unhover card', () => {
        component.cards[1].isExpanded = true;
        component.unhoverCard(1);
        expect(component.cards[1].isExpanded).toBe(false);
    });
});

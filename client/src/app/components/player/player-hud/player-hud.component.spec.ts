import { ComponentFixture, TestBed } from '@angular/core/testing';
import { Item } from '@app/classes/entity/item';
import { Player } from '@app/classes/entity/player';
import { GameManagerService } from '@app/services/state/game-manager.service';
import { PlayerHudComponent } from './player-hud.component';
import { BonusType } from '@app/constants/bonus.constants';

describe('PlayerHudComponent', () => {
    let component: PlayerHudComponent;
    let fixture: ComponentFixture<PlayerHudComponent>;
    let gameManagerServiceSpy: jasmine.SpyObj<GameManagerService>;

    const mockPlayer = new Player('player');
    const mockVodka = new Item('vodka');
    const mockAdrenaline = new Item('adrenaline');
    // const mockCards = [
    //     { item: mockVodka, isExpanded: false },
    //     { item: mockAdrenaline, isExpanded: false }
    // ];

    beforeEach(async () => {
        gameManagerServiceSpy = jasmine.createSpyObj('GameManagerService', ['getMainPlayer']);

        await TestBed.configureTestingModule({
            imports: [PlayerHudComponent],
            providers: [{ provide: GameManagerService, useValue: gameManagerServiceSpy }],
        }).compileComponents();

        fixture = TestBed.createComponent(PlayerHudComponent);
        component = fixture.componentInstance;
        gameManagerServiceSpy.getMainPlayer.and.returnValue(mockPlayer);
        mockPlayer.inventory = [mockVodka, mockAdrenaline];

        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });

    it('should get main player', () => {
        expect(component.player).toEqual(mockPlayer);
    });

    it('should return null when no player is available', () => {
        gameManagerServiceSpy.getMainPlayer.and.returnValue(null);
        expect(component.player).toBeNull();
    });

    it('should get cards from player inventory', () => {
        expect(component.cards.length).toBe(2);
        expect(component.cards[0].item).toBe(mockVodka);
        expect(component.cards[1].item).toBe(mockAdrenaline);
        expect(component.cards[0].isExpanded).toBeFalse();
        expect(component.cards[1].isExpanded).toBeFalse();
    });

    it('should return empty array for cards when player is undefined', () => {
        gameManagerServiceSpy.getMainPlayer.and.returnValue(null);
        // The cards getter should return an empty array when player is undefined
        expect(component.cards).toEqual([]);
    });

    it('should call original cards getter implementation', () => {
        // Get the actual getter method from prototype
        const originalGetter = Object.getOwnPropertyDescriptor(Object.getPrototypeOf(component), 'cards')?.get;

        if (originalGetter) {
            // Call the original getter bound to the component instance
            const result = originalGetter.call(component);
            // Verify that the getter returns the expected array of cards
            expect(result).toEqual([
                { item: mockVodka, isExpanded: false },
                { item: mockAdrenaline, isExpanded: false },
            ]);
        }
    });

    it('should return empty array when player is null', () => {
        // Get the actual getter method from prototype
        const originalGetter = Object.getOwnPropertyDescriptor(Object.getPrototypeOf(component), 'cards')?.get;

        if (originalGetter) {
            // Temporarily set player to undefined
            gameManagerServiceSpy.getMainPlayer.and.returnValue(null);
            // Call the original getter bound to the component instance
            const result = originalGetter.call(component);
            expect(result).toEqual([]);
        }
    });

    it('should get defense points', () => {
        expect(component.defensePoints.length).toBe(mockPlayer.stats['defense'].value);
    });

    it('should return empty array for defense points when player is undefined', () => {
        gameManagerServiceSpy.getMainPlayer.and.returnValue(null);
        expect(component.defensePoints).toEqual([]);
    });

    it('should get attack points', () => {
        expect(component.attackPoints.length).toBe(mockPlayer.stats['attack'].value);
    });

    it('should return empty array for attack points when player is undefined', () => {
        gameManagerServiceSpy.getMainPlayer.and.returnValue(null);
        expect(component.attackPoints).toEqual([]);
    });

    it('should get speed points', () => {
        expect(component.speedPoints.length).toBe(mockPlayer.stats['speed'].value);
    });

    it('should return empty array for speed points when player is undefined', () => {
        gameManagerServiceSpy.getMainPlayer.and.returnValue(null);
        expect(component.speedPoints).toEqual([]);
    });

    it('should get health points', () => {
        expect(component.healthPoints.length).toBe(mockPlayer.stats['health'].value);
    });

    it('should return empty array for health points when player is undefined', () => {
        gameManagerServiceSpy.getMainPlayer.and.returnValue(null);
        expect(component.healthPoints).toEqual([]);
    });

    it('should get movement points', () => {
        expect(component.movementPoints).toBe(mockPlayer.movementPoints);
    });

    it('should return undefined for movement points when player is undefined', () => {
        gameManagerServiceSpy.getMainPlayer.and.returnValue(null);
        expect(component.movementPoints).toBeUndefined();
    });

    it('should get action points', () => {
        expect(component.actionPoints).toBe(mockPlayer.actionPoints);
    });

    it('should return undefined for action points when player is undefined', () => {
        gameManagerServiceSpy.getMainPlayer.and.returnValue(null);
        expect(component.actionPoints).toBeUndefined();
    });

    it('should get D6 dice for chosen stat', () => {
        mockPlayer.d6Choice = BonusType.Defense;
        expect(component.getDice('defense')).toBe('./assets/items/D6.png');
        expect(component.getDice('attack')).toBe('./assets/items/D4.png');
    });

    it('should get D4 dice for non-chosen stat', () => {
        mockPlayer.d6Choice = BonusType.Attack;
        expect(component.getDice('defense')).toBe('./assets/items/D4.png');
        expect(component.getDice('attack')).toBe('./assets/items/D6.png');
    });

    it('should return D4 for dice when player is undefined', () => {
        gameManagerServiceSpy.getMainPlayer.and.returnValue(null);
        expect(component.getDice('defense')).toBe('./assets/items/D4.png');
    });

    it('should toggle card expansion state', () => {
        expect(component.cards[0].isExpanded).toBeFalse();
        component.toggleCard(0);
        expect(component.cards[0].isExpanded).toBeTrue();

        component.toggleCard(0);
        expect(component.cards[0].isExpanded).toBeFalse();
    });

    it('should expand card on hover if not expanded', () => {
        expect(component.cards[0].isExpanded).toBeFalse();
        component.hoverCard(0);
        expect(component.cards[0].isExpanded).toBeTrue();
    });

    it('should not change card state on hover if already expanded', () => {
        component.toggleCard(0); // Expand the card first
        expect(component.cards[0].isExpanded).toBeTrue();
        component.hoverCard(0);
        expect(component.cards[0].isExpanded).toBeTrue();
    });

    it('should collapse card on unhover if expanded', () => {
        component.toggleCard(0); // Expand the card first
        expect(component.cards[0].isExpanded).toBeTrue();
        component.unhoverCard(0);
        expect(component.cards[0].isExpanded).toBeFalse();
    });

    it('should not change card state on unhover if already not expanded', () => {
        expect(component.cards[0].isExpanded).toBeFalse();
        component.unhoverCard(0);
        expect(component.cards[0].isExpanded).toBeFalse();
    });
});

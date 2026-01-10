import { ComponentFixture, TestBed } from '@angular/core/testing';
import { Player } from '@app/classes/player';
import { BonusType } from '@app/constants/bonus.constants';
import { AVATAR_TYPES } from '@app/constants/player.constants';
import { PlayerCardComponent } from './player-card.component';

describe('PlayerCardComponent', () => {
    let component: PlayerCardComponent;
    let fixture: ComponentFixture<PlayerCardComponent>;

    beforeEach(async () => {
        await TestBed.configureTestingModule({
            imports: [PlayerCardComponent],
        }).compileComponents();
    });

    beforeEach(() => {
        fixture = TestBed.createComponent(PlayerCardComponent);
        component = fixture.componentInstance;
    });

    it('should create the component', () => {
        expect(component).toBeTruthy();
    });

    it('should set the correct avatar for a valid player', () => {
        const mockPlayer: Player = new Player('Player1', 'georgie', BonusType.Health, BonusType.Attack);
        component.player = mockPlayer;

        component.ngOnInit();

        expect(component.avatar).toEqual(AVATAR_TYPES['georgie'].avatarFull);
    });

    it('should set default character when player is not provided', () => {
        component.ngOnInit();

        expect(component.avatar).toBeUndefined();
    });

    it('should handle lowercase player avatar names', () => {
        const mockPlayer: Player = new Player('Player1', 'irina', BonusType.Health, BonusType.Attack);
        component.player = mockPlayer;

        component.ngOnInit();

        expect(component.avatar).toEqual(AVATAR_TYPES['irina'].avatarFull);
    });

    it('should not set avatar if the avatar type does not exist', () => {
        const mockPlayer: Player = new Player('Player1', 'unknown', BonusType.Health, BonusType.Attack);
        component.player = mockPlayer;

        component.ngOnInit();

        expect(component.avatar).toBeUndefined();
    });

    it('should send signal when kick button is clicked', () => {
        spyOn(component.banEvent, 'emit');
        component.onKickClick();
        expect(component.banEvent.emit).toHaveBeenCalledWith(component.player);
    });

    it('should set isVirtualPlayer to true when player is virtual', () => {
        const mockPlayer: Player = new Player('Player1', 'georgie', BonusType.Health, BonusType.Attack);
        mockPlayer.isVirtual = true;
        component.player = mockPlayer;

        component.ngOnInit();

        expect(component.isVirtualPlayer).toBeTrue();
    });

    it('should not set isVirtualPlayer when player is not virtual', () => {
        const mockPlayer: Player = new Player('Player1', 'georgie', BonusType.Health, BonusType.Attack);
        mockPlayer.isVirtual = false;
        component.player = mockPlayer;

        component.ngOnInit();

        expect(component.isVirtualPlayer).toBeFalse();
    });
});

import { ComponentFixture, TestBed } from '@angular/core/testing';
import { Player } from '@app/classes/player';
import { MovementService } from '@app/services/movement.service';
import { PlayerComponent } from './player.component';
import { provideHttpClient } from '@angular/common/http';

describe('PlayerComponent', () => {
    let component: PlayerComponent;
    let fixture: ComponentFixture<PlayerComponent>;
    let movementServiceSpy: jasmine.SpyObj<MovementService>;

    beforeEach(async () => {
        movementServiceSpy = jasmine.createSpyObj('MovementService', ['selectPlayer']);

        await TestBed.configureTestingModule({
            imports: [PlayerComponent],
            providers: [provideHttpClient(), { provide: MovementService, useValue: movementServiceSpy }],
        }).compileComponents();

        fixture = TestBed.createComponent(PlayerComponent);
        component = fixture.componentInstance;

        // Create a mock player with required properties
        const mockPlayer = {
            color: 'blue',
            animationState: 'idle',
            orientation: 'down',
        } as Player;

        component.player = mockPlayer;

        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });
});

import { ComponentFixture, TestBed } from '@angular/core/testing';
import { WaitingPlayerPageComponent } from './waiting-player-page.component';
import { provideHttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { BehaviorSubject, of } from 'rxjs';
import { Room } from '@app/interfaces/room';
import { GameCreationService } from '@app/services/game-creation.service';
import { WaitingRoomService } from '@app/services/waiting-room.service';
import { SocketService } from '@app/services/socket.service';

describe('WaitingPlayerPageComponent', () => {
    let component: WaitingPlayerPageComponent;
    let fixture: ComponentFixture<WaitingPlayerPageComponent>;

    // Mock services
    const mockGameCreationService = {
        gameCode: 'TEST123',
        isHost: true,
    };

    const mockWaitingRoomService = {
        room$: new BehaviorSubject<Room | null>(null),
    };

    const mockSocketService = {
        roomExists$: of(true),
        isKicked$: of(false),
        startGame: jasmine.createSpy('startGame'),
        toggleLockRoom: jasmine.createSpy('toggleLockRoom'),
        kickPlayer: jasmine.createSpy('kickPlayer'),
        leaveRoom: jasmine.createSpy('leaveRoom'),
    };

    const mockRouter = {
        navigate: jasmine.createSpy('navigate'),
    };

    beforeEach(async () => {
        await TestBed.configureTestingModule({
            imports: [WaitingPlayerPageComponent],
            providers: [
                provideHttpClient(),
                { provide: GameCreationService, useValue: mockGameCreationService },
                { provide: WaitingRoomService, useValue: mockWaitingRoomService },
                { provide: SocketService, useValue: mockSocketService },
                { provide: Router, useValue: mockRouter },
            ],
        }).compileComponents();

        fixture = TestBed.createComponent(WaitingPlayerPageComponent);
        component = fixture.componentInstance;
        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });
});

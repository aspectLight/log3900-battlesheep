import { CommonModule } from '@angular/common';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { Router } from '@angular/router';
import { Player } from '@app/classes/player';
import { PlayerCardComponent } from '@app/components/player-card/player-card.component';
import { ErrorMessages } from '@app/constants/error-messages.constants';
import { ROUTES } from '@app/constants/routes.constants';
import { Room } from '@app/interfaces/room';
import { GameCreationService } from '@app/services/game-creation.service';
import { SocketService } from '@app/services/socket.service';
import { WaitingRoomService } from '@app/services/waiting-room.service';
import { of, Subject } from 'rxjs';
import { WaitingPlayerComponent } from './waiting-player.component';

describe('WaitingPlayerComponent', () => {
    let component: WaitingPlayerComponent;
    let fixture: ComponentFixture<WaitingPlayerComponent>;
    let mockGameCreationService: jasmine.SpyObj<GameCreationService>;
    let mockWaitingRoomService: jasmine.SpyObj<WaitingRoomService>;
    let mockSocketService: jasmine.SpyObj<SocketService>;
    let mockRouter: jasmine.SpyObj<Router>;
    let roomSubject: Subject<Room>;
    let roomExistsSubject: Subject<boolean>;
    let isKickedSubject: Subject<boolean>;

    const mockGameCode = '1234';
    const mockPlayerId = 'player123';
    const mockIsHost = true;

    const mockPlayer = new Player('viktor');
    mockPlayer.stats = {
        health: { value: 4, description: 'Points de vie du personnage' },
        speed: { value: 4, description: 'Vitesse de déplacement' },
        attack: { value: 4, description: "Puissance d'attaque" },
        defense: { value: 4, description: 'Capacité défensive' },
    };

    const mockRoom: Room = {
        roomId: mockGameCode,
        gameId: 'game123',
        organisatorId: 'org123',
        players: [mockPlayer],
        isLocked: false,
        isDebugging: false,
    };

    beforeEach(async () => {
        mockGameCreationService = jasmine.createSpyObj('GameCreationService', [], {
            gameCode: mockGameCode,
            isHost: mockIsHost,
        });

        roomExistsSubject = new Subject<boolean>();
        isKickedSubject = new Subject<boolean>();

        mockSocketService = jasmine.createSpyObj('SocketService', ['getId', 'startGame', 'toggleLockRoom', 'kickPlayer', 'leaveRoom'], {
            roomExists$: roomExistsSubject.asObservable(),
            isKicked$: isKickedSubject.asObservable(),
        });

        mockSocketService.getId.and.returnValue(mockPlayerId);
        mockSocketService.roomExists$ = of(true);
        mockSocketService.isKicked$ = of(false);

        roomSubject = new Subject<Room>();
        mockWaitingRoomService = jasmine.createSpyObj('WaitingRoomService', [], {
            room$: roomSubject.asObservable(),
        });

        mockRouter = jasmine.createSpyObj('Router', ['navigate']);

        await TestBed.configureTestingModule({
            imports: [CommonModule, PlayerCardComponent, WaitingPlayerComponent],
            providers: [
                { provide: GameCreationService, useValue: mockGameCreationService },
                { provide: WaitingRoomService, useValue: mockWaitingRoomService },
                { provide: SocketService, useValue: mockSocketService },
                { provide: Router, useValue: mockRouter },
            ],
        }).compileComponents();

        fixture = TestBed.createComponent(WaitingPlayerComponent);
        component = fixture.componentInstance;
        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });

    it('should initialize with correct values from services', () => {
        expect(component.code).toBe(mockGameCode);
        expect(component.isHost).toBe(mockIsHost);
    });

    it('should update room when room$ emits', () => {
        roomSubject.next(mockRoom);
        expect(component.room).toEqual(mockRoom);
    });

    it('should show error message when roomExists$ becomes false', () => {
        roomExistsSubject.next(false);
        expect(component.errorMessage).toBe(ErrorMessages.GameDeleted);
        expect(component.showError).toBeTrue();
    });

    it('should show error message when isKicked$ becomes true', () => {
        isKickedSubject.next(true);
        expect(component.errorMessage).toBe(ErrorMessages.PlayerKicked);
        expect(component.showError).toBeTrue();
    });

    it('should call socketService.startGame with correct code when startGame is called', () => {
        component.startGame();
        expect(mockSocketService.startGame).toHaveBeenCalledWith(mockGameCode);
    });

    it('should call socketService.toggleLockRoom with correct code when toggleLockRoom is called', () => {
        component.toggleLockRoom();
        expect(mockSocketService.toggleLockRoom).toHaveBeenCalledWith(mockGameCode);
    });

    it('should call socketService.kickPlayer with correct parameters when kickPlayer is called', () => {
        component.kickPlayer(mockPlayer);
        expect(mockSocketService.kickPlayer).toHaveBeenCalledWith(mockGameCode, mockPlayer);
    });

    it('should unsubscribe from roomSubscription on ngOnDestroy', () => {
        spyOn(component['roomSubscription'], 'unsubscribe');
        component.ngOnDestroy();
        expect(component['roomSubscription'].unsubscribe).toHaveBeenCalled();
    });

    it('should navigate to home when leaveRoom is successful', () => {
        mockSocketService.leaveRoom.and.callFake((code, callback) => {
            callback(true, undefined);
        });
        component.leaveRoom();
        expect(mockSocketService.leaveRoom).toHaveBeenCalledWith(mockGameCode, jasmine.any(Function));
        expect(mockRouter.navigate).toHaveBeenCalledWith([ROUTES.home]);
        expect(component.showError).toBeFalse();
    });

    it('should show the error when leaveRoom is unsuccessful', () => {
        const errorMessage = 'errorMessage';
        mockSocketService.leaveRoom.and.callFake((code, callback) => {
            callback(false, errorMessage);
        });
        component.leaveRoom();
        expect(mockSocketService.leaveRoom).toHaveBeenCalledWith(mockGameCode, jasmine.any(Function));
        expect(component.errorMessage).toEqual(errorMessage);
        expect(component.showError).toBeTrue();
    });

    it('should show the default error when leaveRoom is unsuccessful with no error passed', () => {
        mockSocketService.leaveRoom.and.callFake((code, callback) => {
            callback(false, undefined);
        });
        component.leaveRoom();
        expect(mockSocketService.leaveRoom).toHaveBeenCalledWith(mockGameCode, jasmine.any(Function));
        expect(component.errorMessage).toEqual(ErrorMessages.QuitError);
        expect(component.showError).toBeTrue();
    });
});

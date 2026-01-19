import { CommonModule } from '@angular/common';
import { provideHttpClient } from '@angular/common/http';
import { provideHttpClientTesting } from '@angular/common/http/testing';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { Router } from '@angular/router';
import { Player } from '@app/classes/entity/player';
import { PlayerCardComponent } from '@app/components/player/player-card/player-card.component';
import { BonusType } from '@app/constants/bonus.constants';
import { VirtualPlayerType } from '@app/constants/player.constants';
import { ROUTES } from '@app/constants/routes.constants';
import { Room } from '@app/interfaces/room.interface';
import { RoomSocketService } from '@app/services/communication/socket-handlers/room-socket.service';
import { VirtualPlayerService } from '@app/services/gameplay/virtual-player.service';
import { GameCreationService } from '@app/services/lobby/game-creation.service';
import { WaitingRoomService } from '@app/services/lobby/waiting-room.service';
import { ErrorMessages, WaitRoomWelcomeMessage } from '@common/error-messages.constants';
import { of, Subject } from 'rxjs';
import { WaitingPlayerComponent } from './waiting-player.component';

describe('WaitingPlayerComponent', () => {
    let component: WaitingPlayerComponent;
    let fixture: ComponentFixture<WaitingPlayerComponent>;
    let mockVirtualPlayerService: jasmine.SpyObj<VirtualPlayerService>;
    let mockGameCreationService: jasmine.SpyObj<GameCreationService>;
    let mockWaitingRoomService: jasmine.SpyObj<WaitingRoomService>;
    let mockSocketService: jasmine.SpyObj<RoomSocketService>;
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
        hostId: 'org123',
        players: [mockPlayer],
        isLocked: false,
        isDebugging: false,
    };

    beforeEach(async () => {
        mockGameCreationService = jasmine.createSpyObj('GameCreationService', [], {
            gameCode: mockGameCode,
            isHost: mockIsHost,
            isCTF: false,
        });

        mockVirtualPlayerService = jasmine.createSpyObj('VirtualPlayerService', ['generateVirtualPlayer', 'resetUsedNames', 'removeName']);

        roomExistsSubject = new Subject<boolean>();
        isKickedSubject = new Subject<boolean>();

        mockSocketService = jasmine.createSpyObj(
            'SocketService',
            [
                'getId',
                'startGame',
                'toggleLockRoom',
                'kickPlayer',
                'leaveRoom',
                'reconnect',
                'reserveAvatar',
                'createPlayer',
                'getMessagesFromWaitingRoom',
            ],
            {
                roomExists$: roomExistsSubject.asObservable(),
                isKicked$: isKickedSubject.asObservable(),
            },
        );

        mockSocketService.getId.and.returnValue(mockPlayerId);
        mockSocketService.roomExists$ = of(true);
        mockSocketService.isKicked$ = of(false);
        mockSocketService.getMessagesFromWaitingRoom.and.stub();

        roomSubject = new Subject<Room>();
        mockWaitingRoomService = jasmine.createSpyObj('WaitingRoomService', ['getPlayerFromId'], {
            room$: roomSubject.asObservable(),
        });
        mockWaitingRoomService.getPlayerFromId.and.stub();

        mockRouter = jasmine.createSpyObj('Router', ['navigate']);

        await TestBed.configureTestingModule({
            imports: [CommonModule, PlayerCardComponent, WaitingPlayerComponent],
            providers: [
                provideHttpClient(),
                provideHttpClientTesting(),
                { provide: GameCreationService, useValue: mockGameCreationService },
                { provide: WaitingRoomService, useValue: mockWaitingRoomService },
                { provide: RoomSocketService, useValue: mockSocketService },
                { provide: VirtualPlayerService, useValue: mockVirtualPlayerService },
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

    it('should show welcome message popup on initialization', () => {
        expect(component.errorMessage).toBe(WaitRoomWelcomeMessage);
        expect(component.showMessage).toBeTrue();
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

    it('should get error message from waitingRoomService', () => {
        mockWaitingRoomService.errorMessage = 'errorMessage';
        expect(component.errorMessageFromService).toEqual('errorMessage');
    });

    it('should call socketService.startGame with correct code when startGame is called', () => {
        component.room = {
            ...mockRoom,
            isLocked: true,
            players: [mockPlayer, new Player('player2')],
        };

        component.startGame();
        expect(mockSocketService.startGame).toHaveBeenCalledWith(mockGameCode);
    });

    it('should call socketService.toggleLockRoom with correct code when toggleLockRoom is called', () => {
        component.toggleLockRoom();
        expect(mockSocketService.toggleLockRoom).toHaveBeenCalledWith(mockGameCode);
    });

    it('should call socketService.toggleLockRoom with correct code when toggleLockRoom is called', () => {
        component.toggleLockRoom();
        expect(mockSocketService.toggleLockRoom).toHaveBeenCalledWith(mockGameCode);
    });

    it('should disbale the unlock error', () => {
        component.disableUnlockError();
        expect(mockWaitingRoomService.isError).toEqual(false);
        expect(mockWaitingRoomService.errorMessage).toEqual('');
    });

    it('should kick player and remove their name', () => {
        component.kickPlayer(mockPlayer);
        expect(mockSocketService.kickPlayer).toHaveBeenCalledWith(component.code, mockPlayer);
        expect(mockVirtualPlayerService.removeName).toHaveBeenCalledWith(mockPlayer.id);
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
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        spyOn<any>(component, 'resetMessages');

        mockSocketService.leaveRoom.and.callFake((code, callback) => {
            callback(false, errorMessage);
        });

        component.leaveRoom();

        expect(mockSocketService.leaveRoom).toHaveBeenCalledWith(mockGameCode, jasmine.any(Function));
        expect(component.errorMessage).toBe(errorMessage);
        expect(component.showError).toBeTrue();
    });

    it('should show the default error when leaveRoom is unsuccessful with no error passed', () => {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        spyOn<any>(component, 'resetMessages');

        mockSocketService.leaveRoom.and.callFake((code, callback) => {
            callback(false, undefined);
        });

        component.leaveRoom();

        expect(mockSocketService.leaveRoom).toHaveBeenCalledWith(mockGameCode, jasmine.any(Function));
        expect(component.errorMessage).toBe(ErrorMessages.QuitError);
        expect(component.showError).toBeTrue();
    });

    describe('Profile Section', () => {
        it('should open profile section when openProfileSection is called', () => {
            component.room = { ...mockRoom, isLocked: false };
            component.openProfileSection();
            expect(component.isProfileSectionVisible).toBeTrue();
        });

        it('should show locked room error when trying to open profile section in locked room', () => {
            // First close the welcome popup
            component.onCancel();

            // Now set up the locked room state
            component.room = { ...mockRoom, isLocked: true };

            // Try to open profile section
            component.openProfileSection();

            expect(component.errorMessage).toBe(ErrorMessages.RoomLockedAddPlayer);
            expect(component.showMessage).toBeTrue();
            expect(component.isProfileSectionVisible).toBeFalse();
        });

        it('should close profile section when closeProfileSection is called', () => {
            component.isProfileSectionVisible = true;
            component['closeProfileSection']();
            expect(component.isProfileSectionVisible).toBeFalse();
        });

        it('should handle aggressive profile selection', () => {
            const mockVirtualPlayer = new Player('VP1', 'avatar1', BonusType.Health, BonusType.Attack, VirtualPlayerType.Aggressive);
            mockVirtualPlayerService.generateVirtualPlayer.and.returnValue(mockVirtualPlayer);

            component.handleAgressiveProfileClick();

            expect(mockVirtualPlayerService.generateVirtualPlayer).toHaveBeenCalledWith(VirtualPlayerType.Aggressive);
            expect(mockSocketService.reserveAvatar).toHaveBeenCalledWith(mockGameCode, mockVirtualPlayer.avatar?.name || '', mockVirtualPlayer.id);
            expect(mockSocketService.createPlayer).toHaveBeenCalledWith(mockGameCode, mockVirtualPlayer);
            expect(component.isProfileSectionVisible).toBeFalse();
        });

        it('should handle defensive profile selection', () => {
            const mockVirtualPlayer = new Player('VP1', 'avatar1', BonusType.Health, BonusType.Attack, VirtualPlayerType.Defensive);
            mockVirtualPlayerService.generateVirtualPlayer.and.returnValue(mockVirtualPlayer);

            component.handleDefensiveProfileClick();

            expect(mockVirtualPlayerService.generateVirtualPlayer).toHaveBeenCalledWith(VirtualPlayerType.Defensive);
            expect(mockSocketService.reserveAvatar).toHaveBeenCalledWith(mockGameCode, mockVirtualPlayer.avatar?.name || '', mockVirtualPlayer.id);
            expect(mockSocketService.createPlayer).toHaveBeenCalledWith(mockGameCode, mockVirtualPlayer);
            expect(component.isProfileSectionVisible).toBeFalse();
        });
    });

    describe('confirmAction', () => {
        it('should set up kick confirmation when action is kick', () => {
            component.confirmAction('kick', mockPlayer);

            expect(component.errorMessage).toBe('Voulez-vous vraiment expulser ce joueur ?');
            expect(component.showConfirmation).toBeTrue();

            // Test the stored action
            component.toDo();
            expect(mockSocketService.kickPlayer).toHaveBeenCalledWith(component.code, mockPlayer);
        });

        it('should not set up lock confirmation when action is lock and room is unlocked', () => {
            component.room = { ...mockRoom, isLocked: false };
            component.confirmAction('lock');

            expect(component.errorMessage).toBe('');
            expect(component.showConfirmation).toBeFalse();

            // Test the stored action
            component.toDo();
            expect(mockSocketService.toggleLockRoom).toHaveBeenCalledWith(component.code);
        });

        it('should set up unlock confirmation when action is lock and room is locked', () => {
            component.room = { ...mockRoom, isLocked: true };
            component.confirmAction('lock');

            expect(component.errorMessage).toBe('Voulez-vous vraiment deverrouiller la salle ?');
            expect(component.showConfirmation).toBeTrue();

            // Test the stored action
            component.toDo();
            expect(mockSocketService.toggleLockRoom).toHaveBeenCalledWith(component.code);
        });

        it('should set up leave confirmation when action is leave', () => {
            component.confirmAction('leave');

            expect(component.errorMessage).toBe('Voulez-vous vraiment quitter la salle ?');
            expect(component.showConfirmation).toBeTrue();

            // Test the stored action
            mockSocketService.leaveRoom.and.callFake((code, callback) => {
                callback(true, undefined);
            });
            component.toDo();
            expect(mockSocketService.leaveRoom).toHaveBeenCalledWith(component.code, jasmine.any(Function));
        });
    });

    it('should show locked room error message when room is locked', () => {
        component.room = { ...mockRoom, isLocked: true };
        component.showMessage = false;

        // First close the welcome popup
        component.onCancel();

        // Simulate room being locked
        roomSubject.next(component.room);

        expect(component.errorMessage).toBe('');
        expect(component.showMessage).toBeFalse();
    });

    describe('isStartValid getter', () => {
        it('should return false if room is null', () => {
            component.room = null;
            expect(component.isStartValid).toBeFalse();
        });

        it('should return false if room is not locked', () => {
            component.room = { ...mockRoom, isLocked: false, players: [new Player('p1'), new Player('p2')] };
            expect(component.isStartValid).toBeFalse();
        });

        it('should return false if player count is not greater than 1', () => {
            component.room = { ...mockRoom, isLocked: true, players: [new Player('p1')] };
            expect(component.isStartValid).toBeFalse();
        });

        it('should return true for classic mode with multiple players and locked room', () => {
            // Set up classic mode
            Object.defineProperty(mockGameCreationService, 'isCTF', { get: () => false });

            component.room = { ...mockRoom, isLocked: true, players: [new Player('p1'), new Player('p2'), new Player('p3')] };
            expect(component.isStartValid).toBeTrue();
        });

        it('should return true for CTF mode with even number of players and locked room', () => {
            // Set up CTF mode
            Object.defineProperty(mockGameCreationService, 'isCTF', { get: () => true });

            component.room = { ...mockRoom, isLocked: true, players: [new Player('p1'), new Player('p2'), new Player('p3'), new Player('p4')] };
            expect(component.isStartValid).toBeTrue();
        });

        it('should return false for CTF mode with odd number of players', () => {
            // Set up CTF mode
            Object.defineProperty(mockGameCreationService, 'isCTF', { get: () => true });

            component.room = { ...mockRoom, isLocked: true, players: [new Player('p1'), new Player('p2'), new Player('p3')] };
            expect(component.isStartValid).toBeFalse();
        });
    });
});

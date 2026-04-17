import { ComponentFixture, TestBed } from '@angular/core/testing';
import { ActivatedRoute, Router } from '@angular/router';
import { GameCreationService } from '@app/services/lobby/game-creation.service';
import { PlayerCreationService } from '@app/services/lobby/player-creation.service';
import { CreatePlayerPageComponent } from './create-player-page.component';

import { ElementRef } from '@angular/core';
import { Player } from '@app/classes/entity/player';
import { ErrorMessages } from '@common/error-messages.constants';
import { DEFAULT_STATS_VALUE, AVATAR_TYPES } from '@app/constants/player.constants';
import { ROUTES } from '@app/constants/routes.constants';
import { Subject } from 'rxjs';
import { RoomSocketService } from '@app/services/communication/socket-handlers/room-socket.service';
import { BonusType } from '@app/constants/bonus.constants';

describe('CreatePlayerPageComponent', () => {
    let component: CreatePlayerPageComponent;
    let fixture: ComponentFixture<CreatePlayerPageComponent>;
    let mockGameCreationService: jasmine.SpyObj<GameCreationService>;
    let mockPlayerCreationService: jasmine.SpyObj<PlayerCreationService>;
    let mockSocketService: jasmine.SpyObj<RoomSocketService>;
    let mockRouter: jasmine.SpyObj<Router>;

    let roomLockedSubject: Subject<boolean>;
    let reservedAvatarsSubject: Subject<{ reservorId: string; chosenAvatar: string }[]>;
    let avatarReservationFailedSubject: Subject<{ error: string }>;
    let characterCreationGameStartedLeftOutSubject: Subject<void>;

    beforeEach(async () => {
        roomLockedSubject = new Subject<boolean>();
        reservedAvatarsSubject = new Subject<{ reservorId: string; chosenAvatar: string }[]>();
        avatarReservationFailedSubject = new Subject<{ error: string }>();
        characterCreationGameStartedLeftOutSubject = new Subject<void>();

        mockPlayerCreationService = jasmine.createSpyObj('PlayerCreationService', ['createPlayer', 'clearAvatar'], ['selectedCharacter', 'selectedBonus']);
        mockGameCreationService = jasmine.createSpyObj('GameCreationService', [], ['isHost', 'gameCode', 'selectedGame']);
        mockSocketService = jasmine.createSpyObj(
            'RoomSocketService',
            ['getReservedAvatars', 'getId', 'reserveAvatar', 'createRoom', 'createPlayer', 'sync'],
            ['roomLocked$', 'reservedAvatars$'],
        );
        mockRouter = jasmine.createSpyObj('Router', ['navigate']);

        mockSocketService.getId.and.returnValue('1');
        mockSocketService.reserveAvatar.and.returnValue(Promise.resolve());

        Object.defineProperty(mockGameCreationService, 'isHost', { get: () => true });
        Object.defineProperty(mockGameCreationService, 'gameCode', { get: () => 'testCode' });
        Object.defineProperty(mockGameCreationService, 'selectedGame', { get: () => ({ _id: 'gameId' }) });

        Object.defineProperty(mockSocketService, 'roomLocked$', { get: () => roomLockedSubject.asObservable() });
        Object.defineProperty(mockSocketService, 'reservedAvatars$', { get: () => reservedAvatarsSubject.asObservable() });
        Object.defineProperty(mockSocketService, 'avatarReservationFailed$', {
            get: () => avatarReservationFailedSubject.asObservable(),
        });
        Object.defineProperty(mockSocketService, 'characterCreationGameStartedLeftOut$', {
            get: () => characterCreationGameStartedLeftOutSubject.asObservable(),
        });

        Object.defineProperty(mockPlayerCreationService, 'selectedCharacter', {
            get: () => ({
                character: { name: '', id: 1, avatar: '', avatarFull: '' },
                bonus: { life: DEFAULT_STATS_VALUE, speed: DEFAULT_STATS_VALUE, defense: DEFAULT_STATS_VALUE, attack: DEFAULT_STATS_VALUE },
            }),
        });
        Object.defineProperty(mockPlayerCreationService, 'selectedBonus', {
            get: () => ({
                life: DEFAULT_STATS_VALUE,
                speed: DEFAULT_STATS_VALUE,
                defense: DEFAULT_STATS_VALUE,
                attack: DEFAULT_STATS_VALUE,
            }),
        });

        await TestBed.configureTestingModule({
            imports: [CreatePlayerPageComponent],
            providers: [
                { provide: PlayerCreationService, useValue: mockPlayerCreationService },
                { provide: GameCreationService, useValue: mockGameCreationService },
                { provide: RoomSocketService, useValue: mockSocketService },
                { provide: Router, useValue: mockRouter },
                { provide: ActivatedRoute, useValue: {} },
            ],
        }).compileComponents();

        fixture = TestBed.createComponent(CreatePlayerPageComponent);
        component = fixture.componentInstance;

        component.playerNameInput = {
            nativeElement: { value: 'Test Player' },
        } as ElementRef<HTMLInputElement>;

        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });

    it('should show error message when roomLocked$ emits true', () => {
        roomLockedSubject.next(true);
        fixture.detectChanges();
        expect(component.errorMessage).toBe(ErrorMessages.GameDeletedOrLocked);
        expect(component.showError).toBeTrue();
    });

    it('should update reservedAvatars when reservedAvatars$ emits', () => {
        const avatars = [{ reservorId: 'id1', chosenAvatar: 'avatar1' }];
        reservedAvatarsSubject.next(avatars);
        fixture.detectChanges();
        expect(component.reservedAvatars).toEqual(avatars);
    });

    it('onCharacterSelected should update selectedCharacter and call reserveAvatar', async () => {
        const chosenAvatar = { name: '', id: 1 };
        const expectedCharacter = {
            character: { name: '', id: 1, avatar: '', avatarFull: '' },
            bonus: { life: DEFAULT_STATS_VALUE, speed: DEFAULT_STATS_VALUE, defense: DEFAULT_STATS_VALUE, attack: DEFAULT_STATS_VALUE },
        };
        await component.onCharacterSelected(chosenAvatar);
        expect(mockPlayerCreationService.selectedCharacter).toEqual(expectedCharacter);
        expect(mockSocketService.reserveAvatar).toHaveBeenCalledWith('testCode', chosenAvatar.name, '1');
    });

    it('onBonusSelected should update selectedBonus', () => {
        const chosenBonus = { life: 10, speed: 10, defense: 10, attack: 10 };
        const expectedBonus = { life: DEFAULT_STATS_VALUE, speed: DEFAULT_STATS_VALUE, defense: DEFAULT_STATS_VALUE, attack: DEFAULT_STATS_VALUE };
        component.onBonusSelected(chosenBonus);
        expect(mockPlayerCreationService.selectedBonus).toEqual(expectedBonus);
    });

    it('should not create player if gameModified is true', async () => {
        component.gameModified = true;
        await component.createPlayer();
        expect(mockPlayerCreationService.createPlayer).not.toHaveBeenCalled();
    });
    it('should create room if player creation succeeds and user is host', async () => {
        component.gameModified = false;
        const newPlayer = new Player('Test Player');
        mockPlayerCreationService.createPlayer.and.returnValue(newPlayer);
        await component.createPlayer();
        expect(mockSocketService.createRoom).toHaveBeenCalledWith('testCode', 'gameId', newPlayer);
        expect(mockRouter.navigate).toHaveBeenCalledWith([ROUTES.waiting]);
    });

    it('should create player if user is not host', async () => {
        Object.defineProperty(mockGameCreationService, 'isHost', { get: () => false });
        component.isHost = false;
        const newPlayer = new Player('Test Player');
        mockPlayerCreationService.createPlayer.and.returnValue(newPlayer);
        await component.createPlayer();
        expect(mockSocketService.createPlayer).toHaveBeenCalledWith('testCode', newPlayer);
        expect(mockRouter.navigate).toHaveBeenCalledWith([ROUTES.waiting]);
    });

    it('should set validCharacter to false if player creation fails', async () => {
        mockPlayerCreationService.createPlayer.and.returnValue(null);
        await component.createPlayer();
        expect(component.validCharacter).toBeFalse();
    });

    it('handlePopUp should reset gameModified and showError then navigate home', () => {
        component.gameModified = true;
        component.showError = true;
        component.handlePopUp();
        expect(component.gameModified).toBeFalse();
        expect(component.showError).toBeFalse();
        expect(mockRouter.navigate).toHaveBeenCalledWith([ROUTES.home]);
    });

    it('should return empty string when getId returns undefined', () => {
        mockSocketService.getId.and.returnValue(undefined);
        expect(component.getId()).toBe('');
    });

    describe('previewPlayer getter', () => {
        it('should return empty player when no character is selected', () => {
            Object.defineProperty(mockPlayerCreationService, 'selectedCharacter', {
                get: () => ({
                    character: { name: '', id: 1, avatar: '', avatarFull: '' },
                    bonus: { life: 0, speed: 0, defense: 0, attack: 0 },
                }),
            });
            const player = component.previewPlayer;
            expect(player.name).toBeNull();
            expect(player.avatar).toBeNull();
            expect(player.d4Choice).toBe(BonusType.Attack);
            expect(player.d6Choice).toBeNull();
        });

        it('should create player with correct bonuses when character is selected', () => {
            Object.defineProperty(mockPlayerCreationService, 'selectedCharacter', {
                get: () => ({
                    character: { name: 'TestChar', id: 1, avatar: '', avatarFull: '' },
                    bonus: { life: 6, speed: 0, defense: 6, attack: 0 },
                }),
            });
            const player = component.previewPlayer;
            expect(player.name).toBe('TestChar');
            expect(player.avatar).toBe(AVATAR_TYPES['testchar']);
            expect(player.d4Choice).toBe(BonusType.Attack);
            expect(player.d6Choice).toBe(BonusType.Defense);
        });

        it('should create player with speed and attack bonuses when no stat has bonus', () => {
            Object.defineProperty(mockPlayerCreationService, 'selectedCharacter', {
                get: () => ({
                    character: { name: 'TestChar', id: 1, avatar: '', avatarFull: '' },
                    bonus: { life: 0, speed: 0, defense: 0, attack: 0 },
                }),
            });
            const player = component.previewPlayer;
            expect(player.name).toBe('TestChar');
            expect(player.avatar).toBe(AVATAR_TYPES['testchar']);
            expect(player.d4Choice).toBe(BonusType.Defense);
            expect(player.d6Choice).toBe(BonusType.Attack);
        });
    });
});

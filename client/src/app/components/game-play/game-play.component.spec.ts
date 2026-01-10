import { ComponentFixture, TestBed } from '@angular/core/testing';
import { Router } from '@angular/router';
import { Board } from '@app/classes/board';
import { Room } from '@app/interfaces/room';
import { CombatService } from '@app/services/combat.service';
import { GameManagerService } from '@app/services/game-manager.service';
import { SocketService } from '@app/services/socket.service';
import { of, Subject } from 'rxjs';
import { GamePlayComponent } from './game-play.component';

const countDownValue = 10;
const notificationDuration = 5000;

describe('GamePlayComponent', () => {
    let component: GamePlayComponent;
    let fixture: ComponentFixture<GamePlayComponent>;
    let mockGameManagerService: jasmine.SpyObj<GameManagerService>;
    let mockCombatService: jasmine.SpyObj<CombatService>;
    let mockRouter: jasmine.SpyObj<Router>;
    let mockSocketService: jasmine.SpyObj<SocketService>;
    let gameCountdownSubject: Subject<number>;
    let combatCountdownSubject: Subject<number>;

    beforeEach(async () => {
        // Create mock subjects for observables
        gameCountdownSubject = new Subject<number>();
        combatCountdownSubject = new Subject<number>();

        // Create mock board and game
        const mockBoard = jasmine.createSpyObj('Board', ['getCell', 'getPlayerById']);
        const mockGame = jasmine.createSpyObj('Game', [], { board: mockBoard });
        const mockRoom: Room = {
            roomId: 'test-room',
            organisatorId: 'test-organizer',
            gameId: 'test-game',
            players: [],
            isLocked: false,
            isDebugging: false,
        };

        // Create mock services
        mockGameManagerService = jasmine.createSpyObj(
            'GameManagerService',
            ['getBoard', 'getIsGameLoaded', 'loadGame', 'addPlayersToBoard', 'getPlayers'],
            {
                room: mockRoom,
                gameCountdown: gameCountdownSubject,
                isNotificationVisible: false,
                notificationMessage: 'Test notification',
                notificationDuration: 3000,
                isGameCanceled: false,
                isGameFinished: false,
            },
        );
        mockGameManagerService.getBoard.and.returnValue(mockBoard);
        mockGameManagerService.getIsGameLoaded.and.returnValue(false);
        mockGameManagerService.loadGame.and.returnValue(of(mockGame));
        mockGameManagerService.getPlayers.and.returnValue([]);

        mockCombatService = jasmine.createSpyObj('CombatService', ['getCombatMode'], {
            combatCountdown: combatCountdownSubject,
            flightAttemptsLeft: 2,
            isCombatPlayerTurn: true,
        });
        mockCombatService.getCombatMode.and.returnValue(false);

        mockRouter = jasmine.createSpyObj('Router', ['navigate']);
        mockSocketService = jasmine.createSpyObj('SocketService', ['toggleDebugMode']);

        await TestBed.configureTestingModule({
            imports: [GamePlayComponent],
            providers: [
                { provide: GameManagerService, useValue: mockGameManagerService },
                { provide: CombatService, useValue: mockCombatService },
                { provide: Router, useValue: mockRouter },
                { provide: SocketService, useValue: mockSocketService },
            ],
        }).compileComponents();

        fixture = TestBed.createComponent(GamePlayComponent);
        component = fixture.componentInstance;
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });

    describe('ngOnInit', () => {
        it('should set isGameLoaded to true if game is already loaded', () => {
            mockGameManagerService.getIsGameLoaded.and.returnValue(true);
            mockGameManagerService.room.gameId = 'test-game';

            component.ngOnInit();

            expect(component.isGameLoaded).toBeTrue();
            expect(mockGameManagerService.loadGame).not.toHaveBeenCalled();
        });

        it('should load game if not already loaded and gameId exists', () => {
            mockGameManagerService.getIsGameLoaded.and.returnValue(false);
            mockGameManagerService.room.gameId = 'test-game';

            component.ngOnInit();

            expect(mockGameManagerService.loadGame).toHaveBeenCalled();
            expect(component.isGameLoaded).toBeTrue();
            expect(mockGameManagerService.addPlayersToBoard).toHaveBeenCalled();
        });

        it('should set showError to true if gameId does not exist', () => {
            mockGameManagerService.getIsGameLoaded.and.returnValue(false);
            mockGameManagerService.room.gameId = '';

            component.ngOnInit();

            expect(component.showError).toBeTrue();
            expect(mockGameManagerService.loadGame).not.toHaveBeenCalled();
        });

        it('should subscribe to gameCountdown', () => {
            mockGameManagerService.getIsGameLoaded.and.returnValue(true);
            mockGameManagerService.room.gameId = 'test-game';

            component.ngOnInit();
            gameCountdownSubject.next(countDownValue);

            expect(component.gameCountdown).toBe(countDownValue);
        });

        it('should subscribe to combatCountdown', () => {
            mockGameManagerService.getIsGameLoaded.and.returnValue(true);
            mockGameManagerService.room.gameId = 'test-game';

            component.ngOnInit();
            combatCountdownSubject.next(countDownValue);

            expect(component.combatCountdown).toBe(countDownValue);
            expect(component.isTurnToFight).toBe(mockCombatService.isCombatPlayerTurn);
        });
    });

    describe('getters', () => {
        it('should get board from gameManagerService', () => {
            const mockBoard = new Board(countDownValue); // Create a 10x10 board
            mockGameManagerService.getBoard.and.returnValue(mockBoard);

            expect(component.board).toBe(mockBoard);
        });

        it('should get isCombatMode from combatService', () => {
            mockCombatService.getCombatMode.and.returnValue(true);

            expect(component.isCombatMode).toBeTrue();
            expect(mockCombatService.getCombatMode).toHaveBeenCalled();
        });

        it('should get flightAttemptsLeft from combatService', () => {
            expect(component.flightAttemptsLeft).toBe(2);
        });

        it('should get isNotificationVisible from gameManagerService', () => {
            // Set the property before testing the getter
            Object.defineProperty(mockGameManagerService, 'isNotificationVisible', { get: () => true });

            expect(component.isNotificationVisible).toBeTrue();
        });

        it('should get notificationMessage from gameManagerService', () => {
            // Set the property before testing the getter
            Object.defineProperty(mockGameManagerService, 'notificationMessage', { get: () => 'Test message' });

            expect(component.notificationMessage).toBe('Test message');
        });

        it('should get notificationDuration from gameManagerService', () => {
            // Set the property before testing the getter
            Object.defineProperty(mockGameManagerService, 'notificationDuration', { get: () => notificationDuration });

            expect(component.notificationDuration).toBe(notificationDuration);
        });

        it('should get isGameCanceled from gameManagerService', () => {
            // Set the property before testing the getter
            Object.defineProperty(mockGameManagerService, 'isGameCanceled', { get: () => true });

            expect(component.isGameCanceled).toBeTrue();
        });

        it('should get isGameFinished from gameManagerService', () => {
            // Set the property before testing the getter
            Object.defineProperty(mockGameManagerService, 'isGameFinished', { get: () => true });

            expect(component.isGameFinished).toBeTrue();
        });

        it('should get isDebugging from gameManagerService room', () => {
            // Set the property before testing the getter
            Object.defineProperty(mockGameManagerService.room, 'isDebugging', { get: () => true });

            expect(component.isDebugging).toBeTrue();
        });
    });

    describe('onKeyDown', () => {
        it('should toggle debug mode when d key is pressed', () => {
            const keyEvent = new KeyboardEvent('keydown', { key: 'd' });

            component.onKeyDown(keyEvent);

            expect(mockSocketService.toggleDebugMode).toHaveBeenCalled();
        });

        it('should not toggle debug mode when other keys are pressed', () => {
            const keyEvent = new KeyboardEvent('keydown', { key: 'a' });

            component.onKeyDown(keyEvent);

            expect(mockSocketService.toggleDebugMode).not.toHaveBeenCalled();
        });
    });

    describe('goBackToMenu', () => {
        it('should navigate to home page', () => {
            component.goBackToMenu();

            expect(mockRouter.navigate).toHaveBeenCalledWith(['/home']);
        });
    });
});

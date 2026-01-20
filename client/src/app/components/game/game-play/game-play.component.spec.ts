import { ComponentFixture, TestBed } from '@angular/core/testing';
import { Router } from '@angular/router';
import { Board } from '@app/classes/board/board';
import { Item } from '@app/classes/entity/item';
import { Room } from '@app/interfaces/room.interface';
import { CombatService } from '@app/services/gameplay/combat.service';
import { GameManagerService } from '@app/services/state/game-manager.service';
import { SocketService } from '@app/services/communication/socket-handlers/socket.service';
import { ActionSocketService } from '@app/services/communication/socket-handlers/action-socket.service';
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
    let mockActionSocketService: jasmine.SpyObj<ActionSocketService>;
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
            hostId: 'test-host',
            gameId: 'test-game',
            players: [],
            isLocked: false,
            isDebugging: false,
        };

        // Create mock services
        mockGameManagerService = jasmine.createSpyObj(
            'GameManagerService',
            ['getBoard', 'getIsGameLoaded', 'loadGame', 'addPlayersToBoard', 'getPlayers', 'hasWon', 'getWinner', 'processReplacement'],
            {
                room: mockRoom,
                gameCountdown: gameCountdownSubject,
                isNotificationVisible: false,
                notificationMessage: 'Test notification',
                notificationTime: 3000,
                isGameCanceled: false,
                isGameFinished: false,
            },
        );
        mockGameManagerService.getBoard.and.returnValue(mockBoard);
        mockGameManagerService.getIsGameLoaded.and.returnValue(false);
        mockGameManagerService.loadGame.and.returnValue(of(mockGame));
        mockGameManagerService.getPlayers.and.returnValue([]);
        mockGameManagerService.hasWon.and.returnValue(false);
        mockGameManagerService.getWinner.and.returnValue('Player1');

        mockCombatService = jasmine.createSpyObj('CombatService', ['getCombatMode'], {
            combatCountdown: combatCountdownSubject,
            flightAttemptsLeft: 2,
            isCombatPlayerTurn: true,
        });
        mockCombatService.getCombatMode.and.returnValue(false);

        mockRouter = jasmine.createSpyObj('Router', ['navigate']);
        mockSocketService = jasmine.createSpyObj('SocketService', ['toggleDebugMode', 'dropItem']);
        mockActionSocketService = jasmine.createSpyObj('ActionSocketService', ['toggleDebugMode']);

        await TestBed.configureTestingModule({
            imports: [GamePlayComponent],
            providers: [
                { provide: GameManagerService, useValue: mockGameManagerService },
                { provide: CombatService, useValue: mockCombatService },
                { provide: Router, useValue: mockRouter },
                { provide: SocketService, useValue: mockSocketService },
                { provide: ActionSocketService, useValue: mockActionSocketService },
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

        it('should handle game countdown subscription', () => {
            const testCount = 120;
            component.ngOnInit();
            gameCountdownSubject.next(testCount);
            expect(component.gameCountdown).toBe(testCount);
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

        it('should get notificationTime from gameManagerService', () => {
            // Set the property before testing the getter
            Object.defineProperty(mockGameManagerService, 'notificationTime', { get: () => notificationDuration });

            expect(component.notificationTime).toBe(notificationDuration);
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

        it('should get isPopUpVisible from gameManagerService', () => {
            // Set the property before testing the getter
            Object.defineProperty(mockGameManagerService, 'isReplacementPopupVisible', { get: () => true });

            expect(component.isPopUpVisible).toBeTrue();
        });

        it('should get replaceMessage from gameManagerService', () => {
            const testMessage = 'Test replacement message';
            // Set the property before testing the getter
            Object.defineProperty(mockGameManagerService, 'replacementPopupMessage', { get: () => testMessage });

            expect(component.replaceMessage).toBe(testMessage);
        });

        it('should get candidateItems from gameManagerService pendingReplacement', () => {
            const mockItems = [new Item('adrenaline'), new Item('vodka')];
            // Set the property before testing the getter
            Object.defineProperty(mockGameManagerService, 'pendingReplacement', {
                get: () => ({ candidateItems: mockItems }),
            });

            expect(component.candidateItems).toEqual(mockItems);
        });

        it('should return undefined for candidateItems when pendingReplacement is null', () => {
            // Set the property before testing the getter
            Object.defineProperty(mockGameManagerService, 'pendingReplacement', {
                get: () => null,
            });

            expect(component.candidateItems).toBeUndefined();
        });
    });

    describe('onKeyDown', () => {
        it('should toggle debug mode when d key is pressed', () => {
            const keyEvent = new KeyboardEvent('keydown', { key: 'd' });

            component.onKeyDown(keyEvent);

            expect(mockActionSocketService.toggleDebugMode).toHaveBeenCalled();
        });

        it('should not toggle debug mode when other keys are pressed', () => {
            const keyEvent = new KeyboardEvent('keydown', { key: 'a' });

            component.onKeyDown(keyEvent);

            expect(mockActionSocketService.toggleDebugMode).not.toHaveBeenCalled();
        });
    });

    describe('goBackToMenu', () => {
        it('should navigate to home page', () => {
            component.goBackToMenu();

            expect(mockRouter.navigate).toHaveBeenCalledWith(['/home']);
        });
    });

    describe('onItemReplacement', () => {
        it('should process replacement and drop the item', () => {
            // Create a mock item
            const selectedItem = new Item('adrenaline');
            const mockToDrop = new Item('vodka');
            const mockCoords = { x: 5, y: 5 };

            // Set up the mock to return the expected values
            mockGameManagerService.processReplacement = jasmine.createSpy('processReplacement').and.returnValue([mockToDrop, mockCoords]);

            // Call the method
            component.onItemReplacement(selectedItem);

            // Verify the service methods were called correctly
            expect(mockGameManagerService.processReplacement).toHaveBeenCalledWith(selectedItem);
            expect(mockSocketService.dropItem).toHaveBeenCalledWith(mockToDrop, mockCoords);
        });
    });

    describe('generateEndMessage', () => {
        beforeEach(() => {
            // Reset spies before each test
            mockGameManagerService.hasWon.calls.reset();
            mockGameManagerService.getWinner.calls.reset();
        });

        it('should generate win message for CTF mode', () => {
            mockGameManagerService.hasWon.and.returnValue(true);
            Object.defineProperty(mockGameManagerService, 'isCTF', { get: () => true });
            mockGameManagerService.getWinner.and.returnValue('USSR');

            const message = component.generateEndMessage();
            expect(message).toBe('Victoire! Ton équipe a capturé le drapeau !');
        });

        it('should generate win message for classic mode', () => {
            mockGameManagerService.hasWon.and.returnValue(true);
            Object.defineProperty(mockGameManagerService, 'isCTF', { get: () => false });
            mockGameManagerService.getWinner.and.returnValue('Player1');

            const message = component.generateEndMessage();
            expect(message).toBe('Victoire! Tu as gagné trois combats');
        });

        it('should generate lose message for CTF mode', () => {
            mockGameManagerService.hasWon.and.returnValue(false);
            Object.defineProperty(mockGameManagerService, 'isCTF', { get: () => true });
            mockGameManagerService.getWinner.and.returnValue('USA');

            const message = component.generateEndMessage();
            expect(message).toBe("Défaite! L'équipe USA a capturé le drapeau !");
        });

        it('should generate lose message for classic mode', () => {
            mockGameManagerService.hasWon.and.returnValue(false);
            Object.defineProperty(mockGameManagerService, 'isCTF', { get: () => false });
            mockGameManagerService.getWinner.and.returnValue('Player2');

            const message = component.generateEndMessage();
            expect(message).toBe('Défaite! Player2 a gagné trois combats');
        });
    });
});

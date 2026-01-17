/* eslint-disable max-lines */
import { provideHttpClientTesting } from '@angular/common/http/testing';
import { ComponentFixture, fakeAsync, TestBed, tick } from '@angular/core/testing';
import { Cell } from '@app/classes/cell';
import { Item } from '@app/classes/item';
import { Player } from '@app/classes/player';
import { Tile } from '@app/classes/tile';
import { BonusType } from '@app/constants/bonus.constants';
import { CombatState } from '@app/constants/combat.constants';
import { Room } from '@app/interfaces/room';
import { ActionService } from '@app/services/action.service';
import { CombatService } from '@app/services/combat.service';
import { GameManagerService } from '@app/services/game-manager.service';
import { SocketService } from '@app/services/socket.service';
import { ActionSocketService } from '@app/services/socket/action-socket.service';
import { of, Subject } from 'rxjs';
import { Socket } from 'socket.io-client';
import { CombatComponent } from './combat.component';

describe('CombatComponent', () => {
    let component: CombatComponent;
    let fixture: ComponentFixture<CombatComponent>;
    let actionServiceSpy: jasmine.SpyObj<ActionService>;
    let combatServiceSpy: jasmine.SpyObj<CombatService>;
    let socketServiceSpy: jasmine.SpyObj<SocketService>;
    let gameManagerServiceSpy: jasmine.SpyObj<GameManagerService>;
    let actionSocketServiceSpy: jasmine.SpyObj<ActionSocketService>;

    beforeEach(async () => {
        actionServiceSpy = jasmine.createSpyObj(
            'ActionService',
            ['interact', 'setSelectionActive', 'getIsSelectionActive', 'toggleAction', 'toggleSelection', 'getIsActionActive'],
            {
                selectedCell$: of(null),
            },
        );
        actionServiceSpy.getIsSelectionActive.and.returnValue(true);
        actionServiceSpy.getIsActionActive.and.returnValue(true);

        combatServiceSpy = jasmine.createSpyObj(
            'CombatService',
            ['getCombatMode', 'getEnemy', 'toggleCombatMode', 'setEnemy', 'startCombat', 'attack', 'flight', 'setCombatMode', 'resetCombat'],
            {
                combatStateChange: new Subject(),
            },
        );

        socketServiceSpy = jasmine.createSpyObj(
            'SocketService',
            ['attack', 'flightAttempt', 'startCombat', 'endPlayerTurn', 'registerSocketService'],
            {
                attackTrigger: new Subject(),
            },
        );

        actionSocketServiceSpy = jasmine.createSpyObj(
            'ActionSocketService',
            ['setUpConnection', 'toggleDebugMode', 'startCombat', 'flightAttempt', 'attack', 'toggleDoor'],
            {
                attackTrigger: new Subject(),
            },
        );
        actionSocketServiceSpy.socket = {} as Socket;

        gameManagerServiceSpy = jasmine.createSpyObj('GameManagerService', ['getMainPlayer', 'getRoomId', 'isPlayerMoving'], {
            turnChange: new Subject(),
        });
        gameManagerServiceSpy.isPlayerMoving.and.returnValue(false);
        gameManagerServiceSpy.turnChange = new Subject<void>();

        combatServiceSpy.getCombatMode.and.returnValue(false);
        combatServiceSpy.getEnemy.and.returnValue(null);
        Object.defineProperty(actionServiceSpy, 'selectedCell$', {
            get: () => of(null),
        });

        await TestBed.configureTestingModule({
            imports: [CombatComponent],
            providers: [
                provideHttpClientTesting(),
                { provide: ActionService, useValue: actionServiceSpy },
                { provide: CombatService, useValue: combatServiceSpy },
                { provide: SocketService, useValue: socketServiceSpy },
                { provide: GameManagerService, useValue: gameManagerServiceSpy },
                { provide: ActionSocketService, useValue: actionSocketServiceSpy },
            ],
        }).compileComponents();

        fixture = TestBed.createComponent(CombatComponent);
        component = fixture.componentInstance;

        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });

    it('should initialize showButtons based on isPlayerTurn', () => {
        // Create a fresh spy object for each test case to avoid property redefinition errors
        let localGameManagerSpy = jasmine.createSpyObj('GameManagerService', ['getMainPlayer', 'getRoomId', 'isPlayerMoving'], {
            turnChange: new Subject(),
            canEndTurn: false,
        });

        // Test with isPlayerTurn = true
        Object.defineProperty(localGameManagerSpy, 'isPlayerTurn', {
            get: () => true,
            configurable: true,
        });

        // Add setter for canEndTurn to handle initialization in component
        Object.defineProperty(localGameManagerSpy, 'canEndTurn', {
            get: () => true,
            // eslint-disable-next-line @typescript-eslint/no-empty-function
            set: () => {},
            configurable: true,
        });

        TestBed.resetTestingModule();
        TestBed.configureTestingModule({
            imports: [CombatComponent],
            providers: [
                provideHttpClientTesting(),
                { provide: ActionService, useValue: actionServiceSpy },
                { provide: CombatService, useValue: combatServiceSpy },
                { provide: SocketService, useValue: socketServiceSpy },
                { provide: GameManagerService, useValue: localGameManagerSpy },
                { provide: ActionSocketService, useValue: actionSocketServiceSpy },
            ],
        }).compileComponents();

        let localFixture = TestBed.createComponent(CombatComponent);
        let localComponent = localFixture.componentInstance;
        localFixture.detectChanges();

        expect(localComponent.showButtons).toBeTrue();

        // Test with isPlayerTurn = false
        localGameManagerSpy = jasmine.createSpyObj('GameManagerService', ['getMainPlayer', 'getRoomId', 'isPlayerMoving'], {
            turnChange: new Subject(),
            canEndTurn: false,
        });

        Object.defineProperty(localGameManagerSpy, 'isPlayerTurn', {
            get: () => false,
            configurable: true,
        });

        // Add setter for canEndTurn to handle initialization in component
        Object.defineProperty(localGameManagerSpy, 'canEndTurn', {
            get: () => false,
            // eslint-disable-next-line @typescript-eslint/no-empty-function
            set: () => {},
            configurable: true,
        });

        TestBed.resetTestingModule();
        TestBed.configureTestingModule({
            imports: [CombatComponent],
            providers: [
                provideHttpClientTesting(),
                { provide: ActionService, useValue: actionServiceSpy },
                { provide: CombatService, useValue: combatServiceSpy },
                { provide: SocketService, useValue: socketServiceSpy },
                { provide: GameManagerService, useValue: localGameManagerSpy },
                { provide: ActionSocketService, useValue: actionSocketServiceSpy },
            ],
        }).compileComponents();

        localFixture = TestBed.createComponent(CombatComponent);
        localComponent = localFixture.componentInstance;
        localFixture.detectChanges();

        expect(localComponent.showButtons).toBeFalse();
    });

    it('should call actionService.toggleAction when toggleAction is called', () => {
        component.toggleAction();
        expect(actionServiceSpy.toggleAction).toHaveBeenCalled();
    });

    it('should call actionService.toggleSelection when toggleSelection is called', () => {
        component.toggleSelection();
        expect(actionServiceSpy.toggleSelection).toHaveBeenCalled();
    });

    it('should set cellReference to the placeholder image when setCellReference is called with a null cell', () => {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        (component as any).setCellReference(null);
        expect(component.cellReference).toBe('./assets/combat/placeholder.png');
    });

    it('should set cellReference to the door closed image when setCellReference is called with a cell with a closed door', () => {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        (component as any).setCellReference({ tile: new Tile('door'), x: 0, y: 0 } as Cell);
        expect(component.cellReference).toBe('./assets/combat/door_closed.png');
    });

    it('should set cellReference to the door open image when setCellReference is called with a cell with an open door', () => {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        (component as any).setCellReference({ tile: new Tile('door', '', 'opened'), x: 0, y: 0 } as Cell);
        expect(component.cellReference).toBe('./assets/combat/door_open.png');
    });

    it('should set player on the cell as enemy', () => {
        const enemyMock = new Player('enemy');
        const cell = { tile: new Tile('ice'), x: 0, y: 0, player: enemyMock } as Cell;

        combatServiceSpy.getEnemy.and.returnValue(enemyMock);

        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        (component as any).setCellReference(cell);

        // The setEnemy method is commented out in the component, so we shouldn't expect it to be called
        // expect(combatServiceSpy.setEnemy).toHaveBeenCalledWith(enemyMock);
        expect(component.enemy).toBe(enemyMock);
    });

    it('should clearTimeout if a timeout is given', () => {
        const clearTimeoutSpy = spyOn(window, 'clearTimeout');

        // eslint-disable-next-line @typescript-eslint/no-empty-function
        const timeoutId = setTimeout(() => {}, 1000);
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        (component as any).notificationTimeout = timeoutId;
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        (component as any).displayNotification('ok', 'ok', true);

        expect(clearTimeoutSpy).toHaveBeenCalledWith(timeoutId);
        expect(clearTimeoutSpy).toHaveBeenCalledTimes(1);
    });

    it('should reset notification state after the timeout expires', fakeAsync(() => {
        component.isWinLossNotification = true;
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        (component as any).displayNotification('Test Title', 'Test Message', true, 800);

        expect(component.showNotification).toBeTrue();

        tick(800);

        expect(component.showNotification).toBeFalse();
        expect(component.isWinLossNotification).toBeFalse();
    }));
    it('should correctly end turn', () => {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const displaySpy = spyOn(component as any, 'displayNotification');
        component.endTurn();
        expect(socketServiceSpy.endPlayerTurn).toHaveBeenCalled();
        expect(displaySpy).toHaveBeenCalled();
    });

    it('should return early when player is moving', () => {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const displaySpy = spyOn(component as any, 'displayNotification');
        gameManagerServiceSpy.isPlayerMoving.and.returnValue(true);
        component.endTurn();
        expect(socketServiceSpy.endPlayerTurn).not.toHaveBeenCalled();
        expect(displaySpy).not.toHaveBeenCalled();
    });

    it('should return the correct value for isCombatInitiator', () => {
        combatServiceSpy.isCombatInitiator = true;
        expect(component.isCombatInitiator).toBeTrue();

        combatServiceSpy.isCombatInitiator = false;
        expect(component.isCombatInitiator).toBeFalse();
    });

    it('should correctly reset fight', () => {
        const clearTimeoutSpy = spyOn(window, 'clearTimeout');
        // eslint-disable-next-line @typescript-eslint/no-empty-function
        const timeoutId = setTimeout(() => {}, 1000);
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        (component as any).notificationTimeout = timeoutId;
        component.resetCombat();

        expect(clearTimeoutSpy).toHaveBeenCalledWith(timeoutId);

        // Create a new component without a timeout
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        (component as any).notificationTimeout = undefined as unknown as ReturnType<typeof setTimeout>;

        // Reset the spy
        clearTimeoutSpy.calls.reset();

        // Call resetCombat again
        component.resetCombat();

        expect(combatServiceSpy.resetCombat).toHaveBeenCalled();
        expect(component.showNotification).toEqual(false);
        expect(component.isWinLossNotification).toEqual(false);
        // Should not call clearTimeout when there's no timeout
        expect(clearTimeoutSpy).not.toHaveBeenCalled();
    });

    describe('attack', () => {
        let enemy: Player;
        let player: Player;

        beforeEach(() => {
            // Create a test enemy and player.
            enemy = new Player('enemy');
            enemy.id = 'enemyId';
            enemy.setStatValue(BonusType.Defense, 4);
            // We'll simulate roll methods later.
            player = new Player('player');
            player.id = 'playerId';
            player.setStatValue(BonusType.Attack, 4);

            // Force gameManagerService.getMainPlayer() to return our test player.
            gameManagerServiceSpy.getMainPlayer.and.returnValue(player);
            (combatServiceSpy.getEnemy as jasmine.Spy).and.returnValue(enemy);
        });

        describe('Non-debug mode', () => {
            beforeEach(() => {
                gameManagerServiceSpy.room = { isDebugging: false } as unknown as Room;
            });

            it('should call socketService.attack when attack payload exists', () => {
                spyOn(enemy, 'rollStat').and.returnValue(4);
                spyOn(player, 'rollStat').and.returnValue(4);
                const payload = { roomId: 'room123', attackValue: 4, defenseValue: 4 };
                combatServiceSpy.attack.and.returnValue(payload);
                component.attack();
                expect(enemy.rollStat).toHaveBeenCalledWith(BonusType.Defense);
                expect(player.rollStat).toHaveBeenCalledWith(BonusType.Attack);
                expect(combatServiceSpy.attack).toHaveBeenCalledWith(4, 4);
                expect(actionSocketServiceSpy.attack).toHaveBeenCalledWith(payload);
            });

            it('should not call socketService.attack if attack payload is null', () => {
                spyOn(enemy, 'rollStat').and.returnValue(4);
                spyOn(player, 'rollStat').and.returnValue(4);
                combatServiceSpy.attack.and.returnValue(null);
                component.attack();
                expect(actionSocketServiceSpy.attack).not.toHaveBeenCalled();
            });
        });

        describe('Debug mode', () => {
            beforeEach(() => {
                // Simulate debug mode.
                gameManagerServiceSpy.room = { isDebugging: true } as unknown as Room;
            });

            it('should call socketService.attack when attack payload exists', () => {
                // Spy on enemy.rollStatDebug and player.rollStatDebug.
                spyOn(enemy, 'rollStatDebug').and.returnValue(6);
                spyOn(player, 'rollStatDebug').and.returnValue(6);
                const payload = { roomId: 'room123', attackValue: 6, defenseValue: 6 };
                combatServiceSpy.attack.and.returnValue(payload);
                component.attack();
                expect(enemy.rollStatDebug).toHaveBeenCalledWith(BonusType.Defense);
                expect(player.rollStatDebug).toHaveBeenCalledWith(BonusType.Attack);
                expect(combatServiceSpy.attack).toHaveBeenCalledWith(6, 6);
                expect(actionSocketServiceSpy.attack).toHaveBeenCalledWith(payload);
            });

            it('should not call socketService.attack if attack payload is null', () => {
                spyOn(enemy, 'rollStatDebug').and.returnValue(6);
                spyOn(player, 'rollStatDebug').and.returnValue(6);
                combatServiceSpy.attack.and.returnValue(null);
                component.attack();
                expect(actionSocketServiceSpy.attack).not.toHaveBeenCalled();
            });
        });
    });

    describe('getVirtualPlayerAttack', () => {
        let enemy: Player;
        let player: Player;

        beforeEach(() => {
            // Create a test enemy and player.
            enemy = new Player('enemy');
            enemy.id = 'enemyId';
            enemy.setStatValue(BonusType.Attack, 4);

            player = new Player('player');
            player.id = 'playerId';
            player.setStatValue(BonusType.Defense, 4);

            // Force gameManagerService.getMainPlayer() to return our test player.
            gameManagerServiceSpy.getMainPlayer.and.returnValue(player);
            (combatServiceSpy.getEnemy as jasmine.Spy).and.returnValue(enemy);

            // Set combatRoomId for the attack payload
            Object.defineProperty(combatServiceSpy, 'combatRoomId', {
                get: () => 'room123',
            });
        });

        describe('Non-debug mode', () => {
            beforeEach(() => {
                gameManagerServiceSpy.room = { isDebugging: false } as unknown as Room;
            });

            it('should call actionSocketService.attack with correct payload', () => {
                spyOn(player, 'rollStat').and.returnValue(3);
                spyOn(enemy, 'rollStat').and.returnValue(5);

                component.getVirtualPlayerAttack();

                expect(player.rollStat).toHaveBeenCalledWith(BonusType.Defense);
                expect(enemy.rollStat).toHaveBeenCalledWith(BonusType.Attack);
                expect(actionSocketServiceSpy.attack).toHaveBeenCalledWith({
                    roomId: 'room123',
                    attackValue: 5,
                    defenseValue: 3,
                });
            });
        });

        describe('Debug mode', () => {
            beforeEach(() => {
                gameManagerServiceSpy.room = { isDebugging: true } as unknown as Room;
            });

            it('should call actionSocketService.attack with correct payload using debug values', () => {
                spyOn(player, 'rollStatDebug').and.returnValue(2);
                spyOn(enemy, 'rollStatDebug').and.returnValue(6);

                component.getVirtualPlayerAttack();

                expect(player.rollStatDebug).toHaveBeenCalledWith(BonusType.Defense);
                expect(enemy.rollStatDebug).toHaveBeenCalledWith(BonusType.Attack);
                expect(actionSocketServiceSpy.attack).toHaveBeenCalledWith({
                    roomId: 'room123',
                    attackValue: 6,
                    defenseValue: 2,
                });
            });
        });
    });

    describe('Getters', () => {
        it('should get the main player', () => {
            const expectedPlayer = new Player('mainPlayer');
            gameManagerServiceSpy.getMainPlayer.and.returnValue(expectedPlayer);

            expect(component.player).toBe(expectedPlayer);
        });

        it('should get the combat state', () => {
            const expectedState = CombatState.Idle;
            combatServiceSpy.combatState = expectedState;

            expect(component.combatState).toBe(expectedState);
        });

        it('should return if the player still has fight attempts', () => {
            let attemptsLeft = 2;
            combatServiceSpy.flightAttemptsLeft = attemptsLeft;
            expect(component.hasFlightAttempts).toBe(true);

            attemptsLeft = 0;
            combatServiceSpy.flightAttemptsLeft = attemptsLeft;
            expect(component.hasFlightAttempts).toBe(false);
        });

        it('should return the enemy stat', () => {
            const expectedHealth = 6;
            const enemy = new Player('enemy');
            enemy.stats['health'].value = expectedHealth;
            combatServiceSpy.getEnemy.and.returnValue(enemy);
            expect(component.getEnemyStat('health')).toEqual(expectedHealth);
        });
    });

    describe('showCombatNotification', () => {
        beforeEach(() => {
            // Mock the player and enemy for the notification tests
            gameManagerServiceSpy.getMainPlayer.and.returnValue(new Player('Player'));
            combatServiceSpy.getEnemy.and.returnValue(new Player('Enemy'));

            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            spyOn(component as any, 'displayNotification').and.callThrough();
            component.isWinLossNotification = false;
        });

        it('should return early if enemy is null', () => {
            combatServiceSpy.getEnemy.and.returnValue(null);
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (component as any).showCombatNotification('hit');
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            expect((component as any).displayNotification).not.toHaveBeenCalled();
        });

        it('should return early if player is null', () => {
            gameManagerServiceSpy.getMainPlayer.and.returnValue(null);
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (component as any).showCombatNotification('hit');
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            expect((component as any).displayNotification).not.toHaveBeenCalled();
        });

        it('should display "Raté!" notification for state "miss"', () => {
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (component as any).showCombatNotification('miss');
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            expect((component as any).displayNotification).toHaveBeenCalledWith('Raté!', '', false, 800);
        });

        it('should display hit notification for state "hit"', () => {
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (component as any).attackValue = 10;
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (component as any).defenseValue = 3;
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (component as any).showCombatNotification('hit');
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            expect((component as any).displayNotification).toHaveBeenCalledWith('-7', '', true, 800);
        });

        it('should display getHit notification for state "getHit"', () => {
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (component as any).attackValue = 10;
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (component as any).defenseValue = 3;
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (component as any).showCombatNotification('getHit');
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            expect((component as any).displayNotification).toHaveBeenCalledWith('-7', '', false, 800);
        });

        it('should display "Esquivé!" notification for state "getMissed"', () => {
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (component as any).showCombatNotification('getMissed');
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            expect((component as any).displayNotification).toHaveBeenCalledWith('Esquivé!', '', true, 800);
        });

        it('should display FlightSuccess notification for state FlightSuccess', () => {
            gameManagerServiceSpy.getMainPlayer.and.returnValue(new Player('Player'));
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (component as any).showCombatNotification('flightSuccess');
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            expect((component as any).displayNotification).toHaveBeenCalledWith('Tentative de fuite !', 'Vous avez réussi à fuir!', true, 3000);
        });

        it('should display FlightFailure notification for state FlightFailure', () => {
            gameManagerServiceSpy.getMainPlayer.and.returnValue(new Player('Player'));
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (component as any).showCombatNotification('flightFailure');
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            expect((component as any).displayNotification).toHaveBeenCalledWith(
                'Tentative de fuite !',
                "Vous n'avez pas réussi à fuir!",
                false,
                3000,
            );
        });

        it('should display flight success notification when won with wasFlightEnd true', () => {
            const player = new Player('Player');
            gameManagerServiceSpy.getMainPlayer.and.returnValue(player);

            // Set wasFlightEnd to true
            combatServiceSpy.wasFlightEnd = true;

            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (component as any).showCombatNotification('won');

            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            expect((component as any).displayNotification).toHaveBeenCalledWith(
                'Tentative de fuite réussie!',
                `${player.name} a réussi à fuir!`,
                true,
                3000,
            );
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            expect((component as any).isWinLossNotification).toBeTrue();
        });

        it('should display flight success notification when lost with wasFlightEnd true', () => {
            const player = new Player('Player');
            gameManagerServiceSpy.getMainPlayer.and.returnValue(player);

            // Set wasFlightEnd to true
            combatServiceSpy.wasFlightEnd = true;

            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (component as any).showCombatNotification('lost');

            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            expect((component as any).displayNotification).toHaveBeenCalledWith(
                'Tentative de fuite réussie!',
                `${player.name} a réussi à fuir!`,
                false,
                3000,
            );
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            expect((component as any).isWinLossNotification).toBeTrue();
        });

        it('should display victory notification for state "won" with wasFlightEnd false', () => {
            const player = new Player('Player');
            gameManagerServiceSpy.getMainPlayer.and.returnValue(player);

            // Set wasFlightEnd to false
            combatServiceSpy.wasFlightEnd = false;

            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (component as any).showCombatNotification('won');

            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            expect((component as any).displayNotification).toHaveBeenCalledWith('Victoire!', `${player.name} a gagné le combat!`, true, 3000);
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            expect((component as any).isWinLossNotification).toBeTrue();
        });

        it('should display defeat notification for state "lost" with wasFlightEnd false', () => {
            const enemy = new Player('Enemy');
            combatServiceSpy.getEnemy.and.returnValue(enemy);

            // Set wasFlightEnd to false
            combatServiceSpy.wasFlightEnd = false;

            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (component as any).showCombatNotification('lost');

            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            expect((component as any).displayNotification).toHaveBeenCalledWith('Défaite', `${enemy.name} a gagné le combat!`, false, 3000);
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            expect((component as any).isWinLossNotification).toBeTrue();
        });

        it('should return without calling displayNotification for an unknown state', () => {
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (component as any).showCombatNotification('unknown');
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            expect((component as any).displayNotification).not.toHaveBeenCalled();
        });
    });

    describe('Setters', () => {
        it('should set the correct attack and defense stats', () => {
            const attackStat = 4;
            const defenseStat = 6;

            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (component as any).attackValue = attackStat;
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (component as any).defenseValue = defenseStat;

            expect(combatServiceSpy.attackValue).toEqual(attackStat);
            expect(combatServiceSpy.defenseValue).toEqual(defenseStat);
        });
    });

    describe('Subscriptions', () => {
        it('should call attack() when socketService.attackTrigger emits', () => {
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (actionSocketServiceSpy as any).attackTrigger = new Subject<void>();

            // Mock isCombatPlayerTurn to return true
            Object.defineProperty(component, 'isCombatPlayerTurn', {
                get: () => true,
            });

            component.ngOnInit();

            const attackSpy = spyOn(component, 'attack');

            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (actionSocketServiceSpy as any).attackTrigger.next();

            expect(attackSpy).toHaveBeenCalled();
        });

        it('should call getVirtualPlayerAttack() when socketService.attackTrigger emits and it is not combat player turn', () => {
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (actionSocketServiceSpy as any).attackTrigger = new Subject<void>();

            // Mock isCombatPlayerTurn to return false to trigger the else branch
            Object.defineProperty(component, 'isCombatPlayerTurn', {
                get: () => false,
            });

            component.ngOnInit();

            const getVirtualPlayerAttackSpy = spyOn(component, 'getVirtualPlayerAttack');

            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (actionSocketServiceSpy as any).attackTrigger.next();

            expect(getVirtualPlayerAttackSpy).toHaveBeenCalled();
        });

        it('should call showCombatNotification when combatStateChange emits a state', () => {
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (combatServiceSpy as any).combatStateChange = new Subject<string>();

            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            spyOn(component as any, 'showCombatNotification');

            component.ngOnInit();

            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (combatServiceSpy as any).combatStateChange.next('hit');

            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            expect((component as any).showCombatNotification).toHaveBeenCalledWith('hit');
        });

        it('should call setSelectionActive when turnChange emits', () => {
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (gameManagerServiceSpy as any).turnChange = new Subject<string>();

            // Mock isPlayerTurn on gameManagerService instead of combatService
            Object.defineProperty(gameManagerServiceSpy, 'isPlayerTurn', {
                get: () => true,
            });

            component.ngOnInit();

            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (gameManagerServiceSpy as any).turnChange.next();

            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            expect(actionServiceSpy.toggleSelection).toHaveBeenCalled();
        });

        it('should set showButtons to false when turn changes and it is not the player turn', () => {
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (gameManagerServiceSpy as any).turnChange = new Subject<string>();

            // Mock isPlayerTurn to return false
            Object.defineProperty(gameManagerServiceSpy, 'isPlayerTurn', {
                get: () => false,
            });

            component.ngOnInit();

            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (gameManagerServiceSpy as any).turnChange.next();

            expect(component.showButtons).toBeFalse();
        });
    });

    describe('hasEnemyBarbedWire', () => {
        let enemy: Player;

        beforeEach(() => {
            enemy = new Player('enemy');
            combatServiceSpy.getEnemy.and.returnValue(enemy);
        });

        it('should return true when enemy has barbed wire in inventory', () => {
            enemy.inventory = [new Item('barbedWire'), null];
            expect(component.hasEnemyBarbedWire).toBeTrue();
        });

        it('should return false when enemy has no barbed wire in inventory', () => {
            enemy.inventory = [new Item('vodka'), null];
            expect(component.hasEnemyBarbedWire).toBeFalse();
        });

        it('should return false when enemy has empty inventory', () => {
            enemy.inventory = [null, null];
            expect(component.hasEnemyBarbedWire).toBeFalse();
        });

        it('should return false when enemy is null', () => {
            combatServiceSpy.getEnemy.and.returnValue(null);
            expect(component.hasEnemyBarbedWire).toBeFalse();
        });
    });

    it('should return the isSelectionActive from actionService', () => {
        expect(component.isSelectionActive).toBeTrue();
        expect(actionServiceSpy.getIsSelectionActive).toHaveBeenCalled();
    });

    it('should return the isActionActive from actionService', () => {
        expect(component.isActionActive).toBeTrue();
        expect(actionServiceSpy.getIsActionActive).toHaveBeenCalled();
    });

    describe('flight', () => {
        let enemy: Player;
        let displayNotificationSpy: jasmine.Spy;

        beforeEach(() => {
            enemy = new Player('enemy');
            combatServiceSpy.getEnemy.and.returnValue(enemy);
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            displayNotificationSpy = spyOn(component as any, 'displayNotification');
        });

        it('should prevent flight when enemy has barbed wire and player is not combat initiator', () => {
            enemy.inventory = [new Item('barbedWire'), null];
            spyOnProperty(component, 'isCombatInitiator', 'get').and.returnValue(false);

            component.flight();

            expect(displayNotificationSpy).toHaveBeenCalledWith('Barbed wire', "La fuite est empêché par l'adversaire", false);
            expect(combatServiceSpy.flight).not.toHaveBeenCalled();
        });

        it('should allow flight when enemy has barbed wire but player is combat initiator', () => {
            enemy.inventory = [new Item('barbedWire'), null];
            spyOnProperty(component, 'isCombatInitiator', 'get').and.returnValue(true);
            const flightInfo = { roomId: 'room1', opponentId: 'enemyId' };
            combatServiceSpy.flight.and.returnValue(flightInfo);

            component.flight();

            expect(displayNotificationSpy).not.toHaveBeenCalled();
            expect(combatServiceSpy.flight).toHaveBeenCalled();
            expect(actionSocketServiceSpy.flightAttempt).toHaveBeenCalledWith(flightInfo);
        });

        it('should allow flight when enemy has no barbed wire', () => {
            enemy.inventory = [new Item('vodka'), null];
            spyOnProperty(component, 'isCombatInitiator', 'get').and.returnValue(false);
            const flightInfo = { roomId: 'room1', opponentId: 'enemyId' };
            combatServiceSpy.flight.and.returnValue(flightInfo);

            component.flight();

            expect(displayNotificationSpy).not.toHaveBeenCalled();
            expect(combatServiceSpy.flight).toHaveBeenCalled();
            expect(actionSocketServiceSpy.flightAttempt).toHaveBeenCalledWith(flightInfo);
        });

        it('should not call socketService.flightAttempt when combatService.flight returns null', () => {
            enemy.inventory = [new Item('vodka'), null];
            spyOnProperty(component, 'isCombatInitiator', 'get').and.returnValue(false);
            combatServiceSpy.flight.and.returnValue(null);

            component.flight();

            expect(displayNotificationSpy).not.toHaveBeenCalled();
            expect(combatServiceSpy.flight).toHaveBeenCalled();
            expect(actionSocketServiceSpy.flightAttempt).not.toHaveBeenCalled();
        });
    });
});

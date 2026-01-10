/* eslint-disable max-lines */
import { provideHttpClientTesting } from '@angular/common/http/testing';
import { ComponentFixture, fakeAsync, TestBed, tick } from '@angular/core/testing';
import { Cell } from '@app/classes/cell';
import { Player } from '@app/classes/player';
import { Tile } from '@app/classes/tile';
import { BonusType } from '@app/constants/bonus.constants';
import { Room } from '@app/interfaces/room';
import { ActionService } from '@app/services/action.service';
import { CombatService } from '@app/services/combat.service';
import { GameManagerService } from '@app/services/game-manager.service';
import { SocketService } from '@app/services/socket.service';
import { of, Subject } from 'rxjs';
import { CombatComponent } from './combat.component';

/* eslint-disable @typescript-eslint/no-magic-numbers */
describe('CombatComponent', () => {
    let component: CombatComponent;
    let fixture: ComponentFixture<CombatComponent>;
    let actionServiceSpy: jasmine.SpyObj<ActionService>;
    let combatServiceSpy: jasmine.SpyObj<CombatService>;
    let socketServiceSpy: jasmine.SpyObj<SocketService>;
    let gameManagerServiceSpy: jasmine.SpyObj<GameManagerService>;

    beforeEach(async () => {
        actionServiceSpy = jasmine.createSpyObj('ActionService', ['interact', 'toggleSelection', 'setSelectionActive', 'getIsSelectionActive'], {
            selectedCell$: of(null),
        });

        combatServiceSpy = jasmine.createSpyObj(
            'CombatService',
            ['getCombatMode', 'getEnemy', 'toggleCombatMode', 'setEnemy', 'startCombat', 'attack', 'flight', 'setCombatMode', 'resetCombat'],
            {
                combatStateChange: new Subject(),
            },
        );

        socketServiceSpy = jasmine.createSpyObj('SocketService', ['attack', 'flightAttempt', 'startCombat', 'endPlayerTurn'], {
            attackTrigger: new Subject(),
        });
        gameManagerServiceSpy = jasmine.createSpyObj('GameManagerService', ['getMainPlayer', 'getRoomId']);

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
            ],
        }).compileComponents();

        fixture = TestBed.createComponent(CombatComponent);
        component = fixture.componentInstance;

        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });

    it('should call actionService.interact when interact is called', () => {
        component.interact();
        expect(actionServiceSpy.interact).toHaveBeenCalled();
    });

    it('should call actionService.toggleSelection when toggleSelection is called', () => {
        component.toggleSelection();
        expect(actionServiceSpy.toggleSelection).toHaveBeenCalled();
    });

    it('should set cellReference to the placeholder image when setCellReference is called with a null cell', () => {
        component.setCellReference(null);
        expect(component.cellReference).toBe('./assets/combat/placeholder.png');
    });

    it('should set cellReference to the door closed image when setCellReference is called with a cell with a closed door', () => {
        component.setCellReference({ tile: new Tile('door'), x: 0, y: 0 } as Cell);
        expect(component.cellReference).toBe('./assets/combat/door_closed.png');
    });

    it('should set cellReference to the door open image when setCellReference is called with a cell with an open door', () => {
        component.setCellReference({ tile: new Tile('door', '', 'opened'), x: 0, y: 0 } as Cell);
        expect(component.cellReference).toBe('./assets/combat/door_open.png');
    });

    it('should set player on the cell as enemy', () => {
        const enemyMock = new Player('enemy');
        const cell = { tile: new Tile('ice'), x: 0, y: 0, player: enemyMock } as Cell;

        combatServiceSpy.getEnemy.and.returnValue(enemyMock);

        component.setCellReference(cell);

        expect(combatServiceSpy.setEnemy).toHaveBeenCalledWith(enemyMock);
        expect(component.enemy).toBe(enemyMock);
    });

    describe('startCombat', () => {
        it('should return immediately if no enemy is defined', () => {
            spyOnProperty(component, 'enemy', 'get').and.returnValue(null);

            component.startCombat();

            expect(actionServiceSpy.setSelectionActive).not.toHaveBeenCalled();
            expect(combatServiceSpy.startCombat).not.toHaveBeenCalled();
            expect(socketServiceSpy.startCombat).not.toHaveBeenCalled();
        });

        it('should not call socketService.startCombat if combatService.startCombat returns null', () => {
            const enemy = new Player('enemy');
            spyOnProperty(component, 'enemy', 'get').and.returnValue(enemy);

            component.startCombat();

            expect(actionServiceSpy.setSelectionActive).toHaveBeenCalledWith(false);
            expect(combatServiceSpy.startCombat).toHaveBeenCalledWith(enemy);
            expect(socketServiceSpy.startCombat).not.toHaveBeenCalled();
        });

        it('should call socketService.startCombat when combatService.startCombat returns a payload', () => {
            const enemy = new Player('enemy');
            const payload = { roomId: 'room1', opponentId: enemy.id };
            spyOnProperty(component, 'enemy', 'get').and.returnValue(enemy);
            combatServiceSpy.startCombat.and.returnValue(payload);

            component.startCombat();

            expect(actionServiceSpy.setSelectionActive).toHaveBeenCalledWith(false);
            expect(combatServiceSpy.startCombat).toHaveBeenCalledWith(enemy);
            expect(socketServiceSpy.startCombat).toHaveBeenCalledWith(payload);
        });
    });

    it('should call flightAttempt when flightInfo exists and do nothing if flightInfo is null', () => {
        combatServiceSpy.flight.and.returnValue(null);
        component.flight();
        expect(socketServiceSpy.flightAttempt).not.toHaveBeenCalled();

        const payload = { roomId: 'combat123', opponentId: 'enemyId' };
        (combatServiceSpy.flight as jasmine.Spy).and.returnValue(payload);
        socketServiceSpy.flightAttempt.calls.reset();
        component.flight();
        expect(socketServiceSpy.flightAttempt).toHaveBeenCalledWith(payload);
    });

    it('should clearTimeout if a timeout is given', () => {
        const clearTimeoutSpy = spyOn(window, 'clearTimeout');

        // eslint-disable-next-line @typescript-eslint/no-empty-function
        const timeoutId = setTimeout(() => {}, 1000);
        component.notificationTimeout = timeoutId;
        component.displayNotification('ok', 'ok', true);

        expect(clearTimeoutSpy).toHaveBeenCalledWith(timeoutId);
        expect(clearTimeoutSpy).toHaveBeenCalledTimes(1);
    });

    it('should reset notification state after the timeout expires', fakeAsync(() => {
        component.isWinLossNotification = true;
        component.displayNotification('Test Title', 'Test Message', true, 800);

        expect(component.showNotification).toBeTrue();

        tick(800);

        expect(component.showNotification).toBeFalse();
        expect(component.isWinLossNotification).toBeFalse();
    }));

    it('should correctly end turn', () => {
        const displaySpy = spyOn(component, 'displayNotification');
        component.endTurn();
        expect(socketServiceSpy.endPlayerTurn).toHaveBeenCalled();
        expect(displaySpy).toHaveBeenCalled();
    });

    it('should correctly exit fight', () => {
        const displaySpy = spyOn(component, 'displayNotification');

        component.exitCombat();

        expect(combatServiceSpy.setCombatMode).toHaveBeenCalledWith(false);
        expect(displaySpy).toHaveBeenCalled();
    });

    it('should correctly reset fight', () => {
        const clearTimeoutSpy = spyOn(window, 'clearTimeout');
        // eslint-disable-next-line @typescript-eslint/no-empty-function
        const timeoutId = setTimeout(() => {}, 1000);
        component.notificationTimeout = timeoutId;
        component.resetCombat();

        expect(clearTimeoutSpy).toHaveBeenCalledWith(timeoutId);

        // Create a new component without a timeout
        component.notificationTimeout = undefined as unknown as ReturnType<typeof setTimeout>;

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

        it('should do nothing if no enemy is present', () => {
            // Force getEnemy() to return null.
            (combatServiceSpy.getEnemy as jasmine.Spy).and.returnValue(null);
            component.attack();
            expect(socketServiceSpy.attack).not.toHaveBeenCalled();
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
                expect(socketServiceSpy.attack).toHaveBeenCalledWith(payload);
            });

            it('should not call socketService.attack if attack payload is null', () => {
                spyOn(enemy, 'rollStat').and.returnValue(4);
                spyOn(player, 'rollStat').and.returnValue(4);
                combatServiceSpy.attack.and.returnValue(null);
                component.attack();
                expect(socketServiceSpy.attack).not.toHaveBeenCalled();
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
                expect(socketServiceSpy.attack).toHaveBeenCalledWith(payload);
            });

            it('should not call socketService.attack if attack payload is null', () => {
                spyOn(enemy, 'rollStatDebug').and.returnValue(6);
                spyOn(player, 'rollStatDebug').and.returnValue(6);
                combatServiceSpy.attack.and.returnValue(null);
                component.attack();
                expect(socketServiceSpy.attack).not.toHaveBeenCalled();
            });
        });
    });

    describe('Getters', () => {
        it('should get the fight attempts', () => {
            const expectedAttempts = 3;
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (component as any).combatService.flightAttemptsLeft = expectedAttempts;

            expect(component.flightAttempts).toBe(expectedAttempts);
        });

        it('should get the main player', () => {
            const expectedPlayer = new Player('mainPlayer');
            gameManagerServiceSpy.getMainPlayer.and.returnValue(expectedPlayer);

            expect(component.player).toBe(expectedPlayer);
        });

        it('should get the combat state', () => {
            const expectedState = 'idle';
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

        it('should return canFight from combatService', () => {
            combatServiceSpy.canFight = true;
            expect(component.canFight).toBeTrue();

            combatServiceSpy.canFight = false;
            expect(component.canFight).toBeFalse();
        });

        it('should return canAct from combatService', () => {
            combatServiceSpy.canAct = true;
            expect(component.canAct).toBeTrue();

            combatServiceSpy.canAct = false;
            expect(component.canAct).toBeFalse();
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

            spyOn(component, 'displayNotification').and.callThrough();
            component.isWinLossNotification = false;
        });

        it('should return early if enemy is null', () => {
            combatServiceSpy.getEnemy.and.returnValue(null);
            component.showCombatNotification('hit');
            expect(component.displayNotification).not.toHaveBeenCalled();
        });

        it('should return early if player is null', () => {
            gameManagerServiceSpy.getMainPlayer.and.returnValue(undefined);
            component.showCombatNotification('hit');
            expect(component.displayNotification).not.toHaveBeenCalled();
        });

        it('should display "Raté!" notification for state "miss"', () => {
            component.showCombatNotification('miss');
            expect(component.displayNotification).toHaveBeenCalledWith('Raté!', '', false, 800);
        });

        it('should display hit notification for state "hit"', () => {
            component.attackValue = 10;
            component.defenseValue = 3;
            component.showCombatNotification('hit');
            expect(component.displayNotification).toHaveBeenCalledWith('-7', '', true, 800);
        });

        it('should display getHit notification for state "getHit"', () => {
            component.attackValue = 10;
            component.defenseValue = 3;
            component.showCombatNotification('getHit');
            expect(component.displayNotification).toHaveBeenCalledWith('-7', '', false, 800);
        });

        it('should display "Esquivé!" notification for state "getMissed"', () => {
            component.showCombatNotification('getMissed');
            expect(component.displayNotification).toHaveBeenCalledWith('Esquivé!', '', true, 800);
        });

        it('should display victory notification for state "won"', () => {
            gameManagerServiceSpy.getMainPlayer.and.returnValue(new Player('Player'));
            component.showCombatNotification('won');
            expect(component.displayNotification).toHaveBeenCalledWith('Victoire!', 'Player a gagné le combat!', true, 3000);
            expect(component.isWinLossNotification).toBeTrue();
        });

        it('should display defeat notification for state "lost"', () => {
            // Set a dummy enemy so that this.enemy!.name is available.
            combatServiceSpy.getEnemy.and.returnValue(new Player('Enemy'));
            component.showCombatNotification('lost');
            expect(component.displayNotification).toHaveBeenCalledWith('Défaite', 'Enemy a gagné le combat!', false, 3000);
            expect(component.isWinLossNotification).toBeTrue();
        });

        it('should return without calling displayNotification for an unknown state', () => {
            component.showCombatNotification('unknown');
            expect(component.displayNotification).not.toHaveBeenCalled();
        });
    });

    describe('Setters', () => {
        it('should set the correct attack and defense stats', () => {
            const attackStat = 4;
            const defenseStat = 6;

            component.attackValue = attackStat;
            component.defenseValue = defenseStat;

            expect(combatServiceSpy.attackValue).toEqual(attackStat);
            expect(combatServiceSpy.defenseValue).toEqual(defenseStat);
        });
    });

    describe('Subscriptions', () => {
        it('should call attack() when socketService.attackTrigger emits', () => {
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (socketServiceSpy as any).attackTrigger = new Subject<void>();

            component.ngOnInit();

            const attackSpy = spyOn(component, 'attack');

            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (socketServiceSpy as any).attackTrigger.next();

            expect(attackSpy).toHaveBeenCalled();
        });

        it('should call showCombatNotification when combatStateChange emits a state', () => {
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (combatServiceSpy as any).combatStateChange = new Subject<string>();

            spyOn(component, 'showCombatNotification');

            component.ngOnInit();

            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (combatServiceSpy as any).combatStateChange.next('hit');

            expect(component.showCombatNotification).toHaveBeenCalledWith('hit');
        });
    });
});

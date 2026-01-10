import { ComponentFixture, TestBed } from '@angular/core/testing';
import { NotificationComponent } from './notification.component';
import { provideHttpClient } from '@angular/common/http';
import { GameManagerService } from '@app/services/game-manager.service';
import { Subject } from 'rxjs';
/* eslint-disable @typescript-eslint/no-magic-numbers */
describe('NotificationComponent', () => {
    let component: NotificationComponent;
    let fixture: ComponentFixture<NotificationComponent>;
    let originalTimeout: number;
    let gameManagerService: jasmine.SpyObj<GameManagerService>;

    beforeEach(async () => {
        gameManagerService = jasmine.createSpyObj('GameManagerService', [], {
            turnCountdown: new Subject<number>(),
        });

        await TestBed.configureTestingModule({
            imports: [NotificationComponent],
            providers: [provideHttpClient(), { provide: GameManagerService, useValue: gameManagerService }],
        }).compileComponents();

        fixture = TestBed.createComponent(NotificationComponent);
        component = fixture.componentInstance;
        fixture.detectChanges();

        originalTimeout = jasmine.DEFAULT_TIMEOUT_INTERVAL;
        jasmine.DEFAULT_TIMEOUT_INTERVAL = 5000;
    });

    afterEach(() => {
        jasmine.DEFAULT_TIMEOUT_INTERVAL = originalTimeout;
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });

    it('should initialize remainingSeconds based on duration', () => {
        component.time = 3000;
        component.mode = 'finishGame';
        component.ngOnInit();
        expect(component.remainingSeconds).toBe(3);
    });

    it('should hide notification after duration', (done) => {
        component.time = 2000;
        component.mode = 'finishGame';
        component.ngOnInit();
        setTimeout(() => {
            expect(component.isVisible).toBeFalse();
            done();
        }, 2500);
    });

    it('should clear interval on destroy', () => {
        spyOn(window, 'clearInterval');
        component.ngOnDestroy();
        expect(clearInterval).toHaveBeenCalled();
    });

    it('should decrease remainingSeconds every second', (done) => {
        component.time = 3000;
        component.mode = 'finishGame';
        component.ngOnInit();
        setTimeout(() => {
            expect(component.remainingSeconds).toBe(1);
            done();
        }, 2000);
    });

    it('should update visibility and remainingSeconds when turnCountdown emits', () => {
        component.ngOnInit();
        (gameManagerService.turnCountdown as Subject<number>).next(5);
        expect(component.isVisible).toBeTrue();
        expect(component.remainingSeconds).toBe(5);
    });

    it('should hide notification when turnCountdown emits 0', () => {
        component.ngOnInit();
        (gameManagerService.turnCountdown as Subject<number>).next(0);
        expect(component.isVisible).toBeFalse();
        expect(component.remainingSeconds).toBe(0);
    });

    it('should handle multiple turnCountdown emissions', () => {
        component.ngOnInit();
        (gameManagerService.turnCountdown as Subject<number>).next(5);
        expect(component.isVisible).toBeTrue();
        expect(component.remainingSeconds).toBe(5);

        (gameManagerService.turnCountdown as Subject<number>).next(3);
        expect(component.isVisible).toBeTrue();
        expect(component.remainingSeconds).toBe(3);

        (gameManagerService.turnCountdown as Subject<number>).next(0);
        expect(component.isVisible).toBeFalse();
        expect(component.remainingSeconds).toBe(0);
    });
});

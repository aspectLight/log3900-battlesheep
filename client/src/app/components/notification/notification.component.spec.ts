import { ComponentFixture, TestBed } from '@angular/core/testing';
import { NotificationComponent } from './notification.component';
/* eslint-disable @typescript-eslint/no-magic-numbers */
describe('NotificationComponent', () => {
    let component: NotificationComponent;
    let fixture: ComponentFixture<NotificationComponent>;
    let originalTimeout: number;

    beforeEach(async () => {
        await TestBed.configureTestingModule({
            imports: [NotificationComponent],
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
        component.duration = 3000;
        component.ngOnInit();
        expect(component.remainingSeconds).toBe(3);
    });

    it('should hide notification after duration', (done) => {
        component.duration = 2000;
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
        component.duration = 3000;
        component.ngOnInit();
        setTimeout(() => {
            expect(component.remainingSeconds).toBe(1);
            done();
        }, 1500);
    });
});

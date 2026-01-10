import { ComponentFixture, TestBed, fakeAsync, tick } from '@angular/core/testing';
import { AppComponent } from '@app/pages/app/app.component';
import { Router, NavigationStart, NavigationEnd } from '@angular/router';
import { LOADING_SCREEN_DELAY } from '@app/constants/routes.constants';
import { Subject } from 'rxjs';

describe('AppComponent', () => {
    let component: AppComponent;
    let fixture: ComponentFixture<AppComponent>;
    let routerEvents: Subject<unknown>;

    beforeEach(async () => {
        routerEvents = new Subject<unknown>();
        const mockRouter = {
            events: routerEvents.asObservable(),
        };

        await TestBed.configureTestingModule({
            imports: [AppComponent],
            providers: [{ provide: Router, useValue: mockRouter }],
        }).compileComponents();

        fixture = TestBed.createComponent(AppComponent);
        component = fixture.componentInstance;
        fixture.detectChanges();
    });

    it('should create the app', () => {
        expect(component).toBeTruthy();
    });

    it('should show loading screen when navigation starts', () => {
        expect(component.isLoading).toBeFalse();
        routerEvents.next(new NavigationStart(1, '/'));
        expect(component.isLoading).toBeTrue();
    });

    it('should hide loading screen after delay when navigation ends', fakeAsync(() => {
        routerEvents.next(new NavigationStart(1, '/'));
        expect(component.isLoading).toBeTrue();

        routerEvents.next(new NavigationEnd(1, '/', '/'));
        expect(component.isLoading).toBeTrue(); // Should still be true before delay

        tick(LOADING_SCREEN_DELAY);
        expect(component.isLoading).toBeFalse();
    }));

    it('should handle multiple navigation events correctly', fakeAsync(() => {
        // First navigation
        routerEvents.next(new NavigationStart(1, '/'));
        expect(component.isLoading).toBeTrue();

        routerEvents.next(new NavigationEnd(1, '/', '/'));
        tick(LOADING_SCREEN_DELAY);
        expect(component.isLoading).toBeFalse();

        // Second navigation
        routerEvents.next(new NavigationStart(2, '/game'));
        expect(component.isLoading).toBeTrue();

        routerEvents.next(new NavigationEnd(2, '/game', '/game'));
        tick(LOADING_SCREEN_DELAY);
        expect(component.isLoading).toBeFalse();
    }));
});

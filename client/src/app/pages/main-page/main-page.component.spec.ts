import { ComponentFixture, TestBed, fakeAsync, tick } from '@angular/core/testing';
import { Router, Routes, provideRouter } from '@angular/router';
import { Location } from '@angular/common';
import { MainPageComponent } from '@app/pages/main-page/main-page.component';
import { GamePageComponent } from '@app/pages/game-page/game-page.component';
import { CreateGamePageComponent } from '@app/pages/create-game-page/create-game-page.component';
import { AdminGamePageComponent } from '@app/pages/admin-game-page/admin-game-page.component';
import { ROUTES } from '@app/constants/routes.constants';
import { GameManagerService } from '@app/services/state/game-manager.service';

const routes: Routes = [
    { path: 'game', component: GamePageComponent },
    { path: 'create-game', component: CreateGamePageComponent },
    { path: 'admin-game', component: AdminGamePageComponent },
    { path: 'join-game', component: GamePageComponent },
];

describe('MainPageComponent', () => {
    let component: MainPageComponent;
    let fixture: ComponentFixture<MainPageComponent>;
    let router: Router;
    let location: Location;
    let fakeGameManagerService: jasmine.SpyObj<GameManagerService>;

    beforeEach(async () => {
        fakeGameManagerService = jasmine.createSpyObj('GameManagerService', [], {
            isGameCanceled: false,
            isGameFinished: false,
        });

        await TestBed.configureTestingModule({
            imports: [MainPageComponent],
            providers: [provideRouter(routes), { provide: GameManagerService, useValue: fakeGameManagerService }],
        }).compileComponents();

        router = TestBed.inject(Router);
        fixture = TestBed.createComponent(MainPageComponent);
        location = TestBed.inject(Location);
        component = fixture.componentInstance;
        fixture.detectChanges();

        router.initialNavigation();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });

    it("should have as title 'Eastern Solace'", () => {
        expect(component.title.toLowerCase()).toEqual('eastern solace');
    });

    it('should redirect to the join game page', fakeAsync(() => {
        const button = fixture.nativeElement.querySelector('#join-game-button');
        button.click();
        tick();
        expect(location.path()).toBe(ROUTES.join);
    }));

    it('should redirect to the game creation page', fakeAsync(() => {
        const button = fixture.nativeElement.querySelector('#create-game-button');
        button.click();
        tick();
        expect(location.path()).toBe(ROUTES.createGame);
    }));

    it('should redirect to the admin page', fakeAsync(() => {
        const button = fixture.nativeElement.querySelector('#admin-game-button');
        button.click();
        tick();
        expect(location.path()).toBe(ROUTES.admin);
    }));

    it('should return isGameCanceled from gameManagerService getter', () => {
        expect(component.isGameCanceled).toEqual(fakeGameManagerService.isGameCanceled);
    });

    it('understandError should set gameManagerService.isGameCanceled to false', () => {
        fakeGameManagerService.isGameCanceled = true;
        component.understandError();
        expect(component.isGameCanceled).toBeFalse();
    });

    it('understandMessage should set gameManagerService.isGameFinished to false', () => {
        fakeGameManagerService.isGameFinished = true;
        component.understandMessage();
        expect(component.isGameFinished).toBeFalse();
    });
});

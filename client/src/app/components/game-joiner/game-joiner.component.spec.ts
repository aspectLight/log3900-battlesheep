import { CommonModule, Location } from '@angular/common';
import { provideHttpClient } from '@angular/common/http';
import { ComponentFixture, fakeAsync, TestBed, tick } from '@angular/core/testing';
import { GameService } from '@app/services/game.service';
import { GameJoinerComponent } from './game-joiner.component';
import { ROUTES } from '@app/constants/routes.constants';
import { provideRouter } from '@angular/router';
import { CreatePlayerPageComponent } from '@app/pages/create-player-page/create-player-page.component';

describe('GameJoinerComponent', () => {
    let component: GameJoinerComponent;
    let fixture: ComponentFixture<GameJoinerComponent>;
    let mockGameService: jasmine.SpyObj<GameService>;
    let location: Location;

    beforeEach(async () => {
        mockGameService = jasmine.createSpyObj('GameService', ['setNewGame', 'setGameSettings']);

        await TestBed.configureTestingModule({
            imports: [CommonModule, GameJoinerComponent],
            providers: [
                provideHttpClient(),
                provideRouter([{ path: 'create-player', component: CreatePlayerPageComponent }]),
                { provide: GameService, useValue: mockGameService },
            ],
        }).compileComponents();

        fixture = TestBed.createComponent(GameJoinerComponent);
        location = TestBed.inject(Location);
        component = fixture.componentInstance;
        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });

    it('should join game if the code is valid', fakeAsync(() => {
        spyOn(component['socketService'], 'joinRoom').and.callFake((gameCode, callback) => {
            callback(true, undefined);
        });
        component.gameCodeInput.nativeElement.value = 'gameCode';
        component.joinGame();
        tick();
        expect(location.path()).toBe(ROUTES.createPlayer);
    }));

    it('should not join game if the code is invalid', fakeAsync(() => {
        spyOn(component['socketService'], 'joinRoom').and.callFake((gameCode, callback) => {
            callback(false, undefined);
        });
        component.gameCodeInput.nativeElement.value = 'gameCode';
        component.joinGame();
        tick();
        expect(location.path()).not.toBe(ROUTES.createPlayer);
    }));
});

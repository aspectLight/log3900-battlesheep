import { HttpClient } from '@angular/common/http';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { Board } from '@app/classes/board';

import { GameService } from '@app/services/game.service';
import { RestartGameComponent } from './restart-game.component';

describe('RestartGameComponent', () => {
    let component: RestartGameComponent;
    let fixture: ComponentFixture<RestartGameComponent>;
    let boardSpy: jasmine.SpyObj<Board>;
    let gameServiceSpy: jasmine.SpyObj<GameService>;
    let httpClientSpy: jasmine.SpyObj<HttpClient>;

    beforeEach(async () => {
        httpClientSpy = jasmine.createSpyObj('HttpClient', ['get', 'post', 'put', 'delete']);
        gameServiceSpy = jasmine.createSpyObj('GameService', ['getName', 'setName', 'setDescription']);
        boardSpy = jasmine.createSpyObj('Board', ['clearBoard']);
        await TestBed.configureTestingModule({
            imports: [RestartGameComponent],
            providers: [
                { provide: HttpClient, useValue: httpClientSpy },
                { provide: GameService, useValue: gameServiceSpy },
                { provide: Board, useValue: boardSpy },
            ],
        }).compileComponents();

        fixture = TestBed.createComponent(RestartGameComponent);
        component = fixture.componentInstance;
        component.board = boardSpy;
        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });

    it('should toggle isToggled', () => {
        component.isToggled = false;
        component.onRestartGame();
        expect(component.isToggled).toBeTrue();
    });

    it('should untoggle isToggled', () => {
        component.isToggled = true;
        component.onCancelRestart();
        expect(component.isToggled).toBeFalse();
    });

    it('should emit restartConfirmed and set isToggled to false when onConfirmRestart is called', () => {
        component.isToggled = true;
        spyOn(component.restartConfirmed, 'emit');

        component.onConfirmRestart();

        expect(component.restartConfirmed.emit).toHaveBeenCalled();
        expect(component.isToggled).toBeFalse();
    });

    it('should emit restartConfirmed when game is being modified', () => {
        component.isToggled = true;
        gameServiceSpy.isGameBeingModified = true;
        spyOn(component.restartConfirmed, 'emit');

        component.onConfirmRestart();

        expect(component.restartConfirmed.emit).toHaveBeenCalled();
        expect(component.isToggled).toBeFalse();
    });
});

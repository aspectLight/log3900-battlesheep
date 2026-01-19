import { ComponentFixture, fakeAsync, TestBed } from '@angular/core/testing';
import { Router } from '@angular/router';
import { Game } from '@app/classes/game/game';
import { GameValidationService } from '@app/services/editor/game-validation.service';
import { GameService } from '@app/services/editor/game.service';

import { HttpErrorResponse } from '@angular/common/http';
import { HTTP_STATUS_CODES } from '@app/constants/http-status-code.constants';
import { of, throwError } from 'rxjs';
import { SaveGameComponent } from './save-game.component';
import { ROUTES } from '@app/constants/routes.constants';
import { Board } from '@app/classes/board/board';
import { BOARD_CONFIGS, BoardSizes } from '@app/constants/board.constants';
import { WARNING_MESSAGES } from '@common/error-messages.constants';

interface BoardComponentPrivate {
    validateBoard(): boolean;
    saveNewGame(): void;
    saveModifications(): void;
}

describe('SaveGameComponent', () => {
    let component: SaveGameComponent;
    let fixture: ComponentFixture<SaveGameComponent>;
    let gameServiceSpy: jasmine.SpyObj<GameService>;
    let gameValidationServiceSpy: jasmine.SpyObj<GameValidationService>;
    let routerSpy: jasmine.SpyObj<Router>;

    beforeEach(async () => {
        gameServiceSpy = jasmine.createSpyObj('GameService', [
            'getName',
            'getDescription',
            'getBoard',
            'saveModifications',
            'saveNewGame',
            'setBoard',
            'fetchGames',
            'getId',
            'getMode',
        ]);
        gameValidationServiceSpy = jasmine.createSpyObj('GameValidationService', ['validateGame']);
        routerSpy = jasmine.createSpyObj('Router', ['navigate']);

        gameServiceSpy.getName.and.returnValue('Nom1');
        gameServiceSpy.getDescription.and.returnValue('Description1');
        gameServiceSpy.getMode.and.returnValue('classic');
        gameServiceSpy.getBoard.and.returnValue(new Board(BOARD_CONFIGS[BoardSizes.Moyenne].board));

        gameValidationServiceSpy.validateGame.and.returnValue([]);

        await TestBed.configureTestingModule({
            imports: [SaveGameComponent],
            providers: [
                { provide: GameService, useValue: gameServiceSpy },
                { provide: GameValidationService, useValue: gameValidationServiceSpy },
                { provide: Router, useValue: routerSpy },
            ],
        }).compileComponents();

        fixture = TestBed.createComponent(SaveGameComponent);
        component = fixture.componentInstance;
        component.board = new Board(BOARD_CONFIGS[BoardSizes.Moyenne].board);
        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });

    it('should validate Board', () => {
        const result = component['validateBoard']();

        expect(result).toBe(true);

        expect(gameServiceSpy.getName).toHaveBeenCalled();
        expect(gameServiceSpy.getDescription).toHaveBeenCalled();
        expect(gameServiceSpy.getMode).toHaveBeenCalled();
        expect(gameValidationServiceSpy.validateGame).toHaveBeenCalled();
    });

    it('should navigate to /admin-game on successful modificated save', () => {
        gameServiceSpy.saveModifications.and.returnValue(of(new Game()));

        component['saveModifications']();

        expect(gameServiceSpy.saveModifications).toHaveBeenCalled();
        expect(routerSpy.navigate).toHaveBeenCalledWith([ROUTES.admin]);
    });

    it('should call handleSaveError on error on modificated save', fakeAsync(() => {
        let errorResponse = new HttpErrorResponse({ status: 500, statusText: 'InternalServerError' });
        gameServiceSpy.saveModifications.and.returnValue(throwError(() => errorResponse));
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const spyError = spyOn(component as any, 'handleSaveError').and.callThrough();

        component['saveModifications']();

        expect(spyError).toHaveBeenCalledWith(errorResponse);
        expect(component.errorMessage).toBe('Une erreur est survenue. Veuillez réessayer.');

        errorResponse = new HttpErrorResponse({ status: HTTP_STATUS_CODES.conflict, statusText: 'Conflict' });
        gameServiceSpy.saveModifications.and.returnValue(throwError(() => errorResponse));

        component['saveModifications']();

        expect(spyError).toHaveBeenCalledWith(errorResponse);
        expect(component.errorMessage).toBe('Le nom choisi pour le jeu est déjà utilisé. Veuillez le changer.');
    }));

    it('should navigate to /admin-game on successful on new save', () => {
        gameServiceSpy.saveNewGame.and.returnValue(of(void 0));

        component['saveNewGame']();

        expect(gameServiceSpy.saveNewGame).toHaveBeenCalled();
        expect(routerSpy.navigate).toHaveBeenCalledWith([ROUTES.admin]);
    });

    it('should call handleSaveError on error on new save', fakeAsync(() => {
        let errorResponse = new HttpErrorResponse({ status: 500, statusText: 'InternalServerError' });
        gameServiceSpy.saveNewGame.and.returnValue(throwError(() => errorResponse));
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const spyError = spyOn(component as any, 'handleSaveError').and.callThrough();

        component['saveNewGame']();

        expect(spyError).toHaveBeenCalledWith(errorResponse);
        expect(component.errorMessage).toBe('Une erreur est survenue. Veuillez réessayer.');

        errorResponse = new HttpErrorResponse({ status: HTTP_STATUS_CODES.conflict, statusText: 'Conflict' });
        gameServiceSpy.saveNewGame.and.returnValue(throwError(() => errorResponse));

        component['saveNewGame']();

        expect(spyError).toHaveBeenCalledWith(errorResponse);
        expect(component.errorMessage).toBe('Le nom choisi pour le jeu est déjà utilisé. Veuillez le changer.');
    }));

    it('should not proceed if board is invalid', () => {
        const validateBoardSpy = spyOn(component as unknown as BoardComponentPrivate, 'validateBoard').and.callThrough();
        validateBoardSpy.and.returnValue(false);
        component.onSaveGame();
        const saveNewGameSpy = spyOn(component as unknown as BoardComponentPrivate, 'saveNewGame');
        expect(saveNewGameSpy).not.toHaveBeenCalled();
    });

    it('should save modifications if game exists', fakeAsync(() => {
        const validateBoardSpy = spyOn(component as unknown as BoardComponentPrivate, 'validateBoard');
        validateBoardSpy.and.returnValue(true);
        gameServiceSpy.isGameBeingModified = true;
        const existingGame = { _id: '123' } as Game;
        gameServiceSpy.getId.and.returnValue('123');
        gameServiceSpy.fetchGames.and.returnValue(of([existingGame]));

        const saveModifications = spyOn(component as unknown as BoardComponentPrivate, 'saveModifications');

        component.onConfirmSave();

        expect(saveModifications).toHaveBeenCalled();
    }));

    it('should save as new game if game does not exist', fakeAsync(() => {
        const validateBoardSpy = spyOn(component as unknown as BoardComponentPrivate, 'validateBoard');
        validateBoardSpy.and.returnValue(true);
        gameServiceSpy.isGameBeingModified = true;
        gameServiceSpy.getId.and.returnValue('123');
        gameServiceSpy.fetchGames.and.returnValue(of([]));

        const saveNewGameSpy = spyOn(component as unknown as BoardComponentPrivate, 'saveNewGame');

        component.onConfirmSave();

        expect(saveNewGameSpy).toHaveBeenCalled();
    }));

    it('should save as new game if game is not being modified', () => {
        const validateBoardSpy = spyOn(component as unknown as BoardComponentPrivate, 'validateBoard');
        validateBoardSpy.and.returnValue(true);
        const saveNewGameSpy = spyOn(component as unknown as BoardComponentPrivate, 'saveNewGame');
        gameServiceSpy.isGameBeingModified = false;

        component.onConfirmSave();

        expect(saveNewGameSpy).toHaveBeenCalled();
    });

    it('should close dialog', () => {
        component.errors = [{ message: 'Erreur 1' }, { message: 'Erreur 2' }];

        component.closeDialogue();

        expect(component.errors).toEqual([]);
    });

    it('should set up confirmation dialog when onSaveGame is called with valid board', () => {
        const validateBoardSpy = spyOn(component as unknown as BoardComponentPrivate, 'validateBoard');
        validateBoardSpy.and.returnValue(true);

        component.onSaveGame();

        expect(component.errorMessage).toBe(WARNING_MESSAGES.SaveConfirmation);
        expect(component.showError).toBeTrue();
        expect(component.showSecondButton).toBeTrue();
        expect(component.onConfirm).toBe(component.onConfirmSave);
    });
});

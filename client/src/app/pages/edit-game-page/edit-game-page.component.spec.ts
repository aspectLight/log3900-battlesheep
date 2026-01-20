import { ComponentFixture, TestBed } from '@angular/core/testing';
import { EditGamePageComponent } from './edit-game-page.component';
import { GameEditorComponent } from '@app/components/editor/game-editor/game-editor.component';
import { CommonModule } from '@angular/common';
import { provideHttpClient } from '@angular/common/http';
import { GameService } from '@app/services/editor/game.service';
import { provideRouter, Router } from '@angular/router';
import { WARNING_MESSAGES } from '@common/error-messages.constants';

describe('EditGamePageComponent', () => {
    let component: EditGamePageComponent;
    let fixture: ComponentFixture<EditGamePageComponent>;
    let mockGameService: jasmine.SpyObj<GameService>;
    let mockRouter: jasmine.SpyObj<Router>;

    beforeEach(async () => {
        mockGameService = jasmine.createSpyObj('GameService', ['getGameSettings']);
        mockGameService.getGameSettings.and.returnValue({ mode: 'classique', boardSize: 10 });
        mockRouter = jasmine.createSpyObj('Router', ['navigate']);

        await TestBed.configureTestingModule({
            imports: [CommonModule, EditGamePageComponent, GameEditorComponent],
            providers: [
                provideHttpClient(),
                provideRouter([]),
                { provide: GameService, useValue: mockGameService },
                { provide: Router, useValue: mockRouter },
            ],
        }).compileComponents();

        fixture = TestBed.createComponent(EditGamePageComponent);
        component = fixture.componentInstance;
        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });

    it('should render the GameEditorComponent', () => {
        const compiled = fixture.nativeElement;
        expect(compiled.querySelector('app-game-editor')).toBeTruthy();
    });

    it('should set showConfirmation to true when onReturnClick is called', () => {
        component.showConfirmation = false;
        component.onReturnClick();
        expect(component.showConfirmation).toBeTrue();
    });

    it('should set quitMessage to the correct warning message', () => {
        expect(component.quitMessage).toBe(WARNING_MESSAGES.QuitEdit);
    });

    it('should set showConfirmation to false and navigate to admin-game when onConfirmQuit is called', () => {
        component.showConfirmation = true;
        component.onConfirmQuit();
        expect(component.showConfirmation).toBeFalse();
        expect(mockRouter.navigate).toHaveBeenCalledWith(['/admin-game']);
    });

    it('should set showConfirmation to false when onCancelQuit is called', () => {
        component.showConfirmation = true;
        component.onCancelQuit();
        expect(component.showConfirmation).toBeFalse();
    });
});

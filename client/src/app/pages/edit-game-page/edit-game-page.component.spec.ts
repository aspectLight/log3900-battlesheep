import { ComponentFixture, TestBed } from '@angular/core/testing';
import { EditGamePageComponent } from './edit-game-page.component';
import { GameEditorComponent } from '@app/components/game-editor/game-editor.component';
import { CommonModule } from '@angular/common';
import { provideHttpClient } from '@angular/common/http';
import { GameService } from '@app/services/game.service';
import { provideRouter } from '@angular/router';

describe('EditGamePageComponent', () => {
    let component: EditGamePageComponent;
    let fixture: ComponentFixture<EditGamePageComponent>;
    let mockGameService: jasmine.SpyObj<GameService>;

    beforeEach(async () => {
        mockGameService = jasmine.createSpyObj('GameService', ['getGameSettings']);
        mockGameService.getGameSettings.and.returnValue({ mode: 'classique', boardSize: 10 });

        await TestBed.configureTestingModule({
            imports: [CommonModule, EditGamePageComponent, GameEditorComponent],
            providers: [provideHttpClient(), provideRouter([]), { provide: GameService, useValue: mockGameService }],
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
});

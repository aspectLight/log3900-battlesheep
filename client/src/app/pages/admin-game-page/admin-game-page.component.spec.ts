import { ComponentFixture, TestBed } from '@angular/core/testing';
import { AdminGamePageComponent } from './admin-game-page.component';
import { GameListComponent } from '@app/components/game-list/game-list.component';
import { CommonModule } from '@angular/common';
import { provideHttpClient } from '@angular/common/http';
import { GameService } from '@app/services/game.service';
import { of } from 'rxjs';
import { Game } from '@app/classes/game';
import { ActivatedRoute } from '@angular/router';

describe('AdminGamePageComponent', () => {
    let component: AdminGamePageComponent;
    let fixture: ComponentFixture<AdminGamePageComponent>;
    let mockGameService: jasmine.SpyObj<GameService>;
    let mockActivatedRoute: Partial<ActivatedRoute>;

    beforeEach(async () => {
        mockGameService = jasmine.createSpyObj('GameService', ['fetchGames', 'setGame', 'setNewGame', 'saveNewGame', 'saveModifications']);
        const mockGames: Game[] = [{ _id: '123', name: 'Test Game', mode: 'classique', board: { size: 10 } } as Game];
        mockGameService.fetchGames.and.returnValue(of(mockGames));
        mockActivatedRoute = {};
        await TestBed.configureTestingModule({
            imports: [CommonModule, AdminGamePageComponent, GameListComponent],
            providers: [
                provideHttpClient(),
                { provide: GameService, useValue: mockGameService },
                { provide: ActivatedRoute, useValue: mockActivatedRoute },
            ],
        }).compileComponents();

        fixture = TestBed.createComponent(AdminGamePageComponent);
        component = fixture.componentInstance;
        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });

    it('should render the GameListComponent', () => {
        const compiled = fixture.nativeElement;
        expect(compiled.querySelector('app-game-list')).toBeTruthy();
    });

    it('should fetch games on initialization', () => {
        expect(mockGameService.fetchGames).toHaveBeenCalled();
    });
});

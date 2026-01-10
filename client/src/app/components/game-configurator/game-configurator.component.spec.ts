import { ComponentFixture, TestBed } from '@angular/core/testing';
import { Router } from '@angular/router';
import { GameConfiguratorComponent } from './game-configurator.component';
import { GameService } from '@app/services/game.service';
import { CommonModule } from '@angular/common';
import { provideHttpClient } from '@angular/common/http';
import { BOARD_SIZES } from '@app/constants/board.constants';
import { MODES } from '@app/constants/game.constants';
import { ROUTES } from '@app/constants/routes.constants';

describe('GameConfiguratorComponent', () => {
    let component: GameConfiguratorComponent;
    let fixture: ComponentFixture<GameConfiguratorComponent>;
    let mockRouter: jasmine.SpyObj<Router>;
    let mockGameService: jasmine.SpyObj<GameService>;

    beforeEach(async () => {
        mockRouter = jasmine.createSpyObj('Router', ['navigate']);
        mockGameService = jasmine.createSpyObj('GameService', ['setNewGame', 'setGameSettings']);

        await TestBed.configureTestingModule({
            imports: [CommonModule, GameConfiguratorComponent],
            providers: [provideHttpClient(), { provide: Router, useValue: mockRouter }, { provide: GameService, useValue: mockGameService }],
        }).compileComponents();

        fixture = TestBed.createComponent(GameConfiguratorComponent);
        component = fixture.componentInstance;
        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });

    it('should initialize with default mode and board size', () => {
        expect(component.mode).toBe('classique');
        expect(component.modeDescription).toBe(MODES['classique']);
        expect(component.boardSize).toBe('moyenne');
        expect(component.board).toBe(BOARD_SIZES['moyenne'].board);
    });

    it('should update mode when onModeChange is called', () => {
        component.onModeChange('ctf');
        expect(component.mode).toBe('ctf');
        expect(component.modeDescription).toBe(MODES['ctf']);
    });

    it('should update board size when onSizeChange is called', () => {
        component.onSizeChange('grande');
        expect(component.boardSize).toBe('grande');
        expect(component.board).toBe(BOARD_SIZES['grande'].board);
    });

    it('should navigate to /edit-game and set game settings when createGame is called', () => {
        component.createGame();
        expect(mockRouter.navigate).toHaveBeenCalledWith([ROUTES.edit]);
        expect(mockGameService.setNewGame).toHaveBeenCalled();
        expect(mockGameService.setGameSettings).toHaveBeenCalledWith(component.mode, component.board);
    });

    it('should navigate to /admin-game when cancel is called', () => {
        component.cancel();
        expect(mockRouter.navigate).toHaveBeenCalledWith([ROUTES.admin]);
    });
});

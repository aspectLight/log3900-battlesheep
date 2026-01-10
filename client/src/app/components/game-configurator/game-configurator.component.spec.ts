import { ComponentFixture, TestBed } from '@angular/core/testing';
import { Router } from '@angular/router';
import { GameConfiguratorComponent } from './game-configurator.component';
import { GameService } from '@app/services/game.service';
import { CommonModule } from '@angular/common';
import { provideHttpClient } from '@angular/common/http';
import { BoardSizes, BOARD_CONFIGS } from '@app/constants/board.constants';
import { MODES, MODE_DESCRIPTIONS } from '@app/constants/game.constants';
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
        expect(component.mode).toBe(MODES.CLASSIQUE);
        expect(component.modeDescription).toBe(MODE_DESCRIPTIONS[MODES.CLASSIQUE]);
        expect(component.boardSize).toBe(BoardSizes.Moyenne);
        expect(component.board).toBe(BOARD_CONFIGS[BoardSizes.Moyenne].board);
    });

    it('should update mode when onModeChange is called', () => {
        component.onModeChange(MODES.CTF);
        expect(component.mode).toBe(MODES.CTF);
        expect(component.modeDescription).toBe(MODE_DESCRIPTIONS[MODES.CTF]);
    });

    it('should update board size when onSizeChange is called', () => {
        component.onSizeChange(BoardSizes.Grande);
        expect(component.boardSize).toBe(BoardSizes.Grande);
        expect(component.board).toBe(BOARD_CONFIGS[BoardSizes.Grande].board);
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

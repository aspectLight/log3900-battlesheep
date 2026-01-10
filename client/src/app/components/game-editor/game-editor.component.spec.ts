import { ComponentFixture, TestBed } from '@angular/core/testing';
import { Board } from '@app/classes/board';
import { BoardSizes, BOARD_CONFIGS } from '@app/constants/board.constants';
import { GameService } from '@app/services/game.service';
import { GameEditorComponent } from './game-editor.component';
import { ToolboxComponent } from '@app/components/toolbox/toolbox.component';

describe('GameEditorComponent', () => {
    let component: GameEditorComponent;
    let fixture: ComponentFixture<GameEditorComponent>;
    let gameServiceSpy: jasmine.SpyObj<GameService>;
    let toolboxComponentSpy: jasmine.SpyObj<ToolboxComponent>;

    beforeEach(async () => {
        gameServiceSpy = jasmine.createSpyObj('GameService', ['getBoard', 'getName', 'getGameSettings', 'undoModifications']);
        toolboxComponentSpy = jasmine.createSpyObj('ToolboxComponent', ['resetInputs']);

        gameServiceSpy.getGameSettings.and.returnValue({ mode: 'ctf', boardSize: 15 });
        let isGameBeingModified = true;
        Object.defineProperty(gameServiceSpy, 'isGameBeingModified', {
            get: () => isGameBeingModified,
            set: (value) => {
                isGameBeingModified = value;
            },
            configurable: true,
        });

        await TestBed.configureTestingModule({
            imports: [GameEditorComponent],
            providers: [
                { provide: GameService, useValue: gameServiceSpy },
                { provide: ToolboxComponent, useValue: toolboxComponentSpy },
            ],
        }).compileComponents();

        fixture = TestBed.createComponent(GameEditorComponent);
        component = fixture.componentInstance;
        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });

    it('should return name', () => {
        component.getGameName();
        expect(gameServiceSpy.getBoard).toHaveBeenCalled();
    });

    it('should get board when modifying', () => {
        gameServiceSpy.getBoard.and.returnValue(new Board(BOARD_CONFIGS[BoardSizes.Moyenne].board));
        gameServiceSpy.getName.and.returnValue('Test Game');
        component.ngOnInit();
        expect(gameServiceSpy.getBoard).toHaveBeenCalled();
    });

    it('should get game setting when not modifying', () => {
        gameServiceSpy.getBoard.and.returnValue(new Board(BOARD_CONFIGS[BoardSizes.Moyenne].board));
        gameServiceSpy.getName.and.returnValue('Test Game');
        gameServiceSpy.isGameBeingModified = false;
        component.ngOnInit();
        expect(gameServiceSpy.getGameSettings).toHaveBeenCalled();
        expect(gameServiceSpy.getBoard).toHaveBeenCalled();
    });

    it('should undo modifications, get board and reset toolbox inputs when restart is triggered', () => {
        gameServiceSpy.getBoard.and.returnValue(new Board(BOARD_CONFIGS[BoardSizes.Moyenne].board));

        component.onRestartConfirmed();

        expect(gameServiceSpy.undoModifications).toHaveBeenCalled();
        expect(gameServiceSpy.getBoard).toHaveBeenCalled();
        expect(component.board).toEqual(gameServiceSpy.getBoard());
    });
});

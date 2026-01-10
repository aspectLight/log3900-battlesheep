import { ComponentFixture, TestBed } from '@angular/core/testing';
import { provideHttpClient } from '@angular/common/http';
import { BoardComponent } from './board.component';
import { PaintService } from '@app/services/paint.service';
import { DragDropService } from '@app/services/drag-drop.service';
import { ActionService } from '@app/services/action.service';
import { GameManagerService } from '@app/services/game-manager.service';
import { SocketService } from '@app/services/socket.service';
import { Board } from '@app/classes/board';
import { Cell } from '@app/classes/cell';
import { Tile } from '@app/classes/tile';
import { Item } from '@app/classes/item';
import { Player } from '@app/classes/player';
import { Room } from '@app/interfaces/room';
import { BehaviorSubject } from 'rxjs';

/* eslint-disable @typescript-eslint/no-magic-numbers */
describe('BoardComponent', () => {
    let component: BoardComponent;
    let fixture: ComponentFixture<BoardComponent>;
    let paintServiceSpy: jasmine.SpyObj<PaintService>;
    let dragDropServiceSpy: jasmine.SpyObj<DragDropService>;
    let actionServiceSpy: jasmine.SpyObj<ActionService>;
    let gameManagerServiceSpy: jasmine.SpyObj<GameManagerService>;
    let socketServiceSpy: jasmine.SpyObj<SocketService>;

    const BOARD_SIZE = 10;
    let board: Board;
    const cell1 = new Cell(new Tile('ice'), 0, 0);
    const cell2 = new Cell(new Tile('snow'), 1, 1);
    const player1 = new Player('player1');
    const room = {
        roomId: 'room1',
        players: [player1],
        isDebugging: false,
    } as Room;

    const coords1 = { x: cell1.x, y: cell1.y };
    const coords2 = { x: cell2.x, y: cell2.y };
    const dummyMap = new Map();
    dummyMap.set(coords1, [coords1, coords2]);
    const moveInfo = {
        roomId: room.roomId,
        playerId: player1.id,
        map: dummyMap,
        selectedPath: [coords1],
    };

    beforeEach(async () => {
        paintServiceSpy = jasmine.createSpyObj('PaintService', ['handleMouseDown', 'handleMouseMove', 'handleMouseUp']);
        dragDropServiceSpy = jasmine.createSpyObj('DragDropService', ['startDrag', 'handleDragEnd', 'allowDrop', 'handleDrop']);
        actionServiceSpy = jasmine.createSpyObj(
            'ActionService',
            ['selectCell', 'toggleSelection', 'interact', 'selectSingleCell', 'getIsSelectionActive'],
            {
                selectedCell$: new BehaviorSubject<Cell | null>(null),
            },
        );
        gameManagerServiceSpy = jasmine.createSpyObj('GameManagerService', [
            'getSelectedPath',
            'getPaths',
            'setPathFromCoord',
            'getMainPlayer',
            'getMoveInfo',
        ]);
        socketServiceSpy = jasmine.createSpyObj('SocketService', ['teleportPlayer', 'movedPlayer']);

        gameManagerServiceSpy.getSelectedPath.and.returnValue([cell1, cell2]);
        gameManagerServiceSpy.getPaths.and.returnValue([cell1, cell2]);
        gameManagerServiceSpy.getMoveInfo.and.returnValue(moveInfo);
        gameManagerServiceSpy.getMainPlayer.and.returnValue(player1);
        gameManagerServiceSpy.room = room;
        gameManagerServiceSpy.currentPlayerId = 'player1';

        await TestBed.configureTestingModule({
            imports: [BoardComponent],
            providers: [
                provideHttpClient(),
                { provide: PaintService, useValue: paintServiceSpy },
                { provide: DragDropService, useValue: dragDropServiceSpy },
                { provide: ActionService, useValue: actionServiceSpy },
                { provide: GameManagerService, useValue: gameManagerServiceSpy },
                { provide: SocketService, useValue: socketServiceSpy },
            ],
        }).compileComponents();

        fixture = TestBed.createComponent(BoardComponent);
        component = fixture.componentInstance;
        board = new Board(BOARD_SIZE);
        component.board = board;
        component.mode = 'edit';
        fixture.detectChanges();
    });

    describe('Edit mode', () => {
        beforeEach(() => {
            component.mode = 'edit';
            fixture.detectChanges();
        });

        it('should create', () => {
            expect(component).toBeTruthy();
        });

        it('should call paintService.handleMouseDown when handleMouseDown is called in edit mode', () => {
            const cell = new Cell(new Tile('snow'), 0, 0);
            const event = new MouseEvent('mousedown');
            component.handleMouseDown(event, cell);
            expect(paintServiceSpy.handleMouseDown).toHaveBeenCalledWith(event, cell, board);
        });

        it('should call paintService.handleMouseMove when handleMouseMove is called in edit mode', () => {
            const cell = new Cell(new Tile('snow'), 1, 1);
            component.handleMouseMove(cell);
            expect(paintServiceSpy.handleMouseMove).toHaveBeenCalledWith(cell, board);
        });

        it('should call paintService.handleMouseUp when handleMouseUp is called in edit mode', () => {
            component.handleMouseUp();
            expect(paintServiceSpy.handleMouseUp).toHaveBeenCalled();
        });

        it('should call dragDropService.startDrag when handleDrag is called and cell has an item', () => {
            const item = new Item('adrenaline');
            cell1.addItem(item);
            component.handleDrag(cell1);
            expect(dragDropServiceSpy.startDrag).toHaveBeenCalledWith(
                jasmine.objectContaining({
                    name: 'Adrenaline',
                    description: 'Ajoute 2 points de rapidité, enlève 1 point de défense',
                    imagePath: './assets/items/drug.png',
                    type: 'adrenaline',
                }),
                cell1,
            );
        });

        it('should not call dragDropService.startDrag when handleDrag is called and cell has no item', () => {
            const cell = new Cell(new Tile('snow'), 3, 3);
            cell.removeItem();
            component.handleDrag(cell);
            expect(dragDropServiceSpy.startDrag).not.toHaveBeenCalled();
        });

        it('should call dragDropService.handleDragEnd when handleDragEnd is called in edit mode', () => {
            component.handleDragEnd();
            expect(dragDropServiceSpy.handleDragEnd).toHaveBeenCalled();
        });

        it('should call dragDropService.allowDrop when handleDragOver is called in edit mode', () => {
            const event = new DragEvent('dragover');
            component.handleDragOver(event);
            expect(dragDropServiceSpy.allowDrop).toHaveBeenCalledWith(event);
        });

        it('should call dragDropService.handleDrop when handleDrop is called in edit mode', () => {
            const cell = new Cell(new Tile('snow'), 4, 4);
            component.handleDrop(cell);
            expect(dragDropServiceSpy.handleDrop).toHaveBeenCalledWith(cell);
        });

        it('should disable context menu when disableContextMenu is called', () => {
            const event = new MouseEvent('contextmenu');
            const spyPrevent = spyOn(event, 'preventDefault');
            component.disableContextMenu(event);
            expect(spyPrevent).toHaveBeenCalled();
        });

        it('movePlayerFromPath should call socketService.movedPlayer when move info is available', () => {
            component.movePlayerFromPath();
            expect(gameManagerServiceSpy.getMoveInfo).toHaveBeenCalled();
            expect(socketServiceSpy.movedPlayer).toHaveBeenCalledWith(moveInfo);
        });
    });

    describe('Play mode', () => {
        beforeEach(() => {
            component.mode = 'play';
            actionServiceSpy.selectCell.calls.reset();
            actionServiceSpy.toggleSelection.calls.reset();
            actionServiceSpy.interact.calls.reset();
            socketServiceSpy.teleportPlayer.calls.reset();
            fixture.detectChanges();
        });

        it('ngOnInit should subscribe to actionService.selectedCell$ and update selectedCell', () => {
            const testCell = new Cell(new Tile('snow'), 5, 5);
            component.mode = 'play';
            component.ngOnInit();
            (actionServiceSpy.selectedCell$ as BehaviorSubject<Cell | null>).next(testCell);
            expect(component.selectedCell).toBe(testCell);
        });

        it('ngOnDestroy should unsubscribe from subscriptions', () => {
            const fakeSub = jasmine.createSpyObj('Subscription', ['unsubscribe']);
            component['subscriptions'].push(fakeSub);
            component.ngOnDestroy();
            expect(fakeSub.unsubscribe).toHaveBeenCalled();
        });

        describe('handleMouseDown in play mode', () => {
            let cell: Cell;
            let event: MouseEvent;
            beforeEach(() => {
                cell = new Cell(new Tile('snow'), 6, 6);
            });

            it('should handle right click with debugging true and teleport player if main player', () => {
                event = new MouseEvent('mousedown', { button: 2 });
                gameManagerServiceSpy.room.isDebugging = true;
                gameManagerServiceSpy.currentPlayerId = gameManagerServiceSpy.getMainPlayer()?.id as string;
                component.handleMouseDown(event, cell1);
                expect(actionServiceSpy.selectSingleCell).toHaveBeenCalledWith(cell1);
                expect(socketServiceSpy.teleportPlayer).toHaveBeenCalledWith(cell1.x, cell1.y);
            });

            it('should handle right click with debugging false', () => {
                event = new MouseEvent('mousedown', { button: 2 });
                gameManagerServiceSpy.room.isDebugging = false;
                component.handleMouseDown(event, cell);
                expect(actionServiceSpy.toggleSelection).toHaveBeenCalled();
                expect(actionServiceSpy.selectSingleCell).toHaveBeenCalledWith(cell);
                expect(socketServiceSpy.teleportPlayer).not.toHaveBeenCalled();
            });

            it('should handle left click (button not 2) in play mode', () => {
                event = new MouseEvent('mousedown', { button: 0 });
                actionServiceSpy.getIsSelectionActive.and.returnValue(true);
                component.handleMouseDown(event, cell);
                expect(gameManagerServiceSpy.getMoveInfo).toHaveBeenCalled();
                expect(socketServiceSpy.movedPlayer).toHaveBeenCalledWith(moveInfo);
                expect(actionServiceSpy.interact).toHaveBeenCalled();
            });

            it('should not call movePlayerFromPath when left click and selection is not active', () => {
                event = new MouseEvent('mousedown', { button: 0 });
                actionServiceSpy.getIsSelectionActive.and.returnValue(false);
                const movePathSpy = spyOn(component, 'movePlayerFromPath');
                component.handleMouseDown(event, cell);
                expect(movePathSpy).not.toHaveBeenCalled();
            });
        });

        it('handleMouseMove in play mode should select cell and set path', () => {
            const cell = new Cell(new Tile('snow'), 7, 7);
            component.handleMouseMove(cell);
            expect(actionServiceSpy.selectCell).toHaveBeenCalledWith(cell);
            expect(gameManagerServiceSpy.setPathFromCoord).toHaveBeenCalledWith({ x: cell.x, y: cell.y });
        });

        it('should call movePlayerFromPath when left click and selection is active', () => {
            component.mode = 'play';
            fixture.detectChanges();

            const movePathSpy = spyOn(component, 'movePlayerFromPath');

            const event = new MouseEvent('mousedown', { button: 0 });
            actionServiceSpy.getIsSelectionActive.and.returnValue(true);

            component.handleMouseDown(event, cell1);

            expect(actionServiceSpy.interact).toHaveBeenCalled();
            expect(movePathSpy).toHaveBeenCalled();
        });
    });

    describe('Getters', () => {
        it('selectedPath getter should return value from gameManagerService', () => {
            expect(component.selectedPath).toEqual([cell1, cell2]);
            expect(gameManagerServiceSpy.getSelectedPath).toHaveBeenCalled();
        });

        it('availableCells getter should return value from gameManagerService', () => {
            expect(component.availableCells).toEqual([cell1, cell2]);
            expect(gameManagerServiceSpy.getPaths).toHaveBeenCalled();
        });

        it('should return isDebugMode from gameManagerService', () => {
            Object.defineProperty(gameManagerServiceSpy, 'isDebugMode', { get: () => true });
            expect(component.isDebugMode).toBe(true);
        });
    });
});

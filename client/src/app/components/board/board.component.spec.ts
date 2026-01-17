import { provideHttpClient } from '@angular/common/http';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { Board } from '@app/classes/board';
import { Cell } from '@app/classes/cell';
import { Item } from '@app/classes/item';
import { Player } from '@app/classes/player';
import { Tile } from '@app/classes/tile';
import { Room } from '@app/interfaces/room';
import { ActionService } from '@app/services/action.service';
import { DragDropService } from '@app/services/drag-drop.service';
import { GameManagerService } from '@app/services/game-manager.service';
import { PaintService } from '@app/services/paint.service';
import { SocketService } from '@app/services/socket.service';
import { ActionSocketService } from '@app/services/socket/action/action-socket.service';
import { MovementSocketService } from '@app/services/socket/movement/movement-socket.service';
import { BehaviorSubject } from 'rxjs';
import { Socket } from 'socket.io-client';
import { BoardComponent } from './board.component';

describe('BoardComponent', () => {
    let component: BoardComponent;
    let fixture: ComponentFixture<BoardComponent>;
    let paintServiceSpy: jasmine.SpyObj<PaintService>;
    let dragDropServiceSpy: jasmine.SpyObj<DragDropService>;
    let actionServiceSpy: jasmine.SpyObj<ActionService>;
    let gameManagerServiceSpy: jasmine.SpyObj<GameManagerService>;
    let socketServiceSpy: jasmine.SpyObj<SocketService>;
    let movementSocketServiceSpy: jasmine.SpyObj<MovementSocketService>;
    let actionSocketServiceSpy: jasmine.SpyObj<ActionSocketService>;

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
            [
                'selectCell',
                'toggleSelection',
                'interact',
                'selectSingleCell',
                'getIsSelectionActive',
                'getIsActionActive',
                'setSelectionActive',
                'switchModes',
            ],
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
        socketServiceSpy = jasmine.createSpyObj('SocketService', [
            'movedPlayer',
            'registerSocketService',
            'setUpConnection',
            'connect',
            'getId',
            'getRoomId',
            'abandonGame',
            'endPlayerTurn',
            'getPlayerMovements',
            'finishGame',
            'dropItem',
            'virtualPlayerTurn',
            'reconnect',
        ]);
        socketServiceSpy.socket = {} as Socket;
        movementSocketServiceSpy = jasmine.createSpyObj('MovementSocketService', [
            'movedPlayer',
            'setUpConnection',
            'getPlayerMovements',
            'teleportPlayer',
        ]);
        movementSocketServiceSpy.socket = {} as Socket;
        actionSocketServiceSpy = jasmine.createSpyObj('ActionSocketService', [
            'setUpConnection',
            'toggleDebugMode',
            'startCombat',
            'flightAttempt',
            'attack',
            'toggleDoor',
        ]);
        actionSocketServiceSpy.socket = {} as Socket;
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
                { provide: MovementSocketService, useValue: movementSocketServiceSpy },
                { provide: ActionSocketService, useValue: actionSocketServiceSpy },
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
                    description: 'Ajoute 2 points de vie',
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
        it('should call socketService.movedPlayer when movePlayerFromPath is called and move info is available', () => {
            // Use a spy to access the private method
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            spyOn<any>(component, 'movePlayerFromPath').and.callThrough();

            // Setup the moveInfo to be returned
            gameManagerServiceSpy.getMoveInfo.and.returnValue(moveInfo);

            // Call the method through the component instance
            component['movePlayerFromPath']();

            expect(gameManagerServiceSpy.getMoveInfo).toHaveBeenCalled();
            expect(movementSocketServiceSpy.movedPlayer).toHaveBeenCalledWith(moveInfo);
        });
    });

    describe('Play mode', () => {
        beforeEach(() => {
            component.mode = 'play';
            actionServiceSpy.selectCell.calls.reset();
            actionServiceSpy.toggleSelection.calls.reset();
            actionServiceSpy.interact.calls.reset();
            movementSocketServiceSpy.teleportPlayer.calls.reset();
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
                Object.defineProperty(gameManagerServiceSpy, 'isPlayerTurn', { get: () => true });
                gameManagerServiceSpy.currentPlayerId = gameManagerServiceSpy.getMainPlayer()?.id as string;
                component.handleMouseDown(event, cell1);
                expect(actionServiceSpy.selectSingleCell).toHaveBeenCalledWith(cell1);
                expect(movementSocketServiceSpy.teleportPlayer).toHaveBeenCalledWith(cell1.x, cell1.y);
            });

            it('should handle right click with debugging false', () => {
                event = new MouseEvent('mousedown', { button: 2 });
                gameManagerServiceSpy.room.isDebugging = false;
                component.handleMouseDown(event, cell);
                expect(actionServiceSpy.toggleSelection).toHaveBeenCalled();
                expect(actionServiceSpy.selectSingleCell).toHaveBeenCalledWith(cell);
                expect(movementSocketServiceSpy.teleportPlayer).not.toHaveBeenCalled();
            });

            it('should call interact when isActionActive is true', () => {
                event = new MouseEvent('mousedown', { button: 0 });
                actionServiceSpy.getIsActionActive.and.returnValue(true);
                actionServiceSpy.getIsSelectionActive.and.returnValue(false);

                component.handleMouseDown(event, cell);

                expect(actionServiceSpy.interact).toHaveBeenCalled();
                expect(actionServiceSpy.selectSingleCell).toHaveBeenCalledWith(cell);
            });

            it('should call movePlayerFromPath when isActionActive is false and isSelectionActive is true', () => {
                event = new MouseEvent('mousedown', { button: 0 });
                actionServiceSpy.getIsActionActive.and.returnValue(false);
                actionServiceSpy.getIsSelectionActive.and.returnValue(true);
                // eslint-disable-next-line @typescript-eslint/no-explicit-any
                const movePathSpy = spyOn<any>(component, 'movePlayerFromPath');

                component.handleMouseDown(event, cell);

                expect(movePathSpy).toHaveBeenCalled();
                expect(actionServiceSpy.interact).not.toHaveBeenCalled();
            });

            it('should do nothing when isActionActive is false and isSelectionActive is false', () => {
                event = new MouseEvent('mousedown', { button: 0 });
                actionServiceSpy.getIsActionActive.and.returnValue(false);
                actionServiceSpy.getIsSelectionActive.and.returnValue(false);
                // eslint-disable-next-line @typescript-eslint/no-explicit-any
                const movePathSpy = spyOn<any>(component, 'movePlayerFromPath');

                component.handleMouseDown(event, cell);

                expect(movePathSpy).not.toHaveBeenCalled();
                expect(actionServiceSpy.interact).not.toHaveBeenCalled();
            });
        });

        it('handleMouseMove in play mode should select cell and set path', () => {
            const cell = new Cell(new Tile('snow'), 7, 7);
            component.handleMouseMove(cell);
            expect(actionServiceSpy.selectCell).toHaveBeenCalledWith(cell);
            expect(gameManagerServiceSpy.setPathFromCoord).toHaveBeenCalledWith({ x: cell.x, y: cell.y });
        });

        describe('handleMouseMove selection behavior', () => {
            let cell: Cell;

            beforeEach(() => {
                cell = new Cell(new Tile('snow'), 7, 7);
            });

            it('should not set selection active when cell is not available', () => {
                gameManagerServiceSpy.getPaths.and.returnValue([]);
                actionServiceSpy.getIsActionActive.and.returnValue(false);

                component.handleMouseMove(cell);

                expect(actionServiceSpy.setSelectionActive).not.toHaveBeenCalled();
            });

            it('should not set selection active when action is active', () => {
                gameManagerServiceSpy.getPaths.and.returnValue([cell]);
                actionServiceSpy.getIsActionActive.and.returnValue(true);

                component.handleMouseMove(cell);

                expect(actionServiceSpy.setSelectionActive).not.toHaveBeenCalled();
            });
        });

        it('should call movePlayerFromPath when left click and selection is active', () => {
            component.mode = 'play';
            fixture.detectChanges();

            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            const movePathSpy = spyOn<any>(component, 'movePlayerFromPath');
            actionServiceSpy.getIsActionActive.and.returnValue(false);
            actionServiceSpy.getIsSelectionActive.and.returnValue(true);

            const event = new MouseEvent('mousedown', { button: 0 });
            component.handleMouseDown(event, cell1);

            expect(movePathSpy).toHaveBeenCalled();
            expect(actionServiceSpy.interact).not.toHaveBeenCalled();
        });

        it('should teleport player when debugging is enabled and it is player turn', () => {
            const cell = new Cell(new Tile('snow'), 5, 5);
            gameManagerServiceSpy.room.isDebugging = true;
            Object.defineProperty(gameManagerServiceSpy, 'isPlayerTurn', { get: () => true });

            component.handleMouseDown(new MouseEvent('mousedown', { button: 2 }), cell);

            expect(movementSocketServiceSpy.teleportPlayer).toHaveBeenCalledWith(cell.x, cell.y);
        });

        it('should not teleport player when debugging is disabled', () => {
            const cell = new Cell(new Tile('snow'), 5, 5);
            gameManagerServiceSpy.room.isDebugging = false;
            Object.defineProperty(gameManagerServiceSpy, 'isPlayerTurn', { get: () => true });

            component.handleMouseDown(new MouseEvent('mousedown', { button: 2 }), cell);

            expect(movementSocketServiceSpy.teleportPlayer).not.toHaveBeenCalled();
        });

        it('should not teleport player when it is not player turn', () => {
            const cell = new Cell(new Tile('snow'), 5, 5);
            gameManagerServiceSpy.room.isDebugging = true;
            Object.defineProperty(gameManagerServiceSpy, 'isPlayerTurn', { get: () => false });

            component.handleMouseDown(new MouseEvent('mousedown', { button: 2 }), cell);

            expect(movementSocketServiceSpy.teleportPlayer).not.toHaveBeenCalled();
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

        it('should return isSelectionActive from actionService', () => {
            actionServiceSpy.getIsSelectionActive.and.returnValue(true);
            expect(component.isSelectionActive).toBe(true);
            expect(actionServiceSpy.getIsSelectionActive).toHaveBeenCalled();
        });
    });
});

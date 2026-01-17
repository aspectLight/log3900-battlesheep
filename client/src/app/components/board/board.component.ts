import { Component, EventEmitter, Input, OnDestroy, OnInit, Output } from '@angular/core';
import { Board } from '@app/classes/board';
import { Cell } from '@app/classes/cell';
import { Item } from '@app/classes/item';
import { PlayerComponent } from '@app/components/player/player.component';
import { ActionService } from '@app/services/action.service';
import { DragDropService } from '@app/services/drag-drop.service';
import { GameManagerService } from '@app/services/game-manager.service';
import { MovementService } from '@app/services/movement.service';
import { PaintService } from '@app/services/paint.service';
import { MovementSocketService } from '@app/services/socket/movement-socket.service';
import { Subscription } from 'rxjs';

@Component({
    selector: 'app-board',
    templateUrl: './board.component.html',
    styleUrls: ['./board.component.scss'],
    imports: [PlayerComponent],
})

/*
For now, we have no need to create a service for game modes, hence the choice to implement with if statements.
We could have used a decorator, or even a function map, but the code becomes much less maintainable.

Additionally, we haven't really decided yet if we're going to reuse this component for the main game. Therefore, adding such a service this early
in the project would add coupling between services that we might potentially need to remove later based on our future choices.
*/
export class BoardComponent implements OnInit, OnDestroy {
    @Input() board!: Board;
    @Input() mode: 'view' | 'edit' | 'play' = 'view';
    @Input() title: string = '';
    @Output() cellClicked = new EventEmitter<Cell>();

    selectedCell: Cell | null = null;
    private subscriptions: Subscription[] = [];

    // eslint-disable-next-line max-params
    constructor(
        private paintService: PaintService,
        private dragDropService: DragDropService,
        private actionService: ActionService,
        public gameManagerService: GameManagerService,
        private movementSocketService: MovementSocketService,
        private movementService: MovementService,
    ) {}

    get selectedPath() {
        return this.gameManagerService.getSelectedPath();
    }

    get availableCells() {
        return this.gameManagerService.getPaths();
    }

    get isSelectionActive() {
        return this.actionService.getIsSelectionActive();
    }

    get isActionActive() {
        return this.actionService.getIsActionActive();
    }

    ngOnInit(): void {
        if (this.mode === 'play') {
            this.subscriptions.push(
                this.actionService.selectedCell$.subscribe((cell) => {
                    this.selectedCell = cell;
                }),
            );
        }
    }

    ngOnDestroy(): void {
        this.subscriptions.forEach((sub) => sub.unsubscribe());
    }

    handleMouseDown(event: MouseEvent, cell: Cell): void {
        if (this.mode === 'edit') {
            this.paintService.handleMouseDown(event, cell, this.board);
        }
        if (this.mode === 'play') {
            this.actionService.selectSingleCell(cell);

            if (event.button === 2) {
                if (this.gameManagerService.room.isDebugging && this.gameManagerService.isPlayerTurn) {
                    if (!this.movementService.isCellFree(cell)) {
                        return;
                    }
                    this.movementSocketService.teleportPlayer(cell.x, cell.y);
                    return;
                }
                this.actionService.toggleSelection();
                return;
            } else {
                if (this.isActionActive) {
                    this.actionService.interact();
                    return;
                } else {
                    if (!this.isSelectionActive) return;
                    this.gameManagerService.setPathFromCoord({ x: cell.x, y: cell.y });
                    this.movePlayerFromPath();
                }
            }
        }
    }

    handleMouseMove(cell: Cell): void {
        if (this.mode === 'edit') {
            this.paintService.handleMouseMove(cell, this.board);
        }
        if (this.mode === 'play') {
            this.actionService.selectCell(cell);
            this.gameManagerService.setPathFromCoord({ x: cell.x, y: cell.y });
        }
    }

    handleMouseUp(): void {
        if (this.mode === 'edit') {
            this.paintService.handleMouseUp();
        }
    }

    handleDrag(cell: Cell): void {
        if (this.mode === 'edit') {
            const item: Item | null = cell.getItem();
            if (item) {
                this.dragDropService.startDrag(item, cell);
            }
        }
    }

    handleDragEnd(): void {
        if (this.mode === 'edit') {
            this.dragDropService.handleDragEnd();
        }
    }

    handleDragOver(event: DragEvent): void {
        if (this.mode === 'edit') {
            this.dragDropService.allowDrop(event);
        }
    }

    handleDrop(cell: Cell): void {
        if (this.mode === 'edit') {
            this.dragDropService.handleDrop(cell);
        }
    }

    disableContextMenu(event: MouseEvent): void {
        event.preventDefault();
    }

    private async movePlayerFromPath(): Promise<void> {
        const moveInfo = this.gameManagerService.getMoveInfo();

        if (!moveInfo?.selectedPath?.length) return;

        if (this.gameManagerService.movementService.isMoving()) {
            return;
        }

        const response = await this.movementSocketService.movedPlayer(moveInfo);

        if (!response.success && response.error) {
            // eslint-disable-next-line no-console
            console.warn('Movement rejected:', response.error);
        }
    }
}

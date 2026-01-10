import { Component, EventEmitter, Input, OnDestroy, OnInit, Output } from '@angular/core';
import { Board } from '@app/classes/board';
import { Cell } from '@app/classes/cell';
import { Item } from '@app/classes/item';
import { PlayerComponent } from '@app/components/player/player.component';
import { DragDropService } from '@app/services/drag-drop.service';
import { PaintService } from '@app/services/paint.service';
import { ActionService } from '@app/services/action.service';
import { Subscription } from 'rxjs';
import { GameManagerService } from '@app/services/game-manager.service';
import { SocketService } from '@app/services/socket.service';

@Component({
    selector: 'app-board',
    templateUrl: './board.component.html',
    styleUrls: ['./board.component.scss'],
    imports: [PlayerComponent],
})

/*
Pour l'instant, nous avons aucune utilité de faire un service pour les modes de jeux, d'ou le choix d'implémentation avec des if.
Nous aurions pû faire un décorateur, ou même une map de fonction, mais le code devient beaucoup moins maintenable.

De plus, nous n'avons pas vraiment encore choisi si nous allons réutiliser ce component pour le jeu principal. Ainsi, ajouter un tel service aussi tôt 
dans le projet viendrait rajouter du couplage entre service, que nous aurons potentiellement besoin d'enlever plus tard selon nos choix futurs.
*/
export class BoardComponent implements OnInit, OnDestroy {
    @Input() board!: Board;
    @Input() mode: 'view' | 'edit' | 'play' = 'view';
    @Input() title: string = '';
    @Output() cellClicked = new EventEmitter<Cell>();

    selectedCell: Cell | null = null;
    private subscriptions: Subscription[] = [];

    constructor(
        private paintService: PaintService,
        private dragDropService: DragDropService,
        private actionService: ActionService,
        public gameManagerService: GameManagerService,
        public socketService: SocketService,
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

    get isDebugMode() {
        return this.gameManagerService.isDebugMode;
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
                if (this.gameManagerService.room.isDebugging) {
                    if (this.gameManagerService.getMainPlayer()?.id === this.gameManagerService.currentPlayerId)
                        this.socketService.teleportPlayer(cell.x, cell.y);
                    return;
                }
                this.actionService.toggleSelection();
                return;
            } else {
                this.actionService.interact();
                if (!this.isSelectionActive) return;
                this.movePlayerFromPath();
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

    movePlayerFromPath(): void {
        const moveInfo = this.gameManagerService.getMoveInfo();

        if (moveInfo) {
            this.socketService.movedPlayer(moveInfo);
        }
    }

    disableContextMenu(event: MouseEvent): void {
        event.preventDefault();
    }
}

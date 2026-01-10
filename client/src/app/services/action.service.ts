import { Injectable } from '@angular/core';
import { Cell } from '@app/classes/cell';
import { BehaviorSubject } from 'rxjs';
import { GameManagerService } from './game-manager.service';
import { CombatService } from './combat.service';
import { Player } from '@app/classes/player';
import { SocketService } from './socket.service';

@Injectable({
    providedIn: 'root',
})
export class ActionService {
    selectedCell = new BehaviorSubject<Cell | null>(null);
    selectedCell$ = this.selectedCell.asObservable();

    isSelectionActive = new BehaviorSubject<boolean>(false);
    isSelectionActive$ = this.isSelectionActive.asObservable();

    constructor(
        private gameManager: GameManagerService,
        private combatService: CombatService,
        private socketService: SocketService,
    ) {}

    get player() {
        return this.gameManager.movementService.selectedPlayer;
    }

    get enemy(): Player | null {
        return this.combatService.getEnemy();
    }

    set enemy(enemy: Player) {
        this.combatService.setEnemy(enemy);
    }

    set canFight(value: boolean) {
        this.combatService.canFight = value;
    }

    set canAct(value: boolean) {
        this.combatService.canAct = value;
    }

    getIsSelectionActive(): boolean {
        return this.isSelectionActive.value;
    }

    startCombat(cell: Cell) {
        if (!cell.player) return;
        this.enemy = cell.player;
        this.setSelectionActive(false); // Deselect the cell
        const startCombatInfo = this.combatService.startCombat(this.enemy);
        if (!startCombatInfo) return;
        this.socketService.startCombat(startCombatInfo);
    }

    toggleSelection(): void {
        const newState = !this.isSelectionActive.value;
        this.isSelectionActive.next(newState);

        if (!newState) {
            this.selectedCell.next(null);
        }
    }

    setSelectionActive(value: boolean): void {
        this.isSelectionActive.next(value);
    }

    selectCell(cell: Cell): void {
        if (this.isSelectionActive.value) {
            this.selectedCell.next(cell);
            this.canFight = this.canPlayerFight();
            this.canAct = this.canPlayerAct();
        }
    }

    selectSingleCell(cell: Cell): void {
        this.selectedCell.next(cell);
        this.canFight = this.canPlayerFight();
        this.canAct = this.canPlayerAct();
    }

    interact(): void {
        if (!this.player) return;

        const cell = this.selectedCell.value;

        if (!cell || !this.isCellCloseToPlayer() || this.player.actionPoints <= 0) return;

        if (cell.tile.type === 'door') {
            if (cell.tile.state === 'closed' && !cell.player) {
                this.toggleDoor(cell);
            } else if (cell.tile.state === 'opened' && !cell.player) {
                this.toggleDoor(cell);
            }
        }
        if (cell.player) {
            this.startCombat(cell);
            this.removeActionPoints();
        }
    }

    removeActionPoints() {
        if (!this.player) return;
        if (this.gameManager.isDebugMode) return;
        this.player.actionPoints--;
    }

    toggleDoor(cell: Cell) {
        this.socketService.toggleDoor(cell.x, cell.y);
        this.removeActionPoints();
    }

    isCellCloseToPlayer(): boolean {
        if (!this.player) return false;

        const player = this.gameManager.getBoard().getPlayerById(this.player.id);

        if (!player) {
            return false;
        }

        if (!player.cell) {
            return false;
        }

        if (!this.selectedCell.value) {
            return false;
        }

        const playerX = player.cell.x;
        const playerY = player.cell.y;
        const cellX = this.selectedCell.value.x;
        const cellY = this.selectedCell.value.y;

        return (Math.abs(playerX - cellX) === 1 && playerY === cellY) || (Math.abs(playerY - cellY) === 1 && playerX === cellX);
    }

    canPlayerFight(): boolean {
        // Check if player exists and has action points
        if (!this.player || this.player.actionPoints <= 0) {
            return false;
        }

        // Check if there's a selected cell with an enemy player
        const cell = this.selectedCell.value;
        if (!cell || !cell.player || cell.player.id === this.player.id) {
            return false;
        }

        // Check if the cell with enemy is adjacent to the player
        return this.isCellCloseToPlayer();
    }

    canPlayerAct(): boolean {
        // Check if player exists and has action points
        if (!this.player || this.player.actionPoints <= 0) {
            return false;
        }

        // Check if there's a selected cell
        const cell = this.selectedCell.value;
        if (!cell) {
            return false;
        }

        // Check if cell is adjacent to player
        if (!this.isCellCloseToPlayer()) {
            return false;
        }

        // Check if cell has a door or a player (something to interact with)
        return (cell.tile.type === 'door' && (cell.tile.state === 'closed' || cell.tile.state === 'opened') && !cell.player) || cell.player !== null;
    }
}

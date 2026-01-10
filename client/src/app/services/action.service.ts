import { Injectable } from '@angular/core';
import { Cell } from '@app/classes/cell';
import { BehaviorSubject } from 'rxjs';
import { GameManagerService } from './game-manager.service';
import { CombatService } from './combat.service';
import { Player } from '@app/classes/player';
import { SocketService } from './socket.service';
import { MovementService } from './movement.service';
import { ActionSocketService } from './socket/action-socket.service';
@Injectable({
    providedIn: 'root',
})
export class ActionService {
    selectedCell = new BehaviorSubject<Cell | null>(null);
    selectedCell$ = this.selectedCell.asObservable();

    isSelectionActive = new BehaviorSubject<boolean>(false);
    isSelectionActive$ = this.isSelectionActive.asObservable();

    isActionActive = new BehaviorSubject<boolean>(false);
    isActionActive$ = this.isActionActive.asObservable();

    constructor(
        private gameManager: GameManagerService,
        private combatService: CombatService,
        private socketService: SocketService,
        private movementService: MovementService,
        private actionSocketService: ActionSocketService,
    ) {}

    get player() {
        return this.gameManager.getMainPlayer();
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

    getIsActionActive(): boolean {
        return this.isActionActive.value;
    }

    startCombat(cell: Cell) {
        if (!cell.player) return;
        this.enemy = cell.player;
        this.setSelectionActive(false);
        const startCombatInfo = this.combatService.startCombat(this.enemy);
        if (!startCombatInfo) return;
        this.actionSocketService.startCombat(startCombatInfo);
    }

    switchModes() {
        if (this.isSelectionActive.value) {
            this.isSelectionActive.next(false);
            this.isActionActive.next(true);
        } else {
            this.isSelectionActive.next(true);
            this.isActionActive.next(false);
        }
    }

    toggleSelection(): void {
        const newState = !this.isSelectionActive.value;
        this.isSelectionActive.next(newState);

        if (!newState) {
            this.selectedCell.next(null);
        }
        this.isActionActive.next(false);
    }

    toggleAction(): void {
        const newState = !this.isActionActive.value;
        this.isActionActive.next(newState);
        this.isSelectionActive.next(false);
    }

    setSelectionActive(value: boolean): void {
        this.isSelectionActive.next(value);
    }

    setActionActive(value: boolean): void {
        this.isActionActive.next(value);
    }

    selectCell(cell: Cell): void {
        if (this.isSelectionActive.value || this.isActionActive.value) {
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
        if (!this.player || this.player.actionPoints <= 0 || !this.gameManager.isPlayerTurn) return;

        const cell = this.selectedCell.value;
        if (!cell) return;

        const hasCamo = this.player.hasItem('camouflage');
        const hasAirStrike = this.player.hasItem('airStrike');

        if (!this.isCellCloseToPlayer()) {
            this.handleRemoteAction(cell, hasAirStrike, hasCamo);
            return;
        }

        this.handleDoorToggle(cell);

        if (cell.player && (!this.gameManager.isCTF || this.player.team !== cell.player.team)) {
            this.startCombat(cell);
            this.removeActionPoints();
        }
    }

    removeActionPoints() {
        if (!this.player) return;
        if (this.gameManager.isDebugMode) return;
        this.player.actionPoints--;
        this.switchModes();
    }

    toggleDoor(cell: Cell) {
        this.actionSocketService.toggleDoor(cell.x, cell.y);
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
        if (!this.player || this.player.actionPoints <= 0) {
            return false;
        }

        const cell = this.selectedCell.value;
        if (!cell || !cell.player || cell.player.id === this.player.id) {
            return false;
        }

        return this.isCellCloseToPlayer();
    }

    canPlayerAct(): boolean {
        if (!this.player || this.player.actionPoints <= 0) {
            return false;
        }

        const cell = this.selectedCell.value;
        if (!cell) {
            return false;
        }

        if (!this.isCellCloseToPlayer()) {
            return false;
        }

        return (cell.tile.type === 'door' && (cell.tile.state === 'closed' || cell.tile.state === 'opened') && !cell.player) || cell.player !== null;
    }

    private handleRemoteAction(cell: Cell, hasAirStrike: boolean, hasCamo: boolean): void {
        if (cell.player && hasAirStrike) {
            this.startCombat(cell);
            this.removeActionPoints();
        } else if (cell && hasCamo && this.movementService.isCellFree(cell)) {
            const playerId = cell.player?.id || '';
            this.socketService.teleportPlayer(cell.x, cell.y, playerId, hasCamo);
            this.removeActionPoints();
        }
    }

    private handleDoorToggle(cell: Cell): void {
        if (cell.tile.type === 'door' && !cell.player && !cell.item) {
            if (cell.tile.state === 'closed' || cell.tile.state === 'opened') {
                this.toggleDoor(cell);
            }
        }
    }
}

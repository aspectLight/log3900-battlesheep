/* eslint-disable max-lines */
import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { Board } from '@app/classes/board';
import { Cell } from '@app/classes/cell';
import { Game } from '@app/classes/game';
import { Item } from '@app/classes/item';
import { Player } from '@app/classes/player';
import { BonusType } from '@app/constants/bonus.constants';
import { ITEM_TYPES } from '@app/constants/item.constants';
import { ROUTES } from '@app/constants/routes.constants';
import { Coords } from '@app/interfaces/coords';
import { Room } from '@app/interfaces/room';
import { API_ENDPOINTS } from '@common/api-endpoints.constants';
import { BehaviorSubject, Observable, Subject } from 'rxjs';
import { environment } from 'src/environments/environment';
import { GameRoomService } from './game-room.service';
import { MovementService } from './movement.service';
import { PathService } from './path.service';

@Injectable({
    providedIn: 'root',
})
export class GameManagerService {
    notificationMessage: string;

    notificationTime: number;
    isNotificationVisible: boolean = false;

    isGameCanceled: boolean = false;
    isGameFinished: boolean = false;
    isGameLoaded: boolean = false;
    gameCountdown: Subject<number> = new Subject<number>();
    turnCountdown: Subject<number> = new Subject<number>();

    currentPlayerId: string = '';
    disconnectedPlayer: Player[] = [];
    turnChangeSubject = new Subject<void>();
    turnChange = this.turnChangeSubject.asObservable();
    canEndTurn: boolean = false;

    isReplacementPopupVisible: boolean = false;
    replacementPopupMessage: string = '';
    pendingReplacement: { player: Player; newItem: Item; candidateItems: Item[]; cellCoords: Coords } | null = null;
    dropItem: (item: Item, coords: Coords) => void;

    movementService: MovementService;
    room: Room;

    playerWithFlag: string | null = null;
    winner: string;

    private game: Game;
    private board: Board;

    private mainPlayerId: string = '';
    private currentPlayerSubject = new BehaviorSubject<Player>(new Player());
    private currentPlayer: Observable<Player> = this.currentPlayerSubject.asObservable();

    constructor(
        private http: HttpClient,
        private gameRoomService: GameRoomService,
        private pathService: PathService,
        private router: Router,
    ) {
        this.movementService = new MovementService();
        this.gameRoomService.room$.subscribe((room) => {
            this.room = room;
        });
    }

    get isPlayerTurn(): boolean {
        const currentPlayer = this.currentPlayerSubject.getValue();
        if (!this.mainPlayer) return false;
        return currentPlayer.id === this.mainPlayer.id;
    }

    get isDebugMode(): boolean {
        return this.room.isDebugging;
    }

    get isCTF(): boolean {
        return this.game.isCTF;
    }

    get mainPlayer(): Player | null {
        return this.board.getPlayerById(this.mainPlayerId);
    }

    hasWon(): boolean {
        const winner = this.getPlayers().find((p) => p.id === this.winner);
        if (!winner) return false;
        return this.mainPlayerId === winner.id || (this.mainPlayer?.team !== undefined && this.mainPlayer.team === winner.team);
    }

    getWinner(): string {
        if (this.isCTF) {
            return this.room.players.find((p) => p.id === this.winner)?.team === 1 ? 'USSR' : 'USA';
        }
        return this.room.players.find((p) => p.id === this.winner)?.name as string;
    }

    getGame() {
        return this.game;
    }

    resetManager() {
        this.isGameCanceled = false;
        this.isGameFinished = false;
        this.isGameLoaded = false;
        this.disconnectedPlayer = [];
    }

    cancelGame() {
        this.isGameCanceled = true;
    }

    finishGame(winnerId: string) {
        const delay = 5000;
        this.isGameFinished = true;
        this.winner = winnerId;
        setTimeout(() => {
            this.router.navigate([ROUTES.endGame]);
            this.isGameFinished = false;
        }, delay);
        for (const player of this.room.players) {
            if (!player.isVirtual) player.clearInfo();
        }
    }

    loadGame(): Observable<Game> {
        const subject = new Subject<Game>();
        if (this.room.gameId) {
            this.fetchGame(this.room.gameId).subscribe((game) => {
                this.game = new Game(game);
                this.board = this.game.board;
                this.isGameLoaded = true;
                subject.next(game);
                subject.complete();
            });
        }
        return subject.asObservable();
    }

    fetchGame(gameId: string): Observable<Game> {
        return this.http.get<Game>(environment.serverUrl + API_ENDPOINTS.games + gameId);
    }

    getIsGameLoaded(): boolean {
        return this.isGameLoaded;
    }

    getBoard(): Board {
        return this.board;
    }

    addPlayersToBoard(players: Player[]): boolean {
        const uniqueItems = { ...ITEM_TYPES };

        for (const p of players) {
            const player = Player.fromObject(p);
            const cell = this.board.getCell(player.spawnPoint.x, player.spawnPoint.y);
            if (!cell) {
                return false;
            }
            if (cell.getEntity()) {
                return false;
            }

            player.addCell(cell);
            cell.addEntity(player);
        }

        const matrix = this.board.matrix;
        for (const row of matrix) {
            for (const cell of row) {
                if (cell.item && !cell.player) {
                    if (cell.item.type === 'spawnPoint') {
                        cell.item = null;
                    } else if (cell.item.type === 'random') {
                        const seed = this.room.roomId.split('').reduce((acc, char) => acc + char.charCodeAt(0), 0);
                        const availableItems = Object.keys(uniqueItems).filter(
                            (type) => type !== 'random' && type !== 'spawnPoint' && type !== 'flag',
                        );
                        if (availableItems.length === 0) {
                            cell.item = null;
                        } else {
                            const randomIndex = Math.abs(seed) % availableItems.length;
                            const randomItemType = availableItems[randomIndex];
                            cell.item = new Item(randomItemType);
                            delete uniqueItems[randomItemType];
                        }
                    } else if (cell.item.type in uniqueItems) {
                        delete uniqueItems[cell.item.type];
                    } else {
                        cell.item = null;
                    }
                } else if (cell.player && cell.item) {
                    if (cell.item.type === 'spawnPoint') {
                        const playerColor = cell.player.color;
                        cell.item.imagePath = `assets/items/${playerColor}_spawn.gif`;
                    }
                }
            }
        }

        return true;
    }

    getPlayers(): Player[] {
        return this.room.players;
    }

    getMainPlayer() {
        return this.board.getPlayerById(this.mainPlayerId);
    }

    getCurrentPlayer(): Observable<Player> {
        return this.currentPlayer;
    }

    getRoomId(): string {
        return this.room.roomId;
    }

    setMainPlayer(id: string | undefined) {
        if (!id) return;
        this.mainPlayerId = id;
        if (!this.mainPlayer) return;
        this.mainPlayer.onReplaceItem = (newItem: Item, inventory: [Item | null, Item | null], cellCoords: Coords) => {
            const invItems = inventory.filter((item) => item !== null) as Item[];
            const candidateItems = [...invItems, newItem];
            this.triggerReplacementPopup(this.mainPlayer as Player, newItem, candidateItems, cellCoords);
        };
    }

    getPlayerById(playerId: string): Player | null {
        return this.board.getPlayerById(playerId);
    }

    disconnectPlayer(playerId: string) {
        const playerIndex = this.room.players.findIndex((player) => player.id === playerId);

        if (playerIndex !== -1) {
            const [disconnected] = this.room.players.splice(playerIndex, 1);
            this.disconnectedPlayer.push(disconnected);
            this.getPlayerById(playerId)?.clearInfo();
            this.removePlayer(playerId);
        }
    }

    removePlayer(playerId: string): void {
        const player = this.board.getPlayerById(playerId);

        if (player) {
            const playerCell = player.cell;
            if (playerCell && playerCell.getEntity() === player) {
                playerCell.removeEntity();
            }
        }
    }

    updateScore(playerId: string): number {
        const foundPlayer = this.room.players.find((p) => p.id === playerId);
        if (!foundPlayer) return 0;
        foundPlayer.fightsWon++;
        return foundPlayer.fightsWon;
    }

    setPlayer(player: Player) {
        this.movementService.selectedPlayer = player;
    }

    setPathFromCoord(coords: Coords) {
        this.pathService.setPathFromCoord(coords, this.board);
    }

    setSelectedPathFromCoords(selectedPath: Coords[]) {
        this.pathService.setSelectedPathFromCoords(selectedPath, this.board);
    }

    setPaths(map: Map<Coords, Coords[]>) {
        this.pathService.setPaths(map);
    }

    getPaths() {
        return this.pathService.getAllCellsFromPaths(this.board);
    }

    async movePlayerFromPath(callback?: (item?: Item, cell?: Cell) => void) {
        this.canEndTurn = false;
        const result = await this.movementService.movePlayerFromPath(this.board, this.pathService.selectedPath);
        this.resetPlayerSelection();

        if (result.success && result.cell) {
            const collectedItem = this.handleItemCollection(result.cell);
            if (callback) {
                callback(collectedItem?.item, collectedItem?.cell);
            }
        }
        this.pathService.clearPath();
    }

    teleportPlayer(destinationX: number, destinationY: number) {
        const cell = this.board.getCell(destinationX, destinationY);
        if (!cell) return;
        this.handleItemCollection(cell);
        this.movementService.teleportPlayer(this.board, cell.x, cell.y);
        this.resetPlayerSelection();
    }

    clearPaths() {
        this.pathService.clearService();
    }

    getMoveInfo() {
        if (!this.movementService.selectedPlayer) return;
        const roomId = this.room.roomId;
        const playerId = this.movementService.selectedPlayer.id;
        const map = this.pathService.paths;
        const selectedPath = this.pathService.getSelectedPathAsCoords();
        return { roomId, playerId, map, selectedPath };
    }

    selectPlayer(player: Player) {
        this.movementService.selectPlayer(player);
    }

    resetPlayerSelection() {
        if (this.mainPlayer) this.movementService.selectedPlayer = this.mainPlayer;
    }

    setMovementPoints(points: number) {
        if (!this.mainPlayer || !this.isPlayerTurn) return;
        this.mainPlayer.movementPoints = points;
    }

    setActionPoints(points: number) {
        if (!this.mainPlayer) return;
        this.mainPlayer.actionPoints = points;
    }

    getSelectedPath() {
        return this.pathService.selectedPath;
    }

    isPlayerMoving() {
        return this.movementService.isMoving();
    }

    handleTurnStarting(player: Player, countdown: number): void {
        this.clearPaths();
        this.notificationMessage = `Le tour de ${player.name} commence dans 3 secondes!`;
        this.notificationTime = countdown;
        this.updateCurrentPlayer(player);
    }

    startTurn(player: Player): void {
        this.updateCurrentPlayer(player);
    }

    triggerReplacementPopup(player: Player, newItem: Item, candidateItems: Item[], cellCoords: Coords): void {
        this.pendingReplacement = { player, newItem, candidateItems, cellCoords };
        this.replacementPopupMessage = "Inventaire plein ! Choisissez l'objet à rejeter :";
        this.isReplacementPopupVisible = true;
    }

    processReplacement(selectedItem: Item): [Item, Coords] {
        let toDrop: Item | undefined;
        let coords: Coords = { x: -1, y: -1 };
        if (this.pendingReplacement) {
            const { player, newItem, cellCoords } = this.pendingReplacement;
            coords = cellCoords;
            const index = player.inventory.findIndex((item) => item === selectedItem);
            if (index !== -1) {
                player.updateItemsEffect(-1);
                toDrop = player.inventory[index] as Item;
                player.inventory[index] = newItem;
                player.updateItemsEffect(1);
            } else {
                toDrop = newItem;
            }
            this.pendingReplacement = null;
            this.isReplacementPopupVisible = false;
        }
        return [toDrop as Item, coords];
    }

    addItemToBoard(item: Item, coords: Coords): void {
        if (coords.x < 0 || coords.y < 0 || coords.x >= this.board.matrix.length || coords.y >= this.board.matrix[0].length) {
            return;
        }
        this.board.matrix[coords.x][coords.y].addItem(item);
    }

    combatLost(loserId: string): void {
        const loser = this.board.getPlayerById(loserId);
        if (!loser) {
            return;
        }
        const playerCoords = this.board.getPlayerCoordsById(loserId);
        if (!playerCoords) {
            return;
        }
        const emptyCells = this.board.getTwoNearestEmptyCells(playerCoords);
        for (let i = 0; i < 2; i++) {
            if (loser.inventory[i]) {
                loser.updateItemsEffect(-1);
                this.dropItem(loser.inventory[i] as Item, emptyCells[i]);
            }
        }
        loser.inventory = [null, null];
    }

    setMainPlayerHealth(value: number) {
        this.mainPlayer?.setStatValue(BonusType.Health, value);
    }

    redirect(): void {
        this.router.navigate([ROUTES.game]);
    }

    private handleItemCollection(cell: Cell): { item: Item; cell: Cell } | undefined {
        if (!cell.item) {
            return undefined;
        }
        const item = cell.item;
        if (item.type === 'spawnPoint') {
            return undefined;
        }

        let playerToUpdate: Player | null;
        if (this.isPlayerTurn && this.mainPlayer) {
            playerToUpdate = this.mainPlayer;
        }
        playerToUpdate = this.getBoard().getPlayerById(this.currentPlayerId);

        if (!playerToUpdate) {
            return undefined;
        }
        if (playerToUpdate.addItem(item) !== true) {
            playerToUpdate.replaceItem(item, { x: cell.x, y: cell.y });
        }

        cell.removeItem();
        return { item, cell };
    }

    private updateCurrentPlayer(player: Player): void {
        this.currentPlayerSubject.next(player);
        this.turnChangeSubject.next();
    }
}

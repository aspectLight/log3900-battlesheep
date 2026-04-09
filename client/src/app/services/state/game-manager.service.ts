/* eslint-disable max-lines */
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Auth } from '@angular/fire/auth';
import { Router } from '@angular/router';
import { Board } from '@app/classes/board/board';
import { Cell } from '@app/classes/board/cell';
import { Item } from '@app/classes/entity/item';
import { Player } from '@app/classes/entity/player';
import { Game } from '@app/classes/game/game';
import { BonusType } from '@app/constants/bonus.constants';
import { ITEM_TYPES } from '@app/constants/item.constants';
import { ROUTES } from '@app/constants/routes.constants';
import { Coords } from '@app/interfaces/coords.interface';
import { Room } from '@app/interfaces/room.interface';
import { MovementService } from '@app/services/gameplay/movement.service';
import { PathService } from '@app/services/gameplay/path.service';
import { HistoryService } from '@app/services/history/history.service';
import { GameRoomService } from '@app/services/state/game-room.service';
import { SessionService } from '@app/services/state/session.service';
import { API_ENDPOINTS } from '@common/api-endpoints.constants';
import { TranslateService } from '@ngx-translate/core';
import { BehaviorSubject, Observable, Subject, from, switchMap } from 'rxjs';
import { environment } from 'src/environments/environment';

@Injectable({
    providedIn: 'root',
})
export class GameManagerService {
    notificationMessage: string;

    notificationTime: number;
    isNotificationVisible: boolean = false;

    illuminatedCells: Set<string> = new Set();

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

    isTrapPopupVisible: boolean = false;
    trapCanAvoid: boolean = false;

    movementService: MovementService;
    room: Room;

    playerWithFlag: string | null = null;
    winner: string;
    gameRewards: { rewards: { name: string; gain: number; avatarName: string | null }[]; entryFee: number; pool: number } | null = null;

    private game: Game;
    private board: Board;
    private historyStartDateIso: string | null = null;
    private mainPlayerId: string = '';
    private currentPlayerSubject = new BehaviorSubject<Player>(new Player());
    private currentPlayer: Observable<Player> = this.currentPlayerSubject.asObservable();

    constructor(
        private http: HttpClient,
        private gameRoomService: GameRoomService,
        private pathService: PathService,
        private router: Router,
        private historyService: HistoryService,
        private auth: Auth,
        private session: SessionService,
        private translate: TranslateService,
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
        this.gameRewards = null;
        this.clearPaths();
    }

    cancelGame() {
        this.isGameCanceled = true;
        const startDate = this.historyStartDateIso;
        if (startDate) {
            this.historyService.abandonGameHistory(startDate).catch((e) => console.warn('abandonGameHistory failed', e));
            this.historyStartDateIso = null;
        }
    }

    finishGame(winnerId: string) {
        const delay = 5000;
        this.isGameFinished = true;
        this.winner = winnerId;
        const startDate = this.historyStartDateIso;

        if (startDate) {
            const won = this.hasWon();
            this.historyService.endGameHistory(startDate, won).catch((e) => console.warn('endGameHistory failed', e));
            this.historyStartDateIso = null;
        }

        setTimeout(() => {
            this.router.navigate([ROUTES.endGame]);
            this.isGameFinished = false;
        }, delay);
        for (const player of this.room.players) {
            if (!player.isVirtual) player.clearInfo();
        }
    }

    loadGame(currentBoard?: any): Observable<Game> {
        const subject = new Subject<Game>();

        if (this.room.gameId) {
            this.fetchGame(this.room.gameId).subscribe(async (game) => {
                this.game = new Game(game);
                this.board = currentBoard ? new Board(currentBoard) : this.game.board;
                this.isGameLoaded = true;

                if (!this.historyStartDateIso) {
                    const mode: 'Classique' | 'CTF' = this.game.isCTF ? 'CTF' : 'Classique';
                    try {
                        const res = await this.historyService.startGameHistory(mode);
                        this.historyStartDateIso = res.startDate;
                    } catch (e) {
                        console.warn("Impossible de créer l'historique de partie:", e);
                    }
                }

                subject.next(game);
                subject.complete();
            });
        }

        return subject.asObservable();
    }

    fetchGame(gameId: string): Observable<Game> {
        return from(this.getAuthHeaders()).pipe(
            switchMap((headers) => this.http.get<Game>(environment.serverUrl + API_ENDPOINTS.games + gameId, { headers })),
        );
    }

    private async getAuthHeaders(): Promise<HttpHeaders> {
        const user = this.auth.currentUser;
        const sessionId = this.session.sessionId;

        if (!user || !sessionId) {
            throw new Error('Utilisateur non authentifié');
        }

        const token = await user.getIdToken();
        return new HttpHeaders().set('Authorization', `Bearer ${token}`).set('x-session-id', sessionId);
    }

    getIsGameLoaded(): boolean {
        return this.isGameLoaded;
    }

    getBoard(): Board {
        return this.board;
    }

    addPlayersToBoard(players: Player[], useCurrentPosition = false): boolean {
        const uniqueItems = { ...ITEM_TYPES };

        for (const p of players) {
            const player = Player.fromObject(p);
            const currentPosition = (p as any).position as Coords | undefined;
            const coords = useCurrentPosition && currentPosition ? currentPosition : player.spawnPoint;
            const cell = this.board.getCell(coords.x, coords.y);
            if (!cell) {
                return false;
            }
            if (cell.getEntity()) {
                return false;
            }

            player.addCell(cell);
            cell.addEntity(player);
        }

        const spawnPointColorMap = new Map<string, string>();
        for (const p of players) {
            const sp = (p as any).spawnPoint as Coords | undefined;
            if (sp) {
                spawnPointColorMap.set(`${sp.x},${sp.y}`, (p as any).color ?? 'yellow');
            }
        }

        const matrix = this.board.matrix;
        for (const row of matrix) {
            for (const cell of row) {
                if (cell.item && !cell.player) {
                    if (cell.item.type === 'spawnPoint') {
                        const key = `${cell.x},${cell.y}`;
                        const color = spawnPointColorMap.get(key);
                        if (!color) {
                            cell.item = null;
                        } else {
                            cell.item.imagePath = `assets/items/${color}_spawn.gif`;
                        }
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
            const boardPlayer = this.getPlayerById(playerId);
            if (boardPlayer?.spawnPoint) {
                const spawnCell = this.board.getCell(boardPlayer.spawnPoint.x, boardPlayer.spawnPoint.y);
                if (spawnCell) spawnCell.item = null;
            }
            boardPlayer?.clearInfo();
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

    updateScore(playerId: string, fightsWon?: number): number {
        const foundPlayer = this.room.players.find((p) => p.id === playerId);
        if (!foundPlayer) return 0;
        if (fightsWon !== undefined) {
            foundPlayer.fightsWon = fightsWon;
        }
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
            // Only detect the item — don't mutate the board or inventory.
            // The server will broadcast ItemCollected after validation.
            const detected = this.detectItemOnCell(result.cell);
            if (callback) {
                callback(detected?.item, detected?.cell);
            }
        } else if (callback) {
            callback(undefined, undefined);
        }
        this.pathService.clearPath();
    }

    teleportPlayer(destinationX: number, destinationY: number): void {
        const cell = this.board.getCell(destinationX, destinationY);
        if (!cell) {
            return;
        }

        const player = this.movementService.selectedPlayer;
        if (!player) {
            return;
        }

        this.movementService.teleportPlayer(this.board, player, destinationX, destinationY);
        this.resetPlayerSelection();
    }

    clearPaths() {
        this.pathService.clearService();
    }

    isIlluminated(x: number, y: number): boolean {
        return this.illuminatedCells.has(`${x},${y}`);
    }

    updateIllumination(illuminatedCells: string[], players?: any[]): void {
        this.illuminatedCells = new Set(illuminatedCells);

        // Update player stats from server data if provided
        if (players) {
            for (const serverPlayer of players) {
                const boardPlayer = this.board.getPlayerById(serverPlayer.id);
                if (boardPlayer && serverPlayer.stats) {
                    boardPlayer.setStatValue(BonusType.Attack, serverPlayer.stats['attack'].value);
                    boardPlayer.setStatValue(BonusType.Defense, serverPlayer.stats['defense'].value);
                }
            }
        }
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
        this.notificationMessage = this.translate.instant('game_info.turn_starting', { name: player.name });
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

        loser.updateItemsEffect(-1);

        // Collect distinct items to drop
        const itemsToDrop: Item[] = [];
        for (let i = 0; i < 2; i++) {
            const item = loser.inventory[i];
            if (item && !itemsToDrop.includes(item)) {
                itemsToDrop.push(item);
            }
        }

        const emptyCells = this.board.getTwoNearestEmptyCells(playerCoords);

        for (let i = 0; i < itemsToDrop.length; i++) {
            const targetCell = emptyCells[i];
            if (!targetCell) break;
            this.dropItem(itemsToDrop[i], targetCell);
            // Update the local board immediately so the next BFS (if any) sees this cell as occupied.
            this.addItemToBoard(itemsToDrop[i], targetCell);
        }

        loser.inventory = [null, null];
    }

    setMainPlayerHealth(value: number) {
        this.mainPlayer?.setStatValue(BonusType.Health, value);
    }

    redirect(): void {
        this.router.navigate([ROUTES.game]);
    }

    /**
     * Server-authoritative item collection. Called when the server broadcasts
     * ItemCollected to confirm that a player has picked up an item.
     */
    collectItem(playerId: string, item: Item, position: Coords, inventoryFull: boolean): void {
        // Remove the item from the board cell — the server has already removed it
        const cell = this.board.getCell(position.x, position.y);
        if (cell?.item) {
            cell.removeItem();
        }

        const player = this.board.getPlayerById(playerId);
        if (!player) return;

        // The server's Item only has { type: string }. Reconstruct a full client-side
        // Item instance with name, description, imagePath from ITEM_TYPES.
        let fullItem: Item;
        try {
            fullItem = new Item(item.type);
        } catch {
            return; // Unknown item type : ignore
        }

        if (inventoryFull) {
            if (playerId === this.mainPlayerId) {
                player.replaceItem(fullItem, position);
            }
            return;
        }

        player.addItem(fullItem);
    }

    /**
     * Detects if there is a collectable item on a cell WITHOUT modifying the board.
     * Used after movement animation to decide whether to emit ItemCollected to the server.
     */
    private detectItemOnCell(cell: Cell): { item: Item; cell: Cell } | undefined {
        if (!cell.item) {
            return undefined;
        }

        const item = cell.item;
        if (item.type === 'spawnPoint') {
            return undefined;
        }
        return { item, cell };
    }

    private updateCurrentPlayer(player: Player): void {
        this.currentPlayerSubject.next(player);
        this.turnChangeSubject.next();
    }

    endCanceledGame() {
        this.isGameCanceled = true;
        const startDate = this.historyStartDateIso;

        if (startDate) {
            this.historyService.endGameHistory(startDate, false).catch((e) => console.warn('endGameHistory failed', e));
            this.historyStartDateIso = null;
        }
    }
}

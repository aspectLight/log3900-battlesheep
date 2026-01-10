import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { Board } from '@app/classes/board';
import { Game } from '@app/classes/game';
import { Player } from '@app/classes/player';
import { BonusType } from '@app/constants/bonus.constants';
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

    notificationDuration: number;
    isMainPlayerTurn: boolean = false;
    isNotificationVisible: boolean = false;
    canPlayerMove: boolean = false;
    isGameCanceled: boolean = false;
    isGameFinished: boolean = false;
    currentPlayerId: string = '';
    gameCountdown: Subject<number> = new Subject<number>();

    movementService: MovementService;
    room: Room;

    disconnectedPlayer: Player[] = [];

    isGameLoaded: boolean = false;
    private game: Game;
    private board: Board;
    private mainPlayer: Player | undefined;

    // private interval: number | null;
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

    getGame() {
        return this.game;
    }

    resetManager() {
        this.isGameCanceled = false;
        this.isGameFinished = false;
        this.isGameLoaded = false;
        this.canPlayerMove = false;
        this.isMainPlayerTurn = false;
        this.disconnectedPlayer = [];
    }

    cancelGame() {
        this.isGameCanceled = true;
    }

    finishGame() {
        const delay = 3000;
        this.isGameFinished = true;
        setTimeout(() => {
            this.router.navigate(['/home']);
            this.isGameFinished = false;
        }, delay);
    }

    addPlayersToBoard(players: Player[]): boolean {
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
                if (cell.item && cell.item.type === 'spawnPoint' && !cell.player) {
                    cell.item = null;
                }
            }
        }

        return true;
    }

    movePlayer(dx: number, dy: number): boolean {
        return this.movementService.movePlayer(this.board, dx, dy);
    }

    getBoard(): Board {
        return this.board;
    }

    getPlayers(): Player[] {
        return this.room.players;
    }

    getMainPlayer() {
        return this.mainPlayer;
    }

    getCurrentPlayer(): Observable<Player> {
        return this.currentPlayer;
    }

    getRoomId(): string {
        return this.room.roomId;
    }

    stopPlayer(player: Player): void {
        this.movementService.stopPlayer(player);
    }

    setMainPlayer(id: string | undefined) {
        const foundPlayer = this.room.players.find((p) => p.id === id);
        if (!foundPlayer) return;
        this.mainPlayer = Player.fromObject(foundPlayer);
    }

    fetchGame(gameId: string): Observable<Game> {
        return this.http.get<Game>(environment.serverUrl + API_ENDPOINTS.games + gameId);
    }

    getIsGameLoaded(): boolean {
        return this.isGameLoaded;
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

    redirect(): void {
        this.router.navigate(['/game']);
    }

    handleTurnStarting(player: Player, startTime: number): void {
        this.clearPaths();
        const delay = startTime - Date.now();
        this.notificationMessage = `Le tour de ${player.name} commence dans 3 secondes!`;
        this.isNotificationVisible = true;
        this.notificationDuration = delay;
        setTimeout(() => {
            this.startTurn(player);
            this.isNotificationVisible = false;
        }, delay);
    }

    startTurn(player: Player): void {
        this.updateCurrentPlayer(player);
        this.isMainPlayerTurn = this.mainPlayer?.id === player.id;
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

    async movePlayerFromPath(callback?: () => void) {
        await this.movementService.movePlayerFromPath(this.board, this.pathService.selectedPath);
        this.resetPlayerSelection();

        if (callback) {
            callback();
        }
    }

    teleportPlayer(destinationX: number, destinationY: number) {
        this.movementService.teleportPlayer(this.board, destinationX, destinationY);
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
        if (!this.mainPlayer) return;
        this.mainPlayer.movementPoints = points;
    }

    setActionPoints(points: number) {
        if (!this.mainPlayer) return;
        this.mainPlayer.actionPoints = points;
    }

    getSelectedPath() {
        return this.pathService.selectedPath;
    }

    getPlayerById(playerId: string): Player | null {
        return this.board.getPlayerById(playerId);
    }

    setMainPlayerHealth(value: number) {
        this.mainPlayer?.setStatValue(BonusType.Health, value);
    }

    disconnectPlayer(playerId: string) {
        const playerIndex = this.room.players.findIndex((player) => player.id === playerId);

        if (playerIndex !== -1) {
            const [disconnected] = this.room.players.splice(playerIndex, 1);
            this.disconnectedPlayer.push(disconnected);
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
        return foundPlayer.fightsWon ?? 0;
    }

    isPlayerTurnOver() {
        return this.mainPlayer?.movementPoints === 0 && this.mainPlayer.actionPoints === 0;
    }

    private updateCurrentPlayer(player: Player): void {
        this.currentPlayerSubject.next(player);
    }
}

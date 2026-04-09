import { Injectable } from '@angular/core';
import { Auth, onAuthStateChanged } from '@angular/fire/auth';
import { Router } from '@angular/router';
import { Item } from '@app/classes/entity/item';
import { Player } from '@app/classes/entity/player';
import { MAX_WINS } from '@app/constants/combat.constants';
import { ROUTES } from '@app/constants/routes.constants';
import { Coords } from '@app/interfaces/coords.interface';
import { Room } from '@app/interfaces/room.interface';
import { ISocketService } from '@app/interfaces/socket-service.interface';
import { MovementSocketService } from '@app/services/communication/socket-handlers/movement-socket.service';
import { CombatService } from '@app/services/gameplay/combat.service';
import { GameManagerService } from '@app/services/state/game-manager.service';
import { GameRoomService } from '@app/services/state/game-room.service';
import { SessionService } from '@app/services/state/session.service';
import { CurrencyEvents, GameRoomEvents } from '@common/socket.constants';
import { io, Socket } from 'socket.io-client';
import { environment } from 'src/environments/environment';

@Injectable({
    providedIn: 'root',
})
export class SocketService implements ISocketService {
    socket: Socket;
    private socketServices: ISocketService[] = [];

    private movementSocketService!: MovementSocketService;

    // eslint-disable-next-line max-params
    constructor(
        private gameRoomService: GameRoomService,
        private gameManagerService: GameManagerService,
        private combatService: CombatService,
        private router: Router,
        private auth: Auth,
        private session: SessionService,
    ) {
        void this.setUpConnection();
    }

    get playerName() {
        return this.gameRoomService.room.players.find((player) => player.id === this.socket.id)?.name;
    }

    navigateToHome() {
        this.router.navigate([ROUTES.home]);
    }

    async setUpConnection() {
        await this.connect();
        this.setUpListeners();
        for (const service of this.socketServices) {
            service.setUpConnection();
        }
    }

    registerSocketService(service: ISocketService) {
        this.socketServices.push(service);
        if (service.constructor.name === 'MovementSocketService') {
            this.movementSocketService = service as MovementSocketService;
        }
    }

    async connect() {
        // Wait for Firebase Auth to restore user state after page refresh
        await new Promise<void>((resolve) => {
            const unsub = onAuthStateChanged(this.auth, () => {
                unsub();
                resolve();
            });
        });

        const user = this.auth.currentUser;
        const sessionId = this.session.sessionId;

        if (!user || !sessionId) {
            this.socket = io(environment.socketUrl);
            return;
        }

        const token = await user.getIdToken();

        this.socket = io(environment.socketUrl, { auth: { token, sessionId }, transports: ['websocket'], upgrade: false });
    }

    getId(): string | undefined {
        return this.socket.id;
    }

    getRoomId(): string {
        return this.gameRoomService.room.roomId;
    }

    // eslint-disable-next-line @typescript-eslint/ban-types
    send<T>(event: string, data?: T, callback?: Function): void {
        this.socket.emit(event, ...[data, callback].filter((x) => x));
    }

    on<T>(event: string, callback: (data: T) => void): void {
        this.socket.on(event, callback);
    }

    abandonGame(roomId: string) {
        this.socket.emit(GameRoomEvents.AbandonGame, roomId);
    }

    endPlayerTurn(roomId: string): void {
        this.socket.emit(GameRoomEvents.EndTurn, roomId);
        this.gameManagerService.canEndTurn = false;
    }

    finishGame(winnerId: string) {
        const roomId = this.gameManagerService.room.roomId;
        this.socket.emit(GameRoomEvents.FinishGame, { roomId, winnerId });
    }

    dropItem(item: Item, coords: Coords): void {
        const roomId = this.gameManagerService.room.roomId;
        this.socket.emit(GameRoomEvents.ItemDropped, { roomId, playerId: this.socket.id, item, coords });
    }

    virtualPlayerTurn(playerId: string, skipTimeout?: boolean): void {
        const roomId = this.gameManagerService.room.roomId;
        const isCTF = this.gameManagerService.isCTF;
        this.socket.emit(GameRoomEvents.VirtualPlayerTurn, { roomId, playerId, isCTF, skipTimeout });
    }

    sendMessageToGameRoom(message: string, playerName: string | null): void {
        this.socket.emit(GameRoomEvents.SendMessageToGameRoom, { message, playerName, roomId: this.getRoomId() });
    }

    quitEndGame(): void {
        this.socket.emit(GameRoomEvents.QuitEndGame, this.getRoomId());
    }

    disconnect(): void {
        if (this.socket) {
            this.cleanup();
            this.socket.disconnect();
        }
    }

    async reconnect(): Promise<void> {
        this.disconnect();
        await this.setUpConnection();
    }

    private setUpListeners(): void {
        this.socket.on(GameRoomEvents.PlayerSpawned, (players) => {
            this.gameRoomService.updatePlayers(players);
            this.gameManagerService.loadGame().subscribe({
                next: () => {
                    this.gameManagerService.isGameLoaded = true;
                    this.gameManagerService.addPlayersToBoard(this.gameManagerService.getPlayers());
                    this.gameManagerService.setMainPlayer(this.socket.id);
                },
            });
        });

        this.socket.on(GameRoomEvents.TurnStarting, (data) => {
            this.handleTurnStart(data);
        });

        this.socket.on(GameRoomEvents.UpdateCountdown, (countdown: number) => {
            this.gameManagerService.gameCountdown.next(countdown);
        });

        this.socket.on(GameRoomEvents.UpdateStartingCountdown, (countdown: number) => {
            this.gameManagerService.turnCountdown.next(countdown);
        });

        this.socket.on(GameRoomEvents.UpdateScore, (data: { winnerId: string; fightsWon: number } | string) => {
            // Support both old string and new object payload for backwards compatibility
            const winnerId = typeof data === 'string' ? data : data.winnerId;
            const fightsWon = typeof data === 'string' ? undefined : data.fightsWon;
            const result = this.gameManagerService.updateScore(winnerId, fightsWon);
            const winner = this.gameManagerService.room.players.find((p) => p.id === winnerId);
            const mainPlayer = this.gameManagerService.getMainPlayer();
            if (!mainPlayer) return;
            if (this.gameManagerService.isCTF) return;
            if ((mainPlayer.id === winnerId || (winner?.isVirtual && this.getId() === this.gameManagerService.room.hostId)) && result >= MAX_WINS) {
                this.finishGame(winnerId);
            }
        });

        this.socket.on(GameRoomEvents.UpdateCombatCountDown, (countdown) => {
            this.combatService.combatCountdown.next(countdown);
        });

        this.socket.on(GameRoomEvents.GameAbandoned, () => {
            this.router.navigate([ROUTES.home]);
        });

        this.socket.on(GameRoomEvents.GameCanceled, (data: { playerId: string }) => {
            const iAbandoned = data.playerId === this.socket.id;

            if (iAbandoned) {
                this.gameManagerService.cancelGame();
            } else {
                this.gameManagerService.endCanceledGame();
            }

            this.router.navigate([ROUTES.home]);
        });

        this.socket.on(GameRoomEvents.PlayerAbandoned, (playerId) => {
            this.gameManagerService.disconnectPlayer(playerId);
        });

        this.socket.on(GameRoomEvents.FinishGame, (data) => {
            const playersName = [];
            for (const player of this.gameManagerService.room.players) {
                playersName.push(player.name);
            }
            this.gameManagerService.finishGame(data);
        });

        this.socket.on(GameRoomEvents.ItemDropped, (data) => {
            this.gameManagerService.addItemToBoard(data.item, data.coords);
            if (data.item.type === 'flag') {
                this.gameManagerService.playerWithFlag = null;
            }
        });

        this.socket.on(GameRoomEvents.ItemDroppedDisconnected, (data) => {
            const cells = this.gameManagerService.getBoard().getTwoNearestEmptyCells({ x: data.coords.x, y: data.coords.y });
            let i = 0;
            for (const item of data.items) {
                if (item) {
                    this.socket.emit(GameRoomEvents.ItemDropped, {
                        roomId: data.roomId,
                        playerId: null,
                        item,
                        coords: cells[i],
                    });
                    i++;
                }
            }
        });

        this.socket.on(GameRoomEvents.FlagCollected, (data) => {
            this.gameManagerService.playerWithFlag = data;
        });

        this.socket.on(GameRoomEvents.OrganizatorChanged, (data) => {
            this.gameManagerService.room.hostId = data.newhostId;
        });

        this.socket.on(CurrencyEvents.GameRewardsInfo, (data: { rewards: { name: string; gain: number; avatarName: string | null }[]; entryFee: number; pool: number }) => {
            this.gameManagerService.gameRewards = data;
        });
    }

    private handleTurnStart(data: { nextPlayer: Player; startTime: number }): void {
        this.gameManagerService.handleTurnStarting(data.nextPlayer, data.startTime);
        const room = this.gameManagerService.room;
        const currentPlayer = room.players.find((p) => p.id === this.socket.id);

        if (!currentPlayer) return;

        this.setupPlayerPoints(currentPlayer);
        this.handlePlayerTurn(data.nextPlayer, currentPlayer, room);
    }

    private setupPlayerPoints(player: Player): void {
        this.gameManagerService.setMovementPoints(player.movementPoints);
        const actionPoints = this.gameManagerService.getGame()?.actionPoints ?? 1;
        this.gameManagerService.setActionPoints(actionPoints);
    }

    private handlePlayerTurn(nextPlayer: Player, currentPlayer: Player, room: Room): void {
        const isCurrentPlayerTurn = this.socket.id === nextPlayer.id;
        const isOrganizerAndVirtualTurn = this.socket.id === room.hostId && nextPlayer.isVirtual;

        if (isOrganizerAndVirtualTurn) {
            this.handleVirtualPlayerTurn(currentPlayer, nextPlayer);
        } else if (isCurrentPlayerTurn) {
            this.handleHumanPlayerTurn(currentPlayer, room);
        }

        this.gameManagerService.currentPlayerId = nextPlayer.id;
    }

    private handleVirtualPlayerTurn(currentPlayer: Player, nextPlayer: Player): void {
        this.gameManagerService.selectPlayer(currentPlayer);
        this.setupPlayerPoints(currentPlayer);
        this.virtualPlayerTurn(nextPlayer.id);
    }

    private handleHumanPlayerTurn(currentPlayer: Player, room: Room): void {
        this.gameManagerService.selectPlayer(currentPlayer);
        this.setupPlayerPoints(currentPlayer);
        if (!room.isDebugging) {
            this.getPlayerMovements();
        }
    }

    private getPlayerMovements() {
        if (this.movementSocketService) {
            this.movementSocketService.getPlayerMovements();
        } else {
            this.socket.emit(
                GameRoomEvents.PlayerGetMovements,
                {
                    roomId: this.getRoomId(),
                    hasBoots: this.gameManagerService.getMainPlayer()?.hasItem('waterproofBoots'),
                    hasCamouflage: this.gameManagerService.getMainPlayer()?.hasItem('camouflage'),
                    hasAirStrike: this.gameManagerService.getMainPlayer()?.hasItem('airStrike'),
                },
                (response: { success: boolean; paths?: [Coords, Coords[]][]; error?: string }) => {
                    if (response.success && response.paths) {
                        const pathsMap = new Map<Coords, Coords[]>(response.paths);
                        if (!this.gameManagerService.isDebugMode) {
                            this.gameManagerService.setPaths(pathsMap);
                        } else {
                            this.gameManagerService.clearPaths();
                        }
                    } else if (response.error) {
                        // eslint-disable-next-line no-console
                        console.error('Error getting player movements:', response.error);
                    }
                },
            );
        }
    }

    private cleanup(): void {
        if (this.socket) {
            this.socket.removeAllListeners();
        }
    }
}

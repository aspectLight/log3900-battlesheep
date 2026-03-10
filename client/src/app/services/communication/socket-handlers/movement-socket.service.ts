import { Injectable } from '@angular/core';
import { Item } from '@app/classes/entity/item';
import { Player } from '@app/classes/entity/player';
import { Coords } from '@app/interfaces/coords.interface';
import { ISocketService } from '@app/interfaces/socket-service.interface';
import { SocketService } from '@app/services/communication/socket-handlers/socket.service';
import { MovementService } from '@app/services/gameplay/movement.service';
import { GameManagerService } from '@app/services/state/game-manager.service';
import { GameRoomEvents } from '@common/socket.constants';
import { Socket } from 'socket.io-client';
interface MoveInfo {
    roomId: string;
    playerId: string;
    map: Map<Coords, Coords[]>;
    selectedPath: Coords[];
}

@Injectable({
    providedIn: 'root',
})
export class MovementSocketService implements ISocketService {
    socket: Socket;

    constructor(
        private socketService: SocketService,
        private gameManagerService: GameManagerService,
        private movementService: MovementService,
    ) {
        this.socketService.registerSocketService(this);
        this.setUpConnection();
        this.gameManagerService.dropItem = (item: Item, coords: Coords) => {
            this.socketService.dropItem(item, coords);
        };
    }

    sync() {
        this.socket = this.socketService.socket;
    }

    setUpConnection(): void {
        this.sync();
        this.setUpListeners();
    }

    async getPlayerMovements(): Promise<{ success: boolean; paths?: [Coords, Coords[]][]; error?: string }> {
        return new Promise((resolve) => {
            this.socket.emit(
                GameRoomEvents.PlayerGetMovements,
                {
                    roomId: this.socketService.getRoomId(),
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
                    resolve(response);
                },
            );
        });
    }

    checkForFlag(player: Player): boolean {
        if (!player || !player.cell || !player.spawnPoint) return false;
        if (player.cell.x === player.spawnPoint.x && player.cell.y === player.spawnPoint.y && player.hasItem('flag')) {
            this.socketService.finishGame(player.id);
            return true;
        }
        return false;
    }

    checkForAvailablePoints(player: Player): boolean {
        if (player.movementPoints > 0 || player.actionPoints > 0) return false;
        const gameRoomId = this.gameManagerService.getRoomId();
        this.socketService.endPlayerTurn(gameRoomId);
        return true;
    }

    async movedPlayer({
        roomId,
        playerId,
        selectedPath,
    }: Omit<MoveInfo, 'map'>): Promise<{ success: boolean; error?: string; movementPoints?: number }> {
        return new Promise((resolve) => {
            this.socket.emit(
                GameRoomEvents.PlayerMoved,
                { roomId, playerId, selectedPath },
                (response: { success: boolean; error?: string; movementPoints?: number }) => {
                    if (!response.success && response.error) {
                        // Server rejected the movement - show error to user
                        // eslint-disable-next-line no-console
                        console.error('Movement rejected by server:', response.error);
                        // TODO: Show user-friendly error message via toast/snackbar
                        // The movement will not be executed since server rejected it
                    }
                    // Note: If successful, the server will broadcast PlayerMoved event
                    // which will be handled by the existing listener
                    resolve(response);
                },
            );
        });
    }

    async teleportPlayer(
        destinationX: number,
        destinationY: number,
        options: {
            playerId?: string;
            hasCamouflage?: boolean;
        } = {},
    ): Promise<void> {
        const roomId = this.gameManagerService.room.roomId;
        const playerId = options.playerId || this.socket.id;
        const destination = { x: destinationX, y: destinationY };

        const destinationCell = this.gameManagerService.getBoard().getCell(destinationX, destinationY);
        if (!destinationCell) {
            throw new Error('Invalid destination cell');
        }

        if (!this.movementService.isCellFree(destinationCell)) {
            throw new Error('Destination cell is not free');
        }

        const result = await this.socket.emitWithAck(GameRoomEvents.PlayerTeleported, {
            roomId,
            playerId,
            destination,
            hasCamouflage: options.hasCamouflage,
        });

        if (!result.success) {
            throw new Error(result.error || 'Failed to teleport player');
        }
    }

    synchronizeMovement(playerId: string, destinationX: number, destinationY: number): void {
        const roomId = this.gameManagerService.room.roomId;
        const destination = { x: destinationX, y: destinationY };
        this.socket.emit(GameRoomEvents.SynchronizeMovement, { roomId, playerId, destination });
        if (this.gameManagerService.currentPlayerId === this.socket.id) {
            const player = this.gameManagerService.getBoard().getPlayerById(playerId);
            if (!player) return;
            this.gameManagerService.canEndTurn = this.canMoveOrAct(player);
        }
    }

    startVirtualCombat(roomId: string, playerId: string, opponentId: string): void {
        if (this.gameManagerService.room.hostId === this.socket.id) {
            this.socket.emit(GameRoomEvents.StartVirtualCombat, { roomId, playerId, opponentId });
        }
    }

    sendTrapChoice(choice: 'avoid' | 'traverse'): void {
        const roomId = this.gameManagerService.room.roomId;
        const playerId = this.socket.id;
        this.socket.emit(GameRoomEvents.TrapChoice, { roomId, playerId, choice });
        this.gameManagerService.isTrapPopupVisible = false;
    }

    private setUpListeners(): void {
        this.socket.on(GameRoomEvents.GameRoomError, (error) => {
            // eslint-disable-next-line no-console
            console.warn('Erreur depuis le socket serveur de GameRoomGateway : \n', error);
        });

        this.socket.on(GameRoomEvents.TurnStarting, (data) => {
            const mainPlayer = this.gameManagerService.getMainPlayer();
            if (mainPlayer && data.nextPlayer.id === mainPlayer.id) {
                setTimeout(() => {
                    const currentPlayer = this.gameManagerService.getMainPlayer();
                    if (!currentPlayer) {
                        return;
                    }

                    const canAct = this.canMoveOrAct(currentPlayer);
                    if (!canAct) {
                        this.socketService.endPlayerTurn(this.gameManagerService.getRoomId());
                    }
                }, 3100);
            }
        });

        this.socket.on(GameRoomEvents.PlayerMoved, (data) => {
            const player = this.gameManagerService.getBoard().getPlayerById(data.playerId);
            if (!player) return;

            const map = new Map<Coords, Coords[]>(data.map);
            const lastCoord = data.selectedPath[data.selectedPath.length - 1];

            this.gameManagerService.setPlayer(player);
            this.gameManagerService.setMovementPoints(data.movementPoints);
            this.gameManagerService.setPaths(map);
            this.gameManagerService.setSelectedPathFromCoords(data.selectedPath);
            this.gameManagerService.movePlayerFromPath(
                // Callback function to handle item collection
                (item, cell) => {
                    if (this.gameManagerService.currentPlayerId === this.socket.id) {
                        if (item && cell) {
                            const roomId = this.socketService.getRoomId();
                            this.socket.emit(GameRoomEvents.ItemCollected, {
                                roomId,
                                playerId: this.socket.id,
                                item,
                                position: { x: cell.x, y: cell.y },
                            });
                            this.getPlayerMovements();
                        }

                        this.synchronizeMovement(data.playerId, lastCoord.x, lastCoord.y);

                        // If a trap was hit, skip auto-end-turn — the trap flow handles it
                        if (data.isTrap) return;

                        const mainPlayer = this.gameManagerService.getMainPlayer();
                        if (!mainPlayer) return;
                        if (this.checkForAvailablePoints(mainPlayer)) return;
                        if (this.checkForFlag(mainPlayer)) return;
                        if (!this.canMoveOrAct(mainPlayer, item ?? undefined)) this.socketService.endPlayerTurn(this.gameManagerService.getRoomId());
                    }
                },
            );

            if (this.gameManagerService.currentPlayerId === this.socket.id && !data.isTrap) this.getPlayerMovements();
        });

        this.socket.on(GameRoomEvents.PlayerTeleported, (data) => {
            const player = this.gameManagerService.getBoard().getPlayerById(data.playerId);
            if (!player) {
                return;
            }

            const cell = this.gameManagerService.getBoard().getCell(data.destination.x, data.destination.y);
            if (!cell) return;

            this.movementService.teleportPlayer(this.gameManagerService.getBoard(), player, cell.x, cell.y);

            this.gameManagerService.resetPlayerSelection();

            if (this.gameManagerService.currentPlayerId === this.socket.id && !this.gameManagerService.room.isDebugging) {
                this.getPlayerMovements();

                const mainPlayer = this.gameManagerService.getMainPlayer();
                if (mainPlayer && !this.canMoveOrAct(mainPlayer)) {
                    this.socketService.endPlayerTurn(this.gameManagerService.getRoomId());
                }
            }
            this.checkForFlag(player);
        });

        this.socket.on(GameRoomEvents.VirtualPlayerMoved, (data) => {
            let coordsArray: Coords[];
            if (data.path.length > 0 && data.path[0].coord) {
                coordsArray = data.path.map((item: { coord: Coords }) => item.coord);
            } else {
                coordsArray = data.path;
            }
            const player = this.gameManagerService.getBoard().getPlayerById(data.playerId);
            if (!player) return;

            this.gameManagerService.setPlayer(player);
            this.gameManagerService.setMovementPoints(data.remainingMovementPoints);
            this.gameManagerService.setSelectedPathFromCoords(coordsArray);
            this.gameManagerService.movePlayerFromPath((item, cell) => {
                if (this.gameManagerService.room.hostId === this.socket.id) {
                    if (item && cell) {
                        const roomId = this.socketService.getRoomId();
                        this.socket.emit(GameRoomEvents.ItemCollected, {
                            roomId,
                            playerId: data.playerId,
                            item,
                            position: { x: cell.x, y: cell.y },
                        });
                    }
                }
                const gameRoomId = this.gameManagerService.getRoomId();
                if (data.opponentPlayerId) {
                    this.startVirtualCombat(gameRoomId, data.playerId, data.opponentPlayerId);
                } else if (data.remainingMovementPoints > 0) {
                    this.socketService.virtualPlayerTurn(player.id, true);
                } else {
                    const hostId = this.gameManagerService.room.hostId;
                    if (this.socket.id === hostId) {
                        this.socketService.endPlayerTurn(gameRoomId);
                    }
                }
                if (player) this.checkForFlag(player);
            });
        });

        // Server-authoritative item collection: the server broadcasts this event
        // after validating the collection. All clients update their local board here.
        this.socket.on(GameRoomEvents.ItemCollected, (data: { playerId: string; item: Item; position: Coords; inventoryFull: boolean }) => {
            this.gameManagerService.collectItem(data.playerId, data.item, data.position, data.inventoryFull);

            if (data.playerId === this.socket.id && this.gameManagerService.currentPlayerId === this.socket.id) {
                // Boots just added to inventory: re-fetch paths so water tiles cost 1 movement point
                if (data.item.type === 'waterproofBoots') {
                    this.getPlayerMovements();
                }
                // Action item just added: update canEndTurn so the HUD button reflects the new capability
                if (data.item.type === 'camouflage' || data.item.type === 'airStrike') {
                    const mainPlayer = this.gameManagerService.getMainPlayer();
                    if (mainPlayer) {
                        this.gameManagerService.canEndTurn = this.canMoveOrAct(mainPlayer);
                    }
                }
            }
        });

        this.socket.on(GameRoomEvents.PlayerAbandoned, (playerId) => {
            this.gameManagerService.disconnectPlayer(playerId);
            if (this.gameManagerService.currentPlayerId === this.socket.id) {
                this.getPlayerMovements();
            }
        });

        this.socket.on(GameRoomEvents.SynchronizeMovement, (data) => {
            const player = this.gameManagerService.getBoard().getPlayerById(data.playerId);
            if (!player) return;

            if (player.cell && player.cell.x === data.destination.x && player.cell.y === data.destination.y) {
                return;
            }

            const cell = this.gameManagerService.getBoard().getCell(data.destination.x, data.destination.y);
            if (!cell) return;

            // Teleport player directly
            this.movementService.teleportPlayer(this.gameManagerService.getBoard(), player, cell.x, cell.y);
        });

        this.socket.on(GameRoomEvents.TrapPending, (data: { roomId: string; playerId: string; canAvoid: boolean }) => {
            if (data.playerId === this.socket.id) {
                this.gameManagerService.trapCanAvoid = data.canAvoid;
                this.gameManagerService.isTrapPopupVisible = true;
            }
        });

        this.socket.on(
            GameRoomEvents.TrapResult,
            (data: { roomId: string; playerId: string; choice: string; activated: boolean; remainingMovementPoints: number }) => {
                if (data.playerId === this.socket.id && this.gameManagerService.currentPlayerId === this.socket.id) {
                    this.gameManagerService.isTrapPopupVisible = false;

                    const mainPlayer = this.gameManagerService.getMainPlayer();
                    if (!mainPlayer) return;
                    mainPlayer.movementPoints = data.remainingMovementPoints;

                    if (data.activated) {
                        console.log('Fin du tour du joueur');
                        mainPlayer.movementPoints = 0;
                        mainPlayer.actionPoints = 0;
                        const gameRoomId = this.gameManagerService.getRoomId();
                        this.socketService.endPlayerTurn(gameRoomId);
                    } else {
                        console.log('Le joueur peut continuer son tour');
                        this.getPlayerMovements();
                        if (!this.canMoveOrAct(mainPlayer)) {
                            console.log('Mais le joueur ne peut plus rien faire. Fin du tour');
                            this.socketService.endPlayerTurn(this.gameManagerService.getRoomId());
                        }
                    }
                }
            },
        );
    }

    // Accept a pending item that is not yet in the player's inventory
    private canMoveOrAct(player: Player, pendingItem?: Item): boolean {
        if (player.movementPoints > 0) return true;
        const hasActiveItem =
            player.hasItem('camouflage') || player.hasItem('airStrike') || pendingItem?.type === 'camouflage' || pendingItem?.type === 'airStrike';
        if (player.actionPoints > 0 && hasActiveItem) {
            return true;
        }

        if (!player.cell) {
            return false;
        }
        const directions = [
            { x: 0, y: 1 },
            { x: 0, y: -1 },
            { x: 1, y: 0 },
            { x: -1, y: 0 },
        ];
        for (const direction of directions) {
            const cell = this.gameManagerService.getBoard().getCell(player.cell.x + direction.x, player.cell.y + direction.y);
            if (cell?.player) {
                const isSameTeamInCTF = this.gameManagerService.isCTF && cell.player.team === player.team;
                if (!isSameTeamInCTF) return true;
            }
            if (cell?.tile.type === 'door' && player.actionPoints > 0) {
                return true;
            }
        }
        return false;
    }
}

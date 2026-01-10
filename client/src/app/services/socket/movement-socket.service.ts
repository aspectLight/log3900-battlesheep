import { Injectable } from '@angular/core';
import { SocketService } from '@app/services/socket.service';
import { Socket } from 'socket.io-client';
import { GameManagerService } from '@app/services/game-manager.service';
import { ISocketService } from '@app/interfaces/socket-service.interface';
import { Coords } from '@app/interfaces/coords';
import { Item } from '@app/classes/item';
import { GameRoomEvents } from '@common/socket.constants';
import { Player } from '@app/classes/player';
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

    getPlayerMovements() {
        this.socket.emit(GameRoomEvents.PlayerGetMovements, {
            roomId: this.socketService.getRoomId(),
            hasBoots: this.gameManagerService.getMainPlayer()?.hasItem('waterproofBoots'),
            hasCamo: this.gameManagerService.getMainPlayer()?.hasItem('camouflage'),
            hasAirStrike: this.gameManagerService.getMainPlayer()?.hasItem('airStrike'),
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

    movedPlayer({ roomId, playerId, map, selectedPath }: MoveInfo): void {
        const serializedMap = Array.from(map.entries());
        this.socket.emit(GameRoomEvents.PlayerMoved, { roomId, playerId, serializedMap, selectedPath });
    }

    teleportPlayer(destinationX: number, destinationY: number, hasCamo?: boolean): void {
        const roomId = this.gameManagerService.room.roomId;
        const playerId = this.socket.id;
        const destination = { x: destinationX, y: destinationY };
        const item = this.gameManagerService.getBoard().getCell(destinationX, destinationY)?.item;
        if (item && item.type !== 'spawnPoint') {
            this.socket.emit(GameRoomEvents.ItemCollected, { roomId, playerId, item, position: destination });
        }
        this.socket.emit(GameRoomEvents.PlayerTeleported, { roomId, playerId, destination, hasCamo });
    }

    synchronizeMovement(playerId: string, destinationX: number, destinationY: number): void {
        const roomId = this.gameManagerService.room.roomId;
        const destination = { x: destinationX, y: destinationY };
        this.socket.emit(GameRoomEvents.SynchronizeMovement, { roomId, playerId, destination });
        if (this.gameManagerService.currentPlayerId === this.socket.id) {
            const player = this.gameManagerService.getBoard().getPlayerById(playerId);
            if (!player) return;
            if (player.movementPoints > 0) this.gameManagerService.canEndTurn = true;
        }
    }

    startVirtualCombat(roomId: string, playerId: string, opponentId: string): void {
        if (this.gameManagerService.room.organisatorId === this.socket.id) {
            this.socket.emit(GameRoomEvents.StartVirtualCombat, { roomId, playerId, opponentId });
        }
    }

    private setUpListeners(): void {
        this.socket.on(GameRoomEvents.GameRoomError, (error) => {
            // eslint-disable-next-line no-console
            console.warn('Erreur depuis le socket serveur de GameRoomGateway : \n', error);
        });

        this.socket.on(GameRoomEvents.PlayerMovements, (paths) => {
            const pathsMap = new Map<Coords, Coords[]>(paths);
            if (!this.gameManagerService.isDebugMode) this.gameManagerService.setPaths(pathsMap);
            else this.gameManagerService.clearPaths();
        });

        this.socket.on(GameRoomEvents.PlayerMoved, (data) => {
            const player = this.gameManagerService.getBoard().getPlayerById(data.playerId);
            if (!player) return;
            const map = new Map<Coords, Coords[]>(data.map);

            this.gameManagerService.setPlayer(player);
            this.gameManagerService.setMovementPoints(data.movementPoints);
            this.gameManagerService.setPaths(map);
            this.gameManagerService.setSelectedPathFromCoords(data.selectedPath);
            this.gameManagerService.movePlayerFromPath((item, cell) => {
                if (this.gameManagerService.currentPlayerId === this.socket.id) {
                    if (item && cell) {
                        const entry = {
                            type: 'TOUS',
                            content: `${player.name} a ramassé ${item.name}`,
                        };
                        const roomId = this.socketService.getRoomId();
                        this.socket.emit(GameRoomEvents.AddJournalEntry, { roomId, entry });
                        this.socket.emit(GameRoomEvents.ItemCollected, {
                            roomId,
                            playerId: this.socket.id,
                            item,
                            position: { x: cell.x, y: cell.y },
                        });
                        this.getPlayerMovements();
                    }
                    const lastCell = data.selectedPath[data.selectedPath.length - 1];
                    this.synchronizeMovement(data.playerId, lastCell.x, lastCell.y);

                    const mainPlayer = this.gameManagerService.getMainPlayer();
                    if (!mainPlayer) return;
                    if (this.checkForAvailablePoints(mainPlayer)) return;
                    if (this.checkForFlag(mainPlayer)) return;
                    if (!this.canMoveOrAct(mainPlayer)) this.socketService.endPlayerTurn(this.gameManagerService.getRoomId());
                }
            });

            if (this.gameManagerService.currentPlayerId === this.socket.id) this.getPlayerMovements();
        });

        this.socket.on(GameRoomEvents.PlayerTeleported, (data) => {
            const player = this.gameManagerService.getBoard().getPlayerById(data.playerId);
            if (!player) return;
            this.gameManagerService.setPlayer(player);
            this.gameManagerService.teleportPlayer(data.destination.x, data.destination.y);

            if (this.gameManagerService.currentPlayerId === this.socket.id && !this.gameManagerService.room.isDebugging) {
                this.getPlayerMovements();
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
                if (this.gameManagerService.room.organisatorId === this.socket.id) {
                    if (item && cell) {
                        const entry = {
                            type: 'TOUS',
                            content: `${player.name} a ramassé ${item.name}`,
                        };
                        const roomId = this.socketService.getRoomId();
                        this.socket.emit(GameRoomEvents.AddJournalEntry, { roomId, entry });
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
                    const organisatorId = this.gameManagerService.room.organisatorId;
                    if (this.socket.id === organisatorId) {
                        this.socketService.endPlayerTurn(gameRoomId);
                    }
                }
                if (player) this.checkForFlag(player);
            });
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
            this.gameManagerService.setPlayer(player);
            this.gameManagerService.teleportPlayer(data.destination.x, data.destination.y);
        });
    }

    private canMoveOrAct(player: Player): boolean {
        if (player.movementPoints > 0) return true;
        if (player.hasItem('airStrike') || player.hasItem('camouflage')) {
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
            if (cell?.player || cell?.item) {
                return true;
            }
            if (cell?.tile.type === 'door' && player.actionPoints > 0) {
                return true;
            }
        }
        return false;
    }
}

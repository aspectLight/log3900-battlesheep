import { Coords } from '@app/modules/movement/interfaces/coords';
import { GameMovementService } from '@app/modules/movement/services/game-movement.service';
import { GameRoomService } from '@app/modules/shared-room/services/game-room.service';
import { ErrorMessages } from '@common/error-messages.constants';
import { GameRoomEvents } from '@common/socket.constants';
import { Injectable, Logger } from '@nestjs/common';
import { Server, Socket } from 'socket.io';

/**
 * Handler for player movement-related events in the game room
 */
@Injectable()
export class MovementHandler {
    private readonly logger = new Logger(MovementHandler.name);

    constructor(
        private readonly gameRoomService: GameRoomService,
        private readonly gameMovementService: GameMovementService,
    ) {}

    /**
     * Handles the player request for possible movements
     */
    async handlePlayerGetMovements(
        data: { roomId: string; hasBoots: boolean },
        socket: Socket,
    ): Promise<{ success: boolean; paths?: [Coords, Coords[]][]; error?: string }> {
        try {
            const { roomId, hasBoots } = data;
            const room = this.gameRoomService.findRoomById(roomId);
            const player = room.players.find((p) => p.id === socket.id);

            if (!player) {
                return { success: false, error: ErrorMessages.PlayerNotFound };
            }

            player.hasBoots = hasBoots;
            const paths = this.gameMovementService.getAllPaths(roomId, socket.id, room.players);

            return {
                success: true,
                paths: Array.from(paths.entries()),
            };
        } catch (error) {
            return { success: false, error: error.message };
        }
    }

    /**
     * Handles the player request for moving
     */
    async handlePlayerMoved(
        data: { roomId: string; playerId: string; selectedPath: Coords[] },
        server: Server,
    ): Promise<{ success: boolean; error?: string; movementPoints?: number }> {
        try {
            const { roomId, playerId, selectedPath } = data;
            const room = this.gameRoomService.findRoomById(roomId);
            const player = room.players.find((p) => p.id === playerId);

            if (!player) {
                return { success: false, error: ErrorMessages.PlayerNotFound };
            }

            const validation = this.gameMovementService.validatePath(roomId, playerId, selectedPath, room.players);

            if (!validation.isValid) {
                return { success: false, error: validation.isValid === false ? validation.error : '' };
            }

            const playerStats = room.playersStats.find((p) => p.name === player.name);
            for (const path of selectedPath) {
                const alreadyVisited = playerStats.tilesVisited.some((tile) => tile.x === path.x && tile.y === path.y);
                if (!alreadyVisited) playerStats.tilesVisited.push(path);
            }

            const destination = selectedPath[selectedPath.length - 1];
            const movementPoints = this.gameMovementService.movePlayer(roomId, playerId, room.players, destination);

            server.to(roomId).emit(GameRoomEvents.PlayerMoved, { ...data, movementPoints });

            return { success: true, movementPoints };
        } catch (error) {
            return { success: false, error: error.message };
        }
    }

    /**
     * Handles player teleportation
     */
    async handlePlayerTeleported(
        data: { roomId: string; playerId: string; destination: Coords; hasCamouflage?: boolean },
        server: Server,
    ): Promise<{ success: boolean; error?: string }> {
        try {
            const room = this.gameRoomService.findRoomById(data.roomId);
            if (!room) {
                throw new Error(ErrorMessages.RoomDoesNotExist);
            }

            const player = room.players.find((p) => p.id === data.playerId);
            if (!player) {
                throw new Error(ErrorMessages.PlayerNotFound);
            }

            if (data.destination.x < 0 || data.destination.y < 0) {
                throw new Error('Invalid destination coordinates');
            }

            const destinationCell = this.gameMovementService.getCell(data.roomId, data.destination.x, data.destination.y);
            const item = destinationCell?.item;
            const hasCollectableItem = item && item.type !== 'spawnPoint';

            this.gameMovementService.movePlayer(data.roomId, data.playerId, room.players, data.destination, true);

            if (hasCollectableItem) {
                const result = this.gameRoomService.addItemToInventory(data.roomId, data.playerId, item);
                this.gameMovementService.removeItemFromBoard(data.roomId, data.destination);

                // VP has a full inventory and drops an item
                if (result.shouldDrop) {
                    this.gameMovementService.addItemToBoard(data.roomId, result.shouldDrop.item, result.player.position);
                }

                server.to(data.roomId).emit(GameRoomEvents.ItemCollected, {
                    roomId: data.roomId,
                    playerId: data.playerId,
                    item,
                    position: data.destination,
                    inventoryFull: result.inventoryFull || false,
                });

                if (item.type === 'flag') {
                    server.to(data.roomId).emit(GameRoomEvents.FlagCollected, data.playerId);
                }
            }

            server.to(data.roomId).emit(GameRoomEvents.PlayerTeleported, data);

            return { success: true };
        } catch (error) {
            this.logger.error(`Erreur téléportation: ${error.message}`);
            return { success: false, error: error.message };
        }
    }

    /**
     * Handles door toggling
     */
    handleDoorToggled(data: { roomId: string; x: number; y: number }, socket: Socket, server: Server): void {
        try {
            const room = this.gameRoomService.findRoomById(data.roomId);
            this.gameMovementService.toggleDoor(data.roomId, data.x, data.y, room);
            server.to(data.roomId).emit(GameRoomEvents.DoorToggled, data);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    /**
     * Handles movement synchronization
     */
    handleSynchronizeMovement(data: { roomId: string; playerId: string; destination: Coords }, socket: Socket, server: Server): void {
        try {
            server.to(data.roomId).emit(GameRoomEvents.SynchronizeMovement, data);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }
}

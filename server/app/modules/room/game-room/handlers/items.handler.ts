import { Coords } from '@app/modules/movement/interfaces/coords';
import { GameMovementService } from '@app/modules/movement/services/game-movement.service';
import { TorchService } from '@app/modules/movement/services/torch.service';
import { GameRoomService } from '@app/modules/shared-room/services/game-room.service';
import { Item } from '@app/shared/interfaces/item';
import { GameRoomEvents } from '@common/socket.constants';
import { Injectable } from '@nestjs/common';
import { Server, Socket } from 'socket.io';

/**
 * Handler for item-related events in the game room
 */
@Injectable()
export class ItemsHandler {
    constructor(
        private readonly gameRoomService: GameRoomService,
        private readonly gameMovementService: GameMovementService,
        private readonly torchService: TorchService,
    ) {}

    /**
     * Handles item collection
     */
    handleItemCollected(data: { roomId: string; playerId: string; item: Item; position: Coords }, socket: Socket, server: Server): void {
        try {
            const room = this.gameRoomService.findRoomById(data.roomId);
            const playerInRoom = room.players.find((p) => p.id === data.playerId);
            const player = room.playersStats.find((playerReceived) => playerReceived.name === playerInRoom.name);
            if (!player.itemsCollected.includes(data.item.type)) player.itemsCollected.push(data.item.type);

            const result = this.gameRoomService.addItemToInventory(data.roomId, data.playerId, data.item);
            this.gameMovementService.removeItemFromBoard(data.roomId, data.position);

            if (result.shouldDrop) {
                this.gameMovementService.addItemToBoard(data.roomId, result.shouldDrop.item, result.player.position);
            }

            // Broadcast confirmed item collection to ALL clients
            server.to(data.roomId).emit(GameRoomEvents.ItemCollected, {
                ...data,
                inventoryFull: result.inventoryFull || false,
            });

            if (data.item.type === 'flag') server.to(data.roomId).emit(GameRoomEvents.FlagCollected, data.playerId);

            // Recalculate torch illumination after item pickup
            const illuminatedCells = this.torchService.recalculateIllumination(data.roomId, room.players);
            server.to(data.roomId).emit(GameRoomEvents.TorchIlluminationUpdate, { roomId: data.roomId, illuminatedCells, players: room.players });
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    /**
     * Handles item dropping
     */
    handleItemDropped(data: { roomId: string; playerId: string; item: Item; coords: Coords }, socket: Socket, server: Server): void {
        try {
            const room = this.gameRoomService.findRoomById(data.roomId);
            if (!room) {
                socket.emit(GameRoomEvents.GameRoomError, 'Room not found');
                return;
            }

            // Remove item from server inventory. Wrapped separately so that even if
            // the player is not found (e.g. disconnect/reconnect ID mismatch), the
            // drop is still broadcast and the item appears on the board.
            try {
                this.gameRoomService.removeItemFromInventory(data.roomId, data.playerId, data.item);
            } catch {
                // Inventory removal failed — continue so clients stay in sync visually
            }

            this.gameMovementService.addItemToBoard(data.roomId, data.item, data.coords);
            server.to(data.roomId).emit(GameRoomEvents.ItemDropped, data);

            // Recalculate torch illumination after item drop
            const illuminatedCells = this.torchService.recalculateIllumination(data.roomId, room.players);
            server.to(data.roomId).emit(GameRoomEvents.TorchIlluminationUpdate, { roomId: data.roomId, illuminatedCells, players: room.players });
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }
}

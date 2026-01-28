import { Coords } from '@app/modules/movement/interfaces/coords';
import { GameMovementService } from '@app/modules/movement/services/game-movement.service';
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
            this.gameMovementService.removeItemFromBoard(data.position);

            if (result.shouldDrop) {
                this.gameMovementService.addItemToBoard(result.shouldDrop.item, result.player.position);
            }

            if (data.item.type === 'flag') server.to(data.roomId).emit(GameRoomEvents.FlagCollected, data.playerId);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }

    /**
     * Handles item dropping
     */
    handleItemDropped(data: { roomId: string; playerId: string; item: Item; coords: Coords }, socket: Socket, server: Server): void {
        try {
            server.to(data.roomId).emit(GameRoomEvents.ItemDropped, data);
            this.gameRoomService.removeItemFromInventory(data.roomId, data.playerId, data.item);
            this.gameMovementService.addItemToBoard(data.item, data.coords);
        } catch (error) {
            socket.emit(GameRoomEvents.GameRoomError, error.message);
        }
    }
}

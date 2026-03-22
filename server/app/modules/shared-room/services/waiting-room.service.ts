import { MAX_CODE, MAX_DIGITS } from '@app/modules/shared-room/constants/waiting-room.constants';
import { Room } from '@app/modules/shared-room/interfaces/room';
import { Player } from '@app/shared/interfaces/player';
import { ErrorMessages } from '@common/error-messages.constants';
import { Injectable } from '@nestjs/common';
@Injectable()
export class WaitingRoomService {
    private waitingRooms: Room[] = [];

    createRoom(roomId: string, gameId: string, host: Player, sockedId: string, friendsOnly: boolean = false, hostUsername?: string): Room {
        host.id = sockedId;
        const newRoom: Room = {
            roomId,
            gameId,
            hostId: host.id,
            hostUsername,
            players: [host],
            futurePlayers: [],
            isLocked: false,
            dropInDropOut: false,
            friendsOnly,
            messages: [],
        };
        newRoom.reservedAvatars = [{ reservorId: host.id, chosenAvatar: host.avatar.name }];
        this.waitingRooms.push(newRoom);
        return newRoom;
    }

    checkRoomExistence(roomId: string): boolean {
        const room = this.findRoomById(roomId);
        if (!room) {
            throw new Error(ErrorMessages.RoomDoesNotExist);
        }
        if (room.isLocked) {
            throw new Error(ErrorMessages.RoomLocked);
        }
        return true;
    }

    joinRoom(roomId: string, playerId: string): Room | null {
        const room = this.findRoomById(roomId);
        if (!room) {
            throw new Error(ErrorMessages.RoomDoesNotExist);
        }
        if (room.isLocked) {
            throw new Error(ErrorMessages.RoomLocked);
        }
        if (!(room.players.some((player) => player.id === playerId) || room.futurePlayers.some((player) => player === playerId))) {
            room.futurePlayers.push(playerId);
        }
        return room;
    }

    addCharacter(roomId: string, player: Player, socketId: string): Room | null {
        const playerId = player.id;
        const room = this.findRoomById(roomId);
        if (!room) {
            throw new Error(ErrorMessages.RoomDoesNotExist);
        }

        if (room.isLocked) {
            throw new Error(ErrorMessages.RoomLocked);
        }

        if (room.players.some((p) => p.id === playerId)) {
            throw new Error(ErrorMessages.PlayerAlreadyInRoom);
        }
        player.id = socketId;
        room.futurePlayers = room.futurePlayers.filter((p) => p !== playerId);
        room.players.push(player);
        return room;
    }

    addMessage(roomId: string, message: { type: string; name?: string | null; content: string; time: string }) {
        const room = this.findRoomById(roomId);
        if (!room) throw new Error("La salle n'existe pas");
        room.messages.push(message);
    }

    reserveCharacter(roomId: string, playerId: string, chosenAvatar: string) {
        const room = this.findRoomById(roomId);
        if (!room) throw new Error(ErrorMessages.RoomDoesNotExist);
        room.reservedAvatars = room.reservedAvatars
            .filter((avatar) => avatar.reservorId !== playerId)
            .concat([{ reservorId: playerId, chosenAvatar }]);
    }

    leaveRoom(roomId: string, playerId: string) {
        const room = this.findRoomById(roomId);
        if (!room) {
            throw new Error(ErrorMessages.RoomDoesNotExist);
        }

        if (playerId === room.hostId) {
            this.waitingRooms = this.waitingRooms.filter((r) => r.roomId !== roomId);
            return true;
        }
        room.players = room.players.filter((player) => player.id !== playerId);
        room.futurePlayers = room.futurePlayers.filter((player) => player !== playerId);
        room.reservedAvatars = room.reservedAvatars.filter((avatar) => avatar.reservorId !== playerId);
    }

    toggleLockRoom(roomId: string, hostId: string) {
        const room = this.findRoomById(roomId);
        if (!room) {
            throw new Error(ErrorMessages.RoomDoesNotExist);
        }
        if (room.hostId !== hostId) {
            throw new Error(ErrorMessages.HostOnlyLockRoom);
        }
        room.isLocked = !room.isLocked;
        return room.isLocked;
    }

    toggleDropInDropOut(roomId: string, hostId: string): boolean {
        const room = this.findRoomById(roomId);
        if (!room) {
            throw new Error(ErrorMessages.RoomDoesNotExist);
        }
        if (room.hostId !== hostId) {
            throw new Error(ErrorMessages.HostOnlyLockRoom);
        }
        room.dropInDropOut = !room.dropInDropOut;
        return room.dropInDropOut;
    }

    kickPlayer(roomId: string, hostId: string, playerToKick: Player) {
        const room = this.findRoomById(roomId);
        if (!room) {
            throw new Error(ErrorMessages.RoomDoesNotExist);
        }
        if (room.hostId !== hostId) {
            throw new Error(ErrorMessages.HostOnlyKickPlayer);
        }
        room.players = room.players.filter((player) => player.id !== playerToKick.id);
        room.reservedAvatars = room.reservedAvatars.filter((avatar) => avatar.reservorId !== playerToKick.id);
        return true;
    }

    deleteRoom(roomId: string) {
        this.waitingRooms = this.waitingRooms.filter((room) => room.roomId !== roomId);
    }

    findRoomById(roomId: string): Room | null {
        return this.waitingRooms.find((room) => room.roomId === roomId);
    }

    generateCode(): string {
        let code = (Math.floor(Math.random() * MAX_CODE) + 1).toString().padStart(MAX_DIGITS, '0');
        while (this.waitingRooms.some((room) => room.roomId === code)) {
            code = (Math.floor(Math.random() * MAX_CODE) + 1).toString().padStart(MAX_DIGITS, '0');
        }
        return code;
    }

    getAvailableRooms(): Room[] {
        return this.waitingRooms.filter((room) => !room.isLocked);
    }

    findRoomsByPlayerId(playerId: string): Room[] {
        return this.waitingRooms.filter((room) => {
            const playerInRoom = room.players.some((player) => player.id === playerId);
            const futurePlayerInRoom = room.futurePlayers.includes(playerId);
            const ishost = room.hostId === playerId;
            return playerInRoom || futurePlayerInRoom || ishost;
        });
    }
}

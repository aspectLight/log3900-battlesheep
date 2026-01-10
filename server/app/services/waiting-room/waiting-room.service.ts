import { Player } from '@app/interfaces/player';
import { Room } from '@app/interfaces/room';
import { Injectable } from '@nestjs/common';
import { ErrorMessages } from '@common/error-messages.constants';
import { MAX_CODE, MAX_DIGITS } from '@app/constants/waiting-room.constants';
@Injectable()
export class WaitingRoomService {
    private waitingRooms: Room[] = [];

    createRoom(roomId: string, gameId: string, organisator: Player, sockedId: string): Room {
        organisator.id = sockedId;
        const newRoom: Room = {
            roomId,
            gameId,
            organisatorId: organisator.id,
            players: [organisator],
            futurePlayers: [],
            isLocked: false,
            messages: [],
            journalEntries: [],
        };
        newRoom.reservedAvatars = [{ reservorId: organisator.id, chosenAvatar: organisator.avatar.name }];
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

        if (playerId === room.organisatorId) {
            this.waitingRooms = this.waitingRooms.filter((r) => r.roomId !== roomId);
            return true;
        }
        room.players = room.players.filter((player) => player.id !== playerId);
        room.futurePlayers = room.futurePlayers.filter((player) => player !== playerId);
        room.reservedAvatars = room.reservedAvatars.filter((avatar) => avatar.reservorId !== playerId);
    }

    toggleLockRoom(roomId: string, organisatorId: string) {
        const room = this.findRoomById(roomId);
        if (!room) {
            throw new Error(ErrorMessages.RoomDoesNotExist);
        }
        if (room.organisatorId !== organisatorId) {
            throw new Error(ErrorMessages.HostOnlyLockRoom);
        }
        room.isLocked = !room.isLocked;
        return room.isLocked;
    }

    kickPlayer(roomId: string, organisatorId: string, playerToKick: Player) {
        const room = this.findRoomById(roomId);
        if (!room) {
            throw new Error(ErrorMessages.RoomDoesNotExist);
        }
        if (room.organisatorId !== organisatorId) {
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

    findRoomsByPlayerId(playerId: string): Room[] {
        return this.waitingRooms.filter((room) => {
            const playerInRoom = room.players.some((player) => player.id === playerId);
            const futurePlayerInRoom = room.futurePlayers.includes(playerId);
            const isOrganisator = room.organisatorId === playerId;
            return playerInRoom || futurePlayerInRoom || isOrganisator;
        });
    }
}

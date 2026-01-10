import { Player } from '@app/interfaces/player';
import { Room } from '@app/interfaces/room';
import { Injectable } from '@nestjs/common';
const MAX_CODE = 9999;
const MAX_DIGITS = 4;

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
        };
        newRoom.reservedAvatars = [{ reservorId: organisator.id, chosenAvatar: organisator.avatar.name }];
        this.waitingRooms.push(newRoom);
        return newRoom;
    }

    checkRoomExistence(roomId: string): boolean {
        const room = this.findRoomById(roomId);
        if (!room) {
            throw new Error("La salle n'existe pas");
        }
        if (room.isLocked) {
            throw new Error('La salle est verouillée');
        }
        return true;
    }

    joinRoom(roomId: string, playerId: string): Room | null {
        const room = this.findRoomById(roomId);
        if (!room) {
            throw new Error("La salle n'existe pas");
        }
        if (room.isLocked) {
            throw new Error('La salle est verouillée');
        }
        if (!(room.players.some((p) => p.id === playerId) || room.futurePlayers.some((p) => p === playerId))) {
            room.futurePlayers.push(playerId);
        }
        return room;
    }

    addCharacter(roomId: string, player: Player, socketId: string): Room | null {
        const room = this.findRoomById(roomId);
        if (!room) {
            throw new Error("La salle n'existe pas");
        }

        if (room.isLocked) {
            throw new Error('La salle est verouillée');
        }

        if (room.players.some((p) => p === player)) {
            throw new Error('Le joueur est déjà dans la salle');
        }
        player.id = socketId;
        room.futurePlayers = room.futurePlayers.filter((p) => p !== player.id);
        room.players.push(player);
        return room;
    }

    reserveCharacter(roomId: string, playerId: string, chosenAvatar: string) {
        const room = this.findRoomById(roomId);
        if (!room) {
            throw new Error("La salle n'existe pas");
        }
        room.reservedAvatars = room.reservedAvatars
            .filter((avatar) => avatar.reservorId !== playerId)
            .concat([{ reservorId: playerId, chosenAvatar }]);
    }

    leaveRoom(roomId: string, playerId: string) {
        const room = this.findRoomById(roomId);
        if (!room) {
            throw new Error("La salle n'existe pas");
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
            throw new Error("La salle n'existe pas");
        }
        if (room.organisatorId !== organisatorId) {
            throw new Error("Seul l'organisteur de la partie peut verrouiller la partie");
        }
        room.isLocked = !room.isLocked;
        return room.isLocked;
    }

    kickPlayer(roomId: string, organisatorId: string, playerToKick: Player) {
        const room = this.findRoomById(roomId);
        if (!room) {
            throw new Error("La salle n'existe pas");
        }
        if (room.organisatorId !== organisatorId) {
            throw new Error("Seul l'organisteur de la partie peut exclure un joueur");
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

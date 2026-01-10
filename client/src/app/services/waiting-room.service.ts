import { Injectable } from '@angular/core';
import { Player } from '@app/classes/player';
import { Room } from '@app/interfaces/room';
import { BehaviorSubject } from 'rxjs';

@Injectable({
    providedIn: 'root',
})
export class WaitingRoomService {
    currentRoom = new BehaviorSubject<Room>({
        roomId: '',
        gameId: '',
        organisatorId: '',
        players: [],
        isLocked: false,
        isDebugging: false,
    });

    get room$() {
        return this.currentRoom.asObservable();
    }

    updateRoom(room: Room) {
        this.currentRoom.next({ ...room });
    }

    addPlayer(players: Player[]) {
        const room = this.currentRoom.getValue();
        room.players = players;
        this.updateRoom(room);
    }

    removePlayer(playerToRemove: { playerId: string }) {
        const room = this.currentRoom.getValue();

        const playerId = playerToRemove.playerId;
        room.players = room.players.filter((player) => {
            return player.id !== playerId;
        });

        this.updateRoom(room);
    }

    toggleLock(isLocked: boolean) {
        const room = this.currentRoom.getValue();
        room.isLocked = isLocked;
        this.updateRoom(room);
    }

    startGame(newRoomId: string) {
        const room = this.currentRoom.getValue();
        room.roomId = newRoomId;
        this.updateRoom(room);
    }

    resetRoom() {
        this.currentRoom.next({
            roomId: '',
            gameId: '',
            organisatorId: '',
            players: [],
            isLocked: false,
            isDebugging: false,
        });
    }
}

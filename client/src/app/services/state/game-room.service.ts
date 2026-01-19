import { Injectable } from '@angular/core';
import { Player } from '@app/classes/entity/player';
import { Room } from '@app/interfaces/room.interface';
import { BehaviorSubject, Observable } from 'rxjs';

@Injectable({
    providedIn: 'root',
})
export class GameRoomService {
    private currentRoom = new BehaviorSubject<Room>({
        roomId: '',
        gameId: '',
        hostId: '',
        players: [],
        isLocked: false,
        isDebugging: false,
    });

    get room$(): Observable<Room> {
        return this.currentRoom.asObservable();
    }

    get room(): Room {
        return this.currentRoom.getValue();
    }

    updateRoom(room: Room) {
        this.currentRoom.next({ ...room });
    }

    updatePlayers(players: Player[]) {
        const room = this.currentRoom.getValue();
        if (room) {
            this.currentRoom.next({ ...room, players });
        }
    }

    toggleDebugMode() {
        const room = this.currentRoom.getValue();
        if (room) {
            this.currentRoom.next({ ...room, isDebugging: !room.isDebugging });
        }
    }

    setDebugMode(isDebugging: boolean) {
        const room = this.currentRoom.getValue();
        if (room) {
            this.currentRoom.next({ ...room, isDebugging });
        }
    }
}

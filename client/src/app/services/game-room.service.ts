import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { Room } from '@app/interfaces/room';
import { Player } from '@app/classes/player';

@Injectable({
    providedIn: 'root',
})
export class GameRoomService {
    private currentRoom = new BehaviorSubject<Room>({
        roomId: '',
        gameId: '',
        organisatorId: '',
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

    // clearRoom() {
    //     this.currentRoom.next(null);
    // }
}

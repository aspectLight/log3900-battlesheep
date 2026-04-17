import { Injectable } from '@angular/core';
import { Player } from '@app/classes/entity/player';
import { AVATAR_TYPES } from '@app/constants/player.constants';
import { AvatarType } from '@app/interfaces/avatar.interface';
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
        this.currentRoom.next({ ...room, players: room.players.map((p) => this.normalizePlayerAvatar(p)) });
    }

    updatePlayers(players: Player[]) {
        const room = this.currentRoom.getValue();
        if (room) {
            this.currentRoom.next({ ...room, players: players.map((p) => this.normalizePlayerAvatar(p)) });
        }
    }

    private normalizePlayerAvatar(player: Player): Player {
        const raw = (player as any).avatar;
        if (!raw) return player;
        if (typeof raw === 'string') {
            player.avatar = AVATAR_TYPES[raw] ?? null;
        } else if (!('avatar' in raw)) {
            // Partial object like { name: "Petrov" } — look up by name
            const found = Object.values(AVATAR_TYPES).find((a: AvatarType) => a.name.toLowerCase() === (raw.name as string)?.toLowerCase());
            player.avatar = found ?? null;
        }
        return player;
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

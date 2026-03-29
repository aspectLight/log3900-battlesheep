import { CommonModule } from '@angular/common';
import { Component, EventEmitter, OnInit, Output } from '@angular/core';
import { Board } from '@app/classes/board/board';
import { BoardComponent } from '@app/components/shared/board/board.component';
import { LoadingScreenComponent } from '@app/components/shared/loading-screen/loading-screen.component';
import { RoomInfo } from '@app/interfaces/room-info.interface';
import { RoomSocketService } from '@app/services/communication/socket-handlers/room-socket.service';
import { TranslateModule, TranslateService } from '@ngx-translate/core';

@Component({
    selector: 'app-room-list',
    templateUrl: './room-list.component.html',
    styleUrls: ['./room-list.component.scss'],
    imports: [CommonModule, BoardComponent, LoadingScreenComponent, TranslateModule],
})
export class RoomListComponent implements OnInit {
    @Output() selectedRoom = new EventEmitter<RoomInfo>();

    rooms: RoomInfo[] = [];
    selectedRoomId: string | null = null;
    isLoading = true;

    constructor(
        private roomSocketService: RoomSocketService,
        private translate: TranslateService,
    ) {}

    ngOnInit(): void {
        this.loadRooms();
    }

    loadRooms(): void {
        this.isLoading = true;
        this.roomSocketService.getAvailableRooms((rooms) => {
            this.rooms = rooms;
            this.isLoading = false;
        });
    }

    onSelectRoom(room: RoomInfo): void {
        if (room.status === 'playing' && room.dropInDropOut && room.playerCount < room.maxPlayers) {
            this.selectedRoomId = room.roomId;
            this.selectedRoom.emit(room);
        } else if (room.status === 'waiting' && room.playerCount < room.maxPlayers) {
            this.selectedRoomId = room.roomId;
            this.selectedRoom.emit(room);
        }
    }

    getBoard(room: RoomInfo): Board {
        return new Board(room.board);
    }

    getStatusLabel(status: 'waiting' | 'playing'): string {
        return status === 'waiting'
            ? this.translate.instant('room.status_waiting')
            : this.translate.instant('room.status_playing');
    }

    getModeLabel(mode: string): string {
        return mode === 'ctf' ? 'CTF' : 'Classique';
    }

    getAccessibilityLabel(room: RoomInfo): string {
        if (room.playerCount >= room.maxPlayers) return this.translate.instant('room.status_full');
        if (room.friendsOnly) return 'Amis seulement';
        if (room.status === 'playing' && room.dropInDropOut) return 'Drop-in';
        return this.translate.instant('room.status_open');
    }
}

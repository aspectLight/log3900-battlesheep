import { CommonModule } from '@angular/common';
import { Component, OnDestroy, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { Player } from '@app/classes/player';
import { ChatboxComponent } from '@app/components/chatbox/chatbox.component';
import { PlayerCardComponent } from '@app/components/player-card/player-card.component';
import { PopUpComponent } from '@app/components/pop-up/pop-up.component';
import { ErrorMessages, WaitRoomWelcomeMessage } from '@common/error-messages.constants';
import { ROUTES } from '@app/constants/routes.constants';
import { Room } from '@app/interfaces/room';
import { GameCreationService } from '@app/services/game-creation.service';
import { RoomSocketService } from '@app/services/socket/room-socket.service';
import { WaitingRoomService } from '@app/services/waiting-room.service';
import { VirtualPlayerService } from '@app/services/virtual-player.service';
import { Subscription } from 'rxjs';
import { VirtualPlayerType } from '@app/constants/player.constants';

@Component({
    imports: [CommonModule, PlayerCardComponent, PopUpComponent, ChatboxComponent],
    selector: 'app-waiting-player',
    templateUrl: './waiting-player.component.html',
    styleUrl: './waiting-player.component.scss',
})
export class WaitingPlayerComponent implements OnInit, OnDestroy {
    showError: boolean = false;
    errorMessage: string = WaitRoomWelcomeMessage;
    showMessage: boolean = true;
    showConfirmation: boolean = false;
    room: Room | null = null;
    isProfileSectionVisible: boolean = false;
    toDo: () => void;

    readonly routes = ROUTES;

    private roomSubscription!: Subscription;

    constructor(
        private gameCreationService: GameCreationService,
        private waitingRoomService: WaitingRoomService,
        private socketService: RoomSocketService,
        private virtualPlayerService: VirtualPlayerService,
        public router: Router,
    ) {}

    get code(): string {
        return this.gameCreationService.gameCode;
    }

    get isHost(): boolean {
        return this.gameCreationService.isHost;
    }

    get isStartValid(): boolean {
        if (!this.room) return false;

        const isCTF = this.gameCreationService.isCTF;
        const playerCount = this.room.players.length;

        return this.room.isLocked && playerCount > 1 && (!isCTF || (isCTF && playerCount % 2 === 0));
    }

    get showErrorFromService(): boolean {
        return this.waitingRoomService.isError;
    }

    get errorMessageFromService(): string {
        return this.waitingRoomService.errorMessage;
    }

    ngOnInit(): void {
        this.roomSubscription = this.waitingRoomService.room$.subscribe((room) => {
            this.room = room;
        });
        this.socketService.roomExists$.subscribe((roomExists) => {
            if (!roomExists) {
                this.errorMessage = ErrorMessages.GameDeleted;
                this.showError = true;
            }
        });
        this.socketService.isKicked$.subscribe((isKicked) => {
            if (isKicked) {
                this.errorMessage = ErrorMessages.PlayerKicked;
                this.showError = true;
            }
        });

        this.virtualPlayerService.resetUsedNames();
    }

    ngOnDestroy(): void {
        if (this.roomSubscription) {
            this.roomSubscription.unsubscribe();
        }
    }

    startGame() {
        if (this.isStartValid) {
            this.socketService.startGame(this.code);
        }
    }

    toggleLockRoom() {
        this.socketService.toggleLockRoom(this.code);
        this.resetMessages();
    }

    disableUnlockError() {
        this.waitingRoomService.isError = false;
        this.waitingRoomService.errorMessage = '';
    }

    confirmAction(action: string, $event?: Player) {
        if (action === 'kick') {
            this.errorMessage = 'Voulez-vous vraiment expulser ce joueur ?';
            this.toDo = () => this.kickPlayer($event as Player);
            this.showConfirmation = true;
        } else if (action === 'lock') {
            if (this.room?.isLocked) {
                this.errorMessage = 'Voulez-vous vraiment deverrouiller la salle ?';
                this.showConfirmation = true;
            } else {
                this.errorMessage = 'Voulez-vous vraiment verrouiller la salle ?';
                this.showConfirmation = false;
                this.toggleLockRoom();
            }
            this.toDo = () => this.toggleLockRoom();
        } else if (action === 'leave') {
            this.errorMessage = 'Voulez-vous vraiment quitter la salle ?';
            this.toDo = () => this.leaveRoom();
            this.showConfirmation = true;
        }
    }

    kickPlayer(player: Player) {
        this.socketService.kickPlayer(this.code, player);
        this.resetMessages();
        this.virtualPlayerService.removeName(player.id);
    }

    leaveRoom() {
        this.socketService.leaveRoom(this.code, (success, error) => {
            if (success) {
                this.router.navigate([ROUTES.home]);
            } else {
                this.errorMessage = error || ErrorMessages.QuitError;
                this.showError = true;
            }
        });
        this.resetMessages();
    }

    openProfileSection(): void {
        if (!this.room?.isLocked) {
            this.isProfileSectionVisible = true;
        } else {
            this.errorMessage = ErrorMessages.RoomLockedAddPlayer;
            this.showMessage = true;
        }
    }

    handleAgressiveProfileClick(): void {
        this.selectProfile(VirtualPlayerType.Aggressive);
    }

    handleDefensiveProfileClick(): void {
        this.selectProfile(VirtualPlayerType.Defensive);
    }

    onCancel(): void {
        this.resetMessages();
    }

    private selectProfile(profile: VirtualPlayerType): void {
        this.addVirtualPlayer(profile);
        this.closeProfileSection();
    }

    private addVirtualPlayer(profile: string) {
        const newVPlayer = this.virtualPlayerService.generateVirtualPlayer(profile);
        this.socketService.reserveAvatar(this.gameCreationService.gameCode, newVPlayer.avatar?.name || '', newVPlayer.id);
        this.socketService.createPlayer(this.gameCreationService.gameCode, newVPlayer);
    }

    private closeProfileSection(): void {
        this.isProfileSectionVisible = false;
    }

    private resetMessages(): void {
        this.errorMessage = '';
        this.showError = false;
        this.showMessage = false;
        this.showConfirmation = false;
    }
}

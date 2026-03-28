import { CommonModule } from '@angular/common';
import { Component, OnDestroy, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { Player } from '@app/classes/entity/player';
import { PlayerCardComponent } from '@app/components/player/player-card/player-card.component';
import { PopUpComponent } from '@app/components/shared/pop-up/pop-up.component';
import { VirtualPlayerType } from '@app/constants/player.constants';
import { ROUTES } from '@app/constants/routes.constants';
import { Room } from '@app/interfaces/room.interface';
import { RoomSocketService } from '@app/services/communication/socket-handlers/room-socket.service';
import { VirtualPlayerService } from '@app/services/gameplay/virtual-player.service';
import { GameCreationService } from '@app/services/lobby/game-creation.service';
import { WaitingRoomService } from '@app/services/lobby/waiting-room.service';
import { VirtualCurrencyService } from '@app/services/currency/virtual-currency.service';
import { ErrorMessages, WaitRoomWelcomeMessage } from '@common/error-messages.constants';
import { Subscription } from 'rxjs';

@Component({
    imports: [CommonModule, PlayerCardComponent, PopUpComponent],
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
        public currencyService: VirtualCurrencyService,
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

        return playerCount > 1 && (!isCTF || (isCTF && playerCount % 2 === 0));
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

    async startGame(): Promise<void> {
        if (this.isStartValid) {
            try {
                await this.socketService.startGame(this.code);
            } catch (error) {
                this.errorMessage = error instanceof Error ? error.message : 'Failed to start game';
                this.showError = true;
            }
        }
    }

    toggleLockRoom() {
        this.socketService.toggleLockRoom(this.code);
        this.resetMessages();
    }

    toggleDropInDropOut() {
        this.socketService.toggleDropInDropOut(this.code);
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

    private async addVirtualPlayer(profile: string): Promise<void> {
        const newVPlayer = this.virtualPlayerService.generateVirtualPlayer(profile);
        try {
            await this.socketService.reserveAvatar(this.gameCreationService.gameCode, newVPlayer.avatar?.name || '', newVPlayer.id, true);
            this.socketService.createPlayer(this.gameCreationService.gameCode, newVPlayer);
        } catch (error) {
            this.errorMessage = error instanceof Error ? error.message : 'Failed to reserve avatar';
            this.showError = true;
        }
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

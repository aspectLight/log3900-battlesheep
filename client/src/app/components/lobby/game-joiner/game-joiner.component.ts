import { Component, ElementRef, OnDestroy, OnInit, ViewChild } from '@angular/core';
import { Auth } from '@angular/fire/auth';
import { Router, RouterLink } from '@angular/router';
import { RoomListComponent } from '@app/components/lobby/room-list/room-list.component';
import { PopUpComponent } from '@app/components/shared/pop-up/pop-up.component';
import { ProfileMenuComponent } from '@app/components/shared/profile-menu/profile-menu.component';
import { ROUTES } from '@app/constants/routes.constants';
import { RoomInfo } from '@app/interfaces/room-info.interface';
import { MovementSocketService } from '@app/services/communication/socket-handlers/movement-socket.service';
import { RoomSocketService } from '@app/services/communication/socket-handlers/room-socket.service';
import { SocketService } from '@app/services/communication/socket-handlers/socket.service';
import { VirtualCurrencyService } from '@app/services/currency/virtual-currency.service';
import { GameCreationService } from '@app/services/lobby/game-creation.service';
import { SocialEvents } from '@common/socket.constants';
import { TranslateModule, TranslateService } from '@ngx-translate/core';
@Component({
    selector: 'app-game-joiner',
    templateUrl: './game-joiner.component.html',
    imports: [RouterLink, PopUpComponent, RoomListComponent, ProfileMenuComponent, TranslateModule],
    styleUrl: './game-joiner.component.scss',
})
export class GameJoinerComponent implements OnInit, OnDestroy {
    @ViewChild('gameCode') gameCodeInput!: ElementRef<HTMLInputElement>;
    showError: boolean;
    errorMessage: string;
    showBlockedWarning = false;
    blockedWarningMessage = '';
    isJoinButtonEnabled = false;
    private suppressNextJoinError = false;

    private readonly SERVER_ERROR_MAP: Record<string, string> = {
        "La salle n'existe pas": 'errors.room_not_found',
        'La salle est verrouillée': 'errors.room_locked',
    };

    constructor(
        private socketService: RoomSocketService,
        private movementSocketService: MovementSocketService,
        private gameCreationService: GameCreationService,
        private router: Router,
        private auth: Auth,
        private globalSocketService: SocketService,
        private currencyService: VirtualCurrencyService,
        private translate: TranslateService,
    ) {
        this.gameCreationService.isHost = false;
        this.movementSocketService.sync();
    }

    ngOnInit(): void {
        this.currencyService.fetchBalance();
        const socket = this.globalSocketService.socket;
        if (socket) {
            socket.on(SocialEvents.BlockedUserInRoom, (data: { blockedUsernames: string[] }) => {
                this.blockedWarningMessage = `Les utilisateurs suivants que vous avez bloqués sont dans cette salle : ${data.blockedUsernames.join(
                    ', ',
                )}. Voulez-vous quand même entrer ?`;
                this.showBlockedWarning = true;
            });
        }
    }

    ngOnDestroy(): void {
        const socket = this.globalSocketService.socket;
        if (socket) {
            socket.off(SocialEvents.BlockedUserInRoom);
        }
    }

    onBlockedWarningConfirm(): void {
        this.showBlockedWarning = false;
        this.globalSocketService.send(SocialEvents.BlockedUserRoomChoice, { choice: 'enter' });
    }

    onBlockedWarningCancel(): void {
        this.showBlockedWarning = false;
        this.suppressNextJoinError = true;
        this.globalSocketService.send(SocialEvents.BlockedUserRoomChoice, { choice: 'cancel' });
    }

    joinGame(): void {
        const gameCode = this.gameCodeInput.nativeElement.value;
        if (!/^\d{4}$/.test(gameCode)) {
            return;
        }
        this.joinByCode(gameCode);
    }

    onGameCodeInput(input: HTMLInputElement): void {
        const sanitizedGameCode = input.value.replace(/\D/g, '').slice(0, 4);
        input.value = sanitizedGameCode;
        this.isJoinButtonEnabled = sanitizedGameCode.length === 4;
    }

    onRoomSelected(room: RoomInfo) {
        if ((room.entryFee ?? 0) > this.currencyService.balance) {
            this.errorMessage = 'Solde insuffisant pour rejoindre cette partie';
            this.showError = true;
            return;
        }
        if (room.status === 'playing' && room.dropInDropOut) {
            const currentUid = this.auth.currentUser?.uid;
            const isReturning = !!currentUid && (room.abandonedPlayerFirebaseIds ?? []).includes(currentUid);

            this.gameCreationService.gameCode = room.roomId;
            this.gameCreationService.isDropIn = true;

            // All drop-in players (new or returning) go through character creation.
            // Store the uid for returning players so their stats can be restored server-side.
            this.gameCreationService.returningDropInUid = isReturning ? currentUid : undefined;
            this.router.navigate([ROUTES.createPlayer]);
        } else {
            this.joinByCode(room.roomId);
        }
    }

    private joinByCode(gameCode: string) {
        this.socketService.joinRoom(gameCode, (success, error) => {
            if (success) {
                this.gameCreationService.gameCode = gameCode;
                this.gameCreationService.isDropIn = false;
                this.router.navigate([ROUTES.createPlayer]);
            } else if (!this.suppressNextJoinError) {
                this.errorMessage = this.translateServerError(error);
                this.showError = true;
            }
            this.suppressNextJoinError = false;
        });
    }

    private translateServerError(error?: string): string {
        if (!error) return this.translate.instant('errors.generic');
        const key = this.SERVER_ERROR_MAP[error];
        return key ? this.translate.instant(key) : error;
    }
}

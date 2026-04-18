import { Component, OnDestroy, OnInit } from '@angular/core';
import { Router, RouterLink } from '@angular/router';
import { Player } from '@app/classes/entity/player';
import { BonusChoicesComponent } from '@app/components/player/bonus-choices/bonus-choices.component';
import { CharacterGridComponent } from '@app/components/player/character-grid/character-grid.component';
import { PopUpComponent } from '@app/components/shared/pop-up/pop-up.component';
import { BonusType, STAT_WITH_BONUS } from '@app/constants/bonus.constants';
import { D4_VALUE, D6_VALUE, DEFAULT_STATS_VALUE } from '@app/constants/player.constants';
import { ROUTES } from '@app/constants/routes.constants';
import { Bonus } from '@app/interfaces/character.interface';
import { Reservation } from '@app/interfaces/reservation.interface';
import { ProfileService } from '@app/services/communication/profile.service';
import { RoomSocketService } from '@app/services/communication/socket-handlers/room-socket.service';
import { VirtualCurrencyService } from '@app/services/currency/virtual-currency.service';
import { GameCreationService } from '@app/services/lobby/game-creation.service';
import { PlayerCreationService } from '@app/services/lobby/player-creation.service';
import { TranslateModule, TranslateService } from '@ngx-translate/core';
import { ErrorMessages } from '@common/error-messages.constants';
import { environment } from 'src/environments/environment';
import { Subscription } from 'rxjs';

@Component({
    selector: 'app-create-player-page',
    templateUrl: './create-player-page.component.html',
    styleUrls: ['./create-player-page.component.scss'],
    imports: [CharacterGridComponent, BonusChoicesComponent, PopUpComponent, RouterLink, TranslateModule],
})
export class CreatePlayerPageComponent implements OnInit, OnDestroy {
    showError: boolean;
    errorMessage: string;
    validCharacter: boolean = true;

    reservedAvatars: Reservation[] = [];
    characterGridResetNonce = 0;

    gameModified: boolean = false;
    isHost: boolean = false;
    isCreateButtonEnabled: boolean = false;

    /** When true, closing the error popup returns to home (room locked / game started without this player). */
    private dismissErrorNavigatesHome = false;

    private readonly subscriptions = new Subscription();

    constructor(
        public playerCreationService: PlayerCreationService,
        public gameCreationService: GameCreationService,
        public socketService: RoomSocketService,
        public router: Router,
        public roomSocketService: RoomSocketService,
        public profileService: ProfileService,
        public currencyService: VirtualCurrencyService,
        private translate: TranslateService,
    ) {
        this.isHost = this.gameCreationService.isHost;
        this.socketService.getReservedAvatars(this.gameCreationService.gameCode);
        this.roomSocketService.sync();
        this.currencyService.fetchCatalogue();
    }

    get selectedCharacter() {
        return this.playerCreationService.selectedCharacter;
    }

    get previewPlayer(): Player {
        const { character, bonus } = this.playerCreationService.selectedCharacter;
        const p = character.name
            ? new Player(
                  character.name,
                  character.name.toLowerCase(),
                  bonus.life === STAT_WITH_BONUS ? BonusType.Health : BonusType.Speed,
                  bonus.defense === STAT_WITH_BONUS ? BonusType.Defense : BonusType.Attack,
              )
            : new Player();
        if (!character.name) {
            p.stats[BonusType.Health].value = bonus.life;
            p.stats[BonusType.Speed].value = bonus.speed;
        }
        p.stats[BonusType.Attack].value = bonus.attack ?? D4_VALUE;
        p.stats[BonusType.Defense].value = bonus.defense ?? D6_VALUE;
        return p;
    }

    ngOnInit() {
        this.playerCreationService.reset();
        this.updateCreateButtonState();
        this.subscriptions.add(
            this.socketService.roomLocked$.subscribe((locked) => {
                if (locked) {
                    this.dismissErrorNavigatesHome = true;
                    this.errorMessage = this.translate.instant('errors.game_deleted_or_locked');
                    this.showError = true;
                }
            }),
        );
        this.subscriptions.add(
            this.socketService.characterCreationGameStartedLeftOut$.subscribe(() => {
                this.dismissErrorNavigatesHome = true;
                this.errorMessage = this.translate.instant('errors.game_started_left_out_character_creation');
                this.showError = true;
            }),
        );
        this.subscriptions.add(
            this.socketService.reservedAvatars$.subscribe((avatars) => {
                this.reservedAvatars = avatars;
            }),
        );
        this.subscriptions.add(
            this.socketService.avatarReservationFailed$.subscribe((payload) => {
                if (payload.error !== ErrorMessages.AvatarAlreadyInUse) {
                    return;
                }
                this.playerCreationService.clearAvatar();
                this.characterGridResetNonce++;
                this.errorMessage = this.translate.instant('errors.avatar_already_used');
                this.showError = true;
                this.updateCreateButtonState();
            }),
        );
    }

    ngOnDestroy(): void {
        this.subscriptions.unsubscribe();
    }

    getId(): string {
        return this.socketService.getId() || '';
    }

    async onCharacterSelected(chosenAvatar: { name: string; id: number }): Promise<void> {
        this.playerCreationService.selectedCharacter = chosenAvatar;

        // The host creates the waiting room only when clicking the final button,
        // so the room doesn't exist yet — skip avatar reservation for the host.
        // Drop-in players join a game already in progress (no waiting room to reserve against);
        // avatar conflicts are validated server-side in handleJoinGameRoom.
        if (this.isHost || this.gameCreationService.isDropIn) {
            this.validCharacter = true;
            this.updateCreateButtonState();
            return;
        }

        try {
            await this.socketService.reserveAvatar(this.gameCreationService.gameCode, chosenAvatar.name, this.getId());
            this.validCharacter = true;
            this.updateCreateButtonState();
        } catch (error) {
            this.playerCreationService.clearAvatar();
            this.characterGridResetNonce++;
            // Duplicate character: server emits `AvatarReservationFailed` only for that case.
            if (error instanceof Error && error.message === ErrorMessages.AvatarAlreadyInUse) {
                this.updateCreateButtonState();
                return;
            }
            if (error instanceof Error) {
                this.errorMessage = error.message;
                this.showError = true;
            } else {
                this.errorMessage = this.translate.instant('errors.generic');
                this.showError = true;
            }
            this.updateCreateButtonState();
        }
    }

    onCreatePlayerErrorDismiss(): void {
        this.showError = false;
        this.errorMessage = '';
        if (this.dismissErrorNavigatesHome) {
            this.dismissErrorNavigatesHome = false;
            this.router.navigate([ROUTES.home]);
        }
    }

    onBonusSelected(chosenBonus: Bonus): void {
        this.playerCreationService.selectedBonus = chosenBonus;
        this.updateCreateButtonState();
    }

    async createPlayer() {
        if (this.gameModified) return;

        const profile = await this.profileService.getProfile();
        const playerName = profile.username;
        const newPlayer = this.playerCreationService.createPlayer(playerName);
        if (newPlayer) {
            newPlayer.profileAvatarId = profile.avatarId ?? null;
            newPlayer.profileAvatarUrl = profile.avatarUrl ? `${environment.serverUrl}${profile.avatarUrl}` : null;
            newPlayer.activeBanner = (profile.preferences?.['activeBanner'] as string) ?? null;
        }
        if (newPlayer) {
            if (this.gameCreationService.isDropIn) {
                // Attach the firebaseUid for returning players so the server can restore their stats
                if (this.gameCreationService.returningDropInUid) {
                    newPlayer.firebaseUid = this.gameCreationService.returningDropInUid;
                }
                // Drop-in flow: join a game in progress
                this.socketService.joinGameRoom(this.gameCreationService.gameCode, newPlayer, (success, error) => {
                    if (!success) {
                        this.errorMessage = error || this.translate.instant('errors.join_impossible');
                        this.showError = true;
                    }
                    // On success, joinGameRoom callback handles the redirect via gameManagerService
                });
            } else if (this.isHost) {
                try {
                    await this.socketService.createRoom(
                        this.gameCreationService.gameCode,
                        this.gameCreationService.selectedGame._id,
                        newPlayer,
                    );
                    this.router.navigate([ROUTES.waiting]);
                } catch (error) {
                    this.errorMessage = error instanceof Error ? error.message : this.translate.instant('errors.generic');
                    this.showError = true;
                }
            } else {
                this.socketService.createPlayer(this.gameCreationService.gameCode, newPlayer);
                this.router.navigate([ROUTES.waiting]);
            }
        } else {
            this.validCharacter = false;
        }
    }

    handlePopUp(): void {
        this.gameModified = false;
        this.showError = false;
        this.router.navigate([ROUTES.home]);
    }

    private updateCreateButtonState(): void {
        const { character, bonus } = this.selectedCharacter;
        this.isCreateButtonEnabled =
            character.name.trim() !== '' &&
            (bonus.life !== DEFAULT_STATS_VALUE || bonus.speed !== DEFAULT_STATS_VALUE) &&
            bonus.defense !== null &&
            bonus.attack !== null;
    }
}

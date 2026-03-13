import { Component, OnInit } from '@angular/core';
import { Router, RouterLink } from '@angular/router';
import { Player } from '@app/classes/entity/player';
import { BonusChoicesComponent } from '@app/components/player/bonus-choices/bonus-choices.component';
import { CharacterGridComponent } from '@app/components/player/character-grid/character-grid.component';
import { PopUpComponent } from '@app/components/shared/pop-up/pop-up.component';
import { BonusType, STAT_WITH_BONUS } from '@app/constants/bonus.constants';
import { ROUTES } from '@app/constants/routes.constants';
import { Bonus } from '@app/interfaces/character.interface';
import { Reservation } from '@app/interfaces/reservation.interface';
import { RoomSocketService } from '@app/services/communication/socket-handlers/room-socket.service';
import { GameCreationService } from '@app/services/lobby/game-creation.service';
import { PlayerCreationService } from '@app/services/lobby/player-creation.service';
import { ErrorMessages } from '@common/error-messages.constants';
import { ProfileService } from '@app/services/communication/profile.service';
import { environment } from 'src/environments/environment';

@Component({
    selector: 'app-create-player-page',
    templateUrl: './create-player-page.component.html',
    styleUrls: ['./create-player-page.component.scss'],
    imports: [CharacterGridComponent, BonusChoicesComponent, PopUpComponent, RouterLink],
})
export class CreatePlayerPageComponent implements OnInit {
    showError: boolean;
    errorMessage: string;
    validCharacter: boolean = true;

    reservedAvatars: Reservation[] = [];

    gameModified: boolean = false;
    isHost: boolean = false;

    constructor(
        public playerCreationService: PlayerCreationService,
        public gameCreationService: GameCreationService,
        public socketService: RoomSocketService,
        public router: Router,
        public roomSocketService: RoomSocketService,
        public profileService: ProfileService,
    ) {
        this.isHost = this.gameCreationService.isHost;
        this.socketService.getReservedAvatars(this.gameCreationService.gameCode);
        this.roomSocketService.sync();
    }

    get selectedCharacter() {
        return this.playerCreationService.selectedCharacter;
    }

    get previewPlayer(): Player {
        if (!this.selectedCharacter.character.name) {
            return new Player();
        }
        const player = new Player(
            this.selectedCharacter.character.name,
            this.selectedCharacter.character.name.toLowerCase(),
            this.selectedCharacter.bonus.life === STAT_WITH_BONUS ? BonusType.Health : BonusType.Speed,
            this.selectedCharacter.bonus.defense === STAT_WITH_BONUS ? BonusType.Defense : BonusType.Attack,
        );
        return player;
    }

    ngOnInit() {
        this.socketService.roomLocked$.subscribe((locked) => {
            if (locked) {
                this.errorMessage = ErrorMessages.GameDeletedOrLocked;
                this.showError = true;
            }
        });
        this.socketService.reservedAvatars$.subscribe((avatars) => {
            this.reservedAvatars = avatars;
        });
    }

    getId(): string {
        return this.socketService.getId() || '';
    }

    onCharacterSelected(chosenAvatar: { name: string; id: number }): void {
        this.playerCreationService.selectedCharacter = chosenAvatar;
        this.socketService.reserveAvatar(this.gameCreationService.gameCode, chosenAvatar.name, this.getId());
    }

    onBonusSelected(chosenBonus: Bonus): void {
        this.playerCreationService.selectedBonus = chosenBonus;
    }

    async createPlayer() {
        if (this.gameModified) return;

        const profile = await this.profileService.getProfile();
        const playerName = profile.username;
        const newPlayer = this.playerCreationService.createPlayer(playerName);
        if (newPlayer) {
            newPlayer.profileAvatarId = profile.avatarId ?? null;
            newPlayer.profileAvatarUrl = profile.avatarUrl ? `${environment.serverUrl}${profile.avatarUrl}` : null;
        }
        if (newPlayer) {
            if (this.gameCreationService.isDropIn) {
                // Drop-in flow: join a game in progress
                this.socketService.joinGameRoom(this.gameCreationService.gameCode, newPlayer, (success, error) => {
                    if (!success) {
                        this.errorMessage = error || 'Impossible de rejoindre la partie';
                        this.showError = true;
                    }
                    // On success, joinGameRoom callback handles the redirect via gameManagerService
                });
            } else if (this.isHost) {
                this.socketService.createRoom(this.gameCreationService.gameCode, this.gameCreationService.selectedGame._id, newPlayer);
                this.router.navigate([ROUTES.waiting]);
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
}

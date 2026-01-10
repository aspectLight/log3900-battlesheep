import { Component, ElementRef, OnInit, ViewChild } from '@angular/core';
import { Router, RouterLink } from '@angular/router';
import { BonusChoicesComponent } from '@app/components/bonus-choices/bonus-choices.component';
import { CharacterGridComponent } from '@app/components/character-grid/character-grid.component';
import { PopUpComponent } from '@app/components/pop-up/pop-up.component';
import { ErrorMessages } from '@common/error-messages.constants';
import { ROUTES } from '@app/constants/routes.constants';
import { Bonus } from '@app/interfaces/character';
import { GameCreationService } from '@app/services/game-creation.service';
import { PlayerCreationService } from '@app/services/player-creation.service';
import { RoomSocketService } from '@app/services/socket/room-socket.service';
import { Reservation } from '@app/interfaces/reservation';
import { Player } from '@app/classes/player';
import { BonusType, STAT_WITH_BONUS } from '@app/constants/bonus.constants';

@Component({
    selector: 'app-create-player-page',
    templateUrl: './create-player-page.component.html',
    styleUrls: ['./create-player-page.component.scss'],
    imports: [CharacterGridComponent, BonusChoicesComponent, PopUpComponent, RouterLink],
})
export class CreatePlayerPageComponent implements OnInit {
    // ViewChild to remove
    @ViewChild('playerName') playerNameInput!: ElementRef<HTMLInputElement>;
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

    createPlayer() {
        if (this.gameModified) return;
        const playerName = this.playerNameInput.nativeElement.value;
        const newPlayer = this.playerCreationService.createPlayer(playerName);
        if (newPlayer) {
            if (this.isHost) {
                this.socketService.createRoom(this.gameCreationService.gameCode, this.gameCreationService.selectedGame._id, newPlayer);
            } else {
                this.socketService.createPlayer(this.gameCreationService.gameCode, newPlayer);
            }
            this.router.navigate([ROUTES.waiting]);
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

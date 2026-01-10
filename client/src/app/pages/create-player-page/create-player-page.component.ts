import { Component, ElementRef, OnInit, ViewChild } from '@angular/core';
import { Router, RouterLink } from '@angular/router';
import { BonusChoicesComponent } from '@app/components/bonus-choices/bonus-choices.component';
import { CharacterGridComponent } from '@app/components/character-grid/character-grid.component';
import { PopUpComponent } from '@app/components/pop-up/pop-up.component';
import { ErrorMessages } from '@app/constants/error-messages.constants';
import { DEFAULT_STATS_VALUE } from '@app/constants/player.constants';
import { ROUTES } from '@app/constants/routes.constants';
import { Bonus, Character } from '@app/interfaces/character';
import { GameCreationService } from '@app/services/game-creation.service';
import { PlayerCreationService } from '@app/services/player-creation.service';
import { SocketService } from '@app/services/socket.service';

@Component({
    selector: 'app-create-player-page',
    templateUrl: './create-player-page.component.html',
    styleUrls: ['./create-player-page.component.scss'],
    imports: [CharacterGridComponent, BonusChoicesComponent, PopUpComponent, RouterLink],
})
export class CreatePlayerPageComponent implements OnInit {
    @ViewChild('playerName') playerNameInput!: ElementRef<HTMLInputElement>;
    showError: boolean;
    errorMessage: string;
    validCharacter: boolean = true;

    reservedAvatars: { reservorId: string; chosenAvatar: string }[] = [];

    gameModified: boolean = false;
    isHost: boolean = false;

    initialCharacter: Character = {
        character: { name: '', id: 0, avatar: '', avatarFull: '' },
        bonus: { life: DEFAULT_STATS_VALUE, speed: DEFAULT_STATS_VALUE, defense: DEFAULT_STATS_VALUE, attack: DEFAULT_STATS_VALUE },
    };

    constructor(
        public playerCreationService: PlayerCreationService,
        public gameCreationService: GameCreationService,
        public socketService: SocketService,
        public router: Router,
    ) {
        this.isHost = this.gameCreationService.isHost;
        this.socketService.getReservedAvatars(this.gameCreationService.gameCode);
    }

    get selectedCharacter() {
        return this.playerCreationService.selectedCharacter;
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
        this.socketService.reserveAvatar(this.gameCreationService.gameCode, chosenAvatar.name);
    }

    onBonusSelected(chosenBonus: Bonus): void {
        this.playerCreationService.selectedBonus = chosenBonus;
    }

    async createPlayer() {
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

import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { GameListComponent } from '@app/components/editor/game-list/game-list.component';
import { PopUpComponent } from '@app/components/shared/pop-up/pop-up.component';
import { ProfileMenuComponent } from '@app/components/shared/profile-menu/profile-menu.component';
import { VirtualCurrencyService } from '@app/services/currency/virtual-currency.service';
import { ProfileService } from '@app/services/communication/profile.service';
import { GameCreationService } from '@app/services/lobby/game-creation.service';
import { GameListService } from '@app/services/lobby/game-list.service';

import { Game } from '@app/classes/game/game';
import { ROUTES } from '@app/constants/routes.constants';
import { RoomSocketService } from '@app/services/communication/socket-handlers/room-socket.service';
import { TranslateModule } from '@ngx-translate/core';

@Component({
    selector: 'app-game-creator',
    imports: [CommonModule, FormsModule, GameListComponent, PopUpComponent, RouterLink, ProfileMenuComponent, TranslateModule],
    templateUrl: './game-creator.component.html',
    styleUrl: './game-creator.component.scss',
})
export class GameCreatorComponent implements OnInit {
    selectedGame: Game | null = null;
    gameModified = false;
    hasGames = false;
    friendsOnly = false;
    entryFee: number = 0;
    showInsufficientFundsPopup = false;
    showPrivateGamePopup = false;

    private currentUsername: string = '';

    constructor(
        private router: Router,
        private gameListService: GameListService,
        private gameCreationService: GameCreationService,
        private socketService: RoomSocketService,
        private currencyService: VirtualCurrencyService,
        private profileService: ProfileService,
    ) {}

    ngOnInit() {
        this.gameModified = false;
        this.gameCreationService.isHost = true;
        this.friendsOnly = false;
        this.gameCreationService.friendsOnly = false;
        this.entryFee = 0;
        this.gameCreationService.entryFee = 0;
        this.currencyService.fetchBalance();
        this.profileService.getProfile().then((profile) => {
            this.currentUsername = profile.username;
        });
    }

    onSelectGame(game: Game): void {
        this.selectedGame = game;
    }

    onGamesLengthChange(length: number): void {
        this.hasGames = length > 0;
    }

    preventInvalidChars(event: KeyboardEvent): void {
        const invalidChars = ['e', 'E', '+', '-', '.'];
        if (invalidChars.includes(event.key)) {
            event.preventDefault();
        }
    }

    onEntryFeeInput(event: Event): void {
        const inputElement = event.target as HTMLInputElement;
        
        let valueStr = inputElement.value;
        // Keep only digits in case paste event bypassed keydown
        valueStr = valueStr.replace(/[^0-9]/g, '');
        
        if (valueStr === '') {
            inputElement.value = '0';
            this.entryFee = 0;
            return;
        }

        const value = parseInt(valueStr, 10);
        
        if (value > 1000) {
            inputElement.value = '1000';
            this.entryFee = 1000;
        } else {
            // Set value to clean string (removes leading zeros)
            inputElement.value = value.toString();
            this.entryFee = value;
        }
    }

    async createGame(): Promise<void> {
        if (this.selectedGame) {
            if (this.entryFee > this.currencyService.balance) {
                this.showInsufficientFundsPopup = true;
                return;
            }
            const freshGame = await this.gameListService.fetchGameById(this.selectedGame._id);
            if (!freshGame) {
                this.gameModified = true;
                return;
            }
            if (freshGame.privacy === 'private' && freshGame.owner !== this.currentUsername) {
                this.showPrivateGamePopup = true;
                return;
            }
            this.gameCreationService.friendsOnly = this.friendsOnly;
            this.gameCreationService.entryFee = this.entryFee;
            this.gameCreationService.setSelectedGame(this.selectedGame);
            this.socketService.generateCode((code) => {
                if (code) {
                    const gameCode = code;
                    this.gameCreationService.setGameCode(gameCode);
                }
            });
            this.router.navigate([ROUTES.createPlayer]);
        }
    }

    handlePopUp(): void {
        this.gameModified = false;
    }

    handlePrivateGamePopup(): void {
        this.showPrivateGamePopup = false;
    }
}

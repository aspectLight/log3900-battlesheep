import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { GameListComponent } from '@app/components/editor/game-list/game-list.component';
import { ProfileMenuComponent } from '@app/components/shared/profile-menu/profile-menu.component';
import { PopUpComponent } from '@app/components/shared/pop-up/pop-up.component';
import { GameCreationService } from '@app/services/lobby/game-creation.service';
import { GameListService } from '@app/services/lobby/game-list.service';
import { VirtualCurrencyService } from '@app/services/currency/virtual-currency.service';

import { Game } from '@app/classes/game/game';
import { ROUTES } from '@app/constants/routes.constants';
import { RoomSocketService } from '@app/services/communication/socket-handlers/room-socket.service';

@Component({
    selector: 'app-game-creator',
    imports: [CommonModule, FormsModule, GameListComponent, PopUpComponent, RouterLink, ProfileMenuComponent],
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

    constructor(
        private router: Router,
        private gameListService: GameListService,
        private gameCreationService: GameCreationService,
        private socketService: RoomSocketService,
        private currencyService: VirtualCurrencyService,
    ) {}

    ngOnInit() {
        this.gameModified = false;
        this.gameCreationService.isHost = true;
        this.friendsOnly = false;
        this.gameCreationService.friendsOnly = false;
        this.entryFee = 0;
        this.gameCreationService.entryFee = 0;
        this.currencyService.fetchBalance();
    }

    onSelectGame(game: Game): void {
        this.selectedGame = game;
    }

    onGamesLengthChange(length: number): void {
        this.hasGames = length > 0;
    }

    async createGame(): Promise<void> {
        if (this.selectedGame) {
            if (this.entryFee > this.currencyService.balance) {
                this.showInsufficientFundsPopup = true;
                return;
            }
            this.gameModified = await this.gameListService.fetchGameById(this.selectedGame._id);
            if (!this.gameModified) {
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
    }

    handlePopUp(): void {
        this.gameModified = false;
    }
}

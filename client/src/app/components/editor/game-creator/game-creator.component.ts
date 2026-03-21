import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { GameListComponent } from '@app/components/editor/game-list/game-list.component';
import { PopUpComponent } from '@app/components/shared/pop-up/pop-up.component';
import { GameCreationService } from '@app/services/lobby/game-creation.service';
import { GameListService } from '@app/services/lobby/game-list.service';

import { Game } from '@app/classes/game/game';
import { ROUTES } from '@app/constants/routes.constants';
import { RoomSocketService } from '@app/services/communication/socket-handlers/room-socket.service';

@Component({
    selector: 'app-game-creator',
    imports: [CommonModule, FormsModule, GameListComponent, PopUpComponent, RouterLink],
    templateUrl: './game-creator.component.html',
    styleUrl: './game-creator.component.scss',
})
export class GameCreatorComponent implements OnInit {
    selectedGame: Game | null = null;
    gameModified = false;
    hasGames = false;
    friendsOnly = false;

    constructor(
        private router: Router,
        private gameListService: GameListService,
        private gameCreationService: GameCreationService,
        private socketService: RoomSocketService,
    ) {}

    ngOnInit() {
        this.gameModified = false;
        this.gameCreationService.isHost = true;
        this.friendsOnly = false;
        this.gameCreationService.friendsOnly = false;
    }

    onSelectGame(game: Game): void {
        this.selectedGame = game;
    }

    onGamesLengthChange(length: number): void {
        this.hasGames = length > 0;
    }

    async createGame(): Promise<void> {
        if (this.selectedGame) {
            this.gameModified = await this.gameListService.fetchGameById(this.selectedGame._id);
            if (!this.gameModified) {
                this.gameCreationService.friendsOnly = this.friendsOnly;
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

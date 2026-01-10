import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { Router, RouterLink } from '@angular/router';
import { GameListComponent } from '@app/components/game-list/game-list.component';
import { PopUpComponent } from '@app/components/pop-up/pop-up.component';
import { GameCreationService } from '@app/services/game-creation.service';
import { GameListService } from '@app/services/game-list.service';
import { SocketService } from '@app/services/socket.service';

import { Game } from '@app/classes/game';
import { ROUTES } from '@app/constants/routes.constants';

@Component({
    selector: 'app-game-creator',
    imports: [CommonModule, GameListComponent, PopUpComponent, RouterLink],
    templateUrl: './game-creator.component.html',
    styleUrl: './game-creator.component.scss',
})
export class GameCreatorComponent implements OnInit {
    selectedGame: Game | null = null;
    gameModified: boolean = false;
    errorMessage = 'Le jeu sélectionné est caché ou supprimé.';

    constructor(
        private router: Router,
        private gameListService: GameListService,
        private gameCreationService: GameCreationService,
        private socketService: SocketService,
    ) {}

    ngOnInit() {
        this.gameModified = false;
        this.gameCreationService.isHost = true;
    }

    onSelectGame(game: Game): void {
        if (game) {
            this.selectedGame = game;
            this.gameCreationService.setSelectedGame(game);
        }
    }

    async createGame(): Promise<void> {
        if (this.selectedGame) {
            this.gameModified = await this.gameListService.fetchGameById(this.selectedGame._id);
            if (!this.gameModified) {
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

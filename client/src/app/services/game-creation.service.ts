import { Injectable } from '@angular/core';
import { Game } from '@app/classes/game';
import { Player } from '@app/classes/player';

@Injectable({
    providedIn: 'root',
})
export class GameCreationService {
    selectedGame: Game;
    gameCode: string;
    selectedPlayer: Player;

    private _isHost: boolean = false;

    get isHost(): boolean {
        return this._isHost;
    }

    set isHost(value: boolean) {
        this._isHost = value;
    }

    setGameCode(value: string) {
        sessionStorage.setItem('gameCode', JSON.stringify(value));
        this.gameCode = value;
    }

    setSelectedGame(game: Game) {
        this.selectedGame = game;
    }
}

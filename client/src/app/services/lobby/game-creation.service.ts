import { Injectable } from '@angular/core';
import { Game } from '@app/classes/game/game';
import { MODES } from '@app/constants/game.constants';

@Injectable({
    providedIn: 'root',
})
export class GameCreationService {
    selectedGame: Game;
    gameCode: string;
    isDropIn: boolean = false;
    friendsOnly: boolean = false;
    entryFee: number = 0;

    private _isHost: boolean = false;

    get isHost(): boolean {
        return this._isHost;
    }

    get isCTF(): boolean {
        return this.selectedGame?.mode === MODES.CTF;
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

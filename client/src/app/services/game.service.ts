import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Board } from '@app/classes/board';
import { Game } from '@app/classes/game';
import { API_ENDPOINTS } from '@common/api-endpoints.constants';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { ItemService } from './item.service';

interface SavedGameData {
    game: Game;
    savedAt: number;
}

@Injectable({
    providedIn: 'root',
})
export class GameService {
    isGameBeingModified: boolean = false;
    private game: Game;
    private tempGame: Game;

    private readonly baseUrl: string = environment.serverUrl;
    private readonly expirationTimeMs = 24 * 60 * 60 * 1000; // 24 hours

    constructor(
        private http: HttpClient,
        private itemService: ItemService,
    ) {
        const savedData = this.getSavedGameData();

        if (savedData && this.isGameExpired()) {
            this.clearSavedGame();
            return;
        }

        if (savedData) {
            this.game = new Game(savedData.game);
            this.tempGame = new Game(this.game);
            this.tempGame.board = this.game.board.copyBoard();
            this.isGameBeingModified = true;
        } else {
            this.setNewGame();
        }
        this.itemService.setItemCountFromBoard(this.game.board);
    }

    getId() {
        return this.game._id;
    }
    getName() {
        return this.game.name;
    }
    getDescription() {
        return this.game.description;
    }
    getGameSettings() {
        return { mode: this.game.mode, boardSize: this.game.board.size };
    }
    getBoard(): Board {
        return this.game.getBoard();
    }
    getMode() {
        return this.game.mode;
    }

    setName(name: string) {
        this.game.name = name;
    }
    setDescription(description: string) {
        this.game.description = description;
    }
    setGameSettings(mode: string, boardSize: number): void {
        this.game.mode = mode;
        this.game.board.size = boardSize;
        this.itemService.setItemCountFromBoard(this.game.board);

        this.saveGameToLocalStorage();
    }
    setBoard(board: Board): void {
        this.game.board = board;
    }

    undoModifications() {
        this.game = new Game(this.tempGame);
        this.itemService.setItemCountFromBoard(this.game.board);
    }

    setGame(gameData: Game) {
        this.game = new Game(gameData);
        this.setGameSettings(this.game.mode, this.game.board.size);
        this.isGameBeingModified = true;

        this.tempGame = new Game(gameData);
        this.tempGame.board = this.game.board.copyBoard();

        this.saveGameToLocalStorage();
    }
    setNewGame() {
        this.game = new Game();
        this.game.board = new Board(this.game.board.size);
        this.isGameBeingModified = false;

        this.tempGame = new Game(this.game);
        this.tempGame.board = this.game.board.copyBoard();

        this.saveGameToLocalStorage();
    }

    saveNewGame(): Observable<void> {
        return this.http
            .post<void>(this.baseUrl + API_ENDPOINTS.games, this.game, {
                headers: { contentType: 'application/json' },
            })
            .pipe(
                // We're using tap to execute a side effect after the http request success
                // Since we're returning an observable, the http request isn't executed here
                tap(() => {
                    localStorage.removeItem('savedGame');
                    this.isGameBeingModified = false;
                }),
            );
    }

    saveModifications(): Observable<Game> {
        this.game.isVisible = false;
        return this.http
            .patch<Game>(this.baseUrl + API_ENDPOINTS.games + this.game._id, this.game, {
                headers: { contentType: 'application/json' },
            })
            .pipe(
                // We're using tap to execute a side effect after the http request success
                // Since we're returning an observable, the http request isn't executed here
                tap(() => {
                    localStorage.removeItem('savedGame');
                    this.isGameBeingModified = false;
                }),
            );
    }
    fetchGames(): Observable<Game[]> {
        return this.http.get<Game[]>(environment.serverUrl + API_ENDPOINTS.games);
    }

    isGameExpired(): boolean {
        const savedData = this.getSavedGameData();
        if (!savedData) return false;

        const now = Date.now();
        const elapsed = now - savedData.savedAt;
        return elapsed > this.expirationTimeMs;
    }

    clearSavedGame(): void {
        localStorage.removeItem('savedGame');
        this.setNewGame();
    }

    private getSavedGameData(): SavedGameData | null {
        const saved = localStorage.getItem('savedGame');
        if (!saved) return null;

        try {
            const parsed = JSON.parse(saved);

            if (!parsed.savedAt) {
                return {
                    game: parsed,
                    savedAt: Date.now(),
                };
            }

            return parsed as SavedGameData;
        } catch {
            return null;
        }
    }

    private saveGameToLocalStorage(): void {
        const data: SavedGameData = {
            game: this.game,
            savedAt: Date.now(),
        };
        localStorage.setItem('savedGame', JSON.stringify(data));
    }
}

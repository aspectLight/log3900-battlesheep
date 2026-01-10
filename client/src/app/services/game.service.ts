import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Board } from '@app/classes/board';
import { Game } from '@app/classes/game';
import { API_ENDPOINTS } from '@common/api-endpoints.constants';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';
import { ItemService } from './item.service';

@Injectable({
    providedIn: 'root',
})
export class GameService {
    isGameBeingModified: boolean = false;
    private game: Game;
    private tempGame: Game;

    private readonly baseUrl: string = environment.serverUrl;

    constructor(
        private http: HttpClient,
        private itemService: ItemService,
    ) {
        const savedGame = localStorage.getItem('savedGame');
        if (savedGame) {
            this.game = new Game(JSON.parse(savedGame));
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
        return this.http.post<void>(this.baseUrl + API_ENDPOINTS.games, this.game, {
            headers: { contentType: 'application/json' },
        });
    }

    saveModifications(): Observable<Game> {
        this.game.isVisible = false;
        return this.http.patch<Game>(this.baseUrl + API_ENDPOINTS.games + this.game._id, this.game, {
            headers: { contentType: 'application/json' },
        });
    }
    fetchGames(): Observable<Game[]> {
        return this.http.get<Game[]>(environment.serverUrl + API_ENDPOINTS.games);
    }

    private saveGameToLocalStorage() {
        localStorage.setItem('savedGame', JSON.stringify(this.game));
    }
}

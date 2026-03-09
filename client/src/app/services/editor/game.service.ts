import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Auth } from '@angular/fire/auth';
import { Board } from '@app/classes/board/board';
import { Game } from '@app/classes/game/game';
import { SessionService } from '@app/services/state/session.service';
import { API_ENDPOINTS } from '@common/api-endpoints.constants';
import { Observable, from, switchMap } from 'rxjs';
import { tap } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { ItemService } from '@app/services/editor/item.service';

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
        private auth: Auth,
        private session: SessionService,
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

    setGameSettings(mode: string, boardSize: number, privacy: string): void {
        this.game.mode = mode;
        this.game.board.size = boardSize;
        this.game.privacy = privacy;

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
        this.setGameSettings(this.game.mode, this.game.board.size, this.game.privacy);
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

    // Sauvegarde un nouveau jeu sur le serveur.
    // from() convertit la Promise de getAuthHeaders() en Observable pour l'intégrer dans le flux RxJS.
    // switchMap() attend les headers d'auth, puis lance la requête HTTP POST avec ceux-ci.
    // tap() exécute un effet secondaire (nettoyage du localStorage) sans modifier la valeur émise.
    // L'Observable retourné n'est exécuté que lorsqu'un composant s'y abonne via .subscribe().
    saveNewGame(): Observable<void> {
        return from(this.getAuthHeaders()).pipe(
            switchMap((headers) =>
                this.http.post<void>(this.baseUrl + API_ENDPOINTS.games, this.game, { headers }),
            ),
            tap(() => {
                localStorage.removeItem('savedGame');
                this.isGameBeingModified = false;
            }),
        );
    }

    // Sauvegarde les modifications d'un jeu existant (PATCH).
    // Même pattern que saveNewGame : from → switchMap (requête HTTP) → tap (nettoyage).
    saveModifications(): Observable<Game> {
        return from(this.getAuthHeaders()).pipe(
            switchMap((headers) =>
                this.http.patch<Game>(this.baseUrl + API_ENDPOINTS.games + this.game._id, this.game, { headers }),
            ),
            tap(() => {
                localStorage.removeItem('savedGame');
                this.isGameBeingModified = false;
            }),
        );
    }

    // Récupère la liste de tous les jeux depuis le serveur.
    // from → switchMap : obtient les headers d'auth puis lance le GET.
    fetchGames(purpose?: string): Observable<Game[]> {
        return from(this.getAuthHeaders()).pipe(
            switchMap((headers) => {
                const params: Record<string, string> = {};
                if (purpose) params['purpose'] = purpose;
                return this.http.get<Game[]>(environment.serverUrl + API_ENDPOINTS.games, { headers, params });
            }),
        );
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

    private async getAuthHeaders(): Promise<HttpHeaders> {
        const user = this.auth.currentUser;
        const sessionId = this.session.sessionId;

        if (!user || !sessionId) {
            throw new Error('Utilisateur non authentifié');
        }

        const token = await user.getIdToken();
        return new HttpHeaders().set('Authorization', `Bearer ${token}`).set('x-session-id', sessionId);
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

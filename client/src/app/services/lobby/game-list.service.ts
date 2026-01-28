import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from '@app/../environments/environment';
import { Game } from '@app/classes/game/game';
import { API_ENDPOINTS } from '@common/api-endpoints.constants';
import { GameService } from '@app/services/editor/game.service';
import { Observable, firstValueFrom } from 'rxjs';

@Injectable({
    providedIn: 'root',
})
export class GameListService {
    constructor(
        private http: HttpClient,
        private gameService: GameService,
    ) {}

    getDate(game: Game): string {
        const date = new Date(game.modificationDate).toLocaleString('fr-FR', {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: '2-digit',
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit',
        });
        return date;
    }

    onCheckboxClick(game: Game): Observable<object> {
        const updatedGame = { isVisible: !game.isVisible };
        return this.http.patch(environment.serverUrl + API_ENDPOINTS.games + game._id, updatedGame, {
            headers: { contentType: 'application/json' },
        });
    }

    onDeleteClick(game: Game): Observable<object> {
        return this.http.delete(environment.serverUrl + API_ENDPOINTS.games + game._id, {
            headers: { contentType: 'application/json' },
        });
    }

    onModifyClick(game: Game): void {
        this.gameService.setGame(game);
    }

    async fetchGameById(id: string): Promise<boolean> {
        let game: Game;
        try {
            game = await firstValueFrom(this.http.get<Game>(environment.serverUrl + API_ENDPOINTS.games + id));
            return !game.isVisible;
        } catch (error) {
            return true;
        }
    }
}

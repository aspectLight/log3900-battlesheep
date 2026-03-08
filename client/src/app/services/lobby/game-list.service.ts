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

    onDeleteClick(game: Game): Observable<object> {
        return this.http.delete(environment.serverUrl + API_ENDPOINTS.games + game._id, {
            headers: { contentType: 'application/json' },
        });
    }

    onModifyClick(game: Game): void {
        this.gameService.setGame(game);
    }

    async fetchGameById(id: string): Promise<boolean> {
        try {
            await firstValueFrom(this.http.get<Game>(environment.serverUrl + API_ENDPOINTS.games + id));
            return false;
        } catch (error) {
            return true;
        }
    }
}

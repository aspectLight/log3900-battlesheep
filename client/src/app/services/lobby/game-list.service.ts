import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Auth } from '@angular/fire/auth';
import { environment } from '@app/../environments/environment';
import { Game } from '@app/classes/game/game';
import { GameService } from '@app/services/editor/game.service';
import { SessionService } from '@app/services/state/session.service';
import { API_ENDPOINTS } from '@common/api-endpoints.constants';
import { Observable, firstValueFrom, from, switchMap } from 'rxjs';

@Injectable({
    providedIn: 'root',
})
export class GameListService {
    constructor(
        private http: HttpClient,
        private gameService: GameService,
        private auth: Auth,
        private session: SessionService,
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
        return from(this.getAuthHeaders()).pipe(
            switchMap((headers) => this.http.delete(environment.serverUrl + API_ENDPOINTS.games + game._id, { headers })),
        );
    }

    duplicateGame(gameId: string): Observable<void> {
        return from(this.getAuthHeaders()).pipe(
            switchMap((headers) => this.http.post<void>(environment.serverUrl + API_ENDPOINTS.games + gameId + '/duplicate', {}, { headers })),
        );
    }

    updatePrivacy(gameId: string, privacy: string): Observable<Game> {
        return from(this.getAuthHeaders()).pipe(
            switchMap((headers) => this.http.patch<Game>(environment.serverUrl + API_ENDPOINTS.games + gameId, { privacy }, { headers })),
        );
    }

    onModifyClick(game: Game): void {
        this.gameService.setGame(game);
    }

    async fetchGameById(id: string): Promise<Game | null> {
        try {
            const headers = await this.getAuthHeaders();
            const game = await firstValueFrom(this.http.get<Game>(environment.serverUrl + API_ENDPOINTS.games + id, { headers }));
            return new Game(game);
        } catch (error) {
            return null;
        }
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
}

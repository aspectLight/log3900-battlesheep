import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Auth } from '@angular/fire/auth';
import { firstValueFrom } from 'rxjs';
import { environment } from 'src/environments/environment';
import { SessionService } from '@app/services/state/session.service';
import { LogsHistoryItem } from '@app/interfaces/history/logs-history.interface';
import { GameHistoryItem } from '@app/interfaces/history/game-history.interface';

@Injectable({ providedIn: 'root' })
export class HistoryService {
  constructor(
    private http: HttpClient,
    private auth: Auth,
    private session: SessionService,
  ) {}

  async getLoginHistory(): Promise<LogsHistoryItem[]> {
    const headers = await this.buildAuthHeaders();
    return await firstValueFrom(
      this.http.get<LogsHistoryItem[]>(
        `${environment.serverUrl}/auth/history/logins`,
        { headers },
      ),
    );
  }

  async getGameHistory(): Promise<GameHistoryItem[]> {
    const headers = await this.buildAuthHeaders();
    return await firstValueFrom(
      this.http.get<GameHistoryItem[]>(
        `${environment.serverUrl}/auth/history/games`,
        { headers },
      ),
    );
  }

  private async buildAuthHeaders(): Promise<HttpHeaders> {
    const user = this.auth.currentUser;
    const sessionId = this.session.sessionId;

    if (!user || !sessionId) 
      throw new Error('User ou sessionId manquant');

    const token = await user.getIdToken();

    return new HttpHeaders()
      .set('Authorization', `Bearer ${token}`)
      .set('x-session-id', sessionId);
  }
}
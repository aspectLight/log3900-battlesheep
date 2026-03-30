import { CommonModule, DatePipe } from '@angular/common';
import { Component, inject, signal } from '@angular/core';
import { HistoryService } from '@app/services/history/history.service'; 
import { GameHistoryItem } from '@app/interfaces/history/game-history.interface';
import { RouterLink } from '@angular/router';
import { TranslateModule } from '@ngx-translate/core';


@Component({
  selector: 'app-games-history',
  standalone: true,
  imports: [CommonModule, DatePipe, RouterLink, TranslateModule],
  templateUrl: './games-history.component.html',
  styleUrl: './games-history.component.scss',
})
export class GamesHistoryComponent {
  private readonly history = inject(HistoryService);

  loading = signal(true);
  error = signal<string | null>(null);
  games = signal<GameHistoryItem[]>([]);

  constructor() {
    this.load();
  }

  async load() {
    this.loading.set(true);
    this.error.set(null);

    try {
      const data = await this.history.getGameHistory();
      this.games.set(data);
    } catch (e: any) {
      this.error.set(e?.message ?? "Erreur lors du chargement de l’historique");
    } finally {
      this.loading.set(false);
    }
  }

  resultLabel(g: GameHistoryItem): string {
    if (g.hasAbandoned) return 'Abandonnée';
    return g.hasWon ? 'Gagnée' : 'Perdue';
  }

  resultClass(g: GameHistoryItem): string {
    if (g.hasAbandoned) return 'abandoned';
    return g.hasWon ? 'won' : 'lost';
  }

  trackByStartDate = (_: number, g: GameHistoryItem) => g.startDate;
}
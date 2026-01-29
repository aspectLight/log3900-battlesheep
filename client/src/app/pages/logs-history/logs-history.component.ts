import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common'; 
import { RouterModule } from '@angular/router';
import { HistoryService } from '@app/services/communication/history.service';
import { LogsHistoryItem } from '@app/interfaces/history/logs-history.interface';

@Component({
  selector: 'app-logs-history',
  standalone: true,
  imports: [CommonModule, RouterModule], 
  templateUrl: './logs-history.component.html',
  styleUrls: ['./logs-history.component.scss'],
})
export class LogsHistoryComponent implements OnInit {
  items: LogsHistoryItem[] = [];
  loading = true;
  error: string | null = null;

  constructor(private history: HistoryService) {}

  async ngOnInit(): Promise<void> {
    try {
      this.items = await this.history.getLoginHistory();
    } catch (e: any) {
      this.error = e?.message ?? 'Erreur lors du chargement';
    } finally {
      this.loading = false;
    }
  }

  label(type: 'login' | 'logout') {
    return type === 'login' ? 'Connexion' : 'Déconnexion';
  }
}
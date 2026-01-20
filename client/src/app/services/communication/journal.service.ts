import { Injectable } from '@angular/core';
import { SocketService } from '@app/services/communication/socket-handlers/socket.service';
import { CombatService } from '@app/services/gameplay/combat.service';
import { GameRoomEvents } from '@common/socket.constants';
import { ISocketService } from '@app/interfaces/socket-service.interface';
import { Socket } from 'socket.io-client';

@Injectable({
    providedIn: 'root',
})
export class JournalService implements ISocketService {
    socket: Socket;
    journalEntries: { type: string; content: string; time: string }[] = [];
    filteredEntries: { type: string; content: string; time: string }[] = [];

    private scrollCallback: (() => void) | null = null;

    constructor(
        private socketService: SocketService,
        private combatService: CombatService,
    ) {
        this.socketService.registerSocketService(this);
        this.setUpConnection();
    }

    get playerName() {
        return this.socketService.playerName || '';
    }

    setUpConnection(): void {
        this.socket = this.socketService.socket;
        this.clearJournalEntries();
        this.setUpListeners();
    }

    addToJournals(journalEntry: { type: string; content: string; time: string }) {
        const pattern = new RegExp(`\\b${this.playerName}\\b`);
        this.journalEntries.push(journalEntry);
        if (pattern.test(journalEntry.content) && !journalEntry.content.includes(this.playerName + ' -')) {
            this.filteredEntries.push(journalEntry);
        }
    }

    clearJournalEntries() {
        this.journalEntries = [];
        this.filteredEntries = [];
    }

    setScrollHandler(callback: () => void) {
        this.scrollCallback = callback;
    }

    triggerScroll() {
        this.scrollCallback?.();
    }

    private setUpListeners(): void {
        this.socketService.on(GameRoomEvents.AddJournalEntry, (journalEntry: { type: string; content: string; time: string }) => {
            if (journalEntry.type === 'COMBAT') {
                if (this.combatService.isCombatMode) {
                    this.addToJournals(journalEntry);
                }
            } else {
                this.addToJournals(journalEntry);
            }
            this.triggerScroll();
        });
    }
}

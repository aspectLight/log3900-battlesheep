/* eslint-disable @typescript-eslint/ban-types */
import { provideHttpClientTesting } from '@angular/common/http/testing';
import { TestBed } from '@angular/core/testing';
import { SocketService } from '@app/services/communication/socket-handlers/socket.service';
import { CombatService } from '@app/services/gameplay/combat.service';
import { JournalService } from '@app/services/communication/journal.service';

describe('JournalService', () => {
    let service: JournalService;
    const eventHandlers: { [key: string]: Function } = {};
    let socketServiceMock: jasmine.SpyObj<SocketService>;
    let combatServiceMock: jasmine.SpyObj<CombatService>;
    let playerNameValue: string | undefined = 'TestUser';

    beforeEach(() => {
        socketServiceMock = jasmine.createSpyObj('SocketService', ['connect', 'on', 'getJournalEntriesFromGameRoom', 'registerSocketService']);
        socketServiceMock.on.and.callFake((event: string, callback: Function) => {
            eventHandlers[event] = callback;
        });
        socketServiceMock.registerSocketService.and.returnValue(undefined);
        Object.defineProperty(socketServiceMock, 'playerName', {
            get: () => playerNameValue,
        });

        combatServiceMock = jasmine.createSpyObj('CombatService', ['someMethod']);
        combatServiceMock.enemy = null;
        combatServiceMock.isCombatMode = false;

        TestBed.configureTestingModule({
            providers: [
                provideHttpClientTesting(),
                JournalService,
                { provide: SocketService, useValue: socketServiceMock },
                { provide: CombatService, useValue: combatServiceMock },
            ],
        });

        service = TestBed.inject(JournalService);
    });

    it('should be created', () => {
        expect(service).toBeTruthy();
    });

    it('should listen to "addJournalEntry" and add entry to journalEntries array for non-combat entries', () => {
        const testEntry = { type: 'info', content: 'Test message', time: '12:00' };

        eventHandlers['addJournalEntry'](testEntry);

        expect(service.journalEntries).toContain(testEntry);
    });

    it('should add combat entry when in combat mode', () => {
        const combatEntry = { type: 'COMBAT', content: 'Combat message', time: '12:30' };
        combatServiceMock.isCombatMode = true;

        eventHandlers['addJournalEntry'](combatEntry);

        expect(service.journalEntries).toContain(combatEntry);
    });

    it('should add to filteredEntries if journalEntry contains the player name', () => {
        const entryWithName = {
            type: 'info',
            content: 'TestUser a gagné',
            time: '13:00',
        };

        service.addToJournals(entryWithName);

        expect(service.journalEntries).toContain(entryWithName);
        expect(service.filteredEntries).toContain(entryWithName);
    });

    it('should clear journalEntries only', () => {
        const entry = {
            type: 'info',
            content: 'TestUser a gagné',
            time: '14:00',
        };

        service.addToJournals(entry);
        service.clearJournalEntries();

        expect(service.journalEntries.length).toBe(0);
        expect(service.filteredEntries.length).toBe(0);
    });

    it('should return player name from socket service', () => {
        playerNameValue = 'TestUser';
        expect(service.playerName).toBe('TestUser');
    });

    it('should return empty string when player name is not set', () => {
        playerNameValue = undefined;
        expect(service.playerName).toBe('');
    });
});

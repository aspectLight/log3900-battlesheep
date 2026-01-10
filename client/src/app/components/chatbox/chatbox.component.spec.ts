import { provideHttpClientTesting } from '@angular/common/http/testing';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { ChatService } from '@app/services/chat.service';
import { JournalService } from '@app/services/journal.service';
import { ChatboxComponent } from './chatbox.component';

const MESSAGES_LENGTH = 2;
const NULBER_OF_TIMES_CALLED = 3;

describe('ChatboxComponent', () => {
    let component: ChatboxComponent;
    let fixture: ComponentFixture<ChatboxComponent>;
    let chatServiceSpy: jasmine.SpyObj<ChatService>;
    let journalServiceSpy: jasmine.SpyObj<JournalService>;

    beforeEach(async () => {
        chatServiceSpy = jasmine.createSpyObj('ChatService', [
            'clearMessages',
            'getMessagesFromWaitingRoom',
            'sendMessageToWaitingRoom',
            'sendMessageToGameRoom',
            'setScrollHandler',
        ]);
        chatServiceSpy.setScrollHandler.and.stub();
        chatServiceSpy.messages = [
            { type: 'received', content: 'Hello', time: '12:00' },
            { type: 'sent', content: 'World', time: '12:01' },
        ];
        chatServiceSpy.playerName = 'TestUser';
        const filteredEntries = [
            { type: 'type1', content: 'Hello', time: '12:00' },
            { type: 'sent', content: 'World', time: '12:01' },
        ];
        const journalEntries = [
            { type: 'type1', content: 'Hello', time: '12:00' },
            { type: 'sent', content: 'World', time: '12:01' },
        ];
        journalServiceSpy = jasmine.createSpyObj('JournalService', ['getMessagesFromWaitingRoom', 'getMessagesFromGameRoom', 'setScrollHandler']);
        journalServiceSpy.setScrollHandler.and.stub();
        journalServiceSpy.journalEntries = journalEntries;
        journalServiceSpy.filteredEntries = filteredEntries;

        await TestBed.configureTestingModule({
            imports: [ChatboxComponent],
            providers: [
                provideHttpClientTesting(),
                { provide: ChatService, useValue: chatServiceSpy },
                { provide: JournalService, useValue: journalServiceSpy },
            ],
        }).compileComponents();

        fixture = TestBed.createComponent(ChatboxComponent);
        component = fixture.componentInstance;

        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });

    it('should get name from ChatService', () => {
        expect(component.name).toEqual(chatServiceSpy.playerName);
    });

    it('should get journal entries from JournalService', () => {
        expect(component.journal).toEqual(journalServiceSpy.journalEntries);
    });

    it('should get filtered journal entries from JournalService', () => {
        component.withFilter = true;
        expect(component.journal).toEqual(journalServiceSpy.filteredEntries);
    });

    it('should send message', () => {
        component.roomType = 'WaitingRoom';
        component.newMessage = 'Message1';
        component.sendMessage();
        expect(chatServiceSpy.sendMessageToWaitingRoom).toHaveBeenCalledWith('Message1');
        expect(component.newMessage).toEqual('');

        component.roomType = 'GameRoom';
        component.newMessage = 'Message1';
        component.sendMessage();
        expect(chatServiceSpy.sendMessageToGameRoom).toHaveBeenCalledWith('Message1');
        expect(component.newMessage).toEqual('');

        component.roomType = 'EndRoom';
        component.newMessage = 'Message1';
        component.sendMessage();
        expect(chatServiceSpy.sendMessageToGameRoom).toHaveBeenCalledWith('Message1');
        expect(component.newMessage).toEqual('');
    });

    it('should not send empty message', () => {
        component.newMessage = '   ';
        component.sendMessage();
        expect(component.messages.length).toBe(MESSAGES_LENGTH);
    });

    it('should filter by name', () => {
        component.withFilter = false;
        component.filterByName();
        expect(component.withFilter).toBeTrue();
    });

    it('should reset filter', () => {
        component.withFilter = true;
        component.resetFilter();
        expect(component.withFilter).toBeFalse();
    });

    it('should scroll automatically', () => {
        spyOn(component, 'scrollToBottom');
        component.ngAfterViewInit();
        expect(chatServiceSpy.setScrollHandler).toHaveBeenCalled();
        expect(journalServiceSpy.setScrollHandler).toHaveBeenCalled();
        expect(component.scrollToBottom).toHaveBeenCalledTimes(1);

        const chatScrollFn = chatServiceSpy.setScrollHandler.calls.mostRecent().args[0];
        const journalScrollFn = journalServiceSpy.setScrollHandler.calls.mostRecent().args[0];

        chatScrollFn();
        journalScrollFn();

        expect(component.scrollToBottom).toHaveBeenCalledTimes(NULBER_OF_TIMES_CALLED);
    });

    it('should toggle chatbox collapse state', () => {
        expect(component.isCollapsed).toBeFalse();
        component.toggleChatbox();
        expect(component.isCollapsed).toBeTrue();
        component.toggleChatbox();
        expect(component.isCollapsed).toBeFalse();
    });
});

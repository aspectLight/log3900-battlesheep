import { NgClass } from '@angular/common';
import { AfterViewInit, Component, ElementRef, Input, OnInit, ViewChild } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ChatService } from '@app/services/communication/chat.service';
import { JournalService } from '@app/services/communication/journal.service';
const MAX_MESSAGE_LENGTH = 200;

@Component({
    selector: 'app-chatbox',
    imports: [NgClass, FormsModule],
    templateUrl: './chatbox.component.html',
    styleUrl: './chatbox.component.scss',
})
export class ChatboxComponent implements OnInit, AfterViewInit {
    @Input() roomType: 'GeneralChat' | 'WaitingRoom' | 'GameRoom' | 'EndRoom' = 'GeneralChat';
    @ViewChild('chatboxMessages') private messagesContainer!: ElementRef<HTMLDivElement>;

    showMessages: boolean = true;
    withFilter: boolean = false;
    isCollapsed: boolean = false;

    newMessage: string = '';

    constructor(
        private chatService: ChatService,
        private journalService: JournalService,
    ) {
        this.scrollToBottom();
    }

    get messages() {
        return this.chatService.messages;
    }

    get journal() {
        if (this.withFilter) {
            return this.journalService.filteredEntries;
        }
        return this.journalService.journalEntries;
    }

    get name() {
        return this.chatService.playerName;
    }

    ngOnInit() {
        if (this.roomType === 'GeneralChat') {
            this.chatService.clearMessages();
            this.chatService.getGeneralChatMessages();
        } else if (this.roomType === 'WaitingRoom') {
            this.chatService.clearMessages();
            this.chatService.getMessagesFromWaitingRoom();
        }
    }

    ngAfterViewInit() {
        this.chatService.setScrollHandler(() => this.scrollToBottom());
        this.journalService.setScrollHandler(() => this.scrollToBottom());
        this.scrollToBottom();
    }

    sendMessage() {
        if (this.newMessage.trim() && this.newMessage.length <= MAX_MESSAGE_LENGTH) {
            switch (this.roomType) {
                case 'GeneralChat':
                    this.chatService.sendMessageToGeneralChat(this.newMessage);
                    break;
                case 'WaitingRoom':
                    this.chatService.sendMessageToWaitingRoom(this.newMessage);
                    break;
                case 'GameRoom':
                    this.chatService.sendMessageToGameRoom(this.newMessage);
                    break;
                case 'EndRoom':
                    this.chatService.sendMessageToGameRoom(this.newMessage);
                    break;
            }
            this.newMessage = '';
            this.scrollToBottom();
        }
    }

    filterByName() {
        this.withFilter = true;
    }

    resetFilter() {
        this.withFilter = false;
    }

    scrollToBottom() {
        // add a timeout of 100ms to wait for the messages to be rendered
        setTimeout(() => {
            if (this.messagesContainer?.nativeElement) {
                this.messagesContainer.nativeElement.scrollTop = this.messagesContainer.nativeElement.scrollHeight;
            }
        }, 100);
    }

    toggleChatbox() {
        this.isCollapsed = !this.isCollapsed;
    }
}

import { CommonModule } from '@angular/common';
import { AfterViewInit, Component, ElementRef, Input, OnDestroy, OnInit, ViewChild } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ChatService } from '@app/services/communication/chat.service';
import { CustomChannelService } from '@app/services/communication/custom-channel.service';
import { Subscription } from 'rxjs';

const MAX_MESSAGE_LENGTH = 200;

@Component({
    selector: 'app-chatbox',
    imports: [CommonModule, FormsModule],
    templateUrl: './chatbox.component.html',
    styleUrl: './chatbox.component.scss',
})
export class ChatboxComponent implements OnInit, AfterViewInit, OnDestroy {
    @Input() roomType: 'GeneralChat' | 'WaitingRoom' | 'GameRoom' | 'EndRoom' = 'GeneralChat';
    @ViewChild('chatboxMessages') private messagesContainer!: ElementRef<HTMLDivElement>;
    @ViewChild('messageInput') private messageInput!: ElementRef<HTMLInputElement>;

    withFilter: boolean = false;
    isCollapsed: boolean = false;
    newMessage: string = '';

    /** null = général, string = channelId du canal custom actif */
    activeChannelId: string | null = null;
    /** Liste des canaux rejoints (pour le dropdown, visible uniquement en mode GeneralChat) */
    joinedChannelInfos: { id: string; name: string }[] = [];

    private subscriptions = new Subscription();

    constructor(
        private chatService: ChatService,
        private customChannelService: CustomChannelService,
    ) {
        this.scrollToBottom();
    }

    /** Messages à afficher selon le canal actif */
    get displayMessages() {
        if (this.activeChannelId) {
            return this.customChannelService.getMessages(this.activeChannelId);
        }
        return this.chatService.messages;
    }

    /** Libellé affiché dans le sélecteur */
    get activeChannelLabel(): string {
        if (!this.activeChannelId) return 'Général';
        return this.joinedChannelInfos.find((c) => c.id === this.activeChannelId)?.name ?? this.activeChannelId;
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

        // Le sélecteur de canaux n'est disponible qu'en mode GeneralChat
        if (this.roomType === 'GeneralChat') {
            this.joinedChannelInfos = this.customChannelService.getJoinedChannelInfos();

            this.subscriptions.add(
                this.customChannelService.joinedChannels$.subscribe(() => {
                    this.joinedChannelInfos = this.customChannelService.getJoinedChannelInfos();
                    // Si le canal actif a été quitté/supprimé, revenir au général
                    if (this.activeChannelId && !this.joinedChannelInfos.some((c) => c.id === this.activeChannelId)) {
                        this.switchChannel(null);
                    }
                }),
            );

            // Scroll automatique quand de nouveaux messages arrivent sur le canal actif
            this.subscriptions.add(
                this.customChannelService.messagesUpdated$.subscribe(({ channelId }) => {
                    if (this.activeChannelId === channelId) {
                        this.scrollToBottom();
                    }
                }),
            );
        }
    }

    ngAfterViewInit() {
        this.chatService.setScrollHandler(() => this.scrollToBottom());
        this.scrollToBottom();
    }

    ngOnDestroy() {
        this.subscriptions.unsubscribe();
    }

    /** Bascule vers le canal sélectionné (null = général). */
    switchChannel(channelId: string | null): void {
        this.activeChannelId = channelId;
        if (!channelId) {
            // Recharger le général
            this.chatService.clearMessages();
            this.chatService.getGeneralChatMessages();
        } else {
            // S'assurer que l'historique est disponible
            this.customChannelService.fetchMessages(channelId);
        }
        this.scrollToBottom();
    }

    sendMessage() {
        if (this.newMessage.trim() && this.newMessage.length <= MAX_MESSAGE_LENGTH) {
            if (this.activeChannelId && this.roomType === 'GeneralChat') {
                this.customChannelService.sendMessage(this.activeChannelId, this.newMessage);
            } else {
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
            }
            this.newMessage = '';
            this.scrollToBottom();
            this.messageInput?.nativeElement?.focus();
        }
    }

    filterByName() {
        this.withFilter = true;
    }

    resetFilter() {
        this.withFilter = false;
    }

    scrollToBottom() {
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

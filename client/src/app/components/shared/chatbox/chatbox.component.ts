import { CommonModule } from '@angular/common';
import { AfterViewInit, Component, ElementRef, Input, OnDestroy, OnInit, ViewChild } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ACCOUNT_CREATION_AVATARS } from '@app/constants/profile.constants';
import { ChatService } from '@app/services/communication/chat.service';
import { CustomChannelService } from '@app/services/communication/custom-channel.service';
import { WaitingRoomService } from '@app/services/lobby/waiting-room.service';
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

    isCollapsed: boolean = false;
    newMessage: string = '';

    /** null = général, string = channelId du canal custom/partie actif */
    activeChannelId: string | null = null;
    /** Tous les canaux rejoints (custom + partie), pour le dropdown */
    joinedChannelInfos: { id: string; name: string; isGameChannel: boolean }[] = [];

    private subscriptions = new Subscription();

    constructor(
        private chatService: ChatService,
        private customChannelService: CustomChannelService,
        private waitingRoomService: WaitingRoomService,
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

    /** Libellé du canal actif pour le placeholder */
    get activeChannelLabel(): string {
        if (!this.activeChannelId) return 'Général';
        return this.joinedChannelInfos.find((c) => c.id === this.activeChannelId)?.name ?? this.activeChannelId;
    }

    get name() {
        return this.chatService.playerName;
    }

    resolveAvatar(avatarId?: string | null, avatarUrl?: string | null, name?: string | null): string | null {
        if (name === '[supprimé]') return './assets/avatars/account-creation/compte-supprimer.png';
        if (avatarUrl) return avatarUrl;
        if (!avatarId) return null;
        const avatar = ACCOUNT_CREATION_AVATARS.find((a) => a.id === avatarId);
        return avatar ? avatar.image : null;
    }

    ngOnInit() {
        // Charger le chat général
        this.chatService.clearMessages();
        this.chatService.getGeneralChatMessages();

        // Initialiser le dropdown avec les canaux déjà rejoints
        this.joinedChannelInfos = this.customChannelService.getJoinedChannelInfos();

        // Auto-sélectionner le canal de partie s'il est déjà disponible (ex: reconnexion)
        const gameChannelId = this.waitingRoomService.gameChannelId;
        if (gameChannelId && this.customChannelService.isJoined(gameChannelId)) {
            this.activeChannelId = gameChannelId;
            this.customChannelService.fetchMessages(gameChannelId);
        }

        // Mettre à jour le dropdown quand les canaux changent
        this.subscriptions.add(
            this.customChannelService.joinedChannels$.subscribe(() => {
                this.joinedChannelInfos = this.customChannelService.getJoinedChannelInfos();

                // Si le canal actif a disparu, revenir au général
                if (this.activeChannelId && !this.joinedChannelInfos.some((c) => c.id === this.activeChannelId)) {
                    this.switchChannel(null);
                }

                // Auto-sélectionner le canal de partie dès qu'il est rejoint
                const currentGameChannelId = this.waitingRoomService.gameChannelId;
                if (
                    currentGameChannelId &&
                    this.customChannelService.isJoined(currentGameChannelId) &&
                    this.activeChannelId !== currentGameChannelId
                ) {
                    this.activeChannelId = currentGameChannelId;
                    this.customChannelService.fetchMessages(currentGameChannelId);
                }
            }),
        );

        // Scroll automatique sur nouveaux messages du canal actif
        this.subscriptions.add(
            this.customChannelService.messagesUpdated$.subscribe(({ channelId }) => {
                if (channelId === this.activeChannelId) {
                    this.scrollToBottom();
                }
            }),
        );
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
            this.chatService.clearMessages();
            this.chatService.getGeneralChatMessages();
        } else {
            this.customChannelService.fetchMessages(channelId);
        }
        this.scrollToBottom();
    }

    sendMessage() {
        if (this.newMessage.trim() && this.newMessage.length <= MAX_MESSAGE_LENGTH) {
            if (this.activeChannelId) {
                this.customChannelService.sendMessage(this.activeChannelId, this.newMessage);
            } else {
                this.chatService.sendMessageToGeneralChat(this.newMessage);
            }
            this.newMessage = '';
            this.scrollToBottom();
            this.messageInput?.nativeElement?.focus();
        }
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

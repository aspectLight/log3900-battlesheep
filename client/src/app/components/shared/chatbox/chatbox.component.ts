import { CommonModule } from '@angular/common';
import { AfterViewInit, Component, ElementRef, HostBinding, Input, OnChanges, OnDestroy, OnInit, SimpleChanges, ViewChild, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { PopUpComponent } from '@app/components/shared/pop-up/pop-up.component';
import { ACCOUNT_CREATION_AVATARS } from '@app/constants/profile.constants';
import { AuthService } from '@app/services/communication/auth.service';
import { AvatarRegistryService } from '@app/services/communication/avatar-registry.service';
import { ChatService } from '@app/services/communication/chat.service';
import { ChannelInfo, ChannelMessage, CustomChannelService } from '@app/services/communication/custom-channel.service';
import { WaitingRoomService } from '@app/services/lobby/waiting-room.service';
import { isReservedGameChannelName, isReservedGeneralChannelName } from '@common/channel-name.utils';
import { TranslateModule, TranslateService } from '@ngx-translate/core';
import { Subscription } from 'rxjs';
import { environment } from 'src/environments/environment';

const MAX_MESSAGE_LENGTH = 200;

@Component({
    selector: 'app-chatbox',
    imports: [CommonModule, FormsModule, TranslateModule, PopUpComponent],
    templateUrl: './chatbox.component.html',
    styleUrl: './chatbox.component.scss',
})
export class ChatboxComponent implements OnInit, OnChanges, AfterViewInit, OnDestroy {
    @Input() roomType: 'GeneralChat' | 'WaitingRoom' | 'GameRoom' | 'EndRoom' = 'GeneralChat';
    @Input() collapseOnLoad: boolean = false;
    @ViewChild('chatboxMessages') private messagesContainer!: ElementRef<HTMLDivElement>;
    @ViewChild('messageInput') private messageInput!: ElementRef<HTMLInputElement>;

    isCollapsed: boolean = false;
    newMessage: string = '';

    @HostBinding('class.collapsed')
    get isHostCollapsed(): boolean {
        return this.isCollapsed;
    }

    /** null = général, string = channelId du canal custom/partie actif */
    activeChannelId: string | null = null;
    /** Tous les canaux rejoints (custom + partie), pour le dropdown */
    joinedChannelInfos: { id: string; name: string; isGameChannel: boolean }[] = [];

    // ── Canaux de discussion panel ──────────────────────────────────
    showChannelsPanel: boolean = false;

    cp_channels = signal<ChannelInfo[]>([]);
    cp_isLoading = signal(true);
    cp_errorMessage = signal<string | null>(null);
    cp_successMessage = signal<string | null>(null);
    cp_showConfirmation: boolean = false;
    cp_quitMessage = '';
    cp_newChannelName = '';
    cp_filterTerm = '';

    cp_joinedChannels = signal<string[]>([]);
    cp_activeChannelId = signal<string | null>(null);
    cp_channelMessages = signal<ChannelMessage[]>([]);
    cp_activeMessage = '';

    cp_isCreating = false;
    cp_channelToDelete: string | null = null;
    // ───────────────────────────────────────────────────────────────

    private subscriptions = new Subscription();

    constructor(
        private chatService: ChatService,
        private customChannelService: CustomChannelService,
        private waitingRoomService: WaitingRoomService,
        private authService: AuthService,
        private translate: TranslateService,
        private avatarRegistry: AvatarRegistryService,
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
        const activeChannel = this.joinedChannelInfos.find((c) => c.id === this.activeChannelId);
        return activeChannel ? this.cp_getChannelDisplayLabel(activeChannel) : this.activeChannelId;
    }

    get name() {
        return this.chatService.playerName;
    }

    get cp_username(): string {
        return this.customChannelService.username ?? this.authService.currentUser?.displayName ?? 'Utilisateur';
    }

    private toAbsolute(path: string): string {
        if (/^https?:\/\//i.test(path)) return path;
        if (path.startsWith('data:')) return path;
        return `${environment.serverUrl}${path}`;
    }

    resolveAvatar(avatarId?: string | null, avatarUrl?: string | null, name?: string | null): string | null {
        if (name === '[supprimé]') return './assets/avatars/account-creation/compte-supprimer.png';
        if (avatarUrl) return avatarUrl;
        if (!avatarId) return null;
        const avatar = ACCOUNT_CREATION_AVATARS.find((a) => a.id === avatarId);
        return avatar ? avatar.image : null;
    }

    getAvatarFor(msg: { name?: string | null; avatarId?: string | null; avatarUrl?: string | null }): string | null {
        const name = msg?.name;
        if (!name) return null;
        const state = this.avatarRegistry.registrySignal();
        const entry = state[name];
        if (entry) {
            if (entry.deleted) return null;
            const absoluteUrl = entry.avatarUrl ? this.toAbsolute(entry.avatarUrl) : null;
            const fromRegistry = this.resolveAvatar(entry.avatarId, absoluteUrl);
            if (fromRegistry) return fromRegistry;
            return this.resolveAvatar(msg.avatarId, msg.avatarUrl);
        }
        this.avatarRegistry.ensureLoaded([name]);
        return this.resolveAvatar(msg.avatarId, msg.avatarUrl);
    }

    onAvatarImgError(msg: { avatarId?: string | null; avatarUrl?: string | null }): void {
        // Le avatarUrl stocké pointe sur /auth/avatar/:uid ; si l'utilisateur a depuis
        // basculé vers un avatar prédéfini, l'endpoint 400 → on bascule sur l'avatarId.
        if (msg.avatarUrl) {
            msg.avatarUrl = null;
        }
    }

    ngOnInit() {
        // Charger le chat général
        this.chatService.clearMessages();
        this.chatService.getGeneralChatMessages();

        // Initialiser le dropdown avec les canaux déjà rejoints
        this.joinedChannelInfos = this.customChannelService.getJoinedChannelInfos();

        // Auto-sélectionner le canal de partie s'il est déjà disponible (ex: reconnexion)
        const initialGameChannelId = this.cp_getPreferredGameChannelId();
        if (initialGameChannelId && this.customChannelService.isJoined(initialGameChannelId)) {
            this.activeChannelId = initialGameChannelId;
            this.customChannelService.fetchMessages(initialGameChannelId);
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
                const preferredGameChannelId = this.cp_getPreferredGameChannelId();
                if (
                    preferredGameChannelId &&
                    this.customChannelService.isJoined(preferredGameChannelId) &&
                    this.activeChannelId !== preferredGameChannelId
                ) {
                    this.activeChannelId = preferredGameChannelId;
                    this.customChannelService.fetchMessages(preferredGameChannelId);
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

        // ── Panel Canaux ──────────────────────────────────────────────
        const currentIds = this.customChannelService.getJoinedChannelIds();
        if (currentIds.length > 0) {
            this.cp_joinedChannels.set(currentIds);
            this.cp_setActiveChannel(currentIds[0]);
        }

        this.subscriptions.add(
            this.customChannelService.channelsUpdated$.subscribe((list) => {
                this.cp_channels.set(list);
                this.cp_isLoading.set(false);
            }),
        );

        this.subscriptions.add(
            this.customChannelService.channelCreated$.subscribe((data) => {
                this.cp_showSuccess(this.translate.instant('channels.success_created', { name: data.channelName }));
                this.cp_newChannelName = '';
                this.cp_isCreating = false;
            }),
        );

        this.subscriptions.add(
            this.customChannelService.channelDeleted$.subscribe(() => {
                this.cp_showSuccess(this.translate.instant('channels.success_deleted'));
            }),
        );

        this.subscriptions.add(
            this.customChannelService.channelError$.subscribe((msg) => {
                this.cp_showError(msg);
                this.cp_isCreating = false;
            }),
        );

        this.subscriptions.add(
            this.customChannelService.joinedChannels$.subscribe((ids) => {
                this.cp_joinedChannels.set(ids);

                const currentActive = this.cp_activeChannelId();
                if (!currentActive && ids.length > 0) {
                    this.cp_setActiveChannel(ids[0]);
                } else if (currentActive && !ids.includes(currentActive)) {
                    const next = ids[0] ?? null;
                    this.cp_activeChannelId.set(next);
                    this.cp_channelMessages.set(next ? this.customChannelService.getMessages(next) : []);
                }
            }),
        );

        this.subscriptions.add(
            this.customChannelService.messagesUpdated$.subscribe(({ channelId, messages }) => {
                if (this.cp_activeChannelId() === channelId) {
                    this.cp_channelMessages.set(messages);
                }
            }),
        );
        // ─────────────────────────────────────────────────────────────
    }

    ngOnChanges(changes: SimpleChanges): void {
        if (changes['collapseOnLoad']?.currentValue) {
            this.isCollapsed = true;
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

    toggleChannelsPanel() {
        this.showChannelsPanel = !this.showChannelsPanel;
        if (this.showChannelsPanel) {
            this.customChannelService.listChannels();
        }
    }

    // ── Panel Canaux : Création / gestion ────────────────────────

    cp_createChannel(): void {
        const name = this.cp_newChannelName.trim();
        if (!name) {
            this.cp_showError(this.translate.instant('channels.errors.empty_name'));
            return;
        }
        if (name.length > 50) {
            this.cp_showError(this.translate.instant('channels.errors.name_too_long'));
            return;
        }
        if (isReservedGeneralChannelName(name)) {
            this.cp_showError(this.translate.instant('channels.errors.reserved_general'));
            return;
        }
        if (isReservedGameChannelName(name)) {
            this.cp_showError(this.translate.instant('channels.errors.reserved_game'));
            return;
        }
        this.cp_isCreating = true;
        this.cp_errorMessage.set(null);
        this.customChannelService.createChannel(name);
    }

    cp_requestDeleteChannel(channelId: string): void {
        this.cp_channelToDelete = channelId;
        this.cp_quitMessage = this.translate.instant('channels.quit_confirm');
        this.cp_showConfirmation = true;
    }

    cp_confirmDeleteChannel(): void {
        if (this.cp_channelToDelete) {
            this.customChannelService.deleteChannel(this.cp_channelToDelete);
        }
        this.cp_showConfirmation = false;
        this.cp_channelToDelete = null;
    }

    cp_onCancelQuit(): void {
        this.cp_showConfirmation = false;
        this.cp_channelToDelete = null;
    }

    cp_isCreator(channel: ChannelInfo): boolean {
        return channel.creator === this.cp_username;
    }

    cp_filteredChannels(): ChannelInfo[] {
        const term = this.cp_filterTerm.trim().toLowerCase();
        if (!term) return this.cp_channels();
        return this.cp_channels().filter((c) => c.name.toLowerCase().includes(term));
    }

    cp_isJoined(channel: ChannelInfo): boolean {
        return this.customChannelService.isJoined(channel.id);
    }

    cp_joinChannel(channel: ChannelInfo): void {
        this.customChannelService.joinChannel(channel.id);
    }

    cp_leaveChannel(channelId: string): void {
        this.customChannelService.leaveChannel(channelId);
    }

    cp_setActiveChannel(channelId: string): void {
        this.cp_activeChannelId.set(channelId);
        this.cp_channelMessages.set(this.customChannelService.getMessages(channelId));
    }

    cp_leaveActiveChannel(): void {
        const id = this.cp_activeChannelId();
        if (!id) return;
        this.cp_leaveChannel(id);
    }

    cp_getChannelName(channelId: string): string {
        return this.cp_channels().find((c) => c.id === channelId)?.name ?? channelId;
    }

    cp_getChannelDisplayLabel(channel: { id: string; name: string; isGameChannel: boolean }): string {
        if (!channel.isGameChannel) {
            return channel.name;
        }

        const gameId = this.cp_extractGameChannelId(channel);
        return this.translate.instant('chatbox.game_channel', { id: gameId });
    }

    cp_getActiveChannelName(): string {
        const id = this.cp_activeChannelId();
        if (!id) return '';
        return this.cp_getChannelName(id);
    }

    cp_sendMessageToActiveChannel(): void {
        const id = this.cp_activeChannelId();
        const content = this.cp_activeMessage.trim();
        if (!id || !content) return;
        this.customChannelService.sendMessage(id, content);
        this.cp_activeMessage = '';
    }

    private cp_showSuccess(msg: string): void {
        this.cp_successMessage.set(msg);
        setTimeout(() => this.cp_successMessage.set(null), 3000);
    }

    private cp_showError(msg: string): void {
        this.cp_errorMessage.set(msg);
        setTimeout(() => this.cp_errorMessage.set(null), 4000);
    }

    private cp_extractGameChannelId(channel: { id: string; name: string }): string {
        const match = channel.name.match(/^partie\s+(.+)$/i);
        return match?.[1]?.trim() || channel.id;
    }

    private cp_getPreferredGameChannelId(): string | null {
        const fromWaitingRoom = this.waitingRoomService.gameChannelId;
        if (fromWaitingRoom) {
            return fromWaitingRoom;
        }
        return this.joinedChannelInfos.find((c) => c.isGameChannel)?.id ?? null;
    }
}

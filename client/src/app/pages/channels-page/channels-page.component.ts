import { CommonModule } from '@angular/common';
import { Component, OnDestroy, OnInit, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { ACCOUNT_CREATION_AVATARS } from '@app/constants/profile.constants';
import { AuthService } from '@app/services/communication/auth.service';
import { ChannelInfo, ChannelMessage, CustomChannelService } from '@app/services/communication/custom-channel.service';
import { Subscription } from 'rxjs';
import { PopUpComponent } from '@app/components/shared/pop-up/pop-up.component';
import { WARNING_MESSAGES } from '@common/error-messages.constants';
@Component({
    selector: 'app-channels-page',
    templateUrl: './channels-page.component.html',
    styleUrls: ['./channels-page.component.scss'],
    imports: [CommonModule, FormsModule, RouterLink, PopUpComponent],
})
export class ChannelsPageComponent implements OnInit, OnDestroy {
    channels = signal<ChannelInfo[]>([]);
    isLoading = signal(true);
    errorMessage = signal<string | null>(null);
    successMessage = signal<string | null>(null);
    showConfirmation: boolean = false;
    quitMessage = WARNING_MESSAGES.QuitChannel;
    newChannelName = '';
    filterTerm = '';

    // Gestion des canaux rejoints
    joinedChannels = signal<string[]>([]);
    activeChannelId = signal<string | null>(null);
    channelMessages = signal<ChannelMessage[]>([]);
    activeMessage = '';

    isCreating = false;
    channelToDelete: string | null = null;

    private subscriptions = new Subscription();

    constructor(
        private customChannelService: CustomChannelService,
        private authService: AuthService,
    ) {}

    get username(): string {
        return this.authService.currentUser?.displayName ?? 'Utilisateur';
    }

    onCancelQuit(): void {
        this.showConfirmation = false;
        this.channelToDelete = null;
    }

    ngOnInit(): void {
        // Initialiser depuis l'état courant du service (canaux déjà rejoints avant l'ouverture de la page)
        const currentIds = this.customChannelService.getJoinedChannelIds();
        if (currentIds.length > 0) {
            this.joinedChannels.set(currentIds);
            this.setActiveChannel(currentIds[0]);
        }

        this.subscriptions.add(
            this.customChannelService.channelsUpdated$.subscribe((list) => {
                this.channels.set(list);
                this.isLoading.set(false);
            }),
        );

        this.subscriptions.add(
            this.customChannelService.channelCreated$.subscribe((data) => {
                this.showSuccess(`Canal "${data.channelName}" créé avec succès !`);
                this.newChannelName = '';
                this.isCreating = false;
            }),
        );

        this.subscriptions.add(
            this.customChannelService.channelDeleted$.subscribe(() => {
                this.showSuccess('Canal supprimé.');
            }),
        );

        this.subscriptions.add(
            this.customChannelService.channelError$.subscribe((msg) => {
                this.showError(msg);
                this.isCreating = false;
            }),
        );

        this.subscriptions.add(
            this.customChannelService.joinedChannels$.subscribe((ids) => {
                this.joinedChannels.set(ids);

                const currentActive = this.activeChannelId();
                if (!currentActive && ids.length > 0) {
                    this.setActiveChannel(ids[0]);
                } else if (currentActive && !ids.includes(currentActive)) {
                    const next = ids[0] ?? null;
                    this.activeChannelId.set(next);
                    this.channelMessages.set(next ? this.customChannelService.getMessages(next) : []);
                }
            }),
        );

        this.subscriptions.add(
            this.customChannelService.messagesUpdated$.subscribe(({ channelId, messages }) => {
                if (this.activeChannelId() === channelId) {
                    this.channelMessages.set(messages);
                }
            }),
        );

        this.customChannelService.listChannels();
    }

    ngOnDestroy(): void {
        this.subscriptions.unsubscribe();
    }

    // --- Création / gestion de canaux -----------------

    createChannel(): void {
        const name = this.newChannelName.trim();
        if (!name) {
            this.showError('Le nom du canal ne peut pas être vide.');
            return;
        }
        if (name.length > 50) {
            this.showError('Le nom du canal ne peut pas dépasser 50 caractères.');
            return;
        }
        this.isCreating = true;
        this.errorMessage.set(null);
        this.customChannelService.createChannel(name);
    }

    requestDeleteChannel(channelId: string): void {
        this.channelToDelete = channelId;
        this.showConfirmation = true;
    }

    confirmDeleteChannel(): void {
        if (this.channelToDelete) {
            this.customChannelService.deleteChannel(this.channelToDelete);
        }
        this.showConfirmation = false;
        this.channelToDelete = null;
    }

    isCreator(channel: ChannelInfo): boolean {
        return channel.creator === this.username;
    }

    // --- Filtrage / liste ----------------------------

    filteredChannels(): ChannelInfo[] {
        const term = this.filterTerm.trim().toLowerCase();
        if (!term) return this.channels();
        return this.channels().filter((c) => c.name.toLowerCase().includes(term));
    }

    isJoined(channel: ChannelInfo): boolean {
        return this.customChannelService.isJoined(channel.id);
    }

    joinChannel(channel: ChannelInfo): void {
        this.customChannelService.joinChannel(channel.id);
    }

    leaveChannel(channelId: string): void {
        this.customChannelService.leaveChannel(channelId);
    }

    // --- Navigation entre canaux ---------------------

    setActiveChannel(channelId: string): void {
        this.activeChannelId.set(channelId);
        this.channelMessages.set(this.customChannelService.getMessages(channelId));
    }

    leaveActiveChannel(): void {
        const id = this.activeChannelId();
        if (!id) return;
        this.leaveChannel(id);
    }

    getChannelName(channelId: string): string {
        return this.channels().find((c) => c.id === channelId)?.name ?? channelId;
    }

    getActiveChannelName(): string {
        const id = this.activeChannelId();
        if (!id) return '';
        return this.getChannelName(id);
    }

    // --- Chat dans le canal actif --------------------

    sendMessageToActiveChannel(): void {
        const id = this.activeChannelId();
        const content = this.activeMessage.trim();
        if (!id || !content) return;

        this.customChannelService.sendMessage(id, content);
        this.activeMessage = '';
    }

    resolveAvatar(avatarId?: string | null, avatarUrl?: string | null, name?: string | null): string | null {
        if (name === '[supprimé]') return './assets/avatars/account-creation/compte-supprimer.png';
        if (avatarUrl) return avatarUrl;
        if (!avatarId) return null;
        const avatar = ACCOUNT_CREATION_AVATARS.find((a) => a.id === avatarId);
        return avatar ? avatar.image : null;
    }

    // --- Feedback UI ---------------------------------

    private showSuccess(msg: string): void {
        this.successMessage.set(msg);
        setTimeout(() => this.successMessage.set(null), 3000);
    }

    private showError(msg: string): void {
        this.errorMessage.set(msg);
        setTimeout(() => this.errorMessage.set(null), 4000);
    }
}

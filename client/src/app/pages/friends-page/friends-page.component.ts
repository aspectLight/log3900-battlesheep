import { Component, OnDestroy, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { FriendProfile, FriendRequest, SocialService, UserSearchResult } from '@app/services/communication/social.service';
import { Subscription, debounceTime, distinctUntilChanged, Subject } from 'rxjs';
import { ACCOUNT_CREATION_AVATARS } from '@app/constants/profile.constants';
import { environment } from 'src/environments/environment';
import { TranslateModule, TranslateService } from '@ngx-translate/core';

type Tab = 'friends' | 'requests' | 'search' | 'blocked';

@Component({
    selector: 'app-friends-page',
    templateUrl: './friends-page.component.html',
    styleUrls: ['./friends-page.component.scss'],
    imports: [RouterLink, FormsModule, TranslateModule],
})
export class FriendsPageComponent implements OnInit, OnDestroy {
    activeTab: Tab = 'friends';
    friends: FriendProfile[] = [];
    pendingRequests: FriendRequest[] = [];
    sentRequests: FriendRequest[] = [];
    blockedUsers: string[] = [];
    searchResults: UserSearchResult[] = [];
    searchQuery = '';
    isLoading = true;
    errorMessage = '';

    private searchSubject = new Subject<string>();
    private subscriptions: Subscription[] = [];

    constructor(
        private socialService: SocialService,
        private translate: TranslateService,
    ) {}

    async ngOnInit(): Promise<void> {
        this.subscriptions.push(
            this.socialService.friends$.subscribe((friends) => {
                this.friends = friends;
            }),
            this.socialService.pendingRequests$.subscribe((requests) => {
                this.pendingRequests = requests;
            }),
            this.socialService.sentRequests$.subscribe((requests) => {
                this.sentRequests = requests;
            }),
            this.socialService.blockedUsers$.subscribe((users) => {
                this.blockedUsers = users;
            }),
            this.searchSubject.pipe(debounceTime(300), distinctUntilChanged()).subscribe(async (query) => {
                if (query.trim().length === 0) {
                    this.searchResults = [];
                    return;
                }
                try {
                    this.searchResults = await this.socialService.searchUsers(query);
                } catch {
                    this.searchResults = [];
                }
            }),
        );

        try {
            await this.socialService.loadAllSocialData();
        } catch {
            this.errorMessage = this.translate.instant('friends.error_load');
        } finally {
            this.isLoading = false;
        }
    }

    ngOnDestroy(): void {
        this.subscriptions.forEach((s) => s.unsubscribe());
    }

    setTab(tab: Tab): void {
        this.activeTab = tab;
        if (tab === 'search') {
            this.searchResults = [];
            this.searchQuery = '';
        }
    }

    onSearchInput(): void {
        this.searchSubject.next(this.searchQuery);
    }

    getAvatarSrc(avatarId: string, avatarUrl?: string): string {
        if (avatarUrl) {
            return `${environment.serverUrl}${avatarUrl}`;
        }
        const found = ACCOUNT_CREATION_AVATARS.find((a) => a.id === avatarId);
        return found?.image ?? '';
    }

    async sendRequest(username: string): Promise<void> {
        try {
            await this.socialService.sendFriendRequest(username);
            // Remove from search results
            this.searchResults = this.searchResults.filter((u) => u.username !== username);
            this.errorMessage = '';
        } catch (error: unknown) {
            this.errorMessage = (error as { error?: { message?: string } })?.error?.message ?? this.translate.instant('friends.error_send');
        }
    }

    async acceptRequest(requestId: string): Promise<void> {
        try {
            await this.socialService.acceptFriendRequest(requestId);
            this.errorMessage = '';
        } catch {
            this.errorMessage = this.translate.instant('friends.error_accept');
        }
    }

    async refuseRequest(requestId: string): Promise<void> {
        try {
            await this.socialService.refuseFriendRequest(requestId);
            this.errorMessage = '';
        } catch {
            this.errorMessage = this.translate.instant('friends.error_refuse');
        }
    }

    async cancelRequest(requestId: string): Promise<void> {
        try {
            await this.socialService.cancelFriendRequest(requestId);
            this.errorMessage = '';
        } catch {
            this.errorMessage = this.translate.instant('friends.error_cancel');
        }
    }

    async removeFriend(username: string): Promise<void> {
        try {
            await this.socialService.removeFriend(username);
            this.errorMessage = '';
        } catch {
            this.errorMessage = this.translate.instant('friends.error_remove');
        }
    }

    async blockUser(username: string): Promise<void> {
        try {
            await this.socialService.blockUser(username);
            this.errorMessage = '';
        } catch {
            this.errorMessage = this.translate.instant('friends.error_block');
        }
    }

    async unblockUser(username: string): Promise<void> {
        try {
            await this.socialService.unblockUser(username);
            this.errorMessage = '';
        } catch {
            this.errorMessage = this.translate.instant('friends.error_unblock');
        }
    }

    async cancelRequestByUsername(username: string): Promise<void> {
        const request = this.sentRequests.find((r) => r.receiverId === username);
        if (request) {
            await this.cancelRequest(request._id);
        }
    }

    hasPendingRequestTo(username: string): boolean {
        return this.sentRequests.some((r) => r.receiverId === username);
    }

    isBlocked(username: string): boolean {
        return this.blockedUsers.includes(username);
    }

    async blockUserFromSearch(username: string): Promise<void> {
        try {
            await this.socialService.blockUser(username);
            this.searchResults = this.searchResults.filter((u) => u.username !== username);
            this.errorMessage = '';
        } catch {
            this.errorMessage = this.translate.instant('friends.error_block');
        }
    }

    get pendingCount(): number {
        return this.pendingRequests.length;
    }
}

import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Auth } from '@angular/fire/auth';
import { SessionService } from '@app/services/state/session.service';
import { SocketService } from '@app/services/communication/socket-handlers/socket.service';
import { GeneralChatEvents, SocialEvents } from '@common/socket.constants';
import { BehaviorSubject } from 'rxjs';
import { environment } from 'src/environments/environment';
import { firstValueFrom } from 'rxjs';

export interface FriendProfile {
    username: string;
    avatarId: string;
    avatarUrl?: string;
    isOnline: boolean;
}

export interface FriendRequest {
    _id: string;
    senderId: string;
    receiverId: string;
    status: string;
    createdAt: string;
}

export interface UserSearchResult {
    username: string;
    avatarId: string;
    avatarUrl?: string;
    isOnline: boolean;
}

@Injectable({ providedIn: 'root' })
export class SocialService {
    private apiUrl = `${environment.serverUrl}/social`;

    friends$ = new BehaviorSubject<FriendProfile[]>([]);
    pendingRequests$ = new BehaviorSubject<FriendRequest[]>([]);
    sentRequests$ = new BehaviorSubject<FriendRequest[]>([]);
    blockedUsers$ = new BehaviorSubject<string[]>([]);
    usersWhoBlockedMe$ = new BehaviorSubject<string[]>([]);

    constructor(
        private http: HttpClient,
        private auth: Auth,
        private session: SessionService,
        private socketService: SocketService,
    ) {
        this.setupListeners();
    }

    setupListeners(): void {
        this.socketService.on<FriendProfile[]>(SocialEvents.FriendsListResponse, (friends) => {
            this.friends$.next(friends);
        });

        this.socketService.on<FriendRequest[]>(SocialEvents.PendingRequestsResponse, (requests) => {
            this.pendingRequests$.next(requests);
        });

        this.socketService.on<string[]>(SocialEvents.BlockedUsersResponse, (users) => {
            this.blockedUsers$.next(users);
        });

        this.socketService.on<{ requestId: string; senderId: string }>(SocialEvents.FriendRequestReceived, () => {
            this.loadPendingRequests();
        });

        this.socketService.on<{ friendUsername: string }>(SocialEvents.FriendRequestAccepted, () => {
            this.loadFriends();
            this.loadSentRequests();
        });

        this.socketService.on<{ receiverUsername: string }>(SocialEvents.FriendRequestRefused, () => {
            this.loadSentRequests();
        });

        this.socketService.on<{ senderUsername: string }>(SocialEvents.FriendRequestCanceled, () => {
            this.loadPendingRequests();
        });

        this.socketService.on<{ friendUsername: string }>(SocialEvents.FriendRemoved, () => {
            this.loadFriends();
        });

        this.socketService.on<{ blockedUsername?: string; blockerUsername?: string }>(SocialEvents.UserBlocked, (data) => {
            if (data.blockerUsername) {
                const current = this.usersWhoBlockedMe$.value;
                if (!current.includes(data.blockerUsername)) {
                    this.usersWhoBlockedMe$.next([...current, data.blockerUsername]);
                }
            }
        });

        this.socketService.on<{ unblockedUsername?: string; unblockerUsername?: string }>(SocialEvents.UserUnblocked, (data) => {
            if (data.unblockerUsername) {
                this.usersWhoBlockedMe$.next(this.usersWhoBlockedMe$.value.filter((u) => u !== data.unblockerUsername));
            }
        });

        this.socketService.on<string[]>(SocialEvents.UsersWhoBlockedMeResponse, (users) => {
            this.usersWhoBlockedMe$.next(users);
        });

        this.socketService.on<{ username: string }>(SocialEvents.FriendOnline, (data) => {
            this.updateFriendPresence(data.username, true);
        });

        this.socketService.on<{ username: string }>(SocialEvents.FriendOffline, (data) => {
            this.updateFriendPresence(data.username, false);
        });

        this.socketService.on<{ username: string; avatarId: string | null; avatarUrl: string | null }>(
            GeneralChatEvents.AvatarUpdated,
            (payload) => {
                if (!payload?.username) return;
                this.updateFriendAvatar(payload.username, payload.avatarId, payload.avatarUrl);
            },
        );

        this.socketService.on<{ oldUsername: string; newUsername: string }>(GeneralChatEvents.UsernameUpdated, (payload) => {
            if (!payload?.oldUsername || !payload?.newUsername || payload.oldUsername === payload.newUsername) return;
            const friends = this.friends$.value.map((f) =>
                f.username === payload.oldUsername ? { ...f, username: payload.newUsername } : f,
            );
            this.friends$.next(friends);
        });
    }

    async loadFriends(): Promise<void> {
        const headers = await this.getAuthHeaders();
        const friends = await firstValueFrom(this.http.get<FriendProfile[]>(`${this.apiUrl}/friends`, { headers }));
        this.friends$.next(friends);
    }

    async loadPendingRequests(): Promise<void> {
        const headers = await this.getAuthHeaders();
        const requests = await firstValueFrom(this.http.get<FriendRequest[]>(`${this.apiUrl}/requests/pending`, { headers }));
        this.pendingRequests$.next(requests);
    }

    async loadSentRequests(): Promise<void> {
        const headers = await this.getAuthHeaders();
        const requests = await firstValueFrom(this.http.get<FriendRequest[]>(`${this.apiUrl}/requests/sent`, { headers }));
        this.sentRequests$.next(requests);
    }

    async loadBlockedUsers(): Promise<void> {
        const headers = await this.getAuthHeaders();
        const users = await firstValueFrom(this.http.get<string[]>(`${this.apiUrl}/blocked`, { headers }));
        this.blockedUsers$.next(users);
    }

    async loadUsersWhoBlockedMe(): Promise<void> {
        const headers = await this.getAuthHeaders();
        const users = await firstValueFrom(this.http.get<string[]>(`${this.apiUrl}/blocked-by`, { headers }));
        this.usersWhoBlockedMe$.next(users);
    }

    async searchUsers(query: string): Promise<UserSearchResult[]> {
        if (!query || query.trim().length === 0) return [];
        const headers = await this.getAuthHeaders();
        return firstValueFrom(this.http.get<UserSearchResult[]>(`${this.apiUrl}/search`, { headers, params: { q: query } }));
    }

    async sendFriendRequest(targetUsername: string): Promise<void> {
        const headers = await this.getAuthHeaders();
        await firstValueFrom(this.http.post(`${this.apiUrl}/requests`, { targetUsername }, { headers }));
        await this.loadSentRequests();
    }

    async acceptFriendRequest(requestId: string): Promise<void> {
        const headers = await this.getAuthHeaders();
        await firstValueFrom(this.http.patch(`${this.apiUrl}/requests/${requestId}/accept`, {}, { headers }));
        await Promise.all([this.loadFriends(), this.loadPendingRequests()]);
    }

    async refuseFriendRequest(requestId: string): Promise<void> {
        const headers = await this.getAuthHeaders();
        await firstValueFrom(this.http.patch(`${this.apiUrl}/requests/${requestId}/refuse`, {}, { headers }));
        await this.loadPendingRequests();
    }

    async cancelFriendRequest(requestId: string): Promise<void> {
        const headers = await this.getAuthHeaders();
        await firstValueFrom(this.http.delete(`${this.apiUrl}/requests/${requestId}`, { headers }));
        await this.loadSentRequests();
    }

    async removeFriend(username: string): Promise<void> {
        const headers = await this.getAuthHeaders();
        await firstValueFrom(this.http.delete(`${this.apiUrl}/friends/${username}`, { headers }));
        await this.loadFriends();
    }

    async blockUser(targetUsername: string): Promise<void> {
        const headers = await this.getAuthHeaders();
        await firstValueFrom(this.http.post(`${this.apiUrl}/block`, { targetUsername }, { headers }));
        await Promise.all([this.loadBlockedUsers(), this.loadFriends()]);
    }

    async unblockUser(username: string): Promise<void> {
        const headers = await this.getAuthHeaders();
        await firstValueFrom(this.http.delete(`${this.apiUrl}/block/${username}`, { headers }));
        await this.loadBlockedUsers();
    }

    isBlocked(username: string): boolean {
        return this.blockedUsers$.value.includes(username);
    }

    isInBlockRelationship(username: string): boolean {
        return this.blockedUsers$.value.includes(username) || this.usersWhoBlockedMe$.value.includes(username);
    }

    async loadAllSocialData(): Promise<void> {
        await Promise.all([this.loadFriends(), this.loadPendingRequests(), this.loadSentRequests(), this.loadBlockedUsers(), this.loadUsersWhoBlockedMe()]);
    }

    private updateFriendPresence(username: string, isOnline: boolean): void {
        const friends = this.friends$.value.map((f) => (f.username === username ? { ...f, isOnline } : f));
        this.friends$.next(friends);
    }

    private updateFriendAvatar(username: string, avatarId: string | null, avatarUrl: string | null): void {
        const friends = this.friends$.value.map((f) =>
            f.username === username ? { ...f, avatarId: avatarId ?? f.avatarId, avatarUrl: avatarUrl ?? undefined } : f,
        );
        this.friends$.next(friends);
    }

    private async getAuthHeaders(): Promise<HttpHeaders> {
        const user = this.auth.currentUser;
        const sessionId = this.session.sessionId;

        if (!user || !sessionId) {
            throw new Error('Utilisateur non authentifié');
        }

        const token = await user.getIdToken();
        return new HttpHeaders().set('Authorization', `Bearer ${token}`).set('x-session-id', sessionId);
    }
}

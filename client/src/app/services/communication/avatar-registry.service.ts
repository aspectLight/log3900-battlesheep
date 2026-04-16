import { HttpClient } from '@angular/common/http';
import { Injectable, signal } from '@angular/core';
import { SocketService } from '@app/services/communication/socket-handlers/socket.service';
import { GeneralChatEvents } from '@common/socket.constants';
import { firstValueFrom } from 'rxjs';
import { environment } from 'src/environments/environment';

export interface AvatarEntry {
    avatarId: string | null;
    avatarUrl: string | null;
    deleted: boolean;
}

@Injectable({ providedIn: 'root' })
export class AvatarRegistryService {
    private registry = signal<Record<string, AvatarEntry>>({});
    private pendingFetch = new Set<string>();
    private queuedForBatch = new Set<string>();
    private batchScheduled = false;

    constructor(
        private http: HttpClient,
        private socketService: SocketService,
    ) {}

    readonly registrySignal = this.registry.asReadonly();

    setupListeners(): void {
        this.socketService.on<{ username: string; avatarId: string | null; avatarUrl: string | null }>(
            GeneralChatEvents.AvatarUpdated,
            (payload) => {
                if (!payload?.username) return;
                this.registry.update((current) => ({
                    ...current,
                    [payload.username]: {
                        avatarId: payload.avatarId ?? null,
                        avatarUrl: payload.avatarUrl ?? null,
                        deleted: false,
                    },
                }));
            },
        );
    }

    get(username: string | null | undefined): AvatarEntry | null {
        if (!username) return null;
        return this.registry()[username] ?? null;
    }

    setLocal(username: string, entry: { avatarId: string | null; avatarUrl: string | null }): void {
        this.registry.update((current) => ({
            ...current,
            [username]: { avatarId: entry.avatarId, avatarUrl: entry.avatarUrl, deleted: false },
        }));
    }

    ensureLoaded(usernames: (string | null | undefined)[]): void {
        const current = this.registry();
        for (const u of usernames) {
            if (!u) continue;
            if (u in current) continue;
            if (this.pendingFetch.has(u)) continue;
            this.queuedForBatch.add(u);
        }
        if (this.queuedForBatch.size === 0 || this.batchScheduled) return;
        this.batchScheduled = true;
        queueMicrotask(() => this.flushBatch());
    }

    private async flushBatch(): Promise<void> {
        this.batchScheduled = false;
        const batch = [...this.queuedForBatch];
        this.queuedForBatch.clear();
        if (batch.length === 0) return;
        batch.forEach((u) => this.pendingFetch.add(u));
        try {
            const entries = await firstValueFrom(
                this.http.post<{ username: string; avatarId: string | null; avatarUrl: string | null; deleted: boolean }[]>(
                    `${environment.serverUrl}/auth/avatars/batch`,
                    { usernames: batch },
                ),
            );
            this.registry.update((state) => {
                const next = { ...state };
                for (const entry of entries) {
                    next[entry.username] = {
                        avatarId: entry.avatarId ?? null,
                        avatarUrl: entry.avatarUrl ?? null,
                        deleted: !!entry.deleted,
                    };
                }
                return next;
            });
        } catch {
            this.registry.update((state) => {
                const next = { ...state };
                for (const u of batch) {
                    if (!(u in next)) next[u] = { avatarId: null, avatarUrl: null, deleted: false };
                }
                return next;
            });
        } finally {
            batch.forEach((u) => this.pendingFetch.delete(u));
        }
    }
}

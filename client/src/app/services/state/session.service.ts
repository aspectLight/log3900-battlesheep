import { Injectable } from '@angular/core';

const KEY = 'sessionId';

@Injectable({ providedIn: 'root' })
export class SessionService {
    get sessionId(): string | null {
        return localStorage.getItem(KEY);
    }

    set sessionId(value: string | null) {
        if (!value) localStorage.removeItem(KEY);
        else localStorage.setItem(KEY, value);
    }

    clear() {
        this.sessionId = null;
    }
}

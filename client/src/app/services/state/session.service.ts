import { Injectable } from '@angular/core';

const KEY = 'sessionId';

@Injectable({ providedIn: 'root' })
export class SessionService {
    get sessionId(): string | null {
        return sessionStorage.getItem(KEY);
    }

    set sessionId(value: string | null) {
        if (!value) sessionStorage.removeItem(KEY);
        else sessionStorage.setItem(KEY, value);
    }

    clear() {
        this.sessionId = null;
    }
}

/* eslint-disable @typescript-eslint/member-ordering */
import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';

export type ThemeType = 'default' | 'neon' | 'light';

@Injectable({
    providedIn: 'root',
})
export class ThemeService {
    private readonly themeSubject = new BehaviorSubject<ThemeType>('neon');
    readonly theme$: Observable<ThemeType> = this.themeSubject.asObservable();

    constructor() {
        this.initTheme();
    }

    setTheme(theme: ThemeType): void {
        this.themeSubject.next(theme);
    }

    getCurrentTheme(): ThemeType {
        return this.themeSubject.value;
    }

    private initTheme(): void {
        this.themeSubject.next('default');
    }
}

/* eslint-disable @typescript-eslint/member-ordering */
import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';

export type ThemeType = 'default' | 'frost' | 'village';

const VALID_THEMES: ThemeType[] = ['default', 'frost', 'village'];

@Injectable({
    providedIn: 'root',
})
export class ThemeService {
    private readonly themeSubject = new BehaviorSubject<ThemeType>('default');
    readonly theme$: Observable<ThemeType> = this.themeSubject.asObservable();

    setTheme(theme: ThemeType): void {
        const body = document.body;
        VALID_THEMES.forEach((t) => body.classList.remove(`theme-${t}`));
        body.classList.add(`theme-${theme}`);
        this.themeSubject.next(theme);
    }

    getCurrentTheme(): ThemeType {
        return this.themeSubject.value;
    }

    /** Applique le thème venant du profil (avec fallback sur 'default') */
    applyFromProfile(theme: string | undefined): void {
        const safe = VALID_THEMES.includes(theme as ThemeType) ? (theme as ThemeType) : 'default';
        this.setTheme(safe);
    }
}

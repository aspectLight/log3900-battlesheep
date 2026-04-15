import { Injectable } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';
import { BehaviorSubject, Observable } from 'rxjs';

export type LanguageType = 'fr' | 'en';

const VALID_LANGUAGES: LanguageType[] = ['fr', 'en'];
const STORAGE_KEY = 'preferred-language';

@Injectable({
    providedIn: 'root',
})
export class LanguageService {
    private readonly langSubject = new BehaviorSubject<LanguageType>('fr');
    readonly lang$: Observable<LanguageType> = this.langSubject.asObservable();

    constructor(private translate: TranslateService) {
        // Initialise à partir du localStorage dès le démarrage (pré-auth)
        const saved = localStorage.getItem(STORAGE_KEY) as LanguageType | null;
        const initial: LanguageType = saved && VALID_LANGUAGES.includes(saved) ? saved : 'fr';
        this.apply(initial);
    }

    /** Change la langue immédiatement et persiste dans localStorage (pré-auth). */
    setLanguage(lang: LanguageType): void {
        localStorage.setItem(STORAGE_KEY, lang);
        this.apply(lang);
    }

    /** Applique la langue provenant du profil utilisateur (post-login). */
    applyFromProfile(lang: string | undefined): void {
        const safe: LanguageType = VALID_LANGUAGES.includes(lang as LanguageType) ? (lang as LanguageType) : 'fr';
        localStorage.setItem(STORAGE_KEY, safe);
        this.apply(safe);
    }

    /**
     * Réinitialise vers la langue gardée dans localStorage.
     * Appelé à la déconnexion : préserve le choix pré-auth sans tout effacer.
     */
    resetToDefault(): void {
        const saved = localStorage.getItem(STORAGE_KEY) as LanguageType | null;
        const lang: LanguageType = saved && VALID_LANGUAGES.includes(saved) ? saved : 'fr';
        this.apply(lang);
    }

    getCurrentLanguage(): LanguageType {
        return this.langSubject.value;
    }

    private apply(lang: LanguageType): void {
        this.translate.use(lang);
        this.langSubject.next(lang);
        const electron = (window as unknown as { electron?: { setLanguage?: (lang: string) => void } }).electron;
        electron?.setLanguage?.(lang);
    }
}

/* eslint-disable max-params */
import { Component, ElementRef, HostListener, OnInit, ViewChild, inject } from '@angular/core';
import { Auth, signOut } from '@angular/fire/auth';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { PopUpComponent } from '@app/components/shared/pop-up/pop-up.component';
import { ACCOUNT_CREATION_AVATARS } from '@app/constants/profile.constants';
import { ROUTES } from '@app/constants/routes.constants';
import { UserProfile, UserStatistics } from '@app/interfaces/profile.interface';
import { CameraCaptureService } from '@app/services/communication/camera-capture.service';
import { ProfileService } from '@app/services/communication/profile.service';
import { SocketService } from '@app/services/communication/socket-handlers/socket.service';
import { StatsService } from '@app/services/communication/stats.service';
import { VirtualCurrencyService } from '@app/services/currency/virtual-currency.service';
import { LanguageService, LanguageType } from '@app/services/state/language.service';
import { SessionService } from '@app/services/state/session.service';
import { ThemeService, ThemeType } from '@app/services/state/theme.service';
import { EXCLUSIVE_AVATAR_IDS } from '@common/shop.constants';
import { TranslateModule, TranslateService } from '@ngx-translate/core';
import { environment } from 'src/environments/environment';

@Component({
    selector: 'app-profile-page',
    templateUrl: './profile-page.component.html',
    styleUrls: ['./profile-page.component.scss'],
    imports: [ReactiveFormsModule, RouterLink, PopUpComponent, TranslateModule],
})
export class ProfilePageComponent implements OnInit {
    @ViewChild('cameraVideo') cameraVideoRef!: ElementRef<HTMLVideoElement>;
    @ViewChild('cameraCanvas') cameraCanvasRef!: ElementRef<HTMLCanvasElement>;
    @ViewChild('fileInput') fileInputRef!: ElementRef<HTMLInputElement>;

    showAvatarMenu = false;

    avatars = ACCOUNT_CREATION_AVATARS;

    profile: UserProfile | null = null;
    statistics: UserStatistics | null = null;
    isLoading = true;
    isSaving = false;
    isDeleting = false;
    showSuccessMessage = false;
    showErrorMessage = false;
    showDeleteConfirm = false;
    errorMessage = '';

    readonly themes: { value: ThemeType; labelKey: string; description: string; preview: string }[] = [
        { value: 'default', labelKey: 'profile.theme_default', description: 'Rouge sombre', preview: './assets/ui/default_preview.png' },
        { value: 'frost', labelKey: 'profile.theme_frost', description: 'Bleu glacial', preview: './assets/ui/froid_preview.png' },
        { value: 'village', labelKey: 'profile.theme_village', description: 'Brun terreux', preview: './assets/ui/village_preview.png' },
    ];

    readonly languages: { value: LanguageType; labelKey: string }[] = [
        { value: 'fr', labelKey: 'language.fr' },
        { value: 'en', labelKey: 'language.en' },
    ];

    selectedAvatarFile: File | null = null;
    avatarFileError: string | null = null;
    avatarPreviewUrl: string | null = null;

    form = inject(FormBuilder).nonNullable.group({
        username: ['', [Validators.required, Validators.pattern(/^[a-zA-Z0-9]+$/)]],
        email: ['', [Validators.required, Validators.email, Validators.pattern(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/)]],
        avatarId: [''],
    });

    camera = inject(CameraCaptureService);

    private profileService = inject(ProfileService);
    private statsService = inject(StatsService);
    private socketService = inject(SocketService);
    private session = inject(SessionService);
    private currencyService = inject(VirtualCurrencyService);
    private auth = inject(Auth);
    private router = inject(Router);
    themeService = inject(ThemeService);
    languageService = inject(LanguageService);
    private translate = inject(TranslateService);

    get selectedAvatarId(): string {
        return this.form.controls.avatarId.value ?? '';
    }

    get currentAvatarSrc(): string {
        if (this.profile?.avatarUrl) {
            return `${environment.serverUrl}${this.profile.avatarUrl}`;
        }
        const found = this.avatars.find((a) => a.id === this.profile?.avatarId);
        return found?.image ?? '';
    }

    @HostListener('document:click', ['$event.target'])
    onDocumentClick(target: EventTarget | null) {
        const picker = document.querySelector('.avatar-source-picker');
        if (picker && target instanceof Node && !picker.contains(target)) {
            this.showAvatarMenu = false;
        }
    }

    onAvatarFileSelected(event: Event) {
        const input = event.target as HTMLInputElement;
        const file = input.files?.[0] ?? null;
        this.avatarFileError = null;
        this.selectedAvatarFile = null;
        this.avatarPreviewUrl = null;

        if (!file) return;

        const maxSize = 2 * 1024 * 1024;
        const validTypes = ['image/jpeg', 'image/png'];

        if (!validTypes.includes(file.type)) {
            const extension = file.name.split('.').pop()?.toLowerCase() ?? '?';
            this.avatarFileError = this.translate.instant('profile.error_file_type', { ext: extension });
            return;
        }

        if (file.size > maxSize) {
            const sizeMb = file.size / (1024 * 1024);
            this.avatarFileError = this.translate.instant('profile.error_file_size', { size: sizeMb.toFixed(2) });
            return;
        }

        this.selectedAvatarFile = file;
        this.form.controls.avatarId.setValue('');

        const reader = new FileReader();
        reader.onload = (e) => {
            this.avatarPreviewUrl = e.target?.result as string;
        };
        reader.readAsDataURL(file);
    }

    async ngOnInit() {
        this.currencyService.fetchCatalogue();
        await this.loadProfile();
    }

    async loadProfile() {
        try {
            const { profile, statistics } = await this.profileService.loadProfileAndStatistics();
            this.profile = profile;
            this.statistics = statistics;
            this.form.patchValue({
                username: profile.username,
                email: profile.email,
                avatarId: profile.avatarId,
            });
            if (profile.avatarUrl) {
                this.avatarPreviewUrl = `${environment.serverUrl}${profile.avatarUrl}?t=${Date.now()}`;
                this.form.controls.avatarId.setValue('');
            }
        } catch (error) {
            this.showError(this.resolveErrorMessage(this.profileService.getDefaultErrorMessage()));
        } finally {
            this.isLoading = false;
        }
    }

    isPremiumLocked(avatarId: string): boolean {
        if (!EXCLUSIVE_AVATAR_IDS.includes(avatarId)) return false;
        return !this.currencyService.hasPurchased(avatarId);
    }

    selectAvatar(id: string) {
        if (this.isPremiumLocked(id)) return;
        this.selectedAvatarFile = null;
        this.avatarPreviewUrl = null;
        this.avatarFileError = null;
        this.form.controls.avatarId.setValue(id);
        this.form.controls.avatarId.markAsTouched();
    }

    async selectTheme(theme: ThemeType) {
        if (!this.profile) return;
        // Applique immédiatement (retour visuel instantané)
        this.themeService.setTheme(theme);
        // Sauvegarde sur le backend (lié au compte)
        try {
            const updated = await this.profileService.updateProfile({ theme });
            this.profile = updated;
        } catch {
            // En cas d'erreur réseau, le changement visuel reste appliqué localement
        }
    }

    async selectLanguage(language: LanguageType) {
        // Applique immédiatement
        this.languageService.setLanguage(language);
        // Sauvegarde sur le backend si connecté
        if (!this.profile) return;
        try {
            const updated = await this.profileService.updateProfile({ language });
            this.profile = updated;
        } catch {
            // En cas d'erreur réseau, le changement reste appliqué localement
        }
    }

    async submitForm() {
        this.form.markAllAsTouched();

        const hasAvatarSelected = !!this.form.controls.avatarId.value || !!this.selectedAvatarFile || !!this.profile?.avatarUrl;
        if (this.form.invalid || !this.profile || !hasAvatarSelected) {
            return;
        }

        this.isSaving = true;
        this.showErrorMessage = false;
        this.showSuccessMessage = false;

        const formValues = this.form.getRawValue();

        const updatePayload = this.profileService.buildUpdatePayload(this.profile, formValues);
        const hasProfileChanges = Object.keys(updatePayload).length > 0;
        const hasAvatarFile = !!this.selectedAvatarFile;

        if (!hasProfileChanges && !hasAvatarFile) {
            this.showError(this.translate.instant('profile.no_changes'));
            this.isSaving = false;
            return;
        }

        try {
            if (hasProfileChanges) {
                const updatedProfile = await this.profileService.updateProfile(updatePayload);
                this.profile = updatedProfile;
                if (!updatedProfile.avatarUrl) {
                    this.avatarPreviewUrl = null;
                }
            }

            if (hasAvatarFile && this.selectedAvatarFile) {
                const updatedProfileWithAvatar = await this.profileService.uploadAvatar(this.selectedAvatarFile);
                this.profile = updatedProfileWithAvatar;
                this.selectedAvatarFile = null;
                this.form.controls.avatarId.setValue('');
                if (updatedProfileWithAvatar.avatarUrl) {
                    this.avatarPreviewUrl = `${environment.serverUrl}${updatedProfileWithAvatar.avatarUrl}?t=${Date.now()}`;
                }
            }

            this.showSuccessMessage = true;
            setTimeout(() => {
                this.showSuccessMessage = false;
            }, 3000);
        } catch (error: unknown) {
            this.showError(this.resolveErrorMessage(this.profileService.extractErrorMessage(error)));
        } finally {
            this.isSaving = false;
        }
    }

    triggerFileInput() {
        this.showAvatarMenu = false;
        this.fileInputRef?.nativeElement.click();
    }

    async openCamera() {
        this.showAvatarMenu = false;
        this.camera.reset();
        this.camera.showCameraModal = true;

        await this.camera.startStream();

        if (!this.camera.cameraError) {
            setTimeout(() => this.camera.attachStream(this.cameraVideoRef), 0);
        }
    }

    capturePhoto() {
        this.camera.capturePhoto(this.cameraVideoRef, this.cameraCanvasRef);
    }

    async retakePhoto() {
        this.camera.stopStream(this.cameraVideoRef);
        this.camera.capturedImageDataUrl = null;
        await this.camera.startStream();
        if (!this.camera.cameraError) {
            setTimeout(() => this.camera.attachStream(this.cameraVideoRef), 0);
        }
    }

    useCapturedPhoto() {
        if (!this.camera.capturedImageDataUrl) return;

        this.selectedAvatarFile = this.camera.dataUrlToFile(this.camera.capturedImageDataUrl);
        this.avatarPreviewUrl = this.camera.capturedImageDataUrl;
        this.avatarFileError = null;
        this.form.controls.avatarId.setValue('');

        this.camera.closeCamera(this.cameraVideoRef);
    }

    closeCamera() {
        this.camera.closeCamera(this.cameraVideoRef);
    }

    showError(message: string) {
        this.errorMessage = message;
        this.showErrorMessage = true;
    }

    onErrorConfirm() {
        this.showErrorMessage = false;
    }

    onSuccessConfirm() {
        this.showSuccessMessage = false;
        window.location.reload();
    }

    formatTime(seconds: number): string {
        return this.statsService.formatTime(seconds);
    }

    deleteAccount() {
        this.showDeleteConfirm = true;
    }

    onDeleteCancel() {
        this.showDeleteConfirm = false;
    }

    async onDeleteConfirm() {
        this.showDeleteConfirm = false;
        this.isDeleting = true;
        this.showErrorMessage = false;

        const result = await this.profileService.deleteAccount();

        if (result.success) {
            this.socketService.disconnect();
            this.session.clear();
            await signOut(this.auth);
            this.router.navigate([ROUTES.signin]);
        } else if (result.error) {
            this.showError(this.resolveErrorMessage(result.error));
        }

        this.isDeleting = false;
    }

    private resolveErrorMessage(messageOrKey: string): string {
        const translated = this.translate.instant(messageOrKey);
        return translated !== messageOrKey ? translated : messageOrKey;
    }
}

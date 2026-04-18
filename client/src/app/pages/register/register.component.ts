import { HttpErrorResponse } from '@angular/common/http';
import { Component, ElementRef, HostListener, ViewChild } from '@angular/core';
import { AbstractControl, FormBuilder, ReactiveFormsModule, ValidationErrors, ValidatorFn, Validators } from '@angular/forms';
import { bannedUsernameValidator } from '@app/validators/username.validators';
import { Router, RouterLink } from '@angular/router';
import { PopUpComponent } from '@app/components/shared/pop-up/pop-up.component';
import { ACCOUNT_CREATION_AVATARS } from '@app/constants/profile.constants';
import { EXCLUSIVE_AVATAR_IDS } from '@common/shop.constants';
import { CameraCaptureService } from '@app/services/communication/camera-capture.service';
import { AuthService } from '@app/services/communication/auth.service';
import { ProfileService } from '@app/services/communication/profile.service';
import { TranslateModule, TranslateService } from '@ngx-translate/core';
import { LanguageService, LanguageType } from '@app/services/state/language.service';

const passwordContainsLetter: ValidatorFn = (control: AbstractControl): ValidationErrors | null => {
    return /[a-zA-Z]/.test(control.value) ? null : { noLetter: true };
};

const passwordContainsDigit: ValidatorFn = (control: AbstractControl): ValidationErrors | null => {
    return /[0-9]/.test(control.value) ? null : { noDigit: true };
};

const passwordNoSpaces: ValidatorFn = (control: AbstractControl): ValidationErrors | null => {
    return /^\S*$/.test(control.value) ? null : { hasSpaces: true };
};

const passwordMatchValidator: ValidatorFn = (group: AbstractControl): ValidationErrors | null => {
    const password = group.get('password')?.value;
    const confirmPassword = group.get('confirmPassword')?.value;
    return password === confirmPassword ? null : { passwordMismatch: true };
};

@Component({
    selector: 'app-signup-page',
    standalone: true,
    imports: [ReactiveFormsModule, RouterLink, PopUpComponent, TranslateModule],
    templateUrl: './register.component.html',
    styleUrl: './register.component.scss',
})
export class RegisterPageComponent {
    @ViewChild('cameraVideo') cameraVideoRef!: ElementRef<HTMLVideoElement>;
    @ViewChild('cameraCanvas') cameraCanvasRef!: ElementRef<HTMLCanvasElement>;
    @ViewChild('fileInput') fileInputRef!: ElementRef<HTMLInputElement>;

    errorMessage: string | null = null;
    isSubmitting = false;
    showPassword = false;
    showConfirmPassword = false;
    showAvatarMenu = false;

    avatars = ACCOUNT_CREATION_AVATARS.filter(a => !EXCLUSIVE_AVATAR_IDS.includes(a.id));

    selectedAvatarFile: File | null = null;
    avatarFileError: string | null = null;
    avatarPreviewUrl: string | null = null;

    form = this.fb.nonNullable.group(
        {
            username: ['', [Validators.required, Validators.minLength(3), Validators.maxLength(15), Validators.pattern(/^[a-zA-Z0-9]+$/), bannedUsernameValidator]],
            email: ['', [Validators.required, Validators.email, Validators.pattern(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/)]],
            password: ['', [Validators.required, Validators.minLength(8), passwordContainsLetter, passwordContainsDigit, passwordNoSpaces]],
            confirmPassword: ['', [Validators.required]],
            avatarId: ['', [Validators.required]],
        },
        { validators: passwordMatchValidator },
    );

    constructor(
        private fb: FormBuilder,
        private authService: AuthService,
        private profileService: ProfileService,
        private router: Router,
        public camera: CameraCaptureService,
        public languageService: LanguageService,
        private translate: TranslateService,
    ) {}

    setLanguage(lang: LanguageType) {
        this.languageService.setLanguage(lang);
    }

    get selectedAvatarId(): string {
        return this.form.controls.avatarId.value ?? '';
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

        if (!file) {
            if (!this.form.controls.avatarId.value || this.form.controls.avatarId.value === 'custom') {
                this.form.controls.avatarId.setValue('');
            }
            return;
        }

        const maxSize = 4 * 1024 * 1024;
        const validTypes = ['image/jpeg', 'image/png'];

        if (!validTypes.includes(file.type)) {
            const extension = file.name.split('.').pop()?.toLowerCase() ?? 'inconnu';
            this.avatarFileError = `Fichier de type "${extension}" non autorisé. Formats permis : JPG, JPEG, PNG (taille maximale 4 MB).`;
            return;
        }

        if (file.size > maxSize) {
            const sizeMb = file.size / (1024 * 1024);
            this.avatarFileError = `Fichier trop volumineux (${sizeMb.toFixed(2)} MB). Taille maximale autorisée : 4 MB.`;
            return;
        }

        this.selectedAvatarFile = file;

        const reader = new FileReader();
        reader.onload = (e) => {
            this.avatarPreviewUrl = e.target?.result as string;
        };
        reader.readAsDataURL(file);

        this.form.controls.avatarId.setValue('custom');
        this.form.controls.avatarId.markAsTouched();
    }

    isPremiumLocked(avatarId: string): boolean {
        return EXCLUSIVE_AVATAR_IDS.includes(avatarId);
    }

    selectAvatar(id: string) {
        if (this.isPremiumLocked(id)) return;
        this.selectedAvatarFile = null;
        this.avatarPreviewUrl = null;
        this.avatarFileError = null;
        this.form.controls.avatarId.setValue(id);
        this.form.controls.avatarId.markAsTouched();
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
        this.form.controls.avatarId.setValue('custom');
        this.form.controls.avatarId.markAsTouched();

        this.camera.closeCamera(this.cameraVideoRef);
    }

    closeCamera() {
        this.camera.closeCamera(this.cameraVideoRef);
    }

    togglePasswordVisibility() {
        this.showPassword = !this.showPassword;
    }

    toggleConfirmPasswordVisibility() {
        this.showConfirmPassword = !this.showConfirmPassword;
    }

    async submitForm() {
        this.errorMessage = null;
        this.form.markAllAsTouched();

        if (this.form.invalid) return;

        const { username, email, password, avatarId } = this.form.getRawValue();

        this.isSubmitting = true;
        try {
            const res = await this.authService.register({
                username,
                email,
                password,
                avatarId,
            });

            if (this.selectedAvatarFile) {
                try {
                    await this.profileService.uploadAvatar(this.selectedAvatarFile);
                    this.selectedAvatarFile = null;
                } catch {
                    this.errorMessage = "Erreur lors du téléversement de l'avatar (l'image par défaut a été conservée).";
                }
            }

            await this.router.navigate(['/home']);
            // eslint-disable-next-line no-console
            console.log('Session créée:', res.sessionId, res.user);
        } catch (e: unknown) {
            if (e instanceof HttpErrorResponse) {
                const rawMessage = typeof e.error?.message === 'string' ? e.error.message : typeof e.message === 'string' ? e.message : null;
                if (rawMessage) {
                    const translated = this.translate.instant(rawMessage);
                    this.errorMessage = translated !== rawMessage ? translated : rawMessage;
                } else {
                    this.errorMessage = `Erreur serveur (${e.status})`;
                }
            } else {
                this.errorMessage = "Erreur lors de l'inscription.";
            }
            // eslint-disable-next-line no-console
            console.error(e);
        } finally {
            this.isSubmitting = false;
        }
    }
}

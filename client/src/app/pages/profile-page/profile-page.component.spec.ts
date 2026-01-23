import { ComponentFixture, TestBed } from '@angular/core/testing';
import { FormBuilder, ReactiveFormsModule } from '@angular/forms';
import { provideRouter, Router, RouterLink } from '@angular/router';
import { ProfileService, UserProfile, UserStatistics } from '@app/services/communication/profile.service';
import { StatsService } from '@app/services/communication/stats.service';
import { ProfilePageComponent } from './profile-page.component';

describe('ProfilePageComponent', () => {
    let component: ProfilePageComponent;
    let fixture: ComponentFixture<ProfilePageComponent>;
    let profileServiceSpy: jasmine.SpyObj<ProfileService>;
    let statsServiceSpy: jasmine.SpyObj<StatsService>;
    let routerSpy: jasmine.SpyObj<Router>;

    const mockProfile: UserProfile = {
        id: '1',
        email: 'test@example.com',
        username: 'testuser',
        avatarId: 'avatar_01',
    };

    const mockStatistics: UserStatistics = {
        classicGamesPlayed: 10,
        ctfGamesPlayed: 5,
        totalGamesWon: 8,
        averagePlaytimePerGame: 1200,
    };

    beforeEach(async () => {
        profileServiceSpy = jasmine.createSpyObj('ProfileService', [
            'getProfile',
            'updateProfile',
            'getStatistics',
            'loadProfileAndStatistics',
            'buildUpdatePayload',
            'extractErrorMessage',
            'submitProfileUpdate',
            'getDefaultErrorMessage',
        ]);
        statsServiceSpy = jasmine.createSpyObj('StatsService', ['formatTime']);
        routerSpy = jasmine.createSpyObj('Router', ['navigate']);

        profileServiceSpy.loadProfileAndStatistics.and.returnValue(Promise.resolve({ profile: mockProfile, statistics: mockStatistics }));
        profileServiceSpy.updateProfile.and.returnValue(Promise.resolve(mockProfile));
        profileServiceSpy.buildUpdatePayload.and.callFake(
            (profile: UserProfile, formValues: { username: string; email: string; avatarId: string }) => {
                const payload: { username?: string; email?: string; avatarId?: string } = {};
                if (formValues.username !== profile.username) payload.username = formValues.username;
                if (formValues.email !== profile.email) payload.email = formValues.email;
                if (formValues.avatarId !== profile.avatarId) payload.avatarId = formValues.avatarId;
                return payload;
            },
        );
        profileServiceSpy.extractErrorMessage.and.callFake((error: unknown) => {
            const httpError = error as { error?: { message?: string }; message?: string };
            return httpError?.error?.message || httpError?.message || 'Erreur lors de la mise à jour du profil';
        });
        profileServiceSpy.submitProfileUpdate.and.callFake(
            async (profile: UserProfile, formValues: { username: string; email: string; avatarId: string }) => {
                const payload: { username?: string; email?: string; avatarId?: string } = {};
                if (formValues.username !== profile.username) payload.username = formValues.username;
                if (formValues.email !== profile.email) payload.email = formValues.email;
                if (formValues.avatarId !== profile.avatarId) payload.avatarId = formValues.avatarId;

                if (Object.keys(payload).length === 0) {
                    return { success: false, error: 'Aucune modification détectée' };
                }

                return { success: true, updatedProfile: { ...profile, ...formValues } };
            },
        );
        profileServiceSpy.getDefaultErrorMessage.and.returnValue('Erreur lors du chargement du profil');
        statsServiceSpy.formatTime.and.returnValue('20m');

        await TestBed.configureTestingModule({
            imports: [ProfilePageComponent, ReactiveFormsModule, RouterLink],
            providers: [
                FormBuilder,
                provideRouter([]),
                { provide: ProfileService, useValue: profileServiceSpy },
                { provide: StatsService, useValue: statsServiceSpy },
                { provide: Router, useValue: routerSpy },
            ],
        }).compileComponents();

        fixture = TestBed.createComponent(ProfilePageComponent);
        component = fixture.componentInstance;
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });

    it('should load profile and statistics on init', async () => {
        fixture.detectChanges();
        await fixture.whenStable();

        expect(profileServiceSpy.loadProfileAndStatistics).toHaveBeenCalled();
        expect(component.profile).toEqual(mockProfile);
        expect(component.statistics).toEqual(mockStatistics);
        expect(component.isLoading).toBe(false);
    });

    it('should initialize form with profile data', async () => {
        fixture.detectChanges();
        await fixture.whenStable();

        expect(component.form.controls.username.value).toBe('testuser');
        expect(component.form.controls.email.value).toBe('test@example.com');
        expect(component.form.controls.avatarId.value).toBe('avatar_01');
    });

    it('should select avatar', () => {
        component.selectAvatar('avatar_02');
        expect(component.form.controls.avatarId.value).toBe('avatar_02');
        expect(component.form.controls.avatarId.touched).toBe(true);
    });

    it('should not submit form if invalid', () => {
        component.form.controls.username.setValue('');
        component.submitForm();

        expect(profileServiceSpy.submitProfileUpdate).not.toHaveBeenCalled();
    });

    it('should submit form with changed values only', async () => {
        fixture.detectChanges();
        await fixture.whenStable();

        component.form.controls.username.setValue('newusername');
        component.form.controls.email.setValue('newemail@example.com');

        await component.submitForm();

        expect(profileServiceSpy.submitProfileUpdate).toHaveBeenCalled();
        expect(component.showSuccessMessage).toBe(true);
    });

    it('should not submit if nothing changed', async () => {
        fixture.detectChanges();
        await fixture.whenStable();

        await component.submitForm();

        expect(profileServiceSpy.submitProfileUpdate).toHaveBeenCalled();
        expect(component.showSuccessMessage).toBe(false);
    });

    it('should show success message after successful update', async () => {
        fixture.detectChanges();
        await fixture.whenStable();

        component.form.controls.username.setValue('newusername');
        await component.submitForm();

        expect(component.showSuccessMessage).toBe(true);
    });

    it('should show error message on update failure', async () => {
        fixture.detectChanges();
        await fixture.whenStable();

        profileServiceSpy.submitProfileUpdate.and.returnValue(Promise.resolve({ success: false, error: 'Email déjà utilisé' }));

        component.form.controls.email.setValue('newemail@example.com');
        await component.submitForm();

        expect(component.showErrorMessage).toBe(true);
        expect(component.errorMessage).toBe('Email déjà utilisé');
    });

    it('should handle profile load error', async () => {
        profileServiceSpy.loadProfileAndStatistics.and.returnValue(Promise.reject(new Error('Network error')));

        fixture.detectChanges();
        await fixture.whenStable();

        expect(component.isLoading).toBe(false);
        expect(component.showErrorMessage).toBe(true);
    });

    it('should format time using stats service', () => {
        component.formatTime(1200);
        expect(statsServiceSpy.formatTime).toHaveBeenCalledWith(1200);
    });

    it('should have correct selectedAvatarId getter', () => {
        component.form.controls.avatarId.setValue('avatar_03');
        expect(component.selectedAvatarId).toBe('avatar_03');
    });
});

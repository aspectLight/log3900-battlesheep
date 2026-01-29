import { provideHttpClient, withInterceptorsFromDi } from '@angular/common/http';
import { HttpTestingController, provideHttpClientTesting } from '@angular/common/http/testing';
import { TestBed } from '@angular/core/testing';
import { Auth } from '@angular/fire/auth';
import { UpdateProfilePayload, UserProfile, UserStatistics } from '@app/interfaces/profile.interface';
import { SessionService } from '@app/services/state/session.service';
import { environment } from 'src/environments/environment';
import { ProfileService } from './profile.service';

describe('ProfileService', () => {
    let service: ProfileService;
    let httpMock: HttpTestingController;
    let authSpy: jasmine.SpyObj<Auth>;
    let sessionServiceSpy: jasmine.SpyObj<SessionService>;
    let mockUser: { getIdToken: jasmine.Spy };

    const apiUrl = `${environment.serverUrl}/auth`;

    beforeEach(() => {
        mockUser = {
            getIdToken: jasmine.createSpy('getIdToken').and.returnValue(Promise.resolve('mock-token')),
        };

        authSpy = jasmine.createSpyObj('Auth', [], {
            currentUser: mockUser,
        });

        sessionServiceSpy = jasmine.createSpyObj('SessionService', [], {
            sessionId: 'mock-session-id',
        });

        TestBed.configureTestingModule({
            imports: [],
            providers: [
                ProfileService,
                provideHttpClient(withInterceptorsFromDi()),
                provideHttpClientTesting(),
                { provide: Auth, useValue: authSpy },
                { provide: SessionService, useValue: sessionServiceSpy },
            ],
        });

        service = TestBed.inject(ProfileService);
        httpMock = TestBed.inject(HttpTestingController);
    });

    afterEach(() => {
        httpMock.verify();
    });

    it('should be created', () => {
        expect(service).toBeTruthy();
    });

    describe('getProfile', () => {
        it('should return user profile', async () => {
            const mockProfile: UserProfile = {
                id: '1',
                email: 'test@example.com',
                username: 'testuser',
                avatarId: 'avatar_01',
            };

            const promise = service.getProfile();
            const req = httpMock.expectOne(`${apiUrl}/profile`);
            expect(req.request.method).toBe('GET');
            expect(req.request.headers.get('Authorization')).toBe('Bearer mock-token');
            expect(req.request.headers.get('x-session-id')).toBe('mock-session-id');
            req.flush(mockProfile);

            const result = await promise;
            expect(result).toEqual(mockProfile);
        });

        it('should throw error when user is not authenticated', async () => {
            Object.defineProperty(authSpy, 'currentUser', {
                value: null,
                writable: true,
                configurable: true,
            });

            try {
                await service.getProfile();
                fail('Should have thrown an error');
            } catch (error) {
                expect((error as Error).message).toBe('Utilisateur non authentifié');
            }
        });

        it('should throw error when sessionId is missing', async () => {
            Object.defineProperty(sessionServiceSpy, 'sessionId', {
                value: null,
                writable: true,
                configurable: true,
            });

            try {
                await service.getProfile();
                fail('Should have thrown an error');
            } catch (error) {
                expect((error as Error).message).toBe('Utilisateur non authentifié');
            }
        });
    });

    describe('updateProfile', () => {
        it('should update user profile', async () => {
            const updatePayload: UpdateProfilePayload = {
                username: 'newusername',
                email: 'newemail@example.com',
            };

            const mockResponse = {
                message: 'Profil mis à jour',
                user: {
                    id: '1',
                    email: 'newemail@example.com',
                    username: 'newusername',
                    avatarId: 'avatar_01',
                } as UserProfile,
            };

            const promise = service.updateProfile(updatePayload);
            const req = httpMock.expectOne(`${apiUrl}/profile`);
            expect(req.request.method).toBe('PATCH');
            expect(req.request.body).toEqual(updatePayload);
            expect(req.request.headers.get('Authorization')).toBe('Bearer mock-token');
            expect(req.request.headers.get('x-session-id')).toBe('mock-session-id');
            req.flush(mockResponse);

            const result = await promise;
            expect(result).toEqual(mockResponse.user);
        });

        it('should update only avatar', async () => {
            const updatePayload: UpdateProfilePayload = {
                avatarId: 'avatar_02',
            };

            const mockResponse = {
                message: 'Profil mis à jour',
                user: {
                    id: '1',
                    email: 'test@example.com',
                    username: 'testuser',
                    avatarId: 'avatar_02',
                } as UserProfile,
            };

            const promise = service.updateProfile(updatePayload);
            const req = httpMock.expectOne(`${apiUrl}/profile`);
            expect(req.request.method).toBe('PATCH');
            expect(req.request.body).toEqual(updatePayload);
            req.flush(mockResponse);

            const result = await promise;
            expect(result.avatarId).toBe('avatar_02');
        });
    });

    describe('getStatistics', () => {
        it('should return user statistics', async () => {
            const mockStats: UserStatistics = {
                classicGamesPlayed: 10,
                ctfGamesPlayed: 5,
                totalGamesWon: 8,
                averagePlaytimePerGame: 1200,
            };

            const promise = service.getStatistics();
            const req = httpMock.expectOne(`${apiUrl}/statistics`);
            expect(req.request.method).toBe('GET');
            expect(req.request.headers.get('Authorization')).toBe('Bearer mock-token');
            expect(req.request.headers.get('x-session-id')).toBe('mock-session-id');
            req.flush(mockStats);

            const result = await promise;
            expect(result).toEqual(mockStats);
        });
    });

    describe('buildUpdatePayload', () => {
        it('should build payload with only changed fields', () => {
            const currentProfile: UserProfile = {
                id: '1',
                email: 'old@example.com',
                username: 'olduser',
                avatarId: 'avatar_01',
            };

            const formValues = {
                username: 'newuser',
                email: 'old@example.com',
                avatarId: 'avatar_02',
            };

            const payload = service.buildUpdatePayload(currentProfile, formValues);

            expect(payload.username).toBe('newuser');
            expect(payload.email).toBeUndefined();
            expect(payload.avatarId).toBe('avatar_02');
        });

        it('should return empty payload when nothing changed', () => {
            const currentProfile: UserProfile = {
                id: '1',
                email: 'test@example.com',
                username: 'testuser',
                avatarId: 'avatar_01',
            };

            const formValues = {
                username: 'testuser',
                email: 'test@example.com',
                avatarId: 'avatar_01',
            };

            const payload = service.buildUpdatePayload(currentProfile, formValues);

            expect(Object.keys(payload).length).toBe(0);
        });
    });

    describe('extractErrorMessage', () => {
        it('should extract error message from http error', () => {
            const error = { error: { message: 'Email déjà utilisé' } };
            expect(service.extractErrorMessage(error)).toBe('Email déjà utilisé');
        });

        it('should extract error message from error object', () => {
            const error = { message: 'Network error' };
            expect(service.extractErrorMessage(error)).toBe('Network error');
        });

        it('should return default message when no message found', () => {
            const error = {};
            expect(service.extractErrorMessage(error)).toBe('Erreur lors de la mise à jour du profil');
        });
    });

    describe('loadProfileAndStatistics', () => {
        it('should load both profile and statistics', async () => {
            const mockProfile: UserProfile = {
                id: '1',
                email: 'test@example.com',
                username: 'testuser',
                avatarId: 'avatar_01',
            };

            const mockStats: UserStatistics = {
                classicGamesPlayed: 10,
                ctfGamesPlayed: 5,
                totalGamesWon: 8,
                averagePlaytimePerGame: 1200,
            };

            const promise = service.loadProfileAndStatistics();
            const profileReq = httpMock.expectOne(`${apiUrl}/profile`);
            const statsReq = httpMock.expectOne(`${apiUrl}/statistics`);
            profileReq.flush(mockProfile);
            statsReq.flush(mockStats);

            const result = await promise;
            expect(result.profile).toEqual(mockProfile);
            expect(result.statistics).toEqual(mockStats);
        });
    });

    describe('submitProfileUpdate', () => {
        it('should return success when update is successful', async () => {
            const currentProfile: UserProfile = {
                id: '1',
                email: 'old@example.com',
                username: 'olduser',
                avatarId: 'avatar_01',
            };

            const formValues = {
                username: 'newuser',
                email: 'old@example.com',
                avatarId: 'avatar_01',
            };

            const mockResponse = {
                message: 'Profil mis à jour',
                user: {
                    ...currentProfile,
                    username: 'newuser',
                } as UserProfile,
            };

            const promise = service.submitProfileUpdate(currentProfile, formValues);
            const req = httpMock.expectOne(`${apiUrl}/profile`);
            expect(req.request.method).toBe('PATCH');
            req.flush(mockResponse);

            const result = await promise;
            expect(result.success).toBe(true);
            expect(result.updatedProfile).toEqual(mockResponse.user);
        });

        it('should return error when no changes detected', async () => {
            const currentProfile: UserProfile = {
                id: '1',
                email: 'test@example.com',
                username: 'testuser',
                avatarId: 'avatar_01',
            };

            const formValues = {
                username: 'testuser',
                email: 'test@example.com',
                avatarId: 'avatar_01',
            };

            const result = await service.submitProfileUpdate(currentProfile, formValues);
            expect(result.success).toBe(false);
            expect(result.error).toBe('Aucune modification détectée');
        });

        it('should return error when update fails', async () => {
            const currentProfile: UserProfile = {
                id: '1',
                email: 'old@example.com',
                username: 'olduser',
                avatarId: 'avatar_01',
            };

            const formValues = {
                username: 'newuser',
                email: 'old@example.com',
                avatarId: 'avatar_01',
            };

            const promise = service.submitProfileUpdate(currentProfile, formValues);
            const req = httpMock.expectOne(`${apiUrl}/profile`);
            req.flush({ error: { message: 'Email déjà utilisé' } }, { status: 400, statusText: 'Bad Request' });

            const result = await promise;
            expect(result.success).toBe(false);
            expect(result.error).toBeDefined();
        });
    });

    describe('getDefaultErrorMessage', () => {
        it('should return default error message', () => {
            expect(service.getDefaultErrorMessage()).toBe('Erreur lors du chargement du profil');
        });
    });
});

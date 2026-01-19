/* eslint-disable @typescript-eslint/no-explicit-any */
import { TestBed } from '@angular/core/testing';
import { VirtualPlayerService } from '@app/services/gameplay/virtual-player.service';
import { RoomSocketService } from '@app/services/communication/socket-handlers/room-socket.service';
import { of } from 'rxjs';
import { BonusType } from '@app/constants/bonus.constants';
import { VirtualPlayerType } from '@app/constants/player.constants';

describe('VirtualPlayerService', () => {
    let service: VirtualPlayerService;
    let mockRoomSocketService: jasmine.SpyObj<RoomSocketService>;

    beforeEach(() => {
        mockRoomSocketService = jasmine.createSpyObj('RoomSocketService', [], {
            reservedAvatars$: of([{ chosenAvatar: 'avatar1' }, { chosenAvatar: 'avatar2' }]),
        });

        TestBed.configureTestingModule({
            providers: [VirtualPlayerService, { provide: RoomSocketService, useValue: mockRoomSocketService }],
        });
        service = TestBed.inject(VirtualPlayerService);
    });

    it('should be created', () => {
        expect(service).toBeTruthy();
    });

    describe('generateUniqueVPName', () => {
        it('should generate a unique name and add to usedNames', () => {
            const name = service.generateUniqueVPName();
            expect(name).toMatch(/^VP[0-9]+$/);
            expect((service as any).usedNames).toContain(name);
        });

        it('should not generate duplicate names', () => {
            const nameNumber = 10;
            const names = new Set<string>();
            for (let i = 0; i < nameNumber; i++) {
                names.add(service.generateUniqueVPName());
            }
            expect(names.size).toBe(nameNumber);
        });
    });

    describe('resetUsedNames', () => {
        it('should clear usedNames', () => {
            service.generateUniqueVPName();
            service.resetUsedNames();
            expect((service as any).usedNames).toEqual([]);
        });
    });

    describe('removeName', () => {
        it('should remove a name if it exists', () => {
            const name = service.generateUniqueVPName();
            expect((service as any).usedNames).toContain(name);
            service.removeName(name);
            expect((service as any).usedNames).not.toContain(name);
        });

        it('should do nothing if name does not exist', () => {
            service.resetUsedNames();
            service.removeName('NonExistentName');
            expect((service as any).usedNames).toEqual([]);
        });
    });

    describe('generateUniqueAvatar', () => {
        it('should return an avatar not in reserved list', () => {
            const avatar = service.generateUniqueAvatar();
            const reserved = ['avatar1', 'avatar2'].map((a) => a.toLowerCase());
            expect(reserved).not.toContain(avatar.toLowerCase());
        });
    });

    describe('generateRandomD6Choice', () => {
        it('should return either Attack or Defense', () => {
            const value = service.generateRandomD6Choice();
            expect([BonusType.Attack, BonusType.Defense]).toContain(value);
        });
    });

    describe('generateRandomBonusChoice', () => {
        it('should return either Health or Speed', () => {
            const value = service.generateRandomBonusChoice();
            expect([BonusType.Health, BonusType.Speed]).toContain(value);
        });
    });

    describe('generateVirtualPlayer', () => {
        it('should generate a virtual player with correct properties', () => {
            const behaviour = VirtualPlayerType.Aggressive;
            const player = service.generateVirtualPlayer(behaviour);
            expect(player.name).toMatch(/^VP[0-9]+$/);
            expect(player.avatar).toBeTruthy();
        });
    });
});

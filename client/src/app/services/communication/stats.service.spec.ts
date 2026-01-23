import { TestBed } from '@angular/core/testing';
import { StatsService } from './stats.service';

describe('StatsService', () => {
    let service: StatsService;

    beforeEach(() => {
        TestBed.configureTestingModule({});
        service = TestBed.inject(StatsService);
    });

    it('should be created', () => {
        expect(service).toBeTruthy();
    });

    describe('formatTime', () => {
        it('should format seconds less than 60 correctly', () => {
            expect(service.formatTime(0)).toBe('0s');
            expect(service.formatTime(30)).toBe('30s');
            expect(service.formatTime(59)).toBe('59s');
        });

        it('should format minutes less than 60 correctly', () => {
            expect(service.formatTime(60)).toBe('1m');
            expect(service.formatTime(90)).toBe('1m 30s');
            expect(service.formatTime(120)).toBe('2m');
            expect(service.formatTime(3599)).toBe('59m 59s');
        });

        it('should format hours correctly', () => {
            expect(service.formatTime(3600)).toBe('1h');
            expect(service.formatTime(3660)).toBe('1h 1m');
            expect(service.formatTime(3720)).toBe('1h 2m');
            expect(service.formatTime(7200)).toBe('2h');
            expect(service.formatTime(7260)).toBe('2h 1m');
        });

        it('should handle edge cases', () => {
            expect(service.formatTime(1)).toBe('1s');
            expect(service.formatTime(61)).toBe('1m 1s');
            expect(service.formatTime(3601)).toBe('1h 0m');
        });
    });
});

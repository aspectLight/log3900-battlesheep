import { provideHttpClient } from '@angular/common/http';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { ActivatedRoute } from '@angular/router';
import { WaitingPlayerPageComponent } from '@app/pages/waiting-player-page/waiting-player-page.component';
import { of } from 'rxjs';

describe('WaitingPlayerPageComponent', () => {
    let component: WaitingPlayerPageComponent;
    let fixture: ComponentFixture<WaitingPlayerPageComponent>;

    beforeEach(async () => {
        await TestBed.configureTestingModule({
            imports: [WaitingPlayerPageComponent],
            providers: [
                provideHttpClient(),
                {
                    provide: ActivatedRoute,
                    useValue: {
                        params: of({}),
                        snapshot: { params: {} },
                    },
                },
            ],
        }).compileComponents();
    });

    beforeEach(() => {
        fixture = TestBed.createComponent(WaitingPlayerPageComponent);
        component = fixture.componentInstance;
        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });
});

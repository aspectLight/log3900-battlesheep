import { provideHttpClient } from '@angular/common/http';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { ActivatedRoute } from '@angular/router';
import { EndGamePageComponent } from '@app/pages/end-game-page/end-game-page.component';
import { of } from 'rxjs';

describe('EndGamePageComponent', () => {
    let component: EndGamePageComponent;
    let fixture: ComponentFixture<EndGamePageComponent>;

    beforeEach(async () => {
        await TestBed.configureTestingModule({
            imports: [EndGamePageComponent],
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
        fixture = TestBed.createComponent(EndGamePageComponent);
        component = fixture.componentInstance;
        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });
});

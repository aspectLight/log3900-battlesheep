import { provideHttpClient } from '@angular/common/http';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { ActivatedRoute } from '@angular/router';
import { FriendsPageComponent } from '@app/pages/friends-page/friends-page.component';
import { of } from 'rxjs';

describe('FriendsPageComponent', () => {
    let component: FriendsPageComponent;
    let fixture: ComponentFixture<FriendsPageComponent>;

    beforeEach(async () => {
        await TestBed.configureTestingModule({
            imports: [FriendsPageComponent],
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
        fixture = TestBed.createComponent(FriendsPageComponent);
        component = fixture.componentInstance;
        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });
});
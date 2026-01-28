import { ComponentFixture, TestBed } from '@angular/core/testing';
import { ConfigureGamePageComponent } from './configure-game-page.component';
import { GameConfiguratorComponent } from '@app/components/editor/game-configurator/game-configurator.component';
import { CommonModule } from '@angular/common';
import { provideHttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { GameService } from '@app/services/editor/game.service';

describe('ConfigureGamePageComponent', () => {
    let component: ConfigureGamePageComponent;
    let fixture: ComponentFixture<ConfigureGamePageComponent>;
    let mockGameService: jasmine.SpyObj<GameService>;
    let mockRouter: jasmine.SpyObj<Router>;

    beforeEach(async () => {
        mockGameService = jasmine.createSpyObj('GameService', ['setNewGame', 'setGameSettings']);
        mockRouter = jasmine.createSpyObj('Router', ['navigate']);

        await TestBed.configureTestingModule({
            imports: [CommonModule, ConfigureGamePageComponent, GameConfiguratorComponent],
            providers: [provideHttpClient(), { provide: Router, useValue: mockRouter }, { provide: GameService, useValue: mockGameService }],
        }).compileComponents();

        fixture = TestBed.createComponent(ConfigureGamePageComponent);
        component = fixture.componentInstance;
        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });

    it('should render the GameConfiguratorComponent', () => {
        const compiled = fixture.nativeElement;
        expect(compiled.querySelector('app-game-configurator')).toBeTruthy();
    });
});

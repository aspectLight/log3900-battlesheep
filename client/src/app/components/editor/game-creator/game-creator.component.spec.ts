import { CommonModule } from '@angular/common';
import { provideHttpClient } from '@angular/common/http';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { Game } from '@app/classes/game/game';
import { GameCreatorComponent } from '@app/components/editor/game-creator/game-creator.component';
import { GameListComponent } from '@app/components/editor/game-list/game-list.component';
import { ROUTES } from '@app/constants/routes.constants';
import { GameCreationService } from '@app/services/lobby/game-creation.service';
import { GameListService } from '@app/services/lobby/game-list.service';
import { RoomSocketService } from '@app/services/communication/socket-handlers/room-socket.service';

describe('CreateGamePageComponent', () => {
    let component: GameCreatorComponent;
    let fixture: ComponentFixture<GameCreatorComponent>;
    let mockRouter: jasmine.SpyObj<Router>;
    let mockActivatedRoute: Partial<ActivatedRoute>;
    let mockGameListService: jasmine.SpyObj<GameListService>;
    let mockGameCreationService: jasmine.SpyObj<GameCreationService>;
    let mockSocketService: jasmine.SpyObj<RoomSocketService>;

    beforeEach(async () => {
        mockRouter = jasmine.createSpyObj('Router', ['navigate']);
        mockActivatedRoute = {};
        mockGameListService = jasmine.createSpyObj('GameListService', ['fetchGameById']);
        mockGameCreationService = jasmine.createSpyObj('GameCreationService', ['setSelectedGame', 'setGameCode']);
        mockSocketService = jasmine.createSpyObj('RoomSocketService', ['generateCode']);

        await TestBed.configureTestingModule({
            imports: [CommonModule, GameListComponent, GameCreatorComponent, RouterLink],
            providers: [
                provideHttpClient(),
                { provide: Router, useValue: mockRouter },
                { provide: ActivatedRoute, useValue: mockActivatedRoute },
                { provide: GameListService, useValue: mockGameListService },
                { provide: GameCreationService, useValue: mockGameCreationService },
                { provide: RoomSocketService, useValue: mockSocketService },
            ],
        }).compileComponents();

        fixture = TestBed.createComponent(GameCreatorComponent);
        component = fixture.componentInstance;
        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });

    it('should initialize with no selected game', () => {
        expect(component.selectedGame).toBeNull();
    });

    it('should set selectedGame when onSelectGame is called', () => {
        const mockGame: Game = { _id: '123', name: 'Test Game' } as Game;
        component.onSelectGame(mockGame);
        expect(component.selectedGame).toEqual(mockGame);
    });

    it('should disable the button if no game is selected', () => {
        component.hasGames = true;
        fixture.detectChanges();
        const button = fixture.nativeElement.querySelector('.square-button');
        expect(button.disabled).toBeTrue();
    });

    it('should enable the button when a game is selected', () => {
        component.hasGames = true;
        component.selectedGame = { _id: '123', name: 'Test Game' } as Game;
        fixture.detectChanges();
        const button = fixture.nativeElement.querySelector('.square-button');
        expect(button.disabled).toBeFalse();
    });

    it('should navigate to /create-player and store the game in GameCreationService when goToCharacterCreation is called', async () => {
        const mockGame: Game = { _id: '123', name: 'Test Game' } as Game;
        component.selectedGame = mockGame;

        mockGameListService.fetchGameById.and.resolveTo(false);
        const mockCode = 'XYZ123';
        mockSocketService.generateCode.and.callFake((callback) => callback(mockCode));

        await component.createGame();

        expect(mockGameCreationService.setGameCode).toHaveBeenCalledWith(mockCode);

        expect(mockRouter.navigate).toHaveBeenCalledWith([ROUTES.createPlayer]);
    });

    it('should not navigate if game is not found (deleted)', async () => {
        const mockGame: Game = { _id: '123', name: 'Test Game' } as Game;
        component.selectedGame = mockGame;

        mockGameListService.fetchGameById.and.resolveTo(true);

        await component.createGame();

        expect(mockRouter.navigate).not.toHaveBeenCalled();
    });

    it('should not navigate if no game is selected', () => {
        component.selectedGame = null;
        component.createGame();
        expect(mockRouter.navigate).not.toHaveBeenCalled();
    });

    it('should remove popUp when the button is clicked', () => {
        component.handlePopUp();
        expect(component.gameModified).toBeFalse();
    });

    it('should update hasGames based on games length', () => {
        component.onGamesLengthChange(0);
        expect(component.hasGames).toBeFalse();

        component.onGamesLengthChange(1);
        expect(component.hasGames).toBeTrue();

        component.onGamesLengthChange(5);
        expect(component.hasGames).toBeTrue();
    });
});

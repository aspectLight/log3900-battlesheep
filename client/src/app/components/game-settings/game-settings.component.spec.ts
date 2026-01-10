import { ComponentFixture, TestBed } from '@angular/core/testing';
import { Router } from '@angular/router';
import { GameManagerService } from '@app/services/game-manager.service';
import { SocketService } from '@app/services/socket.service';
import { GameSettingsComponent } from './game-settings.component';
import { Game } from '@app/classes/game';
import { Room } from '@app/interfaces/room';
import { Player } from '@app/classes/player';
import { Board } from '@app/classes/board';

describe('GameSettingsComponent', () => {
    let component: GameSettingsComponent;
    let fixture: ComponentFixture<GameSettingsComponent>;
    let socketServiceSpy: jasmine.SpyObj<SocketService>;
    let gameManagerServiceSpy: jasmine.SpyObj<GameManagerService>;
    let routerSpy: jasmine.SpyObj<Router>;

    const mockRoom = {
        roomId: 'roomId',
        gameId: '1',
        organisatorId: '0',
        players: [new Player(), new Player(), new Player()],
        isLocked: false,
        isDebugging: false,
    } as Room;

    class MockGame {
        _id = 'mockId';
        name = 'mockGame';
        description = 'mockDescription';
        mode = 'mockMode';
        isVisible = false;
        modificationDate = 'mockDate';
    }
    /* eslint-disable @typescript-eslint/no-magic-numbers */
    const mockBoard = new Board(3);
    /* eslint-enable @typescript-eslint/no-magic-numbers */

    beforeEach(async () => {
        socketServiceSpy = jasmine.createSpyObj('SocketService', ['abandonGame']);
        gameManagerServiceSpy = jasmine.createSpyObj('GameManagerService', ['getGame', 'getRoomId', 'getBoard']);
        routerSpy = jasmine.createSpyObj('Router', ['navigate']);

        await TestBed.configureTestingModule({
            imports: [GameSettingsComponent],
            providers: [
                { provide: Game, useClass: MockGame },
                { provide: SocketService, useValue: socketServiceSpy },
                { provide: GameManagerService, useValue: gameManagerServiceSpy },
                { provide: Router, useValue: routerSpy },
            ],
        }).compileComponents();

        gameManagerServiceSpy.getRoomId.and.returnValue('roomId');
        gameManagerServiceSpy.getGame.and.returnValue(new MockGame() as Game);
        gameManagerServiceSpy.getBoard.and.returnValue(mockBoard);
        gameManagerServiceSpy.room = mockRoom; // Fix: Initialize room with players

        fixture = TestBed.createComponent(GameSettingsComponent);
        component = fixture.componentInstance;
        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });

    it('should return the game title', () => {
        expect(component.title).toBe('mockGame');
    });

    it('should return the game description with player count', () => {
        expect(component.description).toBe('mockDescription\n\nJoueurs: 3\nJoueur actif: undefined\nTaille du plateau: 3x3');
    });

    it('should return the room ID', () => {
        expect(component.roomId).toBe('roomId');
    });

    it('should toggle isSettingsClicked when toggleSettings is called', () => {
        component.toggleSettings();
        expect(component.isSettingsClicked).toBeTrue();
        component.toggleSettings();
        expect(component.isSettingsClicked).toBeFalse();
    });

    it('should call socketService.abandonGame and navigate to home when quitGame is called', () => {
        component.quitGame();
        expect(socketServiceSpy.abandonGame).toHaveBeenCalledWith('roomId');
        expect(routerSpy.navigate).toHaveBeenCalledWith(['/home']);
    });
});

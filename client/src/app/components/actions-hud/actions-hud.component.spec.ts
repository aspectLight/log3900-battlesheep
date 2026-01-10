import { ComponentFixture, TestBed } from '@angular/core/testing';
import { provideHttpClient } from '@angular/common/http';
import { ActionsHudComponent } from './actions-hud.component';
import { Player } from '@app/classes/player';
import { GameManagerService } from '@app/services/game-manager.service';
import { PlayerCard } from '@app/interfaces/character';

// Define two players for testing.
const player1 = new Player('player1');
const player2 = new Player('player2');

// Fake service to mimic GameManagerService.
class FakeGameManagerService {
    disconnectedPlayer: Player[] = [player2];
    currentPlayerId = player1.id;
    room = { organisatorId: player1.id };

    getPlayers(): Player[] {
        return [player1];
    }
}

describe('ActionsHudComponent', () => {
    beforeEach(async () => {
        await TestBed.configureTestingModule({
            imports: [ActionsHudComponent],
            providers: [provideHttpClient(), { provide: GameManagerService, useClass: FakeGameManagerService }],
        }).compileComponents();
    });

    describe('with overridden playerCardList getter', () => {
        let component: ActionsHudComponent;
        let fixture: ComponentFixture<ActionsHudComponent>;
        let playerCardListMock: PlayerCard[];

        beforeEach(() => {
            fixture = TestBed.createComponent(ActionsHudComponent);
            component = fixture.componentInstance;

            playerCardListMock = [
                {
                    player: player1,
                    isActive: false,
                    isHost: true,
                    playerColor: player1.color,
                    isDisconnected: false,
                },
                {
                    player: player2,
                    isActive: false,
                    isHost: false,
                    playerColor: player2.color,
                    isDisconnected: true,
                },
            ];

            spyOnProperty(component, 'playerCardList', 'get').and.returnValue(playerCardListMock);

            fixture.detectChanges();
        });

        it('should create', () => {
            expect(component).toBeTruthy();
        });

        it('should initialize playerCardList correctly', () => {
            const list = component.playerCardList;
            expect(list.length).toBe(2);

            expect(list[0].player).toBe(player1);
            expect(list[0].isActive).toBeFalse();
            expect(list[0].isHost).toBeTrue();
            expect(list[0].playerColor).toBe(player1.color);
            expect(list[0].isDisconnected).toBeFalse();

            expect(list[1].player).toBe(player2);
            expect(list[1].isActive).toBeFalse();
            expect(list[1].isHost).toBeFalse();
            expect(list[1].playerColor).toBe(player2.color);
            expect(list[1].isDisconnected).toBeTrue();
        });

        it('should toggle card', () => {
            const index = 0;
            expect(component.playerCardList[index].isActive).toBeFalse();

            component.toggleCard(index);
            expect(component.playerCardList[index].isActive).toBeTrue();

            component.playerCardList[index].isActive = true;
            component.toggleCard(index);
            expect(component.playerCardList[index].isActive).toBeTrue();
        });

        it('should hover card', () => {
            const index = 0;
            component.playerCardList[index].isActive = false;
            component.hoverCard(index);
            expect(component.playerCardList[index].isActive).toBeTrue();
        });

        it('should unhover card', () => {
            const index = 0;
            component.playerCardList[index].isActive = true;
            component.unhoverCard(index);
            expect(component.playerCardList[index].isActive).toBeFalse();
        });

        it('should return players from gameManager getter', () => {
            expect(component.players).toEqual([player1]);
        });

        it('should find player index correctly', () => {
            expect(component.findPlayerIndex(player1)).toBe(0);
            expect(component.findPlayerIndex(player2)).toBe(1);
        });

        it('should return -1 when player is not found', () => {
            const nonExistentPlayer = new Player('non-existent');
            expect(component.findPlayerIndex(nonExistentPlayer)).toBe(-1);
        });
    });

    describe('with real playerCardList getter', () => {
        let component: ActionsHudComponent;
        let fixture: ComponentFixture<ActionsHudComponent>;

        beforeEach(() => {
            fixture = TestBed.createComponent(ActionsHudComponent);
            component = fixture.componentInstance;
            fixture.detectChanges();
        });

        it('should compute playerCardList correctly from gameManager', () => {
            const list = component.playerCardList;
            expect(list.length).toBe(2);

            const activeCard = list[0];
            expect(activeCard.player).toBe(player1);
            expect(activeCard.isActive).toBeTrue();
            expect(activeCard.isHost).toBeTrue();
            expect(activeCard.isDisconnected).toBeFalse();

            const disconnectedCard = list[1];
            expect(disconnectedCard.player.id).toBe(player2.id);
            expect(disconnectedCard.isActive).toBeFalse();
            expect(disconnectedCard.isHost).toBeFalse();
            expect(disconnectedCard.isDisconnected).toBeTrue();
        });
    });
});

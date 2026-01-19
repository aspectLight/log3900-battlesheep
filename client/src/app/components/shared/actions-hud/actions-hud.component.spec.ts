import { provideHttpClient } from '@angular/common/http';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { Player } from '@app/classes/entity/player';
import { PlayerCard } from '@app/interfaces/character.interface';
import { GameManagerService } from '@app/services/state/game-manager.service';
import { ActionsHudComponent } from './actions-hud.component';

// Define two players for testing.
const player1 = new Player('player1');
const player2 = new Player('player2');
// Adding a player with team set
const player3 = new Player('player3');
player3.team = 1; // Explicitly setting team value
// Adding a disconnected player with team set
const player4 = new Player('player4');
player4.team = 2; // Explicitly setting team value for disconnected player

// Fake service to mimic GameManagerService.
class FakeGameManagerService {
    disconnectedPlayer: Player[] = [player2, player4];
    currentPlayerId = player1.id;
    room = { hostId: player1.id };
    playerWithFlag = player3.id;

    getPlayers(): Player[] {
        return [player1, player3]; // Include player with team
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
                    playerTeam: null,
                },
                {
                    player: player3,
                    isActive: false,
                    isHost: false,
                    playerColor: player3.color,
                    isDisconnected: false,
                    playerTeam: 1,
                    hasFlag: true,
                },
                {
                    player: player2,
                    isActive: false,
                    isHost: false,
                    playerColor: player2.color,
                    isDisconnected: true,
                    playerTeam: null,
                },
                {
                    player: player4,
                    isActive: false,
                    isHost: false,
                    playerColor: player4.color,
                    isDisconnected: true,
                    playerTeam: 2,
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
            expect(list.length).toBe(4);

            expect(list[0].player).toBe(player1);
            expect(list[0].isActive).toBeFalse();
            expect(list[0].isHost).toBeTrue();
            expect(list[0].playerColor).toBe(player1.color);
            expect(list[0].isDisconnected).toBeFalse();
            expect(list[0].playerTeam).toBeNull();

            expect(list[1].player).toBe(player3);
            expect(list[1].isActive).toBeFalse();
            expect(list[1].isHost).toBeFalse();
            expect(list[1].playerColor).toBe(player3.color);
            expect(list[1].isDisconnected).toBeFalse();
            expect(list[1].playerTeam).toBe(1);
            expect(list[1].hasFlag).toBeTrue();

            expect(list[2].player).toBe(player2);
            expect(list[2].isActive).toBeFalse();
            expect(list[2].isHost).toBeFalse();
            expect(list[2].playerColor).toBe(player2.color);
            expect(list[2].isDisconnected).toBeTrue();
            expect(list[2].playerTeam).toBeNull();

            expect(list[3].player).toBe(player4);
            expect(list[3].isActive).toBeFalse();
            expect(list[3].isHost).toBeFalse();
            expect(list[3].playerColor).toBe(player4.color);
            expect(list[3].isDisconnected).toBeTrue();
            expect(list[3].playerTeam).toBe(2);
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
            expect(list.length).toBe(4); // Should now have 4 players

            const activeCard = list[0];
            expect(activeCard.player).toBe(player1);
            expect(activeCard.isActive).toBeTrue();
            expect(activeCard.isHost).toBeTrue();
            expect(activeCard.isDisconnected).toBeFalse();
            expect(activeCard.playerTeam).toBeNull(); // No team set

            const teamCard = list[1];
            expect(teamCard.player).toBe(player3);
            expect(teamCard.isActive).toBeFalse();
            expect(teamCard.playerTeam).toBe(1); // Team should be set to 1
            expect(teamCard.hasFlag).toBeTrue(); // Should have flag

            const disconnectedCard = list[2];
            expect(disconnectedCard.player.id).toBe(player2.id);
            expect(disconnectedCard.isActive).toBeFalse();
            expect(disconnectedCard.isHost).toBeFalse();
            expect(disconnectedCard.isDisconnected).toBeTrue();
            expect(disconnectedCard.playerTeam).toBeNull(); // No team set

            const disconnectedTeamCard = list[3];
            expect(disconnectedTeamCard.player).toBe(player4);
            expect(disconnectedTeamCard.isActive).toBeFalse();
            expect(disconnectedTeamCard.isHost).toBeFalse();
            expect(disconnectedTeamCard.isDisconnected).toBeTrue();
            expect(disconnectedTeamCard.playerTeam).toBe(2); // Team should be set to 2
        });
    });
});

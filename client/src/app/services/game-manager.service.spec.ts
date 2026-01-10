/* eslint-disable max-lines */
import { provideHttpClient } from '@angular/common/http';
import { fakeAsync, TestBed, tick } from '@angular/core/testing';
import { Router } from '@angular/router';
import { GameManagerService } from './game-manager.service';

import { Board } from '@app/classes/board';
import { Cell } from '@app/classes/cell';
import { Game } from '@app/classes/game';
import { Item } from '@app/classes/item';
import { Player } from '@app/classes/player';
import { Tile } from '@app/classes/tile';
import { Room } from '@app/interfaces/room';
import { of, Subject } from 'rxjs';
import { environment } from 'src/environments/environment';
import { GameRoomService } from './game-room.service';
import { PathService } from './path.service';

// Constants to avoid magic numbers
const BOARD_SIZE = 10;
const DELAY_MS = 3000;
const MOVEMENT_NUMBER = 3000;

const dummyTile = new Tile('snow');
const dummyCell = new Cell(dummyTile, 0, 0);
const dummyBoard = new Board(BOARD_SIZE);
dummyBoard.matrix = [[dummyCell]];

const dummyPlayer = new Player('player1');
const dummyPlayer2 = new Player('player2');

const dummyGame: Game = {
    _id: 'game1',
    name: 'Test Game',
    description: 'desc',
    mode: 'test',
    board: dummyBoard,
    isVisible: true,
    modificationDate: Date.now().toString(),
} as unknown as Game;

const fakeRoom: Room = {
    roomId: 'roomX',
    gameId: 'gameX',
    organisatorId: 'player1',
    players: [dummyPlayer, dummyPlayer2],
    isLocked: false,
    isDebugging: false,
};
const httpClientSpy = jasmine.createSpyObj('HttpClient', ['get']);
const routerSpy = jasmine.createSpyObj('Router', ['navigate']);
const fakeRoom$: Subject<Room> = new Subject<Room>();
const gameRoomServiceSpy = jasmine.createSpyObj('GameRoomService', [], {
    room$: fakeRoom$,
    room: fakeRoom,
    disconnectedPlayer: [],
});
const pathServiceSpy = jasmine.createSpyObj('PathService', [
    'setPathFromCoord',
    'setSelectedPathFromCoords',
    'setPaths',
    'getAllCellsFromPaths',
    'clearService',
    'getSelectedPathAsCoords',
]);
pathServiceSpy.selectedPath = [];
pathServiceSpy.paths = new Map();
pathServiceSpy.getAllCellsFromPaths.and.returnValue([dummyCell]);
pathServiceSpy.getSelectedPathAsCoords.and.returnValue([{ x: 0, y: 0 }]);

const movementServiceSpy = jasmine.createSpyObj(
    'MovementService',
    ['movePlayer', 'stopPlayer', 'movePlayerFromPath', 'teleportPlayer', 'selectPlayer'],
    {
        selectedPlayer: dummyPlayer,
        currentPlayerId: dummyPlayer.id,
    },
);

describe('GameManagerService', () => {
    let service: GameManagerService;

    beforeEach(() => {
        TestBed.configureTestingModule({
            providers: [
                GameManagerService,
                provideHttpClient(),
                { provide: Router, useValue: routerSpy },
                { provide: GameRoomService, useValue: gameRoomServiceSpy },
                { provide: PathService, useValue: pathServiceSpy },
            ],
        });
        service = TestBed.inject(GameManagerService);
        fakeRoom$.next(fakeRoom);
        service.room = fakeRoom;
        service['board'] = dummyBoard;
        service['mainPlayer'] = dummyPlayer;
        service.movementService = movementServiceSpy;
        service['http'] = httpClientSpy;
        jasmine.clock().install();
    });

    afterEach(() => {
        jasmine.clock().uninstall();
    });

    it('should be created', () => {
        expect(service).toBeTruthy();
    });

    describe('isPlayerTurn getter', () => {
        it('should return false if mainPlayer is undefined', () => {
            service['mainPlayer'] = undefined;
            expect(service.isPlayerTurn).toBeFalse();
        });
        it('should return true if current player equals mainPlayer', () => {
            service['mainPlayer'] = dummyPlayer;
            service['currentPlayerSubject'].next(dummyPlayer);
            expect(service.isPlayerTurn).toBeTrue();
        });
        it('should return false if current player is different', () => {
            const otherPlayer = { id: 'other', movementPoints: 0, actionPoints: 0 } as unknown as Player;
            service['mainPlayer'] = dummyPlayer;
            service['currentPlayerSubject'].next(otherPlayer);
            expect(service.isPlayerTurn).toBeFalse();
        });
    });

    describe('isDebugMode getter', () => {
        it('should return room.isDebugging', () => {
            fakeRoom.isDebugging = true;
            expect(service.isDebugMode).toBeTrue();
            fakeRoom.isDebugging = false;
            expect(service.isDebugMode).toBeFalse();
        });
    });

    describe('getGame', () => {
        it('should return the game', () => {
            service['game'] = dummyGame;
            expect(service.getGame()._id).toBe(dummyGame._id);
        });
    });

    describe('cancelGame', () => {
        it('should set isGameCanceled to true', () => {
            service.cancelGame();
            expect(service.isGameCanceled).toBeTrue();
        });
    });

    describe('finishGame', () => {
        it('should set isGameFinished to true, navigate to /home after delay and then set isGameFinished to false', () => {
            service.finishGame();
            expect(service.isGameFinished).toBeTrue();
            jasmine.clock().tick(DELAY_MS);
            expect(routerSpy.navigate).toHaveBeenCalledWith(['/home']);
            expect(service.isGameFinished).toBeFalse();
        });
    });

    describe('addPlayersToBoard', () => {
        let testCell: Cell;
        let playerToAdd: Player;
        beforeEach(() => {
            testCell = new Cell(new Tile('snow'), 0, 0);
            testCell.item = new Item('spawnPoint');
            spyOn(testCell, 'addEntity');
            spyOn(testCell, 'getEntity').and.returnValue(null);
            spyOn(dummyBoard, 'getCell').and.returnValue(testCell);
            spyOn(service, 'getBoard').and.returnValue(dummyBoard);
            playerToAdd = new Player('playerToAdd');
            playerToAdd.spawnPoint = { x: testCell.x, y: testCell.y };
            spyOn(playerToAdd, 'addCell');
        });
        it('should reset variables', () => {
            service.isGameLoaded = true;
            service.resetManager();
            expect(service.isGameLoaded).toBeFalse();
            expect(service.isGameCanceled).toBeFalse();
            expect(service.isGameFinished).toBeFalse();
            expect(service.canPlayerMove).toBeFalse();
            expect(service.disconnectedPlayer).toEqual([]);
        });
        it('should add player and return true if cell exists and free', () => {
            const result = service.addPlayersToBoard([playerToAdd]);
            expect(result).toBeTrue();
            expect(testCell.getEntity).toHaveBeenCalled();
        });
        it('should return false if cell not found', () => {
            dummyBoard.getCell = jasmine.createSpy('getCell').and.returnValue(null);
            const result = service.addPlayersToBoard([playerToAdd]);
            expect(result).toBeFalse();
        });
        it('should return false if cell already has an entity', () => {
            testCell.getEntity = jasmine.createSpy('getEntity').and.returnValue({});
            const result = service.addPlayersToBoard([playerToAdd]);
            expect(result).toBeFalse();
        });
        it('should clear spawnPoint items in board matrix', () => {
            dummyBoard.matrix = [[testCell]];
            service.addPlayersToBoard([playerToAdd]);
            expect(testCell.item).toBeNull();
        });
    });

    describe('movePlayer', () => {
        it('should call movementService.movePlayer with board, dx and dy', () => {
            movementServiceSpy.movePlayer.and.returnValue(true);
            const result = service.movePlayer(1, 2);
            expect(movementServiceSpy.movePlayer).toHaveBeenCalledWith(dummyBoard, 1, 2);
            expect(result).toBeTrue();
        });
    });

    describe('getBoard', () => {
        it('should return the board', () => {
            expect(service.getBoard().matrix).toBe(dummyBoard.matrix);
        });
    });

    describe('get player', () => {
        it('should return player by id', () => {
            const board = service.getBoard();
            spyOn(board, 'getPlayerById').and.returnValue(dummyPlayer);
            service.getPlayerById(dummyPlayer.id);
            expect(board.getPlayerById).toHaveBeenCalledWith(dummyPlayer.id);
        });
        it('should return room.players', () => {
            expect(service.getPlayers().length).toEqual(fakeRoom.players.length);
        });
    });

    describe('getMainPlayer', () => {
        it('should return mainPlayer', () => {
            expect(service.getMainPlayer()?.id).toBe(dummyPlayer.id);
        });
    });

    describe('getCurrentPlayer', () => {
        it('should return an observable of currentPlayer', (done) => {
            service.getCurrentPlayer().subscribe((p) => {
                expect(p.id).toBeDefined();
                done();
            });
        });
    });

    describe('getRoomId', () => {
        it('should return room.roomId', () => {
            expect(service.getRoomId()).toBe(fakeRoom.roomId);
        });
    });

    describe('stopPlayer', () => {
        it('should call movementService.stopPlayer', () => {
            service.stopPlayer(dummyPlayer);
            expect(movementServiceSpy.stopPlayer).toHaveBeenCalledWith(dummyPlayer);
        });
    });

    describe('setMainPlayer', () => {
        it('should set mainPlayer if player is found in room.players', () => {
            spyOn(Player, 'fromObject').and.callThrough();
            service.setMainPlayer(dummyPlayer.id);
            expect(service.getMainPlayer()?.id).toEqual(dummyPlayer.id);
            expect(Player.fromObject).toHaveBeenCalledWith(dummyPlayer);
        });
        it('should not change mainPlayer if player not found', () => {
            spyOn(Player, 'fromObject');
            service.setMainPlayer('nonexistent');
            expect(service.getMainPlayer()?.id).toBe(dummyPlayer.id);
            expect(Player.fromObject).not.toHaveBeenCalled();
        });
    });

    describe('getIsGameLoaded', () => {
        it('should return isGameLoaded', () => {
            expect(service.getIsGameLoaded()).toBeDefined();
        });
    });

    describe('fetchGame', () => {
        it('should call http.get with the correct URL', () => {
            const gameId = 'testGameId';
            httpClientSpy.get.and.returnValue(of(dummyGame));

            service.fetchGame(gameId).subscribe((game) => {
                expect(game).toEqual(dummyGame);
            });

            expect(httpClientSpy.get).toHaveBeenCalledWith(environment.serverUrl + '/games/' + gameId);
        });
    });

    describe('redirect', () => {
        it('should navigate to /game', () => {
            service.redirect();
            expect(routerSpy.navigate).toHaveBeenCalledWith(['/game']);
        });
    });

    describe('selected player and path setters', () => {
        it('should set currentPlayerId', () => {
            service.setPlayer(dummyPlayer);
            expect(movementServiceSpy.currentPlayerId).toBe(dummyPlayer.id);
        });
        it('set selected path from coords', () => {
            service.setPathFromCoord({ x: 0, y: 0 });
            expect(pathServiceSpy.setPathFromCoord).toHaveBeenCalledWith({ x: 0, y: 0 }, service.getBoard());
        });
        it('should set SelectedPathFromCoords', () => {
            service.setSelectedPathFromCoords([{ x: 0, y: 0 }]);
            expect(pathServiceSpy.setSelectedPathFromCoords).toHaveBeenCalledWith([{ x: 0, y: 0 }], service.getBoard());
        });
        it('should set paths', () => {
            service.setPaths(new Map());
            expect(pathServiceSpy.setPaths).toHaveBeenCalledWith(new Map());
        });
        it('should clear paths', () => {
            service.clearPaths();
            expect(pathServiceSpy.clearService).toHaveBeenCalled();
        });
    });

    describe('getCurrentPlayer', () => {
        it('should return an observable that emits the current player', (done) => {
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (service as any).currentPlayerSubject.next(dummyPlayer);
            service.getCurrentPlayer().subscribe((p) => {
                expect(p).toEqual(dummyPlayer);
                done();
            });
        });
    });

    describe('updateCurrentPlayer', () => {
        it('should update currentPlayerSubject with the provided player', (done) => {
            // Create a test player
            const testPlayer = new Player('testPlayer');

            // Subscribe to the currentPlayer observable to verify it emits the new player
            service.getCurrentPlayer().subscribe((player) => {
                if (player.id === testPlayer.id) {
                    expect(player).toEqual(testPlayer);
                    done();
                }
            });

            // Call the private updateCurrentPlayer method
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (service as any).updateCurrentPlayer(testPlayer);
        });
    });

    describe('startTurn', () => {
        it('should update current player and set isMainPlayerTurn to true when player is mainPlayer', () => {
            // Spy on the private updateCurrentPlayer method
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            spyOn<any>(service, 'updateCurrentPlayer');

            // Call startTurn with the main player
            service.startTurn(dummyPlayer);

            // Verify updateCurrentPlayer was called with the player
            expect(service['updateCurrentPlayer']).toHaveBeenCalledWith(dummyPlayer);

            // Verify isMainPlayerTurn is set to true
            expect(service.isMainPlayerTurn).toBeTrue();
        });

        it('should update current player and set isMainPlayerTurn to false when player is not mainPlayer', () => {
            // Spy on the private updateCurrentPlayer method
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            spyOn<any>(service, 'updateCurrentPlayer');

            // Call startTurn with a different player
            service.startTurn(dummyPlayer2);

            // Verify updateCurrentPlayer was called with the player
            expect(service['updateCurrentPlayer']).toHaveBeenCalledWith(dummyPlayer2);

            // Verify isMainPlayerTurn is set to false
            expect(service.isMainPlayerTurn).toBeFalse();
        });
    });

    describe('handleTurnStarting', () => {
        it('should set notifications and call startTurn after the calculated delay', fakeAsync(() => {
            spyOn(service, 'clearPaths');
            spyOn(service, 'startTurn');
            const testPlayer = { id: 'player1', name: 'TestPlayer' } as unknown as Player;
            const now = Date.now();
            const startTime = now + DELAY_MS;
            jasmine.clock().mockDate(new Date(now));

            service.handleTurnStarting(testPlayer, startTime);
            expect(service.clearPaths).toHaveBeenCalled();
            expect(service.notificationMessage).toContain('TestPlayer');
            expect(service.isNotificationVisible).toBeTrue();
            expect(service.notificationDuration).toBe(startTime - now);

            tick(DELAY_MS);
            expect(service.startTurn).toHaveBeenCalledWith(testPlayer);
            expect(service.isNotificationVisible).toBeFalse();
        }));
    });

    describe('movePlayerFromPath', () => {
        it('should call movementService.movePlayerFromPath with board and selectedPath', async () => {
            spyOn(service, 'resetPlayerSelection');
            movementServiceSpy.movePlayerFromPath.and.returnValue(Promise.resolve());

            await service.movePlayerFromPath();

            expect(movementServiceSpy.movePlayerFromPath).toHaveBeenCalledWith(dummyBoard, pathServiceSpy.selectedPath);
            expect(service.resetPlayerSelection).toHaveBeenCalled();
        });
        it('should call the callback function after moving player from path', async () => {
            spyOn(service, 'resetPlayerSelection');
            movementServiceSpy.movePlayerFromPath.and.returnValue(Promise.resolve());
            const callback = jasmine.createSpy('callback');

            await service.movePlayerFromPath(callback);

            expect(movementServiceSpy.movePlayerFromPath).toHaveBeenCalledWith(dummyBoard, pathServiceSpy.selectedPath);
            expect(service.resetPlayerSelection).toHaveBeenCalled();
            expect(callback).toHaveBeenCalled();
        });
        it('should not throw an error if callback is not provided', async () => {
            spyOn(service, 'resetPlayerSelection');
            movementServiceSpy.movePlayerFromPath.and.returnValue(Promise.resolve());

            await expectAsync(service.movePlayerFromPath()).toBeResolved();

            expect(movementServiceSpy.movePlayerFromPath).toHaveBeenCalledWith(dummyBoard, pathServiceSpy.selectedPath);
            expect(service.resetPlayerSelection).toHaveBeenCalled();
        });
    });

    describe('teleportPlayer', () => {
        it('should call movementService.teleportPlayer with board and destination', () => {
            spyOn(service, 'resetPlayerSelection');
            service.teleportPlayer(1, 2);

            expect(movementServiceSpy.teleportPlayer).toHaveBeenCalledWith(dummyBoard, 1, 2);
            expect(service.resetPlayerSelection).toHaveBeenCalled();
        });
    });

    describe('getMoveInfo', () => {
        it('should return all cells from paths', () => {
            const cells = service.getMoveInfo();
            expect(cells).toEqual({
                roomId: fakeRoom.roomId,
                playerId: dummyPlayer.id,
                map: pathServiceSpy.paths,
                selectedPath: pathServiceSpy.getSelectedPathAsCoords(),
            });
        });

        it('should return undefined if no player is selected', () => {
            // Create a new spy object with selectedPlayer as null
            const nullPlayerMovementSpy = jasmine.createSpyObj(
                'MovementService',
                ['movePlayer', 'stopPlayer', 'movePlayerFromPath', 'teleportPlayer', 'selectPlayer'],
                { selectedPlayer: null },
            );

            // Replace the service's movementService with our new spy
            service.movementService = nullPlayerMovementSpy;

            // Now the getMoveInfo should return undefined
            expect(service.getMoveInfo()).toBeUndefined();
        });
    });

    describe('player selection and points setting', () => {
        it('should call movementService.selectPlayer', () => {
            service.selectPlayer(dummyPlayer);
            expect(movementServiceSpy.selectPlayer).toHaveBeenCalledWith(dummyPlayer);
        });
        it('should reset player selection', () => {
            service.resetPlayerSelection();
            expect(movementServiceSpy.selectedPlayer).toBe(dummyPlayer);
        });
        it('should set movement points', () => {
            service.setMovementPoints(MOVEMENT_NUMBER);
            const mainPlayer = service.getMainPlayer();
            expect(mainPlayer?.movementPoints).toBe(MOVEMENT_NUMBER);
        });
        it('should set action points', () => {
            service.setActionPoints(MOVEMENT_NUMBER);
            const mainPlayer = service.getMainPlayer();
            expect(mainPlayer?.actionPoints).toBe(MOVEMENT_NUMBER);
        });
        it('should set main player health', () => {
            const mainPlayer = service.getMainPlayer();
            if (mainPlayer) spyOn(mainPlayer, 'setStatValue');
            service.setMainPlayerHealth(MOVEMENT_NUMBER);
            expect(mainPlayer?.setStatValue).toHaveBeenCalledWith('health', MOVEMENT_NUMBER);
        });
    });
    describe('disconnectPlayer', () => {
        it('should remove player from room and add to disconnectedPlayer', () => {
            spyOn(service, 'removePlayer');
            service.disconnectPlayer(dummyPlayer.id);
            expect(service.room.players.find((p) => p.id === dummyPlayer.id)).toBeUndefined();
            expect(service.disconnectedPlayer.find((p) => p.id === dummyPlayer.id)).toBeDefined();
            expect(service.removePlayer).toHaveBeenCalledWith(dummyPlayer.id);
        });
        it('should not remove player if playerId is not found', () => {
            service.room = fakeRoom;
            spyOn(service, 'removePlayer');
            spyOn(service.getBoard(), 'getPlayerById').and.returnValue(null);
            service.disconnectPlayer('player5');
            expect(service.removePlayer).not.toHaveBeenCalled();
        });
    });

    describe('removePlayer', () => {
        it('should remove player entity from cell', () => {
            dummyPlayer.cell = dummyCell;
            spyOn(dummyCell, 'removeEntity');
            spyOn(dummyCell, 'getEntity').and.returnValue(dummyPlayer);
            spyOn(service.getBoard(), 'getPlayerById').and.returnValue(dummyPlayer);

            service.removePlayer(dummyPlayer.id);

            expect(dummyCell.removeEntity).toHaveBeenCalled();
        });
        it('should not remove entity if player is not found', () => {
            spyOn(service.getBoard(), 'getPlayerById').and.returnValue(null);
            spyOn(dummyCell, 'removeEntity');

            service.removePlayer('nonexistent');

            expect(dummyCell.removeEntity).not.toHaveBeenCalled();
        });
        it('should not remove entity if player cell is not found', () => {
            spyOn(service.getBoard(), 'getPlayerById').and.returnValue(dummyPlayer);
            spyOn(dummyCell, 'getEntity').and.returnValue(null);
            spyOn(dummyCell, 'removeEntity');

            service.removePlayer(dummyPlayer.id);

            expect(dummyCell.removeEntity).not.toHaveBeenCalled();
        });
        it('should not remove entity if cell entity is not the player', () => {
            spyOn(dummyCell, 'removeEntity');
            spyOn(dummyCell, 'getEntity').and.returnValue(dummyPlayer2);
            spyOn(service.getBoard(), 'getPlayerById').and.returnValue(dummyPlayer);

            service.removePlayer(dummyPlayer.id);

            expect(dummyCell.removeEntity).not.toHaveBeenCalled();
        });
    });
    describe('updateScore', () => {
        it('should increment fightsWon for the player and return the updated score', () => {
            service.room.players = [dummyPlayer];
            const initialFightsWon = dummyPlayer.fightsWon;
            const updatedScore = service.updateScore(dummyPlayer.id);
            expect(updatedScore).toBe(initialFightsWon + 1);
            expect(dummyPlayer.fightsWon).toBe(initialFightsWon + 1);
        });
        it('should return 0 if the player is not found', () => {
            const updatedScore = service.updateScore('nonexistent');
            expect(updatedScore).toBe(0);
        });
    });
    describe('isPlayerTurnOver', () => {
        it('should return true if mainPlayer movementPoints and actionPoints are 0', () => {
            dummyPlayer.movementPoints = 0;
            dummyPlayer.actionPoints = 0;
            expect(service.isPlayerTurnOver()).toBeTrue();
        });
        it('should return false if mainPlayer movementPoints are not 0', () => {
            dummyPlayer.movementPoints = 1;
            dummyPlayer.actionPoints = 0;
            expect(service.isPlayerTurnOver()).toBeFalse();
        });
        it('should return false if mainPlayer actionPoints are not 0', () => {
            dummyPlayer.movementPoints = 0;
            dummyPlayer.actionPoints = 1;
            expect(service.isPlayerTurnOver()).toBeFalse();
        });
        it('should return false if mainPlayer is undefined', () => {
            service['mainPlayer'] = undefined;
            expect(service.isPlayerTurnOver()).toBeFalse();
        });
    });
});

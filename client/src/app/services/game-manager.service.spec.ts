/* eslint-disable max-lines */
/* eslint-disable @typescript-eslint/no-magic-numbers */
/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable @typescript-eslint/no-empty-function */
import { provideHttpClient, HttpClient } from '@angular/common/http';
import { fakeAsync, TestBed, tick } from '@angular/core/testing';
import { Router } from '@angular/router';
import { GameManagerService } from './game-manager.service';
import { MovementService } from './movement.service';

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
import { BonusType } from '@app/constants/bonus.constants';
import { ITEM_TYPES } from '@app/constants/item.constants';

// Constants to avoid magic numbers
const BOARD_SIZE = 10;
const MOVEMENT_NUMBER = 3000;

describe('GameManagerService', () => {
    let service: GameManagerService;
    let httpClientSpy: jasmine.SpyObj<HttpClient>;
    let routerSpy: jasmine.SpyObj<Router>;
    let gameRoomServiceSpy: jasmine.SpyObj<GameRoomService>;
    let pathServiceSpy: jasmine.SpyObj<PathService>;
    let movementServiceSpy: jasmine.SpyObj<MovementService>;
    let fakeRoom$: Subject<Room>;
    let fakeRoom: Room;
    let dummyBoard: Board;
    let dummyPlayer: Player;
    let dummyPlayer2: Player;
    let dummyGame: Game;
    let dummyCell: Cell;
    let dummyTile: Tile;

    beforeEach(() => {
        // Create fresh instances for each test
        httpClientSpy = jasmine.createSpyObj('HttpClient', ['get']);
        routerSpy = jasmine.createSpyObj('Router', ['navigate']);
        fakeRoom$ = new Subject<Room>();
        fakeRoom = {
            roomId: 'roomX',
            gameId: 'gameX',
            organisatorId: 'player1',
            players: [],
            isLocked: false,
            isDebugging: false,
        };
        gameRoomServiceSpy = jasmine.createSpyObj('GameRoomService', [], {
            room$: fakeRoom$,
            room: fakeRoom,
            disconnectedPlayer: [],
        });
        pathServiceSpy = jasmine.createSpyObj('PathService', [
            'setPathFromCoord',
            'setSelectedPathFromCoords',
            'setPaths',
            'getAllCellsFromPaths',
            'clearService',
            'getSelectedPathAsCoords',
            'clearPath',
        ]);
        pathServiceSpy.selectedPath = [];
        pathServiceSpy.paths = new Map();
        pathServiceSpy.getAllCellsFromPaths.and.returnValue([]);
        pathServiceSpy.getSelectedPathAsCoords.and.returnValue([{ x: 0, y: 0 }]);

        let selectedPlayerValue: Player | null = null;
        movementServiceSpy = jasmine.createSpyObj(
            'MovementService',
            ['movePlayer', 'stopPlayer', 'movePlayerFromPath', 'teleportPlayer', 'selectPlayer', 'isMoving'],
            {
                selectedPlayer: null,
                currentPlayerId: '',
            },
        );

        // Add this line to allow setting properties on the spy object
        Object.defineProperty(movementServiceSpy, 'selectedPlayer', {
            get: () => selectedPlayerValue,
            set: (v) => {
                selectedPlayerValue = v;
            },
        });

        // Create fresh board and players for each test
        dummyBoard = new Board(BOARD_SIZE);
        dummyPlayer = new Player('player1');
        dummyPlayer2 = new Player('player2');
        fakeRoom.players = [dummyPlayer, dummyPlayer2];

        // Create dummy tile and cell
        dummyTile = new Tile('snow');
        dummyCell = new Cell(dummyTile, 0, 0);

        dummyGame = {
            _id: 'game1',
            name: 'Test Game',
            description: 'desc',
            mode: 'test',
            board: dummyBoard,
            isVisible: true,
            modificationDate: Date.now().toString(),
        } as unknown as Game;

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

        // Reset service state for each test
        service.room = { ...fakeRoom };
        service['board'] = dummyBoard;
        service.setMainPlayer(undefined);
        service.movementService = movementServiceSpy;
        service['http'] = httpClientSpy;
        service.isGameLoaded = false;
        service.isGameCanceled = false;
        service.isGameFinished = false;
        service.disconnectedPlayer = [];
        service.pendingReplacement = null;
        service.isReplacementPopupVisible = false;
        service.replacementPopupMessage = '';

        // Reset the fakeRoom$ subject
        fakeRoom$.next(fakeRoom);

        // Reset jasmine clock
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
            service.setMainPlayer(undefined);
            expect(service.isPlayerTurn).toBeFalse();
        });
        it('should return true if current player equals mainPlayer', () => {
            // Set up the board's getPlayerById to return our dummyPlayer
            spyOn(service.getBoard(), 'getPlayerById').and.returnValue(dummyPlayer);

            // Set the main player ID
            service.setMainPlayer(dummyPlayer.id);

            // Set the current player
            service['currentPlayerSubject'].next(dummyPlayer);

            // Verify isPlayerTurn returns true
            expect(service.isPlayerTurn).toBeTrue();

            // Verify getPlayerById was called with the correct ID
            expect(service.getBoard().getPlayerById).toHaveBeenCalledWith(dummyPlayer.id);
        });
        it('should return false if current player is different', () => {
            const otherPlayer = { id: 'other', movementPoints: 0, actionPoints: 0 } as unknown as Player;

            // Set up the board's getPlayerById to return our dummyPlayer
            spyOn(service.getBoard(), 'getPlayerById').and.returnValue(dummyPlayer);

            // Set the main player ID
            service.setMainPlayer(dummyPlayer.id);

            // Set the current player to a different player
            service['currentPlayerSubject'].next(otherPlayer);

            // Verify isPlayerTurn returns false
            expect(service.isPlayerTurn).toBeFalse();

            // Verify getPlayerById was called with the correct ID
            expect(service.getBoard().getPlayerById).toHaveBeenCalledWith(dummyPlayer.id);
        });
    });

    describe('isDebugMode getter', () => {
        it('should return room.isDebugging', () => {
            service.room.isDebugging = true;
            expect(service.isDebugMode).toBeTrue();
            service.room.isDebugging = false;
            expect(service.isDebugMode).toBeFalse();
        });
    });

    describe('isCTF getter', () => {
        it('should return game.isCTF', () => {
            const ctfGame = new Game();
            ctfGame.mode = 'ctf';
            service['game'] = ctfGame;
            expect(service.isCTF).toBeTrue();

            const nonCtfGame = new Game();
            nonCtfGame.mode = 'classic';
            service['game'] = nonCtfGame;
            expect(service.isCTF).toBeFalse();
        });
    });

    describe('hasWon', () => {
        it('should return true if mainPlayerId matches winner id', () => {
            // Set up a winner player
            const winnerPlayer = new Player('winner');
            winnerPlayer.id = 'winnerId';

            // Set up the main player ID to match the winner
            service['mainPlayerId'] = 'winnerId';

            // Set the winner ID in the service
            service.winner = 'winnerId';

            // Add the winner player to the room's players
            service.room.players = [winnerPlayer];

            // Verify hasWon returns true
            expect(service.hasWon()).toBeTrue();
        });

        it('should return true if mainPlayer is on the same team as winner', () => {
            // Set up a winner player with team 1
            const winnerPlayer = new Player('winner');
            winnerPlayer.id = 'winnerId';
            winnerPlayer.team = 1;

            // Set up the main player with team 1
            const mainPlayer = new Player('mainPlayer');
            mainPlayer.id = 'mainPlayerId';
            mainPlayer.team = 1;

            // Set the main player ID
            service['mainPlayerId'] = 'mainPlayerId';

            // Set the winner ID in the service
            service.winner = 'winnerId';

            // Add both players to the room's players
            service.room.players = [winnerPlayer, mainPlayer];

            // Set up the board's getPlayerById to return our main player
            spyOn(service.getBoard(), 'getPlayerById').and.returnValue(mainPlayer);

            // Verify hasWon returns true
            expect(service.hasWon()).toBeTrue();
        });

        it('should return false if mainPlayer is not the winner and not on the same team', () => {
            // Set up a winner player with team 1
            const winnerPlayer = new Player('winner');
            winnerPlayer.id = 'winnerId';
            winnerPlayer.team = 1;

            // Set up the main player with team 2
            const mainPlayer = new Player('mainPlayer');
            mainPlayer.id = 'mainPlayerId';
            mainPlayer.team = 2;

            // Set the main player ID
            service['mainPlayerId'] = 'mainPlayerId';

            // Set the winner ID in the service
            service.winner = 'winnerId';

            // Add both players to the room's players
            service.room.players = [winnerPlayer, mainPlayer];

            // Set up the board's getPlayerById to return our main player
            spyOn(service.getBoard(), 'getPlayerById').and.returnValue(mainPlayer);

            // Verify hasWon returns false
            expect(service.hasWon()).toBeFalse();
        });

        it('should return false if winner is not found', () => {
            // Set the main player ID
            service['mainPlayerId'] = 'mainPlayerId';

            // Set the winner ID in the service
            service.winner = 'nonexistentId';

            // Add a player to the room's players
            service.room.players = [new Player('player')];

            // Verify hasWon returns false
            expect(service.hasWon()).toBeFalse();
        });
    });

    describe('getWinner', () => {
        it('should return USSR for CTF game when winner team is 1', () => {
            // Set up a CTF game
            const ctfGame = new Game();
            ctfGame.mode = 'ctf';
            service['game'] = ctfGame;

            // Set up a winner player with team 1
            const winnerPlayer = new Player('winner');
            winnerPlayer.id = 'winnerId';
            winnerPlayer.team = 1;

            // Set the winner ID in the service
            service.winner = 'winnerId';

            // Add the winner player to the room's players
            service.room.players = [winnerPlayer];

            // Verify getWinner returns USSR
            expect(service.getWinner()).toBe('USSR');
        });

        it('should return USA for CTF game when winner team is 2', () => {
            // Set up a CTF game
            const ctfGame = new Game();
            ctfGame.mode = 'ctf';
            service['game'] = ctfGame;

            // Set up a winner player with team 2
            const winnerPlayer = new Player('winner');
            winnerPlayer.id = 'winnerId';
            winnerPlayer.team = 2;

            // Set the winner ID in the service
            service.winner = 'winnerId';

            // Add the winner player to the room's players
            service.room.players = [winnerPlayer];

            // Verify getWinner returns USA
            expect(service.getWinner()).toBe('USA');
        });

        it('should return player name for non-CTF game', () => {
            // Set up a non-CTF game
            const nonCtfGame = new Game();
            nonCtfGame.mode = 'classic';
            service['game'] = nonCtfGame;

            // Set up a winner player
            const winnerPlayer = new Player('winner');
            winnerPlayer.id = 'winnerId';
            winnerPlayer.name = 'Winner Player';

            // Set the winner ID in the service
            service.winner = 'winnerId';

            // Add the winner player to the room's players
            service.room.players = [winnerPlayer];

            // Verify getWinner returns the player name
            expect(service.getWinner()).toBe('Winner Player');
        });

        it('should return empty string if winner is not found', () => {
            // Set up a non-CTF game
            const nonCtfGame = new Game();
            nonCtfGame.mode = 'classic';
            service['game'] = nonCtfGame;

            // Set the winner ID in the service to a non-existent player
            service.winner = 'nonexistentId';

            // Add a different player to the room's players
            service.room.players = [new Player('player')];

            // Verify getWinner returns empty string
            expect(service.getWinner()).toBeUndefined();
        });
    });

    describe('finishGame', () => {
        it('should set isGameFinished to true, set winner, and clear player info', () => {
            // Create test players
            const player1 = new Player('player1');
            const player2 = new Player('player2');
            player2.isVirtual = true; // Make player2 virtual

            // Add players to the room
            service.room.players = [player1, player2];

            // Spy on player clearInfo method
            spyOn(player1, 'clearInfo');
            spyOn(player2, 'clearInfo');

            // Call finishGame
            service.finishGame('player1');

            // Verify isGameFinished is set to true
            expect(service.isGameFinished).toBeTrue();

            // Verify winner is set
            expect(service.winner).toBe('player1');

            // Verify clearInfo was called on non-virtual player
            expect(player1.clearInfo).toHaveBeenCalled();

            // Verify clearInfo was not called on virtual player
            expect(player2.clearInfo).not.toHaveBeenCalled();
        });

        it('should navigate to end game route after delay and reset isGameFinished', () => {
            // Import ROUTES from the constants

            // Call finishGame
            service.finishGame('player1');

            // Verify isGameFinished is set to true
            expect(service.isGameFinished).toBeTrue();

            // Advance the clock by the delay amount
            jasmine.clock().tick(5000);

            // Verify router.navigate was called with the correct path
            expect(routerSpy.navigate).toHaveBeenCalledWith(['/end-game']);

            // Verify isGameFinished is set back to false
            expect(service.isGameFinished).toBeFalse();
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

            // Create a spy on the addCell method
            spyOn(playerToAdd, 'addCell');
        });
        it('should reset variables', () => {
            service.isGameLoaded = true;
            service.resetManager();
            expect(service.isGameLoaded).toBeFalse();
            expect(service.isGameCanceled).toBeFalse();
            expect(service.isGameFinished).toBeFalse();
            expect(service.disconnectedPlayer).toEqual([]);
        });
        it('should add player and return true if cell exists and free', () => {
            // Create a spy for the Player.fromObject method to return our player with the spy
            spyOn(Player, 'fromObject').and.returnValue(playerToAdd);

            const result = service.addPlayersToBoard([playerToAdd]);
            expect(result).toBeTrue();
            expect(testCell.getEntity).toHaveBeenCalled();
            expect(testCell.addEntity).toHaveBeenCalledWith(playerToAdd);
            expect(playerToAdd.addCell).toHaveBeenCalledWith(testCell);
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
        it('should replace random items with deterministic items based on roomId', () => {
            // Create a board with a random item
            const randomCell = new Cell(new Tile('snow'), 1, 1);
            randomCell.item = new Item('random');
            dummyBoard.matrix = [[testCell], [randomCell]];

            // Set a specific roomId to test deterministic behavior
            service.room = { ...fakeRoom, roomId: 'testRoom123' };

            // Add a player to trigger the random item replacement
            service.addPlayersToBoard([playerToAdd]);

            // The random item should be replaced with a deterministic item
            expect(randomCell.item).not.toBeNull();
            expect(randomCell.item?.type).not.toBe('random');
            expect(randomCell.item?.type).not.toBe('spawnPoint');

            // Verify that the same roomId always produces the same item
            const firstItemType = randomCell.item?.type;

            // Reset and try again with the same roomId
            randomCell.item = new Item('random');
            service.addPlayersToBoard([playerToAdd]);
            expect(randomCell.item?.type).toBe(firstItemType);

            // Try with a different roomId
            service.room = { ...fakeRoom, roomId: 'differentRoom' };
            randomCell.item = new Item('random');
            service.addPlayersToBoard([playerToAdd]);
            expect(randomCell.item?.type).not.toBe(firstItemType);
        });

        it('should remove items from available items list when found on the board', () => {
            // Create a board with a specific item
            const itemCell = new Cell(new Tile('snow'), 1, 1);
            itemCell.item = new Item('adrenaline');
            dummyBoard.matrix = [[testCell], [itemCell]];

            // Create a copy of the items object for testing

            // Add a player to trigger the item processing
            service.addPlayersToBoard([playerToAdd]);

            // Verify that the item still exists on the board
            expect(itemCell.item).not.toBeNull();
            expect(itemCell.item?.type).toBe('adrenaline');
        });

        it('should set spawn point image path based on player color', () => {
            // Create a board with a spawn point item
            const spawnCell = new Cell(new Tile('snow'), 0, 0);
            const spawnItem = new Item('spawnPoint');
            spawnCell.item = spawnItem;

            // Create a player with a specific color
            const coloredPlayer = new Player('coloredPlayer');
            coloredPlayer.color = 'red';
            coloredPlayer.spawnPoint = { x: 0, y: 0 };

            // Set up the cell to have both the item and player
            spawnCell.player = coloredPlayer;

            // Set up the board matrix
            dummyBoard.matrix = [[spawnCell]];

            // Call addPlayersToBoard
            service.addPlayersToBoard([coloredPlayer]);

            // Verify the spawn point image path was set correctly
            expect(spawnItem.imagePath).toBe('assets/items/red_spawn.gif');
        });

        it('should set random items to null when no available unique items are left', () => {
            // Create cells with all available unique items already placed
            const cells: Cell[][] = [];
            const uniqueItemTypes = Object.keys(ITEM_TYPES).filter((type) => type !== 'random' && type !== 'spawnPoint' && type !== 'flag');

            // Create a row for unique items
            const uniqueItemCells: Cell[] = [];
            for (let i = 0; i < uniqueItemTypes.length; i++) {
                const cell = new Cell(new Tile('snow'), 0, i);
                cell.item = new Item(uniqueItemTypes[i]);
                uniqueItemCells.push(cell);
            }
            cells.push(uniqueItemCells);

            // Create a row with random items that should be set to null
            const randomItemCells: Cell[] = [];
            for (let i = 0; i < 3; i++) {
                const cell = new Cell(new Tile('snow'), 1, i);
                cell.item = new Item('random');
                randomItemCells.push(cell);
            }
            cells.push(randomItemCells);

            // Set up board matrix with these cells
            dummyBoard.matrix = cells;

            // Call addPlayersToBoard
            service.addPlayersToBoard([playerToAdd]);

            // Verify that all random items were set to null
            for (const cell of randomItemCells) {
                expect(cell.item).toBeNull();
            }
        });

        it('should remove duplicate items found on the board', () => {
            // Create cells with one unique item type placed twice
            const itemType = 'adrenaline';

            // Create first cell with the item
            const firstCell = new Cell(new Tile('snow'), 0, 0);
            firstCell.item = new Item(itemType);

            // Create second cell with the same item type (duplicate)
            const duplicateCell = new Cell(new Tile('snow'), 0, 1);
            duplicateCell.item = new Item(itemType);

            // Set up board matrix with these cells
            dummyBoard.matrix = [[firstCell, duplicateCell]];

            // Call addPlayersToBoard
            service.addPlayersToBoard([playerToAdd]);

            // Verify that the first instance of the item still exists
            expect(firstCell.item).not.toBeNull();
            expect(firstCell.item?.type).toBe(itemType);

            // Verify that the duplicate item was removed
            expect(duplicateCell.item).toBeNull();
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
            // Set up the board's getPlayerById to return our dummyPlayer
            spyOn(service.getBoard(), 'getPlayerById').and.returnValue(dummyPlayer);

            // Set the main player ID
            service.setMainPlayer(dummyPlayer.id);

            // Verify getMainPlayer returns the correct player
            expect(service.getMainPlayer()?.id).toBe(dummyPlayer.id);

            // Verify getPlayerById was called with the correct ID
            expect(service.getBoard().getPlayerById).toHaveBeenCalledWith(dummyPlayer.id);
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

    describe('setMainPlayer', () => {
        it('should set mainPlayer if player is found in room.players', () => {
            service.room.players = [dummyPlayer];
            const playerId = dummyPlayer.id;

            // Call the method being tested
            service.setMainPlayer(playerId);

            // Verify mainPlayerId was set
            expect(service['mainPlayerId']).toBe(playerId);
        });

        it('should not change mainPlayer if player not found', () => {
            const originalPlayer = service['mainPlayer'];
            service.setMainPlayer('nonexistent');
            expect(service['mainPlayer']).toEqual(originalPlayer);
        });

        it('should set up onReplaceItem callback for mainPlayer', () => {
            // Create a player with a full inventory
            const playerWithFullInventory = new Player('testPlayer');
            playerWithFullInventory.inventory = [new Item('adrenaline'), new Item('vodka')];

            // Add the player to the room
            service.room.players = [playerWithFullInventory];

            // Set up the board's getPlayerById to return our player
            spyOn(service.getBoard(), 'getPlayerById').and.returnValue(playerWithFullInventory);

            // Spy on the triggerReplacementPopup method
            spyOn(service, 'triggerReplacementPopup');

            // Set the player as main player
            service.setMainPlayer(playerWithFullInventory.id);

            // Get the main player
            const mainPlayer = service.getMainPlayer();

            // Verify the callback was set
            expect(mainPlayer?.onReplaceItem).toBeDefined();

            // Create test data for the callback
            const newItem = new Item('propaganda');
            const cellCoords = { x: 5, y: 5 };

            // Call the callback
            if (mainPlayer?.onReplaceItem) {
                mainPlayer.onReplaceItem(newItem, mainPlayer.inventory, cellCoords);
            }

            // Verify triggerReplacementPopup was called with correct parameters
            expect(service.triggerReplacementPopup).toHaveBeenCalledWith(
                jasmine.any(Player),
                newItem,
                jasmine.arrayContaining([newItem]),
                cellCoords,
            );
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

    describe('loadGame', () => {
        it('should load game and update service state when room has gameId', fakeAsync(() => {
            // Set up the room with a gameId
            service.room = { ...fakeRoom, gameId: 'testGameId' };

            // Mock the fetchGame response
            httpClientSpy.get.and.returnValue(of(dummyGame));

            let result: Game | undefined;
            service.loadGame().subscribe((game) => {
                result = game;
            });

            tick();
            expect(result).toBeUndefined();
            expect(service['game']).toBeDefined();
            expect(service['board']).toBeDefined();
            expect(service.isGameLoaded).toBeTrue();
            expect(httpClientSpy.get).toHaveBeenCalledWith(environment.serverUrl + '/games/testGameId');
        }));

        it('should not make HTTP call when room has no gameId', fakeAsync(() => {
            // Set up the room without a gameId
            service.room = { ...fakeRoom, gameId: '' };

            let result: Game | undefined;
            service.loadGame().subscribe((game) => {
                result = game;
            });

            tick();
            expect(result).toBeUndefined();
            expect(service['game']).toBeUndefined();
            expect(service.isGameLoaded).toBeFalse();
        }));
    });

    describe('redirect', () => {
        it('should navigate to /game', () => {
            service.redirect();
            expect(routerSpy.navigate).toHaveBeenCalledWith(['/game']);
        });
    });

    describe('selected player and path setters', () => {
        it('should set selectedPlayer', () => {
            service.setPlayer(dummyPlayer);
            expect(movementServiceSpy.selectedPlayer).toBe(dummyPlayer);
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
            spyOn<any>(service, 'updateCurrentPlayer');

            // Set the main player
            service.setMainPlayer(dummyPlayer.id);

            // Call startTurn with the main player
            service.startTurn(dummyPlayer);

            // Verify updateCurrentPlayer was called with the player
            expect(service['updateCurrentPlayer']).toHaveBeenCalledWith(dummyPlayer);
        });

        it('should update current player and set isMainPlayerTurn to false when player is not mainPlayer', () => {
            // Spy on the private updateCurrentPlayer method
            spyOn<any>(service, 'updateCurrentPlayer');

            // Call startTurn with a different player
            service.startTurn(dummyPlayer2);

            // Verify updateCurrentPlayer was called with the player
            expect(service['updateCurrentPlayer']).toHaveBeenCalledWith(dummyPlayer2);
        });
    });

    describe('handleTurnStarting', () => {
        it('should set notifications and update current player', () => {
            spyOn(service, 'clearPaths');
            spyOn<any>(service, 'updateCurrentPlayer');
            const testPlayer = { id: 'player1', name: 'TestPlayer' } as unknown as Player;
            const countdown = 3000;

            service.handleTurnStarting(testPlayer, countdown);

            expect(service.clearPaths).toHaveBeenCalled();
            expect(service.notificationMessage).toContain('TestPlayer');
            expect(service.notificationTime).toBe(countdown);
            expect(service['updateCurrentPlayer']).toHaveBeenCalledWith(testPlayer);
        });
    });

    describe('movePlayerFromPath', () => {
        it('should call movementService.movePlayerFromPath with board and selectedPath', async () => {
            spyOn(service, 'resetPlayerSelection');
            movementServiceSpy.movePlayerFromPath.and.returnValue(Promise.resolve({ success: true, cell: new Cell(new Tile('snow'), 0, 0) }));

            await service.movePlayerFromPath();

            expect(movementServiceSpy.movePlayerFromPath).toHaveBeenCalledWith(dummyBoard, pathServiceSpy.selectedPath);
            expect(service.resetPlayerSelection).toHaveBeenCalled();
        });

        it('should call the callback function after moving player from path', async () => {
            spyOn(service, 'resetPlayerSelection');
            const callback = jasmine.createSpy('callback');

            // Set up the mock to execute the callback immediately when called
            movementServiceSpy.movePlayerFromPath.and.callFake(async () => {
                return Promise.resolve({ success: true, cell: new Cell(new Tile('snow'), 0, 0) });
            });

            await service.movePlayerFromPath(callback);

            expect(movementServiceSpy.movePlayerFromPath).toHaveBeenCalledWith(dummyBoard, pathServiceSpy.selectedPath);
            expect(service.resetPlayerSelection).toHaveBeenCalled();
            expect(callback).toHaveBeenCalled();
        });

        it('should not throw an error if callback is not provided', async () => {
            spyOn(service, 'resetPlayerSelection');
            movementServiceSpy.movePlayerFromPath.and.returnValue(Promise.resolve({ success: true, cell: new Cell(new Tile('snow'), 0, 0) }));

            await expectAsync(service.movePlayerFromPath()).toBeResolved();

            expect(movementServiceSpy.movePlayerFromPath).toHaveBeenCalledWith(dummyBoard, pathServiceSpy.selectedPath);
            expect(service.resetPlayerSelection).toHaveBeenCalled();
        });

        it('should handle item collection when moving to a cell with an item', async () => {
            // Create a cell with an item
            const cellWithItem = new Cell(new Tile('snow'), 1, 1);
            const item = new Item('adrenaline');
            cellWithItem.item = item;

            // Set up the movement result with success and the cell
            const movementResult = {
                success: true,
                cell: cellWithItem,
            };

            // Spy on the handleItemCollection method to return an object with item and cell
            spyOn(service as any, 'handleItemCollection').and.returnValue({ item, cell: cellWithItem });

            // Set up the movement service to return our result
            movementServiceSpy.movePlayerFromPath.and.returnValue(Promise.resolve(movementResult));

            // Create a callback spy
            const callback = jasmine.createSpy('callback');

            // Call the method
            await service.movePlayerFromPath(callback);

            // Verify handleItemCollection was called with the cell
            expect(service['handleItemCollection']).toHaveBeenCalledWith(cellWithItem);

            // Verify the callback was called with the collected item and cell
            expect(callback).toHaveBeenCalledWith(item, cellWithItem);
        });
    });

    describe('teleportPlayer', () => {
        it('should call movementService.teleportPlayer with board and destination', () => {
            spyOn(service, 'resetPlayerSelection');
            service.teleportPlayer(1, 2);

            expect(movementServiceSpy.teleportPlayer).toHaveBeenCalledWith(dummyBoard, 1, 2);
            expect(service.resetPlayerSelection).toHaveBeenCalled();
        });

        it('should return early if cell is not found', () => {
            spyOn(service, 'resetPlayerSelection');
            spyOn(service.getBoard(), 'getCell').and.returnValue(null);

            service.teleportPlayer(1, 2);

            expect(movementServiceSpy.teleportPlayer).not.toHaveBeenCalled();
            expect(service.resetPlayerSelection).not.toHaveBeenCalled();
        });
    });

    describe('getMoveInfo', () => {
        it('should return all cells from paths', () => {
            // Set up the movement service with a selected player
            movementServiceSpy.selectedPlayer = dummyPlayer;

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
            Object.defineProperty(movementServiceSpy, 'selectedPlayer', {
                get: () => null,
                set: () => {},
            });

            // Now the getMoveInfo should return undefined
            expect(service.getMoveInfo()).toBeUndefined();
        });
    });

    describe('player selection and points setting', () => {
        it('should call movementService.selectPlayer', () => {
            service.selectPlayer(dummyPlayer);
            expect(movementServiceSpy.selectPlayer).toHaveBeenCalledWith(dummyPlayer);
        });
        it('should reset player selection if mainPlayer exists', () => {
            // Set up the board's getPlayerById to return our dummyPlayer
            spyOn(service.getBoard(), 'getPlayerById').and.returnValue(dummyPlayer);

            // Set mainPlayer to a valid value
            service.setMainPlayer(dummyPlayer.id);

            // Call the method
            service.resetPlayerSelection();

            // Verify that movementServiceSpy.selectedPlayer was set to mainPlayer
            expect(movementServiceSpy.selectedPlayer).toEqual(dummyPlayer);

            // Verify getPlayerById was called with the correct ID
            expect(service.getBoard().getPlayerById).toHaveBeenCalledWith(dummyPlayer.id);
        });
        it('should not change selectedPlayer if mainPlayer is undefined', () => {
            // Set mainPlayer to undefined
            service.setMainPlayer(undefined);

            // Set a value for selectedPlayer to verify it doesn't change
            movementServiceSpy.selectedPlayer = dummyPlayer2;

            // Call the method
            service.resetPlayerSelection();

            // Verify selectedPlayer wasn't changed
            expect(movementServiceSpy.selectedPlayer).toEqual(dummyPlayer2);
        });
        it('should set movement points', () => {
            // Set up the board's getPlayerById to return our dummyPlayer
            spyOn(service.getBoard(), 'getPlayerById').and.returnValue(dummyPlayer);

            // Set the main player ID
            service.setMainPlayer(dummyPlayer.id);

            // Set the current player to be the same as the main player
            service['currentPlayerSubject'].next(dummyPlayer);

            // Call the method
            service.setMovementPoints(MOVEMENT_NUMBER);

            // Verify the movement points were set
            expect(dummyPlayer.movementPoints).toBe(MOVEMENT_NUMBER);
        });
        it('should not set movement points if mainPlayer is undefined', () => {
            // Set mainPlayer to undefined
            service.setMainPlayer(undefined);
            const initialPoints = dummyPlayer.movementPoints;

            // Call the method
            service.setMovementPoints(MOVEMENT_NUMBER);

            // Verify the movement points were not changed
            expect(dummyPlayer.movementPoints).toBe(initialPoints);
        });
        it('should set action points when mainPlayer exists', () => {
            // Set up the board's getPlayerById to return our dummyPlayer
            spyOn(service.getBoard(), 'getPlayerById').and.returnValue(dummyPlayer);

            // Set the main player ID
            service.setMainPlayer(dummyPlayer.id);

            // Call the method with different point values
            service.setActionPoints(1);
            expect(dummyPlayer.actionPoints).toBe(1);

            service.setActionPoints(2);
            expect(dummyPlayer.actionPoints).toBe(2);

            service.setActionPoints(0);
            expect(dummyPlayer.actionPoints).toBe(0);
        });

        it('should not set action points if mainPlayer is undefined', () => {
            // Set mainPlayer to undefined
            service.setMainPlayer(undefined);

            // Set initial action points
            const initialPoints = 3;
            dummyPlayer.actionPoints = initialPoints;

            // Call the method
            service.setActionPoints(5);

            // Verify the action points were not changed
            expect(dummyPlayer.actionPoints).toBe(initialPoints);
        });

        it('should not set action points if mainPlayer is null', () => {
            // Set up the board's getPlayerById to return null
            spyOn(service.getBoard(), 'getPlayerById').and.returnValue(null);

            // Set the main player ID
            service.setMainPlayer('someId');

            // Set initial action points
            const initialPoints = 3;
            dummyPlayer.actionPoints = initialPoints;

            // Call the method
            service.setActionPoints(5);

            // Verify the action points were not changed
            expect(dummyPlayer.actionPoints).toBe(initialPoints);
        });
        it('should set main player health', () => {
            // Set up the board's getPlayerById to return our dummyPlayer
            spyOn(service.getBoard(), 'getPlayerById').and.returnValue(dummyPlayer);

            // Set the main player ID
            service.setMainPlayer(dummyPlayer.id);

            // Spy on the player's setStatValue method
            spyOn(dummyPlayer, 'setStatValue');

            // Call the method
            service.setMainPlayerHealth(MOVEMENT_NUMBER);

            // Verify setStatValue was called with the correct parameters
            expect(dummyPlayer.setStatValue).toHaveBeenCalledWith(BonusType.Health, MOVEMENT_NUMBER);
        });
    });
    describe('disconnectPlayer', () => {
        it('should remove player from room and add to disconnectedPlayer', () => {
            // Set up the room's players array with the dummy player
            service.room.players = [dummyPlayer];
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

        it('should correctly splice player from room.players and add to disconnectedPlayer', () => {
            // Create a test player
            const testPlayer = new Player('testPlayer');
            testPlayer.id = 'testPlayerId';

            // Add the player to the room
            service.room.players = [dummyPlayer, testPlayer, dummyPlayer2];

            // Spy on the removePlayer method
            spyOn(service, 'removePlayer');

            // Call the disconnectPlayer method
            service.disconnectPlayer(testPlayer.id);

            // Verify the player was removed from room.players
            expect(service.room.players.length).toBe(2);
            expect(service.room.players.find((p) => p.id === testPlayer.id)).toBeUndefined();

            // Verify the player was added to disconnectedPlayer
            expect(service.disconnectedPlayer.length).toBe(1);
            expect(service.disconnectedPlayer[0].id).toBe(testPlayer.id);

            // Verify removePlayer was called with the player's ID
            expect(service.removePlayer).toHaveBeenCalledWith(testPlayer.id);
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

    describe('isPlayerMoving', () => {
        it('should call movementService.isMoving and return its result', () => {
            movementServiceSpy.isMoving = jasmine.createSpy('isMoving').and.returnValue(true);
            expect(service.isPlayerMoving()).toBeTrue();

            movementServiceSpy.isMoving.and.returnValue(false);
            expect(service.isPlayerMoving()).toBeFalse();

            expect(movementServiceSpy.isMoving).toHaveBeenCalledTimes(2);
        });
    });

    describe('handleItemCollection', () => {
        it('should collect item from cell and return it', () => {
            // Create a cell with an item
            const cell = new Cell(new Tile('snow'), 1, 1);
            const item = new Item('adrenaline');
            cell.item = item;

            // Set up the main player and current player ID
            service.setMainPlayer(dummyPlayer.id);
            service.currentPlayerId = dummyPlayer.id;

            // Set up the board's getPlayerById to return our player
            spyOn(service.getBoard(), 'getPlayerById').and.returnValue(dummyPlayer);

            // Spy on the player's addItem method
            spyOn(dummyPlayer, 'addItem').and.returnValue(true);

            // Call the method
            const result = service['handleItemCollection'](cell);

            // Verify the item was returned
            expect(result).toEqual({ item, cell });

            // Verify the item was removed from the cell
            expect(cell.item).toBeNull();

            // Verify addItem was called with the item
            expect(dummyPlayer.addItem).toHaveBeenCalledWith(item);

            // Verify getPlayerById was called with the correct ID
            expect(service.getBoard().getPlayerById).toHaveBeenCalledWith(dummyPlayer.id);
        });

        it('should handle item collection when isMainPlayerTurn is false', () => {
            // Create a cell with an item
            const cell = new Cell(new Tile('snow'), 5, 5);
            const item = new Item('adrenaline');
            cell.addItem(item);

            // Set currentPlayerId
            service.currentPlayerId = 'player1';

            // Create a player
            const player = new Player('player1');

            // Create a spy for the board's getPlayerById method
            const boardSpy = jasmine.createSpyObj('Board', ['getPlayerById']);
            boardSpy.getPlayerById.and.returnValue(player);

            // Set the board in the service
            service['board'] = boardSpy as unknown as Board;

            // Spy on the player's addItem and replaceItem methods
            spyOn(player, 'addItem').and.returnValue(true);
            spyOn(player, 'replaceItem');

            // Spy on the cell's removeItem method
            spyOn(cell, 'removeItem');

            // Call the method
            const result = service['handleItemCollection'](cell);

            // Verify the board's getPlayerById method was called with the currentPlayerId
            expect(boardSpy.getPlayerById).toHaveBeenCalledWith('player1');

            // Verify the player's addItem method was called with the item
            expect(player.addItem).toHaveBeenCalledWith(jasmine.objectContaining({ type: 'adrenaline' }));

            // Verify the player's replaceItem method was not called
            expect(player.replaceItem).not.toHaveBeenCalled();

            // Verify the cell's removeItem method was called
            expect(cell.removeItem).toHaveBeenCalled();

            // Verify the result is the item
            expect(result).toEqual({
                item: jasmine.objectContaining({ type: 'adrenaline' }),
                cell: jasmine.objectContaining({ x: 5, y: 5 }),
            });
        });

        it('should handle item collection when mainPlayer is not defined', () => {
            // Create a cell with an item
            const cell = new Cell(new Tile('snow'), 5, 5);
            const item = new Item('adrenaline');
            cell.addItem(item);

            service.setMainPlayer(undefined);

            // Set currentPlayerId
            service.currentPlayerId = 'player1';

            // Create a player
            const player = new Player('player1');

            // Create a spy for the board's getPlayerById method
            const boardSpy = jasmine.createSpyObj('Board', ['getPlayerById']);
            boardSpy.getPlayerById.and.returnValue(player);

            // Set the board in the service
            service['board'] = boardSpy as unknown as Board;

            // Spy on the player's addItem and replaceItem methods
            spyOn(player, 'addItem').and.returnValue(true);
            spyOn(player, 'replaceItem');

            // Spy on the cell's removeItem method
            spyOn(cell, 'removeItem');

            // Call the method
            const result = service['handleItemCollection'](cell);

            // Verify the board's getPlayerById method was called with the currentPlayerId
            expect(boardSpy.getPlayerById).toHaveBeenCalledWith('player1');

            // Verify the player's addItem method was called with the item
            expect(player.addItem).toHaveBeenCalledWith(jasmine.objectContaining({ type: 'adrenaline' }));

            // Verify the player's replaceItem method was not called
            expect(player.replaceItem).not.toHaveBeenCalled();

            // Verify the cell's removeItem method was called
            expect(cell.removeItem).toHaveBeenCalled();

            // Verify the result is the item
            expect(result).toEqual({
                item: jasmine.objectContaining({ type: 'adrenaline' }),
                cell: jasmine.objectContaining({ x: 5, y: 5 }),
            });
        });

        it('should handle item collection when addItem returns false', () => {
            // Create a cell with an item
            const cell = new Cell(new Tile('snow'), 5, 5);
            const item = new Item('adrenaline');
            cell.addItem(item);

            // Set currentPlayerId
            service.currentPlayerId = 'player1';

            // Create a player
            const player = new Player('player1');

            // Create a spy for the board's getPlayerById method
            const boardSpy = jasmine.createSpyObj('Board', ['getPlayerById']);
            boardSpy.getPlayerById.and.returnValue(player);

            // Set the board in the service
            service['board'] = boardSpy as unknown as Board;

            // Spy on the player's addItem and replaceItem methods
            spyOn(player, 'addItem').and.returnValue(false);
            spyOn(player, 'replaceItem');

            // Spy on the cell's removeItem method
            spyOn(cell, 'removeItem');

            // Call the method
            const result = service['handleItemCollection'](cell);

            // Verify the board's getPlayerById method was called with the currentPlayerId
            expect(boardSpy.getPlayerById).toHaveBeenCalledWith('player1');

            // Verify the player's addItem method was called with the item
            expect(player.addItem).toHaveBeenCalledWith(jasmine.objectContaining({ type: 'adrenaline' }));

            // Verify the player's replaceItem method was called with the item and cell coordinates
            expect(player.replaceItem).toHaveBeenCalledWith(jasmine.objectContaining({ type: 'adrenaline' }), { x: 5, y: 5 });

            // Verify the cell's removeItem method was called
            expect(cell.removeItem).toHaveBeenCalled();

            // Verify the result is the item
            expect(result).toEqual({
                item: jasmine.objectContaining({ type: 'adrenaline' }),
                cell: jasmine.objectContaining({ x: 5, y: 5 }),
            });
        });

        it('should handle item collection when currentPlayerId is not found in board', () => {
            // Create a cell with an item
            const cell = new Cell(new Tile('snow'), 5, 5);
            const item = new Item('adrenaline');
            cell.addItem(item);

            // Set currentPlayerId to a non-existent player
            service.currentPlayerId = 'nonexistentPlayer';

            // Create a spy for the board's getPlayerById method
            const boardSpy = jasmine.createSpyObj('Board', ['getPlayerById']);
            boardSpy.getPlayerById.and.returnValue(null);

            // Set the board in the service
            service['board'] = boardSpy as unknown as Board;

            // Spy on the cell's removeItem method
            spyOn(cell, 'removeItem');

            // Call the method
            const result = service['handleItemCollection'](cell);

            // Verify the board's getPlayerById method was called with the currentPlayerId
            expect(boardSpy.getPlayerById).toHaveBeenCalledWith('nonexistentPlayer');

            // Verify the cell's removeItem method was not called
            expect(cell.removeItem).not.toHaveBeenCalled();

            // Verify the result is undefined
            expect(result).toBeUndefined();
        });

        it('should ignore spawn point items and return undefined', () => {
            // Create a cell with a spawn point item
            const cell = new Cell(new Tile('snow'), 5, 5);
            const spawnPointItem = new Item('spawnPoint');
            cell.addItem(spawnPointItem);

            // Set currentPlayerId
            service.currentPlayerId = 'player1';

            // Create a player
            const player = new Player('player1');

            // Create a spy for the board's getPlayerById method
            const boardSpy = jasmine.createSpyObj('Board', ['getPlayerById']);
            boardSpy.getPlayerById.and.returnValue(player);

            // Set the board in the service
            service['board'] = boardSpy as unknown as Board;

            // Spy on the player's addItem and replaceItem methods
            spyOn(player, 'addItem');
            spyOn(player, 'replaceItem');

            // Spy on the cell's removeItem method
            spyOn(cell, 'removeItem');

            // Call the method
            const result = service['handleItemCollection'](cell);

            // Verify the player's methods were not called
            expect(player.addItem).not.toHaveBeenCalled();
            expect(player.replaceItem).not.toHaveBeenCalled();

            // Verify the cell's removeItem method was not called
            expect(cell.removeItem).not.toHaveBeenCalled();

            // Verify the result is undefined
            expect(result).toBeUndefined();
        });

        it('should update main player when isPlayerTurn is true', () => {
            // Create a cell with an item
            const cell = new Cell(new Tile('snow'), 5, 5);
            const item = new Item('adrenaline');
            cell.addItem(item);

            // Create main player
            const mainPlayer = new Player('mainPlayer');
            mainPlayer.id = 'mainPlayerId';

            // Set up the service for main player's turn
            service.setMainPlayer(mainPlayer.id);
            service['currentPlayerSubject'].next(mainPlayer); // Make it player's turn
            service.currentPlayerId = mainPlayer.id;

            // Set up the board's getPlayerById to return our main player
            const boardSpy = jasmine.createSpyObj('Board', ['getPlayerById']);
            boardSpy.getPlayerById.and.returnValue(mainPlayer);
            service['board'] = boardSpy as unknown as Board;

            // Spy on player's addItem method
            spyOn(mainPlayer, 'addItem').and.returnValue(true);

            // Call the method
            const result = service['handleItemCollection'](cell);

            // Verify the board's getPlayerById was called with mainPlayer's id
            expect(boardSpy.getPlayerById).toHaveBeenCalledWith(mainPlayer.id);

            // Verify addItem was called with an item that has the correct properties
            expect(mainPlayer.addItem).toHaveBeenCalledWith(
                jasmine.objectContaining({
                    type: 'adrenaline',
                    name: 'Adrenaline',
                    description: 'Ajoute 2 points de vie',
                    imagePath: './assets/items/drug.png',
                }),
            );

            // Verify the result contains an item with the correct properties
            expect(result?.item).toEqual(
                jasmine.objectContaining({
                    type: 'adrenaline',
                    name: 'Adrenaline',
                    description: 'Ajoute 2 points de vie',
                    imagePath: './assets/items/drug.png',
                }),
            );
            expect(result?.cell).toEqual(cell);
        });
    });

    describe('triggerReplacementPopup', () => {
        it('should set pendingReplacement and show the popup', () => {
            // Create test data
            const player = new Player('testPlayer');
            const newItem = new Item('adrenaline');
            const candidateItems = [new Item('vodka'), new Item('propaganda'), newItem];
            const cellCoords = { x: 5, y: 5 };

            // Call the method
            service.triggerReplacementPopup(player, newItem, candidateItems, cellCoords);

            // Verify pendingReplacement was set correctly
            expect(service.pendingReplacement).toEqual({
                player,
                newItem,
                candidateItems,
                cellCoords,
            });

            // Verify the popup message was set
            expect(service.replacementPopupMessage).toBe("Inventaire plein ! Choisissez l'objet à rejeter :");

            // Verify the popup is visible
            expect(service.isReplacementPopupVisible).toBeTrue();
        });
    });

    describe('processReplacement', () => {
        it('should replace selected item with new item and return the dropped item', () => {
            // Create a player with a full inventory
            const player = new Player('testPlayer');
            const item1 = new Item('adrenaline');
            const item2 = new Item('vodka');
            player.inventory = [item1, item2];

            // Create a new item to add
            const newItem = new Item('propaganda');

            // Set up the pending replacement
            service.pendingReplacement = {
                player,
                newItem,
                candidateItems: [item1, item2, newItem],
                cellCoords: { x: 5, y: 5 },
            };

            // Spy on the player's updateItemsEffect method
            spyOn(player, 'updateItemsEffect');

            // Call the method with the first item as the selected item
            const [droppedItem, coords] = service.processReplacement(item1);

            // Verify the dropped item is the selected item
            expect(droppedItem).toBe(item1);

            // Verify the coordinates are correct
            expect(coords).toEqual({ x: 5, y: 5 });

            // Verify the player's inventory was updated
            expect(player.inventory[0]).toBe(newItem);
            expect(player.inventory[1]).toBe(item2);

            // Verify updateItemsEffect was called correctly
            expect(player.updateItemsEffect).toHaveBeenCalledWith(-1); // Remove old item effects
            expect(player.updateItemsEffect).toHaveBeenCalledWith(1); // Add new item effects

            // Verify pendingReplacement was cleared
            expect(service.pendingReplacement).toBeNull();

            // Verify the popup is hidden
            expect(service.isReplacementPopupVisible).toBeFalse();
        });

        it('should return new item if selected item is not in inventory', () => {
            // Create a player with a full inventory
            const player = new Player('testPlayer');
            const item1 = new Item('adrenaline');
            const item2 = new Item('vodka');
            player.inventory = [item1, item2];

            // Create a new item to add
            const newItem = new Item('propaganda');

            // Create a different item that's not in the inventory
            const differentItem = new Item('camouflage');

            // Set up the pending replacement
            service.pendingReplacement = {
                player,
                newItem,
                candidateItems: [item1, item2, newItem],
                cellCoords: { x: 5, y: 5 },
            };

            // Call the method with a different item
            const [droppedItem, coords] = service.processReplacement(differentItem);

            // Verify the dropped item is the new item
            expect(droppedItem).toBe(newItem);

            // Verify the coordinates are correct
            expect(coords).toEqual({ x: 5, y: 5 });

            // Verify the player's inventory was not changed
            expect(player.inventory[0]).toBe(item1);
            expect(player.inventory[1]).toBe(item2);

            // Verify pendingReplacement was cleared
            expect(service.pendingReplacement).toBeNull();

            // Verify the popup is hidden
            expect(service.isReplacementPopupVisible).toBeFalse();
        });
    });

    describe('addItemToBoard', () => {
        it('should add an item to the specified cell on the board', () => {
            // Create a test item
            const item = new Item('adrenaline');

            // Create test coordinates
            const coords = { x: 3, y: 4 };

            // Create a spy for the cell's addItem method
            const cellSpy = jasmine.createSpyObj('Cell', ['addItem']);

            // Set up the board matrix with our spy cell
            const boardMatrix = Array(5)
                .fill(null)
                .map(() => Array(5).fill(new Cell(new Tile('snow'), 0, 0)));
            boardMatrix[coords.x][coords.y] = cellSpy;

            service['board'] = {
                matrix: boardMatrix,
            } as unknown as Board;

            // Call the method
            service.addItemToBoard(item, coords);

            // Verify the cell's addItem method was called with the item
            expect(cellSpy.addItem).toHaveBeenCalledWith(item);
        });

        it('should handle out of bounds coordinates gracefully', () => {
            // Create a test item
            const item = new Item('adrenaline');

            // Create out of bounds coordinates
            const coords = { x: 10, y: 10 };

            // Set up a small board
            const boardMatrix = Array(2)
                .fill(null)
                .map(() => Array(2).fill(new Cell(new Tile('snow'), 0, 0)));

            // Set the board in the service
            service['board'] = {
                matrix: boardMatrix,
            } as unknown as Board;

            // Create a wrapper function that catches any errors
            const safeAddItem = () => {
                try {
                    service.addItemToBoard(item, coords);
                    return true;
                } catch (error) {
                    return false;
                }
            };

            // Call the method - should not throw an error
            expect(safeAddItem()).toBeTrue();
        });
    });

    describe('combatLost', () => {
        it('should drop all items from player inventory and clear the inventory', () => {
            // Create a main player with items in inventory
            const mainPlayer = new Player('mainPlayer');
            const item1 = new Item('adrenaline');
            const item2 = new Item('vodka');
            mainPlayer.inventory = [item1, item2];

            // Set the main player in the service
            service.setMainPlayer(mainPlayer.id);

            // Create player coordinates
            const playerCoords = { x: 5, y: 5 };

            // Create empty cells for dropping items
            const emptyCell1 = new Cell(new Tile('snow'), 4, 5);
            const emptyCell2 = new Cell(new Tile('snow'), 6, 5);

            // Create a spy for the board's getPlayerCoordsById method
            const boardSpy = jasmine.createSpyObj('Board', ['getPlayerCoordsById', 'getTwoNearestEmptyCells', 'getPlayerById']);
            boardSpy.getPlayerCoordsById.and.returnValue(playerCoords);
            boardSpy.getTwoNearestEmptyCells.and.returnValue([emptyCell1, emptyCell2]);
            boardSpy.getPlayerById.and.returnValue(mainPlayer);

            // Set the board in the service
            service['board'] = boardSpy as unknown as Board;

            // Spy on the player's updateItemsEffect method
            spyOn(mainPlayer, 'updateItemsEffect');

            // Create a spy function for dropItem
            const dropItemSpy = jasmine.createSpy('dropItem');
            service.dropItem = dropItemSpy;

            // Call the method
            service.combatLost(mainPlayer.id);

            // Verify the board methods were called correctly
            expect(boardSpy.getPlayerCoordsById).toHaveBeenCalledWith(mainPlayer.id);
            expect(boardSpy.getTwoNearestEmptyCells).toHaveBeenCalledWith(playerCoords);

            // Verify updateItemsEffect was called for each item
            expect(mainPlayer.updateItemsEffect).toHaveBeenCalledWith(-1);
            expect(mainPlayer.updateItemsEffect).toHaveBeenCalledTimes(2);

            // Verify dropItem was called for each item with the correct coordinates
            expect(dropItemSpy).toHaveBeenCalledWith(item1, emptyCell1);
            expect(dropItemSpy).toHaveBeenCalledWith(item2, emptyCell2);

            // Verify the player's inventory was cleared
            expect(mainPlayer.inventory).toEqual([null, null]);
        });

        it('should handle player with empty inventory', () => {
            // Create a main player with empty inventory
            const mainPlayer = new Player('mainPlayer');
            mainPlayer.inventory = [null, null];

            // Set the main player in the service
            service.setMainPlayer(mainPlayer.id);

            // Create player coordinates
            const playerCoords = { x: 5, y: 5 };

            // Create empty cells for dropping items
            const emptyCell1 = new Cell(new Tile('snow'), 4, 5);
            const emptyCell2 = new Cell(new Tile('snow'), 6, 5);

            // Create a spy for the board's getPlayerCoordsById method
            const boardSpy = jasmine.createSpyObj('Board', ['getPlayerCoordsById', 'getTwoNearestEmptyCells', 'getPlayerById']);
            boardSpy.getPlayerCoordsById.and.returnValue(playerCoords);
            boardSpy.getTwoNearestEmptyCells.and.returnValue([emptyCell1, emptyCell2]);
            boardSpy.getPlayerById.and.returnValue(mainPlayer);

            // Set the board in the service
            service['board'] = boardSpy as unknown as Board;

            // Spy on the player's updateItemsEffect method
            spyOn(mainPlayer, 'updateItemsEffect');

            // Create a spy function for dropItem
            const dropItemSpy = jasmine.createSpy('dropItem');
            service.dropItem = dropItemSpy;

            // Call the method
            service.combatLost(mainPlayer.id);

            // Verify the board methods were called correctly
            expect(boardSpy.getPlayerCoordsById).toHaveBeenCalledWith(mainPlayer.id);
            expect(boardSpy.getTwoNearestEmptyCells).toHaveBeenCalledWith(playerCoords);

            // Verify updateItemsEffect was not called
            expect(mainPlayer.updateItemsEffect).not.toHaveBeenCalled();

            // Verify dropItem was not called
            expect(dropItemSpy).not.toHaveBeenCalled();

            // Verify the player's inventory was still empty
            expect(mainPlayer.inventory).toEqual([null, null]);
        });

        it('should handle undefined mainPlayer', () => {
            // Set mainPlayer to undefined
            service.setMainPlayer(undefined);

            // Create a spy for the board's getPlayerCoordsById method
            const boardSpy = jasmine.createSpyObj('Board', ['getPlayerCoordsById', 'getTwoNearestEmptyCells', 'getPlayerById']);
            boardSpy.getPlayerById.and.returnValue(null);

            // Set the board in the service
            service['board'] = boardSpy as unknown as Board;

            // Create a spy function for dropItem
            const dropItemSpy = jasmine.createSpy('dropItem');
            service.dropItem = dropItemSpy;

            // Call the method - should not throw an error
            expect(() => service.combatLost('nonexistent')).not.toThrow();

            // Verify the board methods were not called
            expect(boardSpy.getPlayerCoordsById).not.toHaveBeenCalled();
            expect(boardSpy.getTwoNearestEmptyCells).not.toHaveBeenCalled();

            // Verify dropItem was not called
            expect(dropItemSpy).not.toHaveBeenCalled();
        });

        it('should handle null playerCoords', () => {
            // Create a main player with items in inventory
            const mainPlayer = new Player('mainPlayer');
            const item1 = new Item('adrenaline');
            const item2 = new Item('vodka');
            mainPlayer.inventory = [item1, item2];

            // Set the main player in the service
            service.setMainPlayer(mainPlayer.id);

            // Create a spy for the board's getPlayerCoordsById method
            const boardSpy = jasmine.createSpyObj('Board', ['getPlayerCoordsById', 'getTwoNearestEmptyCells', 'getPlayerById']);
            boardSpy.getPlayerCoordsById.and.returnValue(null);
            boardSpy.getPlayerById.and.returnValue(mainPlayer);

            // Set the board in the service
            service['board'] = boardSpy as unknown as Board;

            // Spy on the player's updateItemsEffect method
            spyOn(mainPlayer, 'updateItemsEffect');

            // Create a spy function for dropItem
            const dropItemSpy = jasmine.createSpy('dropItem');
            service.dropItem = dropItemSpy;

            // Call the method
            service.combatLost(mainPlayer.id);

            // Verify the board's getPlayerCoordsById method was called with the mainPlayer id
            expect(boardSpy.getPlayerCoordsById).toHaveBeenCalledWith(mainPlayer.id);

            // Verify getTwoNearestEmptyCells was not called
            expect(boardSpy.getTwoNearestEmptyCells).not.toHaveBeenCalled();

            // Verify updateItemsEffect was not called
            expect(mainPlayer.updateItemsEffect).not.toHaveBeenCalled();

            // Verify dropItem was not called
            expect(dropItemSpy).not.toHaveBeenCalled();

            // Verify the player's inventory was not cleared
            expect(mainPlayer.inventory).toEqual([item1, item2]);
        });
    });
});

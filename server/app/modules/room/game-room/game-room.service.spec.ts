/* eslint-disable @typescript-eslint/no-empty-function */
/* eslint-disable max-lines */
/* eslint-disable @typescript-eslint/no-explicit-any */
import { Game } from '@app/modules/game/schemas/game.schema';
import { GameService } from '@app/modules/game/services/game.service';
import { GameMovementService } from '@app/modules/movement/services/game-movement.service';
import { COUNTDOWN_INTERVAL } from '@app/modules/shared-room/constants/game-room.constants';
import { GameRoom } from '@app/modules/shared-room/interfaces/game-room';
import { Player } from '@app/shared/interfaces/player';
import { GameRoomEvents } from '@common/socket.constants';
import { Test, TestingModule } from '@nestjs/testing';
import { SinonStubbedInstance, createStubInstance, stub } from 'sinon';
import { GameRoomService } from './game-room.service';
const TEST_ROOM = {
    roomId: 'test_room',
    gameId: 'test_game',
    hostId: 'test_host',
    players: [
        {
            id: 'test_player',
            stats: {
                health: { maxValue: 100, value: 100, description: 'Health points' },
                speed: { maxValue: 10, value: 10, description: 'Movement points' },
                attack: { maxValue: 10, value: 10, description: 'Attack points' },
                defense: { maxValue: 10, value: 10, description: 'Defense points' },
            },
            inventory: [],
            position: { x: 0, y: 0 },
        },
    ],
    isLocked: false,
    isDebugging: false,
    turnTimer: undefined,
    timeRemaining: undefined,
    messages: [],
    journalEntries: [],
    playersStats: [],
    globalStats: {
        gameDuration: '00:00',
        turns: 0,
        doorsToggled: [],
    },
    startTime: new Date(),
} as GameRoom;
let gameService: SinonStubbedInstance<GameService>;

describe('GameRoomService', () => {
    let service: GameRoomService;
    let fakeServer: any;
    let testRoom;
    gameService = createStubInstance<GameService>(GameService);
    const mockGameMovementService = { removeItemFromBoard: jest.fn(), addItemToBoard: jest.fn() };

    beforeEach(async () => {
        testRoom = JSON.parse(JSON.stringify(TEST_ROOM));
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                GameRoomService,
                { provide: GameService, useValue: gameService },
                { provide: GameMovementService, useValue: mockGameMovementService },
            ],
        }).compile();

        service = module.get<GameRoomService>(GameRoomService);

        fakeServer = {
            to: jest.fn().mockReturnThis(),
            emit: jest.fn(),
        };
        service.setServer(fakeServer);
        service['gameRooms'] = [testRoom];
    });

    describe('Create GameRoom', () => {
        it('should create a room with a waiting room', async () => {
            const waitingRoom: GameRoom = {
                roomId: 'room1',
                gameId: 'game1',
                hostId: 'player1',
                players: [
                    {
                        id: 'player1',
                    },
                ],
                isLocked: true,
                messages: [],
                journalEntries: [],
            };
            gameService.getGameById.returns(Promise.resolve({ mode: 'ctf' } as Game));
            (service as any).assignTurnOrder = stub().returns(waitingRoom.players);
            (service as any).assignColor = stub().returns(waitingRoom.players);
            (service as any).assignTeam = stub().returns(waitingRoom.players);

            const newRoom = await service.createRoom(waitingRoom);
            expect(newRoom.roomId).toBe('game_room1');
            expect(newRoom.isLocked).toBeTruthy();
            expect(newRoom.players.length).toBeGreaterThan(0);
        });

        it('should throw an error if a room with same name already exists', async () => {
            const waitingRoom: GameRoom = {
                roomId: 'test_room',
                gameId: 'game1',
                hostId: 'player1',
                players: [
                    {
                        id: 'player1',
                    },
                ],
                isLocked: true,
                messages: [],
                journalEntries: [],
            };
            await expect(service.createRoom(waitingRoom)).rejects.toThrowError('La salle existe déjà');
        });
    });

    describe('abandonGame', () => {
        it('should remove a player correctly', () => {
            testRoom.players.push({
                id: 'player2',
            });
            const abandonResult = service.abandonGame(testRoom.roomId, 'player1');
            expect(testRoom.hostId).toBe('test_host');
            expect(abandonResult).toBe(false);
        });

        it('should delete the room if players count is less than or equal to 1', () => {
            const abandonResult = service.abandonGame(testRoom.roomId, 'player1');
            expect(abandonResult).toBe(true);
            expect(service.findRoomById(testRoom.roomId)).toBeUndefined();
        });

        it('should return false if player count is higher than 1', () => {
            testRoom.players.push({
                id: 'player2',
            });
            testRoom.players.push({
                id: 'player3',
            });
            testRoom.players.push({
                id: 'player4',
            });
            const abandonResult = service.abandonGame(testRoom.roomId, 'player2');
            expect(abandonResult).toBe(false);
        });

        it('should throw an error if the room doesnt exist', () => {
            expect(() => {
                service.abandonGame('nonExistingRoom', 'player1');
            }).toThrowError("La salle n'existe pas");
        });

        it('should set the first player as new organizer when the organizer abandons the game', () => {
            testRoom.hostId = 'test_host';
            testRoom.players = [{ id: 'player1' }, { id: 'player2' }];
            service.abandonGame(testRoom.roomId, 'test_host');
            expect(testRoom.hostId).toBe('player1');
            expect(testRoom.isDebugging).toBe(false);
        });
    });

    describe('isHost', () => {
        it('should find if a player is the host', () => {
            testRoom.players.push({
                id: 'player2',
            });
            expect(service.isHost(testRoom.roomId, 'test_host')).toBe(true);
            expect(service.isHost(testRoom.roomId, 'player2')).toBe(false);
        });

        it('should throw an error if the room doesnt exist', () => {
            expect(() => {
                service.isHost('nonExistentRoom', 'player1');
            }).toThrowError("La salle n'existe pas");
        });
    });

    describe('deleteRoomById', () => {
        it('should delete the room by id', () => {
            service.deleteRoomById(testRoom.roomId);
            expect(service.findRoomById(testRoom.roomId)).toBeUndefined();
        });
    });

    it('should add message to room', () => {
        const message = {
            type: 'test',
            name: 'testName',
            content: 'testContent',
            time: 'testTime',
        };
        service.addMessage(testRoom.roomId, message);
        expect(testRoom.messages).toEqual([message]);
    });

    it('should throw an error if the room does not exist on adding message', () => {
        expect(() => {
            service.addMessage('nonExistingRoom', { type: 'test', content: 'testContent', time: 'testTime' });
        }).toThrowError("La salle n'existe pas");
    });

    it('should add entry to room', () => {
        const entry = {
            type: 'test',
            content: 'testContent',
            time: 'testTime',
        };
        const expectedEntry = {
            type: entry.type,
            content: entry.content,
            time: 'testTime',
        };
        jest.spyOn(Date.prototype, 'toLocaleTimeString').mockReturnValue('testTime');
        service.addJournalEntry(testRoom.roomId, entry);
        expect(testRoom.journalEntries).toEqual([expectedEntry]);
    });

    it('should throw an error if the room does not exist on adding journal entry', () => {
        expect(() => {
            service.addJournalEntry('nonExistingRoom', { type: 'test', content: 'testContent', time: 'testTime' });
        }).toThrowError("La salle n'existe pas");
    });

    describe('prepareNextTurn', () => {
        it('should emit TurnStarting and set a turn timeout', () => {
            jest.useFakeTimers();
            const TURN_BREAK = 3;
            const startTurnSpy = jest.spyOn(service, 'startTurn').mockImplementation(() => {});
            service.prepareNextTurn(testRoom.roomId);
            jest.advanceTimersByTime((TURN_BREAK + 1) * COUNTDOWN_INTERVAL);

            expect(fakeServer.to).toHaveBeenCalledWith(testRoom.roomId);
            expect(fakeServer.emit).toHaveBeenCalledWith(
                GameRoomEvents.TurnStarting,
                expect.objectContaining({
                    nextPlayer: testRoom.players[0],
                    countdown: TURN_BREAK,
                }),
            );
            expect(startTurnSpy).toHaveBeenCalled();
            jest.runOnlyPendingTimers();
            jest.useRealTimers();
        });

        it('should throw an error if the room doesnt exist', () => {
            expect(() => {
                service.prepareNextTurn('nonExistingRoom');
            }).toThrowError("Le jeu n'existe pas");
        });
    });

    describe('startTurn', () => {
        it('should update countdown and call endTurn when turn ends', () => {
            jest.useFakeTimers();
            const TURN_DURATION = 30;
            const TIME_LEFT = 29;
            const endTurnSpy = jest.spyOn(service, 'endTurn').mockImplementation(() => {});
            service.startTurn(testRoom.roomId);
            expect(testRoom.timeRemaining).toBe(TURN_DURATION);
            jest.advanceTimersByTime(COUNTDOWN_INTERVAL);
            expect(testRoom.timeRemaining).toBe(TIME_LEFT);
            jest.advanceTimersByTime(TIME_LEFT * COUNTDOWN_INTERVAL);
            expect(testRoom.timeRemaining).toBeUndefined();
            expect(endTurnSpy).toHaveBeenCalledWith(testRoom.roomId);
            endTurnSpy.mockRestore();
        });

        it('should throw an error in startTurn if the room doesnt exist', () => {
            expect(() => {
                service.startTurn('nonExistingRoom');
            }).toThrowError("Le jeu n'existe pas");
        });
    });

    describe('endTurn', () => {
        it('endTurn should not change players order (one player) and call prepareNextTurn', () => {
            const prepareNextTurnSpy = jest.spyOn(service, 'prepareNextTurn').mockImplementation(() => {});
            const playersBefore = [...testRoom.players];
            service.endTurn(testRoom.roomId);
            expect(testRoom.players).toEqual(playersBefore);
            expect(prepareNextTurnSpy).toHaveBeenCalledWith(testRoom.roomId);
            prepareNextTurnSpy.mockRestore();
        });

        it('should throw an error in endTurn if the room doesnt exist', () => {
            expect(() => {
                service.endTurn('nonExistingRoom');
            }).toThrowError("Le jeu n'existe pas");
        });
    });

    describe('isPlayerTurn', () => {
        it("should check if it is a player's turn", () => {
            testRoom.players.push({
                id: 'player2',
            });
            expect(service.isPlayerTurn(testRoom.roomId, 'test_player')).toBe(true);
            expect(service.isPlayerTurn(testRoom.roomId, 'player2')).toBe(false);
        });

        it('should throw an error if the room doesnt exist', () => {
            expect(() => {
                service.isPlayerTurn('nonExistentRoom', 'player1');
            }).toThrowError("Le jeu n'existe pas");
        });
    });

    describe('endCombat', () => {
        it('delete a room properly when it is the end of the game', () => {
            const testRoom2: GameRoom = {
                roomId: 'test_room',
                gameId: 'game1',
                hostId: 'player1',
                players: [
                    {
                        id: 'player1',
                        stats: {
                            health: { maxValue: 4, value: 4, description: 'desc' },
                            speed: { maxValue: 4, value: 4, description: 'desc' },
                            attack: { maxValue: 4, value: 4, description: 'desc' },
                            defense: { maxValue: 4, value: 4, description: 'desc' },
                        },
                    },
                ],
                isLocked: true,
                messages: [],
                journalEntries: [],
            };

            service['gameRooms'].push(testRoom2);
            service.endGame(testRoom2.roomId);
            expect(service.findRoomById(testRoom2.roomId)).toBeUndefined();
        });

        it('should throw an error in endGame if the room doesnt exist', () => {
            expect(() => {
                service.endGame('nonExistingRoom');
            }).toThrowError("Le jeu n'existe pas");
        });
    });

    describe('toggleDebugMode', () => {
        it('should toggle debug mode to true if initially false', () => {
            testRoom.isDebugging = false;
            const toggleResult = service.toggleDebugMode(testRoom.roomId);
            expect(toggleResult).toBe(true);
            expect(testRoom.isDebugging).toBe(true);
        });

        it('should toggle debug mode to false if initially true', () => {
            testRoom.isDebugging = true;
            const toggleResult = service.toggleDebugMode(testRoom.roomId);
            expect(toggleResult).toBe(false);
            expect(testRoom.isDebugging).toBe(false);
        });

        it('should throw an error in toggleDebugMode if the room does not exist', () => {
            expect(() => {
                service.toggleDebugMode('nonExistingRoom');
            }).toThrowError("La salle n'existe pas");
        });
    });

    describe('pauseTimer', () => {
        it('should pause the timer by clearing turnTimer', () => {
            const ONE_SECOND = 1000;
            testRoom.turnTimer = setInterval(() => {}, ONE_SECOND);
            service.pauseTimer(testRoom.roomId);
            expect(testRoom.turnTimer).toBeUndefined();
        });
    });

    describe('resumeTurn', () => {
        jest.useFakeTimers();

        it('should start the countdown and emit update events if the first player has movementPoints >= 1', () => {
            jest.useFakeTimers();
            const TIME_REMAINING = 9;
            testRoom.timeRemaining = 10;
            testRoom.players[0].movementPoints = 2;
            service.resumeTurn(testRoom.roomId);

            expect(testRoom.turnTimer).toBeDefined();

            jest.advanceTimersByTime(COUNTDOWN_INTERVAL);
            expect(testRoom.timeRemaining).toBe(TIME_REMAINING);

            const endTurnSpy = jest.spyOn(service, 'endTurn').mockImplementation(() => {});
            jest.advanceTimersByTime(TIME_REMAINING * COUNTDOWN_INTERVAL);
            expect(endTurnSpy).toHaveBeenCalledWith(testRoom.roomId);
            endTurnSpy.mockRestore();
        });

        it('should call endTurn immediately if the first player has movementPoints < 1', () => {
            testRoom.timeRemaining = 10;
            const endTurnSpy = jest.spyOn(service, 'endTurn').mockImplementation(() => {});
            service.resumeTurn(testRoom.roomId);
            expect(endTurnSpy).toHaveBeenCalledWith(testRoom.roomId);
            endTurnSpy.mockRestore();
        });

        it('should throw an error if the room does not exist', () => {
            expect(() => {
                service.resumeTurn('nonExistingRoom');
            }).toThrowError("Le jeu n'existe pas");
        });
    });

    describe('findRoomsByPlayerId', () => {
        it('should return an empty array if the player is not found in any room', () => {
            const foundRooms = service.findRoomsByPlayerId('nonExistingPlayer');
            expect(foundRooms).toEqual([]);
        });

        it('should return rooms where the player is in the players array', () => {
            const foundRooms = service.findRoomsByPlayerId('test_player');
            expect(foundRooms).toContain(testRoom);
        });

        it('should return rooms where the player is the host even if not in players array', () => {
            const room1: GameRoom = {
                roomId: 'room1',
                gameId: 'game1',
                hostId: 'player4',
                players: [
                    {
                        id: 'player3',
                        stats: {
                            health: { maxValue: 4, value: 4, description: 'desc' },
                            speed: { maxValue: 4, value: 4, description: 'desc' },
                            attack: { maxValue: 4, value: 4, description: 'desc' },
                            defense: { maxValue: 4, value: 4, description: 'desc' },
                        },
                    },
                ],
                isLocked: true,
                messages: [],
                journalEntries: [],
            };
            service['gameRooms'].push(room1);
            const foundRooms = service.findRoomsByPlayerId('player4');
            expect(foundRooms).toContain(room1);
        });

        it('should ignore rooms that have no players property', () => {
            const roomWithoutPlayers: GameRoom = {
                roomId: 'room3',
                gameId: 'game1',
                hostId: 'host2',
                players: undefined,
                isLocked: true,
                isDebugging: false,
                turnTimer: undefined,
                timeRemaining: undefined,
                messages: [],
                journalEntries: [],
            };

            service['gameRooms'].push(roomWithoutPlayers);
            const foundRooms = service.findRoomsByPlayerId('organiser2');
            expect(foundRooms).not.toContain(roomWithoutPlayers);
        });
    });

    describe('assignTurnOrder', () => {
        it('should sort players in descending order of speed when speeds are not equal', () => {
            const players: Player[] = [
                {
                    id: 'p1',
                    stats: {
                        health: { maxValue: 4, value: 4, description: 'desc' },
                        speed: { maxValue: 4, value: 7, description: 'desc' },
                        attack: { maxValue: 4, value: 4, description: 'desc' },
                        defense: { maxValue: 4, value: 4, description: 'desc' },
                    },
                    movementPoints: 0,
                } as Player,
                {
                    id: 'p2',
                    stats: {
                        health: { maxValue: 4, value: 4, description: 'desc' },
                        speed: { maxValue: 4, value: 4, description: 'desc' },
                        attack: { maxValue: 4, value: 4, description: 'desc' },
                        defense: { maxValue: 4, value: 4, description: 'desc' },
                    },
                    movementPoints: 0,
                } as Player,
                {
                    id: 'p3',
                    stats: {
                        health: { maxValue: 4, value: 4, description: 'desc' },
                        speed: { maxValue: 4, value: 6, description: 'desc' },
                        attack: { maxValue: 4, value: 4, description: 'desc' },
                        defense: { maxValue: 4, value: 4, description: 'desc' },
                    },
                    movementPoints: 0,
                },
            ];
            const sortedPlayers = (service as any).assignTurnOrder(players);
            expect(sortedPlayers[0].id).toBe('p1');
            expect(sortedPlayers[1].id).toBe('p3');
            expect(sortedPlayers[2].id).toBe('p2');
        });

        it('should sort players randomly when speeds are equal', () => {
            const players: Player[] = [
                {
                    id: 'p1',
                    stats: {
                        health: { maxValue: 4, value: 4, description: 'desc' },
                        speed: { maxValue: 4, value: 4, description: 'desc' },
                        attack: { maxValue: 4, value: 4, description: 'desc' },
                        defense: { maxValue: 4, value: 4, description: 'desc' },
                    },
                    movementPoints: 0,
                } as Player,
                {
                    id: 'p2',
                    stats: {
                        health: { maxValue: 4, value: 4, description: 'desc' },
                        speed: { maxValue: 4, value: 4, description: 'desc' },
                        attack: { maxValue: 4, value: 4, description: 'desc' },
                        defense: { maxValue: 4, value: 4, description: 'desc' },
                    },
                    movementPoints: 0,
                } as Player,
                {
                    id: 'p3',
                    stats: {
                        health: { maxValue: 4, value: 4, description: 'desc' },
                        speed: { maxValue: 4, value: 4, description: 'desc' },
                        attack: { maxValue: 4, value: 4, description: 'desc' },
                        defense: { maxValue: 4, value: 4, description: 'desc' },
                    },
                    movementPoints: 0,
                },
            ];
            const sortedPlayers = (service as any).assignTurnOrder(players);
            const sortedIdsPlayer = sortedPlayers.map((p: Player) => p.id).sort();
            expect(sortedIdsPlayer).toEqual(['p1', 'p2', 'p3'].sort());
        });
    });

    describe('clearTurnTimeout', () => {
        it('should clear the timeout and delete it from turnTimeouts if it exists', () => {
            const roomId = 'test_room';
            const fakeTimeout = setTimeout(() => {}, COUNTDOWN_INTERVAL);
            service['turnTimeouts'].set(roomId, fakeTimeout);
            const clearTimeoutSpy = jest.spyOn(global, 'clearTimeout');
            (service as any).clearTurnTimeout(roomId);
            expect(clearTimeoutSpy).toHaveBeenCalledWith(fakeTimeout);
            expect(service['turnTimeouts'].has(roomId)).toBe(false);

            clearTimeoutSpy.mockRestore();
        });
    });

    describe('Inventory Management', () => {
        const coords = { x: 0, y: 0 };
        beforeEach(() => {
            // S'assurer que tous les joueurs ont bien un inventaire et une position initialisés
            testRoom.players.forEach((player) => {
                player.inventory = [];
                player.position = { x: 0, y: 0 };
            });
        });

        describe('addItemToInventory', () => {
            it('should add an item to the player inventory', () => {
                const testItem = { type: 'sword' };
                service.addItemToInventory(testRoom.roomId, 'test_player', testItem, coords);
                const player = testRoom.players.find((p) => p.id === 'test_player');
                expect(player.inventory).toContain(testItem);
            });

            it('should drop an item if the player is virtual', () => {
                testRoom.players.push({ id: 'VP', inventory: [{ type: 'flag' }, { type: 'shield' }], isVirtual: true });
                const testItem = { type: 'sword' };
                service.addItemToInventory(testRoom.roomId, 'VP', testItem, coords);
                expect(fakeServer.to).toHaveBeenCalledWith(testRoom.roomId);
                expect(fakeServer.emit).toHaveBeenCalledWith(GameRoomEvents.ItemDropped, {
                    roomId: testRoom.roomId,
                    playerId: 'VP',
                    item: { type: 'shield' },
                    coords,
                });
            });
        });

        describe('removeItem', () => {
            it('should remove the item from the player inventory if present', () => {
                const testItem = { type: 'shield' };
                const player = testRoom.players.find((p) => p.id === 'test_player');
                if (!player.inventory) player.inventory = [];
                player.inventory.push(testItem);
                service.removeItemFromInventory(testRoom.roomId, 'test_player', testItem, coords);
                expect(player.inventory).not.toContain(testItem);
            });

            it('should not change the inventory if the item is not present', () => {
                const testItem = { type: 'bow' };
                const player = testRoom.players.find((p) => p.id === 'test_player');
                if (!player.inventory) player.inventory = [];
                // L'inventaire est vide par défaut
                service.removeItemFromInventory(testRoom.roomId, 'test_player', testItem, coords);
                expect(player.inventory.length).toBe(0);
            });

            it('should do nothing if playerId is falsy', () => {
                const testItem = { type: 'axe' };
                const player = testRoom.players.find((p) => p.id === 'test_player');
                if (!player.inventory) player.inventory = [];
                player.inventory.push(testItem);
                service.removeItemFromInventory(testRoom.roomId, '', testItem, coords);
                // L'inventaire doit rester inchangé
                expect(player.inventory).toContain(testItem);
            });
        });

        describe('dropItemsWhenDisconnected', () => {
            it('should emit the ItemDroppedDisconnected event with the correct payload', () => {
                // Ajouter un deuxième joueur pour que le premier de la liste soit utilisé pour l'émission de l'événement
                const secondPlayer = {
                    id: 'player2',
                    inventory: [],
                    position: { x: 10, y: 20 },
                    stats: {},
                };
                testRoom.players.push(secondPlayer);

                // Configurer les données du joueur déconnecté (player1)
                const player1 = testRoom.players.find((p) => p.id === 'test_player');
                if (!player1.inventory) player1.inventory = [];
                player1.inventory = [{ type: 'potion' }];
                if (!player1.position) player1.position = { x: 0, y: 0 };
                player1.position = { x: 5, y: 5 };

                service.dropItemsWhenDisconnected(testRoom.roomId, 'test_player');

                // Vérifier que l'événement est émis vers l'ID du premier joueur de la salle (ici player1)
                expect(fakeServer.to).toHaveBeenCalledWith(testRoom.players[0].id);
                expect(fakeServer.emit).toHaveBeenCalledWith(GameRoomEvents.ItemDroppedDisconnected, {
                    roomId: testRoom.roomId,
                    coords: player1.position,
                    items: player1.inventory,
                });
            });
        });
    });

    describe('isOpponent', () => {
        it('should check if player is opponent from ctf', () => {
            const secondPlayer = {
                id: 'player2',
                inventory: [],
                position: { x: 10, y: 20 },
                stats: {},
                team: 1,
            };
            testRoom.players[0].team = 0;

            expect(service.isOpponent(testRoom.players[0], secondPlayer, true)).toEqual(true);
        });
        it('should check if player is opponent from classic game', () => {
            const secondPlayer = {
                id: 'player2',
                inventory: [],
                position: { x: 10, y: 20 },
                stats: {},
                team: 1,
            };
            testRoom.players[0].team = 0;

            expect(service.isOpponent(testRoom.players[0], secondPlayer, false)).toEqual(true);
            expect(service.isOpponent(testRoom.players[0], testRoom.players[0], false)).toEqual(false);
        });
    });

    it('should check if player is carrying flag', () => {
        testRoom.players[0].inventory = [{ type: 'flag' }];

        expect(service.isCarryingFlag(testRoom.players[0])).toEqual({ type: 'flag' });
    });

    it('should check if opponent is carrying flag', () => {
        const secondPlayer = {
            id: 'player2',
            inventory: [{ type: 'flag' }],
            position: { x: 10, y: 20 },
            stats: {},
            team: 1,
        };
        testRoom.players[0].team = 0;

        expect(service.isOpponentCarryingFlag(testRoom.players[0], secondPlayer)).toEqual({ type: 'flag' });
    });

    it('should check if flag is with our team', () => {
        const secondPlayer = {
            id: 'player2',
            inventory: [{ type: 'flag' }],
            position: { x: 10, y: 20 },
            stats: {},
            team: 0,
        };
        testRoom.players.push(secondPlayer);
        testRoom.players[0].inventory = [];
        testRoom.players[0].team = 0;

        expect(service.isFlagWithOurTeam(testRoom.players[0])).toEqual(secondPlayer);
    });

    it('should not check if flag is with our team', () => {
        const secondPlayer = {
            id: 'player2',
            inventory: [{ type: 'flag' }],
            position: { x: 10, y: 20 },
            stats: {},
            team: 1,
        };
        testRoom.players.push(secondPlayer);
        testRoom.players[0].inventory = [];
        testRoom.players[0].team = 0;
        expect(service.isFlagWithOurTeam({ id: 'fakeId' } as Player)).toEqual(false);
    });

    it('should change host', () => {
        const secondPlayer = {
            id: 'player2',
        };
        testRoom.players.push(secondPlayer);

        service.changehost(testRoom.roomId);

        expect(testRoom.hostId).toEqual('test_player');
        expect(() => {
            service.changehost('nonExistentRoom');
        }).toThrow("La salle n'existe pas");
    });

    it('should get random delay', () => {
        const minSeconds = 10;
        const maxSeconds = 20;

        const result = service.getRandomDelay(minSeconds, maxSeconds);

        expect(result).toBeGreaterThanOrEqual(minSeconds);
        expect(result).toBeLessThanOrEqual(maxSeconds);
    });

    it('should assign colors', () => {
        let players = [{ id: 0 }];

        players = (service as any).assignColor(players);

        expect(players).toEqual([{ id: 0, color: 'yellow' }]);
    });

    it('should assign teams', () => {
        let players = [
            { id: 0, team: undefined },
            { id: 2, team: undefined },
            { id: 3, team: undefined },
            { id: 4, team: undefined },
        ];

        players = (service as any).assignTeam(players);
        const team1 = players.filter((p) => p.team === 1);
        const team2 = players.filter((p) => p.team === 2);
        expect(team1.length).toEqual(team2.length);
    });
});

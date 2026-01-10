/* eslint-disable @typescript-eslint/no-empty-function */
/* eslint-disable max-lines */
/* eslint-disable @typescript-eslint/no-explicit-any */
import { GameRoomEvents } from '@app/gateways/game-room/game-room.gateway.events';
import { GameRoom } from '@app/interfaces/game-room';
import { Player } from '@app/interfaces/player';
import { GameRoomService } from './game-room.service';
const COUNTDOWN_INTERVAL = 1000;
describe('GameRoomService', () => {
    let service: GameRoomService;
    let fakeServer: any;
    let testRoom: GameRoom;
    beforeEach(() => {
        service = new GameRoomService();
        fakeServer = {
            to: jest.fn().mockReturnThis(),
            emit: jest.fn(),
        };
        service.setServer(fakeServer);

        testRoom = {
            roomId: 'test_room',
            gameId: 'game1',
            organisatorId: 'player1',
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
        };
        service['gameRooms'] = [testRoom];
    });

    describe('Create GameRoom', () => {
        it('should create a room with a waiting room', () => {
            const waitingRoom: GameRoom = {
                roomId: 'room1',
                gameId: 'game1',
                organisatorId: 'player1',
                players: [
                    {
                        id: 'player1',
                    },
                ],
                isLocked: true,
            };
            const newRoom = service.createRoom(waitingRoom);
            expect(newRoom.roomId).toBe('game_room1');
            expect(newRoom.isLocked).toBeTruthy();
            expect(newRoom.players.length).toBeGreaterThan(0);
        });

        it('should throw an error if a room with same name already exists', () => {
            const waitingRoom: GameRoom = {
                roomId: 'test_room',
                gameId: 'game1',
                organisatorId: 'player1',
                players: [
                    {
                        id: 'player1',
                    },
                ],
                isLocked: true,
            };
            expect(() => service.createRoom(waitingRoom)).toThrowError('La salle existe déjà');
        });
    });

    describe('abandonGame', () => {
        it('should remove a player correctly', () => {
            testRoom.players.push({
                id: 'player2',
            });
            const abandonResult = service.abandonGame(testRoom.roomId, 'player1');
            expect(testRoom.organisatorId).toBe('player2');
            expect(abandonResult).toBe(true);
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
            const abandonResult = service.abandonGame(testRoom.roomId, 'player2');
            expect(abandonResult).toBe(false);
        });

        it('should throw an error if the room doesnt exist', () => {
            expect(() => {
                service.abandonGame('nonExistingRoom', 'player1');
            }).toThrowError("La salle n'existe pas");
        });
    });

    describe('deleteRoomById', () => {
        it('should delete the room by id', () => {
            service.deleteRoomById(testRoom.roomId);
            expect(service.findRoomById(testRoom.roomId)).toBeUndefined();
        });
    });

    describe('prepareNextTurn', () => {
        it('should emit TurnStarting and set a turn timeout', () => {
            jest.useFakeTimers();
            const TURN_BREAK = 3;
            const startTurnSpy = jest.spyOn(service, 'startTurn').mockImplementation(() => {});
            service.prepareNextTurn(testRoom.roomId);

            expect(fakeServer.to).toHaveBeenCalledWith(testRoom.roomId);
            expect(fakeServer.emit).toHaveBeenCalledWith(
                GameRoomEvents.TurnStarting,
                expect.objectContaining({
                    nextPlayer: testRoom.players[0],
                    startTime: expect.any(Number),
                }),
            );
            jest.advanceTimersByTime(TURN_BREAK + 1);
            jest.runOnlyPendingTimers();
            expect(startTurnSpy).toHaveBeenCalled();
        });

        it('should throw an error if the room doesnt exist', () => {
            expect(() => {
                service.prepareNextTurn('nonExistingRoom');
            }).toThrowError("La partie n'existe pas");
        });
    });

    describe('startTurn', () => {
        it('should update countdown and call endTurn when turn ends', () => {
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
            }).toThrowError("La partie n'existe pas");
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
            }).toThrowError("La partie n'existe pas");
        });
    });

    describe('endCombat', () => {
        it('delete a room properly when it is the end of the game', () => {
            const testRoom2: GameRoom = {
                roomId: 'test_room',
                gameId: 'game1',
                organisatorId: 'player1',
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
            };

            service['gameRooms'].push(testRoom2);
            service.endGame(testRoom2.roomId);
            expect(service.findRoomById(testRoom2.roomId)).toBeUndefined();
        });

        it('should throw an error in endGame if the room doesnt exist', () => {
            expect(() => {
                service.endGame('nonExistingRoom');
            }).toThrowError("La partie n'existe pas");
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
            }).toThrowError("La partie n'existe pas");
        });
    });

    describe('findRoomsByPlayerId', () => {
        it('should return an empty array if the player is not found in any room', () => {
            const foundRooms = service.findRoomsByPlayerId('nonExistingPlayer');
            expect(foundRooms).toEqual([]);
        });

        it('should return rooms where the player is in the players array', () => {
            const foundRooms = service.findRoomsByPlayerId('player1');
            expect(foundRooms).toContain(testRoom);
        });

        it('should return rooms where the player is the organisator even if not in players array', () => {
            const room1: GameRoom = {
                roomId: 'room1',
                gameId: 'game1',
                organisatorId: 'player4',
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
            };
            service['gameRooms'].push(room1);
            const foundRooms = service.findRoomsByPlayerId('player4');
            expect(foundRooms).toContain(room1);
        });

        it('should ignore rooms that have no players property', () => {
            const roomWithoutPlayers: GameRoom = {
                roomId: 'room3',
                gameId: 'game1',
                organisatorId: 'organisator2',
                players: undefined,
                isLocked: true,
                isDebugging: false,
                turnTimer: undefined,
                timeRemaining: undefined,
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
});

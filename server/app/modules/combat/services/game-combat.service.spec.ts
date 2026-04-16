/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable max-lines */
/* eslint-disable prettier/prettier */
import { MAX_TIME, MAX_TIME_WITHOUT_EVASION, MIN_TIME } from '@app/modules/combat/constants/game-combat.constants';
import { GameMovementService } from '@app/modules/movement/services/game-movement.service';
import { GameRoom } from '@app/modules/shared-room/interfaces/game-room';
import { GameRoomService } from '@app/modules/shared-room/services/game-room.service';
import { Player, VirtualPlayerType } from '@app/shared/interfaces/player';
import { DiceService } from '@app/shared/services/dice.service';
import { GameRoomEvents } from '@common/socket.constants';
import { Test, TestingModule } from '@nestjs/testing';
import { SinonStubbedInstance, createStubInstance } from 'sinon';
import { Server } from 'socket.io';
import { GameCombatService } from './game-combat.service';

describe('GameCombatService', () => {
    let service: GameCombatService;
    let gameRoomService: GameRoomService;
    let server: Server;

    const mockPlayers: Player[] = [
        {
            id: 'player1',
            stats: {
                health: { value: 100, maxValue: 100, description: '' },
                attack: { value: 20, maxValue: 20, description: '' },
                defense: { value: 10, maxValue: 10, description: '' },
                speed: { value: 15, maxValue: 15, description: '' },
            },
            evasionPoints: 2,
            name: 'Alice',
        },
        {
            id: 'player2',
            stats: {
                health: { value: 80, maxValue: 80, description: '' },
                attack: { value: 15, maxValue: 15, description: '' },
                defense: { value: 5, maxValue: 5, description: '' },
                speed: { value: 10, maxValue: 10, description: '' },
            },
            evasionPoints: 2,
            name: 'Bob',
        },
    ];

    const combatRoomId = 'combat-123';
    const roomId = 'game-room-123';

    let diceService: SinonStubbedInstance<DiceService>;
    let gameMovementService: SinonStubbedInstance<GameMovementService>;

    beforeEach(async () => {
        server = {
            to: jest.fn().mockReturnValue({
                emit: jest.fn(),
            }),
            socketsLeave: jest.fn(),
        } as unknown as Server;

        const mockGameRoomService = {
            findRoomsByPlayerId: jest.fn().mockReturnValue([
                {
                    roomId: 'game-room-123',
                    players: JSON.parse(JSON.stringify(mockPlayers)),
                },
            ]),
            resumeTurn: jest.fn(),
            endTurn: jest.fn(),
            findRoomById: jest.fn().mockReturnValue({
                playersStats: [
                    { name: 'Alice', damage: 0, healthLost: 0 },
                    { name: 'Bob', damage: 0, healthLost: 0 },
                ],
            }),
            addJournalEntry: jest.fn(),
        };

        diceService = createStubInstance<DiceService>(DiceService);
        gameMovementService = createStubInstance<GameMovementService>(GameMovementService);

        diceService.rollStat.returns(10);
        diceService.rollStatDebug.returns(10);
        gameMovementService.getCell.returns({ tile: { type: 'snow' } } as any);

        const module: TestingModule = await Test.createTestingModule({
            providers: [
                GameCombatService,
                { provide: DiceService, useValue: diceService },
                { provide: GameMovementService, useValue: gameMovementService },
                { provide: GameRoomService, useValue: mockGameRoomService },
            ],
        }).compile();

        service = module.get<GameCombatService>(GameCombatService);
        gameRoomService = module.get<GameRoomService>(GameRoomService);
        service.setServer(server);

        jest.useFakeTimers();
        // eslint-disable-next-line @typescript-eslint/naming-convention
        global.setInterval = Object.assign(jest.fn().mockReturnValue('interval-id' as unknown as NodeJS.Timeout), { __promisify__: jest.fn() });
        global.clearInterval = jest.fn();
    });

    afterEach(() => {
        jest.clearAllMocks();
        jest.clearAllTimers();
    });

    describe('startCombat', () => {
        it('devrait initialiser un nouveau combat avec le joueur le plus rapide commençant', () => {
            service.startCombat(roomId, combatRoomId, JSON.parse(JSON.stringify(mockPlayers)), 'player1', 'player2');

            expect(server.to).toHaveBeenCalledWith(combatRoomId);

            const emitMock = server.to(combatRoomId).emit as jest.Mock;
            expect(emitMock).toHaveBeenCalledWith(
                GameRoomEvents.CombatTurnStarted,
                expect.objectContaining({
                    combatRoomId,
                    attackerId: 'player1',
                    defenderId: 'player2',
                    currentPlayerId: 'player1',
                    currentOpponentId: 'player2',
                }),
            );
        });

        it("devrait initialiser un nouveau combat avec le défenseur commençant s'il est plus rapide", () => {
            const modifiedPlayers = JSON.parse(JSON.stringify(mockPlayers));
            modifiedPlayers[1].stats.speed.value = 20;

            service.startCombat(roomId, combatRoomId, modifiedPlayers, 'player1', 'player2');

            const emitMock = server.to(combatRoomId).emit as jest.Mock;
            const calls = (emitMock as jest.Mock).mock.calls;

            const lastCall = calls.find((call) => call[0] === GameRoomEvents.CombatTurnStarted);
            expect(lastCall[1]).toHaveProperty('currentPlayerId', 'player2');
            expect(lastCall[1]).toHaveProperty('currentOpponentId', 'player1');
        });
    });

    describe('startTurn', () => {
        beforeEach(() => {
            jest.clearAllMocks();
            service.startCombat(roomId, combatRoomId, JSON.parse(JSON.stringify(mockPlayers)), 'player1', 'player2');
            (server.to(combatRoomId).emit as jest.Mock).mockClear();
        });

        it('devrait démarrer un tour avec le compte à rebours', () => {
            service.startTurn(combatRoomId);

            expect(global.setInterval).toHaveBeenCalled();

            const intervalCallback = (global.setInterval as unknown as jest.Mock).mock.calls[0][0];
            intervalCallback();

            expect(server.to).toHaveBeenCalledWith(combatRoomId);
            expect(server.to(combatRoomId).emit).toHaveBeenCalledWith(GameRoomEvents.UpdateCombatCountDown, 5);
        });

        it('should throw an error if the combat room is not found', () => {
            expect(() => service.startTurn('nonexistentCombat')).toThrowError("Le combat n'existe pas");
        });

        it('devrait utiliser TURN_DURATION_WITHOUT_EVASION (3) lorsque le currentPlayer a 0 evasionPoints', () => {
            const playersCopy = JSON.parse(JSON.stringify(mockPlayers));
            // Démarrer le combat
            service.startCombat(roomId, combatRoomId, playersCopy, 'player1', 'player2');

            // Récupérer le combat actif et forcer les evasionPoints du currentPlayer à 0
            const combat = service['findCombatRoomById'](combatRoomId);
            const currentPlayer = combat.players.find((p) => p.id === combat.currentPlayerId);
            currentPlayer.evasionPoints = 0;

            // Démarrer à nouveau le tour pour que la méthode lise la nouvelle valeur d'evasionPoints
            service.startTurn(combatRoomId);

            // Récupérer le callback passé à setInterval (ici on prend le dernier appel)
            const setIntervalMock = global.setInterval as unknown as jest.Mock;
            const lastCallIndex = setIntervalMock.mock.calls.length - 1;
            const callback = setIntervalMock.mock.calls[lastCallIndex][0];

            // Appeler une première fois le callback : le compte à rebours initial doit être égal à TURN_DURATION_WITHOUT_EVASION (3)
            callback();

            // Vérifier que l'événement UpdateCombatCountDown est émis avec la valeur 3
            expect(server.to).toHaveBeenCalledWith(combat.combatRoomId);
            expect(server.to(combat.combatRoomId).emit).toHaveBeenCalledWith(GameRoomEvents.UpdateCombatCountDown, 3);
        });
    });

    describe('attack', () => {
        beforeEach(() => {
            jest.clearAllMocks();
            service.startCombat(roomId, combatRoomId, JSON.parse(JSON.stringify(mockPlayers)), 'player1', 'player2');
            (server.to(combatRoomId).emit as jest.Mock).mockClear();
        });

        it('devrait calculer correctement les dommages et mettre à jour la vie du défenseur', async () => {
            diceService.rollStat.onFirstCall().returns(20);
            diceService.rollStat.onSecondCall().returns(5);

            await service.attack(combatRoomId);

            const emitMock = server.to(combatRoomId).emit as jest.Mock;
            const calls = (emitMock as jest.Mock).mock.calls;

            const attackResultCall = calls.find((call) => call[0] === GameRoomEvents.AttackResult);
            expect(attackResultCall[1]).toMatchObject({
                isAttackSuccess: true,
                attackValue: 20,
                defenseValue: 5,
            });

            expect(attackResultCall[1].opponentHealthPoints).toBe(65); // 80 - (20-5) = 65

            expect(gameRoomService.findRoomById).toHaveBeenCalledWith(roomId);
            expect(gameRoomService.findRoomById(roomId).playersStats[1].healthLost).toBe(15);
            expect(gameRoomService.findRoomById(roomId).playersStats[0].damage).toBe(15);
        });

        it("devrait envoyer un échec d'attaque quand la défense est supérieure à l'attaque", async () => {
            diceService.rollStat.onFirstCall().returns(10);
            diceService.rollStat.onSecondCall().returns(15);

            await service.attack(combatRoomId);

            const emitMock = server.to(combatRoomId).emit;
            const calls = (emitMock as jest.Mock).mock.calls;

            const attackResultCall = calls.find((call) => call[0] === GameRoomEvents.AttackResult);
            expect(attackResultCall[1]).toMatchObject({
                isAttackSuccess: false,
                attackValue: 10,
                defenseValue: 15,
            });
        });

        it("devrait gérer le cas où le combat n'existe pas", async () => {
            // eslint-disable-next-line @typescript-eslint/no-empty-function
            const consoleSpy = jest.spyOn(console, 'log').mockImplementation(() => {});

            await service.attack('nonexistent');

            expect(consoleSpy).not.toHaveBeenCalled();
        });

        it("devrait gérer le cas où l'acquisition du lock échoue", async () => {
            service['acquireLock'](combatRoomId);

            await expect(service.attack(combatRoomId)).rejects.toThrow('Combat action already in progress');
        });
    });

    describe('attemptFlight', () => {
        beforeEach(() => {
            jest.clearAllMocks();
            service.startCombat(roomId, combatRoomId, JSON.parse(JSON.stringify(mockPlayers)), 'player1', 'player2');
            (server.to(combatRoomId).emit as jest.Mock).mockClear();

            jest.spyOn(global.Math, 'random').mockReturnValue(0.5);
        });

        afterEach(() => {
            jest.spyOn(global.Math, 'random').mockRestore();
        });

        it('devrait réussir la fuite quand Math.random <= FLIGHT_CHANCES', () => {
            jest.spyOn(global.Math, 'random').mockReturnValue(0.2);
            service.attemptFlight(combatRoomId);

            const emitMock = server.to(combatRoomId).emit;
            const calls = (emitMock as jest.Mock).mock.calls;

            const flightResultCall = calls.find((call) => call[0] === GameRoomEvents.FlightAttemptResult);
            expect(flightResultCall[1]).toMatchObject({
                isSuccess: true,
            });

            const endCombatCall = calls.find((call) => call[0] === GameRoomEvents.EndCombat);
            expect(endCombatCall).toBeTruthy();
        });

        it("devrait échouer la fuite et réduire les points d'évasion quand Math.random > FLIGHT_CHANCES", () => {
            jest.spyOn(global.Math, 'random').mockReturnValue(0.5);

            service.attemptFlight(combatRoomId);

            const emitMock = server.to(combatRoomId).emit;
            const calls = (emitMock as jest.Mock).mock.calls;

            const flightResultCall = calls.find((call) => call[0] === GameRoomEvents.FlightAttemptResult);
            expect(flightResultCall[1]).toMatchObject({
                isSuccess: false,
                attackerEvasionPoints: 1,
            });
        });
    });

    describe('prepareNextTurn', () => {
        beforeEach(() => {
            jest.clearAllMocks();
            service.startCombat(roomId, combatRoomId, JSON.parse(JSON.stringify(mockPlayers)), 'player1', 'player2');
        });

        it('devrait inverser les rôles currentPlayerId et currentOpponentId', () => {
            const initialCombat = service['findCombatRoomById'](combatRoomId);
            const initialCurrentPlayerId = initialCombat.currentPlayerId;
            const initialCurrentOpponentId = initialCombat.currentOpponentId;

            service.prepareNextTurn(combatRoomId);

            const combat = service['findCombatRoomById'](combatRoomId);
            expect(combat.currentPlayerId).toBe(initialCurrentOpponentId);
            expect(combat.currentOpponentId).toBe(initialCurrentPlayerId);

            const emitMock = server.to(combatRoomId).emit;
            const calls = (emitMock as jest.Mock).mock.calls;

            const turnStartedCall = calls.find((call) => call[0] === GameRoomEvents.CombatTurnStarted);
            expect(turnStartedCall[1].currentPlayerId).toBe(initialCurrentOpponentId);
            expect(turnStartedCall[1].currentOpponentId).toBe(initialCurrentPlayerId);
        });

        it("devrait terminer le combat si la santé de l'opposant est <= 0", () => {
            const combat = service['findCombatRoomById'](combatRoomId);
            const opponent = combat.players.find((p) => p.id === combat.currentOpponentId);
            opponent.stats.health.value = 0;

            const endCombatSpy = jest.spyOn(service, 'endCombat');

            service.prepareNextTurn(combatRoomId);

            expect(endCombatSpy).toHaveBeenCalledWith(combatRoomId, false);
        });
    });

    describe('endCombat', () => {
        beforeEach(() => {
            jest.clearAllMocks();
            service.startCombat(roomId, combatRoomId, JSON.parse(JSON.stringify(mockPlayers)), 'player1', 'player2');
            (server.to(combatRoomId).emit as jest.Mock).mockClear();
        });

        it('devrait terminer le tour si le défenseur gagne', () => {
            const combat = service['findCombatRoomById'](combatRoomId);
            combat.currentPlayerId = combat.defenderId;
            combat.currentOpponentId = combat.attackerId;

            service.endCombat(combatRoomId, false);

            expect(gameRoomService.endTurn).toHaveBeenCalledWith('game-room-123');
        });

        it('devrait reprendre le tour sans mettre à jour le score en cas de fuite', () => {
            service.endCombat(combatRoomId, true);

            expect(gameRoomService.resumeTurn).toHaveBeenCalledWith('game-room-123');

            const emitMock = server.to('game-room-123').emit;
            const calls = (emitMock as jest.Mock).mock.calls;
            const updateScoreCall = calls.find((call) => call[0] === GameRoomEvents.UpdateScore);
            expect(updateScoreCall).toBeFalsy();
        });
    });

    describe('abandonCombat', () => {
        beforeEach(() => {
            jest.clearAllMocks();
            service.startCombat(roomId, combatRoomId, JSON.parse(JSON.stringify(mockPlayers)), 'player1', 'player2');
            (server.to(combatRoomId).emit as jest.Mock).mockClear();
        });

        it("devrait mettre à jour le score pour l'adversaire", () => {
            const updateScoreSpy = jest.spyOn(service, 'updateScore');

            const combat = service['findCombatRoomById'](combatRoomId);
            const opponentId = combat.currentOpponentId;

            service.abandonCombat(combatRoomId, true);

            expect(updateScoreSpy).toHaveBeenCalledWith(combatRoomId, opponentId, combat.attackerId, true);
        });
    });

    describe('findCombatsByPlayerId', () => {
        beforeEach(() => {
            jest.clearAllMocks();
            service['activeCombats'] = [];

            service.startCombat(roomId, combatRoomId, JSON.parse(JSON.stringify(mockPlayers)), 'player1', 'player2');

            const player3 = {
                id: 'player3',
                stats: {
                    health: { value: 90, maxValue: 90, description: '' },
                    attack: { value: 18, maxValue: 18, description: '' },
                    defense: { value: 8, maxValue: 8, description: '' },
                    speed: { value: 12, maxValue: 12, description: '' },
                },
                evasionPoints: 2,
            };

            const players2 = [player3, mockPlayers[0]];
            service.startCombat(roomId, 'combat-456', players2, 'player3', 'player1');
        });

        it('devrait trouver tous les combats liés à un joueur', () => {
            const combats = service.findCombatsByPlayerId('player1');
            expect(combats.length).toBe(2);
            expect(combats[0].combatRoomId).toBe(combatRoomId);
            expect(combats[1].combatRoomId).toBe('combat-456');
        });

        it("devrait retourner un tableau vide si aucun combat n'est trouvé", () => {
            const combats = service.findCombatsByPlayerId('non-existent');
            expect(combats.length).toBe(0);
        });
    });
    describe('startTurn - virtual player behavior', () => {
        beforeEach(() => {
            // Clear any previous timers or mocks.
            jest.clearAllMocks();
        });

        it('should call attemptFlight when a virtual defensive player has reduced health and evasionPoints > 0', () => {
            const players = JSON.parse(JSON.stringify(mockPlayers));
            players[0].isVirtual = true;
            players[0].profile = VirtualPlayerType.Defensive;
            players[0].stats.health.value = 100;

            jest.spyOn(service as any, 'getRandomDelay').mockReturnValue(4);

            // Now start the combat (which will also trigger startTurn).
            service.startCombat(roomId, combatRoomId, players, 'player1', 'player2');

            const combat = service['findCombatRoomById'](combatRoomId);
            const currentPlayer = combat.players.find((player) => player.id === combat.currentPlayerId);

            currentPlayer.stats.health.value = 90;
            currentPlayer.evasionPoints = 1;

            const attemptFlightSpy = jest.spyOn(service, 'attemptFlight');

            const setIntervalMock = global.setInterval as unknown as jest.Mock;
            const callback = setIntervalMock.mock.calls[setIntervalMock.mock.calls.length - 1][0];

            callback();

            expect(attemptFlightSpy).toHaveBeenCalledWith(combatRoomId);
        });

        it('should handle timer callback when combat no longer exists', () => {
            const players = JSON.parse(JSON.stringify(mockPlayers));
            players[0].isVirtual = true;
            players[0].profile = VirtualPlayerType.Aggressive;

            jest.spyOn(service as any, 'getRandomDelay').mockReturnValue(4);

            service.startCombat(roomId, combatRoomId, players, 'player1', 'player2');

            const setIntervalMock = global.setInterval as unknown as jest.Mock;
            const callback = setIntervalMock.mock.calls[setIntervalMock.mock.calls.length - 1][0];

            service['activeCombats'] = service['activeCombats'].filter((c) => c.combatRoomId !== combatRoomId);

            callback();

            expect(clearInterval).toHaveBeenCalled();
        });

        describe('startVirtualCombat', () => {
            const roomIdTest = 'room-1';
            const virtualPlayerId = 'virtual1';
            const opponentId = 'player2';
            let fakeRoom: GameRoom;
            let startCombatSpy: jest.SpyInstance;

            beforeEach(() => {
                Object.defineProperty(server, 'sockets', {
                    value: { sockets: new Map() },
                    configurable: true,
                });

                (gameRoomService as any).pauseTimer = jest.fn();

                fakeRoom = {
                    gameId: 'fake-game-id',
                    hostId: 'fake-organisatior',
                    isLocked: false,
                    messages: [],
                    journalEntries: [],
                    roomId: roomIdTest,
                    players: [
                        {
                            id: virtualPlayerId,
                            isVirtual: true,
                            name: 'VirtualPlayer',
                            stats: { health: { value: 100, maxValue: 100, description: '' } },
                        },
                        {
                            id: opponentId,
                            isVirtual: false,
                            name: 'Opponent',
                            stats: { health: { value: 100, maxValue: 100, description: '' } },
                        },
                    ],
                    playersStats: [
                        {
                            name: 'VirtualPlayer',
                            combats: 0,
                            evasions: 0,
                            victories: 0,
                            defeats: 0,
                            healthLost: 0,
                            damage: 0,
                            itemsCollected: [],
                            tilesVisited: [],
                        },
                        {
                            name: 'Opponent',
                            combats: 0,
                            evasions: 0,
                            victories: 0,
                            defeats: 0,
                            healthLost: 0,
                            damage: 0,
                            itemsCollected: [],
                            tilesVisited: [],
                        },
                    ],
                } as GameRoom;

                jest.spyOn(gameRoomService, 'findRoomById').mockReturnValue(fakeRoom);
                jest.spyOn(gameRoomService, 'pauseTimer').mockImplementation();

                startCombatSpy = jest.spyOn(service, 'startCombat').mockImplementation();
            });

            afterEach(() => {
                jest.restoreAllMocks();
            });

            it('should join non-virtual opponent and call startCombat when isVirtualPlayerStarter is true', () => {
                const fakeSocket = { join: jest.fn() };
                (server.sockets.sockets as Map<string, any>).set(opponentId, fakeSocket);

                service.startVirtualCombat(roomIdTest, virtualPlayerId, opponentId, true);

                const expectedCombatRoom = `combat_${roomIdTest}`;
                expect(fakeSocket.join).toHaveBeenCalledWith(expectedCombatRoom);

                expect(startCombatSpy).toHaveBeenCalledWith(
                    roomIdTest,
                    expectedCombatRoom,
                    [fakeRoom.players.find((p) => p.id === virtualPlayerId), fakeRoom.players.find((p) => p.id === opponentId)],
                    virtualPlayerId,
                    opponentId,
                );

                expect(fakeRoom.playersStats[0].combats).toBe(1);
                expect(fakeRoom.playersStats[1].combats).toBe(1);
            });

            it('should throw error when opponentSocket is not found for non-virtual opponent', () => {
                (server.sockets.sockets as Map<string, any>).clear();

                expect(() => {
                    service.startVirtualCombat(roomIdTest, virtualPlayerId, opponentId, true);
                }).toThrow("L'adversaire n'est pas connecté");
            });

            it('should call startCombat without joining socket when opponent is virtual', () => {
                fakeRoom.players = [
                    {
                        id: virtualPlayerId,
                        isVirtual: true,
                        name: 'VirtualPlayer',
                        stats: { health: { value: 100, maxValue: 100, description: '' } },
                    },
                    {
                        id: opponentId,
                        isVirtual: true,
                        name: 'OpponentVirtual',
                        stats: { health: { value: 100, maxValue: 100, description: '' } },
                    },
                ];
                fakeRoom.playersStats = [
                    {
                        name: 'VirtualPlayer',
                        combats: 0,
                        evasions: 0,
                        victories: 0,
                        defeats: 0,
                        healthLost: 0,
                        damage: 0,
                        itemsCollected: [],
                        tilesVisited: [],
                    },
                    {
                        name: 'OpponentVirtual',
                        combats: 0,
                        evasions: 0,
                        victories: 0,
                        defeats: 0,
                        healthLost: 0,
                        damage: 0,
                        itemsCollected: [],
                        tilesVisited: [],
                    },
                ];
                (server.sockets.sockets as Map<string, any>).clear();

                service.startVirtualCombat(roomIdTest, virtualPlayerId, opponentId, true);
                const expectedCombatRoom = `combat_${roomIdTest}`;

                expect(startCombatSpy).toHaveBeenCalledWith(
                    roomIdTest,
                    expectedCombatRoom,
                    [fakeRoom.players.find((p) => p.id === virtualPlayerId), fakeRoom.players.find((p) => p.id === opponentId)],
                    virtualPlayerId,
                    opponentId,
                );

                expect(fakeRoom.playersStats[0].combats).toBe(1); // VirtualPlayer
                expect(fakeRoom.playersStats[1].combats).toBe(1); // OpponentVirtual
            });

            it('should switch roles when isVirtualPlayerStarter is false', () => {
                const fakeSocket = { join: jest.fn() };
                (server.sockets.sockets as Map<string, any>).set(opponentId, fakeSocket);

                service.startVirtualCombat(roomIdTest, virtualPlayerId, opponentId, false);
                const expectedCombatRoom = `combat_${roomIdTest}`;

                expect(fakeSocket.join).toHaveBeenCalledWith(expectedCombatRoom);

                expect(startCombatSpy).toHaveBeenCalledWith(
                    roomIdTest,
                    expectedCombatRoom,
                    [fakeRoom.players.find((p) => p.id === opponentId), fakeRoom.players.find((p) => p.id === virtualPlayerId)],
                    opponentId,
                    virtualPlayerId,
                );

                expect(fakeRoom.playersStats[0].combats).toBe(1);
                expect(fakeRoom.playersStats[1].combats).toBe(1);
            });

            it('should throw error "La salle n\'existe pas" when no room is found', () => {
                jest.spyOn(gameRoomService, 'findRoomById').mockReturnValue(null);
                expect(() => service.startVirtualCombat('room-1', 'virtual1', 'player2', true)).toThrow("La salle n'existe pas");
            });
        });
    });

    describe('getRandomDelay', () => {
        afterEach(() => {
            jest.restoreAllMocks();
        });

        it('should return a value based on MIN_TIME and MAX_TIME when hasEvasionPoints is true', () => {
            const mockedRandom = 0.5;
            jest.spyOn(global.Math, 'random').mockReturnValue(mockedRandom);
            // Using bracket notation to invoke the private method.
            const result = service['getRandomDelay'](true);
            // The calculation: floor(0.5 * (MAX_TIME - MIN_TIME + 1))
            const expected = Math.floor(mockedRandom * (MAX_TIME - MIN_TIME + 1));
            expect(result).toBe(expected);
        });

        it('should return a value based on MIN_TIME and MAX_TIME_WITHOUT_EVASION when hasEvasionPoints is false', () => {
            const mockedRandom = 0.5;
            jest.spyOn(global.Math, 'random').mockReturnValue(mockedRandom);
            const result = service['getRandomDelay'](false);
            const expected = Math.floor(mockedRandom * (MAX_TIME_WITHOUT_EVASION - MIN_TIME + 1));
            expect(result).toBe(expected);
        });
    });

    describe('updateScore', () => {
        const gameRoomId = 'room-1';

        afterEach(() => {
            jest.restoreAllMocks();
        });

        it('should call endTurn when isByFlight is true and attacker.isVirtual is true', () => {
            const fakeRoom = {
                roomId: gameRoomId,
                players: [
                    { id: 'winner', isVirtual: false },
                    { id: 'attacker', isVirtual: true },
                ],
            };
            (gameRoomService.findRoomsByPlayerId as jest.Mock).mockReturnValue([fakeRoom]);

            const endTurnSpy = jest.spyOn(gameRoomService, 'endTurn').mockImplementation();
            const resumeTurnSpy = jest.spyOn(gameRoomService, 'resumeTurn').mockImplementation();

            const result = service.updateScore(gameRoomId, 'winner', 'attacker', true);
            expect(result).toBeUndefined();
            expect(endTurnSpy).toHaveBeenCalledWith(gameRoomId);
            expect(resumeTurnSpy).not.toHaveBeenCalled();
        });

        it('should call resumeTurn when isByFlight is true and attacker.isVirtual is false', () => {
            const fakeRoom = {
                roomId: gameRoomId,
                players: [
                    { id: 'winner', isVirtual: false },
                    { id: 'attacker', isVirtual: false },
                ],
            };
            (gameRoomService.findRoomsByPlayerId as jest.Mock).mockReturnValue([fakeRoom]);

            const endTurnSpy = jest.spyOn(gameRoomService, 'endTurn').mockImplementation();
            const resumeTurnSpy = jest.spyOn(gameRoomService, 'resumeTurn').mockImplementation();

            const result = service.updateScore(gameRoomId, 'winner', 'attacker', true);
            expect(result).toBeUndefined();
            expect(resumeTurnSpy).toHaveBeenCalledWith(gameRoomId);
            expect(endTurnSpy).not.toHaveBeenCalled();
        });

        it('should call endTurn when isByFlight is false and winnerId === attackerId and winner.isVirtual is true', () => {
            // Here winner and attacker are the same person.
            const fakeRoom = {
                roomId: gameRoomId,
                players: [{ id: 'same', isVirtual: true }],
            };
            (gameRoomService.findRoomsByPlayerId as jest.Mock).mockReturnValue([fakeRoom]);

            const endTurnSpy = jest.spyOn(gameRoomService, 'endTurn').mockImplementation();
            const resumeTurnSpy = jest.spyOn(gameRoomService, 'resumeTurn').mockImplementation();

            const result = service.updateScore(gameRoomId, 'same', 'same', false);
            expect(result).toBeUndefined();
            expect(endTurnSpy).toHaveBeenCalledWith(gameRoomId);
            expect(resumeTurnSpy).not.toHaveBeenCalled();
        });

        it('should call resumeTurn when isByFlight is false and winnerId === attackerId and winner.isVirtual is false', () => {
            const fakeRoom = {
                roomId: gameRoomId,
                players: [{ id: 'same', isVirtual: false }],
            };
            (gameRoomService.findRoomsByPlayerId as jest.Mock).mockReturnValue([fakeRoom]);

            const endTurnSpy = jest.spyOn(gameRoomService, 'endTurn').mockImplementation();
            const resumeTurnSpy = jest.spyOn(gameRoomService, 'resumeTurn').mockImplementation();

            const result = service.updateScore(gameRoomId, 'same', 'same', false);
            expect(result).toBeUndefined();
            expect(resumeTurnSpy).toHaveBeenCalledWith(gameRoomId);
            expect(endTurnSpy).not.toHaveBeenCalled();
        });

        it('should call endTurn when isByFlight is false and winnerId !== attackerId', () => {
            const fakeRoom = {
                roomId: gameRoomId,
                players: [
                    { id: 'winner', isVirtual: false },
                    { id: 'attacker', isVirtual: false },
                ],
            };
            (gameRoomService.findRoomsByPlayerId as jest.Mock).mockReturnValue([fakeRoom]);

            const endTurnSpy = jest.spyOn(gameRoomService, 'endTurn').mockImplementation();
            const resumeTurnSpy = jest.spyOn(gameRoomService, 'resumeTurn').mockImplementation();

            const result = service.updateScore(gameRoomId, 'winner', 'attacker', false);
            expect(result).toBeUndefined();
            expect(endTurnSpy).toHaveBeenCalledWith(gameRoomId);
            expect(resumeTurnSpy).not.toHaveBeenCalled();
        });
    });

    describe('updateHealthPoints', () => {
        it('should update health points for both players', () => {
            service.startCombat(roomId, combatRoomId, JSON.parse(JSON.stringify(mockPlayers)), 'player1', 'player2');
            (service as any).attackerHealthPts = 90;
            (service as any).defenderHealthPts = 70;

            service.updateHealthPoints(combatRoomId);

            const combat = service['findCombatRoomById'](combatRoomId);
            expect(combat.players[0].stats.health.value).toBe(90);
            expect(combat.players[1].stats.health.value).toBe(70);
        });
    });

    describe('findPlayerById', () => {
        beforeEach(() => {
            service.startCombat(roomId, combatRoomId, JSON.parse(JSON.stringify(mockPlayers)), 'player1', 'player2');
        });

        it('should find player by id', () => {
            const player = service['findPlayerById'](combatRoomId, 'player1');
            expect(player.id).toBe('player1');
            expect(player.name).toBe('Alice');
        });

        it('should return undefined if player not found', () => {
            const player = service['findPlayerById'](combatRoomId, 'nonexistent');
            expect(player).toBeUndefined();
        });
    });

    describe('findCombatRoomById', () => {
        it('should find combat room by id', () => {
            service.startCombat(roomId, combatRoomId, JSON.parse(JSON.stringify(mockPlayers)), 'player1', 'player2');

            const combat = service['findCombatRoomById'](combatRoomId);
            expect(combat).toBeDefined();
            expect(combat.combatRoomId).toBe(combatRoomId);
        });

        it('should return undefined if combat not found', () => {
            const combat = service['findCombatRoomById']('nonexistent');
            expect(combat).toBeUndefined();
        });
    });

    describe('isVirtualCombatOnly', () => {
        it('should return true when all players are virtual', () => {
            const virtualPlayers = [
                { ...mockPlayers[0], isVirtual: true },
                { ...mockPlayers[1], isVirtual: true },
            ];
            service.startCombat(roomId, combatRoomId, virtualPlayers, 'player1', 'player2');

            const result = service['isVirtualCombatOnly'](combatRoomId);
            expect(result).toBe(true);
        });

        it('should return false when not all players are virtual', () => {
            const mixedPlayers = [
                { ...mockPlayers[0], isVirtual: true },
                { ...mockPlayers[1], isVirtual: false },
            ];
            service.startCombat(roomId, combatRoomId, mixedPlayers, 'player1', 'player2');

            const result = service['isVirtualCombatOnly'](combatRoomId);
            expect(result).toBe(false);
        });
    });

    describe('isCurrentPlayerAttacker', () => {
        it('should return true when current player is attacker', () => {
            service.startCombat(roomId, combatRoomId, JSON.parse(JSON.stringify(mockPlayers)), 'player1', 'player2');

            const result = service['isCurrentPlayerAttacker'](combatRoomId);
            expect(result).toBe(true);
        });

        it('should return false when current player is defender', () => {
            service.startCombat(roomId, combatRoomId, JSON.parse(JSON.stringify(mockPlayers)), 'player1', 'player2');

            const combat = service['findCombatRoomById'](combatRoomId);
            combat.currentPlayerId = combat.defenderId;

            const result = service['isCurrentPlayerAttacker'](combatRoomId);
            expect(result).toBe(false);
        });
    });

    describe('acquireLock', () => {
        it('should acquire lock when not already locked', () => {
            const result = service['acquireLock'](combatRoomId);
            expect(result).toBe(true);

            // Should be locked now
            const result2 = service['acquireLock'](combatRoomId);
            expect(result2).toBe(false);
        });

        it('should return false when already locked', () => {
            service['acquireLock'](combatRoomId);
            const result = service['acquireLock'](combatRoomId);
            expect(result).toBe(false);
        });
    });

    describe('releaseLock', () => {
        it('should release lock', () => {
            service['acquireLock'](combatRoomId);
            expect(service['combatLocks'].get(combatRoomId)).toBe(true);

            service['releaseLock'](combatRoomId);
            expect(service['combatLocks'].get(combatRoomId)).toBeUndefined();
        });

        it('should not throw when releasing non-existent lock', () => {
            expect(() => service['releaseLock']('nonexistent')).not.toThrow();
        });
    });

    describe('attemptFlight', () => {
        beforeEach(() => {
            jest.clearAllMocks();
            service.startCombat(roomId, combatRoomId, JSON.parse(JSON.stringify(mockPlayers)), 'player1', 'player2');
            (server.to(combatRoomId).emit as jest.Mock).mockClear();
        });

        it('devrait réussir la fuite quand Math.random <= FLIGHT_CHANCES', async () => {
            jest.spyOn(global.Math, 'random').mockReturnValue(0.2);
            await service.attemptFlight(combatRoomId);

            const emitMock = server.to(combatRoomId).emit;
            const calls = (emitMock as jest.Mock).mock.calls;

            const flightResultCall = calls.find((call) => call[0] === GameRoomEvents.FlightAttemptResult);
            expect(flightResultCall[1]).toMatchObject({
                isSuccess: true,
            });

            const endCombatCall = calls.find((call) => call[0] === GameRoomEvents.EndCombat);
            expect(endCombatCall).toBeTruthy();
        });

        it("devrait échouer la fuite et réduire les points d'évasion quand Math.random > FLIGHT_CHANCES", async () => {
            jest.spyOn(global.Math, 'random').mockReturnValue(0.5);

            await service.attemptFlight(combatRoomId);

            const emitMock = server.to(combatRoomId).emit;
            const calls = (emitMock as jest.Mock).mock.calls;

            const flightResultCall = calls.find((call) => call[0] === GameRoomEvents.FlightAttemptResult);
            expect(flightResultCall[1]).toMatchObject({
                isSuccess: false,
                attackerEvasionPoints: 1,
            });
        });

        it("devrait gérer le cas où le combat n'existe pas", async () => {
            // eslint-disable-next-line @typescript-eslint/no-empty-function
            const consoleSpy = jest.spyOn(console, 'log').mockImplementation(() => {});

            await service.attemptFlight('nonexistent');

            expect(consoleSpy).not.toHaveBeenCalled();
        });

        it("devrait gérer le cas où l'acquisition du lock échoue pour la fuite", async () => {
            service.startCombat(roomId, combatRoomId, JSON.parse(JSON.stringify(mockPlayers)), 'player1', 'player2');

            service['acquireLock'](combatRoomId);

            await expect(service.attemptFlight(combatRoomId)).rejects.toThrow('Combat action already in progress');
        });

        it('devrait gérer le cas où le timer est déjà cleared pour la fuite', async () => {
            jest.spyOn(global.Math, 'random').mockReturnValue(0.2);
            service.startCombat(roomId, combatRoomId, JSON.parse(JSON.stringify(mockPlayers)), 'player1', 'player2');

            const combat = service['findCombatRoomById'](combatRoomId);
            combat.turnTimer = undefined;

            await service.attemptFlight(combatRoomId);

            expect(combat.turnTimer).toBeUndefined();
        });
    });

    describe('prepareNextTurn', () => {
        beforeEach(() => {
            jest.clearAllMocks();
            service.startCombat(roomId, combatRoomId, JSON.parse(JSON.stringify(mockPlayers)), 'player1', 'player2');
        });

        it('devrait inverser les rôles currentPlayerId et currentOpponentId', () => {
            const initialCombat = service['findCombatRoomById'](combatRoomId);
            const initialCurrentPlayerId = initialCombat.currentPlayerId;
            const initialCurrentOpponentId = initialCombat.currentOpponentId;

            service.prepareNextTurn(combatRoomId);

            const combat = service['findCombatRoomById'](combatRoomId);
            expect(combat.currentPlayerId).toBe(initialCurrentOpponentId);
            expect(combat.currentOpponentId).toBe(initialCurrentPlayerId);

            const emitMock = server.to(combatRoomId).emit;
            const calls = (emitMock as jest.Mock).mock.calls;

            const turnStartedCall = calls.find((call) => call[0] === GameRoomEvents.CombatTurnStarted);
            expect(turnStartedCall[1].currentPlayerId).toBe(initialCurrentOpponentId);
            expect(turnStartedCall[1].currentOpponentId).toBe(initialCurrentPlayerId);
        });

        it("devrait terminer le combat si la santé de l'opposant est <= 0", () => {
            const combat = service['findCombatRoomById'](combatRoomId);
            const opponent = combat.players.find((p) => p.id === combat.currentOpponentId);
            opponent.stats.health.value = 0;

            const endCombatSpy = jest.spyOn(service, 'endCombat');

            service.prepareNextTurn(combatRoomId);

            expect(endCombatSpy).toHaveBeenCalledWith(combatRoomId, false);
        });
    });

    describe('abandonCombat', () => {
        beforeEach(() => {
            jest.clearAllMocks();
            service.startCombat(roomId, combatRoomId, JSON.parse(JSON.stringify(mockPlayers)), 'player1', 'player2');
            (server.to(combatRoomId).emit as jest.Mock).mockClear();
        });

        it("devrait mettre à jour le score pour l'adversaire", () => {
            const updateScoreSpy = jest.spyOn(service, 'updateScore');

            const combat = service['findCombatRoomById'](combatRoomId);
            const opponentId = combat.currentOpponentId;

            service.abandonCombat(combatRoomId, true);

            expect(updateScoreSpy).toHaveBeenCalledWith(combatRoomId, opponentId, combat.attackerId, true);
        });
    });
});

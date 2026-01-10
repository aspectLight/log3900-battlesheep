/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable max-lines */
/* eslint-disable @typescript-eslint/no-magic-numbers */
/* eslint-disable prettier/prettier */
import { GameRoomEvents } from '@common/socket.constants';
import { Player, VirtualPlayerType } from '@app/interfaces/player';
import { GameRoomService } from '@app/services/game-room/game-room.service';
import { Test, TestingModule } from '@nestjs/testing';
import { Server } from 'socket.io';
import { GameCombatService } from './game-combat.service';
import { MIN_TIME, MAX_TIME, MAX_TIME_WITHOUT_EVASION, COUNTDOWN_INTERVAL } from '@app/constants/game-combat.constants';
import { GameRoom } from '@app/interfaces/game-room';

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

    let combatRoomId = 'combat-123';
    const roomId = 'game-room-123';

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
                    // Make sure to include the players array with the players used in your tests.
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

        const module: TestingModule = await Test.createTestingModule({
            providers: [GameCombatService, { provide: GameRoomService, useValue: mockGameRoomService }],
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

        it('devrait clearInterval et émettre PerformAttack lorsque le compte à rebours est terminé', () => {
            // Démarrer le tour de combat, ce qui va lancer un setInterval
            const modifiedPlayers = JSON.parse(JSON.stringify(mockPlayers));

            service.startCombat(roomId, combatRoomId, modifiedPlayers, 'player1', 'player2');
            service.startTurn(combatRoomId);

            // Récupérer le callback passé à setInterval
            const setIntervalMock = global.setInterval as unknown as jest.Mock;
            const callback = setIntervalMock.mock.calls[0][0];

            // Le tour démarre avec un compte à rebours égal à TURN_DURATION (5 si le joueur a des points d'évasion)
            // Appeler la callback 6 fois permet d'amener countdown de 5 jusqu'à -1
            for (let i = 0; i < 6; i++) {
                callback();
            }

            // Vérifier que clearInterval a été appelé avec l'ID d'intervalle retourné par setInterval
            expect(clearInterval).toHaveBeenCalledWith('interval-id');

            // Dans notre configuration, le currentPlayerId correspond à 'player1'
            // Vérifier que l'événement PerformAttack est émis sur le socket du currentPlayerId avec combatRoomId
            expect(server.to).toHaveBeenCalledWith('player1');
            expect(server.to('player1').emit).toHaveBeenCalledWith(GameRoomEvents.PerformAttack, combatRoomId);
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
            // Créer une copie des joueurs pour le test
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

        it('devrait calculer correctement les dommages et mettre à jour la vie du défenseur', () => {
            const attackValue = 20;
            const defenseValue = 5;

            service.attack(combatRoomId, attackValue, defenseValue);

            const emitMock = server.to(combatRoomId).emit as jest.Mock;
            const calls = (emitMock as jest.Mock).mock.calls;

            const attackResultCall = calls.find((call) => call[0] === GameRoomEvents.AttackResult);
            expect(attackResultCall[1]).toMatchObject({
                isAttackSuccess: true,
                attackValue: 20,
                defenseValue: 5,
            });

            expect(attackResultCall[1].opponentHealthPoints).toBeLessThan(80);

            expect(gameRoomService.findRoomById).toHaveBeenCalledWith(roomId);
            expect(gameRoomService.findRoomById(roomId).playersStats[1].healthLost).toBe(attackValue - defenseValue);
            expect(gameRoomService.findRoomById(roomId).playersStats[0].damage).toBe(attackValue - defenseValue);
        });

        it("devrait envoyer un échec d'attaque quand la défense est supérieure à l'attaque", () => {
            const attackValue = 10;
            const defenseValue = 15;

            service.attack(combatRoomId, attackValue, defenseValue);

            const emitMock = server.to(combatRoomId).emit;
            const calls = (emitMock as jest.Mock).mock.calls;

            const attackResultCall = calls.find((call) => call[0] === GameRoomEvents.AttackResult);
            expect(attackResultCall[1]).toMatchObject({
                isAttackSuccess: false,
                attackValue: 10,
                defenseValue: 15,
            });
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

        it("devrait mettre à jour le score et reprendre le tour si l'attaquant gagne", () => {
            const combat = service['findCombatRoomById'](combatRoomId);
            combat.currentPlayerId = combat.attackerId;
            combat.currentOpponentId = combat.defenderId;

            service.endCombat(combatRoomId, false);

            const emitMock = server.to(combatRoomId).emit;
            expect(emitMock).toHaveBeenCalledWith(GameRoomEvents.EndCombat, combat.currentPlayerId, combat.currentOpponentId);

            expect(server.socketsLeave).toHaveBeenCalledWith(combatRoomId);

            expect(server.to('game-room-123').emit).toHaveBeenCalledWith(GameRoomEvents.UpdateScore, combat.currentPlayerId);
            expect(gameRoomService.resumeTurn).toHaveBeenCalledWith('game-room-123');
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
            // Crée un spy direct sur updateScore pour vérifier l'appel
            const updateScoreSpy = jest.spyOn(service, 'updateScore');

            // Obtient l'opponent ID avant d'appeler la méthode
            const combat = service['findCombatRoomById'](combatRoomId);
            const opponentId = combat.currentOpponentId;

            service.abandonCombat(combatRoomId, true);

            // Vérifie que updateScore a été appelé avec l'ID de l'adversaire
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
            // Prepare players such that the current (attacker) is virtual and defensive.
            const players = JSON.parse(JSON.stringify(mockPlayers));
            players[0].isVirtual = true;
            players[0].profile = VirtualPlayerType.Defensive;
            // Ensure the player's health is full on start (this value is stored as the initial health)
            players[0].stats.health.value = 100;

            // Spy on getRandomDelay BEFORE calling startCombat so it returns 4.
            jest.spyOn(service as any, 'getRandomDelay').mockReturnValue(4);

            // Now start the combat (which will also trigger startTurn).
            service.startCombat(roomId, combatRoomId, players, 'player1', 'player2');

            // Retrieve the combat object and the current player.
            const combat = service['findCombatRoomById'](combatRoomId);
            const currentPlayer = combat.players.find((player) => player.id === combat.currentPlayerId);

            // Simulate that the current player's health dropped (from initial 100 to 90)
            currentPlayer.stats.health.value = 90;
            // Ensure the player has evasion points.
            currentPlayer.evasionPoints = 1;

            // Spy on attemptFlight
            const attemptFlightSpy = jest.spyOn(service, 'attemptFlight');

            // Retrieve the setInterval callback (the timer started by startTurn).
            const setIntervalMock = global.setInterval as unknown as jest.Mock;
            const callback = setIntervalMock.mock.calls[setIntervalMock.mock.calls.length - 1][0];

            // Call the timer callback once.
            // On the first tick, countdown (starting at 5) is emitted and then decremented to 4.
            // Since 4 equals our mocked randomDelay and the current player is virtual, the condition will be met.
            callback();

            // Verify that attemptFlight was called with the combat room id.
            expect(attemptFlightSpy).toHaveBeenCalledWith(combatRoomId);
        });

        it('should emit CalculateVirtualPlayerAttack when a virtual player does not meet the defensive condition', () => {
            // Prepare players: only the attacker (player1) is virtual with a non-defensive profile.
            const players = JSON.parse(JSON.stringify(mockPlayers));
            players[0].isVirtual = true;
            players[0].profile = VirtualPlayerType.Aggressive; // non-defensive profile
            players[0].stats.health.value = 100; // full health

            // Create a map to hold our unique fake BroadcastOperator objects for each id.
            const emitMocks = new Map<string, { emit: jest.Mock }>();

            // Override server.to so each call returns a fake BroadcastOperator.
            // We cast our returned object to 'any' to bypass type issues.
            server.to = jest.fn((id: string) => {
                const fakeBroadcastOperator = { emit: jest.fn() } as any;
                emitMocks.set(id, fakeBroadcastOperator);
                return fakeBroadcastOperator;
            });

            // Spy on getRandomDelay early so that startTurn uses our mocked value.
            jest.spyOn(service as any, 'getRandomDelay').mockReturnValue(4);

            // Start combat: attacker is player1, defender is player2.
            service.startCombat(roomId, combatRoomId, players, 'player1', 'player2');

            // Retrieve combat details.
            const combat = service['findCombatRoomById'](combatRoomId);
            const currentPlayerId = combat.currentPlayerId; // expected "player1"
            const currentOpponentId = combat.currentOpponentId; // expected "player2"

            // Retrieve the last setInterval callback (the timer from startTurn).
            const setIntervalMock = global.setInterval as unknown as jest.Mock;
            const callback = setIntervalMock.mock.calls[setIntervalMock.mock.calls.length - 1][0];

            // Execute the timer callback once.
            callback();

            // The expected behavior: since the current player is virtual but non-defensive,
            // the service should emit CalculateVirtualPlayerAttack to currentOpponentId ("player2").
            expect(server.to).toHaveBeenCalledWith(currentOpponentId);

            // Retrieve the fake BroadcastOperator used for currentOpponentId.
            const targetBroadcastOperator = emitMocks.get(currentOpponentId);
            expect(targetBroadcastOperator).toBeDefined();
            expect(targetBroadcastOperator.emit).toHaveBeenCalledWith(
                GameRoomEvents.CalculateVirtualPlayerAttack,
                false, // isVirtualCombatOnly should be false since not every player is virtual
                currentPlayerId,
                currentOpponentId,
                combatRoomId,
            );
        });

        describe('startVirtualCombat', () => {
            const roomIdTest = 'room-1';
            const virtualPlayerId = 'virtual1';
            const opponentId = 'player2';
            let fakeRoom: GameRoom;
            let startCombatSpy: jest.SpyInstance;

            beforeEach(() => {
                // Set up server.sockets.sockets as a Map to simulate socket storage.
                Object.defineProperty(server, 'sockets', {
                    value: { sockets: new Map() },
                    configurable: true, // Allows overriding later if needed.
                });

                // Create a fake room that will be returned by gameRoomService.findRoomById.
                // Here we start with the opponent as non-virtual.

                (gameRoomService as any).pauseTimer = jest.fn();

                fakeRoom = {
                    gameId: 'fake-game-id',
                    organisatorId: 'fake-organisatior',
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
                };

                // Stub the gameRoomService methods used in startVirtualCombat.
                jest.spyOn(gameRoomService, 'findRoomById').mockReturnValue(fakeRoom);
                jest.spyOn(gameRoomService, 'pauseTimer').mockImplementation();

                // Spy on startCombat to verify it gets called with proper arguments.
                startCombatSpy = jest.spyOn(service, 'startCombat').mockImplementation();
            });

            afterEach(() => {
                jest.restoreAllMocks();
            });

            it('should join non-virtual opponent and call startCombat when isVirtualPlayerStarter is true', () => {
                // For isVirtualPlayerStarter = true:
                // Attacker should be the virtual player (virtualPlayerId)
                // Defender should be the opponent (opponentId)
                // Set up a fake socket for the opponent.
                const fakeSocket = { join: jest.fn() };
                (server.sockets.sockets as Map<string, any>).set(opponentId, fakeSocket);

                service.startVirtualCombat(roomIdTest, virtualPlayerId, opponentId, true);

                const expectedCombatRoom = `combat_${roomIdTest}`;
                // The fake socket join method should be called with the expected combat room.
                expect(fakeSocket.join).toHaveBeenCalledWith(expectedCombatRoom);

                // Verify that startCombat is called with the correct parameters.
                expect(startCombatSpy).toHaveBeenCalledWith(
                    roomIdTest,
                    expectedCombatRoom,
                    [fakeRoom.players.find((p: any) => p.id === virtualPlayerId), fakeRoom.players.find((p: any) => p.id === opponentId)],
                    virtualPlayerId,
                    opponentId,
                );
            });

            it('should throw error when opponentSocket is not found for non-virtual opponent', () => {
                // Ensure that the socket map does NOT contain the opponent.
                (server.sockets.sockets as Map<string, any>).clear();

                expect(() => {
                    service.startVirtualCombat(roomIdTest, virtualPlayerId, opponentId, true);
                }).toThrow("L'adversaire n'est pas connecté");
            });

            it('should call startCombat without joining socket when opponent is virtual', () => {
                // Modify the room so that the opponent is virtual.
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
                // No socket is needed when the opponent is virtual.
                (server.sockets.sockets as Map<string, any>).clear();

                service.startVirtualCombat(roomIdTest, virtualPlayerId, opponentId, true);
                const expectedCombatRoom = `combat_${roomIdTest}`;

                // In this branch, the if-condition "if (!opponent.isVirtual)" is skipped.
                // So startCombat should be called with parameters based on the original order.
                expect(startCombatSpy).toHaveBeenCalledWith(
                    roomIdTest,
                    expectedCombatRoom,
                    [fakeRoom.players.find((p: any) => p.id === virtualPlayerId), fakeRoom.players.find((p: any) => p.id === opponentId)],
                    virtualPlayerId,
                    opponentId,
                );
            });

            it('should switch roles when isVirtualPlayerStarter is false', () => {
                // For isVirtualPlayerStarter = false:
                // Attacker becomes the opponent, and defender becomes the virtual player.
                // With opponent non-virtual, we need a socket.
                const fakeSocket = { join: jest.fn() };
                (server.sockets.sockets as Map<string, any>).set(opponentId, fakeSocket);

                service.startVirtualCombat(roomIdTest, virtualPlayerId, opponentId, false);
                const expectedCombatRoom = `combat_${roomIdTest}`;

                // The socket join should still be called because opponent is non-virtual.
                expect(fakeSocket.join).toHaveBeenCalledWith(expectedCombatRoom);

                // In this branch, attacker should be the one with id equal to opponentId,
                // and defender should be the one with id equal to virtualPlayerId.
                expect(startCombatSpy).toHaveBeenCalledWith(
                    roomIdTest,
                    expectedCombatRoom,
                    [fakeRoom.players.find((p: any) => p.id === opponentId), fakeRoom.players.find((p: any) => p.id === virtualPlayerId)],
                    opponentId,
                    virtualPlayerId,
                );
            });

            it('should throw error "La salle n\'existe pas" when no room is found', () => {
                jest.spyOn(gameRoomService, 'findRoomById').mockReturnValue(null);
                expect(() => service.startVirtualCombat('room-1', 'virtual1', 'player2', true)).toThrow("La salle n'existe pas");
            });
        });

        describe('startTurn - virtual player behavior (all players virtual, organisator branch)', () => {
            const roomIdTest = 'room-virtual';
            const virtualPlayerId = 'virtual1';
            const opponentId = 'virtual2';
            const organisatorId = 'org-123';
            let fakeRoom: GameRoom;
            let emitMocks: Map<string, { emit: jest.Mock }>;
        
            beforeEach(() => {
                // Clear active combats so that we have a fresh state.
                service['activeCombats'] = [];
        
                // Create a fake room with organisatorId and two virtual players.
                fakeRoom = {
                    gameId: 'fake-game-id',
                    isLocked: false,
                    messages: [],
                    journalEntries: [],
                    roomId: roomIdTest,
                    organisatorId, // This property is used when all players are virtual.
                    players: [
                        {
                            id: virtualPlayerId,
                            isVirtual: true,
                            profile: VirtualPlayerType.Aggressive, // Use non-defensive to force the "else" branch in startTurn.
                            stats: {
                                health: { value: 100, maxValue: 100, description: '' },
                                speed: { value: 15, maxValue: 15, description: '' },
                            },
                            evasionPoints: 1,
                        },
                        {
                            id: opponentId,
                            isVirtual: true,
                            profile: VirtualPlayerType.Aggressive,
                            stats: {
                                health: { value: 100, maxValue: 100, description: '' },
                                speed: { value: 10, maxValue: 10, description: '' },
                            },
                            evasionPoints: 1,
                        },
                    ],
                };
        
                // Stub gameRoomService.findRoomById to return our fake room.
                jest.spyOn(gameRoomService, 'findRoomById').mockImplementation((id: string) => {
                    return id === roomIdTest ? fakeRoom : fakeRoom;
                });
        
                // Ensure gameRoomService.pauseTimer exists.
                (gameRoomService as any).pauseTimer = jest.fn();
        
                // Override server.to so that each call returns a fake broadcast operator.
                // We also store these objects in a Map so we can later inspect the emit calls.
                emitMocks = new Map();
                (server.to as jest.Mock).mockImplementation((id: string) => {
                    const broadcastOperator = { emit: jest.fn() };
                    emitMocks.set(id, broadcastOperator);
                    return broadcastOperator;
                });
        
                // Override getRandomDelay so that it returns 4.
                // This makes the timer callback trigger when countdown (TURN_DURATION, assumed to be 5) reaches 4.
                jest.spyOn(service as any, 'getRandomDelay').mockReturnValue(4);
        
                // Use fake timers so we can simulate time passage.
                jest.useFakeTimers();
            });
        
            afterEach(() => {
                jest.useRealTimers();
                jest.restoreAllMocks();
            });
        
            it('should emit CalculateVirtualPlayerAttack using organisatorId when all players are virtual', () => {
                // Call startVirtualCombat with isVirtualPlayerStarter true.
                // This will call startCombat and then startTurn.
                service.startVirtualCombat(roomIdTest, virtualPlayerId, opponentId, true);
        
                // The combatRoom is built as `combat_${roomIdTest}`.
                combatRoomId = `combat_${roomIdTest}`;
                // Retrieve the combat from activeCombats.
                const combat = service['findCombatRoomById'](combatRoomId);
                expect(combat).toBeDefined();
        
                // With evasionPoints available, turnDuration should be TURN_DURATION (typically 5).
                // Our timer callback compares the current countdown against randomDelay (which is 4).
                // Instead of manually retrieving the callback from setInterval's mock.calls, we simulate the passage of one tick.
                jest.advanceTimersByTime(COUNTDOWN_INTERVAL);
        
                // Now, the timer callback should have been executed and, because both players are virtual,
                // isVirtualCombatOnly returns true. Thus, virtualAttackCalculatorId is set to this.generalRoom.organisatorId.
                // Verify that server.to was called with organisatorId.
                expect(server.to).toHaveBeenCalledWith(organisatorId);
        
                // Retrieve the fake broadcast operator for organisatorId.
                const operator = emitMocks.get(organisatorId);
                expect(operator).toBeDefined();
        
                // Finally, confirm that the emitted event is CalculateVirtualPlayerAttack with the expected parameters.
                // Note: The parameters include:
                // - isVirtualCombatOnly (true in this case),
                // - currentPlayerId, currentOpponentId, and combatRoomId.
                expect(operator.emit).toHaveBeenCalledWith(
                    GameRoomEvents.CalculateVirtualPlayerAttack,
                    true,
                    combat.currentPlayerId,
                    combat.currentOpponentId,
                    combatRoomId
                );
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
                    { id: 'attacker', isVirtual: true }
                ]
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
                    { id: 'attacker', isVirtual: false }
                ]
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
                players: [
                    { id: 'same', isVirtual: true }
                ]
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
                players: [
                    { id: 'same', isVirtual: false }
                ]
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
                    { id: 'attacker', isVirtual: false }
                ]
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
});

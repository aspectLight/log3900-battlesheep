/* eslint-disable @typescript-eslint/no-magic-numbers */
/* eslint-disable prettier/prettier */
import { Test, TestingModule } from '@nestjs/testing';
import { GameCombatService } from './game-combat.service';
import { GameRoomService } from '@app/services/game-room/game-room.service';
import { GameRoomEvents } from '@app/gateways/game-room/game-room.gateway.events';
import { Player } from '@app/interfaces/player';
import { Server } from 'socket.io';

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
        speed: { value: 15, maxValue: 15, description: '' }
      },
      evasionPoints: 2
    },
    {
      id: 'player2',
      stats: {
        health: { value: 80, maxValue: 80, description: '' },
        attack: { value: 15, maxValue: 15, description: '' },
        defense: { value: 5, maxValue: 5, description: '' },
        speed: { value: 10, maxValue: 10, description: '' }
      },
      evasionPoints: 2
    }
  ];

  const combatRoomId = 'combat-123';

  beforeEach(async () => {
    server = {
      to: jest.fn().mockReturnValue({
        emit: jest.fn()
      }),
      socketsLeave: jest.fn()
    } as unknown as Server;

    const mockGameRoomService = {
      findRoomsByPlayerId: jest.fn().mockReturnValue([{ roomId: 'game-room-123' }]),
      resumeTurn: jest.fn(),
      endTurn: jest.fn()
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        GameCombatService,
        { provide: GameRoomService, useValue: mockGameRoomService }
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
      service.startCombat(combatRoomId, JSON.parse(JSON.stringify(mockPlayers)), 'player1', 'player2');

      expect(server.to).toHaveBeenCalledWith(combatRoomId);
      
      const emitMock = server.to(combatRoomId).emit as jest.Mock;
      expect(emitMock).toHaveBeenCalledWith(
        GameRoomEvents.CombatTurnStarted,
        expect.objectContaining({
          combatRoomId,
          attackerId: 'player1',
          defenderId: 'player2',
          currentPlayerId: 'player1',
          currentOpponentId: 'player2'
        })
      );
    });

    it('devrait initialiser un nouveau combat avec le défenseur commençant s\'il est plus rapide', () => {
      const modifiedPlayers = JSON.parse(JSON.stringify(mockPlayers));
      modifiedPlayers[1].stats.speed.value = 20;

      service.startCombat(combatRoomId, modifiedPlayers, 'player1', 'player2');

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
      service.startCombat(combatRoomId, JSON.parse(JSON.stringify(mockPlayers)), 'player1', 'player2');
      (server.to(combatRoomId).emit as jest.Mock).mockClear();
    });

    it('devrait démarrer un tour avec le compte à rebours', () => {
      service.startTurn(combatRoomId);

      expect(global.setInterval).toHaveBeenCalled();
      
      const intervalCallback = (global.setInterval as unknown as jest.Mock).mock.calls[0][0];
      intervalCallback();

      expect(server.to).toHaveBeenCalledWith(combatRoomId);
      expect(server.to(combatRoomId).emit).toHaveBeenCalledWith(
        GameRoomEvents.UpdateCombatCountDown,
        5
      );
    });

    it('should throw an error if the combat room is not found', () => {
      expect(() => service.startTurn('nonexistentCombat')).toThrowError("Le combat n'existe pas");
    });
  });

  describe('attack', () => {
    beforeEach(() => {
      jest.clearAllMocks();
      service.startCombat(combatRoomId, JSON.parse(JSON.stringify(mockPlayers)), 'player1', 'player2');
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
        defenseValue: 5
      });
      
      expect(attackResultCall[1].opponentHealthPoints).toBeLessThan(80);
    });

    it('devrait envoyer un échec d\'attaque quand la défense est supérieure à l\'attaque', () => {
      const attackValue = 10;
      const defenseValue = 15;

      service.attack(combatRoomId, attackValue, defenseValue);

      const emitMock = server.to(combatRoomId).emit;
      const calls = (emitMock as jest.Mock).mock.calls;
      
      const attackResultCall = calls.find((call) => call[0] === GameRoomEvents.AttackResult);
      expect(attackResultCall[1]).toMatchObject({
        isAttackSuccess: false,
        attackValue: 10,
        defenseValue: 15
      });
    });
  });

  describe('attemptFlight', () => {
    beforeEach(() => {
      jest.clearAllMocks();
      service.startCombat(combatRoomId, JSON.parse(JSON.stringify(mockPlayers)), 'player1', 'player2');
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
        isSuccess: true
      });
      
      const endCombatCall = calls.find((call) => call[0] === GameRoomEvents.EndCombat);
      expect(endCombatCall).toBeTruthy();
    });

    it('devrait échouer la fuite et réduire les points d\'évasion quand Math.random > FLIGHT_CHANCES', () => {
      jest.spyOn(global.Math, 'random').mockReturnValue(0.5);

      service.attemptFlight(combatRoomId);

      const emitMock = server.to(combatRoomId).emit;
      const calls = (emitMock as jest.Mock).mock.calls;
      
      const flightResultCall = calls.find((call) => call[0] === GameRoomEvents.FlightAttemptResult);
      expect(flightResultCall[1]).toMatchObject({
        isSuccess: false,
        attackerEvasionPoints: 1 
      });
    });
  });

  describe('prepareNextTurn', () => {
    beforeEach(() => {
      jest.clearAllMocks();
      service.startCombat(combatRoomId, JSON.parse(JSON.stringify(mockPlayers)), 'player1', 'player2');
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

    it('devrait terminer le combat si la santé de l\'opposant est <= 0', () => {
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
      service.startCombat(combatRoomId, JSON.parse(JSON.stringify(mockPlayers)), 'player1', 'player2');
      (server.to(combatRoomId).emit as jest.Mock).mockClear();
    });

    it('devrait mettre à jour le score et reprendre le tour si l\'attaquant gagne', () => {
      const combat = service['findCombatRoomById'](combatRoomId);
      combat.currentPlayerId = combat.attackerId;
      combat.currentOpponentId = combat.defenderId;

      service.endCombat(combatRoomId, false);

      const emitMock = server.to(combatRoomId).emit;
      expect(emitMock).toHaveBeenCalledWith(
        GameRoomEvents.EndCombat,
        combat.currentPlayerId
      );

      expect(server.socketsLeave).toHaveBeenCalledWith(combatRoomId);
      
      expect(server.to('game-room-123').emit).toHaveBeenCalledWith(
        GameRoomEvents.UpdateScore,
        combat.currentPlayerId
      );
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
      service.startCombat(combatRoomId, JSON.parse(JSON.stringify(mockPlayers)), 'player1', 'player2');
      (server.to(combatRoomId).emit as jest.Mock).mockClear();
    });
  
    it('devrait mettre à jour le score pour l\'adversaire', () => {
      // Crée un spy direct sur updateScore pour vérifier l'appel
      const updateScoreSpy = jest.spyOn(service, 'updateScore');
      
      // Obtient l'opponent ID avant d'appeler la méthode
      const combat = service['findCombatRoomById'](combatRoomId);
      const opponentId = combat.currentOpponentId;
      
      service.abandonCombat(combatRoomId, true);
  
      // Vérifie que updateScore a été appelé avec l'ID de l'adversaire
      expect(updateScoreSpy).toHaveBeenCalledWith(
        opponentId,
        combat.attackerId,
        true
      );
    });
  });

  describe('findCombatsByPlayerId', () => {
    beforeEach(() => {
      jest.clearAllMocks();
      service['activeCombats'] = []; 
      
      service.startCombat(combatRoomId, JSON.parse(JSON.stringify(mockPlayers)), 'player1', 'player2');
      
      const player3 = {
        id: 'player3',
        stats: {
                    health: { value: 90, maxValue: 90, description: '' },
                    attack: { value: 18, maxValue: 18, description: '' },
                    defense: { value: 8, maxValue: 8, description: '' },
                    speed: { value: 12, maxValue: 12, description: '' },
        },
        evasionPoints: 2
      };
      
      const players2 = [player3, mockPlayers[0]];
      service.startCombat('combat-456', players2, 'player3', 'player1');
    });

    it('devrait trouver tous les combats liés à un joueur', () => {
      const combats = service.findCombatsByPlayerId('player1');
      expect(combats.length).toBe(2);
      expect(combats[0].combatRoomId).toBe(combatRoomId);
      expect(combats[1].combatRoomId).toBe('combat-456');
    });

    it('devrait retourner un tableau vide si aucun combat n\'est trouvé', () => {
      const combats = service.findCombatsByPlayerId('non-existent');
      expect(combats.length).toBe(0);
    });
  });
});

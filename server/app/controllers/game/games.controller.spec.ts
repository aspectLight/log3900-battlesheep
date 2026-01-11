/* eslint-disable @typescript-eslint/no-explicit-any */

import { BOARD_SIZES } from '@app/constants/game-validation.constants';
import { Board } from '@app/interfaces/board';
import { Cell } from '@app/interfaces/cell';
import { TileType } from '@app/interfaces/tile';
import { CreateGameDto } from '@app/model/dto/game/create-game.dto';
import { UpdateGameDto } from '@app/model/dto/game/update-game.dto';
import { GameValidationService } from '@app/services/game-validation/game-validation.service';
import { GameService } from '@app/services/game/game.service';
import { ErrorMessages } from '@common/error-messages.constants';
import { HttpStatus } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { Response } from 'express';
import { GameController } from './games.controller';

describe('GamesController', () => {
    let controller: GameController;
    let gameService: jest.Mocked<GameService>;
    let gameValidationService: jest.Mocked<GameValidationService>;
    let mockResponse: Partial<Response>;

    // Helper to create a valid board
    const createValidBoard = (size: number = BOARD_SIZES.small): Board => {
        const matrix: Cell[][] = [];
        for (let i = 0; i < size; i++) {
            const row: Cell[] = [];
            for (let j = 0; j < size; j++) {
                row.push({
                    tile: { type: TileType.Water, state: 'default', orientation: '' },
                    item: null,
                    x: i,
                    y: j,
                });
            }
            matrix.push(row);
        }

        // Add required spawn points
        matrix[0][0].item = { type: 'spawnPoint' };
        matrix[size - 1][size - 1].item = { type: 'spawnPoint' };

        // Add required items
        matrix[3][3].item = { type: 'adrenaline' };
        matrix[6][6].item = { type: 'vodka' };

        return { size, matrix };
    };

    beforeEach(async () => {
        const mockGameService = {
            createGame: jest.fn(),
            getAllGames: jest.fn(),
            getGameById: jest.fn(),
            updateGame: jest.fn(),
            deleteGame: jest.fn(),
        };

        const mockGameValidationService = {
            validateGame: jest.fn(),
        };

        const module: TestingModule = await Test.createTestingModule({
            controllers: [GameController],
            providers: [
                { provide: GameService, useValue: mockGameService },
                { provide: GameValidationService, useValue: mockGameValidationService },
            ],
        }).compile();

        controller = module.get<GameController>(GameController);
        gameService = module.get(GameService);
        gameValidationService = module.get(GameValidationService);

        mockResponse = {
            status: jest.fn().mockReturnThis(),
            json: jest.fn().mockReturnThis(),
            send: jest.fn().mockReturnThis(),
        };
    });

    it('should be defined', () => {
        expect(controller).toBeDefined();
    });

    describe('createGame', () => {
        it('should create game when validation passes', async () => {
            const createGameDto: CreateGameDto = {
                name: 'Valid Game',
                description: 'A valid game',
                mode: 'classic',
                board: createValidBoard(),
            };

            gameValidationService.validateGame.mockReturnValue([]);
            gameService.createGame.mockResolvedValue();

            await controller.createGame(createGameDto, mockResponse as Response);

            expect(gameValidationService.validateGame).toHaveBeenCalledWith(
                createGameDto.name,
                createGameDto.description,
                createGameDto.board,
                false,
            );
            expect(gameService.createGame).toHaveBeenCalledWith(createGameDto);
            expect(mockResponse.status).toHaveBeenCalledWith(HttpStatus.CREATED);
            expect(mockResponse.send).toHaveBeenCalled();
        });

        it('should return 400 when game name is invalid', async () => {
            const createGameDto: CreateGameDto = {
                name: '',
                description: 'A valid game',
                mode: 'classic',
                board: createValidBoard(),
            };

            gameValidationService.validateGame.mockReturnValue([{ isValid: false, message: ErrorMessages.GameShouldHaveName }]);

            await controller.createGame(createGameDto, mockResponse as Response);

            expect(gameValidationService.validateGame).toHaveBeenCalled();
            expect(gameService.createGame).not.toHaveBeenCalled();
            expect(mockResponse.status).toHaveBeenCalledWith(HttpStatus.BAD_REQUEST);
            expect(mockResponse.json).toHaveBeenCalledWith({
                message: ErrorMessages.InvalidGame,
                errors: [ErrorMessages.GameShouldHaveName],
            });
        });

        it('should return 400 when multiple validation errors occur', async () => {
            const createGameDto: CreateGameDto = {
                name: '',
                description: '',
                mode: 'classic',
                board: createValidBoard(),
            };

            gameValidationService.validateGame.mockReturnValue([
                { isValid: false, message: ErrorMessages.GameShouldHaveName },
                { isValid: false, message: ErrorMessages.GameShouldHaveDescription },
            ]);

            await controller.createGame(createGameDto, mockResponse as Response);

            expect(mockResponse.status).toHaveBeenCalledWith(HttpStatus.BAD_REQUEST);
            expect(mockResponse.json).toHaveBeenCalledWith({
                message: ErrorMessages.InvalidGame,
                errors: [ErrorMessages.GameShouldHaveName, ErrorMessages.GameShouldHaveDescription],
            });
        });

        it('should validate CTF mode correctly', async () => {
            const createGameDto: CreateGameDto = {
                name: 'CTF Game',
                description: 'A CTF game',
                mode: 'ctf',
                board: createValidBoard(),
            };

            gameValidationService.validateGame.mockReturnValue([]);
            gameService.createGame.mockResolvedValue();

            await controller.createGame(createGameDto, mockResponse as Response);

            expect(gameValidationService.validateGame).toHaveBeenCalledWith(
                createGameDto.name,
                createGameDto.description,
                createGameDto.board,
                true, // isCTF should be true
            );
        });

        it('should handle service errors gracefully', async () => {
            const createGameDto: CreateGameDto = {
                name: 'Valid Game',
                description: 'A valid game',
                mode: 'classic',
                board: createValidBoard(),
            };

            gameValidationService.validateGame.mockReturnValue([]);
            gameService.createGame.mockRejectedValue(new Error('Database error'));

            await controller.createGame(createGameDto, mockResponse as Response);

            expect(mockResponse.status).toHaveBeenCalledWith(HttpStatus.INTERNAL_SERVER_ERROR);
            expect(mockResponse.json).toHaveBeenCalledWith({
                message: 'Database error',
            });
        });
    });

    describe('updateGame', () => {
        const gameId = '507f1f77bcf86cd799439011';
        const existingGame = {
            _id: gameId,
            name: 'Existing Game',
            description: 'Existing description',
            mode: 'classic',
            board: createValidBoard(),
            isVisible: true,
            modificationDate: '2024-01-01',
        };

        it('should update game when validation passes', async () => {
            const updateGameDto: UpdateGameDto = {
                name: 'Updated Game',
                description: 'Updated description',
                board: createValidBoard(),
            };

            gameService.getGameById.mockResolvedValue(existingGame as any);
            gameValidationService.validateGame.mockReturnValue([]);
            gameService.updateGame.mockResolvedValue({ ...existingGame, ...updateGameDto } as any);

            await controller.updateGame(gameId, updateGameDto, mockResponse as Response);

            expect(gameService.getGameById).toHaveBeenCalledWith(gameId);
            expect(gameValidationService.validateGame).toHaveBeenCalledWith(
                updateGameDto.name,
                updateGameDto.description,
                updateGameDto.board,
                false,
            );
            expect(gameService.updateGame).toHaveBeenCalledWith(gameId, updateGameDto);
            expect(mockResponse.status).toHaveBeenCalledWith(HttpStatus.OK);
        });

        it('should skip validation when only isVisible is updated', async () => {
            const updateGameDto: UpdateGameDto = {
                isVisible: false,
            };

            gameService.updateGame.mockResolvedValue({ ...existingGame, isVisible: false } as any);

            await controller.updateGame(gameId, updateGameDto, mockResponse as Response);

            expect(gameService.getGameById).not.toHaveBeenCalled();
            expect(gameValidationService.validateGame).not.toHaveBeenCalled();
            expect(gameService.updateGame).toHaveBeenCalledWith(gameId, updateGameDto);
            expect(mockResponse.status).toHaveBeenCalledWith(HttpStatus.OK);
        });

        it('should use existing values for missing fields during validation', async () => {
            const updateGameDto: UpdateGameDto = {
                name: 'Updated Name Only',
            };

            gameService.getGameById.mockResolvedValue(existingGame as any);
            gameValidationService.validateGame.mockReturnValue([]);
            gameService.updateGame.mockResolvedValue({ ...existingGame, ...updateGameDto } as any);

            await controller.updateGame(gameId, updateGameDto, mockResponse as Response);

            expect(gameValidationService.validateGame).toHaveBeenCalledWith(
                updateGameDto.name,
                existingGame.description, // Should use existing
                existingGame.board, // Should use existing
                false,
            );
        });

        it('should return 400 when updated game is invalid', async () => {
            const updateGameDto: UpdateGameDto = {
                name: '',
            };

            gameService.getGameById.mockResolvedValue(existingGame as any);
            gameValidationService.validateGame.mockReturnValue([{ isValid: false, message: ErrorMessages.GameShouldHaveName }]);

            await controller.updateGame(gameId, updateGameDto, mockResponse as Response);

            expect(gameService.updateGame).not.toHaveBeenCalled();
            expect(mockResponse.status).toHaveBeenCalledWith(HttpStatus.BAD_REQUEST);
            expect(mockResponse.json).toHaveBeenCalledWith({
                message: ErrorMessages.InvalidGame,
                errors: [ErrorMessages.GameShouldHaveName],
            });
        });

        it('should validate CTF mode correctly for update', async () => {
            const ctfGame = { ...existingGame, mode: 'ctf' };
            const updateGameDto: UpdateGameDto = {
                board: createValidBoard(),
            };

            gameService.getGameById.mockResolvedValue(ctfGame as any);
            gameValidationService.validateGame.mockReturnValue([]);
            gameService.updateGame.mockResolvedValue({ ...ctfGame, ...updateGameDto } as any);

            await controller.updateGame(gameId, updateGameDto, mockResponse as Response);

            expect(gameValidationService.validateGame).toHaveBeenCalledWith(
                ctfGame.name,
                ctfGame.description,
                updateGameDto.board,
                true, // isCTF should be true
            );
        });

        it('should handle getGameById errors', async () => {
            const updateGameDto: UpdateGameDto = {
                name: 'Updated Game',
            };

            gameService.getGameById.mockRejectedValue(new Error('Game not found'));

            await controller.updateGame(gameId, updateGameDto, mockResponse as Response);

            expect(mockResponse.status).toHaveBeenCalledWith(HttpStatus.INTERNAL_SERVER_ERROR);
            expect(mockResponse.json).toHaveBeenCalledWith({
                message: 'Game not found',
            });
        });
    });
});

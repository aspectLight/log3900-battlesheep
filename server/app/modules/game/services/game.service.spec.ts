import { Board } from '@app/modules/game/schemas/board.schema';
import { Game, GameDocument } from '@app/modules/game/schemas/game.schema';
import { GameService } from '@app/modules/game/services/game.service';
import { DateService } from '@app/shared/services/date.service';
import { ErrorMessages } from '@common/error-messages.constants';
import { BadRequestException, ConflictException, NotFoundException } from '@nestjs/common';
import { getModelToken } from '@nestjs/mongoose';
import { Test, TestingModule } from '@nestjs/testing';
import { Model, Types } from 'mongoose';

describe('GameService', () => {
    let service: GameService;
    let gameModel: Model<GameDocument>;
    let dateService: DateService;
    const validMongoId = new Types.ObjectId().toString();

    beforeEach(async () => {
        const mockDateService = { currentTime: jest.fn(() => new Date().toISOString()) };

        const module: TestingModule = await Test.createTestingModule({
            providers: [
                GameService,
                { provide: DateService, useValue: mockDateService },
                {
                    provide: getModelToken(Game.name),
                    useValue: {
                        findOne: jest.fn().mockReturnValue({ exec: jest.fn() }),
                        find: jest.fn().mockReturnValue({ exec: jest.fn() }),
                        findById: jest.fn().mockReturnValue({ exec: jest.fn() }),
                        findByIdAndUpdate: jest.fn().mockReturnValue({ exec: jest.fn() }),
                        findByIdAndDelete: jest.fn().mockReturnValue({ exec: jest.fn() }),
                        create: jest.fn(),
                    },
                },
            ],
        }).compile();

        service = module.get<GameService>(GameService);
        gameModel = module.get<Model<GameDocument>>(getModelToken(Game.name));
        dateService = module.get<DateService>(DateService);
    });

    it('should be defined', () => {
        expect(service).toBeDefined();
    });

    it('createGame() should create a game', async () => {
        (gameModel.findOne as jest.Mock).mockReturnValue({ exec: jest.fn().mockResolvedValue(null) });
        (gameModel.create as jest.Mock).mockResolvedValue(undefined);

        await expect(service.createGame({ name: 'New Game' } as Game)).resolves.toBeUndefined();
    });

    it('createGame() should throw 409 if a game with the same name already exists', async () => {
        (gameModel.findOne as jest.Mock).mockReturnValue({ exec: jest.fn().mockResolvedValue({} as Game) });
        await expect(service.createGame({ name: 'Existing Game' } as Game)).rejects.toThrow(new ConflictException(ErrorMessages.GameAlreadyExists));
    });

    it('getAllGames() should return all games', async () => {
        (gameModel.find as jest.Mock).mockReturnValue({ exec: jest.fn().mockResolvedValue([{ _id: validMongoId }] as Game[]) });

        await expect(service.getAllGames()).resolves.toEqual([{ _id: validMongoId }]);
    });

    it('getAllGames() should throw 404 if no games exist', async () => {
        (gameModel.find as jest.Mock).mockReturnValue({ exec: jest.fn().mockResolvedValue([]) });

        await expect(service.getAllGames()).rejects.toThrow(NotFoundException);
    });

    it('getGameById() should return a game with a valid id', async () => {
        (gameModel.findById as jest.Mock).mockReturnValue({ exec: jest.fn().mockResolvedValue({ _id: validMongoId } as Game) });

        await expect(service.getGameById(validMongoId)).resolves.toEqual({ _id: validMongoId });
    });

    it('getGameById() should throw 400 if the id format is invalid', async () => {
        await expect(service.getGameById('invalidId')).rejects.toThrow(new BadRequestException(ErrorMessages.InvalidIdFormat));
    });

    it('getGameById() should throw 404 if game does not exist', async () => {
        (gameModel.findById as jest.Mock).mockReturnValue({ exec: jest.fn().mockResolvedValue(null) });

        await expect(service.getGameById(validMongoId)).rejects.toThrow(new NotFoundException(ErrorMessages.GameDoesNotExist));
    });

    it('updateGame() should update a game', async () => {
        (gameModel.findByIdAndUpdate as jest.Mock).mockReturnValue({
            exec: jest.fn().mockResolvedValue({ _id: validMongoId, name: 'updatedName' } as Game),
        });

        await expect(service.updateGame(validMongoId, { name: 'updatedName' })).resolves.toEqual({
            _id: validMongoId,
            name: 'updatedName',
        });
    });

    it('updateGame() should throw 400 if id is invalid', async () => {
        await expect(service.updateGame('invalidId', { name: 'updatedName' })).rejects.toThrow(
            new BadRequestException(ErrorMessages.InvalidIdFormat),
        );
    });

    it('updateGame() should throw 400 if the body is empty', async () => {
        await expect(service.updateGame(validMongoId, {})).rejects.toThrow(new BadRequestException(ErrorMessages.EmptyRequestBody));
    });

    it('updateGame() should throw 404 if the game does not exist', async () => {
        (gameModel.findByIdAndUpdate as jest.Mock).mockReturnValue({ exec: jest.fn().mockResolvedValue(null) });

        await expect(service.updateGame(validMongoId, { name: 'updatedName' })).rejects.toThrow(
            new NotFoundException(ErrorMessages.GameDoesNotExist),
        );
    });

    it('deleteGame() should delete a game', async () => {
        (gameModel.findByIdAndDelete as jest.Mock).mockReturnValue({
            exec: jest.fn().mockResolvedValue({ _id: validMongoId } as Game),
        });

        await expect(service.deleteGame(validMongoId)).resolves.toBeUndefined();
    });

    it('deleteGame() should throw 400 if game id is invalid', async () => {
        await expect(service.deleteGame('invalidId')).rejects.toThrow(new BadRequestException(ErrorMessages.InvalidIdFormat));
    });

    it('deleteGame() should throw 404 if the game does not exist', async () => {
        (gameModel.findByIdAndDelete as jest.Mock).mockReturnValue({ exec: jest.fn().mockResolvedValue(null) });

        await expect(service.deleteGame(validMongoId)).rejects.toThrow(new NotFoundException(ErrorMessages.GameDoesNotExist));
    });

    it('updateGame() should update modificationDate if board is updated', async () => {
        const mockDate = dateService.currentTime();
        const mockBoard: Board = { size: 10, matrix: [] } as Board;

        const updates: Partial<Game> = { board: mockBoard };
        const expectedGame = { _id: validMongoId, ...updates, modificationDate: mockDate };

        (gameModel.findByIdAndUpdate as jest.Mock).mockReturnValue({
            exec: jest.fn().mockResolvedValue(expectedGame),
        });

        await expect(service.updateGame(validMongoId, updates)).resolves.toEqual(expectedGame);
    });
});

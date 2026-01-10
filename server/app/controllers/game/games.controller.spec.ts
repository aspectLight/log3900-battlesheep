import { Game } from '@app/model/schema/game.schema';
import { UpdateGameDto } from '@app/model/dto/game/update-game.dto';
import { GameService } from '@app/services/game/game.service';
import { BadRequestException, ConflictException, HttpStatus, NotFoundException } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { GameController } from './games.controller';

/* eslint-disable @typescript-eslint/no-explicit-any */

describe('GameController', () => {
    let controller: GameController;
    let gameService: jest.Mocked<GameService>;

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            controllers: [GameController],
            providers: [
                {
                    provide: GameService,
                    useValue: {
                        getAllGames: jest.fn(),
                        getGameById: jest.fn(),
                        createGame: jest.fn(),
                        deleteGame: jest.fn(),
                        updateGame: jest.fn(),
                    },
                },
            ],
        }).compile();

        controller = module.get<GameController>(GameController);
        gameService = module.get(GameService);
    });

    it('should be defined', () => {
        expect(controller).toBeDefined();
    });

    it('findAllGames() should return all games', async () => {
        const fakeGames = [{}, {}] as Game[];
        gameService.getAllGames.mockResolvedValue(fakeGames);

        const res = {
            status: jest.fn().mockReturnThis(),
            json: jest.fn().mockReturnThis(),
        } as any;

        await controller.findAllGames(res);

        expect(res.status).toHaveBeenCalledWith(HttpStatus.OK);
        expect(res.json).toHaveBeenCalledWith(fakeGames);
    });

    it('findAllGames() should return a 404 error if there are no games', async () => {
        gameService.getAllGames.mockRejectedValue(new NotFoundException('Aucun jeu trouvé.'));

        const res = {
            status: jest.fn().mockReturnThis(),
            json: jest.fn().mockReturnThis(),
        } as any;

        await controller.findAllGames(res);

        expect(res.status).toHaveBeenCalledWith(HttpStatus.NOT_FOUND);
        expect(res.json).toHaveBeenCalledWith({ message: 'Aucun jeu trouvé.' });
    });

    it('findAllGames() should return INTERNAL_SERVER_ERROR with default message if error has no status or message', async () => {
        gameService.getAllGames.mockRejectedValue({});

        const res = {
            status: jest.fn().mockReturnThis(),
            json: jest.fn().mockReturnThis(),
        } as any;

        await controller.findAllGames(res);

        expect(res.status).toHaveBeenCalledWith(HttpStatus.INTERNAL_SERVER_ERROR);
        expect(res.json).toHaveBeenCalledWith({ message: 'Une erreur inattendue est survenue.' });
    });

    it('findGameById() should return a game with valid ID', async () => {
        const fakeGame = { _id: 'ID' } as Game;
        gameService.getGameById.mockResolvedValue(fakeGame);

        const res = {
            status: jest.fn().mockReturnThis(),
            json: jest.fn().mockReturnThis(),
        } as any;

        await controller.findGameById('ID', res);

        expect(res.status).toHaveBeenCalledWith(HttpStatus.OK);
        expect(res.json).toHaveBeenCalledWith(fakeGame);
    });

    it('findGameById() should return 400 if the id format is invalid', async () => {
        gameService.getGameById.mockRejectedValue(new BadRequestException("Le format de l'id n'est pas bon."));

        const res = {
            status: jest.fn().mockReturnThis(),
            json: jest.fn().mockReturnThis(),
        } as any;

        await controller.findGameById('invalidId', res);

        expect(res.status).toHaveBeenCalledWith(HttpStatus.BAD_REQUEST);
        expect(res.json).toHaveBeenCalledWith({ message: "Le format de l'id n'est pas bon." });
    });

    it('findGameById() should return 404 if the game does not exist', async () => {
        gameService.getGameById.mockRejectedValue(new NotFoundException("Le jeu avec l'id ID n'existe pas."));

        const res = {
            status: jest.fn().mockReturnThis(),
            json: jest.fn().mockReturnThis(),
        } as any;

        await controller.findGameById('ID', res);

        expect(res.status).toHaveBeenCalledWith(HttpStatus.NOT_FOUND);
        expect(res.json).toHaveBeenCalledWith({ message: "Le jeu avec l'id ID n'existe pas." });
    });

    it('findGameById() should return INTERNAL_SERVER_ERROR with default message if error has no status or message', async () => {
        gameService.getGameById.mockRejectedValue({});

        const res = {
            status: jest.fn().mockReturnThis(),
            json: jest.fn().mockReturnThis(),
        } as any;

        await controller.findGameById('someId', res);

        expect(res.status).toHaveBeenCalledWith(HttpStatus.INTERNAL_SERVER_ERROR);
        expect(res.json).toHaveBeenCalledWith({ message: 'Une erreur inattendue est survenue.' });
    });

    it('createGame() should return 201 if it creates the game', async () => {
        const fakeGame = {} as Game;
        gameService.createGame.mockResolvedValue(undefined);

        const res = {
            status: jest.fn().mockReturnThis(),
            send: jest.fn().mockReturnThis(),
        } as any;

        await controller.createGame(fakeGame, res);

        expect(res.status).toHaveBeenCalledWith(HttpStatus.CREATED);
        expect(res.send).toHaveBeenCalled();
    });

    it('createGame() should return 409 if a game with the same name already exists', async () => {
        const fakeGame = { name: 'abc' } as Game;
        gameService.createGame.mockRejectedValue(new ConflictException('Un jeu avec le meme nom existe deja'));

        const res = {
            status: jest.fn().mockReturnThis(),
            json: jest.fn().mockReturnThis(),
        } as any;

        await controller.createGame(fakeGame, res);

        expect(res.status).toHaveBeenCalledWith(HttpStatus.CONFLICT);
        expect(res.json).toHaveBeenCalledWith({ message: 'Un jeu avec le meme nom existe deja' });
    });

    it('createGame() should return INTERNAL_SERVER_ERROR with default message if error has no status or message', async () => {
        // Force createGame to reject with an empty error object.
        gameService.createGame.mockRejectedValue({});

        const res = {
            status: jest.fn().mockReturnThis(),
            send: jest.fn().mockReturnThis(),
            json: jest.fn().mockReturnThis(),
        } as any;

        await controller.createGame({ name: 'testGame' } as any, res);

        expect(res.status).toHaveBeenCalledWith(HttpStatus.INTERNAL_SERVER_ERROR);
        expect(res.json).toHaveBeenCalledWith({ message: 'Une erreur inattendue est survenue.' });
    });

    it('deleteGame() should return 204 when the game is deleted', async () => {
        gameService.deleteGame.mockResolvedValueOnce(undefined);

        const res = {
            status: jest.fn().mockReturnThis(),
            send: jest.fn().mockReturnThis(),
        } as any;

        await controller.deleteGame('validId', res);

        expect(res.status).toHaveBeenCalledWith(HttpStatus.NO_CONTENT);
        expect(res.send).toHaveBeenCalled();
    });

    it('deleteGame() should return 400 if game id is invalid', async () => {
        gameService.deleteGame.mockRejectedValue(new BadRequestException("Le format de l'id n'est pas bon."));

        const res = {
            status: jest.fn().mockReturnThis(),
            json: jest.fn().mockReturnThis(),
        } as any;

        await controller.deleteGame('invalidId', res);

        expect(res.status).toHaveBeenCalledWith(HttpStatus.BAD_REQUEST);
        expect(res.json).toHaveBeenCalledWith({ message: "Le format de l'id n'est pas bon." });
    });

    it('deleteGame() should return 404 if the game does not exist', async () => {
        gameService.deleteGame.mockRejectedValue(new NotFoundException("Le jeu avec l'id ID n'existe pas."));

        const res = {
            status: jest.fn().mockReturnThis(),
            json: jest.fn().mockReturnThis(),
        } as any;

        await controller.deleteGame('validId', res);

        expect(res.status).toHaveBeenCalledWith(HttpStatus.NOT_FOUND);
        expect(res.json).toHaveBeenCalledWith({ message: "Le jeu avec l'id ID n'existe pas." });
    });

    it('deleteGame() should return INTERNAL_SERVER_ERROR with default message if error has no status or message', async () => {
        // Force deleteGame to reject with an empty error object.
        gameService.deleteGame.mockRejectedValue({});

        const res = {
            status: jest.fn().mockReturnThis(),
            json: jest.fn().mockReturnThis(),
            send: jest.fn().mockReturnThis(),
        } as any;

        await controller.deleteGame('id', res);

        expect(res.status).toHaveBeenCalledWith(HttpStatus.INTERNAL_SERVER_ERROR);
        expect(res.json).toHaveBeenCalledWith({ message: 'Une erreur inattendue est survenue.' });
    });

    it('updateGame() should return 200 if game is updated', async () => {
        const fakeGame = { _id: 'id', name: 'updatedName' } as Game;
        gameService.updateGame.mockResolvedValue(fakeGame);

        const res = {
            status: jest.fn().mockReturnThis(),
            json: jest.fn().mockReturnThis(),
        } as any;

        await controller.updateGame('id', { name: 'Updated Game' } as UpdateGameDto, res);

        expect(res.status).toHaveBeenCalledWith(HttpStatus.OK);
        expect(res.json).toHaveBeenCalledWith(fakeGame);
    });

    it('updateGame() should return 400 if game id is invalid', async () => {
        gameService.updateGame.mockRejectedValue(new BadRequestException("Le format de l'id n'est pas bon."));

        const res = {
            status: jest.fn().mockReturnThis(),
            json: jest.fn().mockReturnThis(),
        } as any;

        await controller.updateGame('invalidId', { name: 'updatedName' } as UpdateGameDto, res);

        expect(res.status).toHaveBeenCalledWith(HttpStatus.BAD_REQUEST);
        expect(res.json).toHaveBeenCalledWith({ message: "Le format de l'id n'est pas bon." });
    });

    it('updateGame() should return 400 if the request body is empty', async () => {
        gameService.updateGame.mockRejectedValue(new BadRequestException('Le corps de la requête est vide.'));

        const res = {
            status: jest.fn().mockReturnThis(),
            json: jest.fn().mockReturnThis(),
        } as any;

        await controller.updateGame('id', {} as UpdateGameDto, res);

        expect(res.status).toHaveBeenCalledWith(HttpStatus.BAD_REQUEST);
        expect(res.json).toHaveBeenCalledWith({ message: 'Le corps de la requête est vide.' });
    });

    it('updateGame() should return 404 if the game does not exist', async () => {
        gameService.updateGame.mockRejectedValue(new NotFoundException("Le jeu avec l'id invalidId n'existe pas."));

        const res = {
            status: jest.fn().mockReturnThis(),
            json: jest.fn().mockReturnThis(),
        } as any;

        await controller.updateGame('invalidId', { name: 'updatedName' } as UpdateGameDto, res);

        expect(res.status).toHaveBeenCalledWith(HttpStatus.NOT_FOUND);
        expect(res.json).toHaveBeenCalledWith({ message: "Le jeu avec l'id invalidId n'existe pas." });
    });

    it('updateGame() should return INTERNAL_SERVER_ERROR with default message if error has no status or message', async () => {
        // Force updateGame to reject with an empty error object.
        gameService.updateGame.mockRejectedValue({});

        const res = {
            status: jest.fn().mockReturnThis(),
            json: jest.fn().mockReturnThis(),
        } as any;

        await controller.updateGame('id', { name: 'updatedGame' } as any, res);

        expect(res.status).toHaveBeenCalledWith(HttpStatus.INTERNAL_SERVER_ERROR);
        expect(res.json).toHaveBeenCalledWith({ message: 'Une erreur inattendue est survenue.' });
    });
});

import { CreateGameDto } from '@app/model/dto/game/create-game.dto';
import { UpdateGameDto } from '@app/model/dto/game/update-game.dto';
import { GameService } from '@app/services/game/game.service';
import { Body, Controller, Delete, Get, HttpStatus, Param, Patch, Post, Res } from '@nestjs/common';
import { Response } from 'express';

@Controller('games')
export class GameController {
    constructor(private readonly gameService: GameService) {}

    @Get()
    async findAllGames(@Res() response: Response) {
        try {
            const games = await this.gameService.getAllGames();
            return response.status(HttpStatus.OK).json(games);
        } catch (error) {
            const status = error.status ? error.status : HttpStatus.INTERNAL_SERVER_ERROR;
            const message = error.message || 'Une erreur inattendue est survenue.';
            return response.status(status).json({ message });
        }
    }

    @Get(':id')
    async findGameById(@Param('id') id: string, @Res() response: Response) {
        try {
            const game = await this.gameService.getGameById(id);
            return response.status(HttpStatus.OK).json(game);
        } catch (error) {
            const status = error.status ? error.status : HttpStatus.INTERNAL_SERVER_ERROR;
            const message = error.message || 'Une erreur inattendue est survenue.';
            return response.status(status).json({ message });
        }
    }

    @Post()
    async createGame(@Body() createGameDto: CreateGameDto, @Res() response: Response) {
        try {
            await this.gameService.createGame(createGameDto);
            return response.status(HttpStatus.CREATED).send();
        } catch (error) {
            const status = error.status ? error.status : HttpStatus.INTERNAL_SERVER_ERROR;
            const message = error.message || 'Une erreur inattendue est survenue.';
            return response.status(status).json({ message });
        }
    }

    @Patch(':id')
    async updateGame(@Param('id') id: string, @Body() updateGameDto: UpdateGameDto, @Res() response: Response) {
        try {
            const updatedGame = await this.gameService.updateGame(id, updateGameDto);
            return response.status(HttpStatus.OK).json(updatedGame);
        } catch (error) {
            const status = error.status ? error.status : HttpStatus.INTERNAL_SERVER_ERROR;
            const message = error.message || 'Une erreur inattendue est survenue.';
            return response.status(status).json({ message });
        }
    }

    @Delete(':id')
    async deleteGame(@Param('id') id: string, @Res() response: Response) {
        try {
            await this.gameService.deleteGame(id);
            return response.status(HttpStatus.NO_CONTENT).send();
        } catch (error) {
            const status = error.status ? error.status : HttpStatus.INTERNAL_SERVER_ERROR;
            const message = error.message || 'Une erreur inattendue est survenue.';
            return response.status(status).json({ message });
        }
    }
}

import { CreateGameDto } from '@app/modules/game/dto/create-game.dto';
import { UpdateGameDto } from '@app/modules/game/dto/update-game.dto';
import { GameValidationService } from '@app/modules/game/services/game-validation.service';
import { GameService } from '@app/modules/game/services/game.service';
import { ErrorMessages } from '@common/error-messages.constants';
import { Body, Controller, Delete, Get, HttpStatus, Param, Patch, Post, Res } from '@nestjs/common';
import { Response } from 'express';

@Controller('games')
export class GameController {
    constructor(
        private readonly gameService: GameService,
        private readonly gameValidationService: GameValidationService,
    ) {}

    @Get()
    async findAllGames(@Res() response: Response) {
        try {
            const games = await this.gameService.getAllGames();
            return response.status(HttpStatus.OK).json(games);
        } catch (error) {
            const status = error.status ? error.status : HttpStatus.INTERNAL_SERVER_ERROR;
            const message = error.message || ErrorMessages.PlainError;
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
            const message = error.message || ErrorMessages.PlainError;
            return response.status(status).json({ message });
        }
    }

    @Post()
    async createGame(@Body() createGameDto: CreateGameDto, @Res() response: Response) {
        try {
            const isCTF = createGameDto.mode === 'ctf';
            const errors = this.gameValidationService.validateGame(createGameDto.name, createGameDto.description, createGameDto.board, isCTF);

            if (errors.length > 0) {
                return response.status(HttpStatus.BAD_REQUEST).json({
                    message: ErrorMessages.InvalidGame,
                    errors: errors.map((e) => e.message),
                });
            }

            await this.gameService.createGame(createGameDto);
            return response.status(HttpStatus.CREATED).send();
        } catch (error) {
            const status = error.status ? error.status : HttpStatus.INTERNAL_SERVER_ERROR;
            const message = error.message || ErrorMessages.PlainError;
            return response.status(status).json({ message });
        }
    }

    @Patch(':id')
    async updateGame(@Param('id') id: string, @Body() updateGameDto: UpdateGameDto, @Res() response: Response) {
        try {
            if (updateGameDto.board !== undefined || updateGameDto.name !== undefined || updateGameDto.description !== undefined) {
                const existingGame = await this.gameService.getGameById(id);

                const isCTF = existingGame.mode === 'ctf';
                const errors = this.gameValidationService.validateGame(
                    updateGameDto.name !== undefined ? updateGameDto.name : existingGame.name,
                    updateGameDto.description !== undefined ? updateGameDto.description : existingGame.description,
                    updateGameDto.board !== undefined ? updateGameDto.board : existingGame.board,
                    isCTF,
                );

                if (errors.length > 0) {
                    return response.status(HttpStatus.BAD_REQUEST).json({
                        message: ErrorMessages.InvalidGame,
                        errors: errors.map((e) => e.message),
                    });
                }
            }

            const updatedGame = await this.gameService.updateGame(id, updateGameDto);
            return response.status(HttpStatus.OK).json(updatedGame);
        } catch (error) {
            const status = error.status ? error.status : HttpStatus.INTERNAL_SERVER_ERROR;
            const message = error.message || ErrorMessages.PlainError;
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
            const message = error.message || ErrorMessages.PlainError;
            return response.status(status).json({ message });
        }
    }
}

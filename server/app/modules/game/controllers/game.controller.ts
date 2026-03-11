import { CurrentUser } from '@app/modules/auth/decorators/current-user.decorator';
import { AuthGuard } from '@app/modules/auth/guards/auth.guard';
import { UserDocument } from '@app/modules/auth/schemas/user.schema';
import { CreateGameDto } from '@app/modules/game/dto/create-game.dto';
import { UpdateGameDto } from '@app/modules/game/dto/update-game.dto';
import { GameValidationService } from '@app/modules/game/services/game-validation.service';
import { GameService } from '@app/modules/game/services/game.service';
import { ErrorMessages } from '@common/error-messages.constants';
import { Body, Controller, Delete, Get, HttpStatus, Param, Patch, Post, Query, Res, UseGuards } from '@nestjs/common';
import { Response } from 'express';

@Controller('games')
@UseGuards(AuthGuard)
export class GameController {
    constructor(
        private readonly gameService: GameService,
        private readonly gameValidationService: GameValidationService,
    ) {}

    @Get()
    async findAllGames(@CurrentUser() user: UserDocument, @Query('purpose') purpose: string, @Res() response: Response) {
        try {
            const games =
                purpose === 'play'
                    ? await this.gameService.getPlayableGames(user.username)
                    : await this.gameService.getAccessibleGames(user.username);
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
    async createGame(@Body() createGameDto: CreateGameDto, @CurrentUser() user: UserDocument, @Res() response: Response) {
        try {
            const isCTF = createGameDto.mode === 'ctf';
            const errors = this.gameValidationService.validateGame(createGameDto.name, createGameDto.description, createGameDto.board, isCTF);

            if (errors.length > 0) {
                return response.status(HttpStatus.BAD_REQUEST).json({
                    message: ErrorMessages.InvalidGame,
                    errors: errors.map((e) => e.message),
                });
            }

            await this.gameService.createGame(createGameDto, user.username);
            return response.status(HttpStatus.CREATED).send();
        } catch (error) {
            const status = error.status ? error.status : HttpStatus.INTERNAL_SERVER_ERROR;
            const message = error.message || ErrorMessages.PlainError;
            return response.status(status).json({ message });
        }
    }

    @Post(':id/duplicate')
    async duplicateGame(@Param('id') id: string, @CurrentUser() user: UserDocument, @Res() response: Response) {
        try {
            await this.gameService.duplicateGame(id, user.username);
            return response.status(HttpStatus.CREATED).send();
        } catch (error) {
            const status = error.status ? error.status : HttpStatus.INTERNAL_SERVER_ERROR;
            const message = error.message || ErrorMessages.PlainError;
            return response.status(status).json({ message });
        }
    }

    @Patch(':id')
    async updateGame(@Param('id') id: string, @Body() updateGameDto: UpdateGameDto, @CurrentUser() user: UserDocument, @Res() response: Response) {
        try {
            const existingGame = await this.gameService.getGameById(id);

            if (existingGame.privacy !== 'public' && existingGame.owner !== user.username) {
                return response.status(HttpStatus.FORBIDDEN).json({ message: 'Accès refusé' });
            }

            if (updateGameDto.privacy !== undefined && updateGameDto.privacy !== existingGame.privacy && existingGame.owner !== user.username) {
                return response.status(HttpStatus.FORBIDDEN).json({ message: 'Seul le propriétaire peut modifier la confidentialité' });
            }

            if (updateGameDto.board !== undefined || updateGameDto.name !== undefined || updateGameDto.description !== undefined) {
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
    async deleteGame(@Param('id') id: string, @CurrentUser() user: UserDocument, @Res() response: Response) {
        try {
            const game = await this.gameService.getGameById(id);

            if (game.privacy !== 'public' && game.owner !== user.username) {
                return response.status(HttpStatus.FORBIDDEN).json({ message: 'Accès refusé' });
            }

            await this.gameService.deleteGame(id);
            return response.status(HttpStatus.NO_CONTENT).send();
        } catch (error) {
            const status = error.status ? error.status : HttpStatus.INTERNAL_SERVER_ERROR;
            const message = error.message || ErrorMessages.PlainError;
            return response.status(status).json({ message });
        }
    }
}

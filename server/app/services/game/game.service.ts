import { Game, GameDocument } from '@app/model/schema/game.schema';
import { DateService } from '@app/services/date/date.service';
import { ErrorMessages } from '@common/error-messages.constants';
import { BadRequestException, ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { isValidObjectId, Model } from 'mongoose';

@Injectable()
export class GameService {
    constructor(
        @InjectModel(Game.name) private readonly gameModel: Model<GameDocument>,
        private readonly dateService: DateService,
    ) {}

    async createGame(gameData: Partial<Game>): Promise<void> {
        await this.gameWithSameName(gameData.name);
        gameData.modificationDate = this.dateService.currentTime();
        await this.gameModel.create(gameData);
    }

    async getAllGames(): Promise<Game[]> {
        const games = await this.gameModel.find().exec();
        if (games.length === 0) {
            throw new NotFoundException(ErrorMessages.NoGamesFound);
        }

        return games;
    }

    async getGameById(gameId: string): Promise<Game> {
        if (!isValidObjectId(gameId)) {
            throw new BadRequestException(ErrorMessages.InvalidIdFormat);
        }

        const game = await this.gameModel.findById(gameId).exec();

        if (!game) {
            throw new NotFoundException(ErrorMessages.GameDoesNotExist);
        }
        return game;
    }

    async updateGame(gameId: string, updates: Partial<Game>): Promise<Game> {
        if (!isValidObjectId(gameId)) {
            throw new BadRequestException(ErrorMessages.InvalidIdFormat);
        }

        if (JSON.stringify(updates) === '{}') {
            throw new BadRequestException(ErrorMessages.EmptyRequestBody);
        }

        if (updates.board) {
            updates.modificationDate = this.dateService.currentTime();
        }
        const updatedGame = await this.gameModel.findByIdAndUpdate(gameId, updates, { new: true }).exec();
        if (!updatedGame) {
            throw new NotFoundException(ErrorMessages.GameDoesNotExist);
        }
        return updatedGame;
    }

    async deleteGame(gameId: string): Promise<void> {
        if (!isValidObjectId(gameId)) {
            throw new BadRequestException(ErrorMessages.InvalidIdFormat);
        }
        const deletedGame = await this.gameModel.findByIdAndDelete(gameId).exec();
        if (!deletedGame) {
            throw new NotFoundException(ErrorMessages.GameDoesNotExist);
        }
    }

    private async gameWithSameName(gameName: string) {
        const isGameWithSameName = await this.gameModel.findOne({ name: gameName }).exec();
        if (isGameWithSameName) {
            throw new ConflictException(ErrorMessages.GameAlreadyExists);
        }
    }
}

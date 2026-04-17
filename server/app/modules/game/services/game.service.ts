import { CreateGameDto } from '@app/modules/game/dto/create-game.dto';
import { UpdateGameDto } from '@app/modules/game/dto/update-game.dto';
import { Game, GameDocument } from '@app/modules/game/schemas/game.schema';
import { DateService } from '@app/shared/services/date.service';
import { ErrorMessages } from '@common/error-messages.constants';
import { BadRequestException, ConflictException, ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { isValidObjectId, Model } from 'mongoose';

@Injectable()
export class GameService {
    constructor(
        @InjectModel(Game.name) private readonly gameModel: Model<GameDocument>,
        private readonly dateService: DateService,
    ) {}

    async createGame(gameData: CreateGameDto, owner: string): Promise<void> {
        await this.verifyDuplicateName(gameData.name);
        const gameWithDate = {
            ...gameData,
            owner,
            modificationDate: this.dateService.currentTime(),
        };
        await this.gameModel.create(gameWithDate);
    }

    async getAllGames(): Promise<Game[]> {
        const games = await this.gameModel.find().exec();
        if (games.length === 0) {
            throw new NotFoundException(ErrorMessages.NoGamesFound);
        }

        return games;
    }

    async getAccessibleGames(username: string): Promise<Game[]> {
        return this.gameModel.find({ $or: [{ privacy: 'public' }, { owner: username }] }).exec();
    }

    async getPlayableGames(username: string): Promise<Game[]> {
        return this.gameModel.find({ $or: [{ privacy: 'public' }, { privacy: 'protected' }, { owner: username }] }).exec();
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

    async updateGame(gameId: string, updates: UpdateGameDto): Promise<Game> {
        if (!isValidObjectId(gameId)) {
            throw new BadRequestException(ErrorMessages.InvalidIdFormat);
        }

        if (JSON.stringify(updates) === '{}') {
            throw new BadRequestException(ErrorMessages.EmptyRequestBody);
        }

        const updateData: UpdateGameDto & { modificationDate?: string } = { ...updates };
        if (updates.board) {
            updateData.modificationDate = this.dateService.currentTime();
        }
        const updatedGame = await this.gameModel.findByIdAndUpdate(gameId, updateData, { new: true }).exec();
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

    async deleteGamesByOwner(owner: string): Promise<number> {
        const result = await this.gameModel.deleteMany({ owner }).exec();
        return result.deletedCount;
    }

    async duplicateGame(gameId: string, owner: string, language = 'fr'): Promise<void> {
        const game = await this.getGameById(gameId);

        if (game.privacy !== 'public') {
            throw new ForbiddenException('Seuls les jeux publics peuvent être dupliqués');
        }

        const newName = await this.generateUniqueCopyName(game.name, language);

        const duplicatedGame = {
            name: newName,
            description: game.description,
            mode: game.mode,
            board: game.board,
            privacy: 'private',
            owner,
            modificationDate: this.dateService.currentTime(),
        };

        await this.gameModel.create(duplicatedGame);
    }

    private async generateUniqueCopyName(originalName: string, language: string): Promise<string> {
        const copySuffix = language.toLowerCase() === 'en' ? 'copy' : 'copie';
        const escapedOriginalName = this.escapeRegex(originalName);
        const copyNamePattern = new RegExp(`^${escapedOriginalName}_(?:copy|copie)(\\d+)?$`);
        const existingCopyNames = await this.gameModel.find({ name: { $regex: copyNamePattern } }).exec();

        let maxSuffix = -1;
        for (const existingGame of existingCopyNames) {
            const match = existingGame.name.match(copyNamePattern);
            if (!match) continue;
            const numericSuffix = match[1] ? Number.parseInt(match[1], 10) : 0;
            maxSuffix = Math.max(maxSuffix, numericSuffix);
        }

        const nextSuffix = maxSuffix + 1;
        return nextSuffix === 0 ? `${originalName}_${copySuffix}` : `${originalName}_${copySuffix}${nextSuffix}`;
    }

    private escapeRegex(value: string): string {
        return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    }

    private async verifyDuplicateName(gameName: string) {
        const isDuplicateName = await this.gameModel.findOne({ name: gameName }).exec();
        if (isDuplicateName) {
            throw new ConflictException(ErrorMessages.GameAlreadyExists);
        }
    }
}

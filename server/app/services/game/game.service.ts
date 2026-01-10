import { Game, GameDocument } from '@app/model/schema/game.schema';
import { DateService } from '@app/services/date/date.service';
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
            throw new NotFoundException('Aucun jeu trouvé.');
        }

        return games;
    }

    async getGameById(gameId: string): Promise<Game> {
        if (!isValidObjectId(gameId)) {
            throw new BadRequestException("Le format de l'id n'est pas bon.");
        }

        const game = await this.gameModel.findById(gameId).exec();

        if (!game) {
            throw new NotFoundException(`Le jeu avec l'id ${gameId} n'existe pas.`);
        }
        return game;
    }

    async updateGame(gameId: string, updates: Partial<Game>): Promise<Game> {
        if (!isValidObjectId(gameId)) {
            throw new BadRequestException("Le format de l'id n'est pas bon.");
        }

        if (JSON.stringify(updates) === '{}') {
            throw new BadRequestException('Le corps de la requête est vide.');
        }

        if (updates.board) {
            updates.modificationDate = this.dateService.currentTime();
        }
        const updatedGame = await this.gameModel.findByIdAndUpdate(gameId, updates, { new: true }).exec();
        if (!updatedGame) {
            throw new NotFoundException(`Le jeu avec l'Id ${gameId} n'existe pas.`);
        }
        return updatedGame;
    }

    async deleteGame(gameId: string): Promise<void> {
        if (!isValidObjectId(gameId)) {
            throw new BadRequestException("Le format de l'id n'est pas bon.");
        }

        const deletedGame = await this.gameModel.findByIdAndDelete(gameId).exec();

        if (!deletedGame) {
            throw new NotFoundException(`Le jeu avec l'Id ${gameId} n'existe pas.`);
        }
    }

    private async gameWithSameName(gameName: string) {
        const isGameWithSameName = await this.gameModel.findOne({ name: gameName }).exec();

        if (isGameWithSameName) {
            throw new ConflictException('Un jeu avec le meme nom existe deja');
        }
    }
}

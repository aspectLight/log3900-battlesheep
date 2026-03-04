import { GENERAL_CHAT_MESSAGES_LIMIT } from '@app/modules/general-chat/constants/general-chat.constants';
import { ChatMessage } from '@app/modules/general-chat/interfaces/chat';
import { CustomChannel, CustomChannelDocument } from '@app/modules/general-chat/schemas/custom-channel.schema';
import { ConflictException, Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { MongoServerError } from 'mongodb';
import { Model } from 'mongoose';

@Injectable()
export class CustomChannelService {
    private readonly logger = new Logger(CustomChannelService.name);

    constructor(
        @InjectModel(CustomChannel.name)
        private readonly channelModel: Model<CustomChannelDocument>,
    ) {}

    async createChannel(channelName: string, creator: string): Promise<CustomChannelDocument> {
        if (!channelName || channelName.trim().length === 0) {
            throw new Error('Le nom du canal ne peut pas être vide');
        }

        if (channelName.length > 50) {
            throw new Error('Le nom du canal ne peut pas dépasser 50 caractères');
        }

        const normalizedName = channelName.trim();
        const channelId = this.generateChannelId(normalizedName);

        const existing = await this.channelModel.findOne({ channelId, isActive: true });
        if (existing) {
            throw new ConflictException('Un canal avec ce nom existe déjà');
        }

        const channel = new this.channelModel({
            channelId,
            name: normalizedName,
            creator,
            members: [creator],
            messages: [],
            isActive: true,
            isGameChannel: false,
        });

        try {
            await channel.save();
        } catch (error) {
            if (error instanceof MongoServerError && error.code === 11000) {
                throw new ConflictException('Le nom du canal est déjà pris, veuillez en choisir un autre');
            }
            throw error;
        }
        this.logger.log(`Canal créé: ${channelName} par ${creator}`);
        return channel;
    }

    /** Crée un canal éphémère lié à une partie (non visible dans la liste publique). */
    async createGameChannel(channelId: string, name: string): Promise<void> {
        const existing = await this.channelModel.findOne({ channelId });
        if (existing) {
            // Le canal existe déjà (ex: reconnexion rapide) — rien à faire
            return;
        }
        const channel = new this.channelModel({
            channelId,
            name,
            creator: 'system',
            members: [],
            messages: [],
            isActive: true,
            isGameChannel: true,
        });
        await channel.save();
        this.logger.log(`Canal de partie créé: ${channelId}`);
    }

    /** Supprime définitivement un canal de partie (sans vérifier le créateur). */
    async deleteGameChannel(channelId: string): Promise<void> {
        await this.channelModel.deleteOne({ channelId });
        this.logger.log(`Canal de partie supprimé: ${channelId}`);
    }

    /** Retourne vrai si le canal est un canal de partie. */
    async checkIsGameChannel(channelId: string): Promise<boolean> {
        const channel = await this.channelModel.findOne({ channelId }, { isGameChannel: 1 });
        return channel?.isGameChannel ?? false;
    }

    async getChannel(channelId: string): Promise<CustomChannelDocument | null> {
        return this.channelModel.findOne({ channelId });
    }

    async getAllChannels(): Promise<CustomChannelDocument[]> {
        // Exclut les messages et les canaux de partie (éphémères)
        return this.channelModel.find({ isActive: true, isGameChannel: { $ne: true } }, { messages: 0 }).sort({ createdAt: -1 });
    }

    async joinChannel(channelId: string, username: string): Promise<void> {
        const channel = await this.getChannel(channelId);
        if (!channel) {
            throw new NotFoundException('Canal introuvable');
        }

        if (!channel.members.includes(username)) {
            channel.members.push(username);
            await channel.save();
            this.logger.log(`${username} a rejoint le canal ${channel.name}`);
        }
    }

    async leaveChannel(channelId: string, username: string): Promise<void> {
        const channel = await this.getChannel(channelId);
        if (!channel) {
            throw new NotFoundException('Canal introuvable');
        }

        channel.members = channel.members.filter((m) => m !== username);

        if (channel.members.length === 0) {
            await this.channelModel.deleteOne({ channelId });
            this.logger.log(`Canal ${channel.name} supprimé définitivement (plus de membres)`);
        } else {
            await channel.save();
            this.logger.log(`${username} a quitté le canal ${channel.name}`);
        }
    }

    async deleteChannel(channelId: string, username: string): Promise<void> {
        const channel = await this.getChannel(channelId);
        if (!channel) {
            throw new NotFoundException('Canal introuvable');
        }

        if (channel.creator !== username) {
            throw new Error('Seul le créateur peut supprimer le canal');
        }

        await this.channelModel.deleteOne({ channelId });
        this.logger.log(`Canal ${channel.name} supprimé définitivement par ${username}`);
    }

    async addMessage(channelId: string, message: ChatMessage): Promise<void> {
        await this.channelModel.updateOne(
            { channelId },
            {
                $push: {
                    messages: {
                        $each: [message],
                        $slice: -GENERAL_CHAT_MESSAGES_LIMIT,
                    },
                },
            },
        );
    }

    async getMessages(channelId: string): Promise<ChatMessage[]> {
        const channel = await this.channelModel.findOne({ channelId }, { messages: 1 });
        if (!channel) {
            throw new NotFoundException('Canal introuvable');
        }
        return channel.messages as unknown as ChatMessage[];
    }

    async isMember(channelId: string, username: string): Promise<boolean> {
        const channel = await this.getChannel(channelId);
        return channel?.members.includes(username) ?? false;
    }

    /**
     * Retourne tous les canaux non-partie dont l'utilisateur est membre.
     * Utilisé lors de la reconnexion pour restaurer les canaux rejoints.
     */
    async getChannelsForUser(username: string): Promise<{ channelId: string; name: string }[]> {
        const channels = await this.channelModel.find({ isActive: true, isGameChannel: { $ne: true }, members: username }, { channelId: 1, name: 1 });
        return channels.map((c) => ({ channelId: c.channelId, name: c.name }));
    }

    private generateChannelId(name: string): string {
        return name
            .toLowerCase()
            .replace(/\s+/g, '-')
            .replace(/[^a-z0-9-]/g, '');
    }
}

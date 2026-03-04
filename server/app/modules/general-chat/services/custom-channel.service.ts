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
        });

        try {
            await channel.save();
        } catch (error) {
            // L'index unique MongoDB peut déclencher une erreur E11000 en cas de race condition
            if (error instanceof MongoServerError && error.code === 11000) {
                throw new ConflictException('Le nom du canal est déjà pris, veuillez en choisir un autre');
            }
            throw error;
        }
        this.logger.log(`Canal créé: ${channelName} par ${creator}`);
        return channel;
    }

    async getChannel(channelId: string): Promise<CustomChannelDocument | null> {
        return this.channelModel.findOne({ channelId, isActive: true });
    }

    async getAllChannels(): Promise<CustomChannelDocument[]> {
        // On exclut les messages pour ne pas surcharger la réponse de liste
        return this.channelModel.find({ isActive: true }, { messages: 0 }).sort({ createdAt: -1 });
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
            // Plus aucun membre : suppression définitive
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
        // $push avec $slice pour garder seulement les N derniers messages
        await this.channelModel.updateOne(
            { channelId },
            {
                $push: {
                    messages: {
                        $each: [message],
                        $slice: -GENERAL_CHAT_MESSAGES_LIMIT, // Garde les 100 derniers
                    },
                },
            },
        );
    }

    async getMessages(channelId: string): Promise<ChatMessage[]> {
        const channel = await this.channelModel.findOne(
            { channelId, isActive: true },
            { messages: 1 }, // Projeter seulement les messages
        );
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
     * Retourne tous les canaux actifs dont l'utilisateur est membre.
     * Utilisé lors de la reconnexion pour restaurer les canaux rejoints.
     */
    async getChannelsForUser(username: string): Promise<{ channelId: string; name: string }[]> {
        const channels = await this.channelModel.find(
            { isActive: true, members: username },
            { channelId: 1, name: 1 }, // Projeter seulement les champs nécessaires
        );
        return channels.map((c) => ({ channelId: c.channelId, name: c.name }));
    }

    async replaceUsername(oldName: string, newName: string): Promise<void> {
        // Remplacer le nom dans les messages de tous les canaux
        await this.channelModel.updateMany(
            { 'messages.name': oldName },
            { $set: { 'messages.$[elem].name': newName } },
            { arrayFilters: [{ 'elem.name': oldName }] },
        );

        await this.channelModel.updateMany({ members: oldName }, { $pull: { members: oldName } });
        await this.channelModel.updateMany({ creator: oldName }, { $set: { creator: newName } });
        await this.channelModel.deleteMany({ members: { $size: 0 } });
    }

    private generateChannelId(name: string): string {
        return name
            .toLowerCase()
            .replace(/\s+/g, '-')
            .replace(/[^a-z0-9-]/g, '');
    }
}

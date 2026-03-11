import { GENERAL_CHAT_MESSAGES_LIMIT } from '@app/modules/general-chat/constants/general-chat.constants';
import { ChatMessage } from '@app/modules/general-chat/interfaces/chat';
import { GeneralChatHistory, GeneralChatHistoryDocument } from '@app/modules/general-chat/schemas/general-chat-history.schema';
import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';

const GENERAL_ROOM_ID = 'general';

@Injectable()
export class GeneralChatService implements OnModuleInit {
    private readonly logger = new Logger(GeneralChatService.name);

    constructor(
        @InjectModel(GeneralChatHistory.name)
        private readonly historyModel: Model<GeneralChatHistoryDocument>,
    ) {}

    /** Crée le document singleton s'il n'existe pas encore. */
    async onModuleInit(): Promise<void> {
        await this.historyModel.updateOne({ roomId: GENERAL_ROOM_ID }, { $setOnInsert: { roomId: GENERAL_ROOM_ID, messages: [] } }, { upsert: true });
        this.logger.log('Document historique du chat général prêt.');
    }

    /** Ajoute un message et conserve seulement les N derniers. */
    async addMessage(message: ChatMessage): Promise<void> {
        await this.historyModel.updateOne(
            { roomId: GENERAL_ROOM_ID },
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

    /** Retourne les messages persistés. */
    async getMessages(): Promise<ChatMessage[]> {
        const doc = await this.historyModel.findOne({ roomId: GENERAL_ROOM_ID }, { messages: 1 });
        return (doc?.messages as unknown as ChatMessage[]) ?? [];
    }

    /** Remplace un nom d'utilisateur par un placeholder dans tous les messages. */
    async replaceUsername(oldName: string, newName: string): Promise<void> {
        await this.historyModel.updateOne(
            { roomId: GENERAL_ROOM_ID },
            { $set: { 'messages.$[elem].name': newName } },
            { arrayFilters: [{ 'elem.name': oldName }] },
        );
    }
}
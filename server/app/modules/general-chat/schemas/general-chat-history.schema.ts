/* eslint-disable @typescript-eslint/naming-convention */
/* eslint-disable max-classes-per-file */
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type GeneralChatHistoryDocument = GeneralChatHistory & Document;

@Schema({ _id: false })
class HistoryMessage {
    @Prop({ required: true })
    type: string;

    @Prop()
    name: string;

    @Prop({ required: true })
    content: string;

    @Prop({ required: true })
    time: string;

    @Prop()
    avatarId: string;

    @Prop()
    avatarUrl: string;
}

const HistoryMessageSchema = SchemaFactory.createForClass(HistoryMessage);

/**
 * Document singleton — un seul enregistrement existe toujours (roomId = 'general').
 * Les 100 derniers messages y sont stockés directement.
 */
@Schema()
export class GeneralChatHistory {
    /** Clé fixe : toujours "general". Permet l'upsert idempotent. */
    @Prop({ required: true, unique: true, index: true })
    roomId: string;

    @Prop({ type: [HistoryMessageSchema], default: [] })
    messages: HistoryMessage[];
}

export const GeneralChatHistorySchema = SchemaFactory.createForClass(GeneralChatHistory);

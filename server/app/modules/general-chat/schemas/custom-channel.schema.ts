/* eslint-disable max-classes-per-file */
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type CustomChannelDocument = CustomChannel & Document;

@Schema({ _id: false })
class ChannelMessage {
    @Prop({ required: true })
    type: string;

    @Prop()
    name: string;

    @Prop({ required: true })
    content: string;

    @Prop({ required: true })
    time: string;
}

const channelMessageSchema = SchemaFactory.createForClass(ChannelMessage);

@Schema({ timestamps: true })
export class CustomChannel {
    @Prop({ required: true, unique: true, index: true })
    channelId: string; // ID normalisé (ex: "abc" pour "ABC")

    @Prop({ required: true })
    name: string; // Nom original (ex: "ABC")

    @Prop({ required: true, index: true })
    creator: string; // username du créateur

    @Prop({ type: [String], default: [] })
    members: string[]; // array de usernames

    @Prop({ type: [channelMessageSchema], default: [] })
    messages: ChannelMessage[]; // Historique des messages (100 derniers)

    @Prop({ default: true })
    isActive: boolean; // Pour soft delete

    @Prop({ default: false })
    isGameChannel: boolean; // Vrai pour les canaux éphémères liés à une partie
}

export const customChannelSchema = SchemaFactory.createForClass(CustomChannel);

// Index pour recherche rapide
customChannelSchema.index({ isActive: 1, createdAt: -1 });
customChannelSchema.index({ members: 1 });

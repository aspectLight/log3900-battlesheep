import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';

export type BannedWordDocument = HydratedDocument<BannedWord>;

@Schema({ collection: 'banned_words', timestamps: true })
export class BannedWord {
    @Prop({ required: true, unique: true, trim: true, lowercase: true })
    word: string;

    @Prop({ default: true })
    enabled: boolean;

    @Prop({ default: 1 })
    severity: number;
}

export const bannedWordSchema = SchemaFactory.createForClass(BannedWord);
bannedWordSchema.index({ word: 1 }, { unique: true });

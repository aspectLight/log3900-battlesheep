import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type BlockDocument = Block & Document;

@Schema({ timestamps: true })
export class Block {
    @Prop({ required: true })
    blockerId: string;

    @Prop({ required: true })
    blockedId: string;
}

export const BlockSchema = SchemaFactory.createForClass(Block);

// Indexes to optimize queries
BlockSchema.index({ blockerId: 1, blockedId: 1 }, { unique: true });
BlockSchema.index({ blockedId: 1 });

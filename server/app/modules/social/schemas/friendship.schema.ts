import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type FriendshipDocument = Friendship & Document;

@Schema({ timestamps: true })
export class Friendship {
    @Prop({ required: true })
    user1: string;

    @Prop({ required: true })
    user2: string;
}

export const FriendshipSchema = SchemaFactory.createForClass(Friendship);

// Indexes to optimize queries
FriendshipSchema.index({ user1: 1, user2: 1 }, { unique: true });
FriendshipSchema.index({ user1: 1 });
FriendshipSchema.index({ user2: 1 });

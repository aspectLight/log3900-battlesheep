/* eslint-disable max-classes-per-file */
/* eslint-disable @typescript-eslint/naming-convention */
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type UserDocument = User & Document;

@Schema({ _id: false })
class Statistics {
    @Prop({ default: 0 })
    classicGamesPlayed: number;

    @Prop({ default: 0 })
    ctfGamesPlayed: number;

    @Prop({ default: 0 })
    totalGamesWon: number;

    @Prop({ default: 0 })
    totalPlaytime: number; // In seconds
}

@Schema({ _id: false })
class LoginHistory {
    @Prop({ required: true })
    date: Date;

    @Prop({ required: true, enum: ['login', 'logout'] })
    type: 'login' | 'logout';
}

@Schema({ _id: false })
class GameHistory {
    @Prop({ required: true })
    startDate: Date;

    @Prop()
    endDate?: Date;

    @Prop({ required: true, enum: ['Classique', 'CTF'] })
    mode: 'Classique' | 'CTF';

    @Prop({ default: false })
    hasWon: boolean;

    @Prop({ default: false })
    hasAbandoned: boolean;
}

@Schema({ timestamps: true })
export class User {
    @Prop({ required: true, unique: true, index: true })
    firebaseUid: string;

    @Prop({ required: true, unique: true })
    email: string;

    @Prop({ required: true, unique: true })
    username: string;

    @Prop({ required: true })
    avatarId: string;

    @Prop()
    avatarUrl?: string;

    @Prop({ type: Buffer })
    avatarImageBuffer?: Buffer;

    @Prop()
    avatarImageMimeType?: string;

    @Prop({ default: null })
    currentSessionId: string | null;

    @Prop({ default: false })
    isOnline: boolean;

    // The function insures a new object is created each time
    @Prop({ type: Statistics, default: () => ({}) })
    statistics: Statistics;

    @Prop({ type: [LoginHistory], default: [] })
    loginHistory: LoginHistory[];

    @Prop({ type: [GameHistory], default: [] })
    gameHistory: GameHistory[];

    @Prop({ type: Object, default: {} })
    preferences: Record<string, unknown>;

    @Prop()
    lastLoginAt: Date;
}

export const UserSchema = SchemaFactory.createForClass(User);

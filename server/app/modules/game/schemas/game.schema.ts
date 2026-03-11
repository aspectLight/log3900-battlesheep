import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';
import { Board, boardSchema } from './board.schema';

export type GameDocument = Game & Document;

@Schema()
export class Game extends Document {
    @Prop({
        required: true,
        unique: true,
    })
    name: string;

    @Prop({ required: true })
    description: string;

    @Prop({
        required: true,
        enum: ['classique', 'ctf'],
    })
    mode: string;

    @Prop({
        required: true,
        default: false,
    })
    isVisible: boolean;

    @Prop({
        required: true,
    })
    modificationDate: string;

    @Prop({
        required: false,
        default: 1,
        min: 1,
        max: 5,
    })
    actionPoints: number;

    @Prop({
        required: true,
        type: boardSchema,
    })
    board: Board;
}

export const gameSchema = SchemaFactory.createForClass(Game);

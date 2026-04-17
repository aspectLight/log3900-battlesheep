import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';
import { Board, boardSchema } from './board.schema';

export type GameDocument = Game & Document;

@Schema()
export class Game extends Document {
    @Prop({
        required: true,
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

    @Prop({
        required: true,
        enum: ['public', 'private', 'protected'],
        default: 'public',
    })
    privacy: string;

    @Prop({ required: true })
    owner: string;

    /** When set, the blueprint is hidden from listings and name is reusable; document is removed after retention. */
    @Prop({ type: Date, default: null })
    deletedAt: Date | null;
}

export const gameSchema = SchemaFactory.createForClass(Game);

// Active games keep unique names; soft-deleted rows are excluded so the same name can be recreated with a new _id.
gameSchema.index({ name: 1 }, { unique: true, partialFilterExpression: { deletedAt: null } });

import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';
import { Cell, cellSchema } from './cell.schema';

const BOARD_SIZES_10 = 10;
const BOARD_SIZES_15 = 15;
const BOARD_SIZES_20 = 20;

export type BoardDocument = Board & Document;

@Schema({ _id: false })
export class Board extends Document {
    @Prop({
        required: true,
        enum: [BOARD_SIZES_10, BOARD_SIZES_15, BOARD_SIZES_20],
    })
    size: number;

    @Prop({
        type: [[cellSchema]],
        required: true,
    })
    matrix: Cell[][];
}

export const boardSchema = SchemaFactory.createForClass(Board);

import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';
import { Item, itemSchema } from './item.schema';
import { Tile, tileSchema } from './tile.schema';

export type CellDocument = Cell & Document;

@Schema({ _id: false })
export class Cell extends Document {
    @Prop({
        required: true,
    })
    x: number;

    @Prop({
        required: true,
    })
    y: number;

    @Prop({
        type: tileSchema,
        default: { type: 'snow' },
        required: true,
    })
    tile: Tile;

    @Prop({
        type: itemSchema,
        required: false,
    })
    item?: Item;
}

export const cellSchema = SchemaFactory.createForClass(Cell);

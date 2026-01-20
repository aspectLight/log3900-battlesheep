import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';
import { TileType } from '@app/modules/game/interfaces/tile';

export type TileDocument = Tile & Document;

@Schema({ _id: false })
export class Tile extends Document {
    @Prop({
        required: true,
    })
    type: TileType;

    @Prop({
        required: false,
    })
    orientation?: string;

    @Prop({
        required: false,
    })
    state?: string;
}

export const tileSchema = SchemaFactory.createForClass(Tile);

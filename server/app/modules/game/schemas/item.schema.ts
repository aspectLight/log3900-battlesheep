import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';
import { ItemType } from '@app/shared/interfaces/item';

export type ItemDocument = Item & Document;

@Schema({ _id: false })
export class Item extends Document {
    @Prop({
        required: true,
    })
    type: ItemType;
}

export const itemSchema = SchemaFactory.createForClass(Item);

import { Board } from '@app/model/schema/board.schema';
import { IsBoolean, IsNotEmpty, IsOptional, IsString } from 'class-validator';

export class UpdateGameDto {
    @IsOptional()
    @IsString()
    name: string;

    @IsOptional()
    @IsString()
    description: string;

    @IsOptional()
    @IsBoolean()
    isVisible: boolean;

    @IsOptional()
    @IsNotEmpty()
    board: Board;
}

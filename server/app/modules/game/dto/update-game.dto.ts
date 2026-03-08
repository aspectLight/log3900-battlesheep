import { Board } from '@app/modules/game/interfaces/board';
import { IsNotEmpty, IsOptional, IsString } from 'class-validator';

export class UpdateGameDto {
    @IsOptional()
    @IsString()
    name?: string;

    @IsOptional()
    @IsString()
    description?: string;

    @IsOptional()
    @IsNotEmpty()
    board?: Board;
}

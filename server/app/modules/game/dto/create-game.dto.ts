import { Board } from '@app/modules/game/interfaces/board';
import { IsNotEmpty, IsString } from 'class-validator';

export class CreateGameDto {
    @IsString()
    @IsNotEmpty()
    name: string;

    @IsString()
    @IsNotEmpty()
    description: string;

    @IsString()
    @IsNotEmpty()
    mode: string;

    @IsNotEmpty()
    board: Board;

    @IsString()
    @IsNotEmpty()
    privacy: string;
}

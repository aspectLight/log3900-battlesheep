/* eslint-disable max-classes-per-file */
import { IsEmail, IsIn, IsNotEmpty, IsObject, IsOptional, IsString, MinLength } from 'class-validator';

export class RegisterUserDto {
    @IsEmail({}, { message: 'Email Invalide' })
    email: string;

    @IsString()
    @MinLength(8, { message: 'Le mot de passe doit contenir au moins 8 caracteres' })
    password: string;

    @IsString()
    @IsNotEmpty({ message: "Le nom d'utilisateur est requis" })
    username: string;

    @IsString()
    @IsNotEmpty({ message: "L'avatar est requis" })
    avatarId: string;

    @IsOptional()
    @IsString()
    @IsIn(['fr', 'en'], { message: 'Langue invalide' })
    language?: string;

    @IsOptional()
    @IsString()
    @IsIn(['default', 'frost', 'village'], { message: 'Thème invalide' })
    theme?: string;
}

export class LoginDto {
    @IsString()
    token: string;
}

export class VerifyTokenDto {
    @IsString()
    token: string;
}

export class UpdateUserDto {
    @IsOptional()
    @IsString()
    username?: string;

    @IsOptional()
    @IsString()
    email?: string;

    @IsOptional()
    @IsString()
    avatarId?: string;

    @IsOptional()
    @IsString()
    theme?: string;

    @IsOptional()
    @IsString()
    language?: string;

    @IsOptional()
    @IsObject()
    preferences?: Record<string, unknown>;
}

export class GetEmailByUsernameDto {
    @IsString()
    @IsNotEmpty({ message: "Le nom d'utilisateur est requis" })
    username: string;
}

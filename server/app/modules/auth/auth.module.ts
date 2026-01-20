import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { AuthController } from '@app/modules/auth/auth.controller';
import { AuthService } from '@app/modules/auth/services/auth.service';
import { FirebaseAdminService } from '@app/modules/auth/services/firebase-admin.service';
import { AuthGuard } from '@app/modules/auth/guards/auth.guard';
import { User, UserSchema } from '@app/modules/auth/schemas/user.schema';

@Module({
    imports: [MongooseModule.forFeature([{ name: User.name, schema: UserSchema }])],
    controllers: [AuthController],
    providers: [FirebaseAdminService, AuthService, AuthGuard],
    exports: [FirebaseAdminService, AuthService, AuthGuard],
})
export class AuthModule {}

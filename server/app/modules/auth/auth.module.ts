import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { AuthController } from './controllers/auth.controller';
import { AuthGuard } from './guards/auth.guard';
import { User, UserSchema } from './schemas/user.schema';
import { AuthService } from './services/auth.service';
import { FirebaseAdminService } from './services/firebase-admin.service';

@Module({
    imports: [MongooseModule.forFeature([{ name: User.name, schema: UserSchema }])],
    controllers: [AuthController],
    providers: [FirebaseAdminService, AuthService, AuthGuard],
    exports: [FirebaseAdminService, AuthService, AuthGuard],
})
export class AuthModule {}

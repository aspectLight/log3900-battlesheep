import { GeneralChatModule } from '@app/modules/general-chat/general-chat.module';
import { Module, forwardRef } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { AuthController } from './controllers/auth.controller';
import { AuthGuard } from './guards/auth.guard';
import { User, UserSchema } from './schemas/user.schema';
import { AuthService } from './services/auth.service';
import { FirebaseAdminService } from './services/firebase-admin.service';

@Module({
    // Use forwardRef to avoid circular dependency between AuthModule and GeneralChatModule
    imports: [MongooseModule.forFeature([{ name: User.name, schema: UserSchema }]), forwardRef(() => GeneralChatModule)],
    controllers: [AuthController],
    providers: [FirebaseAdminService, AuthService, AuthGuard],
    exports: [FirebaseAdminService, AuthService, AuthGuard],
})
export class AuthModule {}

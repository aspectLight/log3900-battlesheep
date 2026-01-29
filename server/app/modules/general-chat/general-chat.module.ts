import { AuthModule } from '@app/modules/auth/auth.module';
import { GeneralChatGateway } from '@app/modules/general-chat/general-chat.gateway';
import { GeneralChatService } from '@app/modules/general-chat/services/general-chat.service';
import { Module } from '@nestjs/common';

@Module({
    imports: [AuthModule],
    providers: [GeneralChatGateway, GeneralChatService],
    exports: [GeneralChatGateway, GeneralChatService],
})
export class GeneralChatModule {}

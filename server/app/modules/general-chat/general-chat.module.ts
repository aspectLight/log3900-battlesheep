import { Module } from '@nestjs/common';
import { GeneralChatGateway } from '@app/modules/general-chat/general-chat.gateway';
import { GeneralChatService } from '@app/modules/general-chat/services/general-chat.service';

@Module({
    providers: [GeneralChatGateway, GeneralChatService],
    exports: [GeneralChatGateway, GeneralChatService],
})
export class GeneralChatModule {}

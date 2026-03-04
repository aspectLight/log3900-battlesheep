import { AuthModule } from '@app/modules/auth/auth.module';
import { GeneralChatGateway } from '@app/modules/general-chat/general-chat.gateway';
import { CustomChannel, CustomChannelSchema } from '@app/modules/general-chat/schemas/custom-channel.schema';
import { GeneralChatHistory, GeneralChatHistorySchema } from '@app/modules/general-chat/schemas/general-chat-history.schema';
import { CustomChannelService } from '@app/modules/general-chat/services/custom-channel.service';
import { GeneralChatService } from '@app/modules/general-chat/services/general-chat.service';
import { Module, forwardRef } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';

@Module({
    // Use forwardRef to avoid circular dependency between AuthModule and GeneralChatModule
    imports: [
        forwardRef(() => AuthModule),
        MongooseModule.forFeature([
            { name: CustomChannel.name, schema: CustomChannelSchema },
            { name: GeneralChatHistory.name, schema: GeneralChatHistorySchema },
        ]),
    ],
    providers: [GeneralChatGateway, GeneralChatService, CustomChannelService],
    exports: [GeneralChatGateway, GeneralChatService, CustomChannelService],
})
export class GeneralChatModule {}

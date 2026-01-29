import { Injectable } from '@nestjs/common';
import { ChatMessage } from '@app/modules/general-chat/interfaces/chat';
import { GENERAL_CHAT_MESSAGES_LIMIT } from '@app/modules/general-chat/constants/general-chat.constants';

@Injectable()
export class GeneralChatService {
    private messages: ChatMessage[] = [];

    addMessage(message: ChatMessage): void {
        this.messages.push(message);

        if (this.messages.length > GENERAL_CHAT_MESSAGES_LIMIT) {
            this.messages.shift();
        }
    }

    getMessages(): ChatMessage[] {
        return [...this.messages];
    }

    clearMessages(): void {
        this.messages = [];
    }
}

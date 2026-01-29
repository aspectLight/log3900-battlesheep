import { GENERAL_CHAT_MESSAGES_LIMIT } from '@app/modules/general-chat/constants/general-chat.constants';
import { ChatMessage } from '@app/modules/general-chat/interfaces/chat';
import { Test, TestingModule } from '@nestjs/testing';
import { GeneralChatService } from './general-chat.service';

describe('GeneralChatService', () => {
    let service: GeneralChatService;

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [GeneralChatService],
        }).compile();

        service = module.get<GeneralChatService>(GeneralChatService);
    });

    it('should be defined', () => {
        expect(service).toBeDefined();
    });

    it('should add a message', () => {
        const message: ChatMessage = {
            type: 'received',
            name: 'TestUser',
            content: 'Hello World',
            time: '12:00:00',
        };

        service.addMessage(message);
        expect(service.getMessages()).toContain(message);
        expect(service.getMessages().length).toBe(1);
    });

    it('should limit the number of messages', () => {
        const message: ChatMessage = {
            type: 'received',
            name: 'TestUser',
            content: 'Message',
            time: '12:00:00',
        };

        // Add more messages than the limit
        for (let i = 0; i < GENERAL_CHAT_MESSAGES_LIMIT + 10; i++) {
            service.addMessage({ ...message, content: `Message ${i}` });
        }

        expect(service.getMessages().length).toBe(GENERAL_CHAT_MESSAGES_LIMIT);
        expect(service.getMessages()[0].content).toBe('Message 10'); // Should have shifted the first 10 messages
    });

    it('should clear messages', () => {
        const message: ChatMessage = {
            type: 'received',
            name: 'TestUser',
            content: 'Hello World',
            time: '12:00:00',
        };

        service.addMessage(message);
        service.clearMessages();
        expect(service.getMessages().length).toBe(0);
    });

    it('should return a copy of messages array', () => {
        const message: ChatMessage = {
            type: 'received',
            name: 'TestUser',
            content: 'Hello World',
            time: '12:00:00',
        };

        service.addMessage(message);
        const messages = service.getMessages();
        messages.pop(); // Modify the returned array

        expect(service.getMessages().length).toBe(1); // Original array should be unchanged
    });
});

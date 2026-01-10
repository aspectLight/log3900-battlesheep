import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ChatboxComponent } from './chatbox.component';

const MESSAGES_LENGTH = 2;

describe('ChatboxComponent', () => {
    let component: ChatboxComponent;
    let fixture: ComponentFixture<ChatboxComponent>;

    beforeEach(async () => {
        await TestBed.configureTestingModule({
            imports: [ChatboxComponent],
        }).compileComponents();

        fixture = TestBed.createComponent(ChatboxComponent);
        component = fixture.componentInstance;
        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });

    it('should send message', () => {
        component.newMessage = 'Hello';
        component.sendMessage();
        expect(component.messages.length).toBe(MESSAGES_LENGTH + 1);
        expect(component.messages[2].content).toBe('Hello');
    });

    it('should not send empty message', () => {
        component.newMessage = '   ';
        component.sendMessage();
        expect(component.messages.length).toBe(MESSAGES_LENGTH);
    });
});

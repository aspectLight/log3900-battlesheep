import { NgClass } from '@angular/common';
import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';

@Component({
    selector: 'app-chatbox',
    imports: [NgClass, FormsModule],
    templateUrl: './chatbox.component.html',
    styleUrl: './chatbox.component.scss',
})
export class ChatboxComponent {
    messages = [
        { type: 'received', content: 'Bonjour, comment ça va ?', time: '10:00' },
        { type: 'sent', content: 'Ça va, merci ! Et toi ?', time: '10:01' },
    ];

    newMessage: string = '';

    sendMessage() {
        if (this.newMessage.trim()) {
            this.messages.push({ type: 'sent', content: this.newMessage, time: new Date().toLocaleTimeString() });
            this.newMessage = '';
        }
    }
}

import { Component, Input, Output, EventEmitter } from '@angular/core';

@Component({
    selector: 'app-pop-up',
    imports: [],
    templateUrl: './pop-up.component.html',
    styleUrl: './pop-up.component.scss',
})
export class PopUpComponent {
    @Input() showSecondButton: boolean = false;
    @Input() popUpMessage: string;
    @Input() description: string;
    @Input() firstOption: string = 'Ok';
    @Input() secondOption: string = 'Oui';
    @Output() cancel = new EventEmitter<void>();
    @Output() confirm = new EventEmitter<void>();
    onConfirm(): void {
        this.confirm.emit();
    }
    onCancel(): void {
        this.cancel.emit();
    }
}

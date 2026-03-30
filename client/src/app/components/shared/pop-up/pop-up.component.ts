import { Component, Input, Output, EventEmitter } from '@angular/core';
import { Item } from '@app/classes/entity/item';

@Component({
    selector: 'app-pop-up',
    imports: [],
    templateUrl: './pop-up.component.html',
    styleUrl: './pop-up.component.scss',
})
export class PopUpComponent {
    @Input() isError: boolean = false;
    @Input() showSecondButton: boolean = false;
    @Input() popUpMessage: string;
    @Input() description: string;
    @Input() firstOption: string = 'Ok';
    @Input() secondOption: string = 'Oui';
    @Input() items: Item[] = [];
    @Output() cancel = new EventEmitter<void>();
    @Output() confirm = new EventEmitter<void>();
    @Output() itemSelected = new EventEmitter<Item>();

    onSelect(item: Item): void {
        this.itemSelected.emit(item);
    }
    onConfirm(): void {
        this.confirm.emit();
    }
    onCancel(): void {
        this.cancel.emit();
    }
}

import { Component, EventEmitter, Input, Output } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Item } from '@app/classes/entity/item';

@Component({
    selector: 'app-item-card',
    imports: [CommonModule],
    templateUrl: './item-card.component.html',
    styleUrls: ['./item-card.component.scss'],
})
export class ItemCardComponent {
    @Input() item: Item;
    @Input() index: number = 0;
    @Input() showDropButton: boolean = false;
    @Input() dropEnabled: boolean = false;
    @Output() dropClicked = new EventEmitter<Item>();

    onDropClick(event: Event): void {
        event.stopPropagation();
        if (this.dropEnabled) {
            this.dropClicked.emit(this.item);
        }
    }
}

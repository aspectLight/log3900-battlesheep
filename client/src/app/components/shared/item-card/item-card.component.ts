import { CommonModule } from '@angular/common';
import { Component, EventEmitter, Input, Output } from '@angular/core';
import { Item } from '@app/classes/entity/item';
import { TranslateModule, TranslateService } from '@ngx-translate/core';

@Component({
    selector: 'app-item-card',
    imports: [CommonModule, TranslateModule],
    templateUrl: './item-card.component.html',
    styleUrls: ['./item-card.component.scss'],
})
export class ItemCardComponent {
    @Input() item: Item;
    @Input() index: number = 0;
    @Input() showDropButton: boolean = false;
    @Input() dropEnabled: boolean = false;
    @Output() dropClicked = new EventEmitter<Item>();

    constructor(private translate: TranslateService) {}

    get itemDisplayName(): string {
        const key = `items_names.${this.item.type}`;
        const translated = this.translate.instant(key);
        return translated !== key ? translated : this.item.name;
    }

    get itemDisplayInitial(): string {
        return this.itemDisplayName?.[0] ?? '';
    }

    onDropClick(event: Event): void {
        event.stopPropagation();
        if (this.dropEnabled) {
            this.dropClicked.emit(this.item);
        }
    }
}

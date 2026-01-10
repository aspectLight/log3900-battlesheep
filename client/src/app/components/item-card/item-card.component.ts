import { Component, Input } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Item } from '@app/classes/item';

@Component({
    selector: 'app-item-card',
    imports: [CommonModule],
    templateUrl: './item-card.component.html',
    styleUrls: ['./item-card.component.scss'],
})
export class ItemCardComponent {
    @Input() item: Item;
    @Input() index: number = 0;
}

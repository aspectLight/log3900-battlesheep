import { CommonModule } from '@angular/common';
import { Component, Input } from '@angular/core';
import { Item } from '@app/classes/entity/item';
import { TranslateModule } from '@ngx-translate/core';

@Component({
    selector: 'app-item-card',
    imports: [CommonModule, TranslateModule],
    templateUrl: './item-card.component.html',
    styleUrls: ['./item-card.component.scss'],
})
export class ItemCardComponent {
    @Input() item: Item;
    @Input() index: number = 0;
}

import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PopUpComponent } from './pop-up.component';
import { Item } from '@app/classes/item';

describe('PopUpComponent', () => {
    let component: PopUpComponent;
    let fixture: ComponentFixture<PopUpComponent>;

    beforeEach(async () => {
        await TestBed.configureTestingModule({
            imports: [PopUpComponent],
        }).compileComponents();

        fixture = TestBed.createComponent(PopUpComponent);
        component = fixture.componentInstance;
        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });

    it('should emit confirm event when onConfirm() is called', () => {
        spyOn(component.confirm, 'emit');

        component.onConfirm();

        expect(component.confirm.emit).toHaveBeenCalled();
    });

    it('should emit cancel event when onCancel() is called', () => {
        spyOn(component.cancel, 'emit');

        component.onCancel();

        expect(component.cancel.emit).toHaveBeenCalled();
    });

    it('should emit itemSelected event with the selected item when onSelect() is called', () => {
        const mockItem = { name: 'Test Item' } as Item;
        spyOn(component.itemSelected, 'emit');

        component.onSelect(mockItem);

        expect(component.itemSelected.emit).toHaveBeenCalledWith(mockItem);
    });
});

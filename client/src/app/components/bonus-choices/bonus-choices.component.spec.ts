import { ComponentFixture, TestBed } from '@angular/core/testing';

import { BonusChoicesComponent } from './bonus-choices.component';
import { BonusValue } from '@app/interfaces/character';

describe('BonusChoicesComponent', () => {
    let component: BonusChoicesComponent;
    let fixture: ComponentFixture<BonusChoicesComponent>;

    beforeEach(async () => {
        await TestBed.configureTestingModule({
            imports: [BonusChoicesComponent],
        }).compileComponents();

        fixture = TestBed.createComponent(BonusChoicesComponent);
        component = fixture.componentInstance;
        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });

    it('should initialize with default values', () => {
        expect(component.health).toBe(component.initialStat);
        expect(component.speed).toBe(component.initialStat);
        expect(component.attackDice).toBeNull();
        expect(component.defenseDice).toBeNull();
        expect(component.selectedBonus).toBeNull();
    });

    it('should set health to boostedStat when healthBonus is selected', () => {
        component.selectBonus('healthBonus');
        expect(component.selectedBonus).toBe('healthBonus');
        expect(component.health).toBe(component.boostedStat);
        expect(component.speed).toBe(component.initialStat);
    });

    it('should set speed to boostedStat when speedBonus is selected', () => {
        component.selectBonus('speedBonus');
        expect(component.selectedBonus).toBe('speedBonus');
        expect(component.speed).toBe(component.boostedStat);
        expect(component.health).toBe(component.initialStat);
    });

    it('should select attack dice and set defense dice to the opposite value', () => {
        // eslint-disable-next-line @typescript-eslint/no-magic-numbers
        component.selectAttackDice(4);
        expect(component.attackDice).toBe(BonusValue.DEFAULT);
        expect(component.defenseDice).toBe(BonusValue.BOOSTED);

        // eslint-disable-next-line @typescript-eslint/no-magic-numbers
        component.selectAttackDice(6);
        expect(component.attackDice).toBe(BonusValue.BOOSTED);
        expect(component.defenseDice).toBe(BonusValue.DEFAULT);
    });

    it('should select defense dice and set attack dice to the opposite value', () => {
        // eslint-disable-next-line @typescript-eslint/no-magic-numbers
        component.selectDefenseDice(4);
        expect(component.defenseDice).toBe(BonusValue.DEFAULT);
        expect(component.attackDice).toBe(BonusValue.BOOSTED);

        // eslint-disable-next-line @typescript-eslint/no-magic-numbers
        component.selectDefenseDice(6);
        expect(component.defenseDice).toBe(BonusValue.BOOSTED);
        expect(component.attackDice).toBe(BonusValue.DEFAULT);
    });
});

import { ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { CharacterGridComponent } from './character-grid.component';

describe('CharacterGridComponent', () => {
    let component: CharacterGridComponent;
    let fixture: ComponentFixture<CharacterGridComponent>;
    const nCharacters = 12;

    beforeEach(async () => {
        await TestBed.configureTestingModule({
            imports: [CharacterGridComponent],
        }).compileComponents();

        fixture = TestBed.createComponent(CharacterGridComponent);
        component = fixture.componentInstance;
        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });

    it('should display exactly 12 characters', () => {
        const characterElements = fixture.debugElement.queryAll(By.css('.char'));
        expect(characterElements.length).toBe(nCharacters);
    });

    it('should select a character when clicked', () => {
        const characterElements = fixture.debugElement.queryAll(By.css('.char'));
        characterElements[0].nativeElement.click();
        fixture.detectChanges();

        expect(component.selectedCharacter).toEqual(component.characters['viktor']);
        expect(characterElements[0].classes['selected']).toBeTruthy();
    });

    it('should change selected character when another is clicked', () => {
        const characterElements = fixture.debugElement.queryAll(By.css('.char'));
        characterElements[1].nativeElement.click();
        fixture.detectChanges();
        expect(component.selectedCharacter).toEqual(component.characters['petrov']);

        characterElements[2].nativeElement.click();
        fixture.detectChanges();
        expect(component.selectedCharacter).toEqual(component.characters['dmitry']);
    });

    it('should apply selected class to the selected character', () => {
        const characterElements = fixture.debugElement.queryAll(By.css('.char'));
        characterElements[3].nativeElement.click();
        fixture.detectChanges();

        expect(characterElements[3].classes['selected']).toBeTruthy();
    });

    it('should return false on isCharacterDisabled for unreserved avatars', () => {
        component.reservedAvatars = [];
        expect(component.isCharacterDisabled('viktor')).toBeFalse();
    });

    it('should return true on isCharacterDisabled for reserved avatars by other players', () => {
        component.reservedAvatars = [{ reservorId: '123', chosenAvatar: 'viktor' }];
        component.socketId = '456';
        expect(component.isCharacterDisabled('viktor')).toBeTrue();
    });

    it('should return false on isCharacterDisabled for reserved avatars by other itself', () => {
        component.reservedAvatars = [{ reservorId: '123', chosenAvatar: 'viktor' }];
        component.socketId = '123';
        expect(component.isCharacterDisabled('viktor')).toBeFalse();
    });
});

import { CommonModule } from '@angular/common';
import { Component, EventEmitter, Input, OnChanges, Output, SimpleChanges } from '@angular/core';
import { TranslateModule } from '@ngx-translate/core';
import { AVATAR_TYPES } from '@app/constants/player.constants';
import { Reservation } from '@app/interfaces/reservation.interface';
import { EXCLUSIVE_CHARACTER_IDS } from '@common/shop.constants';
@Component({
    imports: [CommonModule, TranslateModule],
    selector: 'app-character-grid',
    templateUrl: './character-grid.component.html',
    styleUrl: './character-grid.component.scss',
})
export class CharacterGridComponent implements OnChanges {
    @Output() characterSelected = new EventEmitter<{ name: string; id: number; avatar: string }>();
    @Input() reservedAvatars: Reservation[] = [];
    @Input() purchasedItems: string[] = [];
    @Input() socketId: string = '';
    /** Increment to clear the local selection (e.g. after the server rejects a reservation). */
    @Input() selectionResetNonce: number = 0;

    characters = AVATAR_TYPES;
    selectedCharacter: { name: string } | null = null;
    private lastSelectionResetNonce = 0;

    ngOnChanges(changes: SimpleChanges): void {
        if (!changes['selectionResetNonce']) return;
        const next = this.selectionResetNonce;
        if (next > this.lastSelectionResetNonce) {
            this.selectedCharacter = null;
            this.lastSelectionResetNonce = next;
        }
    }

    getAvatarKeys(): string[] {
        return Object.keys(AVATAR_TYPES).filter((key) => !this.isPremiumLocked(key));
    }

    isPremiumLocked(character: string): boolean {
        return EXCLUSIVE_CHARACTER_IDS.includes(character) && !this.purchasedItems.includes(character);
    }

    selectCharacter(character: string) {
        if (this.isPremiumLocked(character)) return;
        this.selectedCharacter = AVATAR_TYPES[character];
        this.characterSelected.emit(AVATAR_TYPES[character]);
    }

    isCharacterDisabled(avatarToCheck: string): boolean {
        if (this.isPremiumLocked(avatarToCheck)) return true;
        return this.reservedAvatars.some((avatar) => avatar.chosenAvatar.toLowerCase() === avatarToCheck && avatar.reservorId !== this.socketId);
    }
}

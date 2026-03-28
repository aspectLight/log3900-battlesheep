import { CommonModule } from '@angular/common';
import { Component, EventEmitter, Input, Output } from '@angular/core';
import { TranslateModule } from '@ngx-translate/core';
import { AVATAR_TYPES } from '@app/constants/player.constants';
import { Reservation } from '@app/interfaces/reservation.interface';
@Component({
    imports: [CommonModule, TranslateModule],
    selector: 'app-character-grid',
    templateUrl: './character-grid.component.html',
    styleUrl: './character-grid.component.scss',
})
export class CharacterGridComponent {
    @Output() characterSelected = new EventEmitter<{ name: string; id: number; avatar: string }>();
    @Input() reservedAvatars: Reservation[] = [];
    @Input() socketId: string = '';

    characters = AVATAR_TYPES;
    selectedCharacter: { name: string } | null = null;

    getAvatarKeys(): string[] {
        return Object.keys(AVATAR_TYPES);
    }

    selectCharacter(character: string) {
        this.selectedCharacter = AVATAR_TYPES[character];
        this.characterSelected.emit(AVATAR_TYPES[character]);
    }

    isCharacterDisabled(avatarToCheck: string): boolean {
        return this.reservedAvatars.some((avatar) => avatar.chosenAvatar.toLowerCase() === avatarToCheck && avatar.reservorId !== this.socketId);
    }
}

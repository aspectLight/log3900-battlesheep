import { Injectable } from '@angular/core';
import { Player, Stats } from '@app/classes/player';
import { BonusType } from '@app/constants/bonus.constants';
import { RoomSocketService } from './socket/room-socket.service';
import { AVATAR_TYPES, VirtualPlayerType } from '@app/constants/player.constants';

@Injectable({
    providedIn: 'root',
})
export class VirtualPlayerService {
    private readonly vpNames = ['VP1', 'VP2', 'VP3', 'VP4', 'VP5', 'VP6', 'VP7', 'VP8', 'VP9', 'VP10'];
    private usedNames: string[] = [];
    private readonly avatars = Object.keys(AVATAR_TYPES);

    constructor(private roomSocketService: RoomSocketService) {}

    generateVirtualPlayer(profile: string): Player {
        const name = this.generateUniqueVPName();
        const avatar = this.generateUniqueAvatar();
        const d6Choice = this.generateRandomD6Choice();
        const bonusChoice = this.generateRandomBonusChoice();
        const player = new Player(name, avatar, bonusChoice, d6Choice, profile as VirtualPlayerType);
        player.id = name;
        return player;
    }

    generateUniqueVPName(): string {
        const availableNames = this.vpNames.filter((name) => !this.usedNames.includes(name));
        const selectedName = availableNames[Math.floor(Math.random() * availableNames.length)];
        this.usedNames.push(selectedName);
        return selectedName;
    }

    resetUsedNames(): void {
        this.usedNames = [];
    }

    removeName(name: string): void {
        const index = this.usedNames.indexOf(name);
        if (index !== -1) {
            this.usedNames.splice(index, 1);
        }
    }

    generateUniqueAvatar(): string {
        let reservedAvatars: string[] = [];
        this.roomSocketService.reservedAvatars$
            .subscribe((avatars) => {
                reservedAvatars = avatars.map((avatar) => avatar.chosenAvatar.toLowerCase());
            })
            .unsubscribe();
        const availableAvatars = [...this.avatars].filter((avatar) => !reservedAvatars.includes(avatar.toLowerCase()));
        return availableAvatars[Math.floor(Math.random() * availableAvatars.length)];
    }

    generateRandomD6Choice(): Stats {
        const d6Choices: Stats[] = [BonusType.Attack, BonusType.Defense];
        return d6Choices[Math.floor(Math.random() * d6Choices.length)];
    }

    generateRandomBonusChoice(): Stats {
        const bonusChoices: Stats[] = [BonusType.Health, BonusType.Speed];
        return bonusChoices[Math.floor(Math.random() * bonusChoices.length)];
    }
}

import { Component } from '@angular/core';
import { GameListComponent } from '@app/components/editor/game-list/game-list.component';
import { ProfileMenuComponent } from '@app/components/shared/profile-menu/profile-menu.component';
import { RouterLink } from '@angular/router';

@Component({
    selector: 'app-admin-game-page',
    templateUrl: './admin-game-page.component.html',
    styleUrls: ['./admin-game-page.component.scss'],
    imports: [GameListComponent, RouterLink, ProfileMenuComponent],
})
export class AdminGamePageComponent {}

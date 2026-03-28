import { Component } from '@angular/core';
import { RouterLink } from '@angular/router';
import { GameListComponent } from '@app/components/editor/game-list/game-list.component';
import { TranslateModule } from '@ngx-translate/core';

@Component({
    selector: 'app-admin-game-page',
    templateUrl: './admin-game-page.component.html',
    styleUrls: ['./admin-game-page.component.scss'],
    imports: [GameListComponent, RouterLink, TranslateModule],
})
export class AdminGamePageComponent {}

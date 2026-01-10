import { Component } from '@angular/core';
import { WaitingPlayerComponent } from '@app/components/waiting-player/waiting-player.component';

@Component({
    imports: [WaitingPlayerComponent],
    selector: 'app-waiting-player-page',
    templateUrl: './waiting-player-page.component.html',
    styleUrl: './waiting-player-page.component.scss',
})
export class WaitingPlayerPageComponent {}

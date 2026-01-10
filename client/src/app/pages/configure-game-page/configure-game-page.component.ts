import { Component } from '@angular/core';
import { GameConfiguratorComponent } from '@app/components/game-configurator/game-configurator.component';

@Component({
    selector: 'app-configure-game-page',
    imports: [GameConfiguratorComponent],
    templateUrl: './configure-game-page.component.html',
    styleUrl: './configure-game-page.component.scss',
})
export class ConfigureGamePageComponent {}

import { Component, EventEmitter, Input, Output } from '@angular/core';
import { Board } from '@app/classes/board/board';
import { TranslateModule } from '@ngx-translate/core';

@Component({
    selector: 'app-restart-game',
    imports: [TranslateModule],
    templateUrl: './restart-game.component.html',
    styleUrl: './restart-game.component.scss',
})
export class RestartGameComponent {
    @Input() board!: Board;
    @Output() restartConfirmed = new EventEmitter<void>();
    isToggled: boolean = false;

    onRestartGame() {
        this.isToggled = true;
    }

    onCancelRestart() {
        this.isToggled = false;
    }

    onConfirmRestart() {
        this.restartConfirmed.emit();
        this.isToggled = false;
    }
}

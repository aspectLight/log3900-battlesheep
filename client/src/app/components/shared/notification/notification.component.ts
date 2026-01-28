import { Component, Input, OnDestroy, OnInit } from '@angular/core';
import { GameManagerService } from '@app/services/state/game-manager.service';
import { MS_TO_SECONDS } from '@app/constants/combat.constants';

@Component({
    selector: 'app-notification',
    imports: [],
    templateUrl: './notification.component.html',
    styleUrl: './notification.component.scss',
})
export class NotificationComponent implements OnInit, OnDestroy {
    @Input() message: string;
    @Input() time: number;
    @Input() mode: string;
    isVisible: boolean = false;
    remainingSeconds: number;

    private countdownInterval: number;
    constructor(private gameManager: GameManagerService) {}

    ngOnInit(): void {
        if (this.mode === 'finishGame') {
            this.isVisible = true;
            this.remainingSeconds = Math.ceil(this.time / MS_TO_SECONDS);
            this.countdownInterval = window.setInterval(() => {
                this.remainingSeconds--;
                if (this.remainingSeconds <= 0) {
                    clearInterval(this.countdownInterval);
                    this.isVisible = false;
                }
            }, MS_TO_SECONDS);
        } else {
            this.remainingSeconds = this.time;
        }

        this.gameManager.turnCountdown.subscribe((count) => {
            this.isVisible = true;
            this.remainingSeconds = count;
            if (this.remainingSeconds <= 0) {
                this.isVisible = false;
            }
        });
    }

    ngOnDestroy(): void {
        clearInterval(this.countdownInterval);
    }
}

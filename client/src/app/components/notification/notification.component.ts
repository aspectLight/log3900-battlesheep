import { Component, Input, OnDestroy, OnInit } from '@angular/core';
const MS_TO_SECONDS = 1000;
@Component({
    selector: 'app-notification',
    imports: [],
    templateUrl: './notification.component.html',
    styleUrl: './notification.component.scss',
})
export class NotificationComponent implements OnInit, OnDestroy {
    @Input() message: string;
    @Input() duration: number;
    isVisible: boolean = true;
    remainingSeconds: number;

    private countdownInterval: number;

    ngOnInit(): void {
        this.remainingSeconds = Math.ceil(this.duration / MS_TO_SECONDS);
        this.countdownInterval = window.setInterval(() => {
            this.remainingSeconds--;
            if (this.remainingSeconds <= 0) {
                clearInterval(this.countdownInterval);
                this.isVisible = false;
            }
        }, MS_TO_SECONDS);
    }

    ngOnDestroy(): void {
        clearInterval(this.countdownInterval);
    }
}

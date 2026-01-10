import { Component, OnInit } from '@angular/core';
import { RouterLink } from '@angular/router';
import { PopUpComponent } from '@app/components/pop-up/pop-up.component';
import { GameManagerService } from '@app/services/game-manager.service';
import { SocketService } from '@app/services/socket.service';

@Component({
    selector: 'app-main-page',
    templateUrl: './main-page.component.html',
    styleUrls: ['./main-page.component.scss'],
    imports: [RouterLink, PopUpComponent],
})
export class MainPageComponent implements OnInit {
    readonly title: string = 'Eastern Solace';

    constructor(
        private gameManagerService: GameManagerService,
        private socketService: SocketService,
    ) {}

    get isGameCanceled(): boolean {
        return this.gameManagerService.isGameCanceled;
    }

    get isGameFinished(): boolean {
        return this.gameManagerService.isGameFinished;
    }

    ngOnInit(): void {
        this.socketService.reconnect();
    }

    understandError() {
        this.gameManagerService.isGameCanceled = false;
    }

    understandMessage() {
        this.gameManagerService.isGameFinished = false;
    }
}

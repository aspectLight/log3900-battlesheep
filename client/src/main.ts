import { provideHttpClient } from '@angular/common/http';
import { enableProdMode } from '@angular/core';
import { bootstrapApplication } from '@angular/platform-browser';
import { provideAnimations } from '@angular/platform-browser/animations';
import { Routes, provideRouter, withHashLocation } from '@angular/router';
import { AdminGamePageComponent } from '@app/pages/admin-game-page/admin-game-page.component';
import { AppComponent } from '@app/pages/app/app.component';
import { ConfigureGamePageComponent } from '@app/pages/configure-game-page/configure-game-page.component';
import { CreateGamePageComponent } from '@app/pages/create-game-page/create-game-page.component';
import { CreatePlayerPageComponent } from '@app/pages/create-player-page/create-player-page.component';
import { EditGamePageComponent } from '@app/pages/edit-game-page/edit-game-page.component';
import { GamePageComponent } from '@app/pages/game-page/game-page.component';
import { JoinGamePageComponent } from '@app/pages/join-game-page/join-game-page.component';
import { MainPageComponent } from '@app/pages/main-page/main-page.component';
import { WaitingPlayerPageComponent } from '@app/pages/waiting-player-page/waiting-player-page.component';
import { environment } from './environments/environment';

if (environment.production) {
    enableProdMode();
}

const routes: Routes = [
    { path: '', redirectTo: '/home', pathMatch: 'full' },
    { path: 'home', component: MainPageComponent },
    { path: 'join-game', component: JoinGamePageComponent },
    { path: 'admin-game', component: AdminGamePageComponent },
    { path: 'create-game', component: CreateGamePageComponent },
    { path: 'create-player', component: CreatePlayerPageComponent },
    { path: 'waiting-player', component: WaitingPlayerPageComponent },
    { path: 'configure-game', component: ConfigureGamePageComponent },
    { path: 'edit-game', component: EditGamePageComponent },
    { path: 'game', component: GamePageComponent },
    { path: '**', redirectTo: '/home' },
];

bootstrapApplication(AppComponent, {
    providers: [provideHttpClient(), provideRouter(routes, withHashLocation()), provideAnimations()],
})
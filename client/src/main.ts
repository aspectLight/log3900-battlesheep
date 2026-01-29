import { provideHttpClient } from '@angular/common/http';
import { enableProdMode } from '@angular/core';
import { getApp, initializeApp, provideFirebaseApp } from '@angular/fire/app';
import { browserSessionPersistence, initializeAuth, provideAuth } from '@angular/fire/auth';
import { bootstrapApplication } from '@angular/platform-browser';
import { provideAnimations } from '@angular/platform-browser/animations';
import { PreloadAllModules, Routes, provideRouter, withHashLocation, withPreloading } from '@angular/router';
import { authGuard } from '@app/guards/auth.gard';
import { AdminGamePageComponent } from '@app/pages/admin-game-page/admin-game-page.component';
import { AppComponent } from '@app/pages/app/app.component';
import { AuthLandingPageComponent } from '@app/pages/auth-landing/auth-landing.component';
import { ConfigureGamePageComponent } from '@app/pages/configure-game-page/configure-game-page.component';
import { CreateGamePageComponent } from '@app/pages/create-game-page/create-game-page.component';
import { CreatePlayerPageComponent } from '@app/pages/create-player-page/create-player-page.component';
import { EditGamePageComponent } from '@app/pages/edit-game-page/edit-game-page.component';
import { EndGamePageComponent } from '@app/pages/end-game-page/end-game-page.component';
import { GamePageComponent } from '@app/pages/game-page/game-page.component';
import { GamesHistoryComponent } from '@app/pages/games-history/games-history.component';
import { JoinGamePageComponent } from '@app/pages/join-game-page/join-game-page.component';
import { LoginPageComponent } from '@app/pages/login/login.component';
import { LogsHistoryComponent } from '@app/pages/logs-history/logs-history.component';
import { MainPageComponent } from '@app/pages/main-page/main-page.component';
import { RegisterPageComponent } from '@app/pages/register/register.component';
import { WaitingPlayerPageComponent } from '@app/pages/waiting-player-page/waiting-player-page.component';
import { environment } from './environments/environment';

if (environment.production) {
    enableProdMode();
}

const routes: Routes = [
    { path: '', redirectTo: '/home', pathMatch: 'full' },
    { path: 'home', component: MainPageComponent, canActivate: [authGuard] },
    { path: 'join-game', component: JoinGamePageComponent, canActivate: [authGuard] },
    { path: 'admin-game', component: AdminGamePageComponent, canActivate: [authGuard] },
    { path: 'create-game', component: CreateGamePageComponent, canActivate: [authGuard] },
    { path: 'create-player', component: CreatePlayerPageComponent, canActivate: [authGuard] },
    { path: 'waiting-player', component: WaitingPlayerPageComponent, canActivate: [authGuard] },
    { path: 'configure-game', component: ConfigureGamePageComponent, canActivate: [authGuard] },
    { path: 'edit-game', component: EditGamePageComponent, canActivate: [authGuard] },
    { path: 'game', component: GamePageComponent, canActivate: [authGuard] },
    { path: 'end-game', component: EndGamePageComponent, canActivate: [authGuard] },
    { path: 'register', component: RegisterPageComponent },
    { path: 'login', component: LoginPageComponent },
    { path: 'auth-landing', component: AuthLandingPageComponent },
    { path: 'logs-history', component: LogsHistoryComponent, canActivate: [authGuard] },
    { path: 'games-history', component: GamesHistoryComponent, canActivate: [authGuard] },
    { path: '**', redirectTo: '/home' },
];

bootstrapApplication(AppComponent, {
    providers: [
        provideHttpClient(),
        provideRouter(routes, withHashLocation(), withPreloading(PreloadAllModules)),
        provideAnimations(),
        provideFirebaseApp(() => initializeApp(environment.firebase)),
        provideAuth(() => initializeAuth(getApp(), { persistence: browserSessionPersistence })),
    ],
});

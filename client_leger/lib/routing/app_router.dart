import 'package:auto_route/auto_route.dart';

import '../presentation/screens/auth_landing/auth_landing_screen.dart';
import '../presentation/screens/game_history/game_history_screen.dart';
import '../presentation/screens/login/login_screen.dart';
import '../presentation/screens/logs_history/logs_history_screen.dart';
import '../presentation/screens/main_menu/main_menu_screen.dart';
import '../presentation/screens/sign_up/sign_up_screen.dart';
import 'auth_guard.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  final AuthGuard authGuard;

  AppRouter({required this.authGuard});

  @override
  List<AutoRoute> get routes => [
    CustomRoute(
      page: AuthLandingRoute.page,
      path: '/',
      initial: true,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      page: LoginRoute.page,
      path: '/login',
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      page: SignUpRoute.page,
      path: '/signup',
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      page: MainMenuRoute.page,
      path: '/main',
      guards: [authGuard],
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      page: LogsHistoryRoute.page,
      path: '/logs-history',
      guards: [authGuard],
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      page: GameHistoryRoute.page,
      path: '/game-history',
      guards: [authGuard],
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
  ];

  @override
  RouteType get defaultRouteType => const RouteType.custom();
}

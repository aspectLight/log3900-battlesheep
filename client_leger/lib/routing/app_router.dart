import 'package:auto_route/auto_route.dart';

import '../core/presentation/screens/authenticated_shell/authenticated_shell_screen.dart';
import '../core/presentation/screens/loading_screen/loading_screen.dart';
import '../core/presentation/screens/main_menu/main_menu_screen.dart';
import '../features/authentication/presentation/screens/auth_landing/auth_landing_screen.dart';
import '../features/authentication/presentation/screens/login/login_screen.dart';
import '../features/authentication/presentation/screens/sign_up/sign_up_screen.dart';
import '../features/character_creation/presentation/screens/character_creation/character_creation_screen.dart';
import '../features/friends/presentation/screens/friends_screen.dart';
import '../features/game_history/presentation/screens/game_history/game_history_screen.dart';
import '../features/game_session/presentation/screens/game_screen/game_screen.dart';
import '../features/join_game_session/presentation/screens/join_game_session/join_game_session_screen.dart';
import '../features/logs_history/presentation/screens/logs_history/logs_history_screen.dart';
import '../features/profile/presentation/screens/profile/profile_screen.dart';
import '../features/select_game_session/presentation/screens/select_game_session/select_game_session_screen.dart';
import '../features/statistics/presentation/screens/statistics_screen/statistics_screen.dart';
import '../features/waiting_room/presentation/screens/waiting_room/waiting_room_screen.dart';
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
    AutoRoute(
      page: AuthenticatedShellRoute.page,
      path: '/app',
      guards: [authGuard],
      children: [
        CustomRoute(
          page: MainMenuRoute.page,
          path: 'main',
          initial: true,
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          page: LoadingRoute.page,
          path: 'game-loading',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          page: GameRoute.page,
          path: 'game',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          page: CharacterCreationRoute.page,
          path: 'character-creation',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          page: StatisticsRoute.page,
          path: 'statistics',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          page: JoinGameSessionRoute.page,
          path: 'join-game',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          page: SelectGameSessionRoute.page,
          path: 'select-game',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          page: WaitingRoomRoute.page,
          path: 'waiting-room',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          page: LogsHistoryRoute.page,
          path: 'logs-history',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          page: GameHistoryRoute.page,
          path: 'game-history',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          page: ProfileRoute.page,
          path: 'profile',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          page: FriendsRoute.page,
          path: 'friends',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
      ],
    ),
  ];

  @override
  RouteType get defaultRouteType => const RouteType.custom();
}

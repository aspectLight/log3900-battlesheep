import 'package:auto_route/auto_route.dart';

import '../presentation/screens/auth_landing_screen.dart';
import '../presentation/screens/chat_screen.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/main_screen.dart';
import '../presentation/screens/sign_up_screen.dart';
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
      page: ChatRoute.page,
      path: '/chat',
      guards: [authGuard],
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      page: MainRoute.page,
      path: '/main',
      guards: [authGuard],
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
  ];

  @override
  RouteType get defaultRouteType => const RouteType.custom();
}

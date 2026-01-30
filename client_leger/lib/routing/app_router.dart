import 'package:auto_route/auto_route.dart';

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
    AutoRoute(page: LoginRoute.page, path: '/login'),
    AutoRoute(page: SignUpRoute.page, path: '/signup'),
    AutoRoute(page: ChatRoute.page, path: '/chat', guards: [authGuard]),
    AutoRoute(page: MainRoute.page, path: '/main', guards: [authGuard]),
  ];

  @override
  RouteType get defaultRouteType => const RouteType.material();
}

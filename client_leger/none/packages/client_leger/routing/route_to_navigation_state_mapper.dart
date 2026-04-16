import 'app_router.dart';
import 'navigation_state.dart';

class RouteToNavigationStateMapper {
  NavigationState fromRouteName(String? name) {
    if (name == null) return NavigationState.unknown;
    return switch (name) {
      AuthLandingRoute.name => NavigationState.unauthenticated,
      LoginRoute.name => NavigationState.login,
      SignUpRoute.name => NavigationState.signUp,
      MainMenuRoute.name => NavigationState.mainMenu,
      LoadingRoute.name => NavigationState.game,
      GameRoute.name => NavigationState.game,
      StatisticsRoute.name => NavigationState.statistics,
      _ => NavigationState.unknown,
    };
  }
}

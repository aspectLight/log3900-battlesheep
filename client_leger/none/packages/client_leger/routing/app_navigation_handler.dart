import 'dart:async';

import 'package:auto_route/auto_route.dart';

import 'app_navigator.dart';
import 'app_router.dart';
import 'navigation_command.dart';
import 'route_to_navigation_state_mapper.dart';
import 'stack_transition.dart';

class AppNavigationHandler extends AppNavigator {
  AppNavigationHandler({
    required AppRouter appRouter,
    required RouteToNavigationStateMapper mapper,
  }) : _appRouter = appRouter,
       _mapper = mapper;

  final AppRouter _appRouter;
  final RouteToNavigationStateMapper _mapper;

  @override
  void request(NavigationCommand command) {
    final effectiveRouteName =
        _appRouter.currentChild?.name == AuthenticatedShellRoute.name
        ? _appRouter
              .innerRouterOf<StackRouter>(AuthenticatedShellRoute.name)
              ?.currentChild
              ?.name
        : _appRouter.currentChild?.name;
    _mapper.fromRouteName(effectiveRouteName);
    switch (command) {
      case ForceUnauthenticated():
        _apply(StackTransition.replaceAll, [const AuthLandingRoute()]);
      case GoToAuth():
        _apply(StackTransition.replaceAll, [const AuthLandingRoute()]);
      case GoToLogin():
        _apply(StackTransition.push, [const LoginRoute()]);
      case GoToSignUp():
        _apply(StackTransition.push, [const SignUpRoute()]);
      case GoToMainMenu():
        _apply(StackTransition.replaceAll, [
          const AuthenticatedShellRoute(children: [MainMenuRoute()]),
        ]);
      case ExitToMainMenu():
        _apply(StackTransition.replaceAll, [
          const AuthenticatedShellRoute(children: [MainMenuRoute()]),
        ]);
      case GoToGameLoading():
        _pushAuthenticated(const LoadingRoute());
      case GoToGame():
        _pushAuthenticated(const GameRoute());
      case GoToStatistics():
        _pushAuthenticated(const StatisticsRoute());
      case GoToJoinGameSession():
        _pushAuthenticated(const JoinGameSessionRoute());
      case GoToCharacterCreation():
        _pushAuthenticated(const CharacterCreationRoute());
      case GoToSelectGameSession():
        _pushAuthenticated(const SelectGameSessionRoute());
      case GoToWaitingRoom():
        _pushAuthenticated(const WaitingRoomRoute());
      case GoToLogsHistory():
        _pushAuthenticated(const LogsHistoryRoute());
      case GoToGameHistory():
        _pushAuthenticated(const GameHistoryRoute());
      case GoToProfile():
        _pushAuthenticated(const ProfileRoute());
      case GoToShop():
        _pushAuthenticated(const ShopRoute());
      case GoToFriends():
        _pushAuthenticated(const FriendsRoute());
    }
  }

  void _pushAuthenticated(PageRouteInfo route) {
    final shellRouter = _appRouter.innerRouterOf<StackRouter>(
      AuthenticatedShellRoute.name,
    );
    if (shellRouter != null) {
      unawaited(shellRouter.push(route));
    } else {
      unawaited(_appRouter.push(AuthenticatedShellRoute(children: [route])));
    }
  }

  void _apply(StackTransition transition, List<PageRouteInfo> routes) {
    switch (transition) {
      case StackTransition.push:
        unawaited(_appRouter.push(routes.first));
      case StackTransition.replace:
        unawaited(_appRouter.replace(routes.first));
      case StackTransition.replaceAll:
        unawaited(_appRouter.replaceAll(routes));
      case StackTransition.popUntil:
        break;
    }
  }
}

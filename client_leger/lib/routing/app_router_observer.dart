import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../presentation/view_models/navigation_view_model.dart';

class AppRouterObserver extends AutoRouteObserver {
  AppRouterObserver({required this.navigationViewModel});

  final NavigationViewModel navigationViewModel;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _handleNavigation();
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _handleNavigation();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _handleNavigation();
  }

  void _handleNavigation() {
    navigationViewModel.startNavigation();
    navigationViewModel.stopNavigation();
  }
}

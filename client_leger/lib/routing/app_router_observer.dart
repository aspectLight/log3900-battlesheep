import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../presentation/widgets/loading_overlay/loading_overlay_view_model.dart';

class AppRouterObserver extends AutoRouteObserver {
  AppRouterObserver({required this.loadingOverlayViewModel});

  final LoadingOverlayViewModel loadingOverlayViewModel;

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
    loadingOverlayViewModel.startNavigation();
    loadingOverlayViewModel.stopNavigation();
  }
}

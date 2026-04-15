import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';

import '../../../routing/app_router.dart';

class ShellChromeBackHandler {
  VoidCallback? _onBack;

  void register(VoidCallback callback) => _onBack = callback;

  void clear() => _onBack = null;

  bool get hasCustom => _onBack != null;

  void invokeCustomOrGoHome(StackRouter shellRouter) {
    final cb = _onBack;
    if (cb != null) {
      cb();
      return;
    }
    unawaited(_popShellToMainMenu(shellRouter));
  }

  Future<void> _popShellToMainMenu(StackRouter shellRouter) async {
    while (shellRouter.canPop()) {
      final popped = await shellRouter.maybePop();
      if (!popped) break;
    }
    if (shellRouter.current.name != MainMenuRoute.name) {
      await shellRouter.replaceAll([const MainMenuRoute()]);
    }
  }
}

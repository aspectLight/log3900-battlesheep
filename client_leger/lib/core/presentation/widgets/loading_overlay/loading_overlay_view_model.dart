import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// Shorter than Angular (`LOADING_SCREEN_DELAY` 800ms): full-screen parallax overlay
/// is heavier on mobile; a long hold feels like stutter.
const Duration _loadingOverlayHideDelay = Duration(milliseconds: 380);

class LoadingOverlayViewModel {
  LoadingOverlayViewModel();

  final isNavigating = signal<bool>(false);

  Timer? _hideTimer;

  /// Overlay during route changes. Cancels pending hide when navigation stacks.
  void notifyRouteTransition() {
    _hideTimer?.cancel();
    isNavigating.value = true;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _hideTimer?.cancel();
      _hideTimer = Timer(_loadingOverlayHideDelay, () {
        isNavigating.value = false;
        _hideTimer = null;
      });
    });
  }
}

import 'dart:async';

import 'package:signals_flutter/signals_flutter.dart';

/// Mixin for scoped side effects that need to tear down [effect] callbacks and
/// [StreamSubscription]s when the DI scope is disposed. Use [trackEffect] and
/// [trackSubscription] in the constructor; register with `dispose: (sideEffect) => sideEffect.dispose()`.
mixin DisposableSideEffect {
  final List<void Function()> _effectCleanups = [];
  final List<StreamSubscription<dynamic>> _streamSubscriptions = [];

  void trackEffect(void Function() callback) {
    _effectCleanups.add(effect(callback));
  }

  void trackSubscription(StreamSubscription<dynamic> sub) {
    _streamSubscriptions.add(sub);
  }

  void dispose() {
    for (final c in _effectCleanups) {
      c();
    }
    for (final s in _streamSubscriptions) {
      unawaited(s.cancel());
    }
    _effectCleanups.clear();
    _streamSubscriptions.clear();
  }
}

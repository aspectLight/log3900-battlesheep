import 'dart:async';

import 'package:get_it/get_it.dart';

class ScopedProjectionSubscriptions {
  ScopedProjectionSubscriptions(this._subscriptions);

  final List<StreamSubscription<dynamic>> _subscriptions;

  void addAll(List<StreamSubscription<dynamic>> subscriptions) {
    _subscriptions.addAll(subscriptions);
  }

  Future<void> dispose() async {
    for (final sub in _subscriptions) {
      await sub.cancel();
    }
  }
}

void registerScopedProjectionSubscriptions(
  GetIt scope,
  List<StreamSubscription<dynamic>> subscriptions,
) {
  if (scope.isRegistered<ScopedProjectionSubscriptions>()) {
    scope.get<ScopedProjectionSubscriptions>().addAll(subscriptions);
    return;
  }

  scope.registerSingleton<ScopedProjectionSubscriptions>(
    ScopedProjectionSubscriptions(subscriptions),
    dispose: (value) => value.dispose(),
  );
}

import 'package:flutter/material.dart';

import 'notification_intent.dart';
import 'notification_intent_sink_impl.dart';

typedef NotificationWidgetBuilder<T extends NotificationIntent> =
    Widget Function(BuildContext context, T intent, VoidCallback onDismiss);

class NotificationWidgetRegistry {
  final _builders =
      <Type, Widget Function(BuildContext, NotificationEntry, VoidCallback)>{};

  void register<T extends NotificationIntent>(
    NotificationWidgetBuilder<T> builder,
  ) {
    _builders[T] = (context, entry, onDismiss) =>
        builder(context, entry.intent as T, onDismiss);
  }

  Widget build(
    BuildContext context,
    NotificationEntry entry,
    VoidCallback onDismiss,
  ) {
    final b = _builders[entry.intent.runtimeType];
    return b?.call(context, entry, onDismiss) ?? const SizedBox.shrink();
  }
}

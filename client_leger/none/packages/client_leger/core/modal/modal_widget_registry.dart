import 'package:flutter/material.dart';

import 'modal_entry.dart';
import 'modal_intent.dart';

typedef ModalWidgetBuilder<T extends ModalIntent> =
    Widget Function(BuildContext context, T intent, VoidCallback onClose);

class ModalWidgetRegistry {
  final _builders =
      <Type, Widget Function(BuildContext, ModalEntry, VoidCallback)>{};

  void register<T extends ModalIntent>(ModalWidgetBuilder<T> builder) {
    _builders[T] = (context, entry, onClose) =>
        builder(context, entry.intent as T, onClose);
  }

  Widget build(BuildContext context, ModalEntry entry, VoidCallback onClose) {
    final builder = _builders[entry.intent.runtimeType];
    return builder?.call(context, entry, onClose) ?? const SizedBox.shrink();
  }
}

import 'package:signals_flutter/signals_flutter.dart';

import 'modal_entry.dart';
import 'modal_intent.dart';
import 'modal_intent_sink.dart';

class ModalCoordinator implements ModalIntentSink {
  ModalCoordinator() : _current = signal<ModalEntry?>(null);

  final Signal<ModalEntry?> _current;

  Signal<ModalEntry?> get current => _current;

  static int _nextId = 0;

  @override
  void addIntent(ModalIntent intent) {
    final id = '${_nextId++}';
    _current.value = ModalEntry(id: id, intent: intent);
  }

  void remove(String id) {
    if (_current.value?.id == id) {
      _current.value = null;
    }
  }
}

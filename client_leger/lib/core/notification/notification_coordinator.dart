import 'package:signals_flutter/signals_flutter.dart';

import 'notification_intent.dart';
import 'notification_intent_sink.dart';
import 'notification_intent_sink_impl.dart';

class NotificationCoordinator implements NotificationIntentSink {
  static int _nextId = 0;

  final _entries = signal<List<NotificationEntry>>([]);

  Signal<List<NotificationEntry>> get entries => _entries;

  @override
  void addIntent(NotificationIntent intent) {
    final id = '${_nextId++}';
    _entries.value = [
      ..._entries.value,
      NotificationEntry(id: id, intent: intent),
    ];
  }

  void remove(String id) {
    _entries.value = _entries.value.where((e) => e.id != id).toList();
  }

  void clearAll() {
    _entries.value = [];
  }

  void clearScopeEntries() {
    _entries.value = _entries.value
        .where((e) => e.intent.persistOnExit)
        .toList();
  }
}

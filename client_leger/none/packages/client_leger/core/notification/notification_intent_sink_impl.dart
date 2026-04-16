import 'notification_intent.dart';
import 'notification_intent_sink.dart';

class NotificationEntry {
  final String id;
  final NotificationIntent intent;

  const NotificationEntry({required this.id, required this.intent});
}

class NotificationIntentSinkImpl implements NotificationIntentSink {
  NotificationIntentSinkImpl({void Function(NotificationEntry)? onAdd})
    : _onAdd = onAdd;

  final void Function(NotificationEntry)? _onAdd;
  int _nextId = 0;

  final List<NotificationEntry> entries = [];

  @override
  void addIntent(NotificationIntent intent) {
    final entry = NotificationEntry(id: '${_nextId++}', intent: intent);
    entries.add(entry);
    _onAdd?.call(entry);
  }
}

import 'notification_intent.dart';

abstract interface class NotificationIntentSink {
  void addIntent(NotificationIntent intent);
}

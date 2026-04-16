import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../../../core/notification/notification_intent.dart';
import '../../../../core/notification/notification_intent_sink.dart';
import '../../domain/models/shop_socket_models.dart';
import '../services/shop_socket.dart';

class ShopPurchaseFailedNotificationSideEffect with DisposableSideEffect {
  ShopPurchaseFailedNotificationSideEffect({
    required ShopSocket shopSocket,
    required NotificationIntentSink notificationIntentSink,
  }) : _notificationIntentSink = notificationIntentSink {
    trackSubscription(shopSocket.purchaseStream.listen(_onPurchase));
  }

  final NotificationIntentSink _notificationIntentSink;

  void _onPurchase(ShopPurchaseModel model) {
    final failure = model.failure;
    if (failure == null) {
      return;
    }
    _notificationIntentSink.addIntent(
      ShopPurchaseFailedNotificationIntent(failure),
    );
  }
}

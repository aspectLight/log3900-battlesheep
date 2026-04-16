import 'package:get_it/get_it.dart';

import '../../../../core/notification/notification_intent_sink.dart';
import '../../data/side_effects/shop_purchase_failed_notification_side_effect.dart';
import '../../data/services/shop_socket.dart';

void registerShopSideEffects(GetIt getIt) {
  getIt.registerLazySingleton<ShopPurchaseFailedNotificationSideEffect>(
    () => ShopPurchaseFailedNotificationSideEffect(
      shopSocket: getIt<ShopSocket>(),
      notificationIntentSink: getIt<NotificationIntentSink>(),
    ),
    dispose: (e) => e.dispose(),
  );
}

void bootstrapShopSideEffects(GetIt getIt) {
  getIt.get<ShopPurchaseFailedNotificationSideEffect>();
}

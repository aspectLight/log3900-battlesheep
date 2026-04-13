import 'package:flutter/material.dart';

import '../../../../../core/notification/notification_intent.dart';
import '../../../../../core/notification/notification_shell.dart';
import '../../../core/localisation/shop_localizations.dart';
import '../../../core/extensions/shop_purchase_error_ext.dart';

class ShopPurchaseFailedNotificationWidget extends StatelessWidget {
  final ShopPurchaseFailedNotificationIntent intent;
  final void Function() onDismiss;

  const ShopPurchaseFailedNotificationWidget({
    super.key,
    required this.intent,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = ShopLocalizations.of(context)!;

    return GestureDetector(
      onTap: onDismiss,
      child: NotificationShell(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.shopPurchaseFailedTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'CustomFont',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              intent.failure.errorType.localize(l10n),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'CustomFont',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

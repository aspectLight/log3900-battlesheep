import 'package:flutter/material.dart';

import '../../../../../core/notification/notification_intent.dart';
import '../../../core/extensions/shop_purchase_error_ext.dart';
import '../../../core/localisation/shop_localizations.dart';

class ShopPurchaseFailedNotificationWidget extends StatelessWidget {
  const ShopPurchaseFailedNotificationWidget({
    super.key,
    required this.intent,
    required this.onDismiss,
  });

  final ShopPurchaseFailedNotificationIntent intent;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final l10n = ShopLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final titleStyle = TextStyle(
      color: scheme.primary,
      fontSize: 22,
      fontWeight: FontWeight.bold,
      fontFamily: 'CustomFont',
      letterSpacing: 0.5,
      decoration: TextDecoration.none,
    );
    const descriptionStyle = TextStyle(
      color: Color(0xFF333333),
      fontSize: 16,
      fontFamily: 'CustomFont',
      height: 1.5,
      decoration: TextDecoration.none,
    );
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 30,
                  offset: Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.shopPurchaseFailedTitle,
                  textAlign: TextAlign.center,
                  style: titleStyle,
                ),
                const SizedBox(height: 16),
                Text(
                  intent.failure.errorType.localize(l10n),
                  textAlign: TextAlign.center,
                  style: descriptionStyle,
                ),
                const SizedBox(height: 24),
                _ShopPurchaseFailedActionButton(
                  label: MaterialLocalizations.of(context).okButtonLabel,
                  onTap: onDismiss,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ShopPurchaseFailedActionButton extends StatelessWidget {
  const _ShopPurchaseFailedActionButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF550000),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF7F1F1F)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33550000),
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFFFFF0F0),
              fontWeight: FontWeight.w500,
              fontSize: 15,
              letterSpacing: 0.5,
              fontFamily: 'CustomFont',
            ),
          ),
        ),
      ),
    );
  }
}

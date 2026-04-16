import 'package:flutter/material.dart';

import '../../../../../core/appearance/app_feature_colors.dart';
import '../../../../../core/localisation/core_localizations.dart';
import '../../../../../core/notification/notification_intent.dart';
import '../../../core/localisation/waiting_room_localizations.dart';
import 'waiting_room_confirm_kick_notification_view_model.dart';

class WaitingRoomConfirmKickNotificationWidget extends StatelessWidget {
  WaitingRoomConfirmKickNotificationWidget({
    super.key,
    required WaitingRoomConfirmKickNotificationIntent intent,
    required VoidCallback onDismiss,
  }) : _viewModel = WaitingRoomConfirmKickNotificationViewModel(
         intent: intent,
         onDismiss: onDismiss,
       );

  final WaitingRoomConfirmKickNotificationViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    final coreL10n = CoreLocalizations.of(context)!;
    final l10n = WaitingRoomLocalizations.of(context)!;
    return _ConfirmationShell(
      message: l10n.confirmKickPlayer,
      confirmLabel: coreL10n.yes,
      cancelLabel: coreL10n.no,
      onConfirm: _viewModel.handleConfirm,
      onCancel: _viewModel.handleCancel,
    );
  }
}

class _ConfirmationShell extends StatelessWidget {
  const _ConfirmationShell({
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.onConfirm,
    required this.onCancel,
  });

  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
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
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.featureColors.bgButton,
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    letterSpacing: 0.5,
                    fontFamily: 'CustomFont',
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ActionButton(label: confirmLabel, onTap: onConfirm),
                    _ActionButton(label: cancelLabel, onTap: onCancel),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final f = context.featureColors;
    return Material(
      color: f.bgButton,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: f.borderButton),
            boxShadow: [
              BoxShadow(
                color: f.shadowAccent,
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: f.textSpecialAlt,
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

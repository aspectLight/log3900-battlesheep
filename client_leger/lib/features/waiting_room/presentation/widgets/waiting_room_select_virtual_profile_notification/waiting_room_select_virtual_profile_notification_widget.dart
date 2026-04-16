import 'package:flutter/material.dart';

import '../../../../../core/appearance/app_feature_colors.dart';
import '../../../../../core/notification/notification_intent.dart';
import '../../../core/localisation/waiting_room_localizations.dart';
import 'waiting_room_select_virtual_profile_notification_view_model.dart';

class WaitingRoomSelectVirtualProfileNotificationWidget
    extends StatelessWidget {
  WaitingRoomSelectVirtualProfileNotificationWidget({
    super.key,
    required WaitingRoomSelectVirtualProfileNotificationIntent intent,
    required VoidCallback onDismiss,
  }) : _viewModel = WaitingRoomSelectVirtualProfileNotificationViewModel(
         intent: intent,
         onDismiss: onDismiss,
       );

  final WaitingRoomSelectVirtualProfileNotificationViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = WaitingRoomLocalizations.of(context)!;
    return _SelectionShell(
      message: l10n.selectVirtualProfile,
      firstLabel: l10n.aggressive,
      secondLabel: l10n.defensive,
      onFirstTap: _viewModel.handleAggressive,
      onSecondTap: _viewModel.handleDefensive,
    );
  }
}

class _SelectionShell extends StatelessWidget {
  const _SelectionShell({
    required this.message,
    required this.firstLabel,
    required this.secondLabel,
    required this.onFirstTap,
    required this.onSecondTap,
  });

  final String message;
  final String firstLabel;
  final String secondLabel;
  final VoidCallback onFirstTap;
  final VoidCallback onSecondTap;

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
                    _ActionButton(label: firstLabel, onTap: onFirstTap),
                    _ActionButton(label: secondLabel, onTap: onSecondTap),
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

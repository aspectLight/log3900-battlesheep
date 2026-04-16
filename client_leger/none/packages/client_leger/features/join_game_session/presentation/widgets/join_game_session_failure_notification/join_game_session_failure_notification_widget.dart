import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../../core/notification/notification_intent.dart';
import '../../../core/extensions/join_game_session_failure_ext.dart';
import '../../../core/localisation/join_game_session_localizations.dart';
import 'join_game_session_failure_notification_view_model.dart';

class JoinGameSessionFailureNotificationWidget extends StatefulWidget {
  const JoinGameSessionFailureNotificationWidget({
    super.key,
    required this.intent,
    required this.onDismiss,
  });

  final JoinGameSessionFailureNotificationIntent intent;
  final VoidCallback onDismiss;

  @override
  State<JoinGameSessionFailureNotificationWidget> createState() =>
      _JoinGameSessionFailureNotificationWidgetState();
}

class _JoinGameSessionFailureNotificationWidgetState
    extends State<JoinGameSessionFailureNotificationWidget> {
  late final JoinGameSessionFailureNotificationViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I.get<JoinGameSessionFailureNotificationViewModel>(
      param1: widget.intent,
      param2: widget.onDismiss,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = JoinGameSessionLocalizations.of(context)!;
    final message = _viewModel.failure.localize(l10n);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
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
                  style: const TextStyle(
                    color: Color(0xFF550000),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    decoration: TextDecoration.none,
                    decorationColor: Colors.transparent,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _GameButton(label: l10n.ok, onTap: _viewModel.dismiss),
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

class _GameButton extends StatelessWidget {
  const _GameButton({required this.label, required this.onTap});

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
            border: Border.all(color: const Color(0xFF7f1f1f)),
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
              color: Color(0xFFfff0f0),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

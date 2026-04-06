import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/appearance/app_interaction_colors.dart';
import '../../../core/localisation/join_game_session_localizations.dart';
import '../../../core/constants/join_game_session_input_limits.dart';
import 'join_by_code_panel_view_model.dart';

class JoinByCodePanel extends StatefulWidget {
  const JoinByCodePanel({super.key});

  @override
  State<JoinByCodePanel> createState() => _JoinByCodePanelState();
}

class _JoinByCodePanelState extends State<JoinByCodePanel> {
  late final JoinByCodePanelViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<JoinByCodePanelViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = JoinGameSessionLocalizations.of(context)!;
    const double maxFormWidth = 420;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: maxFormWidth),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.joinGameSubtitle,
            style: const TextStyle(
              color: Color(0xFFf5e6e6),
              fontFamily: 'CustomFont',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.joinGameDescription,
            style: const TextStyle(
              color: Color(0xFFc0c0c0),
              fontFamily: 'CustomFont',
              fontSize: 14,
              fontStyle: FontStyle.italic,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextField(
            keyboardType: TextInputType.number,
            maxLength: JoinGameSessionInputLimits.joinCodeMaxLength,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: '0000',
              hintStyle: const TextStyle(color: Color(0xFF888888)),
              counterText: '',
              filled: true,
              fillColor: const Color(0xFF2b2b2b),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(
                  color: Color(0xFF444444),
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(
                  color: Color(0xFF444444),
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: context.interactionColors.outline,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            style: const TextStyle(
              color: Color(0xFFf5e6e6),
              fontFamily: 'CustomFont',
              fontSize: 20,
              letterSpacing: 8,
            ),
            onChanged: _viewModel.onCodeChanged,
          ),
          const SizedBox(height: 20),
          Watch(
            (context) => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _viewModel.isJoining ? null : _onJoinTap,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    final scheme = Theme.of(context).colorScheme;
                    final strong = context.interactionColors.primaryStrong;
                    if (states.contains(WidgetState.disabled)) {
                      return const Color(0xFF3f3f3f);
                    }
                    if (states.contains(WidgetState.pressed)) {
                      return Color.lerp(scheme.primary, Colors.black, 0.22)!;
                    }
                    if (states.contains(WidgetState.hovered)) {
                      return strong;
                    }
                    return scheme.primary;
                  }),
                  foregroundColor: WidgetStateProperty.resolveWith((states) {
                    final onPrimary = Theme.of(context).colorScheme.onPrimary;
                    if (states.contains(WidgetState.hovered) ||
                        states.contains(WidgetState.pressed)) {
                      return Colors.white;
                    }
                    return onPrimary;
                  }),
                  shadowColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.45),
                  ),
                  elevation: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.pressed)) {
                      return 0;
                    }
                    if (states.contains(WidgetState.hovered)) {
                      return 8;
                    }
                    return 0;
                  }),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(
                        color: Color(0xFF7f1f1f),
                        width: 2,
                      ),
                    ),
                  ),
                  padding: const WidgetStatePropertyAll(
                    EdgeInsets.symmetric(vertical: 10, horizontal: 32),
                  ),
                ),
                child: _viewModel.isJoining
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFf5e6e6),
                        ),
                      )
                    : Text(
                        l10n.joinGameButton,
                        style: const TextStyle(
                          fontFamily: 'CustomFont',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onJoinTap() {
    unawaited(_viewModel.onJoinTap());
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/appearance/app_interaction_colors.dart';
import '../../../core/constants/join_game_session_input_limits.dart';
import '../../../core/localisation/join_game_session_localizations.dart';
import '../../../core/utils/join_game_session_scanner_availability.dart';
import '../join_qr_scanner/join_qr_scanner_dialog.dart';
import 'join_by_code_panel_view_model.dart';

class JoinByCodePanel extends StatefulWidget {
  const JoinByCodePanel({super.key});

  @override
  State<JoinByCodePanel> createState() => _JoinByCodePanelState();
}

class _JoinByCodePanelState extends State<JoinByCodePanel> {
  late final JoinByCodePanelViewModel _viewModel;
  late final TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<JoinByCodePanelViewModel>();
    _codeController = TextEditingController(text: _viewModel.code.value);
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
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
              color: Colors.white,
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
            controller: _codeController,
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
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'CustomFont',
              fontSize: 20,
              letterSpacing: 8,
            ),
            onChanged: _viewModel.onCodeChanged,
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _viewModel.isJoining ? null : _onScanQrTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: context.interactionColors.outline),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text(
                l10n.joinGameScanQrButton,
                style: const TextStyle(
                  fontFamily: 'CustomFont',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
                    Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.45),
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
                      side: BorderSide(
                        color: context.interactionColors.outline,
                        width: 2,
                      ),
                    ),
                  ),
                  padding: const WidgetStatePropertyAll(
                    EdgeInsets.symmetric(vertical: 10, horizontal: 32),
                  ),
                ),
                child: _viewModel.isJoining
                    ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: context.interactionColors.primaryStrong,
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

  Future<void> _onScanQrTap() async {
    final JoinGameSessionLocalizations l10n =
        JoinGameSessionLocalizations.of(context)!;
    if (!JoinGameSessionScannerAvailability.isSupported) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.joinGameScanQrUnsupportedPlatform)),
      );
      return;
    }
    final String? scanned = await showDialog<String>(
      context: context,
      builder: (_) => const JoinQrScannerDialog(),
    );
    if (!mounted || scanned == null) {
      return;
    }
    _viewModel.applyDetectedRoomCode(scanned);
    _codeController.value = TextEditingValue(
      text: _viewModel.code.value,
      selection: TextSelection.collapsed(offset: _viewModel.code.value.length),
    );
    unawaited(_viewModel.onJoinTap());
  }
}

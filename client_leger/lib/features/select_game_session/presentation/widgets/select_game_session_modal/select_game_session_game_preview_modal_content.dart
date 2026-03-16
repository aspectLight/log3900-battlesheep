import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../core/localisation/select_game_session_localizations.dart';
import '../../../core/modal/select_game_session_modal_intents.dart';
import 'select_game_session_game_preview_modal_content_view_model.dart';

class SelectGameSessionGamePreviewModalContent extends StatefulWidget {
  const SelectGameSessionGamePreviewModalContent({
    super.key,
    required this.intent,
    required this.onClose,
  });

  final SelectGameSessionGamePreviewModalIntent intent;
  final VoidCallback onClose;

  @override
  State<SelectGameSessionGamePreviewModalContent> createState() =>
      _SelectGameSessionGamePreviewModalContentState();
}

class _SelectGameSessionGamePreviewModalContentState
    extends State<SelectGameSessionGamePreviewModalContent> {
  late final SelectGameSessionGamePreviewModalContentViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<SelectGameSessionGamePreviewModalContentViewModel>(
      param1: widget.intent,
      param2: widget.onClose,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = SelectGameSessionLocalizations.of(context)!;
    const descriptionStyle = TextStyle(
      color: Color(0xFF333333),
      fontSize: 16,
      fontFamily: 'CustomFont',
      height: 1.5,
      decoration: TextDecoration.none,
    );
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: _viewModel.close,
                    icon: const Icon(Icons.close),
                    color: const Color(0xFF666666),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
              if (_viewModel.intent.imagePath.isEmpty)
                Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF7F1F1F),
                        width: 2,
                      ),
                    ),
                  ),
                )
              else
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      _viewModel.intent.imagePath,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              if (_viewModel.intent.description.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F0E8),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE8E0D0)),
                  ),
                  child: Text(
                    _viewModel.intent.description,
                    style: descriptionStyle,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: _viewModel.close,
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF550000),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 12,
                    ),
                  ),
                  child: Text(l10n.ok),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

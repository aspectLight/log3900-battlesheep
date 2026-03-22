import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../core/localisation/select_game_session_localizations.dart';
import '../../../core/modal/select_game_session_modal_intents.dart';
import '../select_game_session/select_game_session_board_preview_widget.dart';
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
    final maxPreview =
        (MediaQuery.sizeOf(context).width - 80).clamp(200.0, 360.0);
    const panelBg = Color(0xFF2B2B2B);
    const headerBarBg = Color(0xFF3C3C3C);
    const accentBorder = Color(0xFF7F1F1F);
    const titleColor = Color(0xFFE0D8C0);
    const descriptionStyle = TextStyle(
      color: Color(0xFFf5e6e6),
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
          constraints: const BoxConstraints(maxWidth: 440),
          decoration: BoxDecoration(
            color: panelBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: accentBorder, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.45),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: const BoxDecoration(
                  color: headerBarBg,
                  border: Border(
                    bottom: BorderSide(color: Color(0xFF3A3A3A)),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.createGamePreviewHeader.toUpperCase(),
                        style: const TextStyle(
                          color: titleColor,
                          fontFamily: 'CustomFont',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _viewModel.close,
                      icon: const Icon(Icons.close),
                      color: titleColor,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(36, 36),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_viewModel.intent.boardSize > 0 &&
                        _viewModel.intent.boardMatrix.isNotEmpty)
                      Center(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: accentBorder),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: SizedBox.square(
                              dimension: maxPreview,
                              child: SelectGameSessionBoardPreviewWidget(
                                boardSize: _viewModel.intent.boardSize,
                                boardMatrix: _viewModel.intent.boardMatrix,
                              ),
                            ),
                          ),
                        ),
                      )
                    else if (_viewModel.intent.imagePath.isNotEmpty)
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(color: accentBorder),
                            ),
                            child: Image.asset(
                              _viewModel.intent.imagePath,
                              width: maxPreview,
                              height: maxPreview,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    else
                      const SizedBox.shrink(),
                    if (_viewModel.intent.description.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: headerBarBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF3A3A3A)),
                        ),
                        child: Text(
                          _viewModel.intent.description,
                          style: descriptionStyle,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Center(
                  child: ElevatedButton(
                    onPressed: _viewModel.close,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF550000),
                      foregroundColor: const Color(0xFFFFF0F0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: accentBorder),
                      ),
                      elevation: 4,
                      textStyle: const TextStyle(
                        fontFamily: 'CustomFont',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    child: Text(l10n.ok),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

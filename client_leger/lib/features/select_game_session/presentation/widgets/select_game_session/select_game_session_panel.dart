import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart' as fp;
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/constants/ui_assets.dart';
import '../../../../../core/extensions/game_mode_localized_extension.dart';
import '../../../../../core/modal/modal_intent_sink.dart';
import '../../../core/helpers/format_last_modified.dart';
import '../../../core/localisation/select_game_session_localizations.dart';
import '../../../core/modal/select_game_session_modal_intents.dart';
import '../../../domain/models/game_info_model.dart';
import '../../../domain/state/select_game_session_state.dart';
import 'select_game_session_panel_view_model.dart';
import 'select_game_session_board_preview_widget.dart';

class SelectGameSessionPanel extends StatefulWidget {
  const SelectGameSessionPanel({super.key});

  @override
  State<SelectGameSessionPanel> createState() => _SelectGameSessionPanelState();
}

class _SelectGameSessionPanelState extends State<SelectGameSessionPanel> {
  late final SelectGameSessionPanelViewModel _viewModel;
  late final TextEditingController _entryFeeController;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<SelectGameSessionPanelViewModel>();
    _entryFeeController = TextEditingController(
      text: '${_viewModel.entryFee.value}',
    );
    _entryFeeController.addListener(_onEntryFeeTextChanged);
    unawaited(_viewModel.load());
  }

  @override
  void dispose() {
    _entryFeeController.removeListener(_onEntryFeeTextChanged);
    _entryFeeController.dispose();
    super.dispose();
  }

  void _onEntryFeeTextChanged() {
    final raw = _entryFeeController.text.trim();
    if (raw.isEmpty) {
      _viewModel.setEntryFee(0);
      return;
    }
    final n = int.tryParse(raw);
    _viewModel.setEntryFee(n ?? 0);
  }

  void _bumpEntryFeeByStep(int delta) {
    final n = int.tryParse(_entryFeeController.text.trim()) ?? 0;
    final v = (n + delta).clamp(0, 999999999);
    _entryFeeController.text = '$v';
  }

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      return switch (_viewModel.state.value) {
        SelectGameSessionStateLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        SelectGameSessionStateLoaded(
          :final games,
          :final selectedGameId,
          :final isConfirming,
        ) =>
          _buildList(context, games, selectedGameId, isConfirming),
      };
    });
  }

  Widget _buildList(
    BuildContext context,
    List<GameModelInfo> games,
    fp.Option<String> selectedGameId,
    bool isConfirming,
  ) {
    final l10n = SelectGameSessionLocalizations.of(context)!;
    final bool hasSelection = selectedGameId.isSome();
    _viewModel.entryFee.value;
    final balance = _viewModel.coinBalance.value;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF3C3C3C),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              _headerCell(l10n.createGamePreviewHeader),
              _headerCell(l10n.createGameNameHeader),
              _headerCell(l10n.createGameSizeHeader),
              _headerCell(l10n.createGameModeHeader),
              _headerCell(l10n.createGameLastModifiedHeader),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(8),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
              return _GameListItem(
                game: game,
                selectedGameId: selectedGameId,
                viewModel: _viewModel,
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _entryFeeController,
                            enabled: hasSelection,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: TextStyle(
                              color: hasSelection
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.38),
                              fontFamily: 'CustomFont',
                            ),
                            decoration: InputDecoration(
                              labelText: l10n.createGameEntryFeeLabel,
                              hintText: l10n.createGameEntryFeeHint,
                              labelStyle: TextStyle(
                                color: hasSelection
                                    ? const Color(0xFFE0D8C0)
                                    : const Color(0xFFE0D8C0)
                                        .withValues(alpha: 0.38),
                              ),
                              hintStyle: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Color(0xFF5A5A5A)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Color(0xFF7F1F1F)),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.2),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (hasSelection) ...[
                          const SizedBox(width: 4),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 28,
                                ),
                                icon: const Icon(
                                  Icons.keyboard_arrow_up,
                                  color: Colors.white54,
                                ),
                                onPressed: () => _bumpEntryFeeByStep(10),
                              ),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 28,
                                ),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white54,
                                ),
                                onPressed: () => _bumpEntryFeeByStep(-10),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            l10n.createGameBalanceLabel,
                            style: const TextStyle(
                              color: Color(0xFFE0D8C0),
                              fontFamily: 'CustomFont',
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Image.asset(
                          UiAssets.goldCoin,
                          width: 22,
                          height: 22,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$balance',
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'CustomFont',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: (hasSelection && !isConfirming)
              ? () => unawaited(_viewModel.confirmSelectionSubmit())
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF550000),
            foregroundColor: const Color(0xFFFFF0F0),
            disabledBackgroundColor: const Color(0xFF333333),
            disabledForegroundColor: const Color(0xFF666666),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Color(0xFF7F1F1F)),
            ),
            elevation: 4,
            textStyle: const TextStyle(
              fontFamily: 'CustomFont',
              fontWeight: FontWeight.w500,
            ),
          ),
          child: Text(l10n.createGame),
        ),
      ],
    );
  }

  Widget _headerCell(String text) => Expanded(
    child: Center(
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFFE0D8C0),
          fontWeight: FontWeight.bold,
          fontFamily: 'CustomFont',
        ),
      ),
    ),
  );
}

class _GameListItem extends StatelessWidget {
  const _GameListItem({
    required this.game,
    required this.selectedGameId,
    required this.viewModel,
  });

  final GameModelInfo game;
  final fp.Option<String> selectedGameId;
  final SelectGameSessionPanelViewModel viewModel;

  Widget _cell(String text, {required bool isSelected}) => Expanded(
    child: Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: isSelected ? 20 : 18,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          fontFamily: 'CustomFont',
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedGameId.match(
      () => false,
      (value) => value == game.id,
    );
    final backgroundColor = isSelected
        ? const Color(0xFF550000)
        : const Color(0xFF2B2B2B);
    final borderColor = isSelected
        ? const Color(0xFF7F1F1F)
        : const Color(0xFF3A3A3A);

    return InkWell(
      onTap: () => viewModel.selectGame(game.id),
      child: Container(
        height: 116,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(
            left: BorderSide(color: borderColor),
            right: BorderSide(color: borderColor),
            bottom: BorderSide(color: borderColor),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => GetIt.I<ModalIntentSink>().addIntent(
                    SelectGameSessionGamePreviewModalIntent(
                      description: game.description,
                      imagePath: '',
                      boardSize: game.boardSize,
                      boardMatrix: game.boardMatrix,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox.square(
                      dimension: 100,
                      child: SelectGameSessionBoardPreviewWidget(
                        boardSize: game.boardSize,
                        boardMatrix: game.boardMatrix,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _cell(game.name, isSelected: isSelected),
            _cell(game.boardSize.toString(), isSelected: isSelected),
            _cell(game.mode.toLocalizedLabel(context), isSelected: isSelected),
            _cell(
              Format.selectGameLastModified(game.lastModified),
              isSelected: isSelected,
            ),
          ],
        ),
      ),
    );
  }
}

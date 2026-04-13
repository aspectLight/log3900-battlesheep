import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/appearance/app_interaction_colors.dart';
import '../../../../../core/extensions/game_mode_localized_extension.dart';
import '../../../../../core/modal/modal_intent_sink.dart';
import '../../../core/helpers/format_last_modified.dart';
import '../../../core/localisation/select_game_session_localizations.dart';
import '../../../core/modal/select_game_session_modal_intents.dart';
import '../../../domain/models/game_info_model.dart';
import 'select_game_session_board_preview_widget.dart';
import 'select_game_session_panel_view_model.dart';

class SelectGameSessionPanel extends StatefulWidget {
  const SelectGameSessionPanel({super.key});

  @override
  State<SelectGameSessionPanel> createState() => _SelectGameSessionPanelState();
}

class _SelectGameSessionPanelState extends State<SelectGameSessionPanel> {
  late final SelectGameSessionPanelViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<SelectGameSessionPanelViewModel>();
    unawaited(_viewModel.load());
  }

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      return _viewModel.state.value.when(
        loaded: (games, isConfirming, isLoadingGames) => _buildList(
          context,
          games,
          isConfirming,
          isLoadingGames,
        ),
      );
    });
  }

  Widget _buildList(
    BuildContext context,
    List<GameModelInfo> games,
    bool isConfirming,
    bool isLoadingGames,
  ) {
    final l10n = SelectGameSessionLocalizations.of(context)!;
    final bool showFooter = !isLoadingGames && games.isNotEmpty;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildTableHeader(l10n)),
        if (isLoadingGames)
          SliverToBoxAdapter(
            child: SizedBox(
              height: 280,
              child: Center(
                child: Image.asset(
                  'assets/images/loading.gif',
                  height: 120,
                  fit: BoxFit.contain,
                  gaplessPlayback: true,
                ),
              ),
            ),
          )
        else if (games.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              child: Center(
                child: Text(
                  l10n.noGames,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFFFF0F0),
                    fontSize: 18,
                    fontFamily: 'CustomFont',
                  ),
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final game = games[index];
                  return _GameListItem(
                    key: ValueKey(game.id),
                    game: game,
                    viewModel: _viewModel,
                  );
                },
                childCount: games.length,
              ),
            ),
          ),
        if (showFooter)
          SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                Watch(
                  (context) => GestureDetector(
                    onTap: _viewModel.toggleFriendsOnly,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Checkbox(
                            value: _viewModel.friendsOnly.value,
                            onChanged: (_) => _viewModel.toggleFriendsOnly(),
                            fillColor: WidgetStateProperty.resolveWith(
                              (states) => states.contains(WidgetState.selected)
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.surface,
                            ),
                            side: BorderSide(
                              color: context.interactionColors.outline,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Amis seulement',
                          style: TextStyle(
                            color: Color(0xFFFFF0F0),
                            fontSize: 18,
                            fontFamily: 'CustomFont',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Watch(
                  (context) {
                    final hasSelection =
                        _viewModel.selectedGameId.value.isSome();
                    final confirming = _viewModel.state.value.isConfirming;
                    return ElevatedButton(
                      onPressed: (hasSelection && !confirming)
                          ? () => unawaited(_viewModel.confirmSelectionSubmit())
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        disabledBackgroundColor: const Color(0xFF333333),
                        disabledForegroundColor: const Color(0xFF666666),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 32,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: context.interactionColors.outline,
                          ),
                        ),
                        elevation: 4,
                        textStyle: const TextStyle(
                          fontFamily: 'CustomFont',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      child: Text(l10n.createGame),
                    );
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildTableHeader(SelectGameSessionLocalizations l10n) {
    return Container(
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
    super.key,
    required this.game,
    required this.viewModel,
  });

  final GameModelInfo game;
  final SelectGameSessionPanelViewModel viewModel;

  static const _textStyleBase = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontFamily: 'CustomFont',
  );

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final outline = context.interactionColors.outline;

    return InkWell(
      onTap: () => viewModel.selectGame(game.id),
      child: SizedBox(
        height: 116,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Watch((context) {
                    final isSelected = viewModel.selectedGameId.value.match(
                      () => false,
                      (id) => id == game.id,
                    );
                    final borderColor =
                        isSelected ? outline : const Color(0xFF3A3A3A);
                    return Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: isSelected ? scheme.primary : scheme.surface,
                          border: Border(
                            left: BorderSide(color: borderColor),
                            bottom: BorderSide(color: borderColor),
                          ),
                        ),
                      ),
                    );
                  }),
                  Center(
                    child: RepaintBoundary(
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
                            child: DeferredSelectGameSessionBoardPreview(
                              boardSize: game.boardSize,
                              boardMatrix: game.boardMatrix,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Watch((context) {
                final isSelected = viewModel.selectedGameId.value.match(
                  () => false,
                  (id) => id == game.id,
                );
                final borderColor =
                    isSelected ? outline : const Color(0xFF3A3A3A);
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: isSelected ? scheme.primary : scheme.surface,
                    border: Border(
                      right: BorderSide(color: borderColor),
                      bottom: BorderSide(color: borderColor),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              game.name,
                              textAlign: TextAlign.center,
                              style: _textStyleBase.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              game.boardSize.toString(),
                              textAlign: TextAlign.center,
                              style: _textStyleBase.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              game.mode.toLocalizedLabel(context),
                              textAlign: TextAlign.center,
                              style: _textStyleBase.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              Format.selectGameLastModified(game.lastModified),
                              textAlign: TextAlign.center,
                              style: _textStyleBase.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

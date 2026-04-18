import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/appearance/app_feature_colors.dart';
import '../../../../../core/app_transition/app_transition_bus.dart';
import '../../../../../core/constants/ui_assets.dart';
import '../../../../../core/modal/modal_intent_sink.dart';
import '../../../core/app_events/game_session_events.dart';
import '../../../core/context/game_session_scope_holder.dart';
import '../../../core/enums/player_leave_reason.dart';
import '../../../core/modal/game_info_modal_intent.dart';
import '../../../data/repositories/game_actions_repository.dart';
import '../../../data/repositories/game_metadata_repository.dart';
import '../../../domain/commands/game_action_commands.dart';
import '../../../domain/state/game_session_state.dart';
import '../../widgets/game_actions/game_actions_widget.dart';
import '../../widgets/game_board/game_board_widget.dart';
import '../../widgets/game_cell_detail/game_cell_detail_widget.dart';
import '../../widgets/game_combat/game_combat_widget.dart';
import '../../widgets/game_debug_mode_strip/game_debug_mode_strip.dart';
import '../../widgets/game_debug_mode_strip/game_debug_mode_strip_view_model.dart';
import '../../widgets/game_player_cards_hud/game_player_cards_hud_widget.dart';
import '../../widgets/game_player_hud/game_player_hud_widget.dart';
import '../../widgets/game_player_inventory/game_player_inventory_widget.dart';
import '../../widgets/game_timer/game_timer_widget.dart';
import 'game_screen_view_model.dart';

@RoutePage()
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  GameScreenViewModel? _viewModel;

  @override
  void initState() {
    super.initState();
    _resolveViewModel();
  }

  void _resolveViewModel() {
    if (_viewModel != null) return;
    final scope = GetIt.I<GameSessionScopeHolder>().scope;
    if (scope == null || !scope.isRegistered<GameScreenViewModel>()) return;
    _viewModel = scope.get<GameScreenViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    _resolveViewModel();
    final scope = GetIt.I<GameSessionScopeHolder>().scope;
    final viewModel = _viewModel;
    if (scope == null || viewModel == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final isCombatMode = viewModel.isCombatMode.watch(context);
    final padding = _clamp(16, MediaQuery.sizeOf(context).width * 0.02, 32);
    final appTransitionEventBus = GetIt.I<AppTransitionEventBus>();
    final actionsRepository = GetIt.I<GameActionsRepository>();
    final metadataRepository = scope.get<GameMetadataRepository>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          final meta = metadataRepository.state.value;
          if (meta is GameSessionActive) {
            actionsRepository.abandonGame(
              AbandonGameCommand(roomId: meta.roomId),
            );
          }
          appTransitionEventBus.fire(
            const GameSessionExitAppEvent.leaveRequested(
              PlayerLeaveReason.abandoned,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        body: Padding(
          padding: EdgeInsets.all(padding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 2, child: _LeftSide(isCombatMode: isCombatMode)),
              const SizedBox(width: 20),
              Expanded(
                flex: 4,
                child: _MiddleSection(isCombatMode: isCombatMode),
              ),
              const SizedBox(width: 20),
              const Expanded(flex: 2, child: _RightSide()),
            ],
          ),
        ),
      ),
    );
  }

  double _clamp(double min, double value, double max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }
}

class _LeftSide extends StatelessWidget {
  const _LeftSide({required this.isCombatMode});

  final bool isCombatMode;

  /// Matches `ItemCardWidget` max height when torch drop button is shown (196).
  static const double _inventoryRowHeight = 196;

  /// Square cell preview uses this fraction of column width (centered above actions).
  static const double _cellDetailSizeFactor = 0.86 * 0.8;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Stack(
        children: [
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, columnConstraints) {
                final combatActionsPanelHeight =
                    (columnConstraints.maxHeight * 0.22).clamp(220.0, 320.0);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 44),
                    if (!isCombatMode)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final side =
                              constraints.maxWidth * _cellDetailSizeFactor;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: SizedBox(
                                  width: side,
                                  height: side,
                                  child: const GameCellDetailWidget(),
                                ),
                              ),
                              const GameActionsWidget(),
                            ],
                          );
                        },
                      )
                    else
                      SizedBox(
                        height: combatActionsPanelHeight,
                        child: const Align(
                          alignment: Alignment.bottomCenter,
                          child: GameActionsWidget(),
                        ),
                      ),
                    const SizedBox(height: 8),
                    if (isCombatMode)
                      Expanded(
                        flex: 2,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final squareSize =
                                constraints.maxWidth < constraints.maxHeight
                                ? constraints.maxWidth
                                : constraints.maxHeight;
                            final size = squareSize;
                            return Center(
                              child: _BoardContainer(
                                size: size,
                                isCombatBlurred: true,
                                child: const GameBoardWidget(),
                              ),
                            );
                          },
                        ),
                      ),
                    const Expanded(flex: 8, child: GamePlayerHudWidget()),
                    const SizedBox(
                      height: _inventoryRowHeight,
                      child: Center(child: GamePlayerInventoryWidget()),
                    ),
                  ],
                );
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: _GameInfoGearButton(
                onTap: () => _showGameInfoModal(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showGameInfoModal(BuildContext context) {
    GetIt.I<ModalIntentSink>().addIntent(const GameInfoModalIntent());
  }
}

class _GameInfoGearButton extends StatelessWidget {
  const _GameInfoGearButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Image.asset(
          UiAssets.settingsGear,
          width: 28,
          height: 28,
          errorBuilder: (_, _, _) =>
              const Icon(Icons.settings, color: Color(0xFFCCC0C0), size: 28),
        ),
      ),
    );
  }
}

class _MiddleSection extends StatelessWidget {
  const _MiddleSection({required this.isCombatMode});

  final bool isCombatMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: _TimerDebugBarRow(showTimer: !isCombatMode),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final squareSize = constraints.maxWidth < constraints.maxHeight
                  ? constraints.maxWidth
                  : constraints.maxHeight;
              final size = squareSize;
              final child = isCombatMode
                  ? SizedBox(
                      width: size,
                      height: size,
                      child: const GameCombatWidget(),
                    )
                  : _BoardContainer(
                      size: size,
                      isCombatBlurred: false,
                      child: const GameBoardWidget(),
                    );
              return Align(
                alignment: isCombatMode
                    ? Alignment.center
                    : Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: isCombatMode ? 0 : 2),
                  child: child,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Turn countdown centered on the full middle column; with debug on, equal [Expanded]
/// space left and right of the timer so the label stays at true center while the strip
/// fills the right side.
class _TimerDebugBarRow extends StatelessWidget {
  const _TimerDebugBarRow({required this.showTimer});

  final bool showTimer;

  static const double _barHeight = 52;

  @override
  Widget build(BuildContext context) {
    final scope = GetIt.I<GameSessionScopeHolder>().scope;
    if (scope == null) return const SizedBox.shrink();
    final debugVm = scope.get<GameDebugModeStripViewModel>();
    final isDebug = debugVm.isDebugMode.watch(context);
    if (!showTimer && !isDebug) return const SizedBox.shrink();

    if (!showTimer && isDebug) {
      return const SizedBox(
        height: _barHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: GameDebugModeStrip()),
          ],
        ),
      );
    }

    if (showTimer && !isDebug) {
      return const SizedBox(
        height: _barHeight,
        child: Center(
          child: GameTimerWidget(layout: GameTimerLayout.bar),
        ),
      );
    }

    return const SizedBox(
      height: _barHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: SizedBox()),
          Center(
            child: GameTimerWidget(layout: GameTimerLayout.bar),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 14),
              child: GameDebugModeStrip(),
            ),
          ),
        ],
      ),
    );
  }
}

class _BoardContainer extends StatelessWidget {
  const _BoardContainer({
    required this.size,
    required this.isCombatBlurred,
    required this.child,
  });

  final double size;
  final bool isCombatBlurred;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.featureColors.panel,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
    if (isCombatBlurred) {
      content = ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: content,
        ),
      );
    }
    return content;
  }
}

class _RightSide extends StatelessWidget {
  const _RightSide();

  @override
  Widget build(BuildContext context) {
    final f = context.featureColors;
    return Container(
      decoration: BoxDecoration(
        color: f.gameFrameBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: f.gameFrameBorder, width: 4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Let the player cards list take all available
          // vertical space given by the right panel.
          Expanded(child: GamePlayerCardsHudWidget()),
        ],
      ),
    );
  }
}

import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

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
  late final GameScreenViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<GameScreenViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    final isCombatMode = _viewModel.isCombatMode.watch(context);
    final screenHeight = MediaQuery.sizeOf(context).height;
    final boardSize = (screenHeight * 0.8).clamp(0.0, double.infinity);
    final padding = _clamp(16, MediaQuery.sizeOf(context).width * 0.02, 32);
    final appTransitionEventBus = GetIt.I<AppTransitionEventBus>();
    final actionsRepository = GetIt.I<GameActionsRepository>();
    final scope = GetIt.I<GameSessionScopeHolder>().scope;
    if (scope == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
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
        backgroundColor: const Color(0xFF1A1A1A),
        body: Padding(
          padding: EdgeInsets.all(padding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _LeftSide(
                  isCombatMode: isCombatMode,
                  boardSize: boardSize,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 2,
                child: _MiddleSection(
                  isCombatMode: isCombatMode,
                  boardSize: boardSize,
                ),
              ),
              const SizedBox(width: 24),
              const Expanded(child: _RightSide()),
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
  const _LeftSide({required this.isCombatMode, required this.boardSize});

  final bool isCombatMode;
  final double boardSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 44),
              SizedBox(
                height: 320,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!isCombatMode)
                      const Expanded(child: GameCellDetailWidget()),
                    const GameActionsWidget(),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              if (isCombatMode)
                Expanded(
                  flex: 3,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final squareSize =
                          constraints.maxWidth < constraints.maxHeight
                          ? constraints.maxWidth
                          : constraints.maxHeight;
                      final size = squareSize < boardSize
                          ? squareSize
                          : boardSize;
                      return Center(
                        child: _BoardContainer(
                          size: size,
                          isCombatBlurred: true,
                          child: const GameBoardWidget(),
                        ),
                      );
                    },
                  ),
                )
              else
                const Expanded(
                  flex: 3,
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: GameCombatWidget(),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Expanded(
                flex: 2,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 220),
                  child: const GamePlayerHudWidget(),
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            child: _GameInfoGearButton(
              onTap: () => _showGameInfoModal(context),
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
  const _MiddleSection({required this.isCombatMode, required this.boardSize});

  final bool isCombatMode;
  final double boardSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!isCombatMode)
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: GameTimerWidget(),
          ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final squareSize = constraints.maxWidth < constraints.maxHeight
                  ? constraints.maxWidth
                  : constraints.maxHeight;
              final size = squareSize < boardSize ? squareSize : boardSize;
              return Center(
                child: isCombatMode
                    ? SizedBox(
                        width: size,
                        height: size,
                        child: const GameCombatWidget(),
                      )
                    : _BoardContainer(
                        size: size,
                        isCombatBlurred: false,
                        child: const GameBoardWidget(),
                      ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        if (!isCombatMode)
          SizedBox(
            // Reserve full card height but push the inventory
            // further DOWN so only a slimmer strip is visible.
            height: 200,
            child: Transform.translate(
              offset: const Offset(0, 130),
              child: const Align(
                alignment: Alignment.topCenter,
                child: GamePlayerInventoryWidget(),
              ),
            ),
          ),
      ],
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
      decoration: const BoxDecoration(
        color: Color(0xFF2B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(12)),
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
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A0E0E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF8B5E34), width: 4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Let the player cards list take all available
          // vertical space given by the right panel.
          Expanded(child: GamePlayerCardsHudWidget()),
          GameDebugModeStrip(),
        ],
      ),
    );
  }
}

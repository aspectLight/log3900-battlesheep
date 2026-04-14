import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/constants/stat_assets.dart';
import '../../../../../core/constants/ui_assets.dart';
import '../../../../../core/helpers/functional_programming.dart';
import '../../../core/constants/combat_ui_constants.dart';
import '../../../core/context/game_session_scope_holder.dart';
import '../../../core/enums/stat_type.dart';
import '../../../core/localisation/game_session_localizations.dart';
import '../../ui_models/widget_states/game_combat_ui_state.dart';
import 'game_combat_view_model.dart';

class GameCombatWidget extends StatefulWidget {
  const GameCombatWidget({super.key});

  @override
  State<GameCombatWidget> createState() => _GameCombatWidgetState();
}

class _GameCombatWidgetState extends State<GameCombatWidget> {
  late final GameCombatViewModel _viewModel;
  Timer? _notificationTimer;
  GameCombatNotificationUi? _currentNotification;
  EffectCleanup? _notificationEffectCleanup;
  GameSessionLocalizations? _l10n;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<GameSessionScopeHolder>().scope!
        .get<GameCombatViewModel>();
    _setupNotificationListener();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _l10n = GameSessionLocalizations.of(context);
  }

  void _setupNotificationListener() {
    _notificationEffectCleanup = effect(() {
      final model = _viewModel.combatUiModel.value;
      if (model is GameCombatActive &&
          (model.showResults || model.showFlightAttemptResult) &&
          _l10n == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _handleCombatStateChange(_viewModel.combatUiModel.value);
        });
        return;
      }
      _handleCombatStateChange(model);
    });
  }

  void _handleCombatStateChange(GameCombatUiState state) {
    if (state is! GameCombatActive) {
      _dismissNotification();
      return;
    }

    final l10n = _l10n;
    const duration = CombatUiConstants.feedbackDurationMs;
    GameCombatNotificationUi? notification;

    if (state.showFlightAttemptResult) {
      if (l10n == null) return;
      notification = GameCombatNotificationUi(
        title: l10n.combatFlightAttemptTitle,
        message: state.isFlightAttemptSuccess
            ? l10n.combatFlightAttemptSuccess
            : l10n.combatFlightAttemptFailure,
        isSuccess: state.isFlightAttemptSuccess,
      );
      _showNotification(notification, CombatUiConstants.notificationDurationMs);
      return;
    }

    if (state.showResults) {
      if (l10n == null) return;
      final results = state.combatResults;
      final isPlayerAttacking = results.isPlayerAttacking;
      final damage = (results.attackValue - results.defenseValue)
          .clamp(0, double.infinity)
          .toInt();
      if (state.isAttackSuccess) {
        notification = GameCombatNotificationUi(
          title: '-$damage',
          message: '',
          isSuccess: isPlayerAttacking,
        );
      } else {
        notification = GameCombatNotificationUi(
          title: isPlayerAttacking
              ? l10n.combatMissTitle
              : l10n.combatEvadedTitle,
          message: '',
          isSuccess: !isPlayerAttacking,
        );
      }
    }

    if (notification != null) {
      _showNotification(notification, duration);
    }
  }

  void _showNotification(
    GameCombatNotificationUi notification,
    int durationMs,
  ) {
    _dismissNotification();
    setState(() {
      _currentNotification = notification;
    });
    _notificationTimer = Timer(Duration(milliseconds: durationMs), () {
      if (mounted && _currentNotification == notification) {
        setState(() {
          _currentNotification = null;
        });
      }
    });
  }

  void _dismissNotification() {
    _notificationTimer?.cancel();
    _notificationTimer = null;
    if (mounted) {
      setState(() {
        _currentNotification = null;
      });
    }
  }

  @override
  void dispose() {
    _notificationEffectCleanup?.call();
    _notificationTimer?.cancel();
    _notificationTimer = null;
    _currentNotification = null;
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = _viewModel.combatUiModel.watch(context);
    final l10n = GameSessionLocalizations.of(context)!;
    _l10n = l10n;
    if (state is GameCombatActive &&
        (state.showResults || state.showFlightAttemptResult) &&
        _currentNotification == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _handleCombatStateChange(state);
      });
    }

    if (state is! GameCombatActive) {
      return const SizedBox.shrink();
    }

    final countdown = _viewModel.combatCountdown.watch(context);
    final countdownMessage = state.isCombatPlayerTurn
        ? l10n.combatYourTurn(countdown)
        : l10n.combatYourTurnIn(countdown);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            countdownMessage,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'CustomFont',
            ),
          ),
        ),
        Flexible(
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFF1A1A1A),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    spreadRadius: 2,
                    blurRadius: 15,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      UiAssets.cellDetailPlaceholder,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: ColoredBox(
                      color: Colors.black.withValues(alpha: 0.55),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: _CombatCenterLayout(
                      enemy: state.enemyInfo,
                      l10n: l10n,
                      showResults: state.showResults,
                      results: state.combatResults,
                      isPlayerTurn: state.isCombatPlayerTurn,
                    ),
                  ),
                  if (_currentNotification != null)
                    _NotificationOverlay(notification: _currentNotification!),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _CombatActionsView(
          isPlayerTurn: state.isCombatPlayerTurn,
          canAttack: state.canAttack,
          canFlee: state.canFlee,
          hasEnemyBarbedWire:
              state.hasEnemyBarbedWire && !state.isCombatInitiator,
          onAttack: _viewModel.attack,
          onFlee: _viewModel.flightAttempt,
          onFleeBlocked: () {
            _showNotification(
              GameCombatNotificationUi(
                title: l10n.combatBarbedWireTitle,
                message: l10n.combatBarbedWireBlockedMessage,
                isSuccess: false,
              ),
              CombatUiConstants.feedbackDurationMs,
            );
          },
          l10n: l10n,
        ),
        const SizedBox(height: 12),
        Text(
          l10n.combatFlightAttemptsLeft(
            _viewModel.flightAttemptsLeft.watch(context),
          ),
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontFamily: 'CustomFont',
          ),
        ),
      ],
    );
  }
}

class _CombatCenterLayout extends StatelessWidget {
  final GameCombatEnemyInfoUi enemy;
  final GameSessionLocalizations l10n;
  final bool showResults;
  final GameCombatResultsUi results;
  final bool isPlayerTurn;

  const _CombatCenterLayout({
    required this.enemy,
    required this.l10n,
    required this.showResults,
    required this.results,
    required this.isPlayerTurn,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final avatarHeight = height * 0.72;
        final avatarBottom = -(height * 0.02);
        final resultsBottom = height * 0.24;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: avatarBottom,
              child: _EnemyAvatarLarge(enemy: enemy, height: avatarHeight),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: _EnemyStatsCard(enemy: enemy, l10n: l10n),
            ),
            if (showResults)
              Positioned(
                left: 0,
                right: 0,
                bottom: resultsBottom,
                child: Center(
                  child: _CombatResultsBar(
                    results: results,
                    isPlayerAttacking: results.isPlayerAttacking,
                    l10n: l10n,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _CombatResultsBar extends StatelessWidget {
  final GameCombatResultsUi results;
  final bool isPlayerAttacking;
  final GameSessionLocalizations l10n;

  const _CombatResultsBar({
    required this.results,
    required this.isPlayerAttacking,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final playerValue = isPlayerAttacking
        ? results.attackValue
        : results.defenseValue;
    final enemyValue = isPlayerAttacking
        ? results.defenseValue
        : results.attackValue;
    final playerLabel = isPlayerAttacking
        ? l10n.combatYourAttack
        : l10n.combatYourDefense;
    final enemyLabel = isPlayerAttacking
        ? l10n.combatEnemyDefense
        : l10n.combatEnemyAttack;
    final playerWinning = isPlayerAttacking
        ? results.attackValue >= results.defenseValue
        : results.defenseValue >= results.attackValue;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF3A3A3A).withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Expanded(
              child: _ResultTile(
                label: playerLabel.toUpperCase(),
                value: playerValue,
                isWinning: playerWinning,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ResultTile(
                label: enemyLabel.toUpperCase(),
                value: enemyValue,
                isWinning: !playerWinning,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EnemyStatsCard extends StatelessWidget {
  final GameCombatEnemyInfoUi enemy;
  final GameSessionLocalizations l10n;

  const _EnemyStatsCard({required this.enemy, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final attack = enemy.stats[StatType.attack] ?? 0;
    final defense = enemy.stats[StatType.defense] ?? 0;
    final speed = enemy.stats[StatType.speed] ?? 0;
    final health = enemy.stats[StatType.health] ?? 0;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF111111).withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  enemy.name,
                  style: const TextStyle(
                    color: Color(0xFFB00020),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'CustomFont',
                  ),
                ),
                const SizedBox(height: 10),
                _EnemyStatRow(label: l10n.combatStatAttack, value: attack),
                const SizedBox(height: 6),
                _EnemyStatRow(label: l10n.combatStatDefense, value: defense),
                const SizedBox(height: 8),
                _EnemyStatRow(label: l10n.combatStatSpeed, value: speed),
                const SizedBox(height: 8),
                _EnemyStatRow(label: l10n.combatStatHealth, value: health),
                const SizedBox(height: 44),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 30,
              child: Container(
                height: 1,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: _DiceCorner(
                asset: StatAssets.diceD6,
                choice: enemy.d6DiceChoice,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: _DiceCorner(
                asset: StatAssets.diceD4,
                choice: enemy.d4DiceChoice,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EnemyStatRow extends StatelessWidget {
  final String label;
  final int value;

  const _EnemyStatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontFamily: 'CustomFont',
          ),
        ),
        Text(
          value.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'CustomFont',
          ),
        ),
      ],
    );
  }
}

class _DiceCorner extends StatelessWidget {
  final String asset;
  final StatType choice;

  const _DiceCorner({required this.asset, required this.choice});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(asset, width: 22, height: 22),
        const SizedBox(width: 6),
        Text(
          CombatUiConstants.diceChoiceLabels[choice] ?? '',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'CustomFont',
          ),
        ),
      ],
    );
  }
}

class _EnemyAvatarLarge extends StatelessWidget {
  final GameCombatEnemyInfoUi enemy;
  final double height;

  const _EnemyAvatarLarge({required this.enemy, required this.height});

  @override
  Widget build(BuildContext context) {
    return enemy.avatarPath.when(
      none: () => const SizedBox.shrink(),
      some: (path) => Image.asset(path, fit: BoxFit.contain, height: height),
    );
  }
}

class _ResultTile extends StatelessWidget {
  final String label;
  final int value;
  final bool isWinning;

  const _ResultTile({
    required this.label,
    required this.value,
    required this.isWinning,
  });

  @override
  Widget build(BuildContext context) {
    final color = isWinning ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2F2F2F).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              fontFamily: 'CustomFont',
              letterSpacing: 0.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            value.toString(),
            style: TextStyle(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'CustomFont',
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationOverlay extends StatelessWidget {
  final GameCombatNotificationUi notification;

  const _NotificationOverlay({required this.notification});

  static const Color _successColor = Color(0xFF7DFF7D);
  static const Color _errorColor = Color(0xFFFF7D7D);

  @override
  Widget build(BuildContext context) {
    final color = notification.isSuccess ? _successColor : _errorColor;
    return Positioned.fill(
      child: GestureDetector(
        onTap: notification.isWinLossNotification ? () {} : null,
        child: ColoredBox(
          color: Colors.transparent,
          child: Center(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    notification.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: color,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'CustomFont',
                      shadows: const [
                        Shadow(blurRadius: 6),
                        Shadow(blurRadius: 12),
                      ],
                    ),
                  ),
                  if (notification.message.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      notification.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: color,
                        fontSize: 24,
                        fontFamily: 'CustomFont',
                        shadows: const [
                          Shadow(blurRadius: 6),
                          Shadow(blurRadius: 12),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CombatActionsView extends StatelessWidget {
  final bool isPlayerTurn;
  final bool canAttack;
  final bool canFlee;
  final bool hasEnemyBarbedWire;
  final VoidCallback onAttack;
  final VoidCallback onFlee;
  final VoidCallback onFleeBlocked;
  final GameSessionLocalizations l10n;

  const _CombatActionsView({
    required this.isPlayerTurn,
    required this.canAttack,
    required this.canFlee,
    required this.hasEnemyBarbedWire,
    required this.onAttack,
    required this.onFlee,
    required this.onFleeBlocked,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final blocked = !isPlayerTurn;
    final fleeDisabled = blocked || hasEnemyBarbedWire || !canFlee;
    final attackDisabled = blocked || !canAttack;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: const Border(top: BorderSide(color: Color(0xFF444444))),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 18,
              offset: Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Expanded(
              child: _ActionButton(
                label: l10n.combatFlee,
                onTap: fleeDisabled
                    ? null
                    : (hasEnemyBarbedWire ? onFleeBlocked : onFlee),
                isDisabled: fleeDisabled,
                showBarbedWireOverlay: hasEnemyBarbedWire,
                showRightDivider: true,
              ),
            ),
            Expanded(
              child: _ActionButton(
                label: l10n.combatAttack,
                onTap: attackDisabled ? null : onAttack,
                isDisabled: attackDisabled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isDisabled;
  final bool showBarbedWireOverlay;
  final bool showRightDivider;

  const _ActionButton({
    required this.label,
    this.onTap,
    this.isDisabled = false,
    this.showBarbedWireOverlay = false,
    this.showRightDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF222222),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: isDisabled
                ? const Color(0xFF1A1A1A)
                : const Color(0xFF222222),
            border: showRightDivider
                ? const Border(right: BorderSide(color: Color(0xFF444444)))
                : null,
          ),
          child: Stack(
            children: [
              if (showBarbedWireOverlay)
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.25,
                    child: Image.asset(
                      'assets/images/game_board_items/barbedWire.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Center(
                child: Text(
                  label.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDisabled
                        ? const Color(0xFF666666)
                        : const Color(0xFFFFF0F0),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'CustomFont',
                    letterSpacing: 1.1,
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

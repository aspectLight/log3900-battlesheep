import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/constants/ui_assets.dart';
import '../../../../../core/enums/virtual_player_type.dart';
import '../../../../../core/helpers/functional_programming.dart';
import '../../../../../core/presentation/widgets/app_background/app_background.dart';
import '../../../core/context/waiting_room_scope_holder.dart';
import '../../../core/event_bus/waiting_room_event_bus.dart';
import '../../../core/exceptions/waiting_room_failure.dart';
import '../../../core/localisation/waiting_room_localizations.dart';
import '../../../domain/models/waiting_room_player_model.dart';
import '../../mappers/waiting_room_player_ui_mapper.dart';
import '../../styles/waiting_room_player_banner_shell.dart';
import '../../styles/waiting_room_player_banner_styles.dart';
import '../../ui_models/components/waiting_room_player_ui.dart';
import 'waiting_room_view_model.dart';

@RoutePage()
class WaitingRoomScreen extends StatefulWidget {
  const WaitingRoomScreen({super.key});

  @override
  State<WaitingRoomScreen> createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends State<WaitingRoomScreen> {
  late final WaitingRoomViewModel _viewModel;
  late final WaitingRoomEventBus _eventBus;
  final ScrollController _playersScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final scope = GetIt.I<WaitingRoomScopeHolder>().scope;
    assert(
      scope != null,
      'WaitingRoomScope must be initialized before navigating to WaitingRoomScreen',
    );
    _viewModel = scope!.get<WaitingRoomViewModel>();
    _eventBus = GetIt.I<WaitingRoomEventBus>();
    _eventBus.fire(const WaitingRoomWelcomeRequestedEvent());
  }

  @override
  void dispose() {
    _playersScrollController.dispose();
    super.dispose();
  }

  void _notifyFailure(WaitingRoomFailure failure) {
    if (failure is CharacterAlreadyReservedWaitingRoomFailure) {
      _eventBus.fire(WaitingRoomReserveFailedEvent(failure));
      return;
    }
    _eventBus.fire(WaitingRoomFailureNotificationRequestedEvent(failure));
  }

  void _requestLeaveConfirmation() {
    _eventBus.fire(
      WaitingRoomConfirmLeaveRequestedEvent(
        onConfirmAction: () {
          unawaited(_leaveRoomAndNotifyFailure());
        },
        onCancelAction: () {},
      ),
    );
  }

  void _requestToggleLockConfirmationIfNeeded() {
    if (_viewModel.room.value.isLocked) {
      _eventBus.fire(
        WaitingRoomConfirmUnlockRequestedEvent(
          onConfirmAction: () {
            unawaited(_toggleLockAndNotifyFailure());
          },
          onCancelAction: () {},
        ),
      );
      return;
    }
    unawaited(_toggleLockAndNotifyFailure());
  }

  void _requestKickConfirmation(WaitingRoomPlayerModel player) {
    _eventBus.fire(
      WaitingRoomConfirmKickRequestedEvent(
        onConfirmAction: () {
          unawaited(_kickPlayerAndNotifyFailure(player));
        },
        onCancelAction: () {},
      ),
    );
  }

  void _requestAddVirtualPlayerFlow() {
    if (_viewModel.room.value.isLocked) {
      _eventBus.fire(
        WaitingRoomRoomLockedNotificationRequestedEvent(onDismissAction: () {}),
      );
      return;
    }
    _eventBus.fire(
      WaitingRoomSelectVirtualProfileRequestedEvent(
        onAggressiveAction: () {
          unawaited(
            _addVirtualPlayerAndNotifyFailure(VirtualPlayerType.aggressive),
          );
        },
        onDefensiveAction: () {
          unawaited(
            _addVirtualPlayerAndNotifyFailure(VirtualPlayerType.defensive),
          );
        },
      ),
    );
  }

  void _requestStartGame() {
    unawaited(_startGameAndNotifyFailure());
  }

  Future<void> _leaveRoomAndNotifyFailure() async {
    final failure = await _viewModel.leaveRoom();
    failure.whenPresent(_notifyFailure);
  }

  Future<void> _toggleLockAndNotifyFailure() async {
    final failure = await _viewModel.toggleLock();
    failure.whenPresent(_notifyFailure);
  }

  Future<void> _kickPlayerAndNotifyFailure(
    WaitingRoomPlayerModel player,
  ) async {
    final failure = await _viewModel.kickPlayer(player);
    failure.whenPresent(_notifyFailure);
  }

  Future<void> _addVirtualPlayerAndNotifyFailure(
    VirtualPlayerType virtualType,
  ) async {
    final failure = await _viewModel.addVirtualPlayer(virtualType: virtualType);
    failure.whenPresent(_notifyFailure);
  }

  Future<void> _startGameAndNotifyFailure() async {
    final failure = await _viewModel.startGame();
    failure.whenPresent(_notifyFailure);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WaitingRoomLocalizations.of(context)!;
    return AppBackground(
      child: Column(
        children: [
          _buildHeader(context, l10n),
          Expanded(child: _buildBody(context, l10n)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WaitingRoomLocalizations l10n) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: _requestLeaveConfirmation,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      UiAssets.characterCreationBackArrowIcon,
                      width: 15,
                      height: 15,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n.back,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'CustomFont',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              l10n.waitingRoomTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
                fontFamily: 'CustomFont',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WaitingRoomLocalizations l10n) {
    return Watch((context) {
      final room = _viewModel.room.value;
      final isHost = _viewModel.isHost.value;
      final isLocked = room.isLocked;
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: _buildPlayersSection(
                room.players,
                room.hostId,
                isHost,
                l10n,
              ),
            ),
            const SizedBox(height: 20),
            _buildGameCode(room.roomId, l10n),
            const SizedBox(height: 20),
            if (isHost)
              _buildHostActions(
                context,
                l10n,
                isHost,
                isLocked,
                room.dropInDropOut,
                _viewModel.canAddVirtualPlayer.value,
                _viewModel.isAtMaxPlayers.value,
              )
            else
              _buildWaitingMessage(l10n),
            const SizedBox(height: 16),
          ],
        ),
      );
    });
  }

  Widget _buildPlayersSection(
    List<WaitingRoomPlayerModel> players,
    String hostId,
    bool isHost,
    WaitingRoomLocalizations l10n,
  ) {
    if (players.isEmpty) {
      return Center(
        child: Text(
          l10n.waitingRoomWaitingForPlayers,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 14,
            fontFamily: 'CustomFont',
          ),
        ),
      );
    }
    const double cardSpacing = 10;
    const double horizontalPadding = 20;

    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportWidth = constraints.maxWidth;
        final viewportHeight = constraints.maxHeight;
        final availableWidth =
            viewportWidth - (horizontalPadding * 2) - (cardSpacing * (players.length - 1));
        final computedCardWidth = availableWidth / players.length;
        final cardWidth = computedCardWidth > 320 ? 320.0 : computedCardWidth;
        final shouldScroll = cardWidth < 170;

        Widget buildCard(int index) {
          final player = players[index];
          final playerUi = toWaitingRoomPlayerUi(player);
          return SizedBox(
            width: cardWidth,
            child: _WaitingRoomPlayerCard(
              playerUi: playerUi,
              isHost: playerUi.id == hostId,
              l10n: l10n,
              showKickButton: isHost && playerUi.id != hostId,
              onKickPressed: () => _requestKickConfirmation(player),
            ),
          );
        }

        if (shouldScroll) {
          return SizedBox(
            width: viewportWidth,
            height: viewportHeight,
            child: Scrollbar(
              controller: _playersScrollController,
              thumbVisibility: true,
              child: ListView.separated(
                controller: _playersScrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 10,
                ),
                itemCount: players.length,
                separatorBuilder: (_, _) => const SizedBox(width: cardSpacing),
                itemBuilder: (context, index) => buildCard(index),
              ),
            ),
          );
        }

        return SizedBox(
          width: viewportWidth,
          height: viewportHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 10,
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < players.length; i++) ...[
                    if (i > 0) const SizedBox(width: cardSpacing),
                    buildCard(i),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGameCode(String code, WaitingRoomLocalizations l10n) {
    return Column(
      children: [
        Text(
          l10n.waitingRoomGameCode,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontFamily: 'CustomFont',
          ),
        ),
        Text(
          code,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
            letterSpacing: 6,
            fontFamily: 'CustomFont',
          ),
        ),
      ],
    );
  }

  Widget _buildHostActions(
    BuildContext context,
    WaitingRoomLocalizations l10n,
    bool isHost,
    bool isLocked,
    bool isDropInDropOutEnabled,
    bool canAddVirtualPlayer,
    bool isAtMaxPlayers,
  ) {
    final canToggleLock = isHost && (!isLocked || !isAtMaxPlayers);
    return Wrap(
      spacing: 12,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        _buildMenuButton(
          label: isLocked
              ? l10n.waitingRoomUnlockRoom
              : l10n.waitingRoomLockRoom,
          onPressed: canToggleLock ? _requestToggleLockConfirmationIfNeeded : null,
        ),
        _buildDropInToggle(
          enabled: isDropInDropOutEnabled,
          onChanged: (_) => _viewModel.toggleDropInDropOut(),
          label: l10n.waitingRoomDropInDropOut,
        ),
        _buildMenuButton(
          label: l10n.startGame,
          onPressed: _viewModel.isStartValid.value ? _requestStartGame : null,
        ),
        _buildMenuButton(
          label: l10n.waitingRoomAddVirtualPlayer,
          onPressed: (isHost && !isLocked && canAddVirtualPlayer)
              ? _requestAddVirtualPlayerFlow
              : null,
        ),
      ],
    );
  }

  Widget _buildMenuButton({
    required String label,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: 250,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 85, 0, 0),
          disabledBackgroundColor: const Color.fromARGB(255, 52, 10, 10),
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.grey,
          shadowColor: Colors.transparent,
          elevation: 0,
          side: const BorderSide(color: Color.fromARGB(255, 127, 31, 31)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(fontSize: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          label,
          style: const TextStyle(fontFamily: 'CustomFont', fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildDropInToggle({
    required bool enabled,
    required ValueChanged<bool> onChanged,
    required String label,
  }) {
    return Container(
      width: 250,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF550000),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF7f1f1f)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: Checkbox(
              value: enabled,
              onChanged: (value) => onChanged(value ?? false),
              activeColor: const Color(0xFF7f1f1f),
              checkColor: const Color(0xFFfff0f0),
              side: const BorderSide(color: Color(0xFFfff0f0)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFFfff0f0),
                fontFamily: 'CustomFont',
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaitingMessage(WaitingRoomLocalizations l10n) {
    return Text(
      l10n.waitingRoomWaitingForHost,
      style: const TextStyle(
        color: Colors.white54,
        fontSize: 14,
        fontStyle: FontStyle.italic,
        fontFamily: 'CustomFont',
      ),
    );
  }
}

class _WaitingRoomPlayerCard extends StatelessWidget {
  const _WaitingRoomPlayerCard({
    required this.playerUi,
    required this.isHost,
    required this.l10n,
    required this.showKickButton,
    required this.onKickPressed,
  });

  final WaitingRoomPlayerUi playerUi;
  final bool isHost;
  final WaitingRoomLocalizations l10n;
  final bool showKickButton;
  final VoidCallback onKickPressed;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 350),
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: WaitingRoomPlayerBannerShell(
        activeBanner: playerUi.activeBanner,
        builder: (context, theme, borderPhase, _, overlayPhase) {
          return ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: theme == null
                ? DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.28),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: _WaitingRoomPlayerCardInnerStack(
                      playerUi: playerUi,
                      l10n: l10n,
                      isHost: isHost,
                      showKickButton: showKickButton,
                      onKickPressed: onKickPressed,
                      theme: null,
                      borderPhase: borderPhase,
                      overlayPhase: overlayPhase,
                    ),
                  )
                : _WaitingRoomPlayerCardInnerStack(
                    playerUi: playerUi,
                    l10n: l10n,
                    isHost: isHost,
                    showKickButton: showKickButton,
                    onKickPressed: onKickPressed,
                    theme: theme,
                    borderPhase: borderPhase,
                    overlayPhase: overlayPhase,
                  ),
          );
        },
      ),
    );
  }
}

class _WaitingRoomPlayerCardInnerStack extends StatelessWidget {
  const _WaitingRoomPlayerCardInnerStack({
    required this.playerUi,
    required this.l10n,
    required this.isHost,
    required this.showKickButton,
    required this.onKickPressed,
    required this.theme,
    required this.borderPhase,
    required this.overlayPhase,
  });

  final WaitingRoomPlayerUi playerUi;
  final WaitingRoomLocalizations l10n;
  final bool isHost;
  final bool showKickButton;
  final VoidCallback onKickPressed;
  final WaitingRoomBannerTheme? theme;
  final double borderPhase;
  final double overlayPhase;

  @override
  Widget build(BuildContext context) {
    final bannerTheme = theme;
    final nameColor = playerUi.isVirtual
        ? const Color(0xFF00BFFF)
        : (bannerTheme?.nameColor ?? Colors.white);
    final nameShadows =
        playerUi.isVirtual ? null : bannerTheme?.nameShadows;
    final statLabel = bannerTheme?.statLabelColor ?? Colors.white70;
    final statValue = bannerTheme?.statValueColor ?? Colors.white;

    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 210,
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 8, top: 8),
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                gradient: bannerTheme?.div1Gradient,
                color: bannerTheme == null
                    ? const Color.fromRGBO(0, 0, 0, 0.1)
                    : null,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
              ),
              child: Image.asset(
                playerUi.avatarFullPath,
                width: 170,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  UiAssets.characterCreationEmptyPortrait,
                  width: 170,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                gradient: bannerTheme?.div2Gradient,
                color: bannerTheme == null
                    ? const Color.fromRGBO(0, 0, 0, 0.7)
                    : null,
              ),
              child: Text(
                playerUi.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: nameColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'CustomFont',
                  shadows: nameShadows,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                gradient: bannerTheme?.statsGradient,
                color: bannerTheme == null
                    ? const Color.fromRGBO(0, 0, 0, 0.7)
                    : null,
              ),
              child: Row(
                children: [
                  _StatCell(
                    label: l10n.waitingRoomStatHealth,
                    value: '${playerUi.health}',
                    labelColor: statLabel,
                    valueColor: statValue,
                  ),
                  _StatCell(
                    label: l10n.waitingRoomStatSpeed,
                    value: '${playerUi.speed}',
                    labelColor: statLabel,
                    valueColor: statValue,
                  ),
                  _StatCell(
                    label: l10n.waitingRoomStatAttack,
                    value: '${playerUi.attack}',
                    labelColor: statLabel,
                    valueColor: statValue,
                  ),
                  _StatCell(
                    label: l10n.waitingRoomStatDefense,
                    value: '${playerUi.defense}',
                    labelColor: statLabel,
                    valueColor: statValue,
                    showRightBorder: false,
                  ),
                ],
              ),
            ),
          ],
        ),
        if (bannerTheme != null)
          waitingRoomBannerOverlayLayer(
            bannerTheme,
            borderPhase,
            overlayPhase,
          ),
        if (isHost)
          Positioned(
            left: 8,
            top: 10,
            child: Image.asset(
              UiAssets.crownBadge,
              width: 42,
              height: 42,
              errorBuilder: (_, _, _) =>
                  const SizedBox(width: 42, height: 42),
            ),
          ),
        if (playerUi.isVirtual)
          Positioned(
            left: 8,
            top: 10,
            child: Image.asset(
              UiAssets.robotBadge,
              width: 42,
              height: 42,
              errorBuilder: (_, _, _) =>
                  const SizedBox(width: 42, height: 42),
            ),
          ),
        if (showKickButton)
          Positioned(
            right: 6,
            top: 4,
            child: IconButton(
              onPressed: onKickPressed,
              icon: const Text(
                'X',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'CustomFont',
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.label,
    required this.value,
    this.labelColor = Colors.white70,
    this.valueColor = Colors.white,
    this.showRightBorder = true,
  });

  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;
  final bool showRightBorder;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          border: showRightBorder
              ? const Border(
                  right: BorderSide(color: Color.fromRGBO(30, 30, 30, 0.5)),
                )
              : null,
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: labelColor,
                fontSize: 12,
                fontFamily: 'CustomFont',
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontWeight: FontWeight.bold,
                fontFamily: 'CustomFont',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

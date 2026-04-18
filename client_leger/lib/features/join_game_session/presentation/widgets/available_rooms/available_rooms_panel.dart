import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/appearance/app_interaction_colors.dart';
import '../../../../../core/constants/ui_assets.dart';
import '../../../../select_game_session/presentation/widgets/select_game_session/select_game_session_board_preview_widget.dart';
import '../../../core/localisation/join_game_session_localizations.dart';
import '../../../domain/models/available_room_model.dart';
import 'available_rooms_panel_view_model.dart';

class AvailableRoomsPanel extends StatefulWidget {
  const AvailableRoomsPanel({super.key});

  @override
  State<AvailableRoomsPanel> createState() => _AvailableRoomsPanelState();
}

class _AvailableRoomsPanelState extends State<AvailableRoomsPanel> {
  late final AvailableRoomsPanelViewModel _viewModel;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<AvailableRoomsPanelViewModel>();
    unawaited(_viewModel.loadRooms(showLoading: true));
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => unawaited(_viewModel.loadRooms()),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = JoinGameSessionLocalizations.of(context)!;
    return Watch((context) {
      final rooms = _viewModel.rooms.value;
      final loading = _viewModel.isLoading.value;
      final showLoading = loading && rooms.isEmpty;
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.interactionColors.primaryStrong,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: context.interactionColors.outline),
        ),
        child: Column(
          children: [
            _buildHeader(l10n),
            if (showLoading)
              const Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(color: Color(0xFFf5e6e6)),
              )
            else if (rooms.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  l10n.joinGameNoRooms,
                  style: TextStyle(
                    color: context.interactionColors.text,
                    fontFamily: 'CustomFont',
                    fontSize: 16,
                  ),
                ),
              )
            else
              ...rooms.map((room) => _buildRow(context, room, l10n)),
          ],
        ),
      );
    });
  }

  Widget _buildHeader(JoinGameSessionLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: context.interactionColors.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          _headerCell(l10n.joinGameRoomListPreview),
          _headerCell(l10n.joinGameRoomListPlayers),
          _headerCell(l10n.joinGameRoomListSize),
          _headerCell(l10n.joinGameRoomListStatus),
          _headerCell(l10n.joinGameRoomListMode),
          _headerCell(l10n.joinGameRoomListAccessibility),
          _headerCell(l10n.joinGameRoomListCode),
          _headerCell(l10n.joinGameRoomListPrice),
        ],
      ),
    );
  }

  Widget _headerCell(String text) => Expanded(
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: context.interactionColors.text,
        fontFamily: 'CustomFont',
        fontSize: 16,
      ),
    ),
  );

  Widget _buildRow(
    BuildContext context,
    AvailableRoomModel room,
    JoinGameSessionLocalizations l10n,
  ) {
    final joinable = room.isJoinable;
    final statusLabel = room.isPlaying
        ? l10n.joinGameStatusPlaying
        : l10n.joinGameStatusWaiting;
    final accessibilityLabel = room.playerCount >= room.maxPlayers
        ? l10n.joinGameAccessibilityFull
        : (room.isPlaying && room.dropInDropOut
              ? l10n.joinGameModeDropIn
              : l10n.joinGameAccessibilityOpen);
    return InkWell(
      onTap: joinable ? () => unawaited(_viewModel.onRoomTap(room)) : null,
      child: Opacity(
        opacity: joinable ? 1 : 0.5,
        child: Container(
          height: 90,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xFF3a3a3a))),
          ),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: context.interactionColors.outline,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: room.boardSize > 0 && room.boardMatrix.isNotEmpty
                        ? SelectGameSessionBoardPreviewWidget(
                            boardSize: room.boardSize,
                            boardMatrix: room.boardMatrix,
                          )
                        : const ColoredBox(
                            color: Color(0xFFEDEDED),
                            child: Icon(
                              Icons.map_outlined,
                              color: Color(0xFF68718A),
                            ),
                          ),
                  ),
                ),
              ),
              _cell('${room.playerCount}/${room.maxPlayers}'),
              _cell('${room.boardSize}'),
              _cell(statusLabel),
              _cell(
                room.dropInDropOut ? l10n.joinGameModeDropIn : '-',
                color: room.dropInDropOut
                    ? const Color(0xFF4caf50)
                    : context.interactionColors.text,
              ),
              _cell(accessibilityLabel),
              _cell(room.fourDigitCode, letterSpacing: 2),
              _priceCell(room, l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cell(
    String value, {
    Color color = Colors.white,
    String fontFamily = 'CustomFont',
    double letterSpacing = 0,
  }) => Expanded(
    child: Text(
      value,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: color,
        fontFamily: fontFamily,
        fontSize: 18,
        letterSpacing: letterSpacing,
      ),
    ),
  );

  Widget _priceCell(
    AvailableRoomModel room,
    JoinGameSessionLocalizations l10n,
  ) {
    if (room.entryFee <= 0) {
      return _cell(l10n.joinGamePriceFree);
    }
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${room.entryFee}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFf5e6e6),
              fontFamily: 'CustomFont',
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 4),
          Image.asset(
            UiAssets.goldCoin,
            width: 14,
            height: 14,
            filterQuality: FilterQuality.none,
          ),
        ],
      ),
    );
  }
}

import 'package:fpdart/fpdart.dart' show Option;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../core/context/game_session_scope_holder.dart';
import '../../../../../core/constants/ui_assets.dart';
import '../../../core/definitions/item_definition.dart';
import '../../../core/definitions/tile_definition.dart';
import '../../../core/extensions/tile_type_ext.dart';
import '../../../core/localisation/game_session_localizations.dart';
import '../../ui_models/components/game_player_inventory_item_ui.dart';
import '../../ui_models/widget_states/game_cell_detail_ui_state.dart';
import '../item_card/item_card_widget.dart';
import 'game_cell_detail_view_model.dart';

class GameCellDetailWidget extends StatefulWidget {
  const GameCellDetailWidget({super.key});

  @override
  State<GameCellDetailWidget> createState() => _GameCellDetailWidgetState();
}

class _GameCellDetailWidgetState extends State<GameCellDetailWidget> {
  late final GameCellDetailWidgetViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<GameSessionScopeHolder>().scope!
        .get<GameCellDetailWidgetViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    final detail = _viewModel.cellDetail.watch(context);
    final l10n = GameSessionLocalizations.of(context)!;

    return _DetailLayout(
      placeholderPath: UiAssets.cellDetailPlaceholder,
      l10n: l10n,
      child: switch (detail) {
        GameCellDetailEmpty() => const SizedBox.shrink(),
        GameCellDetailPlayer(:final info) => _PlayerDetailView(
          info: info,
          l10n: l10n,
        ),
        GameCellDetailTile(:final info) => _TileDetailView(
          info: info,
          l10n: l10n,
        ),
        GameCellDetailItem(:final info) => _ItemDetailView(
          info: info,
          l10n: l10n,
        ),
      },
    );
  }
}

class _DetailLayout extends StatelessWidget {
  final Widget child;
  final String placeholderPath;
  final GameSessionLocalizations l10n;

  const _DetailLayout({
    required this.child,
    required this.placeholderPath,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(placeholderPath),
          fit: BoxFit.cover,
          alignment: Alignment.bottomCenter,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.2),
            BlendMode.darken,
          ),
        ),
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(child: child),
          ),
        ],
      ),
    );
  }
}

class _MagnifyingGlass extends StatelessWidget {
  final String imagePath;
  const _MagnifyingGlass({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 180,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Handle
          Positioned(
            top: 110,
            right: 25,
            child: Transform.rotate(
              angle: 0.785398, // 45 degrees
              child: Container(
                width: 12,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF333333),
                  border: Border.all(color: const Color(0xFF111111), width: 2),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          // Lens
          Container(
            width: 125,
            height: 125,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1A1A1A),
              border: Border.all(color: const Color(0xFF555555), width: 7),
              boxShadow: [
                const BoxShadow(color: Color(0xFF111111), spreadRadius: 2),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  offset: const Offset(0, 5),
                  blurRadius: 10,
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(imagePath, fit: BoxFit.cover),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.transparent,
                          Color.fromRGBO(0, 0, 0, 0.4),
                        ],
                        stops: [0.6, 1.0],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.white.withValues(alpha: 0.15),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: const Color(0xFF222222), // Match layout background
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF888888),
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontFamily: 'CustomFont',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TileDetailView extends StatelessWidget {
  final TileDefinition info;
  final GameSessionLocalizations l10n;
  const _TileDetailView({required this.info, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MagnifyingGlass(imagePath: info.imagePath),
          const SizedBox(width: 8),
          SizedBox(
            width: 120,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  info.type.getName(l10n).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'CustomFont',
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                if (info.baseMoveModifier >= 0) ...[
                  _SectionHeader(title: l10n.gameCellDetailCost),
                  Text(
                    info.baseMoveModifier == 0
                        ? '0'
                        : '+${info.baseMoveModifier}',
                    style: const TextStyle(
                      color: Color(0xFFBB0000),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'CustomFont',
                    ),
                  ),
                ],
                _SectionHeader(title: l10n.gameCellDetailDescription),
                Text(
                  info.type.getDescription(l10n),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFCCCCCC),
                    fontSize: 13,
                    height: 1.4,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayerDetailView extends StatelessWidget {
  final GameCellDetailPlayerInfo info;
  final GameSessionLocalizations l10n;
  const _PlayerDetailView({required this.info, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final imagePath = info.avatarFullPath.fold(
      () => info.avatarPath,
      Option.of,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          (info.isCurrentPlayer ? l10n.gameCellDetailYou : info.name)
              .toUpperCase(),
          style: TextStyle(
            color: info.isCurrentPlayer ? Colors.amber : Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'CustomFont',
          ),
        ),
        const SizedBox(height: 8),
        imagePath.fold(
          () => const Icon(Icons.person, size: 80, color: Colors.white24),
          (path) => SizedBox(
            height: 140,
            width: double.infinity,
            child: Image.asset(path, fit: BoxFit.contain),
          ),
        ),
      ],
    );
  }
}

class _ItemDetailView extends StatelessWidget {
  final ItemDefinition info;
  final GameSessionLocalizations l10n;
  const _ItemDetailView({required this.info, required this.l10n});

  @override
  Widget build(BuildContext context) {
    // Wrap ItemCardWidget in a centered container to match scale
    return Center(
      child: Transform.scale(
        scale: 1.2,
        child: ItemCardWidget(item: GamePlayerInventoryItemUi(type: info.type)),
      ),
    );
  }
}

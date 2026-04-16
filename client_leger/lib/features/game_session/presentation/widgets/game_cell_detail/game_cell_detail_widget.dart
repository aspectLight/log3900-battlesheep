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
            padding: const EdgeInsets.all(8),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: child,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MagnifyingGlass extends StatelessWidget {
  final String imagePath;
  final double height;

  const _MagnifyingGlass({
    required this.imagePath,
    this.height = 216,
  });

  static const double _baseHeight = 216;
  static const double _baseWidth = 180;

  @override
  Widget build(BuildContext context) {
    final scale = height / _baseHeight;
    final width = _baseWidth * scale;
    final lensSize = 150 * scale;
    final borderW = 8 * scale;
    final handleTop = 132 * scale;
    final handleRight = 30 * scale;
    final handleW = 14 * scale;
    final handleH = 60 * scale;
    final handleBorder = 2 * scale;
    final handleRadius = 4 * scale;
    final shadowBlur = 10 * scale;
    final shadowDy = 5 * scale;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            top: handleTop,
            right: handleRight,
            child: Transform.rotate(
              angle: 0.785398, // 45 degrees
              child: Container(
                width: handleW,
                height: handleH,
                decoration: BoxDecoration(
                  color: const Color(0xFF333333),
                  border: Border.all(
                    color: const Color(0xFF111111),
                    width: handleBorder,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(handleRadius),
                    bottomRight: Radius.circular(handleRadius),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: lensSize,
            height: lensSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1A1A1A),
              border: Border.all(color: const Color(0xFF555555), width: borderW),
              boxShadow: [
                const BoxShadow(color: Color(0xFF111111), spreadRadius: 2),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  offset: Offset(0, shadowDy),
                  blurRadius: shadowBlur,
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
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.white.withValues(alpha: 0.15),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            color: const Color(0xFF222222), // Match layout background
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF888888),
                fontSize: 12,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxH = constraints.maxHeight;
        final glassHeight = maxH.isFinite
            ? maxH.clamp(120.0, 560.0)
            : 216.0;
        return Row(
          children: [
            Flexible(
              flex: 3,
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: _MagnifyingGlass(
                    imagePath: info.imagePath,
                    height: glassHeight,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: LayoutBuilder(
                builder: (context, textConstraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: textConstraints.maxWidth,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          ),
                          const SizedBox(height: 10),
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
                              textAlign: TextAlign.center,
                            ),
                          ],
                          _SectionHeader(title: l10n.gameCellDetailDescription),
                          Text(
                            info.type.getDescription(l10n),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFFCCCCCC),
                              fontSize: 13,
                              height: 1.45,
                              fontFamily: 'CustomFont',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final iconSize = (constraints.maxHeight * 0.28).clamp(48.0, 88.0);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                (info.isCurrentPlayer ? l10n.gameCellDetailYou : info.name)
                    .toUpperCase(),
                style: TextStyle(
                  color: info.isCurrentPlayer ? Colors.amber : Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'CustomFont',
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: imagePath.fold(
                () => Center(
                  child: Icon(
                    Icons.person,
                    size: iconSize,
                    color: Colors.white24,
                  ),
                ),
                (path) => Image.asset(
                  path,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ItemDetailView extends StatelessWidget {
  final ItemDefinition info;
  final GameSessionLocalizations l10n;
  const _ItemDetailView({required this.info, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        child: ItemCardWidget(
          item: GamePlayerInventoryItemUi(type: info.type),
        ),
      ),
    );
  }
}

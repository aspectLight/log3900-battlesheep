import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/item_assets.dart';
import '../../../core/localisation/game_session_localizations.dart';

import '../../ui_models/components/game_player_inventory_item_ui.dart';

class ItemCardWidget extends StatelessWidget {
  final GamePlayerInventoryItemUi item;
  final double width;
  final double height;
  final VoidCallback? onTap;
  final bool showDropButton;
  final bool dropEnabled;
  final VoidCallback? onDropPressed;

  const ItemCardWidget({
    required this.item,
    this.width = 110,
    this.height = 160,
    this.onTap,
    this.showDropButton = false,
    this.dropEnabled = false,
    this.onDropPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = GameSessionLocalizations.of(context)!;
    final name = item.name(l10n);
    final description = item.description(l10n);
    final cornerLetter = name.isNotEmpty ? name[0].toUpperCase() : '?';

    // Without extra height + tighter layout, the middle Column overflows (~100px
    // tall): the Drop button sits in a clipped region and never receives taps.
    final cardHeight = showDropButton ? 196.0 : height;
    final insetV = showDropButton ? 18.0 : 30.0;
    final imageSize = showDropButton ? 52.0 : 80.0;

    Widget card = Container(
        width: width,
        height: cardHeight,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFEDEBE9), Color(0xFFD3CBC6)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x4D000000),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Positioned(top: -2, left: -2, child: _CornerRing()),
            const Positioned(top: -2, right: -2, child: _CornerRing()),
            const Positioned(bottom: -2, left: -2, child: _CornerRing()),
            const Positioned(bottom: -2, right: -2, child: _CornerRing()),
            Positioned(
              top: -2,
              left: -2,
              child: SizedBox(
                width: 30,
                height: 30,
                child: Center(
                  child: Text(cornerLetter, style: _cornerTextStyle),
                ),
              ),
            ),
            Positioned(
              bottom: -2,
              right: -2,
              child: SizedBox(
                width: 30,
                height: 30,
                child: Center(
                  child: Transform.rotate(
                    angle: 3.14159,
                    child: Text(cornerLetter, style: _cornerTextStyle),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 15,
              bottom: 15,
              left: 8,
              child: Container(width: 4, color: const Color(0x33990000)),
            ),
            Positioned(
              top: 15,
              bottom: 15,
              right: 8,
              child: Container(width: 4, color: const Color(0x33990000)),
            ),
            ..._buildDiamonds(cardHeight),
            const Positioned(
              top: 8,
              left: 25,
              right: 25,
              child: _BorderGradientLine(),
            ),
            const Positioned(
              bottom: 8,
              left: 25,
              right: 25,
              child: _BorderGradientLine(),
            ),
            Positioned(
              top: insetV,
              bottom: insetV,
              left: 16,
              right: 16,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize:
                    showDropButton ? MainAxisSize.min : MainAxisSize.max,
                children: [
                  SizedBox(
                    height: imageSize,
                    width: imageSize,
                    child: Image.asset(
                      ItemAssets.gameBoardItem(item.type),
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: showDropButton ? 4 : 8),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                      fontFamily: 'CustomFont',
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (showDropButton)
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                        fontFamily: 'CustomFont',
                      ),
                    )
                  else
                    Flexible(
                      child: Text(
                        description,
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                          fontFamily: 'CustomFont',
                        ),
                      ),
                    ),
                  if (showDropButton) ...[
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 28,
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: dropEnabled
                            ? () {
                                if (kDebugMode) {
                                  debugPrint(
                                    '[torch-drop] Drop button activated (item=${item.type})',
                                  );
                                }
                                onDropPressed?.call();
                              }
                            : null,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: const Size(0, 26),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          foregroundColor: const Color(0xFF5A1A1A),
                          side: const BorderSide(color: Color(0x995A1A1A)),
                          textStyle: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'CustomFont',
                          ),
                        ),
                        child: Text(l10n.dropTorchButton),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );

    if (onTap != null) {
      card = GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }

  TextStyle get _cornerTextStyle => const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Color(0xFF660000),
    decoration: TextDecoration.none,
    fontFamily: 'CustomFont',
  );

  List<Widget> _buildDiamonds(double cardHeight) {
    final third = (cardHeight * 0.55).clamp(90.0, cardHeight - 24.0);
    final positions = [36.0, 96.0, third];
    final widgets = <Widget>[];

    for (final top in positions) {
      widgets.add(_diamond(left: 6, top: top.toDouble()));
      widgets.add(_diamond(right: 6, top: top.toDouble()));
    }
    return widgets;
  }

  Widget _diamond({double? left, double? right, required double top}) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      child: Transform.rotate(
        angle: 0.785398,
        child: Container(width: 8, height: 8, color: const Color(0x99990000)),
      ),
    );
  }
}

class _CornerRing extends StatelessWidget {
  const _CornerRing();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0x99990000), width: 2),
      ),
    );
  }
}

class _BorderGradientLine extends StatelessWidget {
  const _BorderGradientLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Color(0x4D990000),
            Color(0x99990000),
            Color(0x4D990000),
            Colors.transparent,
          ],
          stops: [0.0, 0.2, 0.5, 0.8, 1.0],
        ),
      ),
    );
  }
}

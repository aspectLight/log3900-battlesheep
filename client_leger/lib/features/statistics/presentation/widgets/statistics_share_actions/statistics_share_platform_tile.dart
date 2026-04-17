import 'package:flutter/material.dart';

import '../../../../../core/appearance/app_feature_colors.dart';

Color statisticsShareInnerTileIdle(AppFeatureColors f) {
  final Color anchor = Color.lerp(f.panel, f.panelInset, 0.42)!;
  return Color.lerp(anchor, f.panelElevated, 0.55)!;
}

Color statisticsShareInnerTileHover(AppFeatureColors f) {
  return Color.lerp(statisticsShareInnerTileIdle(f), f.panelElevated, 0.42)!;
}

class StatisticsSharePlatformTile extends StatefulWidget {
  const StatisticsSharePlatformTile({
    super.key,
    required this.featureColors,
    this.compact = false,
    required this.onTap,
    required this.leading,
    required this.title,
    required this.hint,
  });

  final AppFeatureColors featureColors;
  final bool compact;
  final VoidCallback onTap;
  final Widget leading;
  final String title;
  final String hint;

  @override
  State<StatisticsSharePlatformTile> createState() =>
      _StatisticsSharePlatformTileState();
}

class _StatisticsSharePlatformTileState extends State<StatisticsSharePlatformTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final AppFeatureColors f = widget.featureColors;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final c = widget.compact;
    final tilePadding = c
        ? const EdgeInsets.symmetric(horizontal: 10, vertical: 9)
        : const EdgeInsets.symmetric(horizontal: 14, vertical: 12);
    final titleFont = c ? 13.0 : 15.0;
    final hintFont = c ? 9.5 : 11.0;
    final hintHeight = c ? 1.32 : 1.35;
    final leadingSlot = c ? 28.0 : 32.0;
    final gapAfterLeading = c ? 8.0 : 10.0;
    final gapBeforeHint = c ? 6.0 : 8.0;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: tilePadding,
            decoration: BoxDecoration(
              color: _hover
                  ? statisticsShareInnerTileHover(f)
                  : statisticsShareInnerTileIdle(f),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: f.borderHairline),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: leadingSlot,
                  child: Center(child: widget.leading),
                ),
                SizedBox(width: gapAfterLeading),
                Expanded(
                  flex: 5,
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: scheme.onSurface,
                      fontFamily: 'CustomFont',
                      fontSize: titleFont,
                      fontWeight: FontWeight.w600,
                      letterSpacing: c ? 0.35 : 0.5,
                    ),
                  ),
                ),
                SizedBox(width: gapBeforeHint),
                Expanded(
                  flex: 5,
                  child: Text(
                    widget.hint,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: f.textMuted,
                      fontFamily: 'CustomFont',
                      fontSize: hintFont,
                      fontWeight: FontWeight.w500,
                      height: hintHeight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/appearance/app_feature_colors.dart';
import '../../../core/localisation/statistics_localizations.dart';
import '../../../domain/models/post_game_share_snapshot.dart';
import 'statistics_share_actions_view_model.dart';
import 'statistics_share_platform_tile.dart';

class StatisticsShareActionsWidget extends StatelessWidget {
  const StatisticsShareActionsWidget({
    super.key,
    required this.viewModel,
    this.inRewardsRow = false,
  });

  final StatisticsShareActionsViewModel viewModel;
  final bool inRewardsRow;

  static const double _cardMaxWidth = 400;

  static const double cardWidthAlongsideRewards = 384;

  static const Color _blueskyBlue = Color(0xFF0085FF);

  String _composeShareText(
    StatisticsLocalizations l10n,
    PostGameShareSnapshot snapshot,
  ) {
    final String resultWord = snapshot.hasWon
        ? l10n.statisticsShareResultNounWin
        : l10n.statisticsShareResultNounLoss;
    return l10n.statisticsShareSocialBlurb(
      resultWord,
      snapshot.deaths,
      snapshot.combatWinPercent,
      snapshot.mapTraversalPercent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final StatisticsLocalizations l10n = StatisticsLocalizations.of(context)!;
    final AppFeatureColors f = context.featureColors;
    final Color goldBorder = f.goldAccent;
    final bool compact = inRewardsRow;
    return Watch((context) {
      final PostGameShareSnapshot? snapshot = viewModel.shareSnapshot.value;
      if (snapshot == null) {
        return const SizedBox.shrink();
      }
      final String shareText = _composeShareText(l10n, snapshot);
      final cardMaxW =
          compact ? cardWidthAlongsideRewards : _cardMaxWidth;
      final cardPadding = compact
          ? const EdgeInsets.symmetric(horizontal: 20, vertical: 16)
          : const EdgeInsets.symmetric(horizontal: 24, vertical: 20);
      final titleSize = compact ? 16.0 : 18.0;
      final titleLetterSpace = compact ? 1.1 : 1.5;
      final afterTitleGap = compact ? 12.0 : 16.0;
      final betweenTilesGap = compact ? 8.0 : 10.0;
      final Widget card = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: cardMaxW),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [f.panel, f.panelInset],
            ),
            border: Border.all(color: goldBorder, width: 2),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: goldBorder.withValues(alpha: 0.15),
                blurRadius: 20,
              ),
            ],
          ),
          padding: cardPadding,
          child: Column(
            mainAxisSize:
                compact ? MainAxisSize.max : MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.statisticsShareSectionTitle.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: goldBorder,
                  fontFamily: 'CustomFont',
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                  letterSpacing: titleLetterSpace,
                ),
              ),
              SizedBox(height: afterTitleGap),
              StatisticsSharePlatformTile(
                featureColors: f,
                compact: compact,
                onTap: () {
                  unawaited(viewModel.shareOnX(shareText));
                },
                leading: Text(
                  'X',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: compact ? 17 : 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -3,
                    height: 1,
                    fontFamily: 'CustomFont',
                  ),
                ),
                title: l10n.statisticsSharePublishX,
                hint: l10n.statisticsShareXHint,
              ),
              SizedBox(height: betweenTilesGap),
              StatisticsSharePlatformTile(
                featureColors: f,
                compact: compact,
                onTap: () {
                  unawaited(viewModel.shareOnBluesky(shareText));
                },
                leading: Icon(
                  Icons.edit_note_rounded,
                  color: _blueskyBlue,
                  size: compact ? 22 : 26,
                ),
                title: l10n.statisticsSharePublishBluesky,
                hint: l10n.statisticsShareBlueskyHint,
              ),
              if (compact) const Spacer(),
            ],
          ),
        ),
      );
      if (inRewardsRow) {
        return card;
      }
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: card,
        ),
      );
    });
  }
}

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/appearance/app_feature_colors.dart';
import '../../../../../core/constants/character_assets.dart';
import '../../../../../core/constants/ui_assets.dart';
import '../../../../../core/enums/character.dart';
import '../../../core/localisation/statistics_localizations.dart';
import '../../../../../core/enums/item_type.dart';
import '../../../domain/models/game_rewards_info.dart';
import '../../../core/enums/player_stats_sort_field.dart';
import '../../../domain/models/game_statistics.dart';
import 'statistics_content_view_model.dart';

class StatisticsContentWidget extends StatelessWidget {
  const StatisticsContentWidget({super.key, required this.viewModel});

  final StatisticsContentViewModel viewModel;

  /// Minimum width used when laying out the global summary row before scaling to fit.
  static const double _globalStatsRowDesignWidth = 520;

  String _formatPercentage(int part, int total) {
    if (total <= 0 || part <= 0) return '0';
    final double percentage = part / total * 100;
    if (percentage > 0 && percentage < 1) return '<1';
    return percentage.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = StatisticsLocalizations.of(context)!;

    return Watch((context) {
      final statistics = viewModel.statistics.value.data;
      final rewards = viewModel.rewardsRows.value;
      return LayoutBuilder(
        builder: (context, constraints) {
          const scrollPadding = 40.0;
          final rawWidth =
              constraints.maxWidth.isFinite && constraints.maxWidth > 0
              ? constraints.maxWidth
              : MediaQuery.sizeOf(context).width;
          // Only subtract scroll insets (40+40); do not shrink again or the table floats in empty space.
          final contentWidth = (rawWidth - 2 * scrollPadding).clamp(
            200.0,
            double.infinity,
          );
          return SingleChildScrollView(
            padding: const EdgeInsets.all(scrollPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildPlayerStatsTable(context, l10n, statistics, contentWidth),
                const SizedBox(height: 24),
                _buildGlobalStatsTable(context, l10n, statistics),
                if (rewards.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildRewardsSection(context, l10n, rewards),
                ],
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildPlayerStatsTable(
    BuildContext context,
    StatisticsLocalizations l10n,
    GameStatistics statistics,
    double tableWidth,
  ) {
    final sortedPlayers = viewModel.sortedPlayerStats.value;
    final sortField = viewModel.sortField.value;
    final isAscending = viewModel.isAscending.value;

    final f = context.featureColors;
    final headerBg = f.panelElevated;
    final dataBg = f.panel;
    final borderColor = f.borderHairline;
    final cellTextStyle = TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
      fontFamily: 'CustomFont',
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 1,
    );

    final headerDefs = <(String, PlayerStatsSortField)>[
      (l10n.statisticsPlayerName, PlayerStatsSortField.name),
      (l10n.statisticsCombats, PlayerStatsSortField.combats),
      (l10n.statisticsEvasions, PlayerStatsSortField.evasions),
      (l10n.statisticsVictories, PlayerStatsSortField.victories),
      (l10n.statisticsDefeats, PlayerStatsSortField.defeats),
      (l10n.statisticsHealthLost, PlayerStatsSortField.healthLost),
      (l10n.statisticsDamage, PlayerStatsSortField.damage),
      (l10n.statisticsItemsCollected, PlayerStatsSortField.itemsCollected),
      (l10n.statisticsTilesVisited, PlayerStatsSortField.tilesVisited),
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: dataBg,
        border: Border.all(color: borderColor),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 4),
            blurRadius: 6,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        child: SizedBox(
          width: tableWidth,
          child: Table(
            border: TableBorder.all(color: borderColor, width: 1),
            columnWidths: {
              for (var i = 0; i < headerDefs.length; i++)
                i: FlexColumnWidth(i == 0 ? 1.2 : 1),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                decoration: BoxDecoration(color: headerBg),
                children: [
                  for (final pair in headerDefs)
                    TableCell(
                      child: _PlayerStatsSortableHeader(
                        label: pair.$1,
                        field: pair.$2,
                        currentSort: sortField,
                        isAscending: isAscending,
                        onTap: () => viewModel.sortBy(pair.$2),
                      ),
                    ),
                ],
              ),
              for (final player in sortedPlayers)
                TableRow(
                  children: [
                    TableCell(
                      child: _PlayerStatsDataCell(
                        text: player.name,
                        style: cellTextStyle,
                        maxLines: 2,
                      ),
                    ),
                    TableCell(
                      child: _PlayerStatsDataCell(
                        text: '${player.combats}',
                        style: cellTextStyle,
                        maxLines: 1,
                      ),
                    ),
                    TableCell(
                      child: _PlayerStatsDataCell(
                        text: '${player.evasions}',
                        style: cellTextStyle,
                        maxLines: 1,
                      ),
                    ),
                    TableCell(
                      child: _PlayerStatsDataCell(
                        text: '${player.victories}',
                        style: cellTextStyle,
                        maxLines: 1,
                      ),
                    ),
                    TableCell(
                      child: _PlayerStatsDataCell(
                        text: '${player.defeats}',
                        style: cellTextStyle,
                        maxLines: 1,
                      ),
                    ),
                    TableCell(
                      child: _PlayerStatsDataCell(
                        text: '${player.healthLost}',
                        style: cellTextStyle,
                        maxLines: 1,
                      ),
                    ),
                    TableCell(
                      child: _PlayerStatsDataCell(
                        text: '${player.damage}',
                        style: cellTextStyle,
                        maxLines: 1,
                      ),
                    ),
                    TableCell(
                      child: _PlayerStatsDataCell(
                        text: '${player.itemsCollected.length}',
                        style: cellTextStyle,
                        maxLines: 1,
                      ),
                    ),
                    TableCell(
                      child: _PlayerStatsDataCell(
                        text:
                            '${_formatPercentage(player.tilesVisited.length, statistics.walkableTiles)}%',
                        style: cellTextStyle,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlobalStatsTable(
    BuildContext context,
    StatisticsLocalizations l10n,
    GameStatistics statistics,
  ) {
    final global = statistics.globalStats;
    final doorsPercentage = _formatPercentage(
      global.doorsToggled.length,
      statistics.toggableDoors,
    );
    final tilesPercentage = _formatPercentage(
      statistics.playerStats.expand((p) => p.tilesVisited).toSet().length,
      statistics.walkableTiles,
    );

    final playersWithFlag = statistics.playerStats.where(
      (p) => p.itemsCollected.any(
        (item) => item.toLowerCase() == ItemType.flag.name,
      ),
    );
    final flagCount = playersWithFlag.length;
    final isCTF = viewModel.isCTF;

    final f = context.featureColors;
    final headerStyle = TextStyle(
      color: f.textSpecial,
      fontFamily: 'CustomFont',
      fontSize: 12,
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
    );
    final cellStyle = TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
      fontFamily: 'CustomFont',
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 1,
    );

    final headerLabels = <String>[
      l10n.statisticsDuration,
      l10n.statisticsTurns,
      l10n.statisticsTilesExplored,
      l10n.statisticsDoorsToggled,
      if (isCTF) l10n.statisticsFlags,
    ];
    final values = <String>[
      global.gameDuration,
      '${global.turns}',
      '$tilesPercentage%',
      '$doorsPercentage%',
      if (isCTF) '$flagCount',
    ];
    final columnCount = headerLabels.length;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: f.panel,
        border: Border.all(color: f.borderHairline),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 4),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            color: f.panelElevated,
            child: LayoutBuilder(
              builder: (context, c) {
                return FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: math.max(c.maxWidth, _globalStatsRowDesignWidth),
                    child: Row(
                      children: List.generate(
                        columnCount,
                        (i) => Expanded(
                          child: Center(
                            child: Text(
                              headerLabels[i].toUpperCase(),
                              style: headerStyle,
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: f.panel,
              border: Border(top: BorderSide(color: f.borderHairline)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: LayoutBuilder(
                builder: (context, c) {
                  return FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: math.max(c.maxWidth, _globalStatsRowDesignWidth),
                      child: Row(
                        children: List.generate(
                          columnCount,
                          (i) => Expanded(
                            child: Center(
                              child: Text(
                                values[i],
                                style: cellStyle,
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Matches Angular `end-game.component` `.rewards-section` / `.reward-entry`.
  Widget _buildRewardsSection(
    BuildContext context,
    StatisticsLocalizations l10n,
    List<PlayerRewardInfo> rewards,
  ) {
    final f = context.featureColors;
    final goldBorder = f.goldAccent;
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
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
                  spreadRadius: 0,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.statisticsRewardsTitle.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: goldBorder,
                    fontFamily: 'CustomFont',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),
                for (var i = 0; i < rewards.length; i++) ...[
                  if (i > 0) const SizedBox(height: 10),
                  _StatisticsRewardEntry(
                    reward: rewards[i],
                    avatarPath: _avatarPathFor(rewards[i].avatarName),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _avatarPathFor(String avatarName) {
    if (avatarName.isEmpty) return null;
    final character = Character.fromAvatarName(avatarName);
    return CharacterAssets.characterAvatarPath(character);
  }
}

class _PlayerStatsSortableHeader extends StatelessWidget {
  const _PlayerStatsSortableHeader({
    required this.label,
    required this.field,
    required this.currentSort,
    required this.isAscending,
    required this.onTap,
  });

  final String label;
  final PlayerStatsSortField field;
  final PlayerStatsSortField currentSort;
  final bool isAscending;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final headerStyle = TextStyle(
      color: context.featureColors.textSpecial,
      fontFamily: 'CustomFont',
      fontSize: 12,
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
    );
    final active = currentSort == field;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: LayoutBuilder(
          builder: (context, c) {
            final maxW = c.maxWidth.isFinite && c.maxWidth > 0
                ? c.maxWidth
                : 120.0;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: SizedBox(
                  width: maxW,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label.toUpperCase(),
                        style: headerStyle,
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        softWrap: true,
                      ),
                      if (active)
                        Text(
                          isAscending ? '\u25B2' : '\u25BC',
                          style: headerStyle.copyWith(fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PlayerStatsDataCell extends StatelessWidget {
  const _PlayerStatsDataCell({
    required this.text,
    required this.style,
    required this.maxLines,
  });

  final String text;
  final TextStyle style;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      child: Center(
        child: Text(
          text,
          style: style,
          maxLines: maxLines,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

/// One row in the rewards list; mirrors Angular `.reward-entry` hover/background.
class _StatisticsRewardEntry extends StatefulWidget {
  const _StatisticsRewardEntry({
    required this.reward,
    required this.avatarPath,
  });

  final PlayerRewardInfo reward;
  final String? avatarPath;

  @override
  State<_StatisticsRewardEntry> createState() => _StatisticsRewardEntryState();
}

class _StatisticsRewardEntryState extends State<_StatisticsRewardEntry> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final reward = widget.reward;
    final avatarPath = widget.avatarPath;
    final f = context.featureColors;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.ease,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: _hover ? 0.1 : 0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  if (avatarPath != null) ...[
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: f.goldAccent),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        avatarPath,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.medium,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Text(
                      reward.playerName,
                      style: TextStyle(
                        color: f.textSpecial,
                        fontFamily: 'CustomFont',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '+${reward.coinsEarned}',
                  style: TextStyle(
                    color: f.goldAccent,
                    fontFamily: 'CustomFont',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Image.asset(
                    UiAssets.goldCoin,
                    width: 24,
                    height: 24,
                    filterQuality: FilterQuality.medium,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

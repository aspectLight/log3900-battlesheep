import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

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
          const horizontalPadding = 80.0;
          final rawWidth =
              constraints.maxWidth.isFinite && constraints.maxWidth > 0
              ? constraints.maxWidth
              : MediaQuery.sizeOf(context).width;
          final contentWidth = (rawWidth - horizontalPadding).clamp(
            200.0,
            double.infinity,
          );
          return SingleChildScrollView(
            padding: const EdgeInsets.all(40),
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
    double contentWidth,
  ) {
    final sortedPlayers = viewModel.sortedPlayerStats.value;
    final sortField = viewModel.sortField.value;
    final isAscending = viewModel.isAscending.value;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF2b2b2b),
        border: Border.all(color: const Color(0xFF3a3a3a)),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 4),
            blurRadius: 6,
          ),
        ],
      ),
      child: SizedBox(
        width: contentWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            DataTable(
              headingRowColor: WidgetStateProperty.all(const Color(0xFF3c3c3c)),
              dataRowColor: WidgetStateProperty.resolveWith(
                (states) => const Color(0xFF2b2b2b),
              ),
              columns: [
                _buildSortableColumn(
                  l10n.statisticsPlayerName,
                  PlayerStatsSortField.name,
                  sortField,
                  isAscending,
                ),
                _buildSortableColumn(
                  l10n.statisticsCombats,
                  PlayerStatsSortField.combats,
                  sortField,
                  isAscending,
                ),
                _buildSortableColumn(
                  l10n.statisticsEvasions,
                  PlayerStatsSortField.evasions,
                  sortField,
                  isAscending,
                ),
                _buildSortableColumn(
                  l10n.statisticsVictories,
                  PlayerStatsSortField.victories,
                  sortField,
                  isAscending,
                ),
                _buildSortableColumn(
                  l10n.statisticsDefeats,
                  PlayerStatsSortField.defeats,
                  sortField,
                  isAscending,
                ),
                _buildSortableColumn(
                  l10n.statisticsHealthLost,
                  PlayerStatsSortField.healthLost,
                  sortField,
                  isAscending,
                ),
                _buildSortableColumn(
                  l10n.statisticsDamage,
                  PlayerStatsSortField.damage,
                  sortField,
                  isAscending,
                ),
                _buildSortableColumn(
                  l10n.statisticsItemsCollected,
                  PlayerStatsSortField.itemsCollected,
                  sortField,
                  isAscending,
                ),
                _buildSortableColumn(
                  l10n.statisticsTilesVisited,
                  PlayerStatsSortField.tilesVisited,
                  sortField,
                  isAscending,
                ),
              ],
              rows: sortedPlayers.map((player) {
                final tilePercentage = _formatPercentage(
                  player.tilesVisited.length,
                  statistics.walkableTiles,
                );
                const cellTextStyle = TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontFamily: 'CustomFont',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                );
                return DataRow(
                  cells: [
                    DataCell(
                      _wrapCell(Text(player.name, style: cellTextStyle)),
                    ),
                    DataCell(
                      _wrapCell(
                        Text('${player.combats}', style: cellTextStyle),
                      ),
                    ),
                    DataCell(
                      _wrapCell(
                        Text('${player.evasions}', style: cellTextStyle),
                      ),
                    ),
                    DataCell(
                      _wrapCell(
                        Text('${player.victories}', style: cellTextStyle),
                      ),
                    ),
                    DataCell(
                      _wrapCell(
                        Text('${player.defeats}', style: cellTextStyle),
                      ),
                    ),
                    DataCell(
                      _wrapCell(
                        Text('${player.healthLost}', style: cellTextStyle),
                      ),
                    ),
                    DataCell(
                      _wrapCell(Text('${player.damage}', style: cellTextStyle)),
                    ),
                    DataCell(
                      _wrapCell(
                        Text(
                          '${player.itemsCollected.length}',
                          style: cellTextStyle,
                        ),
                      ),
                    ),
                    DataCell(
                      _wrapCell(Text('$tilePercentage%', style: cellTextStyle)),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
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

    const headerStyle = TextStyle(
      color: Color(0xFFe0d8c0),
      fontFamily: 'CustomFont',
      fontSize: 12,
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
    );
    const cellStyle = TextStyle(
      color: Color(0xFFFFFFFF),
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
        color: const Color(0xFF2b2b2b),
        border: Border.all(color: const Color(0xFF3a3a3a)),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 4),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            color: const Color(0xFF3c3c3c),
            child: Row(
              children: List.generate(
                columnCount,
                (i) => Expanded(
                  child: Center(
                    child: Text(
                      headerLabels[i].toUpperCase(),
                      style: headerStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
          DecoratedBox(
            decoration: const BoxDecoration(
              color: Color(0xFF2b2b2b),
              border: Border(top: BorderSide(color: Color(0xFF3a3a3a))),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: List.generate(
                  columnCount,
                  (i) => Expanded(
                    child: Center(
                      child: Text(
                        values[i],
                        style: cellStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _wrapCell(Widget child) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth.isFinite && constraints.maxWidth > 0
            ? constraints.maxWidth
            : 80.0;
        return SizedBox(width: w, child: child);
      },
    );
  }

  DataColumn _buildSortableColumn(
    String label,
    PlayerStatsSortField field,
    PlayerStatsSortField currentSort,
    bool isAscending,
  ) {
    return DataColumn(
      columnWidth: const FlexColumnWidth(),
      label: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth.isFinite && constraints.maxWidth > 0
              ? constraints.maxWidth
              : 120.0;
          return SizedBox(
            width: w,
            child: Text(
              label.toUpperCase(),
              style: const TextStyle(
                color: Color(0xFFe0d8c0),
                fontFamily: 'CustomFont',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
              softWrap: true,
            ),
          );
        },
      ),
      onSort: (columnIndex, ascending) {
        viewModel.sortBy(field);
      },
    );
  }

  Widget _buildRewardsSection(
    BuildContext context,
    StatisticsLocalizations l10n,
    List<PlayerRewardInfo> rewards,
  ) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFF2b2b2b),
            border: Border.all(color: const Color(0xFF3a3a3a)),
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                offset: Offset(0, 4),
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                child: Text(
                  l10n.statisticsRewardsTitle,
                  style: const TextStyle(
                    color: Color(0xFFe0d8c0),
                    fontFamily: 'CustomFont',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              ...List.generate(rewards.length, (index) {
                final reward = rewards[index];
                final avatarPath = _avatarPathFor(reward.avatarName);
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: index == 0
                            ? const Color(0xFF3a3a3a)
                            : const Color(0xFF2b2b2b),
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      if (avatarPath != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: Image.asset(
                            avatarPath,
                            width: 30,
                            height: 30,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.none,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      Expanded(
                        child: Text(
                          reward.playerName,
                          style: const TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontFamily: 'CustomFont',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        '+${reward.coinsEarned}',
                        style: const TextStyle(
                          color: Color(0xFFF6D365),
                          fontFamily: 'CustomFont',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Image.asset(
                        UiAssets.goldCoin,
                        width: 14,
                        height: 14,
                        filterQuality: FilterQuality.none,
                      ),
                    ],
                  ),
                );
              }),
            ],
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

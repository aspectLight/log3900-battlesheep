import 'package:signals_flutter/signals_flutter.dart';

import '../../../data/repositories/statistics_repository.dart';
import '../../../data/services/post_game_share_url_opener.dart';
import '../../../domain/models/game_statistics.dart';
import '../../../domain/models/post_game_share_snapshot.dart';

class StatisticsShareActionsViewModel {
  StatisticsShareActionsViewModel({
    required StatisticsRepository statisticsRepository,
    required PostGameShareUrlOpener shareUrlOpener,
    required String username,
    required String socketId,
    required String winnerId,
  }) : _statisticsRepository = statisticsRepository,
       _shareUrlOpener = shareUrlOpener,
       _username = username,
       _socketId = socketId,
       _winnerId = winnerId;

  final StatisticsRepository _statisticsRepository;
  final PostGameShareUrlOpener _shareUrlOpener;
  final String _username;
  final String _socketId;
  final String _winnerId;

  late final shareSnapshot = computed(() {
    final GameStatistics data = _statisticsRepository.state.value.data;
    PlayerStatistics? me;
    for (final PlayerStatistics p in data.playerStats) {
      if (p.name == _username) {
        me = p;
        break;
      }
    }
    if (me == null) {
      return null;
    }
    final int combats = me.combats;
    final int victories = me.victories;
    final int combatPct = combats <= 0
        ? 0
        : ((100 * victories) / combats).round().clamp(0, 100);
    final int walkable = data.walkableTiles;
    final int visited = me.tilesVisited.length;
    final int mapPct = walkable <= 0
        ? 0
        : ((100 * visited) / walkable).round().clamp(0, 100);
    final hasWon = _socketId == _winnerId;
    return PostGameShareSnapshot(
      hasWon: hasWon,
      deaths: me.defeats,
      combatWinPercent: combatPct,
      mapTraversalPercent: mapPct,
    );
  });

  Future<bool> shareOnX(String text) {
    return _shareUrlOpener.openXShareText(text);
  }

  Future<bool> shareOnBluesky(String text) {
    return _shareUrlOpener.openBlueskyShareText(text);
  }

  void dispose() {}
}

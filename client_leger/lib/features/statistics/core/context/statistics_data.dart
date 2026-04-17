import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/models/game_statistics.dart';

part 'statistics_data.freezed.dart';

@freezed
class StatisticsData with _$StatisticsData {
  const factory StatisticsData({
    required String roomId,
    required GameStatistics initialData,
    required bool isCTF,
    required String winnerId,
    required String currentUserSocketId,
    required String statisticsPlayerName,
  }) = _StatisticsData;
}

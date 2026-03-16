import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/game_statistics.dart';

part 'statistics_state.freezed.dart';

@freezed
class StatisticsState with _$StatisticsState {
  const factory StatisticsState({required GameStatistics data}) =
      _StatisticsState;
}

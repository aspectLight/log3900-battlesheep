import 'package:signals_flutter/signals_flutter.dart';

import '../../domain/models/game_statistics.dart';
import '../../domain/state/statistics_state.dart';

class StatisticsRepository {
  late final Signal<StatisticsState> state;

  StatisticsRepository({required GameStatistics initialData}) :
       state = signal(StatisticsState(data: initialData));

  void applyStatistics(GameStatistics statistics) {
    state.value = StatisticsState(data: statistics);
  }
}

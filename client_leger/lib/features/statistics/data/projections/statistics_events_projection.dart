import 'dart:async';

import '../../../../../core/interfaces/event_projection.dart';
import '../models/extensions/game_rewards_info_dto_extensions.dart';
import '../models/extensions/statistics_dto_extensions.dart';
import '../repositories/statistics_repository.dart';
import '../services/statistics_socket.dart';

class StatisticsEventsProjection implements EventProjection {
  final StatisticsSocket _statisticsSocket;
  final StatisticsRepository _statisticsRepository;

  StatisticsEventsProjection({
    required StatisticsSocket statisticsSocket,
    required StatisticsRepository statisticsRepository,
  }) : _statisticsSocket = statisticsSocket,
       _statisticsRepository = statisticsRepository;

  @override
  List<StreamSubscription> subscribe() => [
    _statisticsSocket.statisticsResponseStream.listen((dto) {
      _statisticsRepository.applyStatistics(dto.toEntity());
    }),
    _statisticsSocket.rewardsInfoStream.listen((dto) {
      _statisticsRepository.applyRewardsInfo(dto.toEntity());
    }),
  ];
}

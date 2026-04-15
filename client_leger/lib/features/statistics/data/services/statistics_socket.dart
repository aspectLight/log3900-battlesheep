import 'dart:async';

import '../../../../core/services/socket_service.dart';
import '../models/dto/game_rewards_info_dto.dart';
import '../models/dto/statistics_dto.dart';
import '../models/events/statistics_socket_events.dart';

class StatisticsSocket {
  final SocketService _socketService;

  final _responseController = StreamController<GameStatisticsDto>.broadcast();
  final _rewardsController = StreamController<GameRewardsInfoDto>.broadcast();
  StreamSubscription<Object?>? _statisticsSubscription;
  StreamSubscription<Object?>? _rewardsSubscription;

  StatisticsSocket({required SocketService socketService})
    : _socketService = socketService {
    _statisticsSubscription = _socketService
        .on<Map<String, dynamic>>(StatisticsSocketEvents.getStatisticsResponse)
        .listen(
          (data) =>
              _responseController.add(GameStatisticsDto.fromSocketData(data)),
        );
    _rewardsSubscription = _socketService
        .on<Map<String, dynamic>>(StatisticsSocketEvents.gameRewardsInfo)
        .listen(
          (data) =>
              _rewardsController.add(GameRewardsInfoDto.fromSocketData(data)),
        );
  }

  void getStatistics(String roomId) {
    _socketService.emit(StatisticsSocketEvents.getStatistics, roomId);
  }

  Stream<GameStatisticsDto> get statisticsResponseStream =>
      _responseController.stream;
  Stream<GameRewardsInfoDto> get rewardsInfoStream => _rewardsController.stream;

  Future<void> dispose() async {
    await _statisticsSubscription?.cancel();
    await _rewardsSubscription?.cancel();
    _socketService.off(StatisticsSocketEvents.getStatisticsResponse);
    _socketService.off(StatisticsSocketEvents.gameRewardsInfo);
    await _responseController.close();
    await _rewardsController.close();
  }
}

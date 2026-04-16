import 'dart:async';

import '../../../../core/services/log_service.dart';
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
    LogService.d('[StatisticsSocket] created, subscribing to events');
    _statisticsSubscription = _socketService
        .on<Map<String, dynamic>>(StatisticsSocketEvents.getStatisticsResponse)
        .listen(
          (data) {
            LogService.d('[StatisticsSocket] getStatisticsResponse received');
            _responseController.add(GameStatisticsDto.fromSocketData(data));
          },
        );
    _rewardsSubscription = _socketService
        .on<Object>(StatisticsSocketEvents.gameRewardsInfo)
        .listen(
          (rawData) {
            LogService.d('[StatisticsSocket] gameRewardsInfo received, type=${rawData.runtimeType}');
            final Map<String, dynamic> data;
            if (rawData is Map<String, dynamic>) {
              data = rawData;
            } else if (rawData is Map) {
              data = Map<String, dynamic>.from(rawData);
            } else {
              LogService.e('[StatisticsSocket] unexpected data type: ${rawData.runtimeType}');
              return;
            }
            _rewardsController.add(GameRewardsInfoDto.fromSocketData(data));
          },
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
    await _responseController.close();
    await _rewardsController.close();
  }
}

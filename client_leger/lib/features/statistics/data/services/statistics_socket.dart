import 'dart:async';

import '../../../../core/services/socket_service.dart';
import '../models/dto/statistics_dto.dart';
import '../models/events/statistics_socket_events.dart';

class StatisticsSocket {
  final SocketService _socketService;

  final _responseController =
      StreamController<GameStatisticsDto>.broadcast();
  StreamSubscription<Object?>? _subscription;

  StatisticsSocket({required SocketService socketService})
      : _socketService = socketService {
    _subscription = _socketService
        .on<Map<String, dynamic>>(StatisticsSocketEvents.getStatisticsResponse)
        .listen((data) =>
            _responseController.add(GameStatisticsDto.fromSocketData(data)));
  }

  void getStatistics(String roomId) {
    _socketService.emit(StatisticsSocketEvents.getStatistics, roomId);
  }

  Stream<GameStatisticsDto> get statisticsResponseStream =>
      _responseController.stream;

  Future<void> dispose() async {
    await _subscription?.cancel();
    _socketService.off(StatisticsSocketEvents.getStatisticsResponse);
    await _responseController.close();
  }
}

import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../../../core/services/log_service.dart';
import '../../../../core/services/socket_service.dart';
import '../../../statistics/data/models/events/statistics_socket_events.dart';
import '../../../statistics/data/models/dto/game_rewards_info_dto.dart';
import '../../../statistics/data/models/extensions/game_rewards_info_dto_extensions.dart';
import '../../../statistics/domain/models/game_rewards_info.dart';
import '../../core/event_bus/game_session_event_bus.dart';
import '../repositories/game_rewards_holder.dart';

class GameRewardsCaptureSideEffect with DisposableSideEffect {
  final SocketService _socketService;
  final GameSessionEventBus _gameSessionEventBus;
  final GameRewardsHolder _gameRewardsHolder;

  bool _awaitingRewards = false;

  GameRewardsCaptureSideEffect({
    required SocketService socketService,
    required GameSessionEventBus gameSessionEventBus,
    required GameRewardsHolder gameRewardsHolder,
  }) : _socketService = socketService,
       _gameSessionEventBus = gameSessionEventBus,
       _gameRewardsHolder = gameRewardsHolder {
    LogService.d('[RewardsCapture] side effect created');
    trackSubscription(
      _gameSessionEventBus.on<GameSessionFinishedEvent>().listen((_) {
        LogService.d('[RewardsCapture] GameSessionFinishedEvent received, now awaiting rewards');
        _gameRewardsHolder.captured = GameRewardsInfo.empty;
        _awaitingRewards = true;
      }),
    );
    trackSubscription(
      _socketService
          .on<Object>(StatisticsSocketEvents.gameRewardsInfo)
          .listen(_onRewardsReceived),
    );
  }

  void _onRewardsReceived(Object rawData) {
    LogService.d('[RewardsCapture] gameRewardsInfo socket event received, awaiting=$_awaitingRewards, type=${rawData.runtimeType}');
    if (!_awaitingRewards) return;
    final Map<String, dynamic> data;
    if (rawData is Map<String, dynamic>) {
      data = rawData;
    } else if (rawData is Map) {
      data = Map<String, dynamic>.from(rawData);
    } else {
      LogService.e('[RewardsCapture] unexpected data type: ${rawData.runtimeType}');
      return;
    }
    final entity = GameRewardsInfoDto.fromSocketData(data).toEntity();
    LogService.d('[RewardsCapture] parsed ${entity.rewards.length} reward(s), entryFee=${entity.entryFee}, pool=${entity.pool}');
    _gameRewardsHolder.captured = entity;
    _awaitingRewards = false;
  }
}

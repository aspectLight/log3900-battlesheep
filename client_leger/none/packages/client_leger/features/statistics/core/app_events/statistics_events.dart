import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/app_transition/app_transition_bus.dart';
import '../../domain/models/game_rewards_info.dart';

part 'statistics_events.freezed.dart';

@freezed
sealed class StatisticsEntryAppEvent
    with _$StatisticsEntryAppEvent
    implements AppTransitionEvent {
  const factory StatisticsEntryAppEvent.statisticsRequested({
    required String roomId,
    required bool isCTF,
    GameRewardsInfo? capturedRewards,
  }) = StatisticsRequested;
}

@freezed
class StatisticsCompletedAppEvent
    with _$StatisticsCompletedAppEvent
    implements AppTransitionEvent {
  const factory StatisticsCompletedAppEvent() = _StatisticsCompletedAppEvent;
}

@freezed
sealed class StatisticsExitAppEvent
    with _$StatisticsExitAppEvent
    implements AppTransitionEvent {
  const factory StatisticsExitAppEvent.leaveRequested() =
      LeaveStatisticsRequestedCommand;
}

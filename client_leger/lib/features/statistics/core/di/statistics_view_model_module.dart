import 'package:get_it/get_it.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../data/repositories/statistics_repository.dart';
import '../../data/services/post_game_share_url_opener.dart';
import '../../presentation/screens/statistics_screen/statistics_screen_view_model.dart';
import '../../presentation/widgets/statistics_content/statistics_content_view_model.dart';
import '../../presentation/widgets/statistics_share_actions/statistics_share_actions_view_model.dart';

void registerStatisticsViewModels(
  GetIt scope,
  GetIt rootGetIt, {
  required bool isCTF,
  required String winnerId,
  required String currentUserSocketId,
  required String statisticsPlayerName,
}) {
  scope.registerFactory<StatisticsContentViewModel>(
    () => StatisticsContentViewModel(
      appTransitionEventBus: rootGetIt.get<AppTransitionEventBus>(),
      statisticsRepository: scope.get<StatisticsRepository>(),
      isCTF: isCTF,
    ),
  );
  scope.registerFactory<StatisticsShareActionsViewModel>(
    () => StatisticsShareActionsViewModel(
      statisticsRepository: scope.get<StatisticsRepository>(),
      shareUrlOpener: rootGetIt.get<PostGameShareUrlOpener>(),
      username: statisticsPlayerName,
      socketId: currentUserSocketId,
      winnerId: winnerId,
    ),
  );
  scope.registerFactory<StatisticsScreenViewModel>(
    () => StatisticsScreenViewModel(
      statisticsViewModel: scope.get<StatisticsContentViewModel>(),
      shareActionsViewModel: scope.get<StatisticsShareActionsViewModel>(),
    ),
  );
}

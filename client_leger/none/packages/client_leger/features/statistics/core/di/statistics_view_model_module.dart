import 'package:get_it/get_it.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../data/repositories/statistics_repository.dart';
import '../../presentation/screens/statistics_screen/statistics_screen_view_model.dart';
import '../../presentation/widgets/statistics_content/statistics_content_view_model.dart';

void registerStatisticsViewModels(
  GetIt scope,
  GetIt rootGetIt, {
  required bool isCTF,
}) {
  scope.registerFactory<StatisticsContentViewModel>(
    () => StatisticsContentViewModel(
      appTransitionEventBus: rootGetIt.get<AppTransitionEventBus>(),
      statisticsRepository: scope.get<StatisticsRepository>(),
      isCTF: isCTF,
    ),
  );
  scope.registerFactory<StatisticsScreenViewModel>(
    () => StatisticsScreenViewModel(
      statisticsViewModel: scope.get<StatisticsContentViewModel>(),
    ),
  );
}

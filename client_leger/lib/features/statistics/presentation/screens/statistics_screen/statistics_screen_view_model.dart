import '../../widgets/statistics_content/statistics_content_view_model.dart';
import '../../widgets/statistics_share_actions/statistics_share_actions_view_model.dart';

class StatisticsScreenViewModel {
  StatisticsScreenViewModel({
    required this.statisticsViewModel,
    required this.shareActionsViewModel,
  });

  final StatisticsContentViewModel statisticsViewModel;
  final StatisticsShareActionsViewModel shareActionsViewModel;

  void handleBackPressed() {
    statisticsViewModel.requestLeave();
  }

  void dispose() {
    statisticsViewModel.dispose();
    shareActionsViewModel.dispose();
  }
}

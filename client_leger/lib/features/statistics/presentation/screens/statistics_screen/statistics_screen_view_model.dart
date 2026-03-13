import '../../widgets/statistics_content/statistics_content_view_model.dart';

class StatisticsScreenViewModel {
  StatisticsScreenViewModel({required this.statisticsViewModel});

  final StatisticsContentViewModel statisticsViewModel;

  void handleBackPressed() {
    statisticsViewModel.requestLeave();
  }

  void dispose() {
    statisticsViewModel.dispose();
  }
}

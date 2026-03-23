import 'package:get_it/get_it.dart';

import '../../../../routing/app_navigator.dart';
import '../coordinators/logs_history_coordinator.dart';

void registerLogsHistoryCoordinator(GetIt getIt) {
  getIt.registerLazySingleton<LogsHistoryCoordinator>(
    () => LogsHistoryCoordinator(appNavigator: getIt<AppNavigator>()),
  );
}

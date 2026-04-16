import 'package:get_it/get_it.dart';

import '../../data/repositories/logs_history_repository.dart';
import '../../data/services/http_logs_history_service.dart';

void registerLogsHistoryRepositories(GetIt getIt) {
  getIt.registerLazySingleton<LogsHistoryRepository>(
    () => LogsHistoryRepository(getIt<HttpLogsHistoryService>()),
  );
}

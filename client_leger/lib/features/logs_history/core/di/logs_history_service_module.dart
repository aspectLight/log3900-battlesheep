import 'package:get_it/get_it.dart';

import '../../../authentication/core/interfaces/auth_repository.dart';
import '../../data/services/http_logs_history_service.dart';

void registerLogsHistoryServices(GetIt getIt) {
  getIt.registerLazySingleton<HttpLogsHistoryService>(
    () => HttpLogsHistoryService(authRepository: getIt<AuthRepository>()),
  );
}

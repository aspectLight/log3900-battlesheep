import 'package:fpdart/fpdart.dart';

import '../../../core/failures/failure.dart';
import '../../entities/logs_history_item.dart';

abstract class LogsHistoryRepository {
  TaskEither<Failure, List<LogsHistoryItem>> getLoginHistory();
}

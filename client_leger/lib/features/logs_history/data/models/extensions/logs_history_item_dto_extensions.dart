import '../../../domain/models/logs_history_item.dart';
import '../../../core/enums/log_type.dart';
import '../dto/logs_history_item_dto.dart';

extension LogsHistoryItemDtoToEntity on LogsHistoryItemDto {
  LogsHistoryItem toEntity() => LogsHistoryItem(
    type: type == 'login' ? LogType.login : LogType.logout,
    date: DateTime.parse(date).toLocal(),
  );
}

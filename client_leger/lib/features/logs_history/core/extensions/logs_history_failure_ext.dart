import '../../../../../core/localisation/core_localizations.dart';
import '../exceptions/logs_history_failure.dart';

extension LogsHistoryFailureExt on LogsHistoryFailure {
  String localize(CoreLocalizations l10n) {
    if (this is LoadFailedLogsHistoryFailure) {
      return l10n.failedToLoadConnectionHistory;
    }
    return l10n.unknownError;
  }
}

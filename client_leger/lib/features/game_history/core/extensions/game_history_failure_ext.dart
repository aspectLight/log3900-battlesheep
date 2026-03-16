import '../../../../../core/localisation/core_localizations.dart';
import '../exceptions/game_history_failure.dart';

extension GameHistoryFailureExt on GameHistoryFailure {
  String localize(CoreLocalizations l10n) {
    if (this is LoadFailedGameHistoryFailure) {
      return l10n.failedToLoadGameHistory;
    }
    return l10n.unknownError;
  }
}

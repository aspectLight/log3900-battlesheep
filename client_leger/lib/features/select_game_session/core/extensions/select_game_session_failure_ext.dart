import '../exceptions/select_game_session_failure.dart';
import '../localisation/select_game_session_localizations.dart';

extension SelectGameSessionFailureExt on SelectGameSessionFailure {
  String localize(SelectGameSessionLocalizations l10n) {
    return l10n.selectedGameHiddenOrDeleted;
  }
}

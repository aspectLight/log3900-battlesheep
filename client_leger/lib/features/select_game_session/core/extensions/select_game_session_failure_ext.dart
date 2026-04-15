import '../exceptions/select_game_session_failure.dart';
import '../localisation/select_game_session_localizations.dart';

extension SelectGameSessionFailureExt on SelectGameSessionFailure {
  String localize(SelectGameSessionLocalizations l10n) {
    if (this is InsufficientFundsSelectGameSessionFailure) {
      return '${l10n.createGameInsufficientFundsTitle}\n\n'
          '${l10n.createGameInsufficientFundsMessage}';
    }
    return l10n.selectedGameHiddenOrDeleted;
  }
}

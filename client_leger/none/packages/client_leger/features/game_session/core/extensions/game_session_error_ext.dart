import '../localisation/game_session_localizations.dart';
import '../enums/game_session_error.dart';

extension GameSessionErrorExt on GameSessionError {
  String localize(GameSessionLocalizations l10n) {
    return switch (this) {
      GameSessionError.gameNotFound => l10n.gameNotFound,
      GameSessionError.network => l10n.networkError,
      GameSessionError.server => l10n.serverError,
      GameSessionError.unknown => l10n.unknownError,
    };
  }
}

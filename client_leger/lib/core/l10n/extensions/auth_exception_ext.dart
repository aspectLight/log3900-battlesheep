import '../../../generated/l10n/app_localizations.dart';
import '../../exceptions/auth_exception.dart';

extension AuthExceptionExt on AuthException {
  String localize(AppLocalizations l10n) {
    if (this is InvalidCredentialsException) {
      return l10n.invalidCredentials;
    }
    if (this is EmailAlreadyInUseException) {
      return l10n.emailAlreadyInUse;
    }
    if (this is UsernameAlreadyInUseException) {
      return l10n.usernameAlreadyInUse;
    }
    if (this is AccountAlreadyConnectedException) {
      return l10n.accountAlreadyConnected;
    }
    if (this is UserNotFoundException) {
      return l10n.userNotFound;
    }
    if (this is NetworkException) {
      return l10n.networkError;
    }
    if (this is ServerException) {
      return l10n.serverError;
    }

    return l10n.unknownError;
  }
}

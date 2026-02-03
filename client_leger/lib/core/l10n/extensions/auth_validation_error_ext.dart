import '../../../generated/l10n/app_localizations.dart';
import '../../enums/auth_validation_error.dart';

extension AuthValidationErrorExt on AuthValidationError {
  String localize(AppLocalizations l10n) {
    return switch (this) {
      AuthValidationError.usernameRequired => l10n.usernameRequired,
      AuthValidationError.identifierRequired => l10n.identifierRequired,
      AuthValidationError.usernameTooShort => l10n.usernameTooShort,
      AuthValidationError.usernameTooLong => l10n.usernameTooLong,
      AuthValidationError.usernameInvalidLength => l10n.usernameInvalidLength,
      AuthValidationError.usernameSpecialChars => l10n.usernameSpecialChars,
      AuthValidationError.emailRequired => l10n.emailRequired,
      AuthValidationError.invalidEmail => l10n.invalidEmail,
      AuthValidationError.passwordRequired => l10n.passwordRequired,
      AuthValidationError.passwordTooShort => l10n.passwordTooShort,
      AuthValidationError.passwordLeastOneLetter => l10n.passwordLeastOneLetter,
      AuthValidationError.passwordLeastOneDigit => l10n.passwordLeastOneDigit,
      AuthValidationError.passwordNoSpaces => l10n.passwordNoSpaces,
      AuthValidationError.confirmationRequired => l10n.confirmationRequired,
      AuthValidationError.passwordsDoNotMatch => l10n.passwordsDoNotMatch,
      AuthValidationError.avatarRequired => l10n.avatarRequired,
    };
  }
}

import '../enums/auth_validation_error.dart';

class PasswordValidator {
  static const int minLength = 8;
  static final RegExp hasLetter = RegExp('[a-zA-Z]');
  static final RegExp hasDigit = RegExp(r'\d');
  static final RegExp hasSpace = RegExp(r'\s');

  static AuthValidationError? validate(String? value) {
    if (value == null || value.isEmpty) {
      return AuthValidationError.passwordRequired;
    }

    if (value.length < minLength) {
      return AuthValidationError.passwordTooShort;
    }

    if (!hasLetter.hasMatch(value)) {
      return AuthValidationError.passwordLeastOneLetter;
    }

    if (!hasDigit.hasMatch(value)) {
      return AuthValidationError.passwordLeastOneDigit;
    }

    if (hasSpace.hasMatch(value)) {
      return AuthValidationError.passwordNoSpaces;
    }

    return null;
  }

  static AuthValidationError? validateConfirmation(
    String? password,
    String? confirmation,
  ) {
    if (confirmation == null || confirmation.isEmpty) {
      return AuthValidationError.confirmationRequired;
    }

    if (password != confirmation) {
      return AuthValidationError.passwordsDoNotMatch;
    }

    return null;
  }
}

import '../enums/auth_validation_error.dart';

class PasswordValidator {
  static const int minLength = 8;
  static final RegExp hasLetter = RegExp('[a-zA-Z]');
  static final RegExp hasDigit = RegExp(r'\d');
  static final RegExp hasSpace = RegExp(r'\s');

  static List<AuthValidationError> validateAll(String? value) {
    final errors = <AuthValidationError>[];

    if (value == null || value.isEmpty) {
      errors.add(AuthValidationError.passwordRequired);
      return errors;
    }

    if (value.length < minLength) {
      errors.add(AuthValidationError.passwordTooShort);
    }

    if (!hasLetter.hasMatch(value)) {
      errors.add(AuthValidationError.passwordLeastOneLetter);
    }

    if (!hasDigit.hasMatch(value)) {
      errors.add(AuthValidationError.passwordLeastOneDigit);
    }

    if (hasSpace.hasMatch(value)) {
      errors.add(AuthValidationError.passwordNoSpaces);
    }

    return errors;
  }

  static List<AuthValidationError> validateConfirmationAll(
    String? password,
    String? confirmation,
  ) {
    final errors = <AuthValidationError>[];

    if (confirmation == null || confirmation.isEmpty) {
      errors.add(AuthValidationError.confirmationRequired);
      return errors;
    }

    if (password != confirmation) {
      errors.add(AuthValidationError.passwordsDoNotMatch);
    }

    return errors;
  }
}

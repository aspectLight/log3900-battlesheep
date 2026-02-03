import '../enums/auth_validation_error.dart';

class UsernameValidator {
  static const int minLength = 3;
  static const int maxLength = 15;
  static final RegExp validPattern = RegExp(r'^[a-zA-Z0-9]+$');

  static List<AuthValidationError> validateAll(String? value) {
    final errors = <AuthValidationError>[];

    if (value == null || value.isEmpty) {
      errors.add(AuthValidationError.usernameRequired);
      return errors;
    }

    if (value.length < minLength || value.length > maxLength) {
      errors.add(AuthValidationError.usernameInvalidLength);
    }

    if (!validPattern.hasMatch(value)) {
      errors.add(AuthValidationError.usernameSpecialChars);
    }

    return errors;
  }
}

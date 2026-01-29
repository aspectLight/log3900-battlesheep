import '../enums/auth_validation_error.dart';

class UsernameValidator {
  static const int minLength = 3;
  static const int maxLength = 15;
  static final RegExp validPattern = RegExp(r'^[a-zA-Z0-9]+$');

  static AuthValidationError? validate(String? value) {
    if (value == null || value.isEmpty) {
      return AuthValidationError.usernameRequired;
    }

    if (value.length < minLength) {
      return AuthValidationError.usernameTooShort;
    }

    if (value.length > maxLength) {
      return AuthValidationError.usernameTooLong;
    }

    if (!validPattern.hasMatch(value)) {
      return AuthValidationError.usernameSpecialChars;
    }

    return null;
  }
}

import '../enums/auth_validation_error.dart';

class EmailValidator {
  static final RegExp emailPattern = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static AuthValidationError? validate(String? value) {
    if (value == null || value.isEmpty) {
      return AuthValidationError.emailRequired;
    }

    if (!emailPattern.hasMatch(value)) {
      return AuthValidationError.invalidEmail;
    }

    return null;
  }
}

import '../enums/auth_validation_error.dart';

class EmailValidator {
  static final RegExp emailPattern = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static List<AuthValidationError> validateAll(String? value) {
    final errors = <AuthValidationError>[];

    if (value == null || value.isEmpty) {
      errors.add(AuthValidationError.emailRequired);
      return errors;
    }

    if (!emailPattern.hasMatch(value)) {
      errors.add(AuthValidationError.invalidEmail);
    }

    return errors;
  }
}

import 'package:fpdart/fpdart.dart';

import '../../../../core/helpers/functional_programming.dart';
import '../enums/auth_validation_error.dart';

class EmailValidator {
  static final RegExp emailPattern = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static List<AuthValidationError> validateAll(Option<String> value) {
    return value.when(
      none: () => [AuthValidationError.emailRequired],
      some: (s) {
        final errors = <AuthValidationError>[];
        if (s.isEmpty) {
          errors.add(AuthValidationError.emailRequired);
          return errors;
        }
        if (!emailPattern.hasMatch(s)) {
          errors.add(AuthValidationError.invalidEmail);
        }
        return errors;
      },
    );
  }
}

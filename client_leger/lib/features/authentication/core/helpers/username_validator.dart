import 'package:fpdart/fpdart.dart';

import '../../../../core/helpers/functional_programming.dart';
import '../constants/auth_constants.dart';
import '../enums/auth_validation_error.dart';

class UsernameValidator {
  static final RegExp validPattern = RegExp(r'^[a-zA-Z0-9]+$');

  static List<AuthValidationError> validateAll(Option<String> value) {
    return value.when(
      none: () => [AuthValidationError.usernameRequired],
      some: (s) {
        final errors = <AuthValidationError>[];
        if (s.isEmpty) {
          errors.add(AuthValidationError.usernameRequired);
          return errors;
        }
        if (s.length < AuthConstants.usernameMinLength ||
            s.length > AuthConstants.usernameMaxLength) {
          errors.add(AuthValidationError.usernameInvalidLength);
        }
        if (!validPattern.hasMatch(s)) {
          errors.add(AuthValidationError.usernameSpecialChars);
        }
        return errors;
      },
    );
  }
}

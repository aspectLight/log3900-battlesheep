import 'package:fpdart/fpdart.dart';

import '../../../../core/helpers/functional_programming.dart';
import '../constants/auth_constants.dart';
import '../enums/auth_validation_error.dart';

class PasswordValidator {
  static final RegExp hasLetter = RegExp('[a-zA-Z]');
  static final RegExp hasDigit = RegExp(r'\d');
  static final RegExp hasSpace = RegExp(r'\s');

  static List<AuthValidationError> validateAll(Option<String> value) {
    return value.when(
      none: () => [AuthValidationError.passwordRequired],
      some: (s) {
        final errors = <AuthValidationError>[];
        if (s.isEmpty) {
          errors.add(AuthValidationError.passwordRequired);
          return errors;
        }
        if (s.length < AuthConstants.passwordMinLength) {
          errors.add(AuthValidationError.passwordTooShort);
        }
        if (!hasLetter.hasMatch(s)) {
          errors.add(AuthValidationError.passwordLeastOneLetter);
        }
        if (!hasDigit.hasMatch(s)) {
          errors.add(AuthValidationError.passwordLeastOneDigit);
        }
        if (hasSpace.hasMatch(s)) {
          errors.add(AuthValidationError.passwordNoSpaces);
        }
        return errors;
      },
    );
  }

  static List<AuthValidationError> validateConfirmationAll(
    Option<String> password,
    Option<String> confirmation,
  ) {
    return confirmation.when(
      none: () => [AuthValidationError.confirmationRequired],
      some: (conf) {
        if (conf.isEmpty) {
          return [AuthValidationError.confirmationRequired];
        }
        return password.when(
          none: () => [AuthValidationError.passwordsDoNotMatch],
          some: (pass) =>
              pass != conf ? [AuthValidationError.passwordsDoNotMatch] : [],
        );
      },
    );
  }
}

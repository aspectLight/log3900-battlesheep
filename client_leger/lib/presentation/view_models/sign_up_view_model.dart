import 'package:signals_flutter/signals_flutter.dart';

import '../../core/enums/auth_validation_error.dart';
import '../../core/helpers/email_validator.dart';
import '../../core/helpers/password_validator.dart';
import '../../core/helpers/username_validator.dart';
import '../../domain/entities/auth_state.dart';
import '../../domain/interfaces/auth_repository.dart';

class SignUpViewModel {
  final AuthRepository _authRepository;

  SignUpViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final username = signal('');
  final email = signal('');
  final password = signal('');
  final confirmPassword = signal('');

  final hasAttemptedSubmit = signal(false);
  final isLoading = signal(false);
  final authState = signal<AuthState>(const AuthStateInitial());

  late final usernameError = computed<AuthValidationError?>(() {
    final error = UsernameValidator.validate(username.value);
    if (error != null && username.value.isEmpty && !hasAttemptedSubmit.value) {
      return null;
    }
    return error;
  });

  late final emailError = computed<AuthValidationError?>(() {
    final error = EmailValidator.validate(email.value);
    if (error != null && email.value.isEmpty && !hasAttemptedSubmit.value) {
      return null;
    }
    return error;
  });

  late final passwordError = computed<AuthValidationError?>(() {
    final error = PasswordValidator.validate(password.value);
    if (error != null && password.value.isEmpty && !hasAttemptedSubmit.value) {
      return null;
    }
    return error;
  });

  late final confirmPasswordError = computed<AuthValidationError?>(() {
    final error = PasswordValidator.validateConfirmation(
      password.value,
      confirmPassword.value,
    );
    if (error != null &&
        confirmPassword.value.isEmpty &&
        !hasAttemptedSubmit.value) {
      return null;
    }
    return error;
  });

  late final isFormValid = computed(() {
    return usernameError.value == null &&
        emailError.value == null &&
        passwordError.value == null &&
        confirmPasswordError.value == null &&
        username.value.isNotEmpty &&
        email.value.isNotEmpty &&
        password.value.isNotEmpty &&
        confirmPassword.value.isNotEmpty;
  });

  void updateUsername(String value) => username.value = value;

  void updateEmail(String value) => email.value = value;

  void updatePassword(String value) => password.value = value;

  void updateConfirmPassword(String value) => confirmPassword.value = value;

  Future<void> submit() async {
    hasAttemptedSubmit.value = true;

    if (!isFormValid.value) {
      return;
    }

    isLoading.value = true;
    authState.value = const AuthStateLoading();

    final result = await _authRepository
        .signUp(
          username: username.value,
          email: email.value,
          password: password.value,
        )
        .run();

    result.fold(
      (exception) => authState.value = AuthStateError(exception),
      (user) => authState.value = AuthStateAuthenticated(user),
    );

    isLoading.value = false;
  }

  void resetForm() {
    username.value = '';
    email.value = '';
    password.value = '';
    confirmPassword.value = '';
    hasAttemptedSubmit.value = false;
    authState.value = const AuthStateInitial();
  }

  void dispose() {}
}

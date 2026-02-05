import 'package:signals_flutter/signals_flutter.dart';

import '../../../core/enums/auth_validation_error.dart';
import '../../../core/helpers/email_validator.dart';
import '../../../core/helpers/password_validator.dart';
import '../../../core/helpers/username_validator.dart';
import '../../../domain/entities/auth_state.dart';
import '../../../domain/interfaces/repositories/auth_repository.dart';

class SignUpViewModel {
  final AuthRepository _authRepository;

  SignUpViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final username = signal('');
  final email = signal('');
  final password = signal('');
  final confirmPassword = signal('');
  final avatarId = signal<String?>(null);

  final hasAttemptedSubmit = signal(false);
  final isLoading = signal(false);
  final authState = signal<AuthState>(const AuthStateInitial());

  late final usernameErrors = computed<List<AuthValidationError>>(() {
    final errors = UsernameValidator.validateAll(username.value);
    if (errors.isNotEmpty &&
        errors.first == AuthValidationError.usernameRequired &&
        !hasAttemptedSubmit.value) {
      return [];
    }
    return errors;
  });

  late final emailErrors = computed<List<AuthValidationError>>(() {
    final errors = EmailValidator.validateAll(email.value);
    if (errors.isNotEmpty &&
        errors.first == AuthValidationError.emailRequired &&
        !hasAttemptedSubmit.value) {
      return [];
    }
    return errors;
  });

  late final passwordErrors = computed<List<AuthValidationError>>(() {
    final errors = PasswordValidator.validateAll(password.value);
    if (errors.isNotEmpty &&
        errors.first == AuthValidationError.passwordRequired &&
        !hasAttemptedSubmit.value) {
      return [];
    }
    return errors;
  });

  late final confirmPasswordErrors = computed<List<AuthValidationError>>(() {
    final errors = PasswordValidator.validateConfirmationAll(
      password.value,
      confirmPassword.value,
    );
    if (errors.isNotEmpty &&
        errors.first == AuthValidationError.confirmationRequired &&
        !hasAttemptedSubmit.value) {
      return [];
    }
    return errors;
  });

  late final avatarError = computed<AuthValidationError?>(() {
    if (avatarId.value == null && hasAttemptedSubmit.value) {
      return AuthValidationError.avatarRequired;
    }
    return null;
  });

  late final isFormValid = computed(() {
    return usernameErrors.value.isEmpty &&
        emailErrors.value.isEmpty &&
        passwordErrors.value.isEmpty &&
        confirmPasswordErrors.value.isEmpty &&
        avatarError.value == null &&
        username.value.isNotEmpty &&
        email.value.isNotEmpty &&
        password.value.isNotEmpty &&
        confirmPassword.value.isNotEmpty &&
        avatarId.value != null;
  });

  void updateUsername(String value) => username.value = value;

  void updateEmail(String value) => email.value = value;

  void updatePassword(String value) => password.value = value;

  void updateConfirmPassword(String value) => confirmPassword.value = value;

  void updateAvatar(String? value) => avatarId.value = value;

  Future<void> submit() async {
    hasAttemptedSubmit.value = true;

    if (!isFormValid.value || avatarId.value == null) {
      return;
    }

    isLoading.value = true;
    authState.value = const AuthStateLoading();

    final result = await _authRepository
        .signUp(
          username: username.value,
          email: email.value,
          password: password.value,
          avatarId: avatarId.value!,
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
    avatarId.value = null;
    hasAttemptedSubmit.value = false;
    authState.value = const AuthStateInitial();
  }

  void dispose() {
    username.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    hasAttemptedSubmit.dispose();
    isLoading.dispose();
    authState.dispose();
    usernameErrors.dispose();
    emailErrors.dispose();
    passwordErrors.dispose();
    confirmPasswordErrors.dispose();
    avatarError.dispose();
    isFormValid.dispose();
    avatarId.dispose();
  }
}

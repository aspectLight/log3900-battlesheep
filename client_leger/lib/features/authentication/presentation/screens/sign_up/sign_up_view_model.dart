import 'package:fpdart/fpdart.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../core/app_events/auth_events.dart';
import '../../../core/enums/auth_validation_error.dart';
import '../../../../../core/enums/avatar.dart';
import '../../../../../core/app_transition/app_transition_bus.dart';
import '../../../core/helpers/email_validator.dart';
import '../../../core/helpers/password_validator.dart';
import '../../../core/helpers/username_validator.dart';

import '../../../domain/commands/auth_commands.dart';
import '../../../domain/state/auth_state.dart';
import '../../../domain/use_cases/sign_up_use_case.dart';
import '../../ui_models/widget_states/sign_up_form_ui_state.dart';

class SignUpViewModel {
  final SignUpUseCase _signUpUseCase;
  final AppTransitionEventBus _appTransitionEventBus;

  SignUpViewModel({
    required SignUpUseCase signUpUseCase,
    required AppTransitionEventBus appTransitionEventBus,
  }) : _signUpUseCase = signUpUseCase,
       _appTransitionEventBus = appTransitionEventBus;

  final formState = signal<SignUpFormUiState>(SignUpFormUiState.initial());
  final authState = signal<AuthState>(const AuthState.initial());

  late final usernameErrors = computed<List<AuthValidationError>>(() {
    final state = formState.value;
    final errors = UsernameValidator.validateAll(Option.of(state.username));
    if (errors.isNotEmpty &&
        errors.first == AuthValidationError.usernameRequired &&
        !state.hasAttemptedSubmit) {
      return [];
    }
    return errors;
  });

  late final emailErrors = computed<List<AuthValidationError>>(() {
    final state = formState.value;
    final errors = EmailValidator.validateAll(Option.of(state.email));
    if (errors.isNotEmpty &&
        errors.first == AuthValidationError.emailRequired &&
        !state.hasAttemptedSubmit) {
      return [];
    }
    return errors;
  });

  late final passwordErrors = computed<List<AuthValidationError>>(() {
    final state = formState.value;
    final errors = PasswordValidator.validateAll(Option.of(state.password));
    if (errors.isNotEmpty &&
        errors.first == AuthValidationError.passwordRequired &&
        !state.hasAttemptedSubmit) {
      return [];
    }
    return errors;
  });

  late final confirmPasswordErrors = computed<List<AuthValidationError>>(() {
    final state = formState.value;
    final errors = PasswordValidator.validateConfirmationAll(
      Option.of(state.password),
      Option.of(state.confirmPassword),
    );
    if (errors.isNotEmpty &&
        errors.first == AuthValidationError.confirmationRequired &&
        !state.hasAttemptedSubmit) {
      return [];
    }
    return errors;
  });

  late final avatarError = computed<Option<AuthValidationError>>(() {
    final state = formState.value;
    if (state.avatar.isNone() && state.hasAttemptedSubmit) {
      return const Option.of(AuthValidationError.avatarRequired);
    }
    return const Option.none();
  });

  late final isFormValid = computed(() {
    final state = formState.value;
    return usernameErrors.value.isEmpty &&
        emailErrors.value.isEmpty &&
        passwordErrors.value.isEmpty &&
        confirmPasswordErrors.value.isEmpty &&
        avatarError.value.isNone() &&
        state.username.isNotEmpty &&
        state.email.isNotEmpty &&
        state.password.isNotEmpty &&
        state.confirmPassword.isNotEmpty &&
        state.avatar.isSome();
  });

  void setUsername(String value) {
    formState.value = formState.value.copyWith(username: value);
  }

  void setEmail(String value) {
    formState.value = formState.value.copyWith(email: value);
  }

  void setPassword(String value) {
    formState.value = formState.value.copyWith(password: value);
  }

  void setConfirmPassword(String value) {
    formState.value = formState.value.copyWith(confirmPassword: value);
  }

  void selectAvatar(Avatar? value) {
    formState.value =
        formState.value.copyWith(avatar: Option.fromNullable(value));
  }

  Future<void> signUpSubmit() async {
    formState.value =
        formState.value.copyWith(hasAttemptedSubmit: true);
    if (!isFormValid.value) return;
    final state = formState.value;
    switch (state.avatar) {
      case None():
        return;
      case Some(value: final selectedAvatar):
        authState.value = const AuthStateLoading();
        final result = await _signUpUseCase
            .execute(
              SignUpCommand(
                username: state.username,
                email: state.email,
                password: state.password,
                avatarId: selectedAvatar.id,
              ),
            )
            .run();
        switch (result) {
          case Left(value: final exception):
            authState.value = AuthState.error(exception);
          case Right(value: final user):
            authState.value = AuthState.authenticated(user);
            _appTransitionEventBus.fire(AuthEntryAppEvent.signInSuccess(user));
        }
    }
  }

  void resetForm() {
    formState.value = SignUpFormUiState.initial();
    authState.value = const AuthState.initial();
  }

  void dispose() {
    formState.dispose();
    authState.dispose();
    usernameErrors.dispose();
    emailErrors.dispose();
    passwordErrors.dispose();
    confirmPasswordErrors.dispose();
    avatarError.dispose();
    isFormValid.dispose();
  }
}

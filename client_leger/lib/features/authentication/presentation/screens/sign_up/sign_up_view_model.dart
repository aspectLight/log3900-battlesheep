import 'package:fpdart/fpdart.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../core/app_events/auth_events.dart';
import '../../../core/enums/auth_validation_error.dart';
import '../../../../../core/appearance/app_appearance_service.dart';
import '../../../../../core/appearance/app_visual_theme.dart';
import '../../../../../core/enums/auth_avatar.dart';
import '../../../../../core/app_transition/app_transition_bus.dart';
import '../../../core/helpers/email_validator.dart';
import '../../../core/helpers/password_validator.dart';
import '../../../core/helpers/username_validator.dart';

import '../../../domain/commands/auth_commands.dart';
import '../../../domain/state/auth_state.dart';
import '../../../domain/use_cases/sign_up_use_case.dart';
import '../../../core/interfaces/auth_repository.dart';
import '../../../../profile/data/services/http_profile_service.dart';
import '../../ui_models/widget_states/sign_up_form_ui_state.dart';

class SignUpViewModel {
  final SignUpUseCase _signUpUseCase;
  final AppTransitionEventBus _appTransitionEventBus;
  final HttpProfileService _profileService;
  final AuthRepository _authRepository;
  final AppAppearanceService _appearance;

  SignUpViewModel({
    required SignUpUseCase signUpUseCase,
    required AppTransitionEventBus appTransitionEventBus,
    required HttpProfileService profileService,
    required AuthRepository authRepository,
    required AppAppearanceService appearance,
  }) : _signUpUseCase = signUpUseCase,
       _appTransitionEventBus = appTransitionEventBus,
       _profileService = profileService,
       _authRepository = authRepository,
       _appearance = appearance;

  final formState = signal<SignUpFormUiState>(SignUpFormUiState.initial());
  final authState = signal<AuthState>(const AuthState.initial());
  final customAvatarUploadFailed = signal<bool>(false);

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
    if (state.avatar.isNone() &&
        (state.customAvatarPath == null || state.customAvatarPath!.isEmpty) &&
        state.hasAttemptedSubmit) {
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
        (state.avatar.isSome() ||
            (state.customAvatarPath != null &&
                state.customAvatarPath!.isNotEmpty));
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

  void selectAvatar(AuthAvatar? value) {
    formState.value = formState.value.copyWith(
      avatar: Option.fromNullable(value),
      customAvatarPath: null,
    );
  }

  void setCustomAvatarPath(String path) {
    formState.value = formState.value.copyWith(
      avatar: const Option.none(),
      customAvatarPath: path,
    );
  }

  void clearCustomAvatarPath() {
    formState.value = formState.value.copyWith(customAvatarPath: null);
  }

  Future<void> signUpSubmit() async {
    formState.value = formState.value.copyWith(hasAttemptedSubmit: true);
    customAvatarUploadFailed.value = false;
    if (!isFormValid.value) return;
    final state = formState.value;
    final avatarId = state.avatar.match(() => 'custom', (a) => a.id);
    authState.value = const AuthStateLoading();
    final result = await _signUpUseCase
        .execute(
          SignUpCommand(
            username: state.username,
            email: state.email,
            password: state.password,
            avatarId: avatarId,
            language: _appearance.effectiveLanguageCodeForApi(),
            theme: appVisualThemeToId(_appearance.visualTheme.value),
          ),
        )
        .run();
    switch (result) {
      case Left(value: final exception):
        authState.value = AuthState.error(exception);
      case Right(value: final user):
        var authenticatedUser = user;
        final customPath = state.customAvatarPath;
        if (customPath != null && customPath.isNotEmpty) {
          try {
            final updatedProfile = await _profileService.uploadAvatar(
              customPath,
            );
            authenticatedUser = authenticatedUser.copyWith(
              username: updatedProfile.username,
              email: updatedProfile.email,
              avatarId: updatedProfile.avatarId,
              avatarUrl: updatedProfile.avatarUrl,
            );
          } on Object {
            customAvatarUploadFailed.value = true;
          }
        }
        _authRepository.syncCurrentUser(authenticatedUser);
        authState.value = AuthState.authenticated(authenticatedUser);
        _appTransitionEventBus.fire(
          AuthEntryAppEvent.signInSuccess(authenticatedUser),
        );
    }
  }

  void resetForm() {
    formState.value = SignUpFormUiState.initial();
    authState.value = const AuthState.initial();
    customAvatarUploadFailed.value = false;
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
    customAvatarUploadFailed.dispose();
  }
}

import 'dart:async';

import 'package:fpdart/fpdart.dart';

import '../../features/authentication/core/interfaces/auth_repository.dart';
import '../../features/authentication/domain/models/user.dart';
import '../../features/profile/data/models/dto/profile_dto.dart';
import '../../features/profile/data/services/http_profile_service.dart';
import '../helpers/functional_programming.dart';
import 'app_appearance_service.dart';

class AppearanceSyncSideEffect {
  AppearanceSyncSideEffect({
    required AuthRepository authRepository,
    required HttpProfileService httpProfileService,
    required AppAppearanceService appearance,
  }) : _authRepository = authRepository,
       _httpProfileService = httpProfileService,
       _appearance = appearance {
    _subscription = _authRepository.authStateChanges.listen(_onAuthChanged);
    unawaited(_syncInitial());
  }

  final AuthRepository _authRepository;
  final HttpProfileService _httpProfileService;
  final AppAppearanceService _appearance;

  StreamSubscription<Option<UserModel>>? _subscription;

  Future<void> _syncInitial() async {
    final result = await _authRepository.getCurrentUser().run();
    switch (result) {
      case Left():
        _appearance.applyGuestDefaults();
      case Right(value: final userOption):
        userOption.when(
          none: _appearance.applyGuestDefaults,
          some: (_) => unawaited(_pullProfileAndApply()),
        );
    }
  }

  void _onAuthChanged(Option<UserModel> userOption) {
    userOption.when(
      none: _appearance.applyGuestDefaults,
      some: (_) => unawaited(_pullProfileAndApply()),
    );
  }

  Future<void> _pullProfileAndApply() async {
    try {
      var dto = await _httpProfileService.fetchProfile();
      final syncLang = _appearance.guestLanguageDisagreesWithServer(
        dto.language,
      );
      if (syncLang != null) {
        try {
          await _httpProfileService.updateProfile(
            ProfileUpdateRequestDto(language: syncLang),
          );
          dto = await _httpProfileService.fetchProfile();
        } on Object {
          // Use last fetched dto; UI will match server defaults.
        } finally {
          _appearance.clearGuestLanguageOverride();
        }
      }
      _appearance.applyFromServer(theme: dto.theme, language: dto.language);
    } on Object {
      // Keep current appearance if profile cannot be loaded.
    }
  }

  void dispose() {
    unawaited(_subscription?.cancel());
  }
}

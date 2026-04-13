import 'package:fpdart/fpdart.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../../core/app_transition/app_transition_bus.dart';
import '../../../../../../core/appearance/app_appearance_service.dart';
import '../../../../authentication/core/app_events/auth_events.dart';
import '../../../core/exceptions/profile_failure.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../domain/commands/profile_commands.dart';
import '../../../domain/models/profile_model.dart';
import '../../../domain/state/profile_state.dart';

class ProfileViewModel {
  ProfileViewModel({
    required ProfileRepository repository,
    required AppTransitionEventBus appTransitionEventBus,
    required AppAppearanceService appearance,
  }) : _repository = repository,
       _appTransitionEventBus = appTransitionEventBus,
       _appearance = appearance,
       state = computed(() => repository.state.value);

  final ProfileRepository _repository;
  final AppTransitionEventBus _appTransitionEventBus;
  final AppAppearanceService _appearance;

  final Computed<ProfileState> state;
  final Signal<bool> isSaving = signal<bool>(false);
  final Signal<bool> isDeleting = signal<bool>(false);
  final Signal<String> selectedAvatarId = signal<String>('');
  final Signal<String> selectedThemeId = signal<String>('default');
  final Signal<String> selectedLanguage = signal<String>('fr');

  void setSelectedAvatarId(String avatarId) {
    selectedAvatarId.value = avatarId;
  }

  void setSelectedThemeId(String themeId) {
    selectedThemeId.value = themeId;
  }

  void setSelectedLanguage(String languageCode) {
    selectedLanguage.value = languageCode;
  }

  void syncPreferencesFromProfile(ProfileModel profile) {
    selectedThemeId.value = profile.theme;
    selectedLanguage.value = profile.language;
  }

  Future<void> load() => _repository.loadProfileAndStatistics();

  Future<Either<ProfileFailure, Unit>> submitUpdate(
    UpdateProfileCommand command,
  ) async {
    isSaving.value = true;
    final result = await _repository.updateProfile(command);
    result.match(
      (_) {
        isSaving.value = false;
      },
      (profile) {
        _appearance.applyFromServer(
          theme: profile.theme,
          language: profile.language,
        );
        isSaving.value = false;
      },
    );
    return result.map((_) => unit);
  }

  Future<Either<ProfileFailure, Unit>> deleteAccount() async {
    isDeleting.value = true;
    final result = await _repository.deleteAccount();
    isDeleting.value = false;
    return result.map((_) {
      _appTransitionEventBus.fire(const AuthExitAppEvent.signOut());
      return unit;
    });
  }
}

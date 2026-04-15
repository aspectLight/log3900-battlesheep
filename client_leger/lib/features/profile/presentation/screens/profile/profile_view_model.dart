import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../../core/app_transition/app_transition_bus.dart';
import '../../../../../../core/appearance/app_appearance_service.dart';
import '../../../../../../core/helpers/functional_programming.dart';
import '../../../../authentication/core/app_events/auth_events.dart';
import '../../../../tutorial/core/app_transition/tutorial_events.dart';
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

  Future<void> submitUpdate(UpdateProfileCommand command) async {
    if (isSaving.value) return;
    isSaving.value = true;
    final result = await _repository.updateProfile(command);
    result.when(
      left: (_) {
        isSaving.value = false;
      },
      right: (profile) {
        _appearance.applyFromServer(
          theme: profile.theme,
          language: profile.language,
        );
        isSaving.value = false;
      },
    );
  }

  Future<void> deleteAccount() async {
    final result = await _repository.deleteAccount();
    result.when(
      left: (_) {},
      right: (_) =>
          _appTransitionEventBus.fire(const AuthExitAppEvent.signOut()),
    );
  }

  void openTutorial() {
    _appTransitionEventBus.fire(const TutorialEntryAppEvent.requested());
  }
}

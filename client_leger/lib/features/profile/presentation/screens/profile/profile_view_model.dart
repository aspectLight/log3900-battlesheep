import 'package:fpdart/fpdart.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../../core/app_transition/app_transition_bus.dart';
import '../../../../../../core/appearance/app_appearance_service.dart';
import '../../../../authentication/core/interfaces/auth_repository.dart';
import '../../../../authentication/domain/models/user.dart';
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
    required AuthRepository authRepository,
  }) : _repository = repository,
       _appTransitionEventBus = appTransitionEventBus,
       _appearance = appearance,
       _authRepository = authRepository,
       state = computed(() => repository.state.value);

  final ProfileRepository _repository;
  final AppTransitionEventBus _appTransitionEventBus;
  final AppAppearanceService _appearance;
  final AuthRepository _authRepository;

  final Computed<ProfileState> state;
  final Signal<bool> isSaving = signal<bool>(false);
  final Signal<bool> isDeleting = signal<bool>(false);
  final Signal<bool> isUploading = signal<bool>(false);
  final Signal<String> selectedAvatarId = signal<String>('');
  final Signal<String?> pendingAvatarFilePath = signal<String?>(null);
  final Signal<String?> avatarPreviewPath = signal<String?>(null);
  final Signal<String> selectedThemeId = signal<String>('default');
  final Signal<String> selectedLanguage = signal<String>('fr');

  void setSelectedAvatarId(String avatarId) {
    selectedAvatarId.value = avatarId;
    clearPendingAvatarFile();
  }

  void syncSelectedAvatarIdFromProfile(String avatarId) {
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

  void setPendingAvatarFile(String path) {
    pendingAvatarFilePath.value = path;
    avatarPreviewPath.value = path;
    selectedAvatarId.value = '';
  }

  void clearPendingAvatarFile() {
    pendingAvatarFilePath.value = null;
    avatarPreviewPath.value = null;
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
        _authRepository.syncCurrentUser(
          UserModel(
            uid: profile.id,
            firebaseUid: profile.firebaseUid,
            email: profile.email,
            username: profile.username,
            avatarId: profile.avatarId,
            avatarUrl: profile.avatarUrl,
          ),
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

  Future<Either<ProfileFailure, ProfileModel>> uploadAvatar(
    String filePath,
  ) async {
    isUploading.value = true;
    final result = await _repository.uploadAvatar(filePath);
    result.match(
      (_) {
        isUploading.value = false;
      },
      (profile) {
        _authRepository.syncCurrentUser(
          UserModel(
            uid: profile.id,
            firebaseUid: profile.firebaseUid,
            email: profile.email,
            username: profile.username,
            avatarId: profile.avatarId,
            avatarUrl: profile.avatarUrl,
          ),
        );
        clearPendingAvatarFile();
        isUploading.value = false;
      },
    );
    return result;
  }
}

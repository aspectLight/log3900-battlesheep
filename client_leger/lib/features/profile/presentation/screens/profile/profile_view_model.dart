import 'package:fpdart/fpdart.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../../core/app_transition/app_transition_bus.dart';
import '../../../../authentication/core/app_events/auth_events.dart';
import '../../../core/exceptions/profile_failure.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../domain/commands/profile_commands.dart';
import '../../../domain/state/profile_state.dart';

class ProfileViewModel {
  ProfileViewModel({
    required ProfileRepository repository,
    required AppTransitionEventBus appTransitionEventBus,
  }) : _repository = repository,
       _appTransitionEventBus = appTransitionEventBus,
       state = computed(() => repository.state.value);

  final ProfileRepository _repository;
  final AppTransitionEventBus _appTransitionEventBus;

  final Computed<ProfileState> state;
  final Signal<bool> isSaving = signal<bool>(false);
  final Signal<bool> isDeleting = signal<bool>(false);
  final Signal<String> selectedAvatarId = signal<String>('');

  void setSelectedAvatarId(String avatarId) {
    selectedAvatarId.value = avatarId;
  }

  Future<void> load() => _repository.loadProfileAndStatistics();

  Future<Either<ProfileFailure, Unit>> submitUpdate(
    UpdateProfileCommand command,
  ) async {
    isSaving.value = true;
    final result = await _repository.updateProfile(command);
    isSaving.value = false;
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

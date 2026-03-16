import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../../core/app_transition/app_transition_bus.dart';
import '../../../../../../core/helpers/functional_programming.dart';
import '../../../../authentication/core/app_events/auth_events.dart';
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
  final Signal<String> selectedAvatarId = signal<String>('');

  void setSelectedAvatarId(String avatarId) {
    selectedAvatarId.value = avatarId;
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
      right: (_) {
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
}

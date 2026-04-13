import 'package:fpdart/fpdart.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../core/exceptions/profile_failure.dart';
import '../../domain/commands/profile_commands.dart';
import '../../domain/models/profile_model.dart';
import '../../domain/models/profile_statistics_model.dart';
import '../../domain/state/profile_state.dart';
import '../models/dto/profile_dto.dart';
import '../models/dto/profile_statistics_dto.dart';
import '../services/http_profile_service.dart';

class ProfileRepository {
  ProfileRepository({
    required HttpProfileService httpProfileService,
  })  : _httpProfileService = httpProfileService,
        state = signal<ProfileState>(const ProfileState.idle());

  final HttpProfileService _httpProfileService;

  final Signal<ProfileState> state;

  Future<void> loadProfileAndStatistics() async {
    state.value = const ProfileState.loading();
    final result = await TaskEither<ProfileFailure, (ProfileModel, ProfileStatisticsModel)>.tryCatch(
      () async {
        final ProfileDto profileDto = await _httpProfileService.fetchProfile();
        final ProfileStatisticsDto statsDto =
            await _httpProfileService.fetchProfileStatistics();
        final profile = ProfileModel(
          id: profileDto.id,
          username: profileDto.username,
          email: profileDto.email,
          avatarId: profileDto.avatarId,
        );
        final statistics = ProfileStatisticsModel(
          classicGamesPlayed: statsDto.classicGamesPlayed,
          ctfGamesPlayed: statsDto.ctfGamesPlayed,
          totalGamesWon: statsDto.totalGamesWon,
          averagePlaytimePerGame: statsDto.averagePlaytimePerGame,
        );
        return (profile, statistics);
      },
      (error, _) =>
          error is ProfileFailure ? error : const UnknownProfileFailure(),
    ).run();
    result.match(
      (failure) => state.value = ProfileState.error(failure),
      (tuple) => state.value = ProfileState.loaded(
        profile: tuple.$1,
        statistics: tuple.$2,
      ),
    );
  }

  Future<Either<ProfileFailure, ProfileModel>> updateProfile(
    UpdateProfileCommand command,
  ) {
    final task = TaskEither<ProfileFailure, ProfileModel>.tryCatch(
      () async {
        final s = state.value;
        if (s is! ProfileStateLoaded) {
          throw const UnknownProfileFailure('Profile not loaded');
        }
        final current = s.profile;
        final dto = ProfileUpdateRequestDto(
          username: command.username != current.username ? command.username : null,
          email: command.email != current.email ? command.email : null,
          avatarId:
              command.avatarId != current.avatarId ? command.avatarId : null,
        );
        final hasChange = dto.username != null ||
            dto.email != null ||
            dto.avatarId != null;
        if (!hasChange) {
          throw const NoChangesProfileFailure();
        }
        final ProfileDto updatedDto =
            await _httpProfileService.updateProfile(dto);
        final model = ProfileModel(
          id: updatedDto.id,
          username: updatedDto.username,
          email: updatedDto.email,
          avatarId: updatedDto.avatarId,
        );
        final loaded = state.value;
        if (loaded is ProfileStateLoaded) {
          state.value = ProfileState.loaded(
            profile: model,
            statistics: loaded.statistics,
          );
        }
        return model;
      },
      (error, _) =>
          error is ProfileFailure ? error : const UnknownProfileFailure(),
    );
    return task.run();
  }

  Future<Either<ProfileFailure, Unit>> deleteAccount() {
    final task = TaskEither<ProfileFailure, Unit>.tryCatch(
      () async {
        await _httpProfileService.deleteAccount();
        return unit;
      },
      (error, _) =>
          error is ProfileFailure ? error : const UnknownProfileFailure(),
    );
    return task.run();
  }
}

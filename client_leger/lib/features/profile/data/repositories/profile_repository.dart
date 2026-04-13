import 'package:fpdart/fpdart.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../core/helpers/functional_programming.dart';
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
        final Option<ProfileDto> profileDtoOption =
            await _httpProfileService.fetchProfile();
        final Option<ProfileStatisticsDto> statsDtoOption =
            await _httpProfileService.fetchProfileStatistics();
        final ProfileDto profileDto = requireOption(
          profileDtoOption,
          orElse: const UnknownProfileFailure(),
        );
        final ProfileStatisticsDto statsDto = requireOption(
          statsDtoOption,
          orElse: const UnknownProfileFailure(),
        );
        final profile = ProfileModel(
          id: profileDto.id,
          username: profileDto.username,
          email: profileDto.email,
          avatarId: profileDto.avatarId,
          theme: profileDto.theme,
          language: profileDto.language,
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
        final dto = ProfileUpdateRequestDto(
          username: command.username,
          email: command.email,
          avatarId: command.avatarId,
          theme: command.theme,
          language: command.language,
        );
        final Option<ProfileDto> updatedOption =
            await _httpProfileService.updateProfile(dto);
        final ProfileDto updatedDto = requireOption(
          updatedOption,
          orElse: const UnknownProfileFailure(),
        );
        final model = ProfileModel(
          id: updatedDto.id,
          username: updatedDto.username,
          email: updatedDto.email,
          avatarId: updatedDto.avatarId,
          theme: updatedDto.theme,
          language: updatedDto.language,
        );
        final s = state.value;
        if (s is ProfileStateLoaded) {
          state.value = ProfileState.loaded(
            profile: model,
            statistics: s.statistics,
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
        final deleted = await _httpProfileService.deleteAccount();
        if (!deleted) {
          throw const UnknownProfileFailure();
        }
        return unit;
      },
      (error, _) =>
          error is ProfileFailure ? error : const UnknownProfileFailure(),
    );
    return task.run();
  }
}


import 'package:fpdart/fpdart.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../core/chat/chat_outgoing_avatars.dart';
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
    required ChatOutgoingAvatars chatOutgoingAvatars,
  }) : _httpProfileService = httpProfileService,
       _chatOutgoingAvatars = chatOutgoingAvatars,
       state = signal<ProfileState>(const ProfileState.idle());

  final HttpProfileService _httpProfileService;
  final ChatOutgoingAvatars _chatOutgoingAvatars;

  final Signal<ProfileState> state;

  Future<void> loadProfileAndStatistics() async {
    state.value = const ProfileState.loading();
    final result =
        await TaskEither<
              ProfileFailure,
              (ProfileModel, ProfileStatisticsModel)
            >.tryCatch(
              () async {
                final ProfileDto profileDto = await _httpProfileService
                    .fetchProfile();
                final ProfileStatisticsDto statsDto = await _httpProfileService
                    .fetchProfileStatistics();
                final profile = ProfileModel(
                  id: profileDto.id,
                  firebaseUid: profileDto.firebaseUid,
                  username: profileDto.username,
                  email: profileDto.email,
                  avatarId: profileDto.avatarId,
                  avatarUrl: profileDto.avatarUrl,
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
              (error, _) => error is ProfileFailure
                  ? error
                  : const UnknownProfileFailure(),
            )
            .run();
    result.match(
      (failure) => state.value = ProfileState.error(failure),
      (tuple) {
        final profile = tuple.$1;
        _chatOutgoingAvatars.setFromAvatarFields(
          avatarId: profile.avatarId,
          avatarRelativeUrl: profile.avatarUrl,
        );
        state.value = ProfileState.loaded(
          profile: profile,
          statistics: tuple.$2,
        );
      },
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
          username: command.username != current.username
              ? command.username
              : null,
          email: command.email != current.email ? command.email : null,
          avatarId: command.avatarId != current.avatarId
              ? command.avatarId
              : null,
          theme: command.theme != null && command.theme != current.theme
              ? command.theme
              : null,
          language:
              command.language != null && command.language != current.language
              ? command.language
              : null,
          preferences: command.preferences,
        );
        final hasChange =
            dto.username != null ||
            dto.email != null ||
            dto.avatarId != null ||
            dto.theme != null ||
            dto.language != null ||
            dto.preferences != null;
        if (!hasChange) {
          throw const NoChangesProfileFailure();
        }
        final ProfileDto updatedDto = await _httpProfileService.updateProfile(
          dto,
        );
        final model = ProfileModel(
          id: updatedDto.id,
          firebaseUid: updatedDto.firebaseUid,
          username: updatedDto.username,
          email: updatedDto.email,
          avatarId: updatedDto.avatarId,
          avatarUrl: updatedDto.avatarUrl,
          theme: updatedDto.theme,
          language: updatedDto.language,
        );
        final loaded = state.value;
        if (loaded is ProfileStateLoaded) {
          state.value = ProfileState.loaded(
            profile: model,
            statistics: loaded.statistics,
          );
        }
        _chatOutgoingAvatars.setFromAvatarFields(
          avatarId: model.avatarId,
          avatarRelativeUrl: model.avatarUrl,
        );
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

  Future<Either<ProfileFailure, ProfileModel>> uploadAvatar(String filePath) {
    final task = TaskEither<ProfileFailure, ProfileModel>.tryCatch(
      () async {
        final dto = await _httpProfileService.uploadAvatar(filePath);
        final model = ProfileModel(
          id: dto.id,
          firebaseUid: dto.firebaseUid,
          username: dto.username,
          email: dto.email,
          avatarId: dto.avatarId,
          avatarUrl: dto.avatarUrl,
          theme: dto.theme,
          language: dto.language,
        );
        final loaded = state.value;
        if (loaded is ProfileStateLoaded) {
          state.value = ProfileState.loaded(
            profile: model,
            statistics: loaded.statistics,
          );
        }
        _chatOutgoingAvatars.setFromAvatarFields(
          avatarId: model.avatarId,
          avatarRelativeUrl: model.avatarUrl,
        );
        return model;
      },
      (error, _) =>
          error is ProfileFailure ? error : const UnknownProfileFailure(),
    );
    return task.run();
  }
}
